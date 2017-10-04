<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.parts.Vendor"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterVendor"%>
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
String pn = WebUtils.getReqString(request, "pn");
PartMaster entity = PartMaster.select(pn);

String UnitDesc = UnitType.selectName(entity.getDes_unit());

List paramsList = new ArrayList();
paramsList.add(new String[]{"pn",pn});

%>

<script type="text/javascript">

var order_price = $('#order_price');
var order_qty = $('#order_qty');
var note = $('#remark');

var form = $('#create_order_form');
var onvendor =$('#onvendor').val();

 if(onvendor == "1"){
	
	 if (confirm("เพิ่มตัวแทนจำหน่าย")) {
		
		window.location="part_edit_vendor.jsp?pn=<%=pn%>";
	}else {
		
		window.location="purchase_manage.jsp";
	} 
	
}
form.submit(function(){
try{  
	//if (isNumber(order_price.val()) && (order_price.val()*1) > 0 && order_price.val() != '') {
		if (isNumber(order_qty.val()) && (order_qty.val()*1) > 0 && order_qty.val() != '') {
			if(order_price.val() ==  '0'){
				alert('สิ้นค้าที่คุุณสั่งไม่มีราคาต้นทุน !');
			 }
			if ($("input[name='vendor_id']:radio").is(':checked')){	
				         
							ajax_load();
							$.post('../PurchaseManage',form.serialize(),function(resData){
								ajax_remove();
								if (resData.status == 'success') {
									
									if(resData.moq){
										//alert('Qrder Qty < Vendor moq!');
										alert('จำนวนจัดส่งขั้นต่ำ  '+ resData.moq +' !');
									}else{
										
										 if (confirm('Create PR !')) {
											window.location.reload();
											tb_remove();
										 }
									}
									
									
								} else {
									alert(resData.message);
								}
							},'json');
						
				 
			 
			} else {
				alert('Select Vender!');
			}
		} else {
			alert('โปรดระบุจำนวนที่จะสั่งซื้อ');
			order_qty.focus();
		}
	/* } else {
		alert('Insert Price per unit!');
		order_price.focus();
	} */
}catch(err){
	alert(err);
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
						: <input type="hidden" name="order_price" id="order_price" class="txt_box" autocomplete="off" value="<%=(entity.getCost().length() > 0)?entity.getCost():"0"%>"> 
					
								<label><%=(entity.getCost().length() > 0)?entity.getCost():"0"%></label>
					</td>
				</tr>
				<tr>
					<td><label title="จำนวนที่ต้องการสั่ง">Order QTY</label></td>
					<td>
						: <input type="text" autocomplete="off" name="order_qty" id="order_qty" class="txt_box required" title="ระบุจำนวนที่ต้องการสั่ง!" value="">  
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
					<td width="80"><label title="หมายเหตุ">Remark</label> </td>
					<td>:<input type="text" class="txt_box s700" autocomplete="off" name="note" id="remark"></td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
			</tbody>
		</table>
		<table class="bg-image s_auto" style="color: #fff;">
			<thead>
				<tr>
					<th valign="top" align="center" width="5%"></th>
					<th valign="top" align="center" width="25%">ชื่อตัวแทนจำหน่าย</th>
					<th valign="top" align="center" width="15%">จัดส่งขั้นต่ำ</th>
					<th valign="top" align="center" width="15%">เวลาจัดส่ง</th>
					<th valign="top" align="center" width="20%">เงื่อนไข</th>
					<th valign="top" align="center" width="20%">เครดิต </th>
				</tr>
			</thead>
			<tbody id="vendor_list">
			<%
				Boolean has = false;
				Iterator ite = InventoryMasterVendor.selectList(pn).iterator();
				while(ite.hasNext()) { 
					has = true;
					InventoryMasterVendor masterVendor = (InventoryMasterVendor) ite.next();
					Vendor vendor = masterVendor.getUIVendor();
			%>
			<tr id="vendor_<%=vendor.getVendor_id()%>">
				<td align="center"><input type="radio" name="vendor_id" id="vendor_id" value="<%=vendor.getVendor_id()%>" ></td>
				<td align="left"><%=vendor.getVendor_name()%></td>
				<td align="center"><%=masterVendor.getVendor_moq()+" "+UnitDesc%>
				<%//=vendor.getVendor_id()%>
			 	<input type="hidden" name="Vendor_moq" id="Vendor_moq" value="<%=masterVendor.getVendor_moq()%>">
				</td>
				
				<td align="center"><%=masterVendor.getVendor_delivery_time()%></td>
				<td align="center"><%=vendor.getVendor_condition()%></td>
				<td align="center"><%=vendor.getVendor_credit()%></td>
			</tr>
			
			<%
			}if(has == false){
				String v ="1";
			%>
			<tr>
				<input type="hidden" name="onvendor" id="onvendor" value="<%=v%>">				
			</tr>
			<%} %>
			</tbody>
		</table>
		
		<table cellpadding="3" cellspacing="3" border="0" class="s600 center">
			<tbody>
				<tr align="center" valign="bottom" height="25">
					<td colspan="2">
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
					<th valign="top" align="center" width="25%">Date</th>
					<th valign="top" align="center" width="25%">PO</th>
					<th valign="top" align="center" width="25%">QTY</th>
					<th valign="top" align="center" width="25%">Price(฿)</th>
				</tr>
			</thead>
			<% 
				Boolean has2 = false;
				String price = "0";
			Iterator iteMas = PurchaseRequest.selectPast3Months(paramsList).iterator();
			while(iteMas.hasNext()){
				has2 = true;
				PurchaseRequest pr = (PurchaseRequest) iteMas.next();
				price = Money.multiple(pr.getOrder_qty(), pr.getOrder_price());
			%>
			<tbody>
				<tr>
					<td align="center"><%=WebUtils.getDateValue(pr.getCreate_date())%></td>
					<td align="center"><%=pr.getPo() %></td>
					<td align="right"><%=Money.moneyInteger(pr.getOrder_qty())+" "+UnitDesc%></td>
					 <td align="right"><%=Money.money(price)%></td> 
				</tr>
				<% }if(has2 == false){
					
					%>
					 <tr>
						<td align="center"  colspan="4">-- ไม่พบข้อมูล --</td>
					
					</tr> 
			<% } %>
			</tbody>
		</table>
	</fieldset>
	
	<div class="m_top10"></div>
</form>