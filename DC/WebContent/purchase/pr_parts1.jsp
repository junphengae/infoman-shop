<%@page import="com.bitmap.bean.parts.Vendor"%>
<%@page import="com.bitmap.bean.inventory.InventoryLot"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterVendor"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="com.bitmap.bean.purchase.PurchaseOrder"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script src="../js/number.js"></script>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>

<%
String pn = WebUtils.getReqString(request, "pn");
InventoryMaster entity = InventoryMaster.select(pn);
%>

<script type="text/javascript">
var order_price = $('#order_price');
var order_qty = $('#order_qty');
var form = $('#create_order_form');

form.submit(function(){
	if (isNumber(order_price.val()) && (order_price.val()*1) > 0 && order_price.val() != '') {
		if (isNumber(order_qty.val()) && (order_qty.val()*1) > 0 && order_qty.val() != '') {
			if ($("input[name='vendor_id']:radio").is(':checked')){
				if (confirm('ยืนยันการขอจัดซื้อ !')) {
					ajax_load();
					$.post('../PurchaseManage',form.serialize(),function(resData){
						ajax_remove();
						if (resData.status == 'success') {
							tb_remove();
						} else {
							alert(resData.message);
						}
					},'json');
				}
			} else {
				alert('กรุณาเลือกตัวแทนจำหน่าย!');
			}
		} else {
			alert('ระบุจำนวนที่ต้องการสั่ง!');
			order_qty.focus();
		}
	} else {
		alert('ระบุราคาที่ต้องการสั่ง!');
		order_price.focus();
	}
		
	return false;
});

order_qty.focus(function(){ var value = $(this).val(); if (!(/^\d+$/.test(value)) || value == '0') { $(this).val(''); }});

</script>


<form id="create_order_form" onsubmit="return false;">
	<fieldset class="fset s750 center m_top5">
		<legend>Detail</legend>
		<div class="left s300">
			<table cellpadding="3" cellspacing="3" border="0" class="s_auto">
				<tbody>
					<tr>
						<td width="45%"><label>PN</label></td>
						<td>: <%-- <%=entity.getUISubCat().getUICat().getUIGroup().getGroup_name_en() + "-" + entity.getUISubCat().getUICat().getCat_name_short() + ((entity.getUISubCat().getSub_cat_name_th().length() > 0)?"-" + entity.getUISubCat().getSub_cat_name_short():"")%>- --%><%=entity.getMat_code()%></td>
					</tr>
					<tr valign="top">
						<td><label>Description</label></td>
						<td align="left">: <%=entity.getDescription()%></td>
					</tr>
					<tr>
						<td><label title="หมายเหตุ">Remark</label> </td>
						<td>: <input type="text" class="txt_box" autocomplete="off" name="note"></td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div class="right s400">
			<table cellpadding="3" cellspacing="3" border="0" class="s_auto">
				<tbody>
					<tr>
						<td width="45%"><label title="ราคาต่อหน่วย">Price per unit</label></td>
						<td>: <input type="text" name="order_price" id="order_price" class="txt_box" autocomplete="off" value="<%=(entity.getCost().length() > 0)?entity.getCost():""%>"></td>
					</tr>
					<tr>
						<td><label title="จำนวนที่ต้องการสั่ง">Order QTY</label></td>
						<td>: <input type="text" autocomplete="off" name="order_qty" id="order_qty" class="txt_box required" title="ระบุจำนวนที่ต้องการสั่ง!" value="0"> <%=entity.getStd_unit()%></td>
					</tr>
					
					<tr><td colspan="2">&nbsp;</td></tr>
				</tbody>
			</table>
		</div>
		
		<div class="clear"></div>
		
		<table class="bg-image s_auto" style="color: #fff;">
			<thead>
				<tr>
					<th valign="top" align="center" width="5%"></th>
					<th valign="top" align="center" width="25%">ชื่อตัวแทนจำหน่าย</th>
					<th valign="top" align="center" width="15%">จัดส่งขั้นต่ำ</th>
					<th valign="top" align="center" width="15%">เวลาจัดส่ง</th>
					<th valign="top" align="center" width="20%">เงื่อนไข</th>
					<th valign="top" align="center" width="20%">เครดิต</th>
				</tr>
			</thead>
			<tbody id="vendor_list">
			<%
				Iterator ite = InventoryMasterVendor.selectList(pn).iterator();
					while(ite.hasNext()) {
				InventoryMasterVendor masterVendor = (InventoryMasterVendor) ite.next();
				Vendor vendor = masterVendor.getUIVendor();
			%>
			<tr id="vendor_<%=vendor.getVendor_id()%>">
				<td><input type="radio" name="vendor_id" value="<%=vendor.getVendor_id()%>"></td>
				<td><%=vendor.getVendor_name()%></td>
				<td align="center"><%=masterVendor.getVendor_moq()%></td>
				<td align="center"><%=masterVendor.getVendor_delivery_time()%></td>
				<td><%=vendor.getVendor_condition()%></td>
				<td align="center"><%=vendor.getVendor_credit()%></td>
			</tr>
			<%
			}
			%>
			</tbody>
		</table>
		
		<div class="center txt_center">
			<input type="submit" name="add" class="btn_box btn_confirm" title="บันทึกลงรายการขอจัดซื้อ" value="Create PR">
			<input type="reset" name="reset" class="btn_box" title="ปิดหน้าจอ" value="Close" onclick="tb_remove();">
			<input type="hidden" name="action" value="create_pr">
			<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
			<input type="hidden" name="pn" value="<%=pn%>">
			<input type="hidden" name="branch_id" value="<%=securProfile.getPersonal().getBranch_id()%>">
		</div>
	</fieldset>
	<%-- <fieldset class="fset s800 center m_top10">
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
					<td align="right"><%=Money.money(entity.getQty))%></td>
					<td align="right"><%=Money.money(PurchaseRequest.pr_opened_list_sum(entity.getPn()))%></td>
				</tr>
			</tbody>
		</table>
	</fieldset> --%>
	 <%
	List prlist = PurchaseRequest.list_status_open(pn);
	if (prlist.size() > 0) {
	%>
	 <fieldset class="fset s750 center h150 m_top5">
		<legend>รายการค้างส่ง</legend>
		<div class="scroll_box h120">
			<table class="bg-image s_auto" style="color: #fff;">
				<thead>
					<tr>
						<th valign="top" align="center" width="30%">วันที่สร้าง</th>
						<th valign="top" align="center" width="30%">วันที่จัดส่ง</th>
						<th valign="top" align="center" width="20%">ราคาที่สั่ง</th>
						<th valign="top" align="center" width="20%">จำนวนที่สั่ง</th>
					</tr>
				</thead>
				<tbody id="inlet_list">
					<%
					Iterator itePR = prlist.iterator();
					while(itePR.hasNext()){
						PurchaseRequest pr = (PurchaseRequest) itePR.next();
						PurchaseOrder po = PurchaseOrder.select(pr.getPo());
					%>
					<tr>
						<td align="center"><%=WebUtils.getDateTimeValue(pr.getCreate_date())%></td>
						<td align="center"><%=WebUtils.getDateValue(po.getDelivery_date())%></td>
						<td align="right"><%=Money.money(pr.getOrder_price())%></td>
						<td align="right"><%=Money.money(pr.getOrder_qty())%></td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
		</div>
	</fieldset>
	<%
	}
	%> 
	
	
</form>
