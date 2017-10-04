<%@page import="com.bitmap.utils.report.Mobile"%>
<%@page import="com.bitmap.bean.branch.BranchMaster"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
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
<title>Branch: </title>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="snc" %>
<%
BranchMaster entity = new BranchMaster();
WebUtils.bindReqToEntity(entity, request);
BranchMaster.select(entity);



%>
</head>
<body>
 <div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Create Branch: </div>
				<div class="right">
					<button class="btn_box" type="button" onclick="history.back();">back</button>
				</div>
				<div class="clear"></div>
			</div> 
			
			
			<div class="content_body">
				<form id="infoForm" name="infoForm" action="" method="post" style="margin: 0;padding: 0;">
					<table cellpadding="3" cellspacing="3" border="0" class="center s480">
						<tbody>
						
						<tr height="20px">
							<td width="20%"><Strong>Branch Code</Strong></td>
							<td align="left">: 
							<%=entity.getBranch_code() %>
							</td>
						</tr>
						<tr height="20px">
							<td><Strong>Branch Name</Strong></td>
							<td align="left">: 
							<%=entity.getBranch_name() %>
							</td>
						 </tr>
						 <tr height="20px">
							<td colspan="2" height="10px" >
								<fieldset class="fset" >
								<legend>Address</legend>
								<table >
								<tr height="20px">
									<td><Strong>Road</Strong></td>
									<td align="left">: 
									<%=entity.getBranch_road() %>
									</td>
								</tr>
						 		<tr height="20px">
									<td><Strong>Soi</Strong></td>
									<td align="left">: 
									<%=entity.getBranch_lane()%>
									</td>
								</tr>
								 <tr height="20px">
									<td><Strong>No.</Strong></td>
									<td align="left">: 
									<%=entity.getBranch_addressnumber() %>
									</td>
								</tr>
						 		<tr height="20px">
									<td><Strong>Village No.</Strong></td>
									<td align="left">: 
									<%=entity.getBranch_moo() %>
									</td>
								</tr>
								<!--  <tr height="20px">
								<td><Strong>หมู่บ้าน</Strong></td>
								<td align="left">: 
								<input type="text" autocomplete="off" name="branch_villege" id="branch_villege"  class="txt_box s200 required" title="**** branch_villege"> 
								</td>
								</tr> --> 
								<tr height="20px">
									<td><Strong>Tambon</Strong></td>
									<td align="left">: 
									<%=entity.getBranch_district() %>
									</td>
								 </tr>
						 		<tr height="20px">
									<td><Strong>District</Strong></td>
									<td align="left">: 
									<%=entity.getBranch_prefecture() %>
									</td>
							 	</tr>
							 	<tr height="20px">
									<td><Strong>Province</Strong></td>
									<td align="left">: 
									<%=entity.getBranch_province() %>
									</td>
						 		</tr>
						 		<tr height="20px">
									<td><Strong>Postal Code</Strong></td>
									<td align="left">: 
									<%=entity.getBranch_postalcode() %>
									</td>
							 	</tr>
						  		<tr height="20px">
									<td><Strong>Phone Number</Strong></td>
									<td align="left">: 
									<%=Mobile.mobile(entity.getBranch_phonenumber()) %>
									</td>
						 		</tr>
						  		<tr height="20px">
									<td><Strong>Fax</Strong></td>
									<td align="left">: 
									<%=Mobile.mobile(entity.getBranch_fax()) %>
								</td>
							 	</tr>
						 	
								</table>
								</fieldset>
							</td>
						 </tr>
						 <tr> 
						 	<td colspan="2" height="10px">  </td> 
						 </tr>
						</tbody>
					</table>
					
	
					</form>
			</div>
			
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>