<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.servlet.purchase.ReportPurchase"%>
<%@page import="com.bitmap.bean.purchase.PurchaseOrder"%>
<%@page import="com.bitmap.bean.parts.Vendor"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
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

String status = WebUtils.getReqString(request, "report_type");
String export = WebUtils.getReqString(request, "export");
String rd_time = WebUtils.getReqString(request, "rd_time");

String month = WebUtils.getReqString(request, "month");
String year = WebUtils.getReqString(request, "year");
String year_month = WebUtils.getReqString(request, "year_month");
String po = WebUtils.getReqString(request, "po");
String create_date = WebUtils.getReqString(request, "create_date");

String date_send2 = WebUtils.getReqString(request,"date_send2");
String date_send3 = WebUtils.getReqString(request, "date_send3");

String status2 = status;
if(status2.equalsIgnoreCase("11")){
	status2 = "รอสร้าง PO";
}else{
	status2 = PurchaseRequest.status(status2);
}

List paramsList = new ArrayList();

paramsList.add(new String[]{"status",status});
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


 if(po.length() > 0){
	paramsList.add(new String[]{"po",po}); 
 }	

if(rd_time.equalsIgnoreCase("0")){
		HeaderDate ="";
}else
if(rd_time.equals("1")){
	HeaderDate ="วันที่  "+create_date ;
	paramsList.add(new String[]{"create_date",create_date});
}else
if(rd_time.equals("2")){
	HeaderDate = "ประจำเดือน "+month_name[WebUtils.getInteger(month)]+" ปี "+year;
	paramsList.add(new String[]{"year_month",year_month});
}else
if(rd_time.equals("3")){
	HeaderDate = "ระหว่างวันที่ "+date_send2+" ถึงวันที่ "+date_send3;
	paramsList.add(new String[]{"date_send2",date_send2,date_send3});
} 

session.setAttribute("report_search", paramsList);

