<%@page import="com.bmp.cs.promotion.PromotionTS"%>
<%@page import="com.bmp.cs.promotion.PromationBean"%>
<%@page import="com.bitmap.utils.report.Mobile"%>
<%@page import="com.bitmap.utils.ReportUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="java.sql.Timestamp"%>
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
<script src="../js/jquery-1.4.2.min.js" type="text/javascript"></script>
<script src="../js/ajaxfileupload.js" type="text/javascript"></script>
<script src="../js/jquery.webcam.js"></script>

<script src="../js/jquery.validate.min.js"></script>
<script src="../js/jquery.metadata.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">



<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Promotion  Configuration</title>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>

<%
PromationBean re = new PromationBean();
re.setId("1");
PromationBean entity = PromotionTS.select(re);
//System.out.println("Promotion:"+entity.getPromotion1());
%>

<script type="text/javascript">

function ajaxImgDelete(id) {
	var $form = $('#delete_img');
	var branch = '<%=entity.getBranch_code()%>';
	var idpro = branch+'-'+id;
	if(idpro != ''){
		//alert(idpro);		
		ajax_load();
		$.post('../BranchManagement','action=delete_img&id=' + idpro ,function(json){	
			ajax_remove();
			if (json.status == 'success') {				
					window.location.reload();
												
			} else {
				alert(json.message);
			}
		},'json');	
		
	}
	
	
	return false;
  }
</script>

</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">		
			<div class="left">Promotion  Configuration</div>
					<div class="right">
						
						<input id="edit_Promotion" class="btn_box thickbox" type="button" lang="promotion_edit.jsp?id=<%=entity.getId() %>&height=500&width=900" value="แก้ไข" title="Edit Promotion" >
							
					</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body" align="center">	
			<div style="width: 900px;">
				<fieldset style="width: 900px;">
					<legend>&nbsp;<Strong>Promotion Info</Strong>&nbsp;</legend>
			 <form action="delete_img" id="delete_img" method="post">	
					<table width="90%" style="margin: 5px 5px 5px 10px;">
						<tr>
							<td width="15%" align="left"><Strong>Set Thank</Strong></td>
							<td width="75%" align="left">: <%=entity.getRemake()%></td>
							<td width="10%" align="left"></td>
						</tr>
						<tr>
							<td ><Strong>Promotion info : 1</Strong></td>
							<td >: <%=entity.getPromotion1()%></td>
							<td align="left"></td>
					  	</tr>
						<tr>
							<td align="left"></td>
							<td align="left">																		
							  <img  src="../DisplayImagePromotion?id=<%=entity.getBranch_code() %>-1">	 							
							</td>
							<td align="left"></td>
						</tr>	 
						<tr>
							<td ></td>
							<td align="center">									
							<input id="upload_promotion" class="btn_box thickbox" type="button" lang="upload_img.jsp?id=<%=entity.getBranch_code() %>-1&height=100&width=200" value="Upload" title="Upload Promotion" >																									
							<input id="delete_promotion" class="btn_box" type="button"  value="Delete" title="Delete Promotion" onclick="return ajaxImgDelete(1);">																				
							</td>
							<td align="left"></td>
					  	</tr>	
					
						<tr>
							<td ><Strong>Promotion info : 2</Strong></td>
							<td >: <%=entity.getPromotion2()%></td>
							<td align="left"></td>
						</tr>
						<tr>
							<td align="left"></td>
							<td align="left">	
							<img src="../DisplayImagePromotion?id=<%=entity.getBranch_code() %>-2">	 									
							</td>
							<td align="left">		
								
							</td>
						</tr>	 
						<tr>
							<td ></td>
							<td align="center">									
							<input id="upload_promotion" class="btn_box thickbox" type="button" lang="upload_img.jsp?id=<%=entity.getBranch_code() %>-2&height=100&width=200" value="Upload" title="Upload Promotion" >																									
							<input id="delete_promotion" class="btn_box" type="button"  value="Delete" title="Delete Promotion" onclick="return ajaxImgDelete(2);">																				
							</td>
							<td align="left"></td>
					  	</tr>		
							
							
						<tr>
							<td ><Strong>Promotion info : 3</Strong></td>
							<td >: <%=entity.getPromotion3()%></td>
							<td align="left"></td>
						</tr>
						<tr>
							<td align="left"></td>
							<td align="left">	
							<img  src="../DisplayImagePromotion?id=<%=entity.getBranch_code() %>-3">	 								
							</td>
							<td align="left">		
							
							</td>
						</tr>
						<tr>
							<td ></td>
							<td align="center">									
							<input id="upload_promotion" class="btn_box thickbox" type="button" lang="upload_img.jsp?id=<%=entity.getBranch_code() %>-3&height=100&width=200" value="Upload" title="Upload Promotion" >																									
							<input id="delete_promotion" class="btn_box" type="button"  value="Delete" title="Delete Promotion" onclick="return ajaxImgDelete(3);">																			
							</td>
							<td align="left"></td>
					  	</tr>
						
						
						<tr>
							<td ><Strong>Promotion info : 4</Strong></td>
							<td >: <%=entity.getPromotion4()%></td>
							<td align="left"></td>
						</tr>
						<tr>
							<td align="left"></td>
							<td align="left">	
							<img  src="../DisplayImagePromotion?id=<%=entity.getBranch_code() %>-4">	 									
							</td>
							<td align="left">		
							
							</td>
						</tr>
						<tr>
							<td ></td>
							<td align="center">									
							<input id="upload_promotion" class="btn_box thickbox" type="button" lang="upload_img.jsp?id=<%=entity.getBranch_code() %>-4&height=100&width=200" value="Upload" title="Upload Promotion" >																									
							<input id="delete_promotion" class="btn_box" type="button"  value="Delete" title="Delete Promotion" onclick="return ajaxImgDelete(4);">																			
							</td>
							<td align="left"></td>
					  	</tr>
						
						
						
						
						<tr>
							<td ><Strong>Promotion info : 5</Strong></td>
							<td >: <%=entity.getPromotion5()%></td>
							<td align="left"></td>
						</tr>
						<tr>
							<td align="left"></td>
							<td align="left">	
							<img  src="../DisplayImagePromotion?id=<%=entity.getBranch_code() %>-5">	 									
							</td>
							<td align="left">		
							
							</td>
						</tr>
						<tr>
							<td ></td>
							<td align="center">									
							<input id="upload_promotion" class="btn_box thickbox" type="button" lang="upload_img.jsp?id=<%=entity.getBranch_code() %>-5&height=100&width=200" value="Upload" title="Upload Promotion" >																									
							<input id="delete_promotion" class="btn_box" type="button"  value="Delete" title="Delete Promotion" onclick="return ajaxImgDelete(5);">																			
							</td>
							<td align="left"></td>
					  	</tr>	
					  	
					 <tr>
						 <td>
							<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
							<input type="hidden" name="id" >
							<input type="hidden" name="branch_code" value="<%=entity.getBranch_code()%>">
						 </td>
					</tr>						
					</table>
					</form>	
				
					
				</fieldset>
			</div>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>