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



<script type="text/javascript">
$(function(){	
	$('#branch_code_confirm').click(function(){
	//	if (confirm('Comfirm Code !')) {
			$.post('../BranchManagement',$('#BranchCodeForm').serialize() ,function(resData){
				if (resData.status == 'success') {
					 window.location.reload();
				} else {
					alert(resData.message);
				}
				
			},'json');
	//	}
	});
	
	
});
</script>

</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
			Branch Configuration
			</div>
			
			<div class="content_body" align="center">
				<form id="BranchCodeForm"  onsubmit="return false;">
						<table width="70%">
							<tr>
								<td align="center" 	 height="30px" valign="middle">
									<Strong>Branch Code</Strong> : 
									<input type="text" name="branch_code" id="branch_code" maxlength="5"/>
								</td>
							</tr>
							<tr>
								<td align="center">
									<font color="red">** ใส่เฉพาะ Bracnh Code เท่านั้น  **</font>
								</td>
							</tr>
							<tr>
								<td align="center" height="50px" valign="bottom">
									<input type="submit" class="btn_box btn_confirm" id="branch_code_confirm" value="Confirm Branch Code" >
								</td>
							</tr>
						</table>
						<input type="hidden" name="action" value="addCode">
						<input type="hidden" name="id" value="1">
					<div class="msg_error"></div> 
				</form>
				
			<div style="width: 450px;">
				<fieldset style="width: 450px;">
					<legend>&nbsp;<Strong>Branch Info</Strong>&nbsp;</legend>
					<table width="90%" style="margin: 5px 5px 5px 10px;">
						<tr>
							<td width="30%" align="left"><Strong>Branch Code</Strong></td>
							<td width="70%" align="left">: <%=entity.getBranch_code()%></td>
						</tr>
						<tr>
							<td ><Strong>Branch Name</Strong></td>
							<td >: <%=entity.getName()%></td>
						</tr>
						<tr>
							<td ><Strong>เลขที่ </Strong></td>
							<td >: <%=entity.getAddressnumber()%></td>
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
					</table>
				</fieldset>
			</div>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>