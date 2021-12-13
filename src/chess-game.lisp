(in-package #:ctj-ui)


(define-screen chess-game (chess-game)
  (:div :id chess-game))

(defun build-chess-game (body)
  (with-onclick (back newchessgame) body
    (:link :rel "stylesheet" :href "css/chess-game.css")
    (:script :src "https://code.jquery.com/ui/1.13.0/jquery-ui.js")
    (:style "body {overflow:hidden;}")
    (:style ".invisible {display:none;}")
    (:style "#dragging-piece {position:absolute; z-index:6;}")
    (:style ".flip {transform:rotate(180deg);}")
    (:style ".pointer-invisible {pointer-events:none;}")
    (:style "#board-cont {user-select:none; background-color: gray; min-height:640px; min-width:640px; max-width:640px; cursor: pointer;}")
    (:style ".flex-r {display: flex; flex-flow: row wrap; justify-content:center;}")
    (:style ".square {height:80px; width:80px; flex:12.5%;}")
    (:style ".light {background-color: BlanchedAlmond;}")
    (:style ".dark {background-color: BurlyWood;}")
    (:style ".ghost {opacity: 35%;}")
    (:style ".piece {height:80px; width:80px; z-index: 5; position: absolute; background-repeat:no-repeat; background-size:cover;}")
    (:p :id back "Back")
    (:p :id newchessgame "New Game")
    (:p :id "flip" "Flip")
    (:h1 :id "event")
    (:div :class "white-perspective"
	  (:div :id "dragging-piece" :class "invisible piece"))
    (:div :id "board-cont" :class "white-perspective"
	  (:div :id "pieces")
	  (:div :id "black-resign")
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
	  (:div :id "white-resign"))
    (:div :id "end-of-game-footer"))
  (on-initialize-chess-game body))

(defun on-initialize-chess-game (obj)
  (let ((board (attach-as-child obj "board")))
    (on-click-newchessgame obj)
    (load-script (html-document *body*) "js/chess-game.js")
    (clog::set-event
     board "attemptmove"
     (lambda (data)
       (attempt-human-move board (parse-attempt-move-event data)))
     :call-back-script attempt-move-event-script)
    (with-store obj
      (setf (connection-data-item obj "current-chess-game")
	    (make-instance 'state-query::chess-game
			   :white (nth 100 (state-query::get-all-players))
			   :black (state-query::get-human-player)
			   :event (first (state-query::get-all-tournaments))))
      (let ((g (connection-data-item obj "current-chess-game")))
	(setup-players g)
	(sleep .05)
	(trigger-ev board (print (build-js-initgame-event g)))))
    (when (and white-engine black-engine)
      (get-engine-move white-engine))
    ))

(defparameter chess-game nil)
(defun on-click-newchessgame (obj)
  (setf chess-game (queen::make-game))
  (queen:reset-game chess-game)
  (setup-pieces-from-game obj))

(defparameter stop-engine nil)
(defparameter white-engine nil)
(defparameter black-engine nil)

(defparameter engine-path 
  "C:/Users/jonnyp/Downloads/stockfish_14.1_win_x64_avx2/stockfish_14.1_win_x64_avx2/stockfish.exe")

(defun setup-players (g)
  (when-let* ((white (state-query::white g))
	      (black (state-query::black g)))
    (if (equal (state-query::player-type white) :cpu)
	(setf white-engine (get-new-engine engine-path))
	(setf white-engine nil))
    (if (equal (state-query::player-type black) :cpu)
	(setf black-engine (get-new-engine engine-path))
	(setf black-engine nil))))

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
	       (queen:game-board chess-game)
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
     (make-engine-move engine chess-game))))

(defun attempt-cpu-move (from-square to-square promote)
  (format t "attempting cpu move: ~a ~a ~a" from-square to-square promote)
  (let ((piece-id (html-id (first-child (attach-as-child *body* from-square)))))
    (attempt-move (attach-as-child *body* "board")
		  piece-id
		  from-square
		  to-square
		  promote)))

