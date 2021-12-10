(in-package #:ctj-ui)


(define-screen player-table (player-table)
  (:div :id player-table))

(defun build-player-table (body &optional player-list)
  (unless player-list (setf player-list (with-store body (state-query::get-all-players))))
  (with-store body
    (with-onclick (back col-name col-sex col-rating col-country) body
      (:p :id back "Back")
      (:table
       (:tr (:td "")
	    (:td :id col-name "Name")
	    (:td "")
	    (:td :id col-sex "Sex")
	    (:td :id col-rating "Rating")
	    (:td :id col-country "Country"))
       (loop for pl in player-list
	     collect (with-slots (bknr.datastore::id) pl
		       (:tr
			:id (format nil "~a" bknr.datastore::id)
			:data-obj-id bknr.datastore::id
			(:td (state-query::title pl))
			(:td (state-query::last-name pl))
			(:td (state-query::first-name pl))
			(:td (state-query::sex pl))
			(:td (format nil "~$" (state-query::rating pl)))
			(:td (state-query::country pl)))))))
    (loop for pl in player-list
	  do (let ((lex-pl pl))
	       (set-on-click (attach-as-child body (format nil "~a" (with-slots (bknr.datastore::id) lex-pl bknr.datastore::id)))
			     (lambda (obj) (format t "HELLO ~a~%" lex-pl)))))))

(defun on-click-col-rating (obj)
  (let ((player-table (attach-as-child obj "PLAYER-TABLE")))
    (build-player-table player-table
			(sort (state-query::get-all-players) #'> :key #'state-query::rating))))
