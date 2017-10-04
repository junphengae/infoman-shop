<%@page import="com.bitmap.report.ReportSaleOrderBean"%>
<%@page import="com.bitmap.report.ReportSaleOrderTS"%>
<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.branch.Branch"%>
<%@page import="java.util.Map"%>
<%@page import="com.bitmap.bean.sale.Models"%>
<%@page import="com.bitmap.bean.sale.Brands"%>
<%@page import="com.bitmap.bean.branch.BranchMaster"%>
<%@page import="com.bitmap.bean.parts.ServiceOutsourceDetail"%>
<%@page import="com.bitmap.webservice.ServiceOutsourceDetailBean"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="com.bitmap.utils.Money"%>
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
<%@page import="com.bitmap.utils.ReportUtils"%>
<%@page import="com.bitmap.security.SecurityUnit"%>
<%@page import="com.bitmap.security.SecuritySystem"%>
<%@page import="java.util.Date"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html> 

<%

String report_type 	= WebUtils.getReqString(request, "report_type");
String export 		= WebUtils.getReqString(request, "export");
String rd_time 		= WebUtils.getReqString(request, "rd_time");
String branch 		= WebUtils.getReqString(request, "branch");

String Mdate = WebUtils.getReqString(request, "month");
String Ydate = WebUtils.getReqString(request, "year");
String year_month = WebUtils.getReqString(request, "year_month");
String id = WebUtils.getReqString(request, "id");
String create_date = WebUtils.getReqString(request, "create_date");

String date_send2 = WebUtils.getReqString(request,"date_send2");
String date_send3 = WebUtils.getReqString(request, "date_send3");

String[] month_name = {
		 "",
		 "มกราคม ",  
		 "กุมภาพันธ์ ",  
		 "มีนาคม " , 
		 "เมษายน  ", 
		 "พฤษภาคม  ",
		 "มิถุนายน  ",
		 "กรกฎาคม   " , 
		 "สิงหาคม  ", 
		 "กันยายน  ",  
		 "ตุลาคม   " , 
		 "พฤศจิกายน  ", 
		 "ธันวาคม   " };
String HeaderDate = "";
List paramsList = new ArrayList();

paramsList.add(new String[]{"id",id});
paramsList.add(new String[]{"branch",branch});
if(rd_time.equals("1")){
	HeaderDate = "วันที่   "+create_date.replaceAll("/", "-");
	paramsList.add(new String[]{"create_date",create_date});
}
if(rd_time.equals("2")){
	HeaderDate = "ประจำเดือน  "+month_name[WebUtils.getInteger(Mdate)]+" ปี "+Ydate;
	paramsList.add(new String[]{"year_month",year_month});
}
if(rd_time.equals("3")){
	HeaderDate = "ระหว่างวันที่  "+date_send2.replaceAll("/", "-")+" ถึงวันที่  "+date_send3.replaceAll("/", "-");
	paramsList.add(new String[]{"date_send2",date_send2,date_send3});
} 

session.setAttribute("report_search", paramsList);


