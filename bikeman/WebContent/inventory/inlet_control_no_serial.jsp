<%@page import="com.bitmap.bean.util.ImagePathUtils"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src="../js/number.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<%
PurchaseRequest pr = new PurchaseRequest();
WebUtils.bindReqToEntity(pr, request);
PurchaseRequest.select4Inlet(pr);
InventoryMaster master = pr.getUIInvMaster();


%>

<div class="m_top10"></div>

<fieldset class="fset min_h180 left s400">
	<legend>รายละเอียดสินค้า</legend>
	<table width="100%" cellspacing="10">
		<tbody>
			<tr>
				<td width="35%">สินค้า</td>
				<td width="65%">: <%=pr.getMat_code()%> &nbsp;-&nbsp;<%=InventoryMaster.selectOnlyDescrip(pr.getMat_code())%></td>
			</tr>
			<tr>
				<td>สถานที่เก็บ</td>
				<td>: <%=master.getLocation()%></td>
			</tr>
			<tr>
				<td>ลักษณะการจัดเก็บ</td>
				<td>: <%=(master.getFifo_flag().equalsIgnoreCase("y")?"FIFO":"Non FIFO")%></td>
			</tr>
			<tr>
				<td>หน่วยกลาง</td>
				<td>: <%=master.getDes_unit()%></td>
			</tr>
		</tbody>
	</table>
</fieldset>

<fieldset class="s330 min_h180 right fset">
	<legend>รูปสินค้า</legend>
	
	<div id="div_img" class="center txt_center">
		<img class="center txt_center" style="width: 200px; max-height: 180px; box-shadow: 0 0px 3px rgba(0,0,0,0.3);" src="<%=ImagePathUtils.img_path%>/inventory/<%=pr.getMat_code()%>.jpg?state=<%=Math.random()%>">
	</div>
	<div class="clear"></div>
</fieldset>

<div class="clear"></div>

<script type="text/javascript">
$(function(){
	$('#lot_expire').datepicker({
		showOtherMonths : true,
		slectOtherMonths : true,
		changeYear : true,
		changeMonth : true,
		yearRange: 'c-5:c+10'
	});
	
	$.metadata.setType("attr", "validate");
	var invoice_form = $('#invoice_form');
	var invoice_validate = invoice_form.validate({
		submitHandler: function(){
			if (confirm('ยืนยันการนำเข้าสินค้า หมายเลข ' + $('#mat_code').val() + '\n\r\n\r -- จำนวน ' + $('#invoice_form #lot_qty').val() + '<%=master.getDescription()%> เข้าสู่คลังสินค้า -- \n\r\n\r** คุณจะไม่สามารถแก้ไขข้อมูลการนำเข้าได้หลังจากกดตกลง **')) {
				ajax_load();
				$.post('../InletManagement',invoice_form.serialize(),function(resData){
					ajax_remove();
					if (resData.status == 'success') {
						window.location='inlet_info.jsp?lot_no=' + resData.LOT.lot_no + '&mat_code=' + resData.LOT.mat_code + '&po=<%=pr.getPo()%>';
					} else {
						alert(resData.message);
					}
				},'json');
			}
		}
	});
	
	invoice_form.submit(function(){
		invoice_validate;
		return false;
	});
});
</script>

<fieldset class="fset">
	<legend>รายละเอียดการรับเข้า</legend>
	<form id="invoice_form" onsubmit="return false">
		<table width="100%" id="tb_invoice_detail">
			<tbody>
				<tr>
					<td width="20%">เลขที่ใบแจ้งหนี้</td>
					<td width="80%">: <input type="text" class="txt_box required" name="invoice" id="invoice" autocomplete="off" title="*"></td>
				</tr>
				<tr>
					<td>จำนวน</td>
					<td>: <input type="text" class="txt_box required" name="lot_qty" id="lot_qty" autocomplete="off" title="*ระบุ จำนวน!"></td>
				</tr>
				<tr>
					<td valign="top">ราคาต่อหน่วย</td>
					<td valign="top">: <%=pr.getOrder_price()%>
					</td>
				</tr>
				<tr><td colspan="2" align="center" height="20"></td></tr>
				<tr>
					<td>รหัสสินค้าของตัวแทน</td>
					<td>: <input type="text" name="vendor_mat_code" class="txt_box" autocomplete="off"></td>
				</tr>
				<tr>
					<td>เลขที่ Lot ของตัวแทน</td>
					<td>: <input type="text" name="vendor_lot_no" class="txt_box" autocomplete="off"></td>
				</tr>
				<tr>
					<td>วันหมดอายุ</td>
					<td>: <input type="text" name="lot_expire" id="lot_expire" class="txt_box" autocomplete="off"></td>
				</tr>
				<tr>
					<td>หมายเหตุ</td>
					<td>: <input type="text" class="txt_box s400" name="note" autocomplete="off"></td>
				</tr>
				<tr>
					<td colspan="2" align="center" height="30">
						<button type="submit" name="add" class="btn_box">รับเข้า</button>
						<button type="button" name="close" class="btn_box" onclick="tb_remove();">ปิด</button>
						<input type="hidden" name="action" value="inlet_invoice">
						<input type="hidden" name="vendor_id" value="<%=pr.getVendor_id()%>">
						<input type="hidden" name="po" value="<%=pr.getPo()%>">
						<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
						<input type="hidden" name="mat_code" id="mat_code" value="<%=pr.getMat_code()%>">
						<input type="hidden" name="lot_price" id="lot_price" value="<%=pr.getOrder_price()%>">
						
					</td>
				</tr>
			</tbody>
		</table>
	</form>
</fieldset>