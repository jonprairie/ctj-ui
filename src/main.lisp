(in-package #:ctj-ui)


(defparameter *screens* (make-hash-table))
(defparameter *body* nil)

(defmacro attach-onclick (obj id)
  (with-gensyms (html-obj)
    `(let ((,html-obj (attach-as-child ,obj ,id)))
       (set-on-click ,html-obj
		     (quote ,(symbolicate (string-upcase "on-click-") (string-upcase id)))))))

(defmacro with-onclick (onclick-ids obj &body html)
  `(progn
     (let (,@(loop for id in onclick-ids collect `(,id ,(string id))))
       (setf (inner-html ,obj) (with-html-string ,@html))
       ,@(loop for id in onclick-ids collect `(attach-onclick ,obj ,id)))))

;; do i have to save the store back to the connection after ,@body?
;; i don't _think_ so, since it should just be a pointer to the same object, not a copy.
(defmacro with-store (obj &body body)
  `(let ((bknr.datastore::*store* (connection-data-item ,obj "store")))
     (if (null (connection-data-item ,obj "store-lock"))
	 (progn
	   (setf (connection-data-item ,obj "store-lock") t)
	   (prog1
	       (unwind-protect
		    (progn
		      ,@body)
		 (setf (connection-data-item ,obj "store-lock") nil))
	     ;; (setf (connection-data-item ,obj :store) bknr.datastore::*store*)
	     (setf (connection-data-item ,obj "store-lock") nil)))
	 (error "concurrent access to store"))))

(defmacro define-screen (screen-name widgets &body body)
  (let ((render-name (symbolicate 'RENDER- screen-name)))
    `(progn
       (defun ,render-name (obj)
	 (let ,(loop for widget in widgets collect `(,widget ,(string widget)))
	   (setf (inner-html obj) (with-html-string ,@body)))
	 ,@(loop for widget in widgets
		 collect
		 (let* ((build-name (symbolicate 'BUILD- widget)))
		   `(,build-name (attach-as-child obj ,(string widget))))))
       (setf (gethash ,(make-keyword screen-name) *screens*) (quote ,render-name)))))

(defun run-ctj ()
  (initialize
   #'on-new-window
   :static-root (merge-pathnames "C:/Users/jonnyp/quicklisp/local-projects/ctj-ui/assets/"))
  (open-browser))

(defclass-std:defclass/std settings () 
  ((first-name last-name rating in-game-rating difficulty time-control)))

(defparameter *settings* nil)

(defun on-new-window (body)
  (setf *body* body)
  (setf (connection-data-item body :body) body)
  (setf (connection-data-item body :screen) :main-menu)
  (setf *settings* (list :first-name "Perry"
			 :last-name "Lark"
			 :rating 1900
			 :in-game-rating 2550))
  (render-screen body)
  (run body))

(eval-when (:compile-toplevel)
  (defun remove-dbl-quotes (s)
    (str:replace-all "\"" "" s))

  (defparameter *js-events* (make-hash-table)))

(defmacro define-event (name props)
  `(setf (gethash (quote ,(symbolicate name)) *js-events*)
	 (cons (format nil "+ JSON.stringify(~a)"
		       (remove-dbl-quotes
			(jonathan:to-json
			 (loop for prop in (quote ,props)
			       collect
			       (let ((sym (symbolicate (cl-change-case:camel-case (string prop)))))
				 (cons sym
				       (format nil "e.~a" sym))))
			 :from :alist)))
	       (lambda (data)
		 (jonathan:parse data)))))

(defmacro define-handler (name id &body body)
  (let ((attach-name (symbolicate "ATTACH-" (if id (str:concat (str:upcase id) "-") "") (str:upcase name)))
	(handle-name (symbolicate "HANDLE-" (if id (str:concat (str:upcase id) "-") "") (str:upcase name))))
    (with-gensyms (event-data ele d)
      `(progn
	 (defun ,handle-name ,(if id `(obj data) `(data))
	   (progn ,@body))
	 (defun ,attach-name ()
	   (let ((,event-data (gethash (quote ,(symbolicate name)) *js-events*))
		 (,ele ,(if id
			    `(attach-as-child *body* ,id)
			    `(window *body*))))
	     (clog::set-event
	      ,ele ,name
	      (lambda (,d)
		,(if id
		     `(,handle-name ,ele (funcall (cdr ,event-data) ,d))
		     `(,handle-name (funcall (cdr ,event-data) ,d))))
	      :call-back-script (car ,event-data))))))))

(defparameter *store-link* nil)

(defun clean-up-window (data)
  (when (and *store-link* (bknr.datastore::store-transaction-log-stream *store-link*))
    (bknr.datastore::close-transaction-log-stream *store-link*)))

(defun render-screen (obj)
  (let* ((body (connection-data-item obj :body))
	 (screen-name (connection-data-item obj :screen))
	 (render (gethash screen-name *screens*)))
    (js-execute obj "$(window).off();")
    (set-on-before-unload (window *body*) #'clean-up-window)
    (funcall render body)))

(defun on-click-back (obj)
  (setf (connection-data-item obj :screen) :game-menu)
  (render-screen obj))

(defun undefined? (clog-el)
  (string-equal (html-id clog-el) "undefined"))

(defun translate-element (clog-el x y)
  (setf (attribute clog-el "style") (format nil "transform: translate(~apx,~apx);" x y)))

(defun hide-element (clog-el)
  (setf (display clog-el) "none"))

(defun show-element (clog-el)
  (setf (display clog-el) ""))

