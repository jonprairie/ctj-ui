/*
  <move-pane>
  <x-move-num>1</x-move-num><x-move>e4</x-move>
  </move-pane>
*/
if (typeof(MovePane) === 'undefined') {
    class MovePane extends HTMLElement {
	constructor() {
	    super();

	    /*
	      var shadow = this.attachShadow({mode: 'open'});
	      var div = document.createElement("div");
	      div.classList.add("flex-r");
	      shadow.appendChild(div);
	    */
	}

	addMove(ev) {
	    //var moveNode = document.createElement("x-move");
	    console.log(ev);

	    var move_pane = $("move-pane");

	    $('move-pane > div.curr').removeClass("curr");

	    if(ev.isWhiteToMove) {
		var moveNum = document.createElement("div");
		moveNum.classList.add("num");
		moveNum.textContent = String(ev.fullMove);
		move_pane.append(moveNum);
	    }

	    var move = document.createElement("div");
	    move.classList.add("curr");
	    move.classList.add("san");
	    move.textContent = String(ev.san);
	    move_pane.append(move);
	}
    }

    if (!customElements.get('move-pane')){
	// Define the new element
	customElements.define('move-pane', MovePane);
    }
}
/*
// Create a class for the element
class MovePane extends HTMLParagraphElement {
constructor() {
// Always call super first in constructor
super();

// count words in element's parent element
var wcParent = this.parentNode;

function countWords(node){
var text = node.innerText || node.textContent
return text.split(/\s+/g).length;
}

var count = 'Words: ' + countWords(wcParent);

// Create a shadow root
var shadow = this.attachShadow({mode: 'open'});

// Create text node and add word count to it
var text = document.createElement('span');
text.textContent = count;

// Append it to the shadow root
shadow.appendChild(text);

// Update count when element content changes
setInterval(function() {
var count = 'Words: ' + countWords(wcParent);
text.textContent = count;
}, 200)

}
}

// Define the new element
customElements.define('move-pane', MovePane, { extends: 'p' });
*/
