<%@page import="com.bitmap.bean.parts.ServiceOtherDetail"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="../js/common.js"></script>
<script src="../js/validator.js"></script>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%
ServiceOtherDetail entity = new ServiceOtherDetail();
WebUtils.bindReqToEntity(entity, request);
ServiceOtherDetail.select(entity);
%>
<form id="update_other_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%" class="center" id="tb_material_add" border="0" cellpadding="4" cellspacing="4">
		<tbody>
			<tr>
				<td width="25%" align="left">Miscellaneous</td>
				<td width="75%" align="left">: <input type="text" name="other_name" id="other_name" value="<%=entity.getOther_name()%>" class="txt_box s280 required input_focus" title="*" autocomplete="off"></td>
			</tr>
			<tr>
				<td align="left">Qty</td>
				<td align="left">: <input type="text" name="other_qty" id="other_qty" value="<%=entity.getOther_qty()%>" class="txt_box required" title="*" autocomplete="off" onblur="calculateDiscount()" onchange="return validNumberOnKeyUp(this, event)"></td>
			</tr>
			<tr>
				<td align="left">Price</td>
				<td align="left">: <input type="text" name="other_price" id="other_price" value="<%=entity.getOther_price()%>" class="txt_box required" title="*" autocomplete="off" onblur="calculateDiscount()" onchange="return validCurrencyOnKeyUp(this, event)"></td>
			</tr>
			<tr>
				<td align="left"><Strong>Discount % </Strong></td>
				<td align="left">: &nbsp;&nbsp;&nbsp;&nbsp;<input type="text"
					name="discount" id="discount_percen" class="txt_box s40"
					autocomplete="off" value="<%=entity.getDiscount()%>" class="txt_box  "
					onblur="calculateDiscount()" onchange="return validCurrencyOnKeyUp(this, event)"> % &nbsp;&nbsp;&nbsp;
					คิดเป็นเงิน : <span id="sod_dis_txt">0</span> <input type="hidden"
					name="sod_dis" id="sod_dis" class="txt_box s40" autocomplete="off"
					value="0" class="txt_box"> บาท
				</td>
			</tr>
			<tr>
				<td align="left"><Strong>Discount เงินสด </Strong></td>
				<td align="left">: &nbsp;&nbsp;&nbsp; <input type="text"
					name="cash_discount" id="cash_discount" class="txt_box s40"
					autocomplete="off" value="<%=entity.getCash_discount()%>" class="txt_box"
					onblur="calculateTotalDiscount()" onchange="return validCurrencyOnKeyUp(this, event)"> บาท
				</td>
			</tr>
			<tr>
				<td align="left"><Strong>รวมเงินส่วนลด </Strong></td>
				<td align="left">: &nbsp;&nbsp;&nbsp;&nbsp; <span
					id="sod_dis_total_txt">0</span> บาท <input type="hidden"
					name="sod_dis_total" id="sod_dis_total" class="txt_box s40"
					autocomplete="off" value="0" class="txt_box">
				</td>

			</tr>
			<tr>
				<td align="left"><Strong>รวมยอดเงินชำระ </Strong></td>
				<td align="left">: &nbsp;&nbsp;&nbsp;&nbsp; <span
					id="sod_net_price_txt">0</span> บาท <input type="hidden"
					name="sod_net_price" id="sod_net_price" class="txt_box s40"
					autocomplete="off" value="0" class="txt_box">
				</td>

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

	
	$( document ).ready(function() {
		calculateDiscount();
	});
	
	function calculateDiscount() {
		var percen_discount = $('#discount_percen').val();
		
		var discount_amount = (($('#other_price').val()*$('#other_qty').val()) * percen_discount) / 100 ;
		$('#sod_dis').val(discount_amount);
		$('#sod_dis_txt').text(discount_amount);
		calculateTotalDiscount();
		
	}
	
	function calculateTotalDiscount() {
		var total_discount = parseFloat($('#sod_dis').val()) + parseFloat($('#cash_discount').val());
		$('#sod_dis_total').val(total_discount);
		$('#sod_dis_total_txt').text(total_discount);
		calculateNetPrice();
	}

	function calculateNetPrice() {
		var net_price = parseFloat($('#other_price').val()*$('#other_qty').val() ) - $('#sod_dis_total').val();
		if(net_price<0){
			alert('ส่วนลดมากกว่าราคารวม');
			return true;
		}else{
			$('#sod_net_price_txt').text(net_price);
			$('#sod_net_price').val(net_price);
		}
	}
		$(function() {
			
			$('#other_price').keyup(function(e) {
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
					$('#other_price').focus();
				}
			});
			
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
					$('#discount_percen').focus();
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
		
		$('#update_other_form .btn_confirm').dblclick(function() {
			return false;
			});
		
			var form = $('#update_other_form');

			var v = form
					.validate({
						submitHandler : function() {
							if(calculateNetPrice()){
								return false;
							}
							
							if (isNumber($('#other_qty').val())) {
								if (isNumber($('#other_price').val())) {
									if (isNumber($('#discount').val())) {
										if (parseInt($('#other_qty').val()) <= 0) {
											alert('จำนวนสินค้าไม่สามารถมีค่าเป็น 0 ได้ !');
											$('#other_qty').focus();
											return false;
										}
										ajax_load();
										$
												.post(
														'../PartSaleManage',
														form.serialize(),
														function(resData) {
															
															ajax_remove();
															if (resData.status == 'success') {
																window.location
																		.reload();
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
									$('#other_price').focus();
								}
							} else {
								alert('โปรดตรวจสอบจำนวน!');
								$('#other_qty').focus();
							}
						}
					});

			form.submit(function() {
				v;
				return false;
			});
		});
	</script>
	
	<div class="txt_center m_top20">
	
		<input type="hidden" name="vat" value="<%=entity.getVat()%>">
		<input type="hidden" name="id" value="<%=entity.getId()%>">
		<input type="hidden" name="number" value="<%=entity.getNumber()%>">
		<input type="submit" name="add" class="btn_box btn_confirm" value="Submit">				
		<input type="button" class="btn_box btn_warn" value="Close Display" onclick="tb_remove();">				
		<input type="hidden" name="action" value="sale_other_update">
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>