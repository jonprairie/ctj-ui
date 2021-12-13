game_over = false;
dragging = null;
drag_piece = null;
move_color = "white"
white_human = true;
black_human = false;

function onInitGame(ev) {
    game_over = false;
    dragging = null;
    drag_piece = null;
    move_color = "white";
    white_human = ev.white.type == "HUMAN";
    black_human = ev.black.type == "HUMAN";

    $('#event').prepend(ev.event);
    $('#white-player').prepend(ev.white.name);
    $('#black-player').prepend(ev.black.name);
    if (!white_human && black_human) {
	$('#flip').click();
    }
}

function onMouseDown(ev) {
    console.log(this.dataset.square);
    if (!game_over && this.dataset.color == move_color
	&& ((move_color == "white" && white_human) || (move_color == "black" && black_human))) {
	drag = $('#dragging-piece');
  	drag.prop('classList', this.classList);
	drag.prop('classList').add("pointer-invisible");
  	this.classList.add("ghost");
  	drag2 = document.getElementById('dragging-piece');
  	drag2.style.left = ev.pageX - 40 + "px";
  	drag2.style.top = ev.pageY - 40 + "px";
  	dragging = drag2;
  	drag_piece = this;
    }
}

function onMouseMove(ev) {
    if (dragging != null) {
	dragging.style.left = ev.pageX - 40 + "px";
	dragging.style.top = ev.pageY - 40 + "px";
    }
}

function onMouseUp(ev) {
    if (dragging != null && drag_piece.dataset.square != this.id) {
	$('#board').trigger({
	    type: "attemptmove",
	    pieceId: drag_piece.id,
	    fromSquare: drag_piece.dataset.square,
    	    toSquare: this.id,
	    promote: ""
	});
	console.log("attempting move: " + drag_piece.dataset.square + this.id);
	ev.stopPropagation();
    }
}

function onAttemptPromote (ev) {
    var promote = "Q";
    $('#board').trigger({
	type: "attemptmove",
	pieceId: ev.pieceId,
	fromSquare: ev.fromSquare,
    	toSquare: ev.toSquare,
	promote: promote
    });
    console.log("attempting promotion: " + ev.fromSquare + ev.toSquare + promote);
}

function onMouseUpWindow(ev) {
    if (dragging != null) {
	dragging.classList.add("invisible");
  	drag_piece.classList.remove("ghost");
  	dragging = null;
  	drag_piece = null;
    }
}

function getPieceOnSquare(squareId) {
    for(c of $('#'+squareId).children()) {
	if (c.dataset.square == squareId) {
	    return c;
	}
    }
    return null;
}

function movePieceOnSquare(fromSquareId, toSquareId) {
    var moving_piece = getPieceOnSquare(fromSquareId);
    if (moving_piece) {
	moving_piece.dataset.square = toSquareId;
	$('#'+toSquareId).prepend($('#'+fromSquareId).children());
	return true;
    }
    return false;
}

function onMakeMove(ev) {
    if (ev.isCapture) {
	var captureId = '#' + ev.captureSquare;
	$(captureId).empty();
    }

    movePieceOnSquare(ev.fromSquare, ev.toSquare);
    $(window).trigger("mouseup");

    if (ev.isCastleK) {
	if (ev.isWhiteToMove) {
	    movePieceOnSquare("h1", "f1");
	} else {
	    movePieceOnSquare("h8", "f8");
	}
    } else if(ev.isCastleQ) {
	if (ev.isWhiteToMove) {
	    movePieceOnSquare("a1", "d1");
	} else {
	    movePieceOnSquare("a8", "d8");
	}
    }
    if (ev.isPromote) {
	pieceId = '#' + ev.pieceId;
	$(pieceId).addClass(ev.promotePiece);
	$(pieceId).removeClass("P p");
    }

    if (ev.isCheckmate) {
	winner = ev.whiteToMove ? "White" : "Black";
	$('#end-of-game-footer').prepend(`Checkmate! ${winner} wins!`);
	game_over = true;
    } else if (ev.isDraw) {
	$('#end-of-game-footer').prepend('Draw! Game over!');
	game_over = true;
    } else {
	move_color = ev.isWhiteToMove ? "black" : "white";
    }
}

function onInvalidMove(ev) {
    $(window).trigger("mouseup");
}

var lut = [];
for (var i=0; i<256; i++) { lut[i] = (i<16?'0':'')+(i).toString(16); }
function e7()
{
    var d0 = Math.random()*0xffffffff|0;
    var d1 = Math.random()*0xffffffff|0;
    var d2 = Math.random()*0xffffffff|0;
    var d3 = Math.random()*0xffffffff|0;
    return 'ev'+lut[d0&0xff]+lut[d0>>8&0xff]+lut[d0>>16&0xff]+lut[d0>>24&0xff]+'_'+
	lut[d1&0xff]+lut[d1>>8&0xff]+'_'+lut[d1>>16&0x0f|0x40]+lut[d1>>24&0xff]+'_'+
	lut[d2&0x3f|0x80]+lut[d2>>8&0xff]+'_'+lut[d2>>16&0xff]+lut[d2>>24&0xff]+
	lut[d3&0xff]+lut[d3>>8&0xff]+lut[d3>>16&0xff]+lut[d3>>24&0xff];
}

function onFlipBoard () {
    var board = $('#board-cont');
    board.toggleClass("white-perspective");
    board.toggleClass("black-perspective");
}

$(function () {
    $('#flip').on('click', onFlipBoard);
    $('#board').on("initgame", onInitGame);
    $('#flip').click().click(); // prime cache with reversed images
    $('.piece').on('mousedown', onMouseDown);
    $(window).on('mousemove', onMouseMove);
    $('.square').on('mouseup', onMouseUp);
    $(window).on('mouseup', onMouseUpWindow);
    $('#board').on("makemove", onMakeMove);
    $('#board').on("attemptpromote", onAttemptPromote);
    $('#board').on("invalidmove", onInvalidMove);
});
