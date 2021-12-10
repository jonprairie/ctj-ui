(in-package #:ctj-ui)


(define-screen chess-game (chess-game)
  (:div :id chess-game))

(defun build-chess-game (body)
  (with-onclick (back newgame flip) body
    (:link :rel "stylesheet" :href "css/chess-game.css")
    (:script :src "https://code.jquery.com/ui/1.13.0/jquery-ui.js")
    (:style "body {overflow:hidden;}")
    (:style ".invisible {display:none;}")
    (:style "#dragging-piece {position:absolute; z-index:6;}")
    (:style ".flip {transform:rotate(180deg);}")
    (:style ".pointer-invisible {pointer-events:none;}")
    (:style "#board-cont {user-select:none; background-color: gray; min-height:640px; min-width:640px; max-height:640px; max-width:640px; cursor: pointer;}")
    (:style ".flex-r {display: flex; flex-flow: row wrap; justify-content:center;}")
    (:style ".square {height:80px; width:80px; flex:12.5%;}")
    (:style ".light {background-color: BlanchedAlmond;}")
    (:style ".dark {background-color: BurlyWood;}")
    (:style ".ghost {opacity: 35%;}")
    ;; (:style ".piece {height:80px; width:80px; z-index: 5; position: absolute; pointer-events:none; background-repeat:no-repeat; background-size:cover; background-attachment:fixed;}")
    (:style ".piece {height:80px; width:80px; z-index: 5; position: absolute; background-repeat:no-repeat; background-size:cover;}")
    (:p :id back "Back")
    (:p :id newgame "New Game")
    (:p :id flip "Flip")
    (:div :class "white-perspective"
	  (:div :id "dragging-piece" :class "invisible piece"))
    (:div :id "board-cont" :class "white-perspective"
	  (:div :id "pieces")
	  (:div :id "board" :class "flex-r"
		(:div :id "a8" :class "square light" "a8")
		(:div :id "b8" :class "square dark"  "b8")
		(:div :id "c8" :class "square light" "c8")
		(:div :id "d8" :class "square dark"  "d8")
		(:div :id "e8" :class "square light" "e8")
		(:div :id "f8" :class "square dark"  "f8")
		(:div :id "g8" :class "square light" "g8")
		(:div :id "h8" :class "square dark"  "h8")
		(:div :id "a7" :class "square dark"  "a7")
		(:div :id "b7" :class "square light" "b7")
		(:div :id "c7" :class "square dark"  "c7")
		(:div :id "d7" :class "square light" "d7")
		(:div :id "e7" :class "square dark"  "e7")
		(:div :id "f7" :class "square light" "f7")
		(:div :id "g7" :class "square dark"  "g7")
		(:div :id "h7" :class "square light" "h7")
		(:div :id "a6" :class "square light" "a6")
		(:div :id "b6" :class "square dark"  "b6")
		(:div :id "c6" :class "square light" "c6")
		(:div :id "d6" :class "square dark"  "d6")
		(:div :id "e6" :class "square light" "e6")
		(:div :id "f6" :class "square dark"  "f6")
		(:div :id "g6" :class "square light" "g6")
		(:div :id "h6" :class "square dark"  "h6")
		(:div :id "a5" :class "square dark"  "a5")
		(:div :id "b5" :class "square light" "b5")
		(:div :id "c5" :class "square dark"  "c5")
		(:div :id "d5" :class "square light" "d5")
		(:div :id "e5" :class "square dark"  "e5")
		(:div :id "f5" :class "square light" "f5")
		(:div :id "g5" :class "square dark"  "g5")
		(:div :id "h5" :class "square light" "h5")
		(:div :id "a4" :class "square light" "a4")
		(:div :id "b4" :class "square dark"  "b4")
		(:div :id "c4" :class "square light" "c4")
		(:div :id "d4" :class "square dark"  "d4")
		(:div :id "e4" :class "square light" "e4")
		(:div :id "f4" :class "square dark"  "f4")
		(:div :id "g4" :class "square light" "g4")
		(:div :id "h4" :class "square dark"  "h4")
		(:div :id "a3" :class "square dark"  "a3")
		(:div :id "b3" :class "square light" "b3")
		(:div :id "c3" :class "square dark"  "c3")
		(:div :id "d3" :class "square light" "d3")
		(:div :id "e3" :class "square dark"  "e3")
		(:div :id "f3" :class "square light" "f3")
		(:div :id "g3" :class "square dark"  "g3")
		(:div :id "h3" :class "square light" "h3")
		(:div :id "a2" :class "square light" "a2")
		(:div :id "b2" :class "square dark"  "b2")
		(:div :id "c2" :class "square light" "c2")
		(:div :id "d2" :class "square dark"  "d2")
		(:div :id "e2" :class "square light" "e2")
		(:div :id "f2" :class "square dark"  "f2")
		(:div :id "g2" :class "square light" "g2")
		(:div :id "h2" :class "square dark"  "h2")
		(:div :id "a1" :class "square dark"  "a1")
		(:div :id "b1" :class "square light" "b1")
		(:div :id "c1" :class "square dark"  "c1")
		(:div :id "d1" :class "square light" "d1")
		(:div :id "e1" :class "square dark"  "e1")
		(:div :id "f1" :class "square light" "f1")
		(:div :id "g1" :class "square dark"  "g1")
		(:div :id "h1" :class "square light" "h1")
		))
    (:script :src "/js/chess-game.js" :type "text/javascript"))
  (let ((board (attach-as-child body "board")))
    (on-click-newgame body)
    ;; (set-on-mouse-up
    ;;  (html-document *body*)
    ;;  (lambda (obj ev)
    ;;    (sleep .05)
    ;;    (when clicked-piece
    ;; 	 (reset-piece board clicked-piece)
    ;; 	 (setf clicked-piece nil))))
    ;; (loop for square in (get-all-squares board)
    ;; 	  do (set-on-mouse-down square (make-on-mouse-down-square square)))
    ;; (loop for square in (get-all-squares board)
    ;; 	  do (set-on-mouse-up square (make-on-mouse-up-square square)))
    ;; (set-on-mouse-move
    ;;  (html-document *body*)
    ;;  (lambda (obj ev)
    ;;    (when clicked-piece
    ;;  	 (translate-element clicked-piece
    ;;  	  		    (- (getf ev :page-x)
    ;;  	  		       (offset-left board))
    ;;  	  		    (- (getf ev :page-y)
    ;;  	  		       (offset-top board))))))
    (clog::set-on-event
     (html-document *body*) "makemove"
     (lambda (obj)
       (print obj)))
    (clog::set-event
     board "attemptmove"
     (lambda (data)
       (when (attempt-move board (parse-attempt-move-event data))
	 (print "valid move")))
     :call-back-script attempt-move-event-script)))

(defparameter chess-game nil)

(defun on-click-newgame (obj)
  (setf chess-game (queen::make-game))
  (queen:reset-game chess-game)
  (setup-pieces-from-game obj))

(defun on-click-flip (obj)
  (let ((board (attach-as-child obj "board-cont")))
    ;; (toggle-class board "flip")
    (toggle-class board "white-perspective")
    (toggle-class board "black-perspective")
    ;; (reset-all-pieces board)
    ))

(defun setup-pieces-from-game (obj)
  (let* ((board (attach-as-child obj "board"))
	 (pieces (attach-as-child obj "pieces")))
    (setf (inner-html pieces) "")
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
		   (print bg-file)
		   (:div :id (gensym "piece") :class classes :data-square square-key :data-color color
			 (concatenate 'string color (string (queen:piece-char p)))))))))))
    (reset-all-pieces board)
    ))

(defparameter clicked-piece nil)

(defun make-on-mouse-down-square (square)
  (lambda (obj ev)
    (print (html-id square))
    (when-let ((piece (get-piece-on-square square (html-id square))))
      (when (or (and (eql (queen:game-side chess-game) queen:+WHITE+)
		     (string-equal (attribute piece "data-color") "white"))
		(and (eql (queen:game-side chess-game) queen::+BLACK+)
		     (string-equal (attribute piece "data-color") "black")))
	(print (html-id piece))
	(setf clicked-piece piece)
	(translate-element clicked-piece
			   (- (getf ev :page-x)
			      (offset-left (attach-as-child square "board")))
			   (- (getf ev :page-y)
			      (offset-top (attach-as-child square "board")))))
      )))

(defun make-on-mouse-up-square (square)
  (lambda (obj ev)
    (print (html-id square))
    (when-let ((piece clicked-piece))
      (let ((san (concatenate 'string (attribute piece "data-square") (html-id square))))
	(if-let ((move (first (queen:game-parse-san chess-game san))))
	  (progn
	    (print (queen:game-san chess-game move))
	    (when-let ((captured-piece (get-piece-on-square square (html-id square))))
	      (remove-from-dom captured-piece))
	    (queen:game-move chess-game move)
	    (put-piece-on-square (attach-as-child piece "board") piece (html-id square)))
	  (reset-piece (attach-as-child square "board") piece)))
      (setf clicked-piece nil))
    ))

(defun attempt-move (board attempt-move-ev)
  (let* ((piece (attach-as-child board (getf attempt-move-ev :piece-id)))
	 (from-square (getf attempt-move-ev :from-square))
	 (to-square (getf attempt-move-ev :to-square))
	 (san (format nil "~a~a" from-square to-square)))
    (when-let ((move (first (queen:game-parse-san chess-game san))))
      (print (queen:game-san chess-game move))
      (when (queen:move-capture? move)
	(let* ((capture-index (queen:move-captured-index move))
	       (capture-square (queen:index-field capture-index))
	       (captured-piece (get-piece-on-square board capture-square)))
	  (format t "~a ~a ~a" capture-index capture-square captured-piece)
	  (remove-from-dom captured-piece)))
      (queen:game-move chess-game move)
      (put-piece-on-square board piece to-square)
      (when (queen:move-oo? move)
	(if (queen:move-white? move)
	    (put-piece-on-square board (get-piece-on-square board "h1") "f1")
	    (put-piece-on-square board (get-piece-on-square board "h8") "f8")))
      (when (queen:move-ooo? move)
	(if (queen:move-white? move)
	    (put-piece-on-square board (get-piece-on-square board "a1") "d1")
	    (put-piece-on-square board (get-piece-on-square board "a8") "d8")))
      (js-execute board (format nil "move_color = ~a;" (if (queen:move-white? move) "'black'" "'white'"))))
    (js-execute board "$(window).trigger(\"mouseup\");")))

(defun make-piece (color-key piece-key &optional square-key)
  (with-html-string
    (:div :id (gensym "piece") :class "piece" :data-square square-key
	  (concatenate 'string (string color-key) (string piece-key)))))

(defun put-piece-on-square (board piece square)
  (setf (attribute piece "data-square") square)
  (reset-piece board piece))

(defun offset-left-relative (el1 el2)
  (let* ((offset-x1 (offset-left el1))
	 (offset-x2 (offset-left el2)))
    (- offset-x1 offset-x2)))

(defun offset-top-relative (el1 el2)
  (let* ((offset-y1 (offset-top el1))
	 (offset-y2 (offset-top el2)))
    (- offset-y1 offset-y2)))

(defun get-all-pieces (board)
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
  (first-child (attach-as-child board square-key))
  ;; (loop for piece in (get-all-pieces board)
  ;; 	do (when (string-equal (attribute piece "data-square") square-key)
  ;; 	     (return piece)))
  )

(defun reset-piece (board piece)
  (let* ((sq-key (attribute piece "data-square"))
	 (sq (attach-as-child board sq-key)))
    (place-inside-top-of sq piece))
  ;; (let* ((square-key (attribute piece "data-square"))
  ;; 	 (square (attach-as-child board square-key))
  ;; 	 (square-x (offset-left-relative square board))
  ;; 	 (square-y (offset-top-relative square board)))
  ;;   (translate-element piece square-x square-y))
  )

;; (defun x (obj)
;;   (parse-integer (property "")))

(defparameter attempt-move-event-script
  "+ e.pieceId + ':' + e.fromSquare + ':' + e.toSquare")

(defun parse-attempt-move-event (data)
  (let ((f (ppcre:split ":" data)))
    (list
     :event-type :attempt-move
     :piece-id (nth 0 f)
     :from-square (nth 1 f)
     :to-square (nth 2 f))))
