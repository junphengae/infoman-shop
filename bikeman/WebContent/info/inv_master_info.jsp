<%@page import="com.bitmap.bean.parts.PartCategoriesSub"%>
<%@page import="com.bitmap.bean.parts.PartCategories"%>
<%@page import="com.bitmap.bean.parts.PartGroups"%>
<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.inventory.SubCategories"%>
<%@page import="com.bitmap.bean.inventory.InventoryLotControl"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.inventory.InventoryLot"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterVendor"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<%
String mat_code = WebUtils.getReqString(request, "mat_code");
/* InventoryMaster invMaster = InventoryMaster.select(mat_code); */

PartMaster entity = PartMaster.select(mat_code);
String UnitDesc = UnitType.selectName(PartMaster.SelectUnitDesc(entity.getPn()));

session.setAttribute("MAT", entity);
%>
				<fieldset class="fset s400 left ">
					<legend>Information</legend>
					<table width="100%" style="height: 240px;" >
						<tbody>
							<tr>
								<td width="25%">Parts Number</td>
								<td>:<%=entity.getPn()%></td>
							</tr>
							<tr>
								<td>Description</td>
								<td>:<%=entity.getDescription()%></td>
							</tr>
							<tr>
								<td >กลุ่ม</td>
								<td >: <%=PartGroups.select(entity.getGroup_id()).getGroup_name_th()%></td>
							</tr>
							<tr>
								<td>ชนิด</td>
								<td>: <%=PartCategories.select(entity.getCat_id(), entity.getGroup_id()).getCat_name_th()%></td>
							</tr>
							<tr>
								<td>ชนิดย่อย</td>
								<td>: <%=PartCategoriesSub.select(entity.getSub_cat_id(), entity.getCat_id(),  entity.getGroup_id()).getSub_cat_name_th()%></td>
							</tr>
							<tr><td>หน่วยกลาง</td>
								<td align="left">: <%=UnitType.selectName(entity.getDes_unit())%></td>
							</tr>
							<tr valign="top">
								<td><label>Fit-To</label></td>
								<td align="left">: <%=entity.getFit_to()%></td>
							</tr>
							<tr><td colspan="2" >&nbsp;</td></tr>
							<tr>
								<td><label title="Serial Number">Store Type</label></td>
								<td align="left">: <%=entity.getSn_flag().equalsIgnoreCase("1")?" Serial Number":entity.getSn_flag().equalsIgnoreCase("0")?" Non-Serial":""%></td>
							</tr>
							<tr>
								<td><label>Weight</label></td>
								<td align="left">: <%=entity.getWeight()%> &nbsp;&nbsp;Kg.</td>
							</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr>
								<td><label>Price</label></td>
								<td align="left">: 
									<%	
									String priceValue = Money.money(entity.getPrice());
									
									if(priceValue.length() > 0){
										out.print(priceValue);
									}else{
										out.print("0.00");
									}
            	
            						%>	
            							<%=PartMaster.unit(entity.getPrice_unit())%></td>
							</tr>
							<tr>
								<td><label>Cost</label></td>
								<td align="left">: 
									<%	
									String costValue = Money.money(entity.getCost()).trim();
									
									if(costValue.length() > 0){
										out.print(costValue);
									}else{
										out.print("0.00");
									} %>
									 <%=PartMaster.unit(entity.getCost_unit())%>
								</td>
							</tr>
							
						</tbody>
					</table>
				</fieldset>
				<fieldset class="right fset min_h240" style="width: 330px; ">
					<legend>Parts Photo</legend>
					
					<div id="div_img" class="center txt_center" style="width: 320px; height: 240px;">
						<img width="320" height="240" <%-- src="../images/inventory/<%=mat_code%>.jpg?state=<%=Math.random()%>" --%>>
					</div>
					
					<div class="clear"></div>
				</fieldset>
				<fieldset class="fset s400 left min_h100">
					<legend>Inventory</legend>
					<table cellpadding="3" cellspacing="3" border="0" >
						<tbody>
							<tr>
								<td width="25%"><label>Balance Qty</label></td>
								<td align="left">: <%=Money.moneyInteger(entity.getQty()) +" "+UnitDesc %></td>
							</tr>
							<tr>
								<td><label title="Minimum Order Qty">MOQ</label></td>
								<td align="left">: <%=entity.getMoq()%></td>
							</tr>
							<tr>
								<td><label title="Minimum Order Repetetion">MOR</label></td>
								<td align="left">: <%=entity.getMor()%></td>
							</tr>
							<tr>
								<td><label>Location</label></td>
								<td align="left">: <%=entity.getLocation()%></td>
							</tr>
						</tbody>
					</table>
				</fieldset>
				<fieldset  class="right fset min_h100" style="width: 300px;">
					<legend>Parts Supersession</legend>
					<table cellpadding="3" cellspacing="3" border="0" class="center m_left30" style="width: 300px;">
						<tbody>
							<tr>
								<td width="35%"><label>SS Parts Number</label></td>
								<td>: <%=entity.getSs_no()%></td>
							</tr>
							<tr>
								<td><label>SS Flag</label></td>
								<td>: <%=entity.getSs_flag()%></td>
							</tr>
						</tbody>
					</table>
				<div class="clear"></div>	
				</fieldset>
				
				
				<div class="clear"></div>
				
				<div class="center txt_center m_top10">
					<button class="btn_box" onclick="tb_remove();">ปิด</button>
				</div>
				
				