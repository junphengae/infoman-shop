<%@page import="com.bitmap.bean.parts.PartCategories"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<%
	String group_id = WebUtils.getReqString(request, "group_id"); 
	String cat_id = WebUtils.getReqString(request, "cat_id"); 
	PartCategories entity = new PartCategories();
	entity.setCat_id(cat_id);
	entity.setGroup_id(group_id);
	entity = PartCategories.select(entity);
%>
<script type="text/javascript">
	$(function(){
		
		var $msg = $('#vendor_msg_error');
		var $form = $('#catEditForm');

		var v = $form.validate({
			submitHandler: function(){
				//if (confirm('ยืนยันการแก้ไขชนิด!')) {
					ajax_load();
					$.post('../PartManagement',$form.serialize(),function(data){
						ajax_remove();
						if (data.status == 'success') {
							$('select[name=cat_id]').children('option[value=<%=cat_id%>]').attr('text',$('#cat_name_th').val() + ' ' + $('#catEditForm #cat_name_short').val());
							tb_remove();
						} else {
							alert(data.message);
							$('#catEditForm #cat_name_short').focus();
						}
					},'json');
				//}
			}
		});
		
		$form.submit(function(){
			v;
			return false;
		});
	});
</script>
<div>
	<form id="catEditForm" action="" method="post" style="margin: 0;padding: 0;">
	<input type="hidden" name="create_by" id="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	<input type="hidden" name="cat_id" id="cat_id" value="<%=entity.getCat_id() %>">
	<input type="hidden" name="group_id" id="group_id" value="<%=entity.getGroup_id() %>">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="420px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>แก้ไขชนิด</h3></td></tr>
			<tr align="center" height="10px"><td colspan="2"></td></tr>
			<tr>
				<td align="left" width="25%"><label>ชื่อชนิด</label></td>
				<td align="left" width="75%">: 
				<input type="text" autocomplete="off" name="cat_name_th" id="cat_name_th" class="txt_box s200 required input_focus" value="<%=entity.getCat_name_th()%>"></td>
			</tr>
			<tr align="center" height="10px"><td colspan="2"></td></tr>
			<tr>
				<td><label>ชื่อย่อ</label></td>
				<td>: <input type="text" autocomplete="off" name="cat_name_short" id="cat_name_short" class="txt_box s200 required" value="<%=entity.getcat_name_short()%>" maxlength="10"></td>
			</tr>
			<tr align="left" height="25px"><td></td><td > <font color="red"> * ชื่อย่อ * ใส่ได้ไม่เกิน 10 ตัวอักษร</font></td></tr>
			<tr align="center" height="10px"><td colspan="2"></td></tr>
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="แก้ไข" class="btn_box btn_confirm">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="hidden" name="action" value="cat_edit">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
				</td>
			</tr>
		</tbody>
	</table>
	<div class="msg_error" id="vendor_msg_error"></div>
	</form>

</div>