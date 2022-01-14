var second = 1000;
var minute = 60 * second;
var hour = 60 * minute;

customElements.define('ch-clock', class extends HTMLElement {
    get whiteTime() {
	return this.getAttribute("white-time");
    }
    set whiteTime(val) {
	this.setAttribute("white-time", val);
    }

    get blackTime() {
	return this.getAttribute("black-time");
    }
    set blackTime(val) {
	this.setAttribute("black-time", val);
    }

    get running() {
	return this.hasAttribute("running");
    }
    set running(val) {
	if(val) {
	    this.setAttribute("running", "");
	    this.removeAttribute("paused");
	} else {
	    this.removeAttribute("running");
	    this.setAttribute("paused", "");
	}
    }

    get paused() {
	return this.hasAttribute("paused");
    }
    set paused(val) {
	if(val) {
	    this.setAttribute("paused", "");
	    this.removeAttribute("running");
	} else {
	    this.removeAttribute("paused");
	    this.setAttribute("running", "");
	}
    }

    get whiteToMove() {
	return this.hasAttribute("white-to-move");
    }
    set whiteToMove(val) {
	if(val) {
	    this.setAttribute("white-to-move", "");
	    this.removeAttribute("black-to-move");
	} else {
	    this.removeAttribute("white-to-move");
	    this.setAttribute("black-to-move", "");
	}
    }

    get blackToMove() {
	return this.hasAttribute("black-to-move");
    }
    set blackToMove(val) {
	if(val) {
	    this.setAttribute("black-to-move", "");
	    this.removeAttribute("white-to-move");
	} else {
	    this.removeAttribute("black-to-move");
	    this.setAttribute("white-to-move", "");
	}
    }

    get gameId() {
	return this.getAttribute("game-id");
    } 
    set gameId(val) {
	let jqGameId = '#' + val;
	if(val && $(jqGameId).length > 0) {
	    this.setAttribute("game-id", val);
	    let th = this;
	    $(jqGameId).on("makemove", function (ev) {th.clockToggle();});
	} else {
	    console.log("clock needs valid game id: " + val);
	}
    }

    leftPad (s, c, n) {
	s = String(s);
	var times = n - s.length;
	if (times > 0) {
	    for(var i = 0; i < times; i++) {
		s = c + s;
	    }
	}
	return s;
    }

    msToString(ms) {
	let hours = Math.floor(ms / hour);
	ms = ms - hours*hour;
	let minutes = Math.floor(ms / minute);
	ms = ms - minutes*minute;
	let seconds = Math.floor(ms / second);
	return this.leftPad(hours, '0', 2) + ':' + this.leftPad(minutes, '0', 2) + ':' + this.leftPad(seconds, '0', 2);
    }

    clockPause() {
	clearInterval(this.updater);
	this.paused = true;
	if(this.whiteToMove) {
	    this.whiteTime = this.live_white_time;
	} else {
	    this.blackTime = this.live_black_time;
	}
    }
    clockRun() {
	if (!this.started) {
	    this.started = true;
	}
	this.last_toggle = Date.now();
	let th = this;
	this.updater = setInterval(function () {
	    let dec = Date.now() - th.last_toggle;
	    if(th.whiteToMove) {
		th.live_white_time = th.whiteTime - dec;
		if(th.white_clock_view.length > 0) {
		    th.white_clock_view.html(th.msToString(th.live_white_time));
		}
	    } else {
		th.live_black_time = th.blackTime - dec;
		if(th.black_clock_view.length > 0) {
		    th.black_clock_view.html(th.msToString(th.live_black_time));
		}
	    }
	    //console.log("white: " + th.live_white_time + " black: " + th.live_black_time);
	}, 100);
	this.running = true;
    }

    clockToggle() {
	if (!this.running) {
	    this.clockRun();
	}
	if (this.whiteToMove) {
	    this.whiteTime = this.live_white_time;
	} else {
	    this.blackTime = this.live_black_time;
	}
	this.whiteToMove = !this.whiteToMove;
    }

    // todo: add sync method to sync clock with authoritative clock (on backend or wherever it exists)

    // todo: add increment functionality
    
    connectedCallback() {
	let th = this;
	$(function () {
	    th.whiteTime = th.whiteTime;
	    th.blackTime = th.blackTime;
	    th.gameId = th.gameId;
	    th.live_white_time = th.whiteTime;
	    th.live_black_time = th.blackTime;
	    if (! (th.running || th.paused)) {
		th.paused = true;
	    } else {
		th.running = th.running;
		th.paused = th.paused;
	    }
	    if (! (th.whiteToMove || th.blackToMove)) {
		th.whiteToMove = true;
	    } else {
		th.whiteToMove = th.whiteToMove;
	    }

	    if (th.running) th.clockRun();

	    th.white_clock_view = $('#'+th.gameId+'-white-clock')
	    th.black_clock_view = $('#'+th.gameId+'-black-clock')

	    if (th.white_clock_view.length > 0) {
		th.white_clock_view.html(th.msToString(th.live_white_time));
	    }
	    if (th.black_clock_view.length > 0) {
		th.black_clock_view.html(th.msToString(th.live_black_time));
	    }
	});
    }
    
    constructor () {
	super();

	this.started = false;
	this.last_toggle = null;
	this.updater = null;
    }
});
