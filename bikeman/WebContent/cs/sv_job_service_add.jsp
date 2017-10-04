<%@page import="com.bitmap.bean.parts.ServiceRepairDetail"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="../js/common.js"></script>
<script src="../js/validator.js"></script>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<form id="service_add_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%" class="center" id="tb_material_add" border="0" cellpadding="4" cellspacing="4">
		<tbody>
			<tr>
				<td width="25%" align="left"><font color="red">*</font>Service Detail</td>
				<td width="75%" align="left">: &nbsp;&nbsp;&nbsp;
				<select name="labor" id="labor" onchange="changeService(this.value);">
						<option value="0" >เลือกการบริการ</option>
						<option value="1" >เปลี่ยนถ่ายน้ำมันเครื่องและไส้กรอง</option>
						<option value="2" >เปลี่ยนยางนอก  - ใน</option>
						<option value="3" >ถอดประกอบชิ้นส่วนอะไหล่เครื่องยนต์</option>
						<option value="4" >ถอดประกอบชิ้นส่วนอะไหล่ภายนอก</option>
						<option value="5" >ค่าบริการล้างทำความสะอาดชิ้นส่วน (ไม่รวมค่าน้ำมันล้าง)</option>
						<option value="6" >งานบริการยกเว้นค่าแรง</option>
				</select>
									
				<input type="hidden"  name="labor_id"  id="labor_id"  value="0"/>
				<input type="hidden" name="labor_name" id="labor_name" value=""/>
				</td>
			</tr>
			<!-- <tr>
				<td align="left">Hour</td>
				<td align="left">: <input type="text" name="labor_qty" id="labor_qty" class="txt_box required" title="*" autocomplete="off"></td>
			</tr> -->
			<tr>
				<td align="left"><font color="red">*</font>Price</td>
				<td align="left">: &nbsp;&nbsp;&nbsp;<input type="text" name="labor_rate" id="labor_rate" class="txt_box" autocomplete="off" value="0" onblur="calculateNetPrice()" onchange="calculateNetPrice()" onkeyup="return validCurrencyOnKeyUp(this, event)"></td>
			</tr>
			<tr>
							<td align="left"><Strong>Discount % </Strong></td>
							<td align="left">: &nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="discount" id="discount_percen" class="txt_box s40"  autocomplete="off"  value="0"  class="txt_box  " onblur="calculateDiscount()" onchange="return validCurrencyOnKeyUp(this, event)" > %
							&nbsp;&nbsp;&nbsp;
							 คิดเป็นเงิน : 
							 <span id="spd_dis2">0</span>
							 <input type="hidden" name="srd_dis" id="srd_dis" class="txt_box s40"  autocomplete="off"  value="0"  class="txt_box"> บาท
							</td>	
						</tr>
						<tr>
							<td align="left"><Strong>Discount เงินสด </Strong></td>
							<td align="left">: &nbsp;&nbsp;&nbsp;
							<input type="text" name="cash_discount" id="cash_discount" class="txt_box s40"  autocomplete="off"  value="0"  class="txt_box" onblur="calculateTotalDiscount()" onchange="return validCurrencyOnKeyUp(this, event)" >
							  บาท
							</td>	
						</tr>
						<tr>
							<td align="left"><Strong>รวมเงินส่วนลด </Strong></td>
							<td align="left">: &nbsp;&nbsp;&nbsp;&nbsp;
								<span id="srd_dis_total_txt">0</span>  บาท
								<input type="hidden" name="srd_dis_total" id="srd_dis_total" class="txt_box s40"  autocomplete="off"  value="0"  class="txt_box" >
							 </td>
						
						</tr>
						<tr>
							<td align="left"><Strong>รวมยอดเงินชำระ </Strong></td>
							<td align="left">: &nbsp;&nbsp;&nbsp;&nbsp;
								<span id="srd_net_price_txt">0</span>  บาท
								<input type="hidden" name="srd_net_price" id="srd_net_price" class="txt_box s40"  autocomplete="off"  value="0"  class="txt_box" > </td>
						
						</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
	/*  onkeyUp  validate Number  */
	function validCurrencyOnKeyUp(thisObj, thisEvent) {
		  var temp = thisObj.value;
		  temp = currencyToNumber(temp); // convert to number
		  thisObj.value = formatCurrency(temp);// convert to currency forma
	}

	function validNumberOnKeyUp(thisObj, thisEvent) {
		  var temp = thisObj.value;
		  temp = currencyToNumber(temp); // convert to number
		  thisObj.value = formatIntegerWithComma(temp);// convert to currency format
	}

	
	function calculateDiscount() {
		var percen_discount = $('#discount_percen').val();
		var discount_amount = (parseFloat($('#labor_rate').val()) * percen_discount) / 100 ;
		$('#srd_dis').val(discount_amount);
		$('#srd_dis2').text(discount_amount);
		calculateTotalDiscount();
		
	}
	
	function calculateTotalDiscount() {
		var total_discount = parseFloat($('#srd_dis').val()) + parseFloat($('#cash_discount').val());
		$('#srd_dis_total').val(total_discount);
		$('#srd_dis_total_txt').text(total_discount);
		calculateNetPrice();
	}

	function calculateNetPrice() {
	
		var net_price = parseFloat($('#labor_rate').val()) - $('#srd_dis_total').val();
		if(net_price<0){
			alert('ส่วนลดมากกว่าราคารวม');
			return true;
		}else{
			$('#srd_net_price_txt').text(net_price);
			$('#srd_net_price').val(net_price);
		}
	}
	function changeService(value){
		
		
		if(value == '1'){
			document.getElementById('labor_id').value = "SV 01/001";
			document.getElementById('labor_name').value = "เปลี่ยนถ่ายน้ำมันเครื่องและไส้กรอง";
			document.getElementById('labor_rate').value = "20.00";
		}else if(value == '2'){
			document.getElementById('labor_id').value = "SV 02/001";
			document.getElementById('labor_name').value = "เปลี่ยนยางนอก – ใน ";
			document.getElementById('labor_rate').value = "60.00";
		}else if(value == '3'){
			document.getElementById('labor_id').value = "SV 02/002";
			document.getElementById('labor_name').value = "ถอดประกอบชิ้นส่วนอะไหล่เครื่องยนต์";
			document.getElementById('labor_rate').value = "80.00";
		}else if(value == '4'){
			document.getElementById('labor_id').value = "SV 02/003";
			document.getElementById('labor_name').value = "ถอดประกอบชิ้นส่วนอะไหล่ภายนอก";
			document.getElementById('labor_rate').value = "80.00";
		}else if(value == '5'){
			document.getElementById('labor_id').value ="SV 02/004";
			document.getElementById('labor_name').value = "ค่าบริการล้างทำความสะอาดชิ้นส่วน (ไม่รวมค่าน้ำมันล้าง)";
			document.getElementById('labor_rate').value = "100.00";
		}else if(value == '6'){
			document.getElementById('labor_id').value ="SV 10/001";
			document.getElementById('labor_name').value = "งานบริการยกเว้นค่าแรง";
			document.getElementById('labor_rate').value = "0.00";
		}
		
	}
	
	$(function(){
	
	

		
		$('#discount_percen').keyup(function(e) {
				//match ints and floats/decimals
				var floatRegex = '[-+]?([0-9]*\.[0-9]+|[0-9]+)';
				var data = $(this).val();
				if (e.keyCode == '13') {
					if (!data == '') {
						$('#material_add_form .btn_confirm').submit();
					}
				} else if (!data.match(floatRegex)) {
					alert('จำนวนกรอกตัวเลขเท่านั้น ');
					$(this).val('0');
					$('#discount').focus();
				}
			});
		$('#cash_discount').keyup(function(e) {
				//match ints and floats/decimals
				var floatRegex = '[-+]?([0-9]*\.[0-9]+|[0-9]+)';
				var data = $(this).val();
				if (e.keyCode == '13') {
					if (!data == '') {
						$('#material_add_form .btn_confirm').submit();
					}
				} else if (!data.match(floatRegex)) {
					alert('จำนวนกรอกตัวเลขเท่านั้น ');
					$(this).val('0');
					$('#cash_discount').focus();
				}
			});

		$('#service_add_form .btn_confirm').dblclick(function() {
			return false;
			});
				 
			var form = $('#service_add_form');
			/*material Form*/
			var v = form.validate({
				submitHandler : function() {
					if(calculateNetPrice()){
						return false;
					}
					
					if ($('#labor').val() != "0") {
						if (isNumber($('#labor_rate').val())) {
							if (isNumber($('#discount').val())) {
								ajax_load();
								
								$.post('../PartSaleManage', form.serialize(),function(resData) {								
											ajax_remove();
											if (resData.status == 'success') {
												window.location.reload();
											} else {
												alert(resData.status);
											}
										}, 'json');
								
							} else {
								alert('โปรดตรวจสอบส่วนลด!');
								$('#discount').focus();
							}
						} else {
							alert('โปรดตรวจสอบราคา!');
							$('#labor_rate').focus();
						}
					} else {
						alert('โปรดเลือกประเภทงานบริการ');
						$('#labor').focus();
					}
				}
			});
			
			form.submit(function() {
				form.unbind('submit').submit();
				v;
				return false;
			});
		});
	</script>
	
	<div class="txt_center m_top20">
		<input type="hidden" name="vat" id="vat" value="<%=ServiceRepairDetail.SERVICE_VAT%>" > 
		<input type="hidden" name="total_vat" id="total_vat" value="0" > 
		<input type="hidden" name="id" value="<%=WebUtils.getReqString(request, "id")%>">
		<input type="submit" name="add"  class="btn_box btn_confirm" value="Submit">				
		<input type="button" class="btn_box btn_warn" value="Close Display" onclick="tb_remove();">				
		<input type="hidden" name="action" value="sale_service_add">
		<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>