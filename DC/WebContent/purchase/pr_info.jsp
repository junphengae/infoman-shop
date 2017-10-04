<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.Vendor"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterVendor"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src="../js/number.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<%
String pn = WebUtils.getReqString(request, "pn"); // Bank : mat_code จิงๆแล้วตอนนี้อ้างอิง pn แต่ไม่อยากเปลี่ยนกลัวโปรแกรมเดี้ยง
PartMaster entity = PartMaster.select(pn) ;
PurchaseRequest pr = PurchaseRequest.select(WebUtils.getReqString(request, "id"));

String UnitDesc = UnitType.selectName(entity.getDes_unit());

%>
	<fieldset class="fset s700 center m_top5">
		<legend>รายละเอียด</legend>
		<div class="center s650" >
			<table cellpadding="3" cellspacing="3" border="0" class="s_auto" >
				<tbody>
					<tr>
						<th width="13%"></th>
						<th width="40%"></th>
						<th width="20%"></th>
						<th width="27%"></th>
					</tr>
					<tr valign="top">
						<td ><strong>รหัสสินค้า</strong></td>
						<td>:&nbsp;&nbsp;<%=entity.getPn()%></td>
					
						<td><strong>ราคาต่อหน่วย</strong></td>
						<td>:&nbsp;&nbsp;<%=Money.money(pr.getOrder_price())%>  ฿</td>
					</tr>
					<tr valign="top">
						<td><strong>ชื่อสินค้า</strong></td>
						<td align="left">:&nbsp;&nbsp;<%=entity.getDescription()%></td>
						
						<td><strong>จำนวนที่ต้องการสั่ง</strong></td>
						<td>:&nbsp;&nbsp;<%=Money.moneyInteger(pr.getOrder_qty())+" "+UnitDesc %> </td>
					</tr>
					<tr>
						<td colspan="4"> <br/></td>
					</tr>
					<tr valign="top">
						<td><strong>หมายเหตุ</strong></td>
						<td colspan="3">:&nbsp;&nbsp;<%=pr.getNote()%></td>
					</tr>
					<tr>
						<td colspan="4"> <br/></td>
					</tr>
				</tbody>
			</table>
			
				
							<table class="bg-image" style="color: #fff;" width="100%">
								<thead>
									<tr>
										<th valign="top" align="center" width="30%">ชื่อตัวแทนจำหน่าย</th>
										<th valign="top" align="center" width="15%">จัดส่งขั้นต่ำ</th>
										<th valign="top" align="center" width="15%">เวลาจัดส่ง</th>
										<th valign="top" align="center" width="20%">เงื่อนไข</th>
										<th valign="top" align="center" width="18%">เครดิต</th>
									</tr>
								</thead>
								<tbody id="vendor_list">
								<%
									Vendor vendor = Vendor.select(pr.getVendor_id());
									InventoryMasterVendor masterVendor = InventoryMasterVendor.select(pn, pr.getVendor_id());
								%>
								<tr id="vendor_<%=vendor.getVendor_id()%>">
									<td align="left"><%=vendor.getVendor_name()%></td>
									<td align="center"><%=masterVendor.getVendor_moq()+" "+UnitDesc%></td>
									<td align="center"><%=masterVendor.getVendor_delivery_time()%></td>
									<td align="center"><%=vendor.getVendor_condition()%></td>
									<td align="center"><%=vendor.getVendor_credit()%></td>
								</tr>
								</tbody>
							</table>
					
					
			
		</div>
		
		
		<div class="clear"></div>
		<div class="m_top10"></div>
		
	
		<div class="center txt_center">
			<input type="reset" name="reset" class="btn_box" value="ปิด" onclick="tb_remove();">
		</div>
	</fieldset>