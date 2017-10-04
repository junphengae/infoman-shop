<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script src="../js/jquery.validate.js" type="text/javascript"></script>
<%
String dep_id = WebUtils.getReqString(request,"dep_id");
String dep_name = WebUtils.getReqString(request ,"dep_name");


%>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<script>
	$(function(){
		var $msg = $('.msg_error');
		var $form = $('#infoForm');
		
		var v = $form.validate({
			submitHandler: function(){
				ajax_load();
				var addData = $form.serialize();
				$.post('../OrgManagement',addData,function(resData){
					ajax_remove();
					
					if (resData.status == "success") {
					
						 if (resData.check == 'Name') {
							alert("ชื่อฝ่าย(ไทย,อังกฤษ) ซ้ำ!");
						}
						if (resData.check == 'Name_th') {
							alert("ชื่อฝ่าย(ไทย) ซ้ำ!");
						}
						if (resData.check == 'Name_en') {
							alert("ชื่อฝ่าย(อังกฤษ) ซ้ำ!");
						}
						if (resData.check == 'success') {
							alert("เพิ่มข้อมูลฝ่ายเรียบร้อยแล้ว");
							//$msg.text('Add new department successful!').show();
							window.location.reload();
						}
						
						
					} else {
						$msg.text('Error: ' + resData.message).show();
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
	<form id="infoForm" style="margin: 0;padding: 0;">
	<input type="hidden" name="create_by" id="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="455px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>Add New Department</h3></td></tr>
			<tr>
				<td width="30%"><label>ชื่อฝ่าย (ไทย)</label></td>
				<td align="left">: <input type="text" autocomplete="off" name="dep_name_th" id="dep_name_th" class="txt_box s200 required" title="Please insert Thai Department Name!"></td>
			</tr>
			<tr>
				<td><label>Department Name (Eng)</label></td>
				<td align="left">: <input type="text" autocomplete="off" name="dep_name_en" id="dep_name_en" class="txt_box s200 required" title="Please insert English Department Name!"></td>
			</tr>
			
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="Add" class="btn_box btn_confirm">
					<input type="hidden" name="action" value="add_dep">
					<input type="reset" onclick="tb_remove();" value="Cancel" class="btn_box">
				</td>
			</tr>
		</tbody>
	</table>
	<div class="msg_error"></div>
	</form>

</div>