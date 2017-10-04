<%@page import="com.bitmap.report.job.bean.servicePartBean"%>
<%@page import="com.bitmap.bean.sale.MoneyDiscountRound"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.bitmap.bean.sale.Models"%>
<%@page import="com.bitmap.bean.sale.Brands"%>
<%@page import="com.bitmap.bean.parts.ServiceOutsourceDetail"%>
<%@page import="com.bitmap.bean.parts.ServiceOtherDetail"%>
<%@page import="com.bitmap.bean.parts.ServiceRepair"%>
<%@page import="com.bitmap.bean.parts.ServiceRepairDetail"%>
<%@page import="com.bitmap.bean.sale.Vehicle"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.ServicePartDetail"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="com.bitmap.bean.parts.ServiceSale"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.security.SecurityUser"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="Component.Accounting.Money.MoneyAccounting"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/clear_form.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/popup.js"></script>
<script src="../js/number.js"></script>
<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.datepicker.js"></script>
<script src="../js/ui/jquery.ui.button.js"></script>
<script src="../js/ui/jquery.ui.position.js"></script>
<script src="../js/ui/jquery.ui.autocomplete.js"></script>
<script src="../js/ZeroValueFormat.js" type="text/javascript"></script>
<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%
ServiceSale entity = new ServiceSale();
WebUtils.bindReqToEntity(entity, request);
ServiceSale.select(entity);

List listOutsource = ServiceOutsourceDetail.list(entity.getId());
List listRepair = ServiceRepairDetail.list(entity.getId());
List listOther = ServiceOtherDetail.list(entity.getId());
List listPart = entity.getUIListDetail();

ServiceRepair repair = ServiceRepair.select(entity.getId());
Personal recv = Personal.select(repair.getCreate_by());

Customer cus = new Customer();
if (entity.getCus_id().length() > 0) {
	cus = Customer.select(entity.getCus_id());
} else {
	cus.setCus_name_th(entity.getCus_name());
}

