(in-package #:ctj-ui)


(define-screen game-menu (game-menu)
  (:div :id game-menu))

(defun build-game-menu (menu)
  (with-onclick (simday mailinbox playerlist tournamentlist chessgame quit) menu
    (:ul (:li (:a :id simday "Simulate Day"))
	 (:li (:a :id mailinbox "Mail Inbox"))
	 (:li (:a :id playerlist "Player List"))
	 (:li (:a :id tournamentlist "Tournament List"))
	 (:li (:a :id chessgame "Chess Game"))
	 (:li (:a :id quit "Quit")))))

(defun on-click-simday (obj)
  (with-store obj (ui::sim-day)))

(defun on-click-mailinbox (obj)
  (setf (connection-data-item obj :screen) :mail-inbox)
  (render-screen obj))

(defun on-click-playerlist (obj)
  (setf (connection-data-item obj :screen) :player-table)
  (render-screen obj))

(defun on-click-tournamentlist (obj)
  (setf (connection-data-item obj :screen) :tournament-table)
  (render-screen obj))

(defun on-click-chessgame (obj)
  (setf (connection-data-item obj :screen) :chess-game)
  (render-screen obj))

(defun on-click-quit (obj)
  (setf (connection-data-item obj :store-lock) nil)
  (setf (connection-data-item obj :screen) :main-menu)
  (render-screen obj))
