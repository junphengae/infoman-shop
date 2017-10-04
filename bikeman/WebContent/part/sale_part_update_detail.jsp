<%@page import="com.bmp.customer.service.bean.ServicePartDetailBean"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.ServicePartDetail"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="../js/common.js"></script>
<script src="../js/validator.js"></script>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%
//ServicePartDetail entity = new ServicePartDetail();
ServicePartDetailBean entity = new ServicePartDetailBean();
WebUtils.bindReqToEntity(entity, request);
ServicePartDetail.select(entity);

PartMaster pm = PartMaster.select(entity.getPn());
%>
<form id="update_discount_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%" class="center" id="tb_material_add" border="0" cellpadding="4" cellspacing="4">
		<tbody>
			<tr>
				<td width="25%" align="left">PN</td>
				<td width="75%" align="left">: <%=pm.getPn()%></td>
			</tr>
			<tr>
				<td align="left">Description</td>
				<td align="left">: <%=entity.getUIDescription()%></td>
			</tr>
			<tr>
				<td align="left">Price</td>
				<td align="left">: <%=pm.getPrice()%>
					 <input type="hidden" name="price" id="price" class="txt_box required" title="*" value="<%=entity.getPrice()%>" autocomplete="off"> 
				</td>
			</tr>
			<tr>
				<td align="left">Stock Qty</td>
				<td align="left">: <span id="stock_qty"><%=pm.getQty() %></span>
				
						<input type="hidden" name="stock_qty" id="stock_qty" value="<%=pm.getQty() %>" autocomplete="off">
				</td>
			</tr>
			<%if(entity.getCutoff_qty().length() > 0){ %>
			
			<tr>
				<td align="left">Draw Qty</td>
				<td align="left">: <span id="draws_qty"><%=entity.getCutoff_qty() %></span>
				
						<input type="hidden" name="draw_qty" id="draw_qty" class="txt_box" value="<%=entity.getCutoff_qty() %>" autocomplete="off">
				</td>
				
			</tr>
			<% } %>
			<tr>
				<td colspan="2"><div class="dot_line"></div></td>
			</tr>
			<tr>
				<td align="left">Qty</td>
				<td align="left">: 
				<label><%=entity.getQty() %></label>
				<input type="hidden" name="qty" id="qty"  value="<%=entity.getQty()%>" >
				<%-- <input type="text" name="qty" id="qty" class="txt_box required digits" title="*" value="<%=entity.getQty()%>" autocomplete="off"> --%>
				</td>
			</tr><%-- 
			<tr>
				<td align="left">Price</td>
				<td align="left">: <input type="hidden" name="price" id="price" class="txt_box required" title="*" value="<%=entity.getPrice()%>" autocomplete="off"></td>
			</tr> --%>

			<tr>
							<td align="left"><Strong>Discount % </Strong></td>
							<td align="left">: &nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="discount" id="discount_percen" class="txt_box s40"  autocomplete="off"  value="<%=entity.getDiscount()%>"  class="txt_box  " onblur="calculateDiscount()" onchange="return validCurrencyOnKeyUp(this, event)" > %
							&nbsp;&nbsp;&nbsp;
							 คิดเป็นเงิน : 
							 <span id="spd_dis_txt">0</span>
							 <input type="hidden" name="spd_dis" id="spd_dis" class="txt_box s40"  autocomplete="off"  value="0"  class="txt_box"> บาท
							</td>	
						</tr>
						<tr>
							<td align="left"><Strong>Discount เงินสด </Strong></td>
							<td align="left">: &nbsp;&nbsp;&nbsp;
							<input type="text" name="cash_discount" id="cash_discount" class="txt_box s40"  autocomplete="off"  value="<%=entity.getCash_discount()%>"  class="txt_box" onblur="calculateTotalDiscount()" onchange="return validCurrencyOnKeyUp(this, event)" >
							  บาท
							</td>	
						</tr>
						<tr>
							<td align="left"><Strong>รวมเงินส่วนลด </Strong></td>
							<td align="left">: &nbsp;&nbsp;&nbsp;&nbsp;
								<span id="spd_dis_total_txt">0</span>  บาท
								<input type="hidden" name="spd_dis_total" id="spd_dis_total" class="txt_box s40"  autocomplete="off"  value="0"  class="txt_box" >
							 </td>
						
						</tr>
						<tr>
							<td align="left"><Strong>รวมยอดเงินชำระ </Strong></td>
							<td align="left">: &nbsp;&nbsp;&nbsp;&nbsp;
								<span id="spd_net_price_txt">0</span>  บาท
								<input type="hidden" name="spd_net_price" id="spd_net_price" class="txt_box s40"  autocomplete="off"  value="0"  class="txt_box" > </td>
						
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
		var discount_amount = (($('#price').val()*$('#qty').val()) * percen_discount) / 100 ;
		$('#spd_dis').val(discount_amount);
		$('#spd_dis_txt').text(discount_amount);
		calculateTotalDiscount();
		
	}
	
	function calculateTotalDiscount() {
		var total_discount = parseFloat($('#spd_dis').val()) + parseFloat($('#cash_discount').val());
		$('#spd_dis_total').val(total_discount);
		$('#spd_dis_total_txt').text(total_discount);
		calculateNetPrice();
	}

	function calculateNetPrice() {
		var net_price = parseFloat($('#price').val()*$('#qty').val() ) - $('#spd_dis_total').val();
		if(net_price<0){
			alert('ส่วนลดมากกว่าราคารวม');
			return true;
		}else{
			$('#spd_net_price_txt').text(net_price);
			$('#spd_net_price').val(net_price);
		}
	}
	$(function(){
		
		$('#qty').keyup(function(e) {
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
				$('#qty').focus();
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
		
	
		$('#update_discount_form .btn_confirm').dblclick(function() {
		return false;
		});
		
		var form = $('#update_discount_form');	
		var v = form.validate({
			submitHandler: function(){
				if(calculateNetPrice()){
					return false;
				}
				if (isNumber($('#price').val())) {
					if (isNumber($('#discount').val())) {
						if (parseInt($('#qty').val()) > parseInt($('#stock_qty').val())) {
							alert('สินค้าคงคลังมีจำนวนไม่เพียงพอต่อความต้องการ');
							$('#qty').focus();
						} else if(parseInt($('#qty').val()) == 0){
							alert('ไม่สามารถระบุจำนวนสินค้าเท่ากับ "0"');
							$('#qty').focus();
							
						} else if(parseInt($('#draw_qty').val()) > parseInt($('#qty').val()) ){
							alert('จำนวนสินค้าไม่สามารถแก้ไขให้น้อยกว่าจำนวนที่เบิกมาแล้ว');
							$('#qty').focus();
						
						
						
						}else {
							ajax_load();
							$.post('../PartSaleManage',form.serialize(),function(resData){			
								ajax_remove();
								if (resData.status == 'success') {
									window.location.reload();
								} else {
									alert(resData.status);
								}
							},'json');
						}
					} else {
						alert('โปรดตรวจสอบส่วนลด!');
						$('#discount').focus();
					}
				} else {
					alert('โปรดตรวจสอบราคา!');
					$('#price').focus();
				}
			}
		});
		
		form.submit(function(){
			v;
			return false;
		});	
	});
	</script>
	
	<div class="txt_center m_top20">
		<input type="hidden" name="id" value="<%=entity.getId()%>">
		<input type="hidden" name="number" value="<%=entity.getNumber()%>">
		<input type="hidden" name="vat" value="<%=entity.getVat()%>">
		<input type="submit" name="add" class="btn_box btn_confirm" value="Submit">				
		<input type="button" class="btn_box btn_warn" value="Close Display" onclick="tb_remove();">				
		<input type="hidden" name="action" value="sale_part_update_detail">
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>