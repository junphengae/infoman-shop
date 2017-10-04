<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src="../js/number.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<%
String pn = WebUtils.getReqString(request, "mat_code");
PartMaster entity = PartMaster.select(pn);
PurchaseRequest pr = PurchaseRequest.select(WebUtils.getReqString(request, "id"));
%>
<script type="text/javascript">

var order_price = $('#order_price');
var order_qty = $('#order_qty');

var form = $('#create_order_form');

form.submit(function(){
		if (isNumber(order_qty.val()) && (order_qty.val()*1) > 0 && order_qty.val() != '') {

				if (confirm('Update PR !')) {
					ajax_load();
					$.post('../PurchaseManage',form.serialize(),function(resData){
						ajax_remove();
						if (resData.status == 'success') {
							window.location.reload();
						} else {
							alert(resData.message);
						}
					},'json');
				}
			
		} else {
			alert('โปรดระบุจำนวนที่จะสั่งซื้อ');
			order_qty.focus();
		}
	
		
	return false;
});

order_price.focus(function(){ var value = $(this).val(); if (!(/^\d+$/.test(value)) || value == '0') { $(this).val(''); }});
order_qty.focus(function(){ var value = $(this).val(); if (!(/^\d+$/.test(value)) || value == '0') { $(this).val(''); }});

</script>
<form id="create_order_form" onsubmit="return false;">
	<fieldset class="fset s800 center m_top10">
		<legend>Detail</legend>
		<table cellpadding="3" cellspacing="3" border="0" class="s400 left">
			<tbody>
				<tr>
					<td width="20%"><label>PN</label></td>
					<td>: <%=entity.getPn()%></td>
				</tr>
				<tr>
					<td>Description</td>
					<td>: <%=entity.getDescription()%></td>
				</tr>
			</tbody>
		</table>
		<table cellpadding="3" cellspacing="3" border="0" class="s350 right">
			<tbody>
				<tr>
					<td><label title="ราคาต่อหน่วย">Price per unit</label></td>
					<td>
						: <input type="text" name="order_price" id="order_price" class="txt_box" autocomplete="off" value="<%=pr.getOrder_price()%>">
					</td>
				</tr>
				<tr>
					<td><label title="จำนวนที่ต้องการสั่ง">Order QTY</label></td>
					<td>
						: <input type="text" autocomplete="off" name="order_qty" id="order_qty" class="txt_box required" title="ระบุจำนวนที่ต้องการสั่ง!" value="<%=pr.getOrder_qty()%>">  
					</td>
				</tr>
				<tr>
					<td><label title="ราคารวม">Total Price</label></td>
					<td>: <span id="sum_price" class="txt_red">0.00</span> 
					<script type="text/javascript">
						$(function(){
							var order_price = $('#order_price');
							var order_qty = $('#order_qty');
							
							var sum_price = $('#sum_price');
							order_price.blur(function(){
								sumMoney();
							});
							
							order_qty.blur(function(){
								sumMoney();
							});
							
							sumMoney();
							
							function sumMoney(){
								sum_price.text(order_price.val() * order_qty.val());		
								if(sum_price.text() > 1000000){
									//alert('Over 1,000,000 !!');
								}
								sum_price.text(money(order_price.val() * order_qty.val()));
							}
						});
						</script>
					</td>
				
				</tr>
			</tbody>
		</table>
		
		<div class="clear"></div>
		<div class="dot_line"></div>
		
		<table class="s_auto">
			<tbody>
				<tr>
					<td width="80"><label title="หมายเหตุ">Remark</label> :</td>
					<td><input type="text" class="txt_box s_auto" autocomplete="off" name="note" id="remark" value="<%=pr.getNote()%>"></td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
			</tbody>
		</table>
		
		
		
		<table cellpadding="3" cellspacing="3" border="0" class="s600 center">
			<tbody>
				<tr align="center" valign="bottom" height="25">
					<td colspan="2">
						<input type="submit" name="add" class="btn_box btn_confirm" title="แก้ไขลงรายการขอจัดซื้อ" value="Update PR">
						<input type="reset" name="reset" class="btn_box" title="ปิดหน้าจอ" value="Close" onclick="tb_remove();">
						<input type="hidden" name="action" value="update_pr">
						<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
						<input type="hidden" name="mat_code" value="<%=pn%>">
						<input type="hidden" name="pr_type" value="<%=PurchaseRequest.TYPE_PARTS%>">
						<input type="hidden" name="id" value="<%=pr.getId()%>">
					</td>
				</tr>
			</tbody>
		</table>
	</fieldset>
	
	<fieldset class="fset s800 center m_top10">
		<legend>Summary of the past 3 months: <%=entity.getDescription()%></legend>
		<table class="bg-image s_auto">
			<thead>
				<tr>
					<th valign="top" align="center" width="25%">Balance</th>
					<th valign="top" align="center" width="25%">PO</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td align="right"><%=Money.money(entity.getQty())%></td>
					<td align="right"><%=Money.money(PurchaseRequest.pr_opened_list_sum(entity.getPn()))%></td>
				</tr>
			</tbody>
		</table>
	</fieldset>
	
	<div class="m_top10"></div>
</form>