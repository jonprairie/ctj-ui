mouse_offset = {};
obj_offset = {};
dragging = null;
drag_piece = null;
move_color = "white"
p_id = null;

function onMouseDown(ev) {
    console.log(this.dataset.square);
    if (this.dataset.color == move_color) {
	drag = $('#dragging-piece');
  	drag.prop('classList', this.classList);
	drag.prop('classList').add("pointer-invisible");
  	this.classList.add("ghost");
  	drag2 = document.getElementById('dragging-piece');
  	drag2.style.left = ev.pageX - 40 + "px";
  	drag2.style.top = ev.pageY - 40 + "px";
  	dragging = drag2;
  	drag_piece = this;
  	p_id = drag_piece.id;
    }
}

function onMouseMove(ev) {
    if (dragging != null) {
	dragging.style.left = ev.pageX - 40 + "px";
	dragging.style.top = ev.pageY - 40 + "px";
    }
}

function onMouseUp(ev) {
    if (dragging != null) {
  	//$(this).prepend($(drag_piece));
	$('#board').trigger({
	    type: "attemptmove",
	    pieceId: drag_piece.id,
	    fromSquare: drag_piece.dataset.square,
    	    toSquare: this.id
	});
	console.log("attempting move: " + drag_piece.dataset.square + this.id);
	ev.stopPropagation();
    }
}

function onMouseUpWindow(ev) {
    if (dragging != null) {
	dragging.classList.add("invisible");
  	drag_piece.classList.remove("ghost");
  	dragging = null;
  	drag_piece = null;
    }
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

$(document).ready(function () {
    $('.piece').on('mousedown', onMouseDown);
    $(window).on('mousemove', onMouseMove);
    $('.square').on('mouseup', onMouseUp);
    $(window).on('mouseup', onMouseUpWindow);
});
