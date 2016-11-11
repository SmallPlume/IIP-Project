var websocket = null;
if (window['WebSocket']) {
	websocket = new WebSocket("ws://" + chotPath + '/websocket');
}else{
	websocket = new new SockJS(contextPath + '/websocket/socketjs');
}

websocket.onopen = function(event) {
	console.log('open', event);
};

websocket.onmessage = function(event) {
	console.log('message', event.data);
	var msg = jQuery.parseJSON(event.data);
	if(msg.alerttype=='0'){
		$('#message > ul').append('<li>' + msg.alert + '</li>');
	}else{
		$('#message > ul').append('<li>' + jQuery.parseJSON(event.data).sentMsg + '</li>');
	}

	$('#users > ul').html('');
	for(var i=0;i<msg.names.length;i++){
		$('#users').append('<li><a href="javascript:chat."' +msg.names[i]+ '</li>');
	}
};

var chat = {
		
		
}
