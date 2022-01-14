customElements.define('ch-board', class extends HTMLElement {
    get fen() {
	return this.hasAtrribute("fen");
    }

    set fen(val) {
	/*
	  if(this.validateFen(val)) {
	  this.setAttribute('fen', val);
	  } else {
	  this.setAttribute('fen', 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR');
	  console.log("invalid fen: " + val);
	  }
	*/
	this.setAttribute("fen",val);
	this.setPosition(val);
    }

    get flip() {
	return this.hasAttribute("flip");
    }

    set flip(val) {
	if(val) {
	    this.setAttribute("flip", "");
	    $(this.shadowRoot).find('#squares').addClass("black-perspective").removeClass("white-perspective");
	} else {
	    this.removeAttribute("flip");
	    $(this.shadowRoot).find('#squares').addClass("white-perspective").removeClass("black-perspective");
	}
    }

    get moveColor() {
	return this.getAttribute("move-color");
    }

    set moveColor(val) {
	if(val) {
	    this.setAttribute("move-color", val);
	} else {
	    this.setAttribute("white");
	}
    }

    get playable() {
	return this.hasAttribute("playable");
    }

    set playable(val) {
	if(val) {
	    this.setAttribute("playable", "");
	} else {
	    this.removeAttribute("playable");
	}
    }

    get whiteHuman() {
	return this.hasAttribute("white-human");
    }

    set whiteHuman(val) {
	if(val) {
	    this.setAttribute("white-human", "");
	} else {
	    this.removeAttribute("white-human");
	}
    }

    get blackHuman() {
	return this.hasAttribute("black-human");
    }

    set blackHuman(val) {
	if(val) {
	    this.setAttribute("black-human", "");
	} else {
	    this.removeAttribute("black-human");
	}
    }

    validateFen(val) {
	return true;
    }

    createPiece(ch) {
	let div = document.createElement('div');
	div.classList.add("piece");

	if(ch == ch.toUpperCase()) {
	    div.classList.add("white");
	} else {
	    div.classList.add("black");
	}

	div.classList.add(ch);
	return div;
    }

    clearBoard() {
	$(this.shadowRoot).find('#squares').children().html("");
    }

    setPosition() {
	this.clearBoard();
	
	let fen = this.getAttribute('fen');
	let row = 7;
	let col = 0;
	let ch = "";

	for(let i = 0; fen[i] != " " && i < fen.length; i++) {
	    ch = fen[i];

	    if (col >= 8) row--;
	    col %= 8;

	    if("RNBKQPrnbkqp".includes(ch)) {
		let square_id = this.cols_lookup[col] + (row+1);
		console.log("piece: " + ch + " " + square_id);
		col++;
		let piece = this.createPiece(ch);
		let square = $(this.shadowRoot).find('#'+square_id)
		square.html("");
		square.append(piece);
	    } else if("12345678".includes(ch)) {
		console.log("skip: " + ch);
		col += parseInt(ch);
	    }
	}
    }

    movePieceOnSquare(fromSquareId, toSquareId) {
	let sr = this.shadowRoot;
	let moving_piece = $(sr).find('#'+fromSquareId).children();
	if (moving_piece) {
	    $(sr).find('#'+toSquareId).prepend(moving_piece);
	    return true;
	} else {
	    return false;
	}
    }

    isPickUpPiece(piece) {
	return piece && this.playable && !this.game_over &&
	    ((piece.classList.contains("white") && this.moveColor == "white" && this.whiteHuman)
	     || (piece.classList.contains("black") && this.moveColor == "black" && this.blackHuman));
    }

    resizeMousePiece() {
	this.mouse_piece[0].style.width = $(this.shadowRoot).find('#a8')[0].clientWidth;
	this.mouse_piece[0].style.height = $(this.shadowRoot).find('#a8')[0].clientHeight;
    }

    setMousePieceXY(x, y) {
	let rect = this.getBoundingClientRect();
	let l = rect.left;
	let t = rect.top;
	let sl = window.scrollX;
	let st = window.scrollY;
	let h = this.mouse_piece[0].clientWidth / 2; //is this expensive? make it instance variable?
	let mp = this.mouse_piece[0];
	let newX = x - h - l - sl;
	let newY = y - h - t - st;
	mp.style.left = newX + "px";
	mp.style.top = newY + "px";
    }

    setMousePiece(x, y) {
	this.setMousePieceXY(x, y);
	this.mouse_piece[0].classList = this.clicked_piece.classList;
	this.clicked_piece.classList.add("ghost");
    }

    unsetMousePiece() {
	this.clicked_piece.classList.remove("ghost");
	this.mouse_piece.addClass("invisible");
    }

    connectedCallback() {
	if(!this.hasAttribute('fen')) {
	    this.fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR";
	}
	this.setPosition();
	this.flip = this.flip;
	this.whiteHuman = this.whiteHuman;
	this.blackHuman = this.blackHuman;
	this.resizeMousePiece();
	if (!this.moveColor) {
	    this.moveColor = "white";
	}
    }

    constructor() {
	super(); 

	this.clicked_piece = null;
	this.clicked_square = null;
	this.game_over = false;

	const shadowRoot = this.attachShadow({mode: 'open'});
	shadowRoot.innerHTML = `
<style>
    :host {display: block; contain: layout; aspect-ratio: 1/1;}
    :host([hidden]) {display: none;} 
    .invisible {visibility:hidden;}
    #dragging-piece {position:absolute; z-index:6;}
    .pointer-invisible {pointer-events:none;}
    .flex-r {display: flex; flex-flow: row wrap; justify-content:center;}
    #mouse-piece {position: absolute; z-index: 10;}
    #squares {min-width: 100%; aspect-ratio: 1 / 1; cursor: pointer; user-select: none;}
    .square {min-height: 12.5%; min-width: 12.5%; aspect-ratio: 1/1;}
    .light {background-color: BlanchedAlmond;}
    .dark {background-color: BurlyWood;}
    .ghost {opacity: 35%;}
    .piece {height:100%; width:100%; aspect-ratio: 1/1; z-index: 5; position: relative; background-repeat:no-repeat; background-size:cover; pointer-events:none;}
</style>
<link rel="stylesheet" href="../../css/chess-game.css" />
<div class="white-perspective">
  <div id="mouse-piece" class="invisible"></div>
</div>
<div id="squares" class="flex-r white-perspective"></div>
    `;

	this.cols_lookup = ["a", "b", "c", "d", "e", "f", "g", "h"];
	this.mouse_piece = $(shadowRoot).find('#mouse-piece');

	let th = this; // we need this in lexical scope since 'this' won't necessarily refer to the ch-board object in event callbacks

	function onSquareMouseDown(ev) {
	    console.log("clicked: " + ev.target.id);
	    let piece = ev.target.firstChild;
	    if (th.isPickUpPiece(piece)) {
		th.clicked_piece = piece;
		th.clicked_square = ev.target;
		console.log("clicked piece: " + th.clicked_piece.classList);
		th.setMousePiece(ev.pageX, ev.pageY);
	    }
	}

	function onSquareMouseUp(ev) {
	    console.log("unclicked: " + ev.target.id);
	    if (th.clicked_piece && ev.target != th.clicked_square) {
		console.log("unclicked piece: " + th.clicked_piece.classList);
		$(th).trigger({
		    type: "attemptmove",
		    fromSquare: th.clicked_square.id,
		    toSquare: ev.target.id,
		    promote: ""
		});
		if (th.clicked_piece) {
		    th.unsetMousePiece();
		    th.clicked_piece = null;
		}
		th.clicked_square = null;
		ev.stopPropagation();
	    }
	}

	for(let row = 7; row >= 0; row--) {
	    for(let col = 0; col < 8; col++) {
		let square = document.createElement('div');
		square.id = this.cols_lookup[col] + (row + 1);
		square.classList.add('square');
		if ((row + col) % 2) square.classList.add('light');
		else square.classList.add('dark');
		$(shadowRoot).find('#squares').append(square);
		$(square).on("mousedown", onSquareMouseDown);
		$(square).on("mouseup", onSquareMouseUp);
	    }
	}

	function onAttemptMove(ev) {
	    console.log("attempting move: " + ev.fromSquare + ev.toSquare);
	    $(th).trigger({
		type: "makemove",
		fromSquare: ev.fromSquare,
		toSquare: ev.toSquare,
		isCapture: false,
		isCastleK: false,
		isCastleQ: false,
		isWhiteToMove: false,
		isPromote: false,
		promotePiece: null
	    });
	}

	function onMakeMove(ev) {
	    console.log("making move: " + ev.fromSquare + ev.toSquare);
	    if (ev.isCapture) {
		var captureId = '#' + ev.captureSquare;
		$(captureId).empty();
	    }

	    this.movePieceOnSquare(ev.fromSquare, ev.toSquare);
	    $(window).trigger("mouseup");

	    if (ev.isCastleK) {
		if (this.moveColor == "white") {
		    this.movePieceOnSquare("h1", "f1");
		} else {
		    this.movePieceOnSquare("h8", "f8");
		}
	    } else if(ev.isCastleQ) {
		if (this.moveColor == "white") {
		    this.movePieceOnSquare("a1", "d1");
		} else {
		    this.movePieceOnSquare("a8", "d8");
		}
	    }
	    if (ev.isPromote) {
		let pieceId = '#' + ev.pieceId;
		$(pieceId).addClass(ev.promotePiece);
		$(pieceId).removeClass("P p");
	    }

	    this.moveColor = this.moveColor == "white" ? "black" : "white";
	}

	function onWindowMouseUp (ev) {
	    if (th.clicked_piece) {
		th.unsetMousePiece();
		th.clicked_piece = null;
	    }
	    th.clicked_square = null;
	}

	function onMouseMove (ev) {
	    if (th.clicked_piece) {
		th.setMousePieceXY(ev.pageX, ev.pageY);
	    }
	}

	function onBoardResize (ev) {
	    th.resizeMousePiece();
	}

	$(window).on("mouseup", onWindowMouseUp);
	$(window).on("mousemove", onMouseMove);
	$(window).on("resize", onBoardResize);
	$(this).on("resize", onBoardResize);
	$(this).on("attemptmove", onAttemptMove);
	$(this).on("makemove", onMakeMove);

    }

});
