customElements.define('ch-moves', class extends HTMLElement {
    get gameId() {
	return this.getAttribute("game-id");
    } 
    set gameId(val) {
	let jqGameId = '#' + val;
	if(val && $(jqGameId).length > 0) {
	    this.setAttribute("game-id", val);
	    let th = this;
	    $(jqGameId).on("makemove", function (ev) {th.addMove(ev);});
	} else {
	    console.log("move pane needs valid game id: " + val);
	}
    }

    addMove(ev) {
	$(this).find('div.curr').removeClass("curr");

	if(ev.isWhiteToMove) {
	    var moveNum = document.createElement("div");
	    moveNum.classList.add("num");
	    moveNum.textContent = String(ev.fullMove);
	    this.append(moveNum);
	}

	var move = document.createElement("div");
	move.classList.add("curr");
	move.classList.add("move");
	move.textContent = String(ev.san);
	this.append(move);
    }

    connectedCallback() {
	let th = this;
	$(function () {
	    th.gameId = th.gameId;
	});
    }

    constructor() {
	super();

	const shadowRoot = this.attachShadow({mode: 'open'});
	shadowRoot.innerHTML = `
<style>
  :host {display: block; contain: layout;}
  :host([hidden]) {display: none;} 
  #container {display:flex; flex-flow:row wrap; align-items:flex-start; align-content:flex-start; user-select:none;}
  ::slotted(div) {height:27px; text-align:center; display:flex; flex-flow:row wrap; align-items:center;}
  ::slotted(div.move) {width:30%; padding-left:10%; font-size:18px; justify-content:left; cursor:pointer;}
  ::slotted(div.num) {width:20%; height:27px; font-size:15px; justify-content:center;}
</style>
<div id="container"><slot></slot></div>`;
    }
});
