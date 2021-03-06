<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.parts.ServiceRepair"%>
<%@page import="com.bitmap.bean.sale.Vehicle"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.bean.parts.ServiceOtherDetail"%>
<%@page import="com.bitmap.bean.parts.ServiceRepairDetail"%>
<%@page import="com.bitmap.utils.SNCUtils"%>
<%@page import="com.bitmap.barcode.Barcode128"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.ServicePartDetail"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.parts.ServiceSale"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css">
<link href="../css/unit.css" rel="stylesheet" type="text/css">
<link href="../css/theme_print.css" rel="stylesheet" type="text/css">

<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/jquery.metadata.js" type="text/javascript"></script>
<script src="../js/jquery.validate.js" type="text/javascript"></script>
<script src="../js/thickbox.js" type="text/javascript"></script>
<script src="../js/loading.js" type="text/javascript"></script>
<script src="../js/number.js" type="text/javascript"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
ServiceSale entity = new ServiceSale();
WebUtils.bindReqToEntity(entity, request);
ServiceSale.select(entity);

Barcode128.genBarcode(WebUtils.getInitParameter(session, SNCUtils.IMG_PATH_BARCODE), entity.getId());

ServiceRepair repair = ServiceRepair.select(entity.getId());
Personal recv = Personal.select(repair.getCreate_by());

