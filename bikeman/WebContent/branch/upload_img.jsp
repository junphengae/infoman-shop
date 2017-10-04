<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Promotion  Configuration</title>
<script src="../js/jquery-1.4.2.min.js" type="text/javascript"></script>
<script src="../js/ajaxfileupload.js" type="text/javascript"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.webcam.js"></script>
<script src="../js/jquery.validate.min.js"></script>
<script src="../js/jquery.metadata.js"></script>
<%
String id = WebUtils.getAjaxReqString(request, "id");
System.out.println("ID : "+id);
%>
<script type="text/javascript">
function ajaxImgUpload(){
	$up = $('#fileToUpload');
	var id  = '<%=id%>';
	if ($up.val() == '') {
		alert('Please select image!');
		$up.focus();
	} else {
		$.ajaxFileUpload({
			url:'../PromotionImg', 
			secureuri:false,
			fileElementId:'fileToUpload',
			param: 'id:' + id,
			dataType: 'json',
			success: function (data, status){
				window.location.reload();
			},
			error: function (){
				window.location.reload();
			}
		});
	}
	return false;
}
</script>
</head>
<body>

<div id="uploadImg" align="center">
	<form enctype="multipart/form-data" method="post" action="" name="imgForm" style="margin: 0px; padding: 0px;">
	<input type="file" id="fileToUpload" name="fileToUpload" readonly="readonly" class="txt_box" onchange="return ajaxImgUpload();">
	</form>
</div>
</body>
</html>