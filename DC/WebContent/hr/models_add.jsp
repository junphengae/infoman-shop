<%@page import="com.bitmap.bean.sale.Brands"%>
<%@page import="com.bitmap.security.SecurityUser"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.webutils.ReqRes" %>
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
<title>Models: </title>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="snc" %>
<script type="text/javascript">
	$(function(){
		var $msg = $('#msg_error');
		var $form = $('#infoForm');

		var v = $form.validate({
			submitHandler: function(){				
				var add = $form.serialize()+'&action=add_Models';
				alert("Name ชื่อรุ่น ซ้ำ !"+add);
				ajax_load();
				$.post('../ModelsManagement',add,function(json){
					ajax_remove();
					if (json.status == 'success') {
						
						if (json.check == 'Name') {
							alert("Name ชื่อรุ่น ซ้ำ !");
							var addData = $form.serialize() + '&action=add_Model_Brand';
							 if (confirm('ชื่อรุ่นนี้มีแล้วในยี่ห้ออื่น คุณต้องการสร้างซ้ำหรือไม่ !')) {
								 ajax_load();
								$.post('../ModelsManagement',addData , function(json){
									ajax_remove();
									if (json.status == 'success') {
										
										window.location="models_manage.jsp";
									}
						 		},'json');
							} 
							
						}
						if (json.check == 'NameBrand') {
							alert("ชื่อรุ่น ซ้ำ !");
						}
						else if (json.check == "success") {
							window.location="models_manage.jsp";
						}
							
					} else {
						alert(json.message);
					}
				},'json');
			}
		});
		
		$form.submit(function(){
			v;
			return false;
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
				<div class="left" >Create Models: </div>
				<div class="right">
					<button class="btn_box" type="button" onclick="history.back();">back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<form id="infoForm" name="infoForm" action="" method="post" style="margin: 0;padding: 0;">
					<table cellpadding="3" cellspacing="3" border="0" class="center s400">
						<tbody>
						<tr height="30px">
							<td width="30%"><Strong>Brand Name</Strong></td> 
							<td align="left">: 
							<bmp:ComboBox name="brand_id"  styleClass="txt_box s120 required" listData="<%=Brands.BrandDropdown()%>" value="" >
								<bmp:option value="" text="--กรุณาเลือก--"></bmp:option>
							</bmp:ComboBox>  
							<%-- <select autocomplete="off"  name="brand_id" id="brand_id"  class="txt_box s120 required" title="Please select Brand Name.">
							<option value="">--Select--</option>
							<%
							boolean has = false;

							Iterator ite = list.iterator();
							System.out.println(list.size());
							while(ite.hasNext()) {
							Brands entity = (Brands) ite.next();
							has = true;
							
							%>
							
							<option value="<%=entity.getBrand_id()%>"><%=entity.getBrand_name()%></option>
					
							<%}if(has == false){ %>
						
							<option value="">-- ไม่พบข้อมูล --</option>							<%} %>			
							
							</select> --%>
						
							</td>
						 </tr>
						<tr height="30px">
							<td width="30%"><Strong>Model Name</Strong></td>
							<td align="left">: 
							<input type="text" autocomplete="off" name="model_name" id="model_name"  class="txt_box s200 required" title="Please insert Model Name."> 
							</td>
						 </tr>
						
					
						 <tr> 
						 	<td colspan="2" height="10px">  </td> 
						 </tr>
						 <tr align="center" valign="bottom" height="20">	
								<td colspan="2">
									<input type="submit" id="btnAdd" value="Create" class="s70 btn_box ">
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								 	<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>"> 
									<input type="reset" value="Reset" class="s70 btn_box " onclick="$('#edit_vendor').hide();">
								</td>
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