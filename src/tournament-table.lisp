(in-package #:ctj-ui)


(define-screen tournament-table (tournament-table)
  (:div :id tournament-table))

(defun build-tournament-table (body &optional tournament-list)
  (unless tournament-list (setf tournament-list (with-store body (state-query::get-all-tournaments))))
  (setf tournament-list (sort tournament-list #'< :key #'state-query::start-date))
  (with-store body
    (with-onclick (back col-name col-start-date) body
      (:p :id back "Back")
      (:table
       (:tr (:td :id col-name "Name")
	    (:td :id col-start-date "Start Date"))
       (loop for tr in tournament-list
	     collect (with-slots (bknr.datastore::id) tr
		       (:tr :id bknr.datastore::id
			    (:td (state-query::name tr))
			    (:td (state-query::start-date tr))
			    (:td :id (format nil "apply-~a" bknr.datastore::id) "Apply"))))))
    (loop for tr in tournament-list
	  do (let ((lex-tr tr))
	       (with-slots (bknr.datastore::id) tr
		 (set-on-click (attach-as-child body (format nil "~a" bknr.datastore::id))
			       (lambda (obj) (format t "HELLO ~a~%" lex-tr)))

		 (set-on-click (attach-as-child body (format nil "apply-~a" bknr.datastore::id))
			       (make-tournament-applier lex-tr)))
	       ))))

(defun make-tournament-applier (tr)
  (lambda (obj) (with-store obj (ui::apply-to-tournament tr))))