Vehicle vehicle = new Vehicle();
if (entity.getV_id().length() > 0) {
	vehicle = Vehicle.select(entity.getV_id());
} else {
	vehicle.setLicense_plate(entity.getV_plate());
}
%>
<title>Job ID: <%=entity.getId()%></title>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left"><strong>Job ID: <%=entity.getId()%></strong> [ <font style="color: yellow;"> Status: <%=ServiceSale.status(entity.getStatus()) %> </font>]</div>
				<div class="right">
					<!-- 
					<button class="btn_box" onclick="window.history.back();">Back</button>
					 -->
					
						<button class="btn_box" type="button" onclick="window.location='<%=LinkControl.link("sv_job_manage.jsp", (List)session.getAttribute("CS_ORDER_SEARCH"))%>';">Back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<form id="sale_part_form" onsubmit="return false;">
				<fieldset class="fset">
					<legend><Strong>Customer Detail</Strong></legend>
						<div class="left s400">
							<table class="s_auto">
								<tbody>
									<tr>
										<td width="40%"><Strong>Order ID</Strong></td>
										<td width="60%">: <%=entity.getId()%></td>
									</tr>
									<tr>
										<td><Strong>Vehicle Plate</Strong></td>
										<td>:  <%=entity.getV_plate()%> </td>
									</tr>
									<tr>
										<td><Strong>Vehicle Plate Province</Strong></td>
										<td>:  <%=entity.getV_plate_province()%> </td>
									</tr>
									<tr>
										<td><Strong>Brand</Strong></td>
										<td>: <%=(Brands.getUIName(entity.getBrand_id()) != null)?Brands.getUIName(entity.getBrand_id()):"-" %> </td>
									</tr>	
									<tr>
										<td><Strong>Model</Strong></td>
										<td>:  <%=(Models.getUIName(entity.getModel_id()) != null)?Models.getUIName(entity.getModel_id()):"-" %> </td>
									</tr>
									
								</tbody>
							</table>
						</div>
						
						
						<div class="right s400">
							<table class="s_auto">
								<tbody>
									<tr>
										<td width="30%"><Strong>Order Date</Strong></td>
										<td width="70%">: <%=WebUtils.getDateTimeValue(entity.getCreate_date())%></td>
									</tr>
									<tr>
										<td><label title="ประเภทการเข้ารับบริการ"><Strong>Service Type</Strong></label></td>
										<td>: <%=ServiceRepair.repairType_th(repair.getRepair_type()) %></td>
									</tr>
									<tr>
										<td><label title="พนักงานรับรถ"><Strong>Received by</Strong></label></td>
										<td>: <%=recv.getName() + " " + recv.getSurname()%></td>
									</tr>
									<tr>
										<td valign="top"><Strong>Customer Name</Strong></td>
										<td valign="top">:  <%=entity.getCus_name()%> </td>
									</tr>
									<tr>
										<td valign="top"><Strong>Customer Surame</Strong></td>
										<td valign="top">:  <%=entity.getCus_surname()%> </td>
									</tr>
								</tbody>
							</table>
						</div>
					
						<div class="clear"></div>
						<%
						String pattern_decimal = new String ( "#.00" );
						DecimalFormat decimal_format = new DecimalFormat ( pattern_decimal );
						%>
						
						<div >
							<div class="dot_line"></div>
							<div>
								<Strong>Service required / Problems </Strong> :
							</div>
							<div style="width: 100%;word-break:break-all" >
								- <%=repair.getProblem().replaceAll(" ", "&nbsp;").replaceAll("\n", "<br>- ")%>
							</div>
						</div>
						
				</fieldset>
				
				<fieldset class="fset">
					<legend><Strong>Service Description &amp; Parts List</Strong></legend>
					
					<div class="right">
						
						<!-- 
						<button class="btn_box btn_add thickbox s120" title="Select parts" lang="../part/sale_part_select.jsp?id=<%=entity.getId()%>&width=420&height=230">Parts</button>
					 	-->
						<% 
						////System.out.println("repair.getRepair_type::"+repair.getRepair_type());
						if(!repair.getRepair_type().equalsIgnoreCase("10")){ %>
						<button class="btn_box btn_add s120" title="Select parts" type="button"
								onclick="popupSetWH('../part/sale_part_search.jsp?id=<%=entity.getId()%>','1000','700');"> Parts</button>
					   <% } %>
					</div>
					<div class="clear"></div>
					<%// if(!repair.getRepair_type().equalsIgnoreCase("10")){ %> 
					<table class="bg-image s_auto breakword columntop">
						<%	if(!repair.getRepair_type().equalsIgnoreCase("10")){ %>
						<thead>
							<tr>
								<th valign="top" align="left" width="2%"></th>
								<th valign="top" align="left" width="2%"></th>
								<th valign="top" align="center" width="14%">Code</th>
								<th valign="top" align="center" width="30%">Description</th>
								<th valign="top" align="center" width="5%">Draw Qty</th>
								<th valign="top" align="center" width="5%">Issued Qty</th>
								<th valign="top" align="center" width="12%">Unit Price</th>
								<!-- <th valign="top" align="center" width="3%">V.A.T.</th> -->
								<th valign="top" align="center" width="11%">Price</th>
								<th valign="top" align="center" width="5%">Dis(%)</th>
								<th valign="top" align="center" width="12%">Net Price</th>
							</tr>
							
						</thead>
						<%} %>
						<tbody>
						<%
							boolean check_close = true;
							String total = "0";
							String total_net_price = "0";
							String total_discount = "0";
							String total_vat = "0";
							String part_total_net_price = "0";
							String part_total_discount = "0";
							
							Double vat_item_double = 0.00;
							String vat_item_string = "";

							Double vat_price_double = 0.00;
							String vat_price_string = "0";
							String total_vat_part = "0";
						
							String vat_part = "0";
							String vat_service = "0";
							String vat_other= "0";
							
							String total_part = "0";
							String total_service  = "0";
							String total_other = "0"; 
							
							Iterator ite = listPart.iterator();
							while(ite.hasNext()) {
								ServicePartDetail detailPart = (ServicePartDetail) ite.next();
								
								/* List listspd	= ServicePartDetail.list_sum(detailPart.getPn(), detailPart.getId());
								Iterator ite1 = listspd.iterator(); */
								/* while(ite1.hasNext()){
									servicePartBean detailPart1 = (servicePartBean) ite1.next(); */
								String net_price = "0";
								String total_price = "0";
								String disc = "0";
								String vat = "0";
								////System.out.println("price::"+detailPart.getPrice());
							
								net_price = Money.multiple(detailPart.getQty(), detailPart.getPrice());
								total_price = MoneyDiscountRound.disRound(net_price, Money.money(detailPart.getDiscount()));
								disc = Money.subtract(net_price, total_price);
								total_net_price = Money.add(total_net_price, net_price);
								total_discount = Money.add(total_discount, disc);
								total_part = Money.add(total_part , total_price);
								total = Money.add(total, total_price);
								
							if(detailPart.getTotal_vat().length()>0){
								vat = detailPart.getTotal_vat();
							}
							vat_part = Money.add(vat_part , vat);
						%>
							<tr>
								<%if(!detailPart.getCutoff_qty().equalsIgnoreCase("0")){//Case มีการเบิกอะไหล่แล้ว จะไม่สามารถลบหรือแก้ไขจำนวนได้%>
								<td align="center">
									<a class="btn_accept" title="Draw Parts Complete"></a>
								</td>
								<td align="center">
								<%-- 
									<a title="Update Parts Detail PN: <%=detailPart.getPn()%>" class="btn_update thickbox" lang="../part/sale_part_update_discount.jsp?id=<%=detailPart.getId()%>&number=<%=detailPart.getNumber()%>&width=420&height=230"></a>
								 --%>		
								 <a title="Update Parts Detail PN: <%=detailPart.getPn()%>" class="btn_update thickbox" lang="../part/sale_part_update_detail.jsp?id=<%=detailPart.getId()%>&number=<%=detailPart.getNumber()%>&width=420&height=230"></a>
							
								</td>
								<%}else{ //Case ยังไม่ได้เบิกอะไหล่ จะสามารถลบหรือแก้ไขจำนวนได้%>
								<td align="center">
									<a class="btn_del" onclick="deletePart('<%=detailPart.getId()%>','<%=detailPart.getNumber()%>','<%=detailPart.getUIDescription()%>','<%=detailPart.getPn()%>');"></a>
								</td>
								<td align="center">
									<a title="Update Parts Detail PN: <%=detailPart.getPn()%>" class="btn_update thickbox" lang="../part/sale_part_update_detail.jsp?id=<%=detailPart.getId()%>&number=<%=detailPart.getNumber()%>&width=420&height=230"></a>
								</td>
								<%}%>
								<td><%=detailPart.getPn() %></td>
								<td><%=detailPart.getUIDescription() %></td>
								<td align="right"><%=Money.moneyInteger(detailPart.getQty())%></td>
								<td align="right"><%=detailPart.getCutoff_qty()%></td>
								<td align="right"><%=Money.money(detailPart.getPrice()) %></td>
								<td align="right"><%=Money.money(net_price) %></td>
								<td align="right"><%=Money.money(detailPart.getDiscount())%></td>
								<td align="right"><%=Money.money(total_price) %></td>
								<input type="hidden" name="spd_net_price" id="spd_net_price" value="<%=Money.money(total_price)%>"> 
							</tr>
						<%

								vat_item_double = 0.00;
								vat_item_string = "";
								
								if ( !detailPart.getCutoff_qty().equalsIgnoreCase(detailPart.getQty()) ){//check เผื่อปิดจ๊อบ
									check_close = false;
								}
							 }
							//}
						%>
						</tbody>
					</table>
					<%	if(!repair.getRepair_type().equalsIgnoreCase("10")){ %>
					<div class="dot_line"></div>
					<%} %>
					<% ////System.out.println("repair.getRepair_type::"+repair.getRepair_type());
						if(!repair.getRepair_type().equalsIgnoreCase("12")){
					%>
					<div class="right m_top10">
						<button class="btn_box btn_add thickbox s120" type="button" title="Add Service Detail" lang="../cs/sv_job_service_add.jsp?id=<%=entity.getId()%>&width=420&height=230">Service</button>
					</div>
					<div class="clear"></div>
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th valign="top" align="left" width="3%"></th>
								<th valign="top" align="left" width="3%"></th>
								<th valign="top" align="center" width="10%">Code</th>
								<th valign="top" align="center" width="34%">Description</th>
								<th valign="top" align="center" width="11%">Unit Price</th>
								<th valign="top" align="center" width="7%">Disc(%)</th>
								<th valign="top" align="center" width="11%">Net Price</th>
							</tr>
						</thead>
						<tbody>
						<%
							
							Iterator iteSV = listRepair.iterator();
							while(iteSV.hasNext()) {
								ServiceRepairDetail detailRepair = (ServiceRepairDetail) iteSV.next();
								String net_price = "0";
								String total_price = "0";
								String disc = "0";
								String vat = "0";
	
								total = Money.add(total, total_price);
								net_price = Money.money(detailRepair.getLabor_rate());
								total_price = MoneyDiscountRound.disRound(net_price, Money.money(detailRepair.getDiscount()));
								
								disc = Money.subtract(net_price, total_price);
								total_service = Money.add(total_service, total_price);
								
								total_net_price = Money.add(total_net_price, net_price);
								total_discount = Money.add(total_discount, disc);
								total = Money.add(total, total_price);
							  	
								if(detailRepair.getTotal_vat().length()>0){
									vat = detailRepair.getTotal_vat();
								}
								vat_service = Money.add(vat_service , vat);

						%>
							<tr>
								<td align="center">
									<a class="btn_del" onclick="deleteService('<%=detailRepair.getId()%>','<%=detailRepair.getNumber()%>','<%=detailRepair.getLabor_name()%>');"></a>
								</td>
								<td align="center">
									<a title="Update Service Detail: <%=detailRepair.getLabor_name()%>" class="btn_update thickbox" lang="../cs/sv_job_service_update.jsp?id=<%=detailRepair.getId()%>&number=<%=detailRepair.getNumber()%>&width=420&height=230"></a>
								</td>
								<td align="center"><%=detailRepair.getLabor_id()%></td>
								<td><%=detailRepair.getLabor_name() %></td>
								<td align="right"><%=Money.money(detailRepair.getLabor_rate()) %></td>
								<td align="right"><%=Money.money(detailRepair.getDiscount())%></td>
								<td align="right"><%=Money.money(total_price)%></td>
								 <input type="hidden" name="srd_net_price" id="srd_net_price" value="<%=Money.money(total_price)%>"> 
							</tr>
						<%
							}
						%>
						
						
						</tbody>
					</table>	
					<div class="dot_line"></div>
					
					<div class="right m_top10">
						<button class="btn_box btn_add thickbox s120" type="button"  title="Add Miscellaneous" lang="../cs/sv_job_other_add.jsp?id=<%=entity.getId()%>&width=420&height=230">Miscellaneous</button>
					</div>
					<div class="clear"></div>
					
					<table class="bg-image s_auto breakword columntop">
						<thead>
							<tr>
								<th valign="top" align="left" width="3%"></th>
								<th valign="top" align="left" width="3%"></th>
								<th valign="top" align="center" width="45%">Description</th>
								<th valign="top" align="center" width="7%">Qty</th>
								<th valign="top" align="center" width="11%">Unit Price</th>
								<th valign="top" align="center" width="12%">Price</th>
								<th valign="top" align="center" width="7%">Disc(%)</th>
								<th valign="top" align="center" width="12%">Net Price</th>
							</tr>
						</thead>

						<tbody>
						<%				
							Iterator iteOther = listOther.iterator();
							while(iteOther.hasNext()) {
								ServiceOtherDetail detailOther = (ServiceOtherDetail) iteOther.next();
								String net_price = "0";
								String total_price = "0";
								String disc = "0";
								String vat = "0";
								
								net_price = Money.multiple(detailOther.getOther_qty(), detailOther.getOther_price());
								total_price = MoneyDiscountRound.disRound(net_price, Money.money(detailOther.getDiscount()));
								disc = Money.subtract(net_price, total_price);

								total_other = Money.add(total_other, total_price);
								
								total_net_price = Money.add(total_net_price, net_price);
								total_discount = Money.add(total_discount, disc);
								
					
								total = Money.add(total, total_price);
								
							
								
								if(detailOther.getTotal_vat().length()>0){
									vat = detailOther.getTotal_vat();
								}
							
								vat_other = Money.add(vat_other , vat);
						%>
							<tr>
								<td align="center">
									<a class="btn_del" onclick="deleteOther('<%=detailOther.getId()%>','<%=detailOther.getNumber()%>','<%=detailOther.getOther_name()%>');"></a>
								</td>
								<td align="center">
									<a title="Update Miscellaneous Detail: <%=detailOther.getOther_name()%>" class="btn_update thickbox" lang="../cs/sv_job_other_update.jsp?id=<%=detailOther.getId()%>&number=<%=detailOther.getNumber()%>&width=420&height=230"></a>
								</td>
								<td><%=detailOther.getOther_name() %></td>
								<td align="right"><%=detailOther.getOther_qty()%></td>
								<td align="right"><%=Money.money(detailOther.getOther_price()) %></td>
								<td align="right"><%=Money.money(net_price) %></td>
								<td align="right"><%=Money.money(detailOther.getDiscount())%></td>
								<td align="right"><%=Money.money(total_price) %></td>
								<input type="hidden" name="sod_net_price" id="sod_net_price" value="<%=Money.money(total_price)%>">
							</tr>
						<%
							}
						%>
						</tbody>
						
					</table>
					<% } %>
					<div class="dot_line"></div>
					<% 
						String summary_vat = "0";
						if(vat_other.length()>0 || vat_part.length()>0 || vat_service.length()>0){
							summary_vat = Money.add(vat_part, vat_service);
							summary_vat = Money.add(summary_vat, vat_other); 
						}
						
					%>
					
					<table class="bg-image s_auto">
						<tfoot>
							<tr>
								<td colspan="2" height="20"></td>
							</tr>
							<tr>
								<td width="700" align="right">Sub Total</td>
								<td width="250" align="right">
									<%=total_net_price%>
									<input type="hidden" name="total" id="total" value="<%=total_net_price%>">
								</td>
							</tr>
							<tr>
								<td align="right">Discount</td>
								<td align="right">
									<input  type="hidden" name="discount" id="discount"  value="<%=total_discount%>"/>
									<%=((Money.money(total_discount).equals("0.00"))?"":"-")+Money.money(total_discount)%>
									   
								
								</td>
							</tr>
							
							<tr class="txt_bold">
								<td align="right">Total Amount</td>
								<td align="right">
									<input type="hidden" name="total_amount" id="total_amount"  value="<%=Money.money(total)%>">
									 <span id="total_amount_text"> </span> 
										
										
								</td>
							</tr>
							
							<tr>
								<td colspan="2">
					<div class="dot_line"></div></td>
							</tr>
							<tr>
								<td align="right">Total Price</td>
								<td align="right">
									
									<%=Money.money(Money.subtract(total, summary_vat))%> 
									
									
								</td>
							</tr>
							<tr>
								<td align="right">
									VAT <%-- <input type="checkbox" <%=(entity.getVat().equalsIgnoreCase("7"))?"checked":""%> class="pointer" name="vat" id="vat" value="7">  --%>
									<input type="hidden" class="pointer" name="vat" id="vat" value="7"> 
									<label class="pointer" for="vat">7 %</label>
								</td>
								
								<td align="right">
									<%=Money.money(summary_vat)%> 
									<input  type="hidden"  name="pay"  id="pay" value="<%=summary_vat %>" /> 
								
								</td>
							</tr>
							<% 
									if(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_MA_REQUEST)  && check_close){
							%>
							<tr>
								<td align="right"> Received</td>
								<td align="right">
									 <input  type="text" class="txt_right required"  title="*****" name="received"  id="received" value="0.00"  /> 
								</td>
							</tr>
														<tr>
								<td align="right">Change</td>
								<td align="right">
									<span id="span_total_change"> </span>
									 <input  type="hidden"  name="total_change"  id="total_change">
									
								</td>
							</tr>
							<%} %>
						</tfoot>
					</table>
					

					<table class="s_auto">
						<tbody>
							<tr>
								<td colspan="2" height="10"><div class="dot_line"></div></td>
							</tr>
							<tr>
								<td colspan="2" height="10" align="center">
								
									<% 
									if(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_MA_REQUEST)  && check_close){
										%>
									<!-- /*********************************************/ -->
									<button type="submit" class="btn_box btn_warn" id="close_sv" onclick="close_order(<%=entity.getId()%>)">Close Job</button>
									<!-- /*********************************************/ -->
										
									<%} else{%>
									<button type="submit" class="btn_box btn_confirm"  onclick="window.location='sv_job_manage.jsp'">Save</button>
									
								<%-- 	<button type="button" class="btn_box btn_warn" id="close_sv" onclick="close_order(<%=entity.getId()%>)">Close Job</button> --%>
									
									<%} %>
									<input type="hidden" name="id" value="<%=entity.getId()%>">
									<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
								</td>
							</tr>
						</tbody>
					</table>
				</fieldset>
				</form>
				<div class="clear"></div>
					
				<script type="text/javascript">
				$(function(){
					
					var total_amount = $('#total_amount');
					var received = $('#received');
					
					var total_change = $('#total_change');
					var span_total_change = $('#span_total_change');
				/**************************************** เพิ่ม  + เปลี่ยน   ************************************************/	

				
					received.click(function(){					
						if (received.val() == "0.00" ) {
							received.val("");
						}						
					});
					received.blur(function(){
						if (received.val() == "" ) {
							received.val("0.00");
						}else{
							$('#received').focus();
						}						
					});
					
					total_amount.blur(function(){
						sumMoney();
					});
					received.keyup(function(){
						sumMoney();
					});
					
					function sumMoney(){
						span_total_change.text(received.val() - total_amount.val());		
						if(span_total_change.text() < 0.00){
							//alert('จำนวนเงินไม่พอจ่ายค่ะ !');
							$('#received').focus();
						} 
						span_total_change.text(money(received.val() - total_amount.val()));
						total_change.val(money(received.val() - total_amount.val()));
					}				
					
					var net = <%=total%>;
					
					$('#total_amount_text').text(money(net));
					$('#total_amount').val(net);
					
				});
	/****************************************  	เพิ่ม  + เปลี่ยน    ************************************************/	
				function save_order(id){
					ajax_load();
					$.post('../PartSaleManage',$('#sale_part_form').serialize() + '&action=job_save',function(resData){
						ajax_remove();
						if (resData.status == 'success') {
 							window.location.reload();
						} else {
							alert(resData.message);
						}
					},'json');
				}
				
				function close_order(id){

					if ($('#received').val() != "" ) {
						
						total = parseInt($('#total').val());
						recive = parseInt($('#received').val());						
						if (total == recive) {	
													
							if (confirm('Close Job?')) {
								ajax_load();
								$.post('../PartSaleManage',$('#sale_part_form').serialize() + '&action=job_close',function(resData){
									ajax_remove();
									if (resData.status == 'success') {										
										window.open('../cs/shop_print.jsp?id=<%=entity.getId()%>','_blank');
										window.location="sv_job_description_closed.jsp?id="+id;			 							
			 							
									} else {
										alert(resData.message);
									}
								},'json');
								
								//====== ********** นัฐยา ทำเพื่ออัพเดทข้อมูล Web Service   *******************=============//
								ajax_load();
								$.post('../CallWSSevrlet','action=updateShopToDc',function(response){	
								ajax_remove();  
									if (response.status == 'success') {
										//alert("update ข้อมูลซ่อม สำเร็จ");
									} else {
										alert(response.message);
									}
								},'json'); 
								//=================================================================================//
							} 
						
						}else if (total < recive) {
							alert('จ่ายเงินเกิน! กรุณาจ่ายเงินให้ครบ');
							$('#received').focus();
						
						}else{
							alert('กรุณาจ่ายเงินให้ครบก่อนปิด JOB !');
							$('#received').focus();
						}
							
							
					}else{
						alert('กรุณาจ่ายเงินก่อนปิด  JOB !');
						$('#received').focus();
					}
					
					
			}
				function deletePart(id,number,desc,pn){
					if (confirm('Remove Part PN: ' + pn + ' [' + desc + ']?')) {
						ajax_load();
						$.post('../PartSaleManage',{'id':id,'number':number,'action':'sale_part_delete'},function(resData){
							ajax_remove();
							if (resData.status == 'success') {
								window.location.reload();
							} else {
								alert(resData.message);
							}
						},'json');
					}
				}
				
				function deleteService(id,number,labor_name){
					if (confirm('Remove Service: ' + labor_name + '?')) {
						ajax_load();
						$.post('../PartSaleManage',{'id':id,'number':number,'action':'sale_service_delete'},function(resData){
							ajax_remove();
							if (resData.status == 'success') {
								window.location.reload();
							} else {
								alert(resData.message);
							}
						},'json');
					}
				}
				function deleteOther(id,number,other_name){
					if (confirm('Remove Miscellaneous: ' + other_name + '?')) {
						ajax_load();
						$.post('../PartSaleManage',{'id':id,'number':number,'action':'sale_other_delete'},function(resData){
							ajax_remove();
							if (resData.status == 'success') {
								window.location.reload();
							} else {
								alert(resData.message);
							}
						},'json');
					}
				}
				
				</script>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
</body>
</html>