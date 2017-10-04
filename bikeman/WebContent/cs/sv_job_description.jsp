<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bmp.special.fn.BMMoney"%>
<%@page import="com.bitmap.utils.report.Mobile"%>
<%@page import="com.bitmap.utils.ReportUtils"%>
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
<script src="../js/two_decimal_places.js" type="text/javascript"></script>
<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table_sale.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<!-- autoNumeric -->
	<script type="text/javascript" src="../js/autoNumeric/two_decimal_places.js" ></script>
	<script type="text/javascript" src="../js/autoNumeric/autoNumeric.js" ></script>
	<script type="text/javascript" src="../js/autoNumeric/jquery.autotab-1.1b.js" ></script>
	
	<script type="text/javascript" src="../js/autoNumeric/jquery-price_format-2-0-min.js" ></script>
	<script type="text/javascript" src="../js/autoNumeric/jquery-price_format-2-0.js" ></script>
	

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%
ServiceSale entity = new ServiceSale();
WebUtils.bindReqToEntity(entity, request);
if(!entity.getId().equalsIgnoreCase("")){
ServiceSale.select(entity);
}
ServiceRepair repair = ServiceRepair.select(entity.getId());

//System.out.println("Create_by : "+repair.getCreate_by());
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

List listOutsource = ServiceOutsourceDetail.list(entity.getId());
List listRepair = ServiceRepairDetail.list(entity.getId());
List listOther = ServiceOtherDetail.list(entity.getId());
List listPart = entity.getUIListDetail();

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
										<td width="40%"><Strong>Job ID</Strong></td>
										<td width="60%">: <%=entity.getId()%></td>
									</tr>
									<tr>
										<td><Strong>เลขทะเบียนรถ</Strong></td>
										<td>:  <%=entity.getV_plate()%> </td>
									</tr>
									<tr>
										<td><Strong>จังหวัดทะเบียนรถ</Strong></td>
										<td>:  <%=entity.getV_plate_province()%> </td>
									</tr>
									<tr>
										<td><Strong>ยี่ห้อ</Strong></td>
										<td>: <%=(Brands.getUIName(entity.getBrand_id()) != null)?Brands.getUIName(entity.getBrand_id()):"-" %> </td>
									</tr>	
									<tr>
										<td><Strong>รุ่น</Strong></td>
										<td>:  <%=(Models.getUIName(entity.getModel_id()) != null)?Models.getUIName(entity.getModel_id()):"-" %> </td>
									</tr>
									<tr>
										<td><Strong>เลขไมล์</Strong></td>
										<td>:  <%=(repair.getMile() != null)?repair.getMile():"-" %> </td>
									</tr>
									<tr>
										<td valign="top"><Strong>ชื่อลูกค้า</Strong></td>
										<td valign="top">:  <%=entity.getForewordname()+"		"+entity.getCus_name()%> </td>
									</tr>
									<tr>
										<td valign="top"><Strong>นามสกุล</Strong></td>
										<td valign="top">:  <%=entity.getCus_surname()%> </td>
									</tr>
									<tr>
										<td valign="top"><Strong>เลขประจำตัวผู้เสียภาษี</Strong></td>
										<td valign="top">:  <%=entity.getTax_id()%> </td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="right s400">
							<table class="s_auto">
								<tbody>
									<tr>
										<td width="30%"><Strong>วันที่เข้ารับบริการ</Strong></td>
										<td width="70%">: <%=WebUtils.getDateTimeValue(entity.getCreate_date())%></td>
									</tr>
									<tr>
										<td><label title="ประเภทการเข้ารับบริการ"><Strong>ประเภทงานบริการ</Strong></label></td>
										<td>: <%=ServiceRepair.repairType_th(repair.getRepair_type()) %></td>
									</tr>
									<tr>
										<td><label title="พนักงานรับรถ"><Strong>รับรถโดย</Strong></label></td>
										<td>: <%=recv.getName() + " " + recv.getSurname()%></td>
									</tr>
									<tr>
										<td colspan="2" >&nbsp;</td>
									</tr>
									<tr>
										<td colspan="2" >&nbsp;</td>
									</tr>
									<tr>
										<td colspan="2" >&nbsp;</td>
									</tr>
									<tr>
										<td colspan="2" >&nbsp;</td>
									</tr>
									<tr>
										<td class="txt_bold"><label title="ผู้ที่นำรถมา">ชื่อผู้ติดต่อ</label></td>
										<td>: <%=repair.getDriven_by()%></td>
									</tr>
									<tr>
										<td class="txt_bold"><label title="เบอร์ติดต่อผู้นำรถมา">เบอร์โทรศัพท์</label></td>
										<td>:<%=Mobile.mobile(repair.getDriven_contact()) %></td>
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
								<Strong>บริการที่ร้องขอ</Strong> :
							</div>
							<div style="width: 100%;word-break:break-all" >
								- <%=repair.getProblem().replaceAll(" ", "&nbsp;").replaceAll("\n", "<br>- ")%>
							</div>
						</div>
						
				</fieldset>
