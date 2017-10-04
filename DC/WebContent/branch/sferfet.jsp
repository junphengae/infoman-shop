<%@page import="com.bitmap.bean.branch.*"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<%
BranchMaster entity = new BranchMaster();
WebUtils.bindReqToEntity(entity, request);
BranchMaster.select(entity);
%>
<script type="text/javascript">
	$(function(){
		var $msg = $('#vendor_msg_error');
		var $form = $('#groupForm');

		var v = $form.validate({
			submitHandler: function(){
				ajax_load();
				$.post('../BranchManagement',$form.serialize(),function(json){
					ajax_remove();
					if (json.status == 'success') {
						if (json.status == 'success') {
							alert(json.branch_id);
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
			<tr align="center" height="25"><td colspan="2"><h3>แก้ไขสาขา</h3></td></tr>
			<tr align="center" height="10px"><td colspan="2"></td></tr>
			<tr>
				<td align="left" width="20%"><label>รหัสสาขา</label></td>
				<td align="left" width="80%">: <input type="text" autocomplete="off" name="branch_code" id="branch_code" class="txt_box s200 required input_focus" value="<%=entity.getBranch_code()%>"></td>
			</tr>
			<tr align="center" height="10px"><td colspan="2"></td></tr>
			<tr>
				<td><label>ชื่อสาขา</label></td>
				<td>: <input type="text" autocomplete="off" name="branch_name" id="branch_name" class="txt_box s200 required" value="<%=entity.getBranch_name()%>" maxlength="4"></td>
			</tr>
			<tr align="left" height="25px"><td></td><td > <font color="red"> * ชื่อย่อ * ใส่ได้ไม่เกิน 4 ตัวอักษร</font></td></tr>
			<tr align="center" height="10px"><td colspan="2"></td></tr>
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="บันทึก" class="btn_box btn_confirm">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 		<input type="hidden" name="action" value="edit_Branch"> 	
				<!--  	<input type="hidden" name="action" value="add_branch"> -->
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
					<input type="hidden" name="create_by" value="<%=entity.getCreate_by()%>">
					<input type="hidden" name="group_id" value="<%=entity.getBranch_id()%>">
				</td>
			</tr>
		
		</tbody>
	</table>
	<div class="msg_error" id="vendor_msg_error"></div>
	</form>

</div>






