<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>上传附件</title>
<%@include file="common/head.jsp"%>
<link type="text/css" rel="stylesheet" href="${basePath}/plupload-2.1.9/js/jquery.plupload.queue/css/jquery.plupload.queue.css">
<script type="text/javascript" src="${basePath}/plupload-2.1.9/js/plupload.full.min.js"></script>
<script type="text/javascript" src="${basePath}/plupload-2.1.9/js/jquery.plupload.queue/jquery.plupload.queue.js"></script>
<script type="text/javascript" src="${basePath}/plupload-2.1.9/js/zh_CN.js"></script>
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
				<div id="uploader">
					<p>Your browser doesn't have Flash, Silverlight or HTML5 support.</p>
				</div>
				<script type="text/javascript">
			// Initialize the widget when the DOM is ready
			$(function() {
			    // Setup html5 version
			    $("#uploader").pluploadQueue({
			        // General settings
			        //runtimes : 'html5,flash,silverlight,html4',
			        runtimes : 'html5,html4',
			        url : basePath+"/upload",
			        chunk_size : '1mb',
			        rename : true,
			        dragdrop: true,
			         
			        filters : {
			            // Maximum file size
			            max_file_size : '10mb',
			            // Specify what files to browse for
			            mime_types: [
			                {title : "Image files", extensions : "jpg,gif,png"},
			                {title : "Zip files", extensions : "zip"}
			            ]
			        },
			        // Resize images on clientside if we can
			        resize: {
			            width : 200,
			            height : 200,
			            quality : 90,
			            crop: true  // crop to exact dimensions
			        },
			        
			        // Sort files
			        sortable: true,
			 
			        // Views to activate
			        views: {
			            list: true,
			            thumbs: true, // Show thumbs
			            active: 'thumbs'
			        },
			        
			        // Flash settings
			        flash_swf_url : basePath+'/plupload-2.1.9/js/Moxie.swf',
			     
			        // Silverlight settings
			        silverlight_xap_url : basePath+'/plupload-2.1.9/js/Moxie.xap'
			    });
			});
			</script>
			</div>
		</div>
	</div>
</body>
</html>