(in-package #:ctj-ui)


(define-screen main-menu (main-menu)
  (:div :id main-menu))

(defun build-main-menu (menu)
  (with-onclick (continue newgame loadgame exit) menu
    (:ul (:li (:a :id continue "Continue"))
	 (:li (:a :id newgame "New Game"))
	 (:li (:a :id loadgame "Load Game"))
	 (:li (:a :id exit "Exit")))))

(defun on-click-continue (obj)
  (setf (connection-data-item obj :screen) :game-menu)
  (with-store obj
    (when (and bknr.datastore::*store*
	       (bknr.datastore::store-transaction-log-stream bknr.datastore::*store*))
      (bknr.datastore::close-transaction-log-stream bknr.datastore::*store*))
    (ui::new-game "test" *settings* 6)
    (setf (connection-data-item obj "store") bknr.datastore::*store*))
  (setf (connection-data-item obj "store") nil)
  (print "loading")
  (with-store obj
    (ui::load-game "test")
    (setf (connection-data-item obj "store") bknr.datastore::*store*)
    (setf *store-link* bknr.datastore::*store*))
  (render-screen obj))

(defun on-click-newgame (obj)
  (setf (connection-data-item obj :screen) :game-menu)
  (print "new game")
  (with-store obj
    (when (and bknr.datastore::*store*
	       (bknr.datastore::store-transaction-log-stream bknr.datastore::*store*))
      (bknr.datastore::close-transaction-log-stream bknr.datastore::*store*))
    (ui::new-game "test" *settings* 6)
    (setf (connection-data-item obj "store") bknr.datastore::*store*)
    (setf *store-link* bknr.datastore::*store*))
  (render-screen obj))

(defun on-click-loadgame (obj))
(defun on-click-exit (obj))
