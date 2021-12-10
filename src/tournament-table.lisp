(in-package #:ctj-ui)


(define-screen tournament-table (tournament-table)
  (:div :id tournament-table))

(defun build-tournament-table (body &optional tournament-list)
  (unless tournament-list (setf tournament-list (with-store body (state-query::get-all-tournaments))))
  (with-store body
    (with-onclick (back col-name col-start-date) body
      (:p :id back "Back")
      (:table
       (:tr (:td :id col-name "Name")
	    (:td :id col-start-date "Start Date"))
       (loop for tr in tournament-list
	     collect (:tr (:td (state-query::name tr))
			  (:td (state-query::start-date tr))))))))
