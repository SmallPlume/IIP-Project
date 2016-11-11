<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@include file="../common/head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>聊天页面</title>
<script type="text/javascript" src="${basePath}/js/sockjs.min.js"></script>
<style type="text/css">
ul{
	width:100%;
}
ul li{
	width:100%;
}
a{
	text-decoration:none;
}
</style>
<script type="text/javascript">
	//获取当前网址
	var localObj = window.location;
	//获取带"/"的项目名
	var contextPath = localObj.pathname.split("/")[1];
	
	var chotPath = localObj.host + "/" + contextPath;
	
	var websocket = null;
	if (window['WebSocket']) {
		websocket = new WebSocket("ws://" + chotPath + '/websocket');
	} else {
		websocket = new new SockJS(contextPath + '/websocket/socketjs');
	}

	websocket.onopen = function(event) {
		console.log('open', event);
	};
	websocket.onmessage = function(event) {
		var msg = jQuery.parseJSON(event.data);
		if (msg.alertType == '0') {
			$('#message').append('<li style="text-align:center;"><span style="font-size:12px; color:#CFCFCF;">' + msg.alert + '</span></li>');
		} else {
			//判断是否群发
			if(msg.all){
				$('#message').append('<li style="text-align:left;"><span>【'+msg.from+'】：' + msg.sentMsg +'</span><span style="float:right; margin-right:5px;">'+ msg.date + '</span></li>');
			}else{
				$('#message').append('<li style="text-align:left;"><span><a href="javascript:void(0);" onclick=setValue_(\"'+msg.from+'\")>【'+msg.from+'】</a>对你说：' + msg.sentMsg +'</span><span style="float:right; margin-right:5px;">'+ msg.date + '</span></li>');
			}
		}

		//显示在线用户
		if (typeof(msg.names) != "undefined"){
			$("#users").find("li").remove();
			$('#users').append('<li><a href="javascript:void(0);" onclick=setValue_(\"ALL\")>全部用户</a></li>');
			for (var i = 0; i < msg.names.length; i++) {
				$('#users').append('<li><a href="javascript:void(0);" onclick=setValue_(\"'+msg.names[i]+'\")>' + msg.names[i] + '</a></li>');
			}
		}
	};

	//选择用户信息
	function setValue_(name) {
		if(name=='ALL'){
			$('#userName').html('【全部用户】');
		}else{
			$('#userName').html('【'+name+'】');
		}
		$('#accept').val(name);
	}

	//发送消息
	function submitMsg() {
		if(!validate()) return false;
		var params = $('.form').serializeArray();
		$.post('${basePath}/chat/send', params, function(r) {
			if(r.code<0) return top.$alert(r.msg);
			var accept = $('#accept').val();
			if(accept!="ALL"){
				$('#message').append('<li style="text-align:left;"><span>你对【'+$('#accept').val()+'】说：' + $('#sentMsg').val() +'</span><span style="float:right; margin-right:5px;">'+ getNowFormatDate() + '</span></li>');
			}
			$('#sentMsg').val('');
		}, "json");
	}
	
	//验证
	function validate(){
		var msg = $('#sentMsg').val();
		
		if(msg==null || msg =='') {
			alert("请输入信息..."); 
			return false;
		}
		return true;
	}
	
	function getNowFormatDate() {
	    var date = new Date();
	    var seperator1 = "-";
	    var seperator2 = ":";
	    var month = date.getMonth() + 1;
	    var strDate = date.getDate();
	    if (month >= 1 && month <= 9) {
	        month = "0" + month;
	    }
	    if (strDate >= 0 && strDate <= 9) {
	        strDate = "0" + strDate;
	    }
	    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
	            + " " + date.getHours() + seperator2 + date.getMinutes()
	            + seperator2 + date.getSeconds();
	    return currentdate;
	}
</script>
</head>
<body>
	<div class="container">
		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="text-center">对话窗口</h3>
				<p class="text-right">
					<span>欢迎<shiro:principal/>登录！</span>
					<a href="${basePath }/logout">退出</a>
				</p>
			</div>
			<div class="panel-body">
				<div class="col-md-3">
					<div class="panel panel-default">
						<div class="panel-heading">
							<h4 class="panel-title">
								<a data-toggle="collapse" data-parent="#accordion" href="#collapseOne">在线用户</a>
							</h4>
						</div>
						<div id="collapseOne" class="panel-collapse collapse in">
							<div class="panel-body">
								<div class="topbar-collapse">
									<ul id="users"></ul>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-9">
					<div class="panel panel-default">
						<div class="panel-heading">
							<h5 class="text-left" id="userName">【全部用户】</h5>
						</div>
						<div class="panel-body">
							<!-- Tab panes -->
							<div role="tabpanel" class="tab-pane active" id="home" style="background-color:#F0F0F0; height: 300px; margin-bottom: 10px; overflow-y:scroll;">
								<ul id="message"></ul>
							</div>
							<div class="tab-pane active">
								<form class="form" method="post">
									<input type="hidden" name="accept" id="accept" value="ALL" />
									<textarea class="form-control" rows="3" name="sentMsg" id="sentMsg"></textarea>
								</form>
							</div>
							<div class="tab-pane active" style="margin-top: 10px;">
								<a href="javascript:submitMsg();" class="btn btn-primary" style="float: right; width: 100px;">发送</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>