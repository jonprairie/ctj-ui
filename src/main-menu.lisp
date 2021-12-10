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
  (print "loading")
  (with-store obj (ui::load-game "test"))
  (render-screen obj))

(defun on-click-newgame (obj)
  (setf (connection-data-item obj :screen) :game-menu)
  (print "loading")
  (with-store obj (ui::new-game "test"))
  (render-screen obj))

(defun on-click-loadgame (obj))
(defun on-click-exit (obj))
