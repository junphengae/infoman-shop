<%@page import="com.bitmap.bean.inventory.InventoryLotControl"%>
<%@page import="com.bitmap.bean.sale.Order"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>

<!-- Date -->
<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>


<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รับเข้าสินค้าหลังจากยกเลิกการขาย</title>
<%
String order_id = WebUtils.getReqString(request,"order_id");
Order entity = new Order();
entity.setOrder_id(order_id);
Order.select(entity);
InventoryLotControl invLot = InventoryLotControl.select(order_id);
%>
<script type="text/javascript">
$(function(){
	var mat = '<%=entity.getItem_id()%>';
	if(mat != '')
	check_material_load();

	$.metadata.setType("attr", "validate");
	var invoice_form = $('#invoice_form');
	var invoice_validate = invoice_form.validate({
		submitHandler: function(){
			if (confirm('ยืนยันการคืนสินค้า รหัส  <%=entity.getItem_id()%> เลขที่ Lot No. <%=invLot.getLot_no()%> \n\rเข้าสู่คลังสินค้า\n\r\n\r** คุณจะไม่สามารถแก้ไขข้อมูลการรับคืนได้หลังจากกดตกลง **')) {
				ajax_load();
				$.post('../InletManagement',invoice_form.serialize(),function(resData){
					ajax_remove();
					if (resData.status == 'success') {
						window.location='inlet_close_order.jsp';
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

function check_material_load(){

	var tb_check_mat = $('#tb_check_mat');
	var tb_show_mat = $('#tb_show_mat');
	var td_mat_code = $('#td_mat_code');
	var td_mat_description = $('#td_mat_description');
	var td_mat_location = $('#td_mat_location');
	var td_mat_fifo = $('#td_mat_fifo');
	var td_mat_std_unit = $('#td_mat_std_unit');
	var td_mat_des_unit = $('#td_mat_des_unit');
	var td_mat_unit_pack = $('#td_mat_unit_pack');
	var tb_lot_qty = $('#tb_lot_qty');
	var tb_input_invoice = $('#tb_input_invoice');
	var tb_serial = $('#tb_serial');
	
	var mat_code = $('#mat_code').val('<%=entity.getItem_id()%>');
	if (mat_code.val() != '') {
		$('#invoice_mat_code').val(mat_code.val());
		$('#product_mat_code').val(mat_code.val());
		ajax_load();
		$.post('../InletManagement',{'action': 'check_material_nopo','mat_code':mat_code.val()},function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				var mat = resData.material;
				tb_check_mat.hide();
				td_mat_code.append(mat.mat_code);
				td_mat_description.append(mat.description);
				td_mat_location.append(mat.location);
				td_mat_fifo.append((mat.fifo_flag == 'y')?'FIFO':'Non FIFO');
				td_mat_std_unit.append(mat.des_unit);
				tb_show_mat.show();
				$('#type_serial').val(mat.serial);
				if(mat.serial == 'y'){
					$('#lot_qty').val("1");
					tb_lot_qty.hide();
					tb_serial.show();
				}else{
					$('#lot_qty').val("");
					tb_lot_qty.show();
					tb_serial.hide();
				}
				tb_input_invoice.show();
				$('#tb_invoice_detail').show();
				
			}
		},'json');
	}
}
</script>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">
					รับเข้าสินค้าหลังจากยกเลิกการขาย | รายการขายเลขที่ <%=order_id%>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<table width="100%" id="tb_check_mat">
					<tbody>
						<tr>
							<td width="25%">รหัสสินค้า</td>
							<td width="75%">: 
								<input type="text" name="mat_code" id="mat_code" class="txt_box s150">
								<button class="btn_box" onclick="check_material();">ตรวจสอบ</button>
							</td>
						</tr>
					</tbody>
				</table>
						
				<table width="100%" id="tb_show_mat" class="hide">
					<tbody>
						<tr>
							<td width="25%">รหัสสินค้า</td>
							<td width="75%" id="td_mat_code">: </td>
						</tr>
						<tr>
							<td>ชื่อสินค้า</td>
							<td id="td_mat_description">: </td>
						</tr>
						<tr>
							<td>สถานที่เก็บ</td>
							<td id="td_mat_location">: </td>
						</tr>
						<tr>
							<td>ลักษณะการจัดเก็บ</td>
							<td id="td_mat_fifo">: </td>
						</tr>
						<tr>
							<td>หน่วยกลาง</td>
							<td id="td_mat_std_unit">: </td>
						</tr>
					</tbody>
				</table>
				
				<div class="m_top15"></div>
				
				<form id="invoice_form" onsubmit="return false">
					<table width="100%" class="hide" id="tb_invoice_detail">
						<tbody>
							<tr>
								<td width="25%">เลขที่การขาย</td>
								<td width="75%">: <%=order_id%></td>
							</tr>
<!-- 							<tr>
								<td width="25%">จำนวน</td>
								<td width="75%">: <input type="text" class="txt_box required" name="lot_qty" id="lot_qty" autocomplete="off" title="*ระบุจำนวน!"></td>
							</tr> -->
							<tr>
								<td width="25%">หมายเลข Serial</td>
								<td width="75%">: <%=entity.getSerial()%></td>
							</tr>
							<tr>
								<td width="25%">หมายเลข Lot No.</td>
								<td width="75%">: <%=invLot.getLot_no()%></td>
							</tr>
							<tr>
								<td colspan="2" align="center" height="30">
									<input type="submit" class="btn_box" value="รับคืน">
									<input type="hidden" name="action" value="inlet_cancel">
									<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
									<input type="hidden" name="mat_code" value="<%=entity.getItem_id()%>">
									<input type="hidden" name="lot_no" value="<%=invLot.getLot_no()%>">
									<input type="hidden" name="serial" value="<%=entity.getSerial()%>">
									<input type="hidden" name="order_id" value="<%=order_id%>">
								</td>
							</tr>
						</tbody>
					</table>
				</form>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
</body>
</html>