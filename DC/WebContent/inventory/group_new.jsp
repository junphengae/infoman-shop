<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<script type="text/javascript">
	$(function(){
		var $msg = $('#vendor_msg_error');
		var $form = $('#groupForm');

		var v = $form.validate({
			submitHandler: function(){
				ajax_load();
				$.post('../MaterialManage',$form.serialize(),function(json){
					ajax_remove();
					if (json.status == 'success') {
						$('select[name=group_id]').append('<option value="' + json.group_id + '">' + json.group_name_th + ' '+ json.group_name_en + '</option>').val(json.group_id);
						$('#edit_group').fadeIn(500).attr('lang', 'group_edit.jsp?height=300&width=520&group_id=' + json.group_id);
						$('#new_cat').fadeIn(500).attr('lang','cat_new.jsp?height=300&width=520&group_id=' + json.group_id);
						tb_remove();
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
	<form id="groupForm" action="" method="post" style="margin: 0;padding: 0;">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="420px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>เพิ่มกลุ่ม</h3></td></tr>
			<tr align="center" height="10px"><td colspan="2"></td></tr>
			<tr>
				<td align="left" width="20%"><label>ชื่อกลุ่ม</label></td>
				<td align="left" width="80%">: <input type="text" autocomplete="off" name="group_name_th" id="group_name_th" class="txt_box s180 required input_focus"></td>
			</tr>
			<tr align="center" height="10px"><td colspan="2"></td></tr>
			<tr>
				<td><label>ชื่อย่อ</label></td>
				<td>: <input type="text" autocomplete="off" name="group_name_en" id="group_name_en" class="txt_box s180 required" ></td>
			</tr>
			<tr align="center" height="10px"><td colspan="2"></td></tr>
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="บันทึก" class="btn_box btn_confirm">
					<input type="hidden" name="action" value="group_add">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
					<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>"> 
				</td>
			</tr>
		</tbody>
	</table>
	<div class="msg_error" id="vendor_msg_error"></div>
	</form>

</div>