(defun attempt-human-move (board attempt-move-ev)
  (let* ((piece-id (getf attempt-move-ev :piece-id))
	 (from-square (getf attempt-move-ev :from-square))
	 (to-square (getf attempt-move-ev :to-square))
	 (promote (getf attempt-move-ev :promote)))
    (attempt-move board piece-id from-square to-square promote)))

(defun attempt-move (board piece-id from-square to-square promote-piece)
  (let ((san (format nil "~a~a~@[~a~]" from-square to-square promote-piece)))
    (if-let ((move (first (queen:game-parse-san chess-game san))))
      (progn
	(print (queen:game-san chess-game move))
	(queen:game-move chess-game move)
	(let* ((white-to-move? (queen:move-white? move))
	       (capture? (queen:move-capture? move))
	       (capture-square (when capture? (queen:index-field (queen:move-captured-index move))))
	       (castle-k? (queen:move-oo? move))
	       (castle-q? (queen:move-ooo? move))
	       (promote? (queen:move-promote? move))
	       (checkmate? (checkmate? chess-game))
	       (draw? (draw? chess-game))
	       (game-over? (or checkmate? draw?)))
	  (when checkmate?
	    (setf (connection-data-item board "current-chess-game-result") (if white-to-move? :white-win :black-win)))
	  (when draw?
	    (setf (connection-data-item board "current-chess-game-result") :draw))
	  (trigger-event board "makemove"
			 :data (list :piece-id piece-id
				     :from-square from-square
				     :to-square to-square
				     :is-white-to-move white-to-move?
				     :is-capture capture?
				     :capture-square capture-square
				     :is-castle-k castle-k?
				     :is-castle-q castle-q?
				     :is-promote promote?
				     :promote-piece promote-piece
				     :is-checkmate checkmate?
				     :is-draw draw?
				     :is-game-over game-over?))
	  (when (and (not game-over?)
		     (not stop-engine))
	    (if white-to-move?
		(when black-engine
		  (get-engine-move black-engine))
		(when white-engine
		  (get-engine-move white-engine))))
	  t))
      (progn
	(if (queen:game-parse-san chess-game (str:concat san "Q"))
	    (trigger-event board "attemptpromote"
			   :data (list :piece-id piece-id :from-square from-square :to-square to-square))
	    (trigger-event board "invalidmove"
			   :data (list :piece-id piece-id :from-square from-square :to-square to-square)))
	nil))))

(defun checkmate? (g)
  (and (queen:attacked? g)
       (not (queen:game-compute-moves g))))

(defun draw? (g)
  (or (queen:draw-by-material? g)
      (not (or (queen:attacked? g)
	       (queen:game-compute-moves g)))))

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

(defun get-new-engine (engine-path)
  (let ((engine (cl-uci::start-engine-server
		 (make-instance 'cl-uci::engine-config
				:name "stockfish"
				:path engine-path))))
    (cl-uci:initialize-engine engine)
    engine))

(defun make-engine-move (engine chess-game)
  (let* ((pos (queen:game-fen chess-game))
	 (cl-uci-move (cl-uci:get-engine-move-pos pos engine))
	 (from-square (cl-uci::from-square cl-uci-move))
	 (to-square (cl-uci::to-square cl-uci-move))
	 (promotion (cl-uci::promotionp cl-uci-move))
	 (promotion-piece (string-upcase (cl-uci::promotion-piece cl-uci-move))))
    (attempt-cpu-move from-square to-square (when promotion promotion-piece))))

(defun trigger-event (clog-obj event-type &key data html-id)
  (js-execute
   clog-obj
   (format nil "$('#~a').trigger({type: '~a', ~{~a: ~a~^, ~}});"
	   (or html-id (html-id clog-obj))
	   (cl-change-case:camel-case (string event-type))
	   (mapcar (lambda (x)
		     (typecase x
		       (string (str:concat "'" x "'"))
		       (symbol (cond
				 ((equal x t) "true")
				 ((equal x nil) "false")
				 (t (str:concat (cl-change-case:camel-case (string x))))))
		       (t x)))
		   data))))

