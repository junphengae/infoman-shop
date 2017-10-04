<%@page import="com.bitmap.bean.branch.BranchMaster"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery.min.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/popup.js"></script>

<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.datepicker.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Report Web Service</title>
</head>
<body>
<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">Report Web Service</div>
			<div class="content_body">
			<form id="report_from" >
			<table>
				<tr>
				<td>สาขา</td>
				<td>:
					<bmp:ComboBox name="branch" styleClass="txt_box s320" listData="<%=BranchMaster.branchDropdown()%>" validate="true" validateTxt="*">
						<bmp:option value="" text="---------------- เลือกทั้งหมด  ----------------"></bmp:option>
					</bmp:ComboBox> 
				</td>
				</tr>
			</table>
			<div class="center txt_center">
					<span class="btn_box btn_confirm" id="btn_view">ดูรายงาน</span>
					<span class="btn_box btn_confirm" id="btn_export">บันทึกเป็นไฟล์</span>
			</div>
			</form>
			</div>
		</div>  
	</div>
</div>
<script type="text/javascript">
	$(function(){
		var btn_view = $('#btn_view');
		var btn_export = $('#btn_export');
		
		btn_view.click(function(){
			//alert('VI '+$('#branch').val());
			popup('report_ws_review.jsp?'+$('#report_from').serialize());
			
		});
		btn_export.click(function(){
			//('EX '+$('#branch').val());
			popup('report_ws_review.jsp?export=true&'+$('#report_from').serialize());			
		});
	});
</script>
</body>
</html>