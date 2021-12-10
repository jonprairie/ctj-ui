(in-package #:ctj-ui)


(define-screen mail-inbox (mail-inbox)
  (:div :id mail-inbox))

(defun build-mail-inbox (body &optional invite-list)
  (unless invite-list (setf invite-list (with-store body (ui::get-human-invites))))
  (with-store body
    (with-onclick (back col-name col-prestige col-start-date col-expir-date) body
      (:p :id back "Back")
      (:table
       (:tr (:td :id col-name "Tournament Name")
	    (:td :id col-prestige "Prestige")
	    (:td :id col-start-date "Start Date")
	    (:td :id col-expir-date "Expiration Date"))
       (loop for inv in invite-list
	     collect (with-slots (bknr.datastore::id state::source state::deadline) inv
		       (with-slots (state::prestige state::start-date state::name) state::source
			 (:tr
			  :id (format nil "~a" bknr.datastore::id)
			  :data-obj-id bknr.datastore::id
			  (:td state::name)
			  (:td (format nil "~$" state::prestige))
			  (:td state::start-date)
			  (:td state::deadline)
			  (:td :id (format nil "accept-~a" bknr.datastore::id) "Accept")
			  (:td :id (format nil "reject-~a" bknr.datastore::id) "Reject")))))))
    (loop for inv in invite-list
	  do (let ((lex-inv inv))
	       (with-slots (bknr.datastore::id) lex-inv
		 (set-on-click (attach-as-child body (format nil "~a" bknr.datastore::id))
			       (lambda (obj) (format t "HELLO ~a~%" lex-inv)))
		 (set-on-click (attach-as-child body (format nil "accept-~a" bknr.datastore::id))
			       (make-inv-accept lex-inv))
		 (set-on-click (attach-as-child body (format nil "reject-~a" bknr.datastore::id))
			       (make-inv-reject lex-inv)))))))

(defun make-inv-accept (inv)
  (lambda (obj) (with-store obj (ui::accept-invite inv))))

(defun make-inv-reject (inv)
  (lambda (obj) (with-store obj (ui::reject-invite inv))))
