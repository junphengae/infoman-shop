<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.parts.PartLot"%>
<%@page import="com.bitmap.bean.purchase.PurchaseOrder"%>
<%@page import="com.bitmap.bean.parts.Vendor"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="java.util.Map"%>
<%@page import="com.bitmap.bean.sale.Models"%>
<%@page import="com.bitmap.bean.sale.Brands"%>
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

String status  = WebUtils.getReqString(request, "report_type");
String export  = WebUtils.getReqString(request, "export");
String rd_time = WebUtils.getReqString(request, "rd_time");
String type    = WebUtils.getReqString(request, "report_type_summary");

String month = WebUtils.getReqString(request, "month");
String year = WebUtils.getReqString(request, "year");
String year_month = WebUtils.getReqString(request, "year_month");



String po = WebUtils.getReqString(request, "po");
String create_date = WebUtils.getReqString(request, "create_date");

String date_send2 = WebUtils.getReqString(request,"date_send2");
String date_send3 = WebUtils.getReqString(request, "date_send3");

List paramsList = new ArrayList();

if(!status.equalsIgnoreCase("1")){
	paramsList.add(new String[]{"status",status});
}

 if(po.length() > 0){
	paramsList.add(new String[]{"po",po}); 
 }
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
if(rd_time.equalsIgnoreCase("0")){
		HeaderDate ="";
}else 
if(rd_time.equals("1")){
	HeaderDate ="วันที่  "+create_date ;
	paramsList.add(new String[]{"create_date",create_date});
}
if(rd_time.equals("2")){
	HeaderDate = "ประจำเดือน "+month_name[WebUtils.getInteger(month)]+" ปี "+year;
	paramsList.add(new String[]{"year_month",year_month});
}
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
	<%if(type.equalsIgnoreCase("SUM_PR")){ 
		String name[]   	= {"สินค้าที่กำลังเปิด PO","สินค้ารออนุมัติ","สินค้าอนุมัติแล้ว","สินค้าปิด PO แล้ว"};
		String status_pr[]  = {"41","10","20","42"};
	%>
	<center>
	<div class="content_head"  >
			<Strong>รายงานสรุปการออก PR </Strong>
	</div>
	<table  class="tb" style="width: 100%;">
		<tbody>
			<tr align="center">
				<th valign="top" align="center" width="50%">รายการ</th>
				<th valign="top" align="center" width="50%" >จำนวน</th>
			</tr>
			<%for(int i=0;i<=3;i++) {%>
			<tr>
				<td style='mso-number-format:"\@"'><%=name[i]%></td>
				<td align="center" style='mso-number-format:"\@"'><%=PurchaseRequest.CountByStatus(status_pr[i]) %> รายการ</td>
			</tr>
			<%} %>
		</tbody>
	</table>
	</center>
	<%}else if(type.equalsIgnoreCase("SUM_PO")){ 
		String name[]   	= {"กำลังสร้าง","เปิด","รอการแก้ไข","รออนุมัติ","ไม่อนุมัติ","อนุมัติแล้ว","ยกเลิก PO","ปิด PO"};
		String status_pr[]  = {"40","41","33","10","35","30","45","42"};
	    %>
		<center>
		<div class="content_head"  >
				<Strong>รายงานสรุปการออก PO </Strong>
		</div>
		<table  class="tb" style="width: 100%;">
			<tbody>
				<tr align="center">
					<th valign="top" align="center" width="50%">รายการ</th>
					<%-- <%if(export.equalsIgnoreCase("true")){ 
					System.out.println("if-1");%>
					<th valign="top" align="center" width="50%" colspan="2">จำนวน</th>
					<%}else{ %> --%>
					<th valign="top" align="center" width="50%" >จำนวน</th>
					<%-- <%} %> --%>
				</tr>
				<%for(int i=0;i<=7;i++) {%>
			<tr>
				<td style='mso-number-format:"\@"'><%=name[i]%></td>
				<%-- <%if(export.equalsIgnoreCase("true")){ 
				System.out.println("if-2");%>
					<td align="center"><%=PurchaseOrder.CountByStatus(status_pr[i]) %> </td>
					<td align="center">รายการ</td>
				<%}else{ %> --%>
					<td align="center" style='mso-number-format:"\@"'><%=PurchaseOrder.CountByStatus(status_pr[i]) %> รายการ</td>
				<%-- <%} %> --%>
			</tr>
			<%} %>
			</tbody>
		</table>
		</center>
	<%}else if(type.equalsIgnoreCase("SUM_PO_STATUS")){ %>
	
				<center>
				<div class="content_head"  >
						<Strong>รายงานใบสั่งซื้อ [PO]: สถานะ </Strong> <%=PurchaseRequest.status(status) %>
						<br/>
						<Strong>
						
							<%=HeaderDate %> 
						</Strong>
				</div>
				<table  class="tb" style="width: 100%;">
					<tbody>
						<tr align="center">	
								<th valign="top" align="center" width="10%">PO</th>	
								<th valign="top" align="center" width="10%">วันที่ออก</th>
								<th valign="top" align="center" width="10%">กำหนดส่ง</th>	
								<th valign="top" align="center" width="10%">วันที่ปิด</th>
								<th valign="top" align="center" width="10%">ยอดเงิน(฿)</th>
								<!-- <th valign="top" align="center" width="10%">ตัวแทนจำหน่าย </th> -->
								<th valign="top" align="center" width="10%">สถานะ</th>
						</tr>
						<%
						boolean has = true;
						  Iterator ite = PurchaseOrder.listreport(paramsList).iterator();
						  String total = "0";
						while(ite.hasNext()) {
							PurchaseOrder entity = (PurchaseOrder) ite.next();
							has = false;
							
							total = Money.add(total, "1");
							
						%>
							<tr>
								<td valign="top" align="center" width="5%" style='mso-number-format:"\@"'><%=entity.getPo() %></td>
								<td valign="top" align="center" width="5%" style='mso-number-format:"Short Date"'><%=WebUtils.getDateValue(entity.getCreate_date())%></td>
								<td valign="top" align="center" width="5%" style='mso-number-format:"Short Date"'><%=WebUtils.getDateValue(entity.getDelivery_date())%></td>
								<td valign="top" align="center" width="5%" style='mso-number-format:"Short Date"'><%=WebUtils.getDateValue(entity.getReceive_date())%></td>
								<td valign="top" align="right" width="10%" style='mso-number-format:"\#\,\#\#0\.00"'><%=Money.money(entity.getGrand_total()) %></td>
								<%-- <td valign="top" align="right" width="10%"><%=vender.getVendor_name() %></td> --%>
								<td valign="top" align="center" width="10%" style='mso-number-format:"\@"'><%=PurchaseRequest.status(entity.getStatus())  %></td>
								
						</tr>
						<%
							}if(has){
						%>
						<tr><td colspan="6" align="center">---- ไม่พบรายการข้อมูล ---- </td></tr>
						<%
						}
						
						%>
					</tbody>
				</table>
				<table  align="right"  class="txt_18">
				<tr>
					<td colspan="6" align="right" >					
					<strong>รายงานใบสั่งซื้อ [PO] สถานะ  <%=PurchaseRequest.status(status) %></strong> : <%=Money.moneyInteger(total)%> รายการ
					</td>
				</tr>
				</table>
				</center>
				
	<%}else if(type.equalsIgnoreCase("SUM_PR_STATUS")){ %>
		<center>
				<div class="content_head"  >
						<Strong>รายงานการขอจัดซื้อ [PR]  : สถานะ </Strong> <%=PurchaseRequest.status(status) %>
						<br/>
						<Strong>
							<%=HeaderDate %> 
						</Strong>
				</div>
				<table  class="tb" style="width: 100%;">
					<tbody>
						<tr align="center">
								
								<th valign="top" align="center" width="10%">PO</th>
								<th valign="top" align="center" width="10%">PN</th>
								<th valign="top" align="center" width="25%">Description</th>
								<th valign="top" align="center" width="5%">Units</th>	
								<th valign="top" align="center" width="5%">จำนวนที่สั่ง</th>	
								<th valign="top" align="center" width="5%">รับเข้าแล้ว</th>
								<th valign="top" align="center" width="10%">ราคาที่สั่ง(฿)</th>	
								<th valign="top" align="center" width="10%">Create Date</th>
								<th valign="top" align="center" width="10%">สถานะ</th>
								
						</tr>
						<%
						boolean has = true;
						  Iterator ite = PurchaseRequest.listreport(paramsList).iterator();
						  String total = "0";
						while(ite.hasNext()) {
							PurchaseRequest entity = (PurchaseRequest) ite.next();
							has = false;
							
							 Map uiMap = entity.getUImap();
							 PartMaster part = (PartMaster)uiMap.get(PartMaster.tableName);
							 Vendor vender   =(Vendor)uiMap.get(Vendor.tableName);

							total = Money.add(total, "1");
							String des_unit = PartMaster.SelectUnitDesc(part.getPn());//Units
							
							
						%>
							<tr>
								
								<td valign="top" align="center" style='mso-number-format:"\@"'><%=entity.getPo() %></td>
								<td valign="top" align="left" style='mso-number-format:"\@"'><%=part.getPn() %></td>
								<td valign="top" align="left" style='mso-number-format:"\@"'><%=part.getDescription() %></td>
								<td valign="top" align="left" style='mso-number-format:"\@"'><%=UnitType.selectName(des_unit)%></td>
								<td valign="top" align="right" style='mso-number-format:"0"'><%=Money.moneyInteger(entity.getOrder_qty()) %></td> 
								<td valign="top" align="right" style='mso-number-format:"0"'><%=Money.moneyInteger( PartLot.SUMPORecive( entity.getPo(), part.getPn() ) )%></td> 
								<td valign="top" align="right" style='mso-number-format:"\#\,\#\#0\.00"' ><%=Money.money(entity.getOrder_price()) %></td>
								<td valign="top" align="center" style='mso-number-format:"Short Date"'><%=WebUtils.getDateValue(entity.getCreate_date())%></td>
								<td valign="top" align="center" style='mso-number-format:"\@"'><%=PurchaseRequest.status(entity.getStatus()) %></td>
						</tr>
						<%
							}if(has){
						%>
						<tr><td colspan="9" align="center">---- ไม่พบรายการข้อมูล ---- </td></tr>
						<%
						}
						
						%>
					</tbody>
				</table>
				<table  align="right"  class="txt_18">
				<tr>
					<td colspan="9" align="right" >					
					<strong>รายงานการขอจัดซื้อ [PR] สถานะ  <%=PurchaseRequest.status(status) %></strong> : <%=Money.moneyInteger(total)%> รายการ
					</td>
				</tr>
				</table>
				</center>
	
	<%}else if(type.equalsIgnoreCase("PR_LIST")){ %>
			<center>
			<div class="content_head"  >
					<Strong>รายการสินค้าขอจัดซื้อ </Strong>
			</div>
			<table  class="tb" style="width: 100%;">
				<tbody>
					<tr align="center">
						<th valign="top" align="center" width="20%">PN</th>
						<th valign="top" align="center" width="40%" >Description</th>
						<th valign="top" align="center" width="10%" >กำลังออก PO</th>
						<th valign="top" align="center" width="10%" >รอส่ง</th>
						<th valign="top" align="center" width="10%" >ปิด PO</th>
						<th valign="top" align="center" width="10%" >ยกเลิก PO</th>
					</tr>
					<%
					Iterator ites = PurchaseRequest.listreport2().iterator();
					 String total = "0";
					while(ites.hasNext()) {
						PurchaseRequest entity = (PurchaseRequest) ites.next();
						total = Money.add(total, "1");
					%>
				<tr>
					<td style='mso-number-format:"\@"'><%=entity.getMat_code()%></td>
				    <td style='mso-number-format:"\@"'><%=entity.getUIcnt()%></td>
					<td style='mso-number-format:"0"' align="center"><%=PurchaseRequest.CountByStatus("30",entity.getMat_code()) %></td>
					<td style='mso-number-format:"0"' align="center"><%=PurchaseRequest.CountByStatus("41",entity.getMat_code()) %></td>
					<td style='mso-number-format:"0"' align="center"><%=PurchaseRequest.CountByStatus("42",entity.getMat_code()) %></td>
					<td style='mso-number-format:"0"' align="center"><%=PurchaseRequest.CountByStatus("45",entity.getMat_code()) %></td>
				</tr>
				<%} %>
				</tbody>
			</table>
			<table  align="right"  class="txt_18">
				<tr>
					<td colspan="9" align="right" >					
					<strong>รายการสินค้าขอจัดซื้อ </strong> : <%=Money.moneyInteger(total)%> รายการ
					</td>
				</tr>
				</table>
			</center>
	<%} %>
	
</body>
</html>