<!-- /***********************************************************************************************************************************/ -->				
				<fieldset class="fset">
					<legend><Strong>Service Description &amp; Parts List</Strong></legend>				
					<div class="right">
						<% 						
						if(!repair.getRepair_type().equalsIgnoreCase("10")){ %>
						<button class="btn_box btn_add s120" title="Select parts" type="button"
								onclick="popupSetWH('../part/sale_part_search.jsp?id=<%=entity.getId()%>','1000','700');"> Parts</button>
					   <% } %>
					</div>
					<div class="clear"></div>					 
					<table class="bg-image s_auto breakword columntop" style="border: 1px solid #555;">
						<%	if(!repair.getRepair_type().equalsIgnoreCase("10")){ %>
						<thead>
							<tr>
								<th valign="top" align="left" width="2%"></th>
								<th valign="top" align="left" width="2%"></th>
								<th valign="top" align="center" width="15%">Code</th>
								<th valign="top" align="center" width="25%">Description</th>
								<th valign="top" align="center" width="5%">Units</th>
								<th valign="top" align="center" width="5%">Draw Qty</th>
								<th valign="top" align="center" width="5%">Issued Qty</th><!-- // Order Qty // -->				
								<th valign="top" align="center" width="12%">Unit Price</th>
								<th valign="top" align="center" width="11%">Price</th>
								<th valign="top" align="center" width="5%">Discount</th>
								<th valign="top" align="center" width="12%">Net Price</th>
							</tr>
							
						</thead>
						<%} %>
						<tbody>
						<%
							boolean check_close = true;
							String total_all 	="0"; //Sub Total(total)
							String discount_all	   	="0"; //Discount (discount)
							String total_amount		="0"; //Total Amount(total_amount)
							String total_price_all	="0"; //Total Price 
							String total_vat_all	="0"; //VAT 7 %	(pay)
												
							
							Iterator ite = listPart.iterator();
							while(ite.hasNext()) {
								ServicePartDetail detailPart = (ServicePartDetail) ite.next();
								if(detailPart.getTotal_price().equalsIgnoreCase("")||detailPart.getTotal_price().equalsIgnoreCase(null)){
									 
								String total_price =	BMMoney.MoneyMultiple(BMMoney.removeCommas(detailPart.getQty()), BMMoney.removeCommas(detailPart.getPrice()));
								//System.out.println(total_price);
								detailPart.setTotal_price(total_price);
								
								}
								total_all 		= Money.add(total_all, detailPart.getTotal_price());
								total_amount	= Money.add(total_amount, detailPart.getSpd_net_price());
								discount_all	= Money.add(discount_all,detailPart.getSpd_dis_total());
								
								String UnitDesc = UnitType.selectName(PartMaster.SelectUnitDesc(detailPart.getPn()));
							
						%>
							<tr>
								<%if(detailPart.getCutoff_qty().equalsIgnoreCase(detailPart.getQty())){//Case มีการเบิกอะไหล่แล้ว จะไม่สามารถลบหรือแก้ไขจำนวนได้%>
								<td align="center">
									<a class="btn_accept" title="Draw Parts Complete"></a>
								</td>
								<td align="center">									
								 <a title="Update Parts Detail PN: <%=detailPart.getPn()%>" class="btn_update thickbox" lang="../part/sale_part_update_detail.jsp?id=<%=detailPart.getId()%>&number=<%=detailPart.getNumber()%>&width=420&height=270"></a>
							
								</td>
								<%}else{ //Case ยังไม่ได้เบิกอะไหล่ จะสามารถลบหรือแก้ไขจำนวนได้%>
								<td align="center">
									<a class="btn_del" onclick="deletePart('<%=detailPart.getId()%>','<%=detailPart.getNumber()%>','<%=detailPart.getUIDescription()%>','<%=detailPart.getPn()%>');"></a>
								</td>
								<td align="center">
									<a title="Update Parts Detail PN: <%=detailPart.getPn()%>" class="btn_update thickbox" lang="../part/sale_part_update_detail.jsp?id=<%=detailPart.getId()%>&number=<%=detailPart.getNumber()%>&width=420&height=270"></a>
								</td>
								<%}%>
								<td align="left"><%=detailPart.getPn() %></td>
								<td align="left"><%=detailPart.getUIDescription() %></td>
								<td align="left"><%=UnitDesc%></td>
								<td align="right"><%=Money.moneyInteger(detailPart.getCutoff_qty())%></td>
								<td align="right"><%=Money.moneyInteger(detailPart.getQty())%></td>
								<td align="right"><%=Money.money(detailPart.getPrice()) %></td>
								<td align="right"><%=Money.money(detailPart.getTotal_price()) %></td>
								<td align="right"><%=detailPart.getSpd_dis_total().equalsIgnoreCase("")?"0.00":Money.money(detailPart.getSpd_dis_total())%></td>
								<td align="right"><%=Money.money(detailPart.getSpd_net_price()) %></td>
								
							</tr>
						<%								
								if ( !detailPart.getCutoff_qty().equalsIgnoreCase(detailPart.getQty()) ){//check เผื่อปิดจ๊อบ
									check_close = false;
								}
							 }							
						%>
						</tbody>
					</table>
					<%	if(!repair.getRepair_type().equalsIgnoreCase("10")){ %>
					<div class="dot_line"></div>
					<%} %>
					<% 
						if(!repair.getRepair_type().equalsIgnoreCase("12")){
					%>
					<div class="right m_top10">
						<button class="btn_box btn_add thickbox s120" type="button" title="Add Service Detail" lang="../cs/sv_job_service_add.jsp?id=<%=entity.getId()%>&width=470&height=250">Service</button>
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
								<th valign="top" align="center" width="7%">Discount</th>
								<th valign="top" align="center" width="11%">Net Price</th>
							</tr>
						</thead>
						<tbody>
						<%
							
							Iterator iteSV = listRepair.iterator();
							while(iteSV.hasNext()) {
								ServiceRepairDetail detailRepair = (ServiceRepairDetail) iteSV.next();
								
								total_all 		= Money.add(total_all, detailRepair.getLabor_rate());
								total_amount	= Money.add(total_amount, detailRepair.getSrd_net_price());
								discount_all	= Money.add(discount_all,detailRepair.getSrd_dis_total());
															
						%>
							<tr>
								<td align="center">
									<a class="btn_del" onclick="deleteService('<%=detailRepair.getId()%>','<%=detailRepair.getNumber()%>','<%=detailRepair.getLabor_name()%>');"></a>
								</td>
								<td align="center">
									<a title="Update Service Detail: <%=detailRepair.getLabor_name()%>" class="btn_update thickbox" lang="../cs/sv_job_service_update.jsp?id=<%=detailRepair.getId()%>&number=<%=detailRepair.getNumber()%>&width=420&height=230"></a>
								</td>
								<td align="left"><%=detailRepair.getLabor_id()%></td>
								<td align="left"><%=detailRepair.getLabor_name() %></td>
								<td align="right"><%=Money.money(detailRepair.getLabor_rate()) %></td>
								<td align="right"><%=detailRepair.getSrd_dis_total().equalsIgnoreCase("")?"0.00":Money.money(detailRepair.getSrd_dis_total())%></td>
								<td align="right"><%=Money.money(detailRepair.getSrd_net_price())%></td>
								
							
							</tr>
						<%
							}
						%>
												
						</tbody>
						
					</table>					
					
					<div class="dot_line"></div>
					
					<div class="right m_top10">
						<button class="btn_box btn_add thickbox s120" type="button"  title="Add Miscellaneous" lang="../cs/sv_job_other_add.jsp?id=<%=entity.getId()%>&width=470&height=250">Miscellaneous</button>
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
								<th valign="top" align="center" width="7%">Discount</th>
								<th valign="top" align="center" width="12%">Net Price</th>
							</tr>
							
						</thead>

						<tbody>
						<%				
							Iterator iteOther = listOther.iterator();
							while(iteOther.hasNext()) {
								ServiceOtherDetail detailOther = (ServiceOtherDetail) iteOther.next();
								if(detailOther.getTotal_price().equalsIgnoreCase("")||detailOther.getTotal_price().equalsIgnoreCase(null)){
									 
									String total_price =	BMMoney.MoneyMultiple(BMMoney.removeCommas(detailOther.getOther_qty()), BMMoney.removeCommas(detailOther.getOther_price()));
									//System.out.println(total_price);
									detailOther.setTotal_price(total_price);
									
									}
																								
								total_all		= Money.add(total_all, detailOther.getTotal_price());
								total_amount	= Money.add(total_amount, detailOther.getSod_net_price());
								discount_all	= Money.add(discount_all,detailOther.getSod_dis_total());
								
								
						%>
							<tr>
								<td align="center">
									<a class="btn_del" onclick="deleteOther('<%=detailOther.getId()%>','<%=detailOther.getNumber()%>','<%=detailOther.getOther_name()%>');"></a>
								</td>
								<td align="center">
									<a title="Update Miscellaneous Detail: <%=detailOther.getOther_name()%>" class="btn_update thickbox" lang="../cs/sv_job_other_update.jsp?id=<%=detailOther.getId()%>&number=<%=detailOther.getNumber()%>&width=420&height=230"></a>
								</td>
								<td align="left"><%=detailOther.getOther_name() %></td>
								<td align="right"><%=Money.moneyInteger(detailOther.getOther_qty())%></td>
								<td align="right"><%=Money.money(detailOther.getOther_price()) %></td>
								<td align="right"><%=Money.money(detailOther.getTotal_price()) %></td>
								<td align="right"><%=detailOther.getSod_dis_total().equalsIgnoreCase("")?"0.00":Money.money(detailOther.getSod_dis_total())%></td>
								<td align="right"><%=Money.money(detailOther.getSod_net_price()) %></td>
																
							
							</tr>
						<%
							}
						%>
						</tbody>
						
					</table>
					<% } %>
					<div class="dot_line"></div>
					<% 						
												
						total_vat_all 	= BMMoney.MoneyVat(total_amount,"7");
						total_price_all = BMMoney.MoneySubtract(total_amount, total_vat_all); 
					%>
					
					<table class="bg-image s_auto">
						<tfoot>
							<tr>
								<td colspan="2" height="20"></td>
							</tr>
							<tr>
								<td width="700" align="right">Sub Total</td>
								<td width="250" align="right">
									<%=Money.money(total_all)%>
									<input type="hidden" name="total" id="total" value="<%=BMMoney.removeCommas(Money.money(total_all))%>">
								</td>
							</tr>
							<tr>
								<td align="right">Discount</td>
								<td align="right">
									<input  type="hidden" name="discount" id="discount"  value="<%=BMMoney.removeCommas(Money.money(discount_all))%>"/>
									<%if( discount_all.equalsIgnoreCase("") || discount_all.equalsIgnoreCase("0") || discount_all.equalsIgnoreCase("0.00")){%>
									<%=Money.money("0")%>
									<%}else{%>
									<%=Money.money("-"+discount_all)%>
								    <%} %>
								
								</td>
							</tr>
							
							<tr class="txt_bold">
								<td align="right">Total Amount</td>
								<td align="right">
									<input type="hidden" name="total_amount" id="total_amount"  value="<%= BMMoney.removeCommas(Money.money(total_amount)) %>">
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
									<%=Money.money(total_price_all)%> 
								</td>
							</tr>
							<tr>
								<td align="right">
									VAT 
									<input type="hidden" class="pointer" name="vat" id="vat" value="7"> 
									<label class="pointer" for="vat">7 %</label>
								</td>
								
								<td align="right">
								<!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
									<%=Money.money(total_vat_all)%> 
								<!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	 -->
									<input  type="hidden"  name="pay"  id="pay" value="<%=BMMoney.removeCommas(Money.money(total_vat_all)) %>" /> 
								
								</td>
							</tr>
							<% 
									if(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_MA_REQUEST)  && check_close){
							%>
							<tr>
								<td align="right"> Received</td>
								<td align="right">
									 <input  type="text" class="txt_right required auto"  title="*****" name="received"  id="received" value="0.00" maxlength="19"  /> 
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
									<%} %>
									<input type="hidden" name="id" value="<%=entity.getId()%>">
									<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
								</td>
							</tr>
						</tbody>
					</table>
				</fieldset>
				