(defun trigger-ev (clog-obj json &optional html-id)
  (js-execute
   clog-obj
   (print (format nil "$('#~a').trigger(JSON.parse('~a'));"
		  (or html-id (html-id clog-obj))
		  json))))

(defun build-js-player-obj (pl)
  (list :|name| (state-query::player-name pl)
	:|rating| (state-query::rating pl)
	:|type| (state-query::player-type pl)))

(defun build-js-initgame-event (chess-game)
  (jonathan:to-json
   (list :|type| "initgame"
	 :|event| (state-query::name (state-query::event chess-game))
	 :|white| (build-js-player-obj (state-query::white chess-game))
	 :|black| (build-js-player-obj (state-query::black chess-game)))))

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

(eval-when (:compile-toplevel)
  (defun remove-dbl-quotes (s)
    (str:replace-all "\"" "" s))

  (defparameter *js-events* (make-hash-table)))

(defmacro define-event (name props)
  `(setf (gethash (quote ,(symbolicate name)) *js-events*)
	 (cons (format nil "+ JSON.stringify(~a)"
		       (remove-dbl-quotes
			(jonathan:to-json
			 (loop for prop in (quote ,props)
			       collect
			       (let ((sym (symbolicate (cl-change-case:camel-case (string prop)))))
				 (cons sym
				       (format nil "e.~a" sym))))
			 :from :alist)))
	       (lambda (data)
		 (jonathan:parse data)))))


(defun on-attemptresign (obj data)
  (print data))

(define-event attemptresign (:player-color))

(defun set-attemptresign ()
  (let ((c (gethash 'attemptresign *js-events*)))
    (clog::set-event
     (window *body*) "attemptresign"
     (lambda (data)
       (on-attemptresign *body* (funcall (cdr c) data)))
     :call-back-script (car c))))

(defun handle-board-attemptresign (data)
  (let ((board (attach-as-child *body* "board")))
    (funcall
     (lambda (obj data)
       stuff)
     board data)))

(defun gameover (data)
  stuff)

;; (clog::set-event
;;      board "attemptmove"
;;      (lambda (data)
;;        (attempt-human-move board (parse-attempt-move-event data)))
;;      :call-back-script attempt-move-event-script)


(define-handler attemptresign "board"
  5)
(define-handler gameover nil
  5
  )

(defmacro define-handler (name id &body body)
  (let ((attach-name (symbolicate "ATTACH-" (if id (str:concat (str:upcase id) "-") "") (str:upcase name)))
	(handle-name (symbolicate "HANDLE-" (if id (str:concat (str:upcase id) "-") "") (str:upcase name))))
    (with-gensyms (event-data ele d)
      `(progn
	 (defun ,handle-name ,(if id `(obj data) `(data))
	   (progn ,@body))
	 (defun ,attach-name ()
	   (let ((,event-data (gethash (quote ,(symbolicate name)) *js-events*))
		 (,ele ,(if id
			    `(attach-as-child *body* ,id)
			    `(window *body*))))
	     (clog::set-event
	      ,ele ,name
	      (lambda (,d)
		,(if id
		     `(,handle-name ,ele (funcall (cdr ,event-data) ,d))
		     `(,handle-name (funcall (cdr ,event-data) ,d))))
	      :call-back-script (car ,event-data))))))))

(define-event attemptmove (:event-type :piece-id :from-square :to-square :promote))

(define-event "testevent" (:test1 :test2 :test3))
(define-handler "testevent" nil
  (format t "~a ~a ~a~%"
	  (getf data :|test1|)
	  (getf data :|test2|)
	  (getf data :|test3|)))
