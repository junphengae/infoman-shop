<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>

<script type="text/javascript">
	$(function() {
		var $msg = $('#type_msg_error');
		var $form = $('#typeForm');
		
		var v = $form.validate({
			submitHandler: function(){
				ajax_load();
				$.post('../MaterialManage',$form.serialize(),function(json){
					ajax_remove();
					if (json.status == 'success') {
						$('select[name=des_unit]').append('<option value="' + json.id + '">' + json.type_name + '</option>').val(json.id);
						$('#edit_unit_type').fadeIn(500).attr('lang', 'unit_type_edit.jsp?height=300&width=520&id=' + json.id);
						//$('#new_cat').fadeIn(500).attr('lang','cat_new.jsp?height=300&width=520&group_id=' + json.group_id);
						tb_remove();
						window.location="units_management.jsp";
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
	<form id="typeForm" action="" method="post" style="margin: 0;padding: 0;">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="485px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>เพิ่มหน่วยนับ</h3></td></tr>
			<tr>
				<td align="left" width="25%"><label>ชื่อหน่วยนับ</label></td>
				<td align="left" width="75%">: 
					<input type="text" autocomplete="off" name="type_name" id="type_name" title="โปรดระบุหน่วยนับ" class="txt_box s200 required input_focus">
				</td>
			</tr>
			
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="บันทึก" class="btn_box btn_confirm">
					<input type="hidden" name="action" value="unit_type_add">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
					<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>"> 
				</td>
			</tr>
		</tbody>
	</table>
	<div class="msg_error" id="type_msg_error"></div>
	</form>
</div>