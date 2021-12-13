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

(defun on-new-window (body)
  (setf *body* body)
  (setf (connection-data-item body :body) body)
  (setf (connection-data-item body :screen) :main-menu)
  (render-screen body)
  (run body))

(defun render-screen (obj)
  (let* ((body (connection-data-item obj :body))
	 (screen-name (connection-data-item obj :screen))
	 (render (gethash screen-name *screens*)))
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

