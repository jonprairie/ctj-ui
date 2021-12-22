var game_over = false;
var dragging = null;
var drag_piece = null;
var move_color = "white"
var white_human = true;
var black_human = false;
var white_clock = 0;
var black_clock = 0;
var last_move_timestamp = 0;
var clock_running = false;
var second = 1000;
var minute = 60 * second;
var hour = 60 * minute;
clearInterval(clock_interval);
var clock_interval = null;

function leftPad (s, c, n) {
    s = String(s);
    var times = n - s.length;
    if (times > 0) {
	for(var i = 0; i < times; i++) {
	    s = c + s;
	}
    }
    return s;
}

function getClockString(ms) {
    var hours = Math.floor(ms / hour);
    ms = ms - hours * hour;
    var minutes = Math.floor(ms / minute);
    ms = ms - minutes * minute;
    var seconds = Math.floor (ms / second);
    return leftPad(hours, '0', 2) + ':' + leftPad(minutes, '0', 2) + ':' + leftPad(seconds, '0', 2);
}

function onInitGame(ev) {
    game_over = false;
    dragging = null;
    drag_piece = null;
    move_color = "white";
    white_human = ev.white.type == "HUMAN";

    black_human = ev.black.type == "HUMAN";
    white_clock = ev.wtime;
    black_clock = ev.btime;

    var wClockHtml = $("#whiteclock");

    var bClockHtml = $("#blackclock");
    var clockTime = new Date(white_clock);
    var clockHtml = getClockString(clockTime);
    wClockHtml.html(clockHtml);
    bClockHtml.html(clockHtml);

    $('#event').prepend(ev.event);
    $('#white-player').prepend(ev.white.name);
    $('#black-player').prepend(ev.black.name);
    if (!white_human && black_human) {
	$('#flip').click();
    }
    if (white_human) {
	$('#WHITERESIGN').prepend("Resign");
    }
    if (black_human) {
	$('#BLACKRESIGN').prepend("Resign");
    }
}

function updateClock() {
    if (clock_running) {
	var now = Date.now();
	var clockTime = move_color === "white" ? white_clock : black_clock;
	var otherClockTime = move_color === "white" ? black_clock : white_clock;
	var newClockTime = clockTime - (now - last_move_timestamp);
	if (newClockTime < 0) newClockTime = 0;
	var clockInnerHtml = getClockString(newClockTime);
	var otherClockInnerHtml = getClockString(otherClockTime);
	var clockId = '#' + move_color + 'clock';
	var otherClockId = '#' + (move_color === "white" ? "black" : "white") + 'clock';

	$(clockId).html(clockInnerHtml);
	$(otherClockId).html(otherClockInnerHtml);

	console.log(newClockTime);
	if (newClockTime <= 0 && !game_over) {
	    console.log("lost on time");
	    $('#board').trigger({ type: "attemptloseontime", playerColor: move_color});
	}
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

    move_color = ev.isWhiteToMove ? "black" : "white";

    clock_running = true;
    console.log(white_clock);
    white_clock = ev.whiteClock;
    console.log(white_clock);
    console.log(black_clock);
    black_clock = ev.blackClock;
    console.log(black_clock);
    last_move_timestamp = ev.timeAtMove;
}

function onGameOver(ev) {
    var winner = "";
    var loser = "";
    var resolution = "";
    var text = "";
    var clock_running = false;
    console.log(ev);
    if (ev.gameResult == "whitewin") {
	winner = "White";
	loser = "Black";
    } else if (ev.gameResult == "blackwin") {
	winner = "Black";
	loser = "White";
    } else if (ev.gameResult == "draw") {
	winner = "Draw";
    } else {}

    if (ev.resolution == "checkmate") {
	text = `Checkmate! ${winner} wins!`;
    } else if (ev.resolution == "resigns") {
	text = `${loser} resigns! ${winner} wins!`;
    } else if (ev.resolution == "time") {
	if (ev.gameResult == "draw") {
	    text = "Insufficient Material! Game Drawn!";
	} else {
	    text = `${loser} lost on time! ${winner} wins!`;
	}
    } else if (ev.resolution == "draw") {
	text = "Game Drawn!";
    }

    if (text) {
	clearInterval(clock_interval);
	$('#end-of-game-footer').prepend(text);
	game_over = true;
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
    $('#board').on("gameover", onGameOver);
    $('#board').on("makemove", $("move-pane").prop("addMove"));
    clock_interval = setInterval(updateClock,100);
});
