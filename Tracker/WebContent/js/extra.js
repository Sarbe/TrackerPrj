
function alertX(msg) {
	var len = msg.length;
	var size  = len*8;
	$("#content #msgAlert").remove();
	var str = '<div class="alertX " id="msgAlert" style="width:'+size+'px;"></div>';
	$("#content").append(str);
	$("#msgAlert").text(msg);
	$("#msgAlert").delay(7000).fadeOut(4000);
}
