<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.bean.dc.SaleServicePartDetail"%>
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
String pn = WebUtils.getReqString(request, "mat_code");
String number = WebUtils.getReqString(request, "number");
String id = WebUtils.getReqString(request, "id");

List paramsList = new ArrayList();

paramsList.add(new String[]{"1",id,number,pn});
Iterator ite = SaleServicePartDetail.selectList(paramsList).iterator();


%>
	<fieldset class="fset s600 center m_top5">
		<legend>Detail</legend>
		<div class="center s550" >
			<table cellpadding="3" cellspacing="3" border="0" class="s_auto" >
				<tbody>
					<tr>
						<th width="13%"></th>
						<th width="40%"></th>
						<th width="20%"></th>
						<th width="27%"></th>
						<%
							while(ite.hasNext()) {
							SaleServicePartDetail entity = (SaleServicePartDetail) ite.next();
							PartMaster master = PartMaster.select(entity.getPn());
						
							String UnitDesc = UnitType.selectName(master.getDes_unit());
						%>
					</tr>
					<tr valign="top">
						<td ><strong>PN</strong></td>
						<td>:&nbsp;&nbsp;<%=entity.getPn()%></td>
					
						<td><strong>Price per unit</strong></td>
						<td>:&nbsp;&nbsp;<%=Money.money(entity.getPrice())%> (฿)</td>
					</tr>
					<tr valign="top">
						<td><strong>Description</strong></td>
						<td align="left">:&nbsp;&nbsp;<%=master.getDescription()%></td>
						
						<td><strong>Order QTY</strong></td>
						<td>:&nbsp;&nbsp;<%=Money.moneyInteger(entity.getQty())+" "+UnitDesc%> </td>
					</tr>
					<tr>
						<td colspan="4"> <br/></td>
					</tr>
					<tr valign="top">
						<td><strong>Remark</strong></td>
						<td colspan="3">:&nbsp;&nbsp;<%=entity.getNote()%></td>
					</tr>
				</tbody>
					<%} %>
			</table>
		</div>
		
		
		<div class="clear"></div>
		<div class="m_top10"></div>
		
	
		<div class="center txt_center">
			<input type="reset" name="reset" class="btn_box" value="Close" onclick="tb_remove();">
		</div>
	</fieldset>