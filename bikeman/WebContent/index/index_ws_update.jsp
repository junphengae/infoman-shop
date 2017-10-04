<%@page import="com.bitmap.utils.ReportUtils"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="java.awt.image.DataBuffer"%>
<%@page import="com.bitmap.webservice.WSLogUpdateTS"%> 
<%@page import="com.bitmap.webservice.WSLogUpdateBean"%>
<%@page import="com.bitmap.security.SecurityUnit"%>
<%@page import="com.bitmap.security.SecuritySystem"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/index.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>BikeMan</title>
<%
	
    WSLogUpdateTS.insertWSLogUpdate("login_session", "login");

%>
<script type="text/javascript">
	$(function(){
		
		ajax_load();
		$.post('../CallWSSevrlet','action=updateDcToShop',function(response){
		 
			ajax_remove();  
			if (response.status == 'success') {
				//alert("Update ข้อมูลจากสำนักงานใหญ่เรียบร้อบ");
				window.location = "index.jsp";
			} else {
				alert(response.message);
			}
		},'json');
	});
	
</script>

</head>
<body >

<div class="wrap_all">
	<jsp:include page="index_header.jsp"></jsp:include>
	<div class="wrap_body">
	</div>
	
	<jsp:include page="footer.jsp"></jsp:include>
	
</div>

</body>
</html>