<!-- /************************************************************************************************************************************/ -->				

				</form>
				<div class="clear"></div>
					
				<script type="text/javascript">
				$(function(){
										
					var total_amount = $('#total_amount');
					var received = $('#received');					
					var total_change = $('#total_change');
					var span_total_change = $('#span_total_change');
															
					var net = <%=total_amount%>;					
					$('#total_amount_text').text('<%=Money.money(total_amount)%>');
					$('#total_amount').val(net);
					
					
				/**************************************** เพิ่ม  + เปลี่ยน   ************************************************/	

					
					received.click(function(){					
						if (received.val() == "0.00" ) {
							received.val("");
							total_change.val("0.00");
						}						
					});
					
					
					received.keyup(function(){		 						 
						$('#received').autotab_magic().autotab_filter( {format: 'custom', pattern: '[^0-9\.]', maxlength: 15 });// จุดทศนิยม 						
						sumMoney();
					});
														
					received.blur(function(){
						if (received.val() == "" || received.val() == "0") {
							received.val("0.00");
							$('#received').focus();
							total_change.val("0.00");
						}else{
							sumMoney();	
						}
																										
					});
					
					$('#received').keypress(function (e) {
						  if (e.which == 13) {
							  sumMoney();	
						  }
					});
				
				
					function sumMoney(){	
						
						if( received.val() == "" || received.val() == "0" || received.val() == "0.00" ) {
							total_change.val("0.00");
						}else{								
							var Change = received.val() - total_amount.val();								
							span_total_change.text(money(Change));
							total_change.val(money(Change));																
						}
						 
					
							}
					
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
						var total_amount_base ="<%=total_amount%>";
						var total_amount_check = parseFloat(total_amount_base);
						var recive = parseFloat($('#received').val());	
						//alert("recive:"+recive+"total_amount:"+total_amount_check); 		
						
						if (total_amount_check <= recive) {	
													
							if (confirm('Close Job?')) {
								ajax_load();
								$.post('../PartSaleManage',$('#sale_part_form').serialize() + '&action=job_close',function(resData){
									ajax_remove();
									if (resData.status == 'success') {										
										window.open('../cs/shop_print.jsp?id=<%=entity.getId()%>','_blank'); 
										 			 										 							
									} else {
										alert(resData.message);
									}
								},'json');
								
								//====== ********** นัฐยา ทำเพื่ออัพเดทข้อมูล Web Service   *******************=============//
								ajax_load();
								$.post('../CallWSSevrlet','action=updateShopToDc',function(response){	
								ajax_remove();  
									if (response.status == 'success') {
										window.location="sv_job_description_closed.jsp?id="+id;
										//alert("update ข้อมูลซ่อม สำเร็จ");
									} else {
										
										window.location="sv_job_description_closed.jsp?id="+id;
										//alert(response.message);
										
									}
								},'json'); 
								//=================================================================================//
								
							} 
						
						}else {
							
							alert('จำนวนที่รับเงินไม่พอชำระรายการค่ะ!');
							$('#received').focus();
							
							/* if( total_change.val() < "0.00" || total_change.val() < "0"){
								alert('จำนวนเงินไม่พอจ่ายค่ะ !');
								$('#received').focus();
								
							} */
						}
							
							
					}else{
						alert('กรุณาจ่ายเงินก่อนปิด  JOB !');
						$('#received').focus();
					}
					
					
			}
				
/******************************************** DELETE ******************************************************/				
				/* ######################## service_part_detail ########################### */
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
				/* ######################## service_repair_detail ########################### */
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
				/* ######################## service_other_detail ########################### */
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
				
/******************************************** DELETE ******************************************************/	
				</script>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>