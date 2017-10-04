<%@page import="com.bitmap.bean.parts.PartGroups"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<%
PartGroups entity = new PartGroups();
WebUtils.bindReqToEntity(entity, request);
PartGroups.select(entity);
%>
<script type="text/javascript">
	$(function(){
		var $msg = $('#vendor_msg_error');
		var $form = $('#groupForm');

		var v = $form.validate({
			submitHandler: function(){
				ajax_load();
				$.post('../PartManagement',$form.serialize(),function(json){
					ajax_remove();
					if (json.status == 'success') {
						$('select[name=group_id]').children('option[value=<%=entity.getGroup_id()%>]').attr('text',json.group_name_th + ' '+ json.group_name_en);
						
						tb_remove();
					} else {
						if(json.message == "Name"){
							alert("ชื่อกลุ่มและชื่อย่อ ซ้ำ!");
						}else if(json.message == "Name_th"){
							alert("ชื่อกลุ่ม ซ้ำ!");
						
						}else if(json.message == "Name_en"){
							alert("ชื่อย่อ ซ้ำ!");
						}else{
							alert(json.message);
						}
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
	<form id="groupForm" action="" method="post" style="margin: 0;padding: 0;">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="420px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>เพิ่มกลุ่ม</h3></td></tr>
			<tr align="center" height="10px"><td colspan="2"></td></tr>
			<tr>
				<td align="left" width="20%"><label>ชื่อกลุ่ม</label></td>
				<td align="left" width="80%">: <input type="text" autocomplete="off" name="group_name_th" id="group_name_th" class="txt_box s200 required input_focus" value="<%=entity.getGroup_name_th()%>"></td>
			</tr>
			<tr align="center" height="10px"><td colspan="2"></td></tr>
			<tr>
				<td><label>ชื่อย่อ</label></td>
				<td>: <input type="text" autocomplete="off" name="group_name_en" id="group_name_en" class="txt_box s200 required" value="<%=entity.getGroup_name_en()%>" maxlength="10"></td>
			</tr>
			<tr align="left" height="25px"><td></td><td > <font color="red"> * ชื่อย่อ * ใส่ได้ไม่เกิน 10 ตัวอักษร</font></td></tr>
			<tr align="center" height="10px"><td colspan="2"></td></tr>
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="บันทึก" class="btn_box btn_confirm">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="hidden" name="action" value="group_edit">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
					<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
					<input type="hidden" name="group_id" value="<%=entity.getGroup_id()%>">
				</td>
			</tr>
		</tbody>
	</table>
	<div class="msg_error" id="vendor_msg_error"></div>
	</form>

</div>