<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="snc" %>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<script type="text/javascript">
	$(function(){
		var $msg = $('#vendor_msg_error');
		var $form = $('#vendorForm');

		var v = $form.validate({
			submitHandler: function(){
				add();
			}
		});
		
		$form.submit(function(){
			v;
			return false;
		});
		
		function add(){
			var addData = $form.serialize();
			$.post('../PartManagement',addData,function(data){addSuccess(data);},'json');
		}
		
		function addSuccess(data){
			if (data.status.indexOf('success') == -1) {
				$msg.text(data.message).show();
			} else {
				$msg.text('Add new Vendor: ' + data.status).show();
				$('select[name=vendor_id]').append('<option value="' + data.vendor_id + '">' + data.vendor_name + '</option>');
				$('select[name=vendor_id]').val(data.vendor_id);
				var attr = 'vendor_edit.jsp?height=330&width=520&modal=true&vendor_id=' + data.vendor_id;
				$('#edit_vendor').attr('lang',attr).fadeIn(500);
				tb_remove();
			}
		}
	});
</script>
<div>
	<form id="vendorForm" action="" method="post" style="margin: 0;padding: 0;">
	<input type="hidden" name="create_by" id="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="485px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>Add Vendor Information</h3></td></tr>
			<tr>
				<td align="left" width="25%"><label>Vendor Name</label></td>
				<td align="left" width="75%">: <input type="text" autocomplete="off" name="vendor_name" id="vendor_name" class="txt_box s150 input_focus required"></td>
			</tr>
			<tr>
				<td><label>Tel.</label></td>
				<td>: <input type="text" autocomplete="off" name="vendor_phone" id="vendor_phone" class="txt_box s200"></td>
			</tr>
			<tr>
				<td><label>Fax</label></td>
				<td>: <input type="text" autocomplete="off" name="vendor_fax" id="vendor_fax" class="txt_box s200"></td>
			</tr>
			<tr>
				<td><label>Address</label></td>
				<td>: <input type="text" autocomplete="off" name="vendor_address" id="vendor_address" class="txt_box s200"></td>
			</tr>
			<tr>
				<td valign="top"><label>Email</label></td>
				<td valign="top">: <input type="text" autocomplete="off" name="vendor_email" id="vendor_email" class="txt_box s200 email"></td>
			</tr>
			<tr>
				<td><label>Contact</label></td>
				<td>: <input type="text" autocomplete="off" name="vendor_contact" id="vendor_contact" class="txt_box s200"></td>
			</tr>
			<tr>
				<td><label>Transportation</label></td>
				<td>: 
					<snc:ComboBox name="vendor_ship" styleClass="txt_box s100">
						<snc:option value="sea" text="Sea"></snc:option>
						<snc:option value="air" text="Air"></snc:option>
						<snc:option value="land" text="Land"></snc:option>
					</snc:ComboBox>
				</td>
			</tr>
			<tr>
				<td><label>Delivery Condition</label></td>
				<td>: <input type="text" autocomplete="off" name="vendor_condition" id="vendor_condition" class="txt_box s200"></td>
			</tr>
			<tr>
				<td><label>Credit</label></td>
				<td>: <input type="text" autocomplete="off" name="vendor_credit" id="vendor_credit" class="txt_box s200"></td>
			</tr>
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="บันทึก" class="btn_box">
					<input type="hidden" name="action" value="vendor_add">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
				</td>
			</tr>
		</tbody>
	</table>
	<div class="msg_error" id="vendor_msg_error"></div>
	</form>

</div>