List list = entity.getUIListDetail();
List listRepair = ServiceRepairDetail.list(entity.getId());
List listOther = ServiceOtherDetail.list(entity.getId());

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
<title>Invoice : <%=entity.getId()%></title>
<style type="text/css">
.tb{border-collapse: collapse;}
.tb tr, .tb td, .tb th{border: .5pt solid #000;border-top: .5pt solid #000; border-bottom: .5pt solid #000;}

.tb tfoot td
{
	border: none;
}

.bb{border: 1px solid #000;}

.po_body{border-collapse: collapse;}
.po_body thead th{border-top: 1px solid #000; border-left: 1px solid #000;border-right: 1px solid #000;}
.po_body tbody tr, .po_body tbody td{border-left: 1px solid #000;border-right: 1px solid #000;}
.po_body td{padding: 1px 3px;}
.po_body tfoot td {border-top: 1px solid #000;}
</style>
<script type="text/javascript">
$(function(){
	setTimeout('window.print()',500); 
	setTimeout('window.close()',1000);
});
</script>
</head>
<body style="background-color: #fff; color: #000;">

<div class="wrap_print">
<table cellpadding="0" cellspacing="0" style="padding: 0; margin: 0;">
	<thead style="display:table-header-group;" align="left">
		<tr>
			<th align="left" style="font-weight: normal;">
				<div class="head_info">
					<div class="head_logo">
						<img src="../images/showroom/logo.png" width="130" height="80">
					</div>
					<div class="head_address">
						<p>บริษัท ศรณรงค์ คาร์ จำกัด</p>
						<p>16/13 ม.2 ถ.แจ้งวัฒนะ ต.คลองเกลือ อ.ปากเกร็ด จ.นนทบุรี 11120</p>
						<p>โทร. 0-2980-8655-6  แฟกซ์ กด 111  www.sncshowroom.com</p>
					</div>
					<div class="clear"></div>
				</div>
			
				<div class="bb right txt_center">
					<div class="txt_bold txt_18 m_left5 m_right5 m_top5">เลขที่ใบแจ้งหนี้</div>
					<div class="center txt_center"><img src="../../images/motoshop/barcode/<%=entity.getId()%>.png"></div>
				</div>
				<div class="clear"></div>
				
				<table class="s_auto">
					<tr valign="top">
						<td width="55%">คุณ <%=entity.getCus_name()%></td>
						<td width="15%">Job ID</td>
						<td width="30%">: <%=entity.getId()%> in: <%=WebUtils.getDateTimeValue(entity.getCreate_date())%></td>
					</tr>
					<tr valign="top">
						<td><%=(cus.getCus_phone().length()>0)?cus.getCus_phone() + "&nbsp;":""%><%=cus.getCus_mobile()%></td>
						<td>Register</td>
						<td>: <%=entity.getV_plate()%></td>
					</tr>
					<tr valign="top">
						<td rowspan="4"><%=cus.getCus_address()%></td>
						<td>Franchise</td>
						<td>: <%=vehicle.getUIMaster().getUIBrand()%>&nbsp;<%=vehicle.getUIMaster().getUIModel()%>&nbsp;<%=vehicle.getUIMaster().getNameplate()%></td>
					</tr>
					<tr valign="top">
						<td>Chassis</td>
						<td>: <%=vehicle.getVin()%></td>
					</tr>
					<tr valign="top">
						<td>Mileage</td>
						<td>: <%=repair.getMile()%></td>
					</tr>
					<tr valign="top">
						<td>CS</td>
						<td>: <%=recv.getName() + " " + recv.getSurname()%></td>
					</tr>
				</table>
				<div class="dot_line"></div>
			</th>
		</tr>
	</thead>
	<tbody style="display:table-body-group;">
		<tr>
			<td>
				<div class="s_auto m_top5">
					<table class="po_body s_auto">
						<thead style="display:table-header-group;">
							<tr>
								<th valign="top" align="center" width="35%">Description</th>
								<th valign="top" align="center" width="10%">Qty</th>
								<th valign="top" align="center" width="15%">Unit Price</th>
								<th valign="top" align="center" width="15%">Net Price</th>
								<th valign="top" align="center" width="10%">Disct(%)</th>
								<th valign="top" align="center" width="20%">Total Price</th>
							</tr>
						</thead>
						<tbody valign="top">
						<%
							String total = "0";
							String total_net_price = "0";
							String total_discount = "0";
							
							String part_total_net_price = "0";
							String part_total_discount = "0";
							
							Iterator ite = list.iterator();
							if(list.size()>0){
						%>
							<tr>
								<td>
									** Parts **
								</td>
								<td align="right"></td>
								<td align="right"></td>
								<td align="right"></td>
								<td align="right"></td>
								<td align="right"></td>
							</tr>
						<%
							}
							while(ite.hasNext()) {
								ServicePartDetail detail = (ServicePartDetail) ite.next();
								String net_price = "0";
								String total_price = "0";
								String disc = "0";
								
								net_price = Money.multiple(detail.getQty(), detail.getPrice());
								total_price = Money.discount(net_price, detail.getDiscount());
								disc = Money.subtract(net_price, total_price);
								
								total_net_price = Money.add(total_net_price, net_price);
								total_discount = Money.add(total_discount, disc);
								part_total_net_price = Money.add(part_total_net_price, net_price);
								part_total_discount = Money.add(part_total_discount, disc);
								total = Money.add(total, total_price);
						%>
							<tr>
								<td><div class="m_left10">- <%=detail.getUIDescription() %></div></td>
								<td align="right"><%=detail.getQty()%></td>
								<td align="right"><%=Money.money(detail.getPrice()) %></td>
								<td align="right"><%=Money.money(net_price) %></td>
								<td align="right"><%=detail.getDiscount()%></td>
								<td align="right"><%=Money.money(total_price) %></td>
							</tr>
						<%
							}
						
							String sv_total_net_price = "0";
							String sv_total_discount = "0";
							
							Iterator iteSV = listRepair.iterator();
							if(listRepair.size()>0){
						%>
							<tr>
								<td>
									** Service **
								</td>
								<td align="right"></td>
								<td align="right"></td>
								<td align="right"></td>
								<td align="right"></td>
								<td align="right"></td>
							</tr>
						<%
							}
							while(iteSV.hasNext()) {
								ServiceRepairDetail detailRepair = (ServiceRepairDetail) iteSV.next();
								String net_price = "0";
								String total_price = "0";
								String disc = "0";
								
								net_price = Money.multiple(detailRepair.getLabor_qty(), detailRepair.getLabor_rate());
								total_price = Money.discount(net_price, detailRepair.getDiscount());
								disc = Money.subtract(net_price, total_price);
								
								total_net_price = Money.add(total_net_price, net_price);
								total_discount = Money.add(total_discount, disc);
								sv_total_net_price = Money.add(sv_total_net_price, net_price);
								sv_total_discount = Money.add(sv_total_discount, disc);
								total = Money.add(total, total_price);
						%>
							<tr>
								<td><div class="m_left10">- <%=detailRepair.getLabor_name()%></div></td>
								<td align="right"><%=detailRepair.getLabor_qty()%></td>
								<td align="right"><%=Money.money(detailRepair.getLabor_rate()) %></td>
								<td align="right"><%=Money.money(net_price) %></td>
								<td align="right"><%=detailRepair.getDiscount()%></td>
								<td align="right"><%=Money.money(total_price) %></td>
							</tr>
						<%
							}
						
							String other_total_net_price = "0";
							String other_total_discount = "0";
							
							Iterator iteOther = listOther.iterator();
							if(listOther.size()>0){
						%>
							<tr>
								<td>
									** Miscellaneous **
								</td>
								<td align="right"></td>
								<td align="right"></td>
								<td align="right"></td>
								<td align="right"></td>
								<td align="right"></td>
							</tr>
						<%
							}
							while(iteOther.hasNext()) {
								ServiceOtherDetail detailOther = (ServiceOtherDetail) iteOther.next();
								String net_price = "0";
								String total_price = "0";
								String disc = "0";
								
								net_price = Money.multiple(detailOther.getOther_qty(), detailOther.getOther_price());
								total_price = Money.discount(net_price, detailOther.getDiscount());
								disc = Money.subtract(net_price, total_price);
								
								total_net_price = Money.add(total_net_price, net_price);
								total_discount = Money.add(total_discount, disc);
								other_total_net_price = Money.add(other_total_net_price, net_price);
								other_total_discount = Money.add(other_total_discount, disc);
								total = Money.add(total, total_price);
						%>
							<tr>
								<td><div class="m_left10">- <%=detailOther.getOther_name()%></div></td>
								<td align="right"><%=detailOther.getOther_qty()%></td>
								<td align="right"><%=Money.money(detailOther.getOther_price()) %></td>
								<td align="right"><%=Money.money(net_price) %></td>
								<td align="right"><%=detailOther.getDiscount()%></td>
								<td align="right"><%=Money.money(total_price) %></td>
							</tr>
						<%
							}
						%>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="7"></td>
							</tr>
						</tfoot>
					</table>
					
					<div class="dot_line m_top10"></div>
					
					<div style="width: 310px;; float: left;">
						<table class="s_auto">
							<tbody>
								<tr>
									<td width="101"></td>
									<td align="right" width="101">Net Price</td>
									<td align="right" width="101">Total Disct</td>
								</tr>
								<tr>
									<td>Parts</td>
									<td align="right"><%=Money.money(part_total_net_price)%></td>
									<td align="right"><%=Money.money(part_total_discount)%></td>
								</tr>
								<tr>
									<td>Service</td>
									<td align="right"><%=Money.money(sv_total_net_price)%></td>
									<td align="right"><%=Money.money(sv_total_discount)%></td>
								</tr>
								<tr>
									<td>Miscellaneous</td>
									<td align="right"><%=Money.money(other_total_net_price)%></td>
									<td align="right"><%=Money.money(other_total_discount)%></td>
								</tr>
							</tbody>
						</table>
					</div>
					
					<div style="width: 280px; float: right;">
						<table class="s_auto">
							<tbody>
								<tr>
									<td width="50%" align="left">Before Disct.</td>
									<td width="50%" align="right"><%=Money.money(total_net_price)%></td>
								</tr>
								<tr>
									<td align="left">Discount</td>
									<td align="right"><%=Money.money(total_discount)%></td>
								</tr>
								<tr>
									<td align="left">Net</td>
									<td align="right"><%=Money.money(total)%></td>
								</tr>
								<tr>
									<td align="left">V.A.T. <%=(entity.getVat().equalsIgnoreCase("7"))?"7":"0"%> %</td>
									<td align="right"><span id="show_vat"><%=(entity.getVat().equalsIgnoreCase("7"))?Money.money(Money.vat(total)):"0.00"%></span></td>
								</tr>
								<tr class="txt_bold">
									<td align="left">Total Amount</td>
									<td align="right">
										<span id="total_amount"><%=(entity.getVat().equalsIgnoreCase("7"))?Money.money(Money.add(total, Money.vat(total))): Money.money(total)%></span>
										<input type="hidden" name="total" id="total" value="<%=(entity.getVat().equalsIgnoreCase("7"))?Money.money(Money.add(total, Money.vat(total))): Money.money(total)%>">
									</td>
								</tr>
							</tbody>
						</table>
						
					</div>
					
					<div class="clear"></div>
					
					<div class="txt_right">
						รวมเป็นเงิน (<%=Money.convertMoney2Thai((entity.getVat().equalsIgnoreCase("7"))?Money.money(Money.add(total, Money.vat(total))): Money.money(total))%>)
					</div>
				</div>
			</td>
		</tr>
	</tbody>
	<tfoot style="display:table-foot-group;">
		<tr>
			<td>
				<div class="dot_line"></div>
	
				<div class="s_auto m_top10">
					<table class="tb s_auto">
						<tbody>
							<tr>
								<td width="25%" align="center">
									<br>
									<br>
									<br>
									.....................................................<br>
									Delivery By
								</td>
								<td width="25%" align="center">
									<br>
									<br>
									.....................................................<br>
									Customer Signature<br>
									Date ........../........../..........
								</td>
								<td width="25%" align="center">
									<br>
									<br>
									.....................................................<br>
									Cashier<br>
									Date ........../........../..........
								</td>
								<td width="25%" align="center">
									<br>
									<br>
									<br>
									.....................................................<br>
									Manager
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</td>
		</tr>
	</tfoot>
</table>
</div>

</body>
</html>