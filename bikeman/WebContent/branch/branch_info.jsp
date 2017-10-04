<%@page import="com.bitmap.utils.report.Mobile"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.branch.Branch"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/clear_form.js"></script>

<script src="../js/jquery.validate.min.js"></script>
<script src="../js/jquery.metadata.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Branch Configuration</title>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>

<%
	Branch entity = Branch.select();
%>

</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
			Branch Info
			</div>
			
			<div class="content_body" align="center">
				
			<div style="width: 460px;">
				<fieldset style="width: 460px;">
					<legend>&nbsp;<Strong>ข้อมูลสาขา</Strong>&nbsp;</legend>
					<table width="90%" style="margin: 5px 5px 5px 10px;">
						<tr>
							<td width="30%" align="left"><Strong>รหัสสาขา</Strong></td>
							<td width="70%" align="left">: <%=entity.getBranch_code()%></td>
						</tr>
						<%-- <tr>
							<td ><Strong>ลำดับสาขา</Strong></td>
							<td >: <%=entity.getBranch_order()%></td>
						</tr> --%>
						<tr>
							<td ><Strong>ชื่อสาขา</Strong></td>
							<td >: <%=entity.getName()%></td>
						</tr>
						<tr>
							<td ><Strong>ชื่อย่อ</Strong></td>
							<td >: <%=entity.getBranch_name_en()%></td>
						</tr>
					</table>
				<fieldset style="width: 450px;">
					<legend>&nbsp;<Strong>ที่อยู่</Strong>&nbsp;</legend>
					<table width="90%" style="margin: 5px 5px 5px 10px;">	
						<tr>
							<td width="30%" align="left"><Strong>เลขที่ </Strong></td>
							<td width="70%" align="left">: <%=entity.getAddressnumber()%></td>
						</tr>
						<tr>
							<td ><Strong>หมู่ที่</Strong></td>
							<td >: <%=entity.getMoo()%></td>
						</tr>
						<tr>
							<td ><Strong>หมู่บ้าน</Strong></td>
							<td >: <%=entity.getVillege()%></td>
						</tr>
						<tr>
							<td ><Strong>ซอย</Strong></td>
							<td >: <%=entity.getSoi()%></td>
						</tr>
						<tr>
							<td ><Strong>ถนน</Strong></td>
							<td >: <%=entity.getRoad()%></td>
						</tr>
						<tr>
							<td ><Strong>ตำบล</Strong></td>
							<td >: <%=entity.getDistrict()%></td>
						</tr>
						<tr>
							<td ><Strong>อำเภอ</Strong></td>
							<td >: <%=entity.getPrefecture()%></td>
						</tr>
						<tr>
							<td ><Strong>จังหวัด</Strong></td>
							<td >: <%=entity.getProvince()%></td>
						</tr>
						<tr>
							<td ><Strong>รหัสไปรษณีรย์</Strong></td>
							<td >: <%=entity.getPostalcode()%></td>
						</tr>
						<tr>
							<td ><Strong>โทรศัพท์</Strong></td>
							<td >: <%=Mobile.mobile(entity.getPhonenumber())%></td>
						</tr>
						<tr>
							<td ><Strong>แฟกซ์</Strong></td>
							<td >: <%=Mobile.mobile(entity.getFax()) %></td>
						</tr>
					</table>
					</fieldset>
				</fieldset>
			</div>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>