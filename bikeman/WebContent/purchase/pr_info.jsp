<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.utils.Money"%>
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
String pn = WebUtils.getReqString(request, "mat_code"); // Bank : mat_code จิงๆแล้วตอนนี้อ้างอิง pn แต่ไม่อยากเปลี่ยนกลัวโปรแกรมเดี้ยง
PartMaster entity = PartMaster.select(pn) ;
PurchaseRequest pr = PurchaseRequest.select(WebUtils.getReqString(request, "id"));

String UnitDesc = UnitType.selectName(PartMaster.SelectUnitDesc(entity.getPn()));


%>
	<fieldset class="fset s600 center m_top5">
		<legend>รายละเอียด</legend>
		<div class="center s550" >
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
						<td>:&nbsp;&nbsp;<%=Money.money(pr.getOrder_price())%></td>
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
				</tbody>
					<!-- <tfoot>
						<tr>
							<td colspan="2" > 
								<strong>
									<font color="red">
										สาเหตุการยกเลิก
									</font>
								</strong>
							</td>
							<td colspan="2"> : </td>
							
						</tr>
					</tfoot> -->
			</table>
		</div>
		
		
		<div class="clear"></div>
		<div class="m_top10"></div>
		
	
		<div class="center txt_center">
			<input type="reset" name="reset" class="btn_box" value="ปิด" onclick="tb_remove();">
		</div>
	</fieldset>