if (export.equalsIgnoreCase("true")) {
	//if(!report_type.equalsIgnoreCase(ReportUtils.PART_STOCK_BRANCH)){
	
	String fileName = report_type + "_" + WebUtils.getDateValue(WebUtils.getCurrentDate()) + ".xls";
	response.setContentType("application/vnd.ms-excel");
	
	response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Content-Type","application/vnd.ms-excel");
    response.addHeader("Content-Disposition", "inline; filename=" +fileName );
    
	//}
	/* else if(report_type.equalsIgnoreCase(ReportUtils.PART_STOCK_BRANCH)){		
		ArrayList dataList = new ArrayList();
		Iterator ite = ReportSaleOrderTS.getReportSaleOrderList(paramsList).iterator();				
		while(ite.hasNext()) {
			ReportSaleOrderBean sale = (ReportSaleOrderBean) ite.next();
			dataList.add(sale);
		}
		
		
		//ReportSaleOrderTS.getReportSaleOrderExcel(dataList , HeaderDate);		

	} */
	
%>
<style type="text/css">
.tb{border-collapse: collapse;}
.tb tr, .tb td, .tb th{border: .5pt solid #000;border-top: .5pt solid #000; border-bottom: .5pt solid #000;}

</style>
<%
} else {
%>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/theme_print.css" rel="stylesheet" type="text/css" media="all">

<%}%>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Report Viewer</title>

</head>
<body>
	<% 
	Boolean has = false;
	if(report_type.equalsIgnoreCase(ReportUtils.PART_STOCK)) {
	%>
		<center>
	<div class="content_head"  >
			<Strong>รายงานสรุปการขายรวม</Strong>
			<br/>
			<Strong>
			<%=HeaderDate %> 
			</Strong>
	</div>
	<table  class="tb" style="width: 100%;">
		<tbody>
			<tr align="center">
					<th valign="top" align="center" width="7%">Job No</th>
					<th valign="top" align="center" width="7%">Name</th>
					<th valign="top" align="center" width="7%">Surname</th>
					<th valign="top" align="center" width="7%">Vehicle Plate</th>
					<th valign="top" align="center" width="7%">Vehicle Plate Province</th>
					<th valign="top" align="center" width="7%">Brand</th>
					<th valign="top" align="center" width="7%">Model</th>
					<th valign="top" align="center" width=9%">Total</th>
					<th valign="top" align="center" width="4%">Vat</th>
					<th valign="top" align="center" width="4%">Discount(%)</th>
					<th valign="top" align="center" width="9%">Total Amount</th>
					<th valign="top" align="center" width="6%">Tax</th>
					<!-- <th valign="top" align="center" width="80">Flag Pay</th> -->
					<th valign="top" align="center" width="5%">Open Job</th>
					<th valign="top" align="center" width="5%">Close Job</th>
					<th valign="top" align="center" width="10%">Branch</th>
					<th valign="top" align="center" width="5%">Bill ID</th>
					<th valign="top" align="center" width="8%">Tax ID</th>
					
			</tr>
			<%
			
			 Iterator ite = ServiceSale.listreport(paramsList).iterator();
			while(ite.hasNext()) {
				has = true;        
				ServiceSale entity = (ServiceSale) ite.next();
							
				Map uiMap = entity.getUImap();
				Brands brand = (Brands)uiMap.get(Brands.tableName);
				Models model = (Models)uiMap.get(Models.tableName);
				Personal per = (Personal)uiMap.get(Personal.tableName);
				
				String net_price = "0";
				String total_price = "0";
				String disc = "0";
				
			%>
				<tr>
					<td style='mso-number-format:"0"' align="center"><%=entity.getId() %> </td>
					<td style='mso-number-format:"\@"' align="Left"><%=entity.getCus_name()%></td>
					<td style='mso-number-format:"\@"' align="Left"><%=entity.getCus_surname()%></td>
					<td style='mso-number-format:"\@"' align="Left"><%=entity.getV_plate() %> </td>
					<td style='mso-number-format:"\@"' align="Left" ><%=entity.getV_plate_province() %>  </td>
					<td style='mso-number-format:"\@"' align="Left" ><%=brand.getBrand_name().length()>0?brand.getBrand_name():"-"%></td>
					<td style='mso-number-format:"\@"' align="Left" ><%=model.getModel_name().length()>0?model.getModel_name():"-"%></td>
					<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getTotal().length()>0 && !(entity.getTotal().equalsIgnoreCase("0")|| entity.getTotal().equalsIgnoreCase("0.00")))?Money.money(entity.getTotal())+"":"0.00"%></td>
					<td style='mso-number-format:"0"' align="right"><%=entity.getVat() %></td>
					<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getDiscount().length()>0 && !(entity.getDiscount().equalsIgnoreCase("0")|| entity.getDiscount().equalsIgnoreCase("0.00")))?Money.money(entity.getDiscount())+"":"0.00"%></td>
					<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getTotal_amount().length()>0 && !(entity.getTotal_amount().equalsIgnoreCase("0")|| entity.getTotal_amount().equalsIgnoreCase("0.00")))?Money.money(entity.getTotal_amount())+"":"0.00"%></td>
					<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getPay().length()>0 && !(entity.getPay().equalsIgnoreCase("0")|| entity.getPay().equalsIgnoreCase("0.00")))?Money.money(entity.getPay())+"":"0.00"%></td>
					<%-- <td  align="right"><%=entity.getFlag_pay() %> </td> --%>
					<td style='mso-number-format:"Short Date"' align="center"><%=WebUtils.getDateValue(entity.getCreate_date())%></td>
					<td style='mso-number-format:"Short Date"' align="center"><%=WebUtils.getDateValue(entity.getJob_close_date())%></td>
					<td style='mso-number-format:"\@"' align="Left" ><%=BranchMaster.selectbranch_code(entity.getBranch_code()).getBranch_name().trim()%></td>
					<td style='mso-number-format:"\@"' align="Left" ><%=entity.getBill_id()%></td>
					<td style='mso-number-format:"\@"' align="Left" ><%=entity.getTax_id()%></td>
			</tr>
			<%
			}
			if(has == false){
			
			%>
			<tr>
				<td align="center"  colspan="15">-- ไม่พบข้อมูล --</td>
			
			</tr>
			<% } %>
		</tbody>
	</table>
	</center>


	<%
	}
	if(report_type.equalsIgnoreCase(ReportUtils.PART_MOR)) {
	%>
	<center>
	<div class="content_head"  >
			<Strong>รายงานสรุปการขายอะไหล่</Strong>
			<br/>
			<Strong>
			<%=HeaderDate %> 
			</Strong>
	</div>
	<table  class="tb" style=" width: 100%;">
		<tbody>
			<tr align="center">
					<th valign="top" align="center" width="5%">Job No</th>
					<th valign="top"  align="center" width="8%">Code</th>
					<th valign="top" align="center" width="17%">Description</th>
					<th valign="top" align="center" width="4%">Units</th>
					<th valign="top" align="center" width="4%">Qty</th>
					<th valign="top" align="center" width="4%">Cutoff Qty</th>
					<th valign="top" align="center" width="8%">Unit Price</th>
					<th valign="top" align="center" width="8%">Net Price</th>
					<th valign="top" align="center" width="5%">Discount(%)</th>
					<th valign="top" align="center" width="5%">Total discount</th>
					<th valign="top" align="center" width="5%">Total Vat</th>
					<th valign="top" align="center" width="8%">Total Price</th>
					<th valign="top" align="center" width="4%">Create Date</th>
					<th valign="top" align="center" width="8%">Branch</th>
			</tr>
			<%
				boolean check_close = true;
				String total = "0";
				String total_net_price = "0";
				String total_discount = "0";
			
				String part_total_net_price = "0";
				String part_total_discount = "0";
			 	
				Iterator ite = ServicePartDetail.listreport(paramsList).iterator();
			 	
			while(ite.hasNext()) {
				has = true;
				ServicePartDetail entity = (ServicePartDetail) ite.next();
				Map uiMap = entity.getUImap();
				Personal per = (Personal)uiMap.get(Personal.tableName);
				
				String net_price = "0";
				String total_price = "0";
				String disc = "0";
				String total_vat = "0";
				net_price = Money.multiple(entity.getQty(), entity.getPrice());
				total_price = Money.discount(net_price, entity.getDiscount());
				disc = Money.subtract(net_price, total_price);
				
				total_vat = Money.money( String.valueOf(( Double.parseDouble(total_price) *7)/107 ));
				
				total_net_price = Money.add(total_net_price, net_price);
				total_discount = Money.add(total_discount, disc);
				total = Money.add(total, total_price);
				String des_unit = PartMaster.SelectUnitDesc(entity.getPn());
				
			%>
			
			<tr>
				<td style='mso-number-format:"\@"' align="center" ><%=ServiceSale.select(entity.getId()).getId().trim()%></td>
				<td align="Left" style='mso-number-format:"\@"'><%=entity.getPn()%></td>
				<td style='mso-number-format:"\@"' align="Left"><%=entity.getUIDescription() %></td>
				<td style='mso-number-format:"\@"'align="left"><%=UnitType.selectName(des_unit)%></td>
				<td style='mso-number-format:"0"' align="right"><%=Money.moneyInteger(entity.getQty())%></td>
				<td style='mso-number-format:"0"' align="right"><%=Money.moneyInteger(entity.getCutoff_qty())%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getPrice().length()>0 && !(entity.getPrice().equalsIgnoreCase("0")|| entity.getPrice().equalsIgnoreCase("0.00")))?Money.money(entity.getPrice())+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(net_price.length()>0 && !(net_price.equalsIgnoreCase("0")|| net_price.equalsIgnoreCase("0.00")))?Money.money(net_price)+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getDiscount().length()>0 && !(entity.getDiscount().equalsIgnoreCase("0")|| entity.getDiscount().equalsIgnoreCase("0.00")))?Money.money(entity.getDiscount())+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getSpd_dis_total().length()>0 && !(entity.getSpd_dis_total().equalsIgnoreCase("0")|| entity.getSpd_dis_total().equalsIgnoreCase("0.00")))?Money.money(entity.getSpd_dis_total())+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(total_vat.length()>0 && !(total_vat.equalsIgnoreCase("0")|| total_vat.equalsIgnoreCase("0.00")))?Money.money(total_vat)+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(total_price.length()>0 && !(total_price.equalsIgnoreCase("0")|| total_price.equalsIgnoreCase("0.00")))?Money.money(total_price)+"":"0.00"%></td>
				<td style='mso-number-format:"Short Date"' align="center" ><%=WebUtils.getDateValue(entity.getCreate_date()) %></td>
				<td style='mso-number-format:"\@"' align="Left" ><%=BranchMaster.selectbranch_code(entity.getBranch_code()).getBranch_name().trim()%></td>
			</tr>
			<%
			}
			if(has == false){
			
			%>
			<tr>
				<td align="center"  colspan="14">-- ไม่พบข้อมูล --</td>
			
			</tr>
			<% } %>
			
		</tbody>
	</table>
	</center>
	
	<% }if (report_type.equalsIgnoreCase(ReportUtils.PART_OUT)) { %>
	<center>
	<div class="content_head"  >
			<Strong>รายงานสรุปการซ่อมแบบ (Service)</Strong>
			<br/>
			<Strong>
			<%=HeaderDate %> 
			</Strong>
	</div>
	<table  class="tb" style=" width: 100%;" >
		<tbody>
			<tr align="center">
					<th valign="top" align="center" width="7%">Job No</th>
					<th valign="top" align="center" width="8%">Create Date</td>
					<th valign="top" align="center" width="10%">Code</td>
					<th valign="top" align="center" width="20%">Description</th>
					<th valign="top" align="center" width="10%">Unit Price</th>
					<th valign="top" align="center" width="10%">Net Price</th>
					<th valign="top" align="center" width="10%">Discount(%)</th>
					<th valign="top" align="center" width="10%">Total Price</th>
					<th valign="top" align="center" width="15%">Branch </td>
			</tr>
			
			<%
				boolean check_close = true;
				String total = "0";
				String total_net_price = "0";
				String total_discount = "0";
			
				String part_total_net_price = "0";
				String part_total_discount = "0";
			
			 	Iterator ite = ServiceRepairDetail.listreport(paramsList).iterator(); 
				while(ite.hasNext()) {
					has = true;
					ServiceRepairDetail detailRepair = (ServiceRepairDetail) ite.next();
					
					Map map = detailRepair.getUImap();
					Personal per = (Personal)map.get(Personal.tableName);
					
					
					String net_price = "0";
					String total_price = "0";
					String disc = "0";
					net_price = Money.money(detailRepair.getLabor_rate());
					total_price = Money.discount(net_price, detailRepair.getDiscount());
					disc = Money.subtract(net_price, total_price);
					
					total_net_price = Money.add(total_net_price, net_price);
					total_discount = Money.add(total_discount, disc);
					total = Money.add(total, total_price);
			
			%>
			
			<tr>
				<td style='mso-number-format:"\@"' align="center"><%=ServiceSale.select(detailRepair.getId()).getId().trim()%></td>
				<td style='mso-number-format:"Short Date"' align="center" ><%=WebUtils.getDateValue(detailRepair.getCreate_date()) %></td>
				<td style='mso-number-format:"\@"' align="Left" ><%=detailRepair.getLabor_id() %></td>
				<td style='mso-number-format:"\@"' align="Left" ><%=detailRepair.getLabor_name() %></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(detailRepair.getLabor_rate().length()>0 && !(detailRepair.getLabor_rate().equalsIgnoreCase("0")|| detailRepair.getLabor_rate().equalsIgnoreCase("0.00")))?Money.money(detailRepair.getLabor_rate())+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(net_price.length()>0 && !(net_price.equalsIgnoreCase("0")|| net_price.equalsIgnoreCase("0.00")))?Money.money(net_price)+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(detailRepair.getDiscount().length()>0 && !(detailRepair.getDiscount().equalsIgnoreCase("0")|| detailRepair.getDiscount().equalsIgnoreCase("0.00")))?Money.money(detailRepair.getDiscount())+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(total_price.length()>0 && !(total_price.equalsIgnoreCase("0")|| total_price.equalsIgnoreCase("0.00")))?Money.money(total_price)+"":"0.00"%></td>
				<td style='mso-number-format:"\@"' align="Left" ><%=BranchMaster.selectbranch_code(detailRepair.getBranch_code()).getBranch_name().trim()%></td>
			</tr>
			<%
			}if(has == false){
				
			%>
			<tr>
				<td align="center"  colspan="9">-- ไม่พบข้อมูล --</td>
				
			</tr>
			<% } %>
		</tbody>
	</table> 
	</center>
	
 		
	<% }else if (report_type.equalsIgnoreCase(ReportUtils.PART_BOR)) {
	%>
	<center>
	<div class="content_head"  >
			<Strong>รายงานสรุปการซ่อมแบบ (Miscellaneous)</Strong>
			<br/>
			<Strong>
			<%=HeaderDate %> 
			</Strong>
	</div>
	<table  class="tb" style=" width: 100%;">
		<tbody>
			<tr align="center">
					<th valign="top" align="center" width="9%">Job No</th>
					<th valign="top" align="center"  width="8%">Create Date</td>
					<th valign="top" align="center"  width="23%">Description</th>
					<th valign="top" align="center"  width="6%">Qty</th>
					<th valign="top" align="center"  width="10%">Unit Price</th>
					<th valign="top" align="center"  width="10%">Net Price</th>
					<th valign="top" align="center"  width="10%">Discount(%)</th>
					<th valign="top" align="center"  width="10%">Total Price</th>
					<th valign="top" align="center"  width="15%">Branch </td>
			</tr>
			
			<%
			 Iterator ite = ServiceOtherDetail.listreport(paramsList).iterator();  
			String qty = "";
			while(ite.hasNext()) {
				has = true;
				ServiceOtherDetail detailOther = (ServiceOtherDetail) ite.next();
				
				 Map map = detailOther.getUImap();
				Personal per = (Personal)map.get(Personal.tableName);
				 
				String net_price = "0";
				String total_price = "0";
				String disc = "0";
			
				if(detailOther.getOther_qty().equalsIgnoreCase("")){
					qty = "1";
				}else{
					qty = detailOther.getOther_qty() ;
				}
				net_price = Money.multiple(qty, detailOther.getOther_price());
				//net_price = Money.multiple(detailOther.getOther_qty(), detailOther.getOther_price());
				total_price = Money.discount(net_price, detailOther.getDiscount());
				disc = Money.subtract(net_price, total_price);
				
				/*  total_net_price = Money.add(total_net_price, net_price);
				total_discount = Money.add(total_discount, disc);
				total = Money.add(total, total_price);  */
			%>
			
			<tr>
				<td style='mso-number-format:"\@"' align="center"><%=ServiceSale.select(detailOther.getId()).getId().trim()%></td>
				<td style='mso-number-format:"Short Date"' align="center"><%=WebUtils.getDateValue(detailOther.getCreate_date())%></td>
				<td style='mso-number-format:"\@"' align="Left"><%=detailOther.getOther_name() %></td>
				<td style='mso-number-format:"0"' align="right"><%=Money.moneyInteger(detailOther.getOther_qty())%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(detailOther.getOther_price().length()>0 && !(detailOther.getOther_price().equalsIgnoreCase("0")||detailOther.getOther_price().equalsIgnoreCase("0.00")))?Money.money(detailOther.getOther_price())+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(net_price.length()>0 && !(net_price.equalsIgnoreCase("0")|| net_price.equalsIgnoreCase("0.00")))?Money.money(net_price)+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(detailOther.getDiscount().length()>0 && !(detailOther.getDiscount().equalsIgnoreCase("0")|| detailOther.getDiscount().equalsIgnoreCase("0.00")))?Money.money(detailOther.getDiscount())+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(total_price.length()>0 && !(total_price.equalsIgnoreCase("0")|| total_price.equalsIgnoreCase("0.00")))?Money.money(total_price)+"":"0.00"%></td>
				<td style='mso-number-format:"\@"' align="Left" ><%=BranchMaster.selectbranch_code(detailOther.getBranch_code()).getBranch_name().trim()%></td>
			</tr>
			<%
			}if(has == false){ 
				
			%>
			<tr>
				<td align="center"  colspan="9">-- ไม่พบข้อมูล --</td>
				
			</tr>
			<% } %>
		</tbody>
	</table>
	</center>
	
	<%}else if(report_type.equalsIgnoreCase(ReportUtils.PART_STOCK_BRANCH)){%>
	
	<center>
	<div class="content_head"  >
			<Strong>รายงานสรุปการขายรวม  All</Strong>
			<br/>
			<Strong>
			<%=HeaderDate %> 
			</Strong>
	</div>
	 <table  class="tb" style=" width: 100%;">
		<thead>
		   <tr align="center">
			<th valign="top" align="center"  >รหัสสาขา</th>
			<th valign="top" align="center"  >ชื่อสาขา</th>
			<th valign="top" align="center"  >วันที่ปิด Job</th>
			<th valign="top" align="center"  >เลขที่ Job</th>
			<th valign="top" align="center"  >เลขที่ ใบเสร็จ</th>
			<th valign="top" align="center"  >ชื่อลูกค้า</th>
			<th valign="top" align="center"  >นามสกุล</th>
			<th valign="top" align="center"  >Brand</th>
			<th valign="top" align="center"  >Model</th>			
			<th valign="top" align="center"  >Plate </th>
			<th valign="top" align="center"  >Plate Province </th>
			<th valign="top" align="center"  >Service Type </th>
			<th valign="top" align="center"  >รหัสสินค้า </th>
			<th valign="top" align="center"  >รายละเอียด </th>
			<th valign="top" align="center"  >หน่วย </th>
			<th valign="top" align="center"  >กลุ่ม </th>
			<th valign="top" align="center"  >ชนิด </th>
			<th valign="top" align="center"  >ชนิดย่อย </th>
			<th valign="top" align="center"  >Cost</th>
			<th valign="top" align="center"  >ราคา/หน่วย</th>
			<th valign="top" align="center"  >จำนวน </th>
			<th valign="top" align="center"  >ส่วนลด </th>
			<th valign="top" align="center"  >รวม </th>
			<th valign="top" align="center"  >ภาษี </th>							
			</tr>			
		</thead>
		<tbody>
		<%					 	
				Iterator ite = ReportSaleOrderTS.getReportSaleOrderList(paramsList).iterator();				
				while(ite.hasNext()) {
					has = true;
					ReportSaleOrderBean sale = (ReportSaleOrderBean) ite.next();
		
		%>
		  <tr>
		  	<td style='mso-number-format:"\@"' align="center"><%= sale.getBranch_code() %></td>
		  	<td style='mso-number-format:"\@"' align="Left"><%= sale.getBranch_name() %></td>
		  	<td style='mso-number-format:"Short Date"' align="center"><%= WebUtils.getDateValue(sale.getJob_close_date())%></td>
		  	<td style='mso-number-format:"0"' align="center"><%= sale.getJob_id()%></td>
		  	<td style='mso-number-format:"\@"' align="Left"><%= sale.getBill_id()%></td>
		  	<td style='mso-number-format:"\@"' align="Left"><%= sale.getForewordname()+" "+sale.getCus_name() %></td>
		  	<td style='mso-number-format:"\@"' align="Left"><%= sale.getCus_surname() %></td>
		  	<td style='mso-number-format:"\@"' align="Left"><%= sale.getBrand_id() %></td>
		  	<td style='mso-number-format:"\@"' align="Left"><%= sale.getModel_id() %></td>
		  	<td style='mso-number-format:"\@"' align="Left"><%= sale.getV_plate() %></td>
		  	<td style='mso-number-format:"\@"' align="Left"><%= sale.getV_plate_province() %></td>
		  	<td style='mso-number-format:"\@"' align="Left"><%= sale.getService_type()%></td>
		  	<td style='mso-number-format:"\@"' align="Left"><%= sale.getPart_number()%></td>
		  	<td style='mso-number-format:"\@"' align="Left"><%= sale.getDescription() %></td>
		  	<td style='mso-number-format:"\@"' align="Left"><%= sale.getUnit_type() %></td>
		  	<td style='mso-number-format:"\@"' align="Left"><%= sale.getGroup_name()%></td>
		  	<td style='mso-number-format:"\@"' align="Left"><%= sale.getCategories_name() %></td>
		  	<td style='mso-number-format:"\@"' align="Left"><%= sale.getSub_categories_name() %></td>
		  	<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%= sale.getCost() %></td>
		  	<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%= sale.getUnit_price() %></td>
		  	<td style='mso-number-format:"0"' align="right"><%= sale.getQuantity() %></td>
		  	<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%= sale.getDiscount() %></td>
		  	<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%= sale.getTotal() %></td>
		  	<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%= sale.getVat() %></td>
		  </tr>
		<% }
			if(has == false){
		 %>	
		<tr>
			<td align="center"  colspan="24">-- ไม่พบข้อมูล --</td>
		</tr>				
	   <%} %>	
		</tbody>
	</table>
	</center>	
  <%} %>
  
  		
</body>
</html>