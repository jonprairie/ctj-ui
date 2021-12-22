(in-package #:ctj-ui)


(define-screen player-tournament-table (player-tournament-table)
  (:div :id player-tournament-table))

(defun build-player-tournament-table (body &optional tournament-list)
  (unless tournament-list (setf tournament-list (with-store body (state-query::get-future-participant-tournaments (state-query::get-human-player)))))
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
			    (:td (state-query::start-date tr)))))))
    (loop for tr in tournament-list
	  do (let ((lex-tr tr))
	       (with-slots (bknr.datastore::id) tr
		 (set-on-click (attach-as-child body (format nil "~a" bknr.datastore::id))
			       (lambda (obj) (format t "HELLO ~a~%" lex-tr))))))))
