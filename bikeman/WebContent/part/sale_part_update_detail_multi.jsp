<%@page import="com.bmp.special.fn.BMMoney"%>
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
<div>
				
				<fieldset>
					<legend><Strong>แก้ไขจำนวนสินค้า</Strong></legend>
					
					<div class="clear"></div>
					
					<table class="bg-image s_auto breakword columntop">
						
						<thead>
							<tr>
								<th valign="top" align="left" width="2%"></th>
								<th valign="top" align="center" width="14%">Code</th>
								<th valign="top" align="center" width="30%">Description</th>
								<th valign="top" align="center" width="5%">Draw Qty</th>
								<th valign="top" align="center" width="5%">Issued Qty</th>
								<th valign="top" align="center" width="12%">Unit Price</th>
								<th valign="top" align="center" width="11%">Price</th>
								<th valign="top" align="center" width="5%">Dis(%)</th>
								<th valign="top" align="center" width="12%">Net Price</th>
							</tr>
							
						</thead>
						
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
									
						%>
							<tr>
								<td align="center">
									<a title="Update Parts Detail PN: <%=detailPart.getPn()%>" class="btn_update thickbox" lang="../part/sale_part_update_detail.jsp?id=<%=detailPart.getId()%>&number=<%=detailPart.getNumber()%>&width=420&height=230"></a>
								</td>
								<td><%=detailPart.getPn() %></td>
								<td><%=detailPart.getUIDescription() %></td>
								<td align="right"><%=Money.moneyInteger(detailPart.getQty())%></td>
								<td align="right"><%=detailPart.getCutoff_qty()%></td>
								<td align="right"><%=Money.money(detailPart.getPrice()) %></td>
								<td align="right"><%=Money.money(detailPart.getTotal_price()) %></td>
								<td align="right"><%=Money.money(detailPart.getDiscount())%></td>
								<td align="right"><%=Money.money(detailPart.getSpd_net_price()) %></td>
								
							</tr>
						<%


								
								if ( !detailPart.getCutoff_qty().equalsIgnoreCase(detailPart.getQty()) ){//check เผื่อปิดจ๊อบ
									check_close = false;
								}
							 }
							//}
						%>
						</tbody>
					</table>
					</fieldset>
</div>					
</body>
</html>