<%@page import="com.lowagie.text.pdf.hyphenation.TernaryTree.Iterator"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.sale.Brands"%>
<%@page import="java.util.Map"%>
<%@page import="com.bitmap.bean.sale.Models"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<%
Models entity = new Models();
WebUtils.bindReqToEntity(entity, request);
Models.select(entity); 

String brand_id = WebUtils.getReqString(request, "brand_id");



%>
<script type="text/javascript">
	$(function(){
		var $msg = $('#vendor_msg_error');
		var $form = $('#groupForm');
		
		var v = $form.validate({
			
			submitHandler: function(){
				var add = $form.serialize() + '&action=edit_Models';
				ajax_load();
				$.post('../ModelsManagement',add,function(json){
					ajax_remove();
					if (json.status == 'success') {
						
						if (json.check == 'Name') {
							
							var addData = $form.serialize() + '&action=edit_Model_Brand';
							 if (confirm('ชื่อรุ่นนี้มีแล้วในยี่ห้ออื่น คุณต้องการสร้างซ้ำหรือไม่ !')) {
								 ajax_load();
								$.post('../ModelsManagement',addData , function(json){
									ajax_remove();
									if (json.status == 'success') {
										
										window.location="models_manage.jsp";
									}
						 		},'json');
							} 
							
						}else if (json.check =="NameBrand") {
							alert("ชื่อรุ่น ซ้ำ !");
						}else if (json.check =="success") {
							alert("แก้ไขเรียบร้อยแล้ว");
							window.location.reload();
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
<div>
	<fieldset class="fset s400 left min_h160">
					<legend><Strong>Update Model Information</Strong></legend>

	<form id="groupForm" action="" method="post" style="margin: 0;padding: 0;">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="400px">
		<tbody>
			
			<tr align="center" height="10px"><td colspan="2"></td></tr>
			<tr>
				<td align="left" width="20%"><Strong>Brand Name</Strong></td>
				<td align="left" width="80%">:
				  <bmp:ComboBox name="brand_id" styleClass="txt_box s100 required " listData="<%=Brands.BrandDropdown()%>" value="<%=brand_id%>" >
							<bmp:option value="" text="--กรุณาเลือก--"></bmp:option>
					
				</bmp:ComboBox>  
				</td>
			</tr>
			<tr>
				<td><label><Strong>Model Name</Strong></label></td>
				<td>: <input type="text" autocomplete="off" name="model_name" id="model_name" class="txt_box s150 required" value="<%=entity.getModel_name()%>" ></td>
			</tr>
			<tr></tr>
			<tr>
				<%-- <td align="left" width="20%"><label><Strong>Model Code</Strong></label></td>
				<td align="left" width="80%">: <%=entity.getModel_id()%> --%>
				<input type="hidden"  name="model_id" id="model_id"  value="<%=entity.getModel_id()%>"></td>
			</tr>
			
			
			<tr align="center" height="10px"><td colspan="2"></td></tr>
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="Update" class="btn_box btn_confirm">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					
					<input type="reset" onclick="tb_remove();" value="Cancel" class="btn_box">
					<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>"> 
					<input type="hidden" name="id" value="<%=entity.getId() %>">
				</td>
			</tr>
		</tbody>
	</table>
	<div class="msg_error" id="vendor_msg_error"></div>
	</form>
</fieldset>
</div>