if (export.equalsIgnoreCase("true")) {
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=" + status + "_" + WebUtils.getDateValue(WebUtils.getCurrentDate()) + ".xls");
	
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
	if(status.equalsIgnoreCase("11") || status.equalsIgnoreCase("00")) {
	%>
	<center>
	<div class="content_head"  >
			<Strong>รายงานรายการสั่งซื้อ  : สถานะ </Strong> <%=status2 %>
			<br/>
			<Strong>
				<%=HeaderDate %> 
			</Strong>
	</div>
	<table  class="tb" style="width: 100%;">
		<tbody>
			<tr align="center">
					<th valign="top" align="center" width="10%">Create Date</th>
					<th valign="top" align="center" width="18%">P/O.NO.</th>
					<th valign="top" align="center" width="18%">Description</th>
					<th valign="top" align="center" width="18%">Vender</th>
					<th valign="top" align="center" width="5%">Units</th>
					<th valign="top" align="center" width="5%">Qty</th>
					<th valign="top" align="center" width="10%">Price(฿)</th>
					
					
					<!-- <th valign="top" align="center" width="10%">Status</th> -->
					
			</tr>
			<%
				boolean has = true;
			  Iterator ite = PurchaseRequest.listreport(paramsList).iterator();
			while(ite.hasNext()) {
				ReportPurchase entity = (ReportPurchase) ite.next();
				has = false;
				
				String net_price = "0";
				String total_price = "0";
				String disc = "0";
				
				System.out.println(">>>> "+entity.getRp_desUnit());
			%>
				<tr>
					<td valign="top" align="center" style='mso-number-format:"Short Date"'><%=WebUtils.getDateValue(entity.getRp_date())%></td>
					<td valign="top" align="center" style='mso-number-format:"\@"'><%=entity.getRp_po() %></td>
					<td valign="top" align="left" style='mso-number-format:"\@"'><%=entity.getRp_description()%></td>
					<td valign="top" align="left" style='mso-number-format:"\@"'><%=entity.getRp_vender() %></td>
					<td valign="top" align="left" style='mso-number-format:"\@"'><%=UnitType.selectName(entity.getRp_desUnit())%></td>
					<td valign="top" align="right" style='mso-number-format:"0"'><%=Money.moneyInteger(entity.getRp_order_qty()) %></td>
					<td valign="top" align="right" style='mso-number-format:"\#\,\#\#0\.00"' ><%=(entity.getRp_price().length()>0 && !(entity.getRp_price().equalsIgnoreCase("0")|| entity.getRp_price().equalsIgnoreCase("0.00")))?Money.money(entity.getRp_price())+"":"0.00"%></td>
					
					
					
					
					<!-- <td valign="top" align="center" width="10%"><%//=PurchaseRequest.status(entity.getStatus()) %></td> -->
			</tr>
			<%
				}if(has){
			%>
			<tr><td colspan="8" align="center">---- ไม่พบรายการข้อมูล ---- </td></tr>
			<%
			}
			
			%>
		</tbody>
	</table>
	</center>
	<%
	}else {
	%>		
				<center>
				<div class="content_head"  >
						<Strong>รายงานรายการสั่งซื้อ  : สถานะ </Strong> <%=PurchaseRequest.status(status) %>
						<br/>
						<Strong>
							<%=HeaderDate %> 
						</Strong>
				</div>
				<table  class="tb" style="width: 100%;">
					<tbody>
						<tr align="center">
								<th valign="top" align="center" width="10%">Create Date</th>
								<th valign="top" align="center" width="18%">P/O.NO.</th>
								<th valign="top" align="center" width="18%">Description</th>
								<th valign="top" align="center" width="18%">Vender</th>
								<th valign="top" align="center" width="5%">Units</th>
								<th valign="top" align="center" width="5%">Qty</th>
								<th valign="top" align="center" width="10%">Price(฿)</th>
								
								
								<!-- <th valign="top" align="center" width="10%">Status</th> --> 
								
						</tr>
						<%
							 boolean has = true;
						   Iterator ite = PurchaseOrder.listreport(paramsList).iterator();
							while(ite.hasNext()) {
								ReportPurchase entity = (ReportPurchase) ite.next();
								has = false;							
							String net_price = "0";
							String total_price = "0";
							String disc = "0"; 
							System.out.println(">>>> "+entity.getRp_desUnit());
						%>
						
						
							<tr>
								<td valign="top" align="center" style='mso-number-format:"Short Date"'><%=WebUtils.getDateValue(entity.getRp_date())%></td>
								<td valign="top" align="center" style='mso-number-format:"\@"'><%=entity.getRp_po() %></td>
								<td valign="top" align="left" style='mso-number-format:"\@"'><%=entity.getRp_description() %></td>
								<td valign="top" align="left" style='mso-number-format:"\@"'><%=entity.getRp_vender() %></td>
								<td valign="top" align="left" style='mso-number-format:"\@"'><%=UnitType.selectName(entity.getRp_desUnit())%></td>
								<td valign="top" align="right" style='mso-number-format:"0"' ><%=Money.moneyInteger(entity.getRp_order_qty()) %></td> 
								<td valign="top" align="right" style='mso-number-format:"\#\,\#\#0\.00"' ><%=(entity.getRp_price().length()>0 && !(entity.getRp_price().equalsIgnoreCase("0")|| entity.getRp_price().equalsIgnoreCase("0.00")))?Money.money(entity.getRp_price())+"":"0.00"%></td>
								
								
								<!-- <td valign="top" align="center" width="10%"><%//=PurchaseRequest.status(entity.getStatus()) %></td> -->
						</tr>
						<%
						}if(has){
						%>
						<tr><td colspan="8" align="center">---- ไม่พบรายการข้อมูล ---- </td></tr>
						<%
						}
						
						%>
					</tbody>
				</table>
				</center>		
				
			<%
			}
			%>
	
</body>
</html>