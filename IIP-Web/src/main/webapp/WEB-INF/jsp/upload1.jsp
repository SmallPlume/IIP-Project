<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>上传附件</title>
<%@include file="common/head.jsp"%>
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<link rel="stylesheet" href="${basePath}/layer/css/layui.css"  media="all">
<script type="text/javascript" src="${basePath}/layer/layui.js"></script>
<script type="text/javascript">
layui.use('upload', function(){
  layui.upload({
    url: basePath+"/uploadImg", //上传接口
    success: function(res){ //上传成功后的回调
      console.log(res);
      //alert(res.data.path);
      $('#img').css('background-image','url('+res.data.path+')');
    }
  });
  
  /* layui.upload({
    url: '/test/upload.json'
    ,elem: '#test' //指定原始元素，默认直接查找class="layui-upload-file"
    ,method: 'get' //上传接口的http类型
    ,success: function(res){
      LAY_demo_upload.src = res.url;
    }
  }); */
});
</script>

</head>
<body>
	<div class="head">
		<br />
	</div>
	<div class="container">
		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="text-center">文件上传</h3>
			</div>
			<div class="panel-body">
				<fieldset class="layui-elem-field layui-field-title" style="margin-top: 50px;">
					<legend>演示上传</legend>
				</fieldset>

				<div class="site-demo-upload">
					<div id="img" style="width:500px; height:300px;"></div>
					<div class="site-demo-upbar">
						<input type="file" name="file" class="layui-upload-file" id="test">
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>