<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src="../js/number.js"></script>
<script src="../js/validator.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<%
String pn = WebUtils.getReqString(request, "pn");
String  sumPR = WebUtils.getReqString(request, "sumPR");
PartMaster entity = PartMaster.select(pn);



String UnitDesc = UnitType.selectName(PartMaster.SelectUnitDesc(entity.getPn()));

String SUMPRDESC = "รายการสินค้าดังกล่าวขอจัดซื้อไปแล้ว  "+Money.moneyInteger(sumPR)+" "+UnitDesc;

Iterator ite = PurchaseRequest.selectPRlist3Month(pn).iterator();
%>
<script type="text/javascript">
var order_price = $('#order_price');
var order_qty = $('#order_qty');
var note = $('#remark');

var form = $('#create_order_form');

var pr =$('#pr').val();

if(pr != '0'){
	
	 if (confirm('<%=SUMPRDESC%> ') ) {
		
		<%-- window.location="pr_parts.jsp?pn=<%=pn%>"; --%>
	}else {
		
		window.location="purchase_manage.jsp";
	} 
	
}






form.submit(function(){
	//if (isNumber(order_price.val()) && (order_price.val()*1) > 0 && order_price.val() != '') {
		
		
						if (isNumber(order_qty.val()) && (order_qty.val()*1) > 0 && order_qty.val() != '') {
							 if(order_price.val() ==  '0'){
								alert('สิ้นค้าที่คุุณสั่งไม่มีราคาต้นทุน !');
							 }
							if (confirm('Create PR !')) {
									ajax_load();
									$.post('../PurchaseManage',form.serialize(),function(resData){
										ajax_remove();
										if (resData.status == 'success') {
											window.location.reload();
											tb_remove();
										} else {
											alert(resData.message);
										}
									},'json');
								}
							
						} else {
							alert('โปรดระบุจำนวนที่จะสั่งซื้อ');
							order_qty.focus();
						}
		
		
	/* } else {
		alert('Insert Price per unit!');
		order_price.focus();
	} */
		
	return false;
});

order_price.focus(function(){ var value = $(this).val(); if (!(/^\d+$/.test(value)) || value == '0') { $(this).val(''); }});
order_qty.focus(function(){ var value = $(this).val(); if (!(/^\d+$/.test(value)) || value == '0') { $(this).val(''); }});

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
						: <%=(entity.getCost().length() > 0)?entity.getCost():"0"%>
						<input type="hidden" name="order_price" id="order_price" class="txt_box" autocomplete="off" value="<%=(entity.getCost().length() > 0)?entity.getCost():"0"%>">
					</td>
				</tr>
				<tr>
					<td><label title="จำนวนที่ต้องการสั่ง">Order QTY</label></td>
					<td>
						: <input type="text" autocomplete="off" name="order_qty" id="order_qty" class="txt_box required" title="ระบุจำนวนที่ต้องการสั่ง!" value="0" onchange="return validNumberOnKeyUp(this, event)">  
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
					<td><input type="text" class="txt_box s_auto" autocomplete="off" name="note" id="remark"></td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
			</tbody>
		</table>
		
		<table cellpadding="3" cellspacing="3" border="0" class="s600 center">
			<tbody>
				<tr align="center" valign="bottom" height="25">
					<td colspan="2">
						<input type="hidden" name="pr" id="pr" value="<%=sumPR%>">
						<input type="submit" name="add" class="btn_box btn_confirm" title="บันทึกลงรายการขอจัดซื้อ" value="Create PR">
						<input type="reset" name="reset" class="btn_box" title="ปิดหน้าจอ" value="Close" onclick="tb_remove();">
						<input type="hidden" name="action" value="create_pr">
						<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
						<input type="hidden" name="mat_code" value="<%=pn%>">
						<input type="hidden" name="pr_type" value="<%=PurchaseRequest.TYPE_PARTS%>">
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
					<th valign="top" align="center" width="20%">Date</th>
					<th valign="top" align="center" width="20%">PO</th>
					<th valign="top" align="center" width="20%">PN</th>
					<th valign="top" align="center" width="15%">QTY</th>
					<th valign="top" align="center" width="25%">Price</th>
				</tr>
			</thead>
			
				<tbody>
						<%
							boolean has = true;
							while(ite.hasNext()) {
								PurchaseRequest entityPR = (PurchaseRequest) ite.next();
								has = false;
						%>
							<tr valign="top">
								<td align="center" >		<%=WebUtils.getDateDBValue(entityPR.getCreate_date()) %>	</td>
								<td align="center" > 		<%=entityPR.getPo()%>															</td>
								<td align="left" > 			<%=entityPR.getMat_code()%>															</td>
								<td align="right" >			<%=Money.moneyInteger(entityPR.getOrder_qty()) +" "+UnitDesc%>				</td>
								<td align="right" >			<%=Money.money(entityPR.getOrder_price()) %>						</td>
							</tr>
							<% } %>
			</tbody>
		</table>
	</fieldset>
	 
	<div class="m_top10"></div>
</form>