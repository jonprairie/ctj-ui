(in-package #:ctj-ui)


(define-screen game-menu (game-menu)
  (:div :id game-menu))

(defun build-game-menu (menu)
  (with-onclick (simday sim10days mailinbox playerlist tournamentlist upcomingtournaments chessgame quit) menu
    (:ul (:li (:a :id simday "Simulate Day"))
	 (:li (:a :id sim10days "Simulate 10 Days"))
	 (:li (:a :id mailinbox "Mail Inbox"))
	 (:li (:a :id playerlist "Player List"))
	 (:li (:a :id tournamentlist "Tournament List"))
	 (:li (:a :id upcomingtournaments "Upcoming Tournaments"))
	 (:li (:a :id chessgame "Chess Game"))
	 (:li (:a :id quit "Quit")))))

(define-condition new-human-invite-error (error) ())

(defun on-click-simday (obj)
  (handler-case
      (progn (sim-day obj) t)
    (new-human-invite-error () (progn (js-execute obj "alert('new invites are available!") nil))
    (state-intfc::sim-human-game-error (e)
      (progn
	(setf (connection-data-item obj "current-chess-game") (state-intfc::human-game e))
	(setf (connection-data-item obj :screen) :chess-game)
	(render-screen obj)
	nil))))

(defun on-click-sim10days (obj)
  (loop for i from 1 to 10 do (unless (on-click-simday obj) (return))))

(defun on-click-mailinbox (obj)
  (setf (connection-data-item obj :screen) :mail-inbox)
  (render-screen obj))

(defun on-click-playerlist (obj)
  (setf (connection-data-item obj :screen) :player-table)
  (render-screen obj))

(defun on-click-tournamentlist (obj)
  (setf (connection-data-item obj :screen) :tournament-table)
  (render-screen obj))

(defun on-click-upcomingtournaments (obj)
  (setf (connection-data-item obj :screen) :player-tournament-table)
  (render-screen obj))

(defun on-click-chessgame (obj)
  (setf (connection-data-item obj :screen) :chess-game)
  (render-screen obj))

(defun on-click-quit (obj)
  (setf (connection-data-item obj :store-lock) nil)
  (setf (connection-data-item obj :screen) :main-menu)
  (render-screen obj))

(defparameter *prev-human-invites* nil)
(defun sim-day (obj)
  (with-store obj
    (let ((invites (ui::get-human-invites)))
      (if (equal invites *prev-human-invites*)
	  (ui::sim-day)
	  (progn
	    (setf *prev-human-invites* invites)
	    (error 'new-human-invite-error))))))
