<%@page import="com.bitmap.servlet.purchase.VendorManage"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<script type="text/javascript">
function  checkNumber_phone(data){
	  if(!data.value.match(/^\d*$/)){
		  
		  		alert("กรอกหมายเลขโทรศัพท์ เป็นตัวเลขเท่านั้น");
				data.value='';
				$('#branch_postalcode').focus();
	  }
}
function  checkNumber_fax(data){
	  if(!data.value.match(/^\d*$/)){
				alert("กรอกหมายเลขแฟ็กซ์ เป็นตัวเลขเท่านั้น");
				data.value='';
			 	$('#branch_fax').focus();
	  }
}
	$(function(){
		var $form = $('#vendorForm');

		$.metadata.setType("attr", "validate");
		var v = $form.validate({
			submitHandler: function(){
				ajax_load();
				$.post('../VendorManage',$form.serialize(),function(json){
					ajax_remove();
					if (json.status == 'success') {
						window.location.reload();
					} else {
						
						if (json.message == "Name") {
							
							alert("ชื่อตัวแทนจำหน่าย ซ้ำ!")
							
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
	<form id="vendorForm" action="" method="post" style="margin: 0;padding: 0;">
	<input type="hidden" name="create_by" id="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="485px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>เพิ่มข้อมูลตัวแทนจำหน่าย</h3></td></tr>
			<tr>
				<td align="left" width="25%"><label>ชื่อตัวแทนจำหน่าย</label></td>
				<td align="left" width="75%">: <input type="text" autocomplete="off" name="vendor_name" id="vendor_name"  class="txt_box s150 input_focus required" title="*"></td>
			</tr>
		
			<tr>
				<td><label>โทรศัพท์</label></td>
				<td>: <input type="text" autocomplete="off" onkeyup='checkNumber_phone(this)' name="vendor_phone" maxlength="10" id="vendor_phone" class="txt_box s200"></td>
			</tr>
			<tr>
				<td><label>แฟกซ์</label></td>
				<td>: <input type="text" autocomplete="off" onkeyup='checkNumber_fax(this)' name="vendor_fax" maxlength="10"  id="vendor_fax" class="txt_box s200"></td>
			</tr>
			<tr>
				<td><label>ที่อยุ่</label></td>
				<td>: <input type="text" autocomplete="off" name="vendor_address" id="vendor_address" class="txt_box s200"></td>
			</tr>
			<tr>
				<td valign="top"><label>Email</label></td>
				<td valign="top">: <input type="text" autocomplete="off" name="vendor_email" id="vendor_email" class="txt_box s200 email"></td>
			</tr>
			<tr>
				<td><label>ชื่อผู้ติดต่อ</label></td>
				<td>: <input type="text" autocomplete="off" name="vendor_contact" id="vendor_contact" class="txt_box s200"></td>
			</tr>
			<tr>
				<td><label>เงื่อนไขการจัดส่ง</label></td>
				<td>: <input type="text" autocomplete="off" name="vendor_condition" id="vendor_condition" class="txt_box s200"></td>
			</tr>
			<tr>
				<td><label>เครดิต</label></td>
				<td>: <input type="text" autocomplete="off" name="vendor_credit" id="vendor_credit" class="txt_box s200"></td>
			</tr>
			<tr>
				<td><label>ประเภทการขนส่ง</label></td>
				<td>: 
					<bmp:ComboBox name="vendor_ship" styleClass="txt_box s100">
						<bmp:option value="land" text="ทางบก"></bmp:option>
						<bmp:option value="sea" text="ทางเรือ"></bmp:option>
						<bmp:option value="air" text="ทางอากาศ"></bmp:option>
					</bmp:ComboBox>
				</td>
			</tr>
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="บันทึก" class="btn_box btn_confirm">
					<input type="hidden" name="action" value="vendor_add">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
				</td>
			</tr>
		</tbody>
	</table>
	</form>

</div>