(in-package #:ctj-ui)


(define-screen chess-game (chess-game)
  (:div :id chess-game))

(defun build-chess-game (body)
  (with-onclick (back whiteresign blackresign) body
    (:link :rel "stylesheet" :href "css/chess-game.css")
    (:script :src "https://code.jquery.com/ui/1.13.0/jquery-ui.js")
    (:style "body {overflow:scroll;}")
    (:style ".invisible {display:none;}")
    (:style "#dragging-piece {position:absolute; z-index:6;}")
    (:style ".flip {transform:rotate(180deg);}")
    (:style ".pointer-invisible {pointer-events:none;}")
    (:style "#board-cont {background-color: gray;}")
    (:style ".flex-r {display: flex; flex-flow: row wrap; justify-content:center;}")
    (:style ".square {height:80px; width:80px; flex:12.5%;}")
    (:style ".light {background-color: BlanchedAlmond;}")
    (:style ".dark {background-color: BurlyWood;}")
    (:style ".ghost {opacity: 35%;}")
    (:style ".piece {height:80px; width:80px; z-index: 5; position: absolute; background-repeat:no-repeat; background-size:cover;}")
    (:p :id back "Back")
    (:p :id "flip" "Flip")
    (:h1 :id "event")
    (:div :id "whiteclock") (:br)
    (:div :id "blackclock")
    (:div :class "white-perspective"
	  (:div :id "dragging-piece" :class "invisible piece"))
    (:div :class "flex-r"
	  (:div :id "board-cont" :class "white-perspective"
		(:div :id "pieces")
		(:div :id blackresign :class "rotate-with-board")
		(:div :id "black-player" :class "rotate-with-board")
		(:div :id "board" :class "flex-r"
		      (:div :id "a8" :class "square light")
		      (:div :id "b8" :class "square dark" )
		      (:div :id "c8" :class "square light")
		      (:div :id "d8" :class "square dark" )
		      (:div :id "e8" :class "square light")
		      (:div :id "f8" :class "square dark" )
		      (:div :id "g8" :class "square light")
		      (:div :id "h8" :class "square dark" )
		      (:div :id "a7" :class "square dark" )
		      (:div :id "b7" :class "square light")
		      (:div :id "c7" :class "square dark" )
		      (:div :id "d7" :class "square light")
		      (:div :id "e7" :class "square dark" )
		      (:div :id "f7" :class "square light")
		      (:div :id "g7" :class "square dark" )
		      (:div :id "h7" :class "square light")
		      (:div :id "a6" :class "square light")
		      (:div :id "b6" :class "square dark" )
		      (:div :id "c6" :class "square light")
		      (:div :id "d6" :class "square dark" )
		      (:div :id "e6" :class "square light")
		      (:div :id "f6" :class "square dark" )
		      (:div :id "g6" :class "square light")
		      (:div :id "h6" :class "square dark" )
		      (:div :id "a5" :class "square dark" )
		      (:div :id "b5" :class "square light")
		      (:div :id "c5" :class "square dark" )
		      (:div :id "d5" :class "square light")
		      (:div :id "e5" :class "square dark" )
		      (:div :id "f5" :class "square light")
		      (:div :id "g5" :class "square dark" )
		      (:div :id "h5" :class "square light")
		      (:div :id "a4" :class "square light")
		      (:div :id "b4" :class "square dark" )
		      (:div :id "c4" :class "square light")
		      (:div :id "d4" :class "square dark" )
		      (:div :id "e4" :class "square light")
		      (:div :id "f4" :class "square dark" )
		      (:div :id "g4" :class "square light")
		      (:div :id "h4" :class "square dark" )
		      (:div :id "a3" :class "square dark" )
		      (:div :id "b3" :class "square light")
		      (:div :id "c3" :class "square dark" )
		      (:div :id "d3" :class "square light")
		      (:div :id "e3" :class "square dark" )
		      (:div :id "f3" :class "square light")
		      (:div :id "g3" :class "square dark" )
		      (:div :id "h3" :class "square light")
		      (:div :id "a2" :class "square light")
		      (:div :id "b2" :class "square dark" )
		      (:div :id "c2" :class "square light")
		      (:div :id "d2" :class "square dark" )
		      (:div :id "e2" :class "square light")
		      (:div :id "f2" :class "square dark" )
		      (:div :id "g2" :class "square light")
		      (:div :id "h2" :class "square dark" )
		      (:div :id "a1" :class "square dark" )
		      (:div :id "b1" :class "square light")
		      (:div :id "c1" :class "square dark" )
		      (:div :id "d1" :class "square light")
		      (:div :id "e1" :class "square dark" )
		      (:div :id "f1" :class "square light")
		      (:div :id "g1" :class "square dark" )
		      (:div :id "h1" :class "square light"))
		(:div :id "white-player" :class "rotate-with-board")
		(:div :id whiteresign :class "rotate-with-board"))
	  (:move-pane))
    (:div :id "end-of-game-footer"))
  (on-initialize-chess-game body))

(defparameter chess-game nil)

(defun on-initialize-chess-game (obj)
  (setf game-over nil
	chess-game (make-instance 'queen:game-details))
  (let ((board (attach-as-child obj "board")))
    (setf white-clock 900000)
    (setf black-clock 900000)
    (setf inc 15000)
    (setf last-move-timestamp nil)
    (setup-pieces-from-game board)
    (load-script (html-document *body*) "js/chess-game.js")
    (load-script (html-document *body*) "js/move-pane.js")
    (clog::set-event
     board "attemptmove"
     (lambda (data)
       (attempt-human-move board (parse-attempt-move-event data)))
     :call-back-script attempt-move-event-script)
    (with-store obj
      ;; (setf (connection-data-item obj "current-chess-game")
      ;; 	    (make-instance 'state-query::chess-game
      ;; 			   :white (state-query::get-human-player)
      ;; 			   :black (nth 100 (state-query::get-all-players))
      ;; 			   :event (first (state-query::get-all-tournaments))))
      (let* ((g (connection-data-item obj "current-chess-game"))
	     (settings (state::get-settings))
	     (player-rating (state-query::rating settings))
	     (player-in-game-rating (state::in-game-rating settings))
	     (rating-diff (- player-in-game-rating player-rating))
	     (event1 (state-query::event g))
	     (final-event (etypecase event1 (state::tournament event1) (state::team-match (state-query::event event1)))))
	(setf (queen:headers chess-game) (list (cons "White" (state-query::player-name (state-query::black g)))
					       (cons "Black" (state-query::player-name (state-query::white g)))
					       (cons "Event" (state-query::name final-event))))
	(setup-players g rating-diff)
	(sleep .15)
	(trigger-ev board (print (build-js-initgame-event g)))))
    (when white-engine 
      (get-engine-move white-engine))
    (attach-board-attemptresign)
    (attach-gameover)
    (attach-board-attemptloseontime)
    ))

(defun on-click-whiteresign (obj)
  (trigger-event obj "attemptresign"
		 :data (list :player-color "white")
		 :html-id "board"))
(defun on-click-blackresign (obj)
  (trigger-event obj "attemptresign"
		 :data (list :player-color "black")
		 :html-id "board"))

(defparameter stop-engine nil)
(defparameter white-engine nil)
(defparameter black-engine nil)
(defparameter white-clock 900000)
(defparameter black-clock 900000)
(defparameter inc 15000)
(defparameter unix-epoch-ms (* 1000 (encode-universal-time 0 0 0 1 1 1970 0)))
(defparameter last-move-timestamp nil)

;; (defparameter engine-path 
;;   "C:/Users/jonnyp/Downloads/stockfish_14.1_win_x64_avx2/stockfish_14.1_win_x64_avx2/stockfish.exe")
(defparameter engine-path
  "C:/Users/jonnyp/quicklisp/local-projects/ctj-ui/assets/engines/Rodent_IV/rodent-iv-x64.exe")

(defun setup-players (g rating-diff)
  (when-let* ((white (state-query::white g))
	      (black (state-query::black g))
	      (white-rating (state-query::rating white))
	      (black-rating (state-query::rating black)))
    (clean-engines)
    (if (equal (state-query::player-type white) :cpu)
	(setf white-engine (get-new-engine engine-path (state-query::personality white) (- white-rating rating-diff)))
	(setf white-engine nil))
    (if (equal (state-query::player-type black) :cpu)
	(setf black-engine (get-new-engine engine-path (state-query::personality black) (- black-rating rating-diff)))
	(setf black-engine nil))))

(defun clean-engines ()
  (when white-engine
    (clean-engine white-engine))
  (when black-engine
    (clean-engine black-engine)))

(defun clean-engine (engine)
  (handler-case
      (when engine (cl-uci:stop-engine-server engine))
    (error () (uiop:terminate-process (cl-uci::server-process engine) :urgent t))))

(defun setup-pieces-from-game (obj)
  (let* ((board (attach-as-child obj "board"))
	 (pieces (attach-as-child obj "pieces")))
    (setf (inner-html pieces) "")
    (loop for sq in (get-all-squares board) do (setf (inner-html sq) ""))
    (setf (inner-html pieces)
	  (with-html-string
	    (flatten
	     (list
	      (queen:board-foreach
	       (queen:game-board (queen:game chess-game))
	       (lambda (p r c i)
		 (let* ((square-key (queen:index-field i))
			(color (if (queen:is-white? p) "white" "black"))
			(piece-char (queen:piece-char p))
			(color-char (if (queen:is-white? p) #\l #\d))
			(bg-file (format nil "Chess_~a~at45~@[~a~].svg" piece-char color-char nil))
			(classes (format nil "piece ~a ~a" color piece-char)))
		   (:div :id (gensym "piece") :class classes :data-square square-key :data-color color))))))))
    (reset-all-pieces board)
    ))

(defun get-engine-move (engine)
  (bordeaux-threads:make-thread
   (lambda ()
     (sleep .5)
     (make-engine-move engine (queen:game chess-game)))))

(defparameter game-over nil)

(defun attempt-cpu-move (from-square to-square promote)
  (when (not game-over)
    (format t "attempting cpu move: ~a ~a ~a" from-square to-square promote)
    (let ((piece-id (html-id (first-child (attach-as-child *body* from-square)))))
      (attempt-move (attach-as-child *body* "board")
		    piece-id
		    from-square
		    to-square
		    promote))))

(defun attempt-human-move (board attempt-move-ev)
  (when (not game-over)
    (let* ((piece-id (getf attempt-move-ev :piece-id))
	   (from-square (getf attempt-move-ev :from-square))
	   (to-square (getf attempt-move-ev :to-square))
	   (promote (getf attempt-move-ev :promote)))
      (attempt-move board piece-id from-square to-square promote))))

(defun attempt-move (board piece-id from-square to-square promote-piece)
  (let ((san (format nil "~a~a~@[~a~]" from-square to-square promote-piece))
	(game (queen:game chess-game)))
    (if-let ((move (first (queen:game-parse-san game san))))
      (progn
	(assert (and from-square to-square))
	(let* ((san (queen:game-san game move))
	       (srn (queen:move-smith move))
	       (full-move (queen:game-fullmove game))
	       (_ (queen:play-move chess-game move))
	       (white-to-move? (queen:move-white? move))
	       (capture? (queen:move-capture? move))
	       (capture-square (when capture? (queen:index-field (queen:move-captured-index move))))
	       (castle-k? (queen:move-oo? move))
	       (castle-q? (queen:move-ooo? move))
	       (promote? (queen:move-promote? move))
	       (final-promote-piece (when white-to-move? (str:upcase promote-piece) (str:downcase promote-piece)))
	       (checkmate? (checkmate? game))
	       (draw? (draw? chess-game))
	       (game-over? (or checkmate? draw?))
	       (now (* 1000 (get-universal-time)))
	       (move-time (if last-move-timestamp (- now last-move-timestamp) 0)))
	  (if white-to-move?
	      (progn
		(decf white-clock move-time)
		(when (<= white-clock 0)
		  (trigger-event board "attemptloseontime" :data (list :player-color "white")))
		(incf white-clock inc))
	      (progn
		(decf black-clock move-time)
		(when (<= black-clock 0)
		  (trigger-event board "attemptloseontime" :data (list :player-color "black")))
		(incf black-clock inc)))
	  (setf last-move-timestamp now)
	  (trigger-event board "makemove"
			 :data (list :piece-id piece-id
				     :from-square from-square
				     :to-square to-square
				     :san san
				     :srn srn
				     :full-move full-move
				     :is-white-to-move white-to-move?
				     :is-capture capture?
				     :capture-square capture-square
				     :is-castle-k castle-k?
				     :is-castle-q castle-q?
				     :is-promote promote?
				     :promote-piece final-promote-piece
				     :is-checkmate checkmate?
				     :is-draw draw?
				     :is-game-over game-over?
				     :time-at-move (- now unix-epoch-ms)
				     :white-clock white-clock
				     :black-clock black-clock))
	  (when game-over?
	    (trigger-event board "gameover"
			   :data (list :resolution (cond (checkmate? "checkmate")
							 (draw? "draw"))
				       :game-result (if draw?
							"draw"
							(format nil "~:[black~;white~]win" white-to-move?)))))
	  (when (and (not game-over?)
		     (not stop-engine))
	    (if white-to-move?
		(when black-engine
		  (get-engine-move black-engine))
		(when white-engine
		  (get-engine-move white-engine))))
	  t))
      (progn
	(if (queen:game-parse-san game (str:concat san "Q"))
	    (trigger-event board "attemptpromote"
			   :data (list :piece-id piece-id :from-square from-square :to-square to-square))
	    (trigger-event board "invalidmove"
			   :data (list :piece-id piece-id :from-square from-square :to-square to-square)))
	nil))))

(defun white-to-move? (g)
  (let ((m (first (queen:game-compute-moves g))))
    (when m
      (queen:move-white? m))))
(defun black-to-move? (g)
  (let ((m (first (queen:game-compute-moves g))))
    (when m
      (not (queen:move-white? m)))))
(defun white-human? () (not white-engine))
(defun black-human? () (not black-engine))

(defun checkmate? (g)
  (and (queen:attacked? g)
       (not (queen:game-compute-moves g))))

(defun draw? (gd)
  (or (queen:draw-by-material? (queen:game gd))
      (queen:threefold-rep gd)
      (>= (queen:game-halfmove (queen:game gd)) 100) ;; 50 move rule
      (not (or (queen:attacked? (queen:game gd))     ;; stalemate
	       (queen:game-compute-moves (queen:game gd))))))

(defun sufficient-material? (game color)
  (let ((has-knight)
	(has-bishop)
	(bishop-type))
    (queen:board-foreach
     (queen:game-board game)
     (lambda (p r c i)
       (when (not (queen:is-king? p))
	 (when (or (and (queen:is-white? p)
			(string= color "white"))
		   (and (queen:is-black? p)
			(string= color "black")))
	   (cond
	     ((queen:is-queen? p) (return-from sufficient-material? t))
	     ((queen:is-rook? p) (return-from sufficient-material? t))
	     ((queen:is-pawn? p) (return-from sufficient-material? t))
	     ((queen:is-knight? p)
	      (setf has-knight t)
	      (when has-bishop
		(return-from sufficient-material? t)))
	     ((queen:is-bishop? p)
	      (when has-knight
		(return-from sufficient-material? t))
	      (if bishop-type
		  (when (/= bishop-type (logand (+ r c) 1))
		    (return-from sufficient-material? t))
		  (setf bishop-type (logand (+ r c) 1)))
	      (setf has-bishop t)))))))))

(defun put-piece-on-square (board piece square)
  (setf (attribute piece "data-square") square)
  (reset-piece board piece))

(defun get-all-pieces (board)
  ;; need to make pieces location consistent, in pieces div or individual squares?
  (let ((pieces (attach-as-child board "pieces")))
    (loop with p = (first-child pieces) until (undefined? p)
	  collect (prog1 p (setf p (next-sibling p))))))

(defun get-all-squares (board)
  (loop with s = (first-child board) until (undefined? s)
	collect (prog1 s (setf s (next-sibling s)))))

(defun reset-all-pieces (board)
  (let ((pieces-cont (attach-as-child board "pieces"))
	(pieces (get-all-pieces board)))
    (hide-element pieces-cont)
    (loop for piece in pieces
	  do (reset-piece board piece))
    (show-element pieces-cont)))

(defun get-piece-on-square (board square-key)
  (first-child (attach-as-child board square-key)))

(defun reset-piece (board piece)
  (let* ((sq-key (attribute piece "data-square"))
	 (sq (attach-as-child board sq-key)))
    (place-inside-top-of sq piece)))

(defun get-new-engine (engine-path personality rating)
  (let* ((engine (cl-uci::start-engine-server
		  (make-instance 'cl-uci::engine-config
				 :name "stockfish"
				 :path engine-path
				 :options `(("Personality" ,personality)
					    ("UCI_LimitStrength" t)
					    ("UCI_Elo" ,(format nil "~a" (floor rating)))
					    ("UseBook" "false"))))))
    (cl-uci:initialize-engine engine)
    engine))

(defun make-engine-move (engine game)
  (let* ((pos (queen:game-fen game))
	 (cl-uci-move (cl-uci::%get-engine-move-pos pos engine white-clock black-clock inc inc))
	 (from-square (cl-uci::from-square cl-uci-move))
	 (to-square (cl-uci::to-square cl-uci-move))
	 (promotion (cl-uci::promotionp cl-uci-move))
	 (promotion-piece (string-upcase (cl-uci::promotion-piece cl-uci-move))))
    (attempt-cpu-move from-square to-square (when promotion promotion-piece))))

(defun escape-string-for-eval (s)
  (serapeum:~> s
	       (str:replace-all "`" "\\`" _)
	       ))

(defun trigger-event (clog-obj event-type &key data html-id)
  (js-execute
   clog-obj
   (print
    (format nil "$('#~a').trigger({type: '~a', ~{~a: ~a~^, ~}});"
	    (or html-id (html-id clog-obj))
	    (cl-change-case:camel-case (string event-type))
	    (mapcar (lambda (x)
		      (typecase x
			(string (str:concat "'" (escape-string-for-eval x) "'"))
			(symbol (cond
				  ((equal x t) "true")
				  ((equal x nil) "false")
				  (t (str:concat (cl-change-case:camel-case (string x))))))
			(t x)))
		    data)))))

(defun trigger-ev (clog-obj json &optional html-id)
  (js-execute
   clog-obj
   (print (format nil "$('#~a').trigger(JSON.parse(`~a`));"
		  (or html-id (html-id clog-obj))
		  json))))

(defun build-js-player-obj (pl)
  (list :|name| (escape-string-for-eval (state-query::player-name pl))
	:|rating| (state-query::rating pl)
	:|score| (serapeum:mvlet ((score num (state-query::get-player-tournament-score
					      (state-query::event (connection-data-item *body* "current-chess-game"))
					      pl)))
		   (format nil "~a/~a" score num))
	:|type| (state-query::player-type pl)))

(defun build-js-initgame-event (game)
  (jonathan:to-json
   (list :|type| "initgame"
	 :|event| (escape-string-for-eval
		   (etypecase (state-query::event game)
		     (state-query::tournament (state-query::name (state-query::event game)))
		     (state-query::team-match
		      (let ((tm (state-query::event game)))
			(format nil "~a: ~a vs ~a"
				(state-query::name (state-query::event tm))
				(state-query::name (state-query::white tm))
				(state-query::name (state-query::black tm)))))))
	 :|white| (build-js-player-obj (state-query::white game))
	 :|black| (build-js-player-obj (state-query::black game))
	 :|wtime| white-clock
	 :|btime| black-clock)))

(defparameter attempt-move-event-script
  "+ e.pieceId + ':' + e.fromSquare + ':' + e.toSquare + ':' + e.promote")

(defun parse-attempt-move-event (data)
  (let ((f (ppcre:split ":" data)))
    (list
     :event-type :attempt-move
     :piece-id (nth 0 f)
     :from-square (nth 1 f)
     :to-square (nth 2 f)
     :promote (nth 3 f))))

(define-event "attemptresign" (:player-color))
(define-handler "attemptresign" "board"
  (let ((player-color (getf data :|playerColor|))
	(winner))
    (cond
      ((and (string= player-color "white")
	    (white-human?))
       (setf winner "black"))
      ((and (string= player-color "black")
	    (black-human?))
       (setf winner "white")))
    (when winner
      (trigger-event obj "gameover"
		     :data (list :resolution "resigns"
				 :game-result (format nil "~awin" winner))))))

(define-event "gameover" (:game-result :resolution))
(define-handler "gameover" nil
  (let* ((res (getf data :|gameResult|))
	 (white-win? (string= res "whitewin"))
	 (black-win? (string= res "blackwin"))
	 (draw? (string= res "draw"))
	 (g (connection-data-item *body* "current-chess-game")))
    (setf game-over t)
    (with-store *body*
      (state-intfc::set-result g (cond (white-win? :white-win)
				       (black-win? :black-win)
				       (draw? :draw)
				       (t (error "unexpected result"))))))
  (when white-engine
    (cl-uci:stop-engine-server white-engine)
    (setf white-engine nil))
  (when black-engine
    (cl-uci:stop-engine-server black-engine)
    (setf black-engine nil)))

(define-event "attemptloseontime" (:player-color))
(define-handler "attemptloseontime" "board"
  (let* ((player-color (getf data :|playerColor|))
	 (other-player-color (if (string= player-color "white") "black" "white"))
	 (sufficient-material? (sufficient-material? (queen:game chess-game) other-player-color))
	 (result (if sufficient-material? (format nil "~awin" other-player-color) "draw"))
	 (player-clock (if (string= player-color "white") white-clock black-clock))
	 (now (* 1000 (get-universal-time)))
	 (move-time (if last-move-timestamp (- now last-move-timestamp) 0)))
    (print data)
    (when (<= (- player-clock move-time) 0)
      (trigger-event obj "gameover"
		     :data (list :resolution "time"
				 :game-result result)))))
