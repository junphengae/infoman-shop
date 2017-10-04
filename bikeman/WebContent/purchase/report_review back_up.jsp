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

String year_month = WebUtils.getReqString(request, "year_month");
String po = WebUtils.getReqString(request, "po");
String create_date = WebUtils.getReqString(request, "create_date");

String date_send2 = WebUtils.getReqString(request,"date_send2");
String date_send3 = WebUtils.getReqString(request, "date_send3");

List paramsList = new ArrayList();

paramsList.add(new String[]{"status",status});

 if(po.length() > 0){
	paramsList.add(new String[]{"po",po}); 
 }	
 if(rd_time.equals("1")){
	paramsList.add(new String[]{"create_date",create_date});
}
if(rd_time.equals("2")){
	paramsList.add(new String[]{"year_month",year_month});
}
if(rd_time.equals("3")){
	
	paramsList.add(new String[]{"date_send2",date_send2,date_send3});
} 

session.setAttribute("report_search", paramsList);
System.out.println("export = "+export);
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
				<td><%=name[i]%></td>
				<td align="center"><%=PurchaseRequest.CountByStatus(status_pr[i]) %> รายการ</td>
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
					<th valign="top" align="center" width="50%" >จำนวน</th>
				</tr>
				<%for(int i=0;i<=7;i++) {%>
			<tr>
				<td><%=name[i]%></td>
				<td align="center"><%=PurchaseOrder.CountByStatus(status_pr[i]) %> รายการ</td>
			</tr>
			<%} %>
			</tbody>
		</table>
		</center>
	<%}else if(type.equalsIgnoreCase("SUM_PO_STATUS")){ %>
			<% 
				if(status.equalsIgnoreCase("10")) {
				%>
				<center>
				<div class="content_head"  >
						<Strong>รายงานรายการสั่งซื้อ  : สถานะ </Strong> <%=PurchaseRequest.status(status) %>
				</div>
				<table  class="tb" style="width: 100%;">
					<tbody>
						<tr align="center">
								<th valign="top" align="center" width="10%">Create Date</th>
								<!-- <th valign="top" align="center" width="10%">P/O.NO.</th> -->
								<th valign="top" align="center" width="18%">Description</th>
					<!-- 			<th valign="top" align="center" width="18%">Vender</th> -->
								<th valign="top" align="center" width="10%">Price</th>
								<th valign="top" align="center" width="10%">Qty</th>
								<!-- <th valign="top" align="center" width="10%">Status</th> -->
								
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
							
							String net_price   = "0";
							String total_price = "0";
							String disc        = "0";
							
							total = Money.add(total, "1");
							
						%>
							<tr>
								<td valign="top" align="left" width="5%"><%=WebUtils.getDateValue(entity.getCreate_date())%></td>
								<td valign="top" align="left" width="5%"><%=entity.getPo() %></td>
								<td valign="top" align="left" width="10%"><%=part.getDescription() %></td>
								<td valign="top" align="left" width="10%"><%=vender.getVendor_name() %></td>
								<td valign="top" align="right" width="10%"><%=Money.money(entity.getOrder_price()) %></td>
								<td valign="top" align="right" width="10%"><%=entity.getOrder_qty() %></td> 
								<%-- <td valign="top" align="center" width="10%"><%//=PurchaseRequest.status(entity.getStatus()) %></td> --%>
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
				<table  align="center"  class="txt_18">
				<tr>
					<td colspan="6" align="center" >					
					<strong>รายงานรายการสั่งซื้อสถานะ  <%=PurchaseRequest.status(status) %></strong> : <%=Money.moneyInteger(total)%> รายการ
					</td>
				</tr>
				</table>
				</center>
				<%
				}else if(status.equalsIgnoreCase("40") || status.equalsIgnoreCase("42") || status.equalsIgnoreCase("45")){
				%>		
							<center>
							<div class="content_head"  >
									<Strong>รายงานรายการสั่งซื้อ  : สถานะ </Strong> <%=PurchaseRequest.status(status) %>
							</div>
							<table  class="tb" style="width: 100%;">
								<tbody>
									<tr align="center">
											<th valign="top" align="center" width="10%">Create Date</th>
											<th valign="top" align="center" width="10%">P/O.NO.</th>
											<th valign="top" align="center" width="18%">Description</th>
											<!-- <th valign="top" align="center" width="18%">Vender</th> -->
											<th valign="top" align="center" width="10%">Price</th>
											<th valign="top" align="center" width="10%">Qty</th>
											<!-- <th valign="top" align="center" width="10%">Status</th> -->
											
									</tr>
									<%
										 boolean has = true;
									   Iterator ite = PurchaseOrder.listreport(paramsList).iterator();
									   String total = "0"; 
										while(ite.hasNext()) {
										PurchaseOrder entity = (PurchaseOrder) ite.next();
										has = false;
										
										  Map uiMap = entity.getUImap();
										PurchaseRequest pr = (PurchaseRequest)uiMap.get(PurchaseRequest.tableName);
										PartMaster pn = PartMaster.select(pr.getMat_code());
										Vendor vender = Vendor.select(entity.getVendor_id());
										
										String net_price = "0";
										String total_price = "0";
										String disc = "0"; 
										
										total = Money.add(total, "1");
										
										
									%>
									
									
										<tr>
											 <td valign="top" align="left" width="5%"><%=WebUtils.getDateValue(pr.getCreate_date())%></td>
											<td valign="top" align="left" width="5%"><%=entity.getPo() %></td>
											<td valign="top" align="left" width="10%"><%=pn.getDescription() %></td>
											<td valign="top" align="right" width="10%"><%=Money.money(pr.getOrder_price()) %></td>
											<td valign="top" align="right" width="10%"><%=pr.getOrder_qty() %></td> 
											<!-- <td valign="top" align="center" width="10%"><%//=PurchaseRequest.status(entity.getStatus()) %></td> -->
									</tr>
									<%
									}if(has){
									%>
									<tr><td colspan="5" align="center">---- ไม่พบรายการข้อมูล ---- </td></tr>
									<%
									}
									
									%>
								</tbody>
							</table>
							<table  align="center"  class="txt_18">
							<tr>
								<td colspan="5" align="center" >					
								<strong>รายงานรายการสั่งซื้อสถานะ  <%=PurchaseRequest.status(status) %></strong> : <%=Money.moneyInteger(total)%> รายการ
								</td>
							</tr>
							</table>
							
							</center>		
							
						<%
						}else{
						%>
								<center>
								<div class="content_head"  >
										<Strong>รายงานรายการสั่งซื้อ  : สถานะ </Strong> <%=PurchaseRequest.status(status) %>
								</div>
								<table  class="tb" style="width: 100%;">
									<tbody>
										<tr align="center">
												<th valign="top" align="center" width="10%">Create Date</th>
												<th valign="top" align="center" width="10%">P/O.NO.</th> 
												<th valign="top" align="center" width="18%">Description</th>
												<!-- <th valign="top" align="center" width="18%">Vender</th> -->
												<th valign="top" align="center" width="10%">Price</th>
												<th valign="top" align="center" width="10%">Qty</th>
												<!-- <th valign="top" align="center" width="10%">Status</th> -->
												
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
											 Vendor vender =(Vendor)uiMap.get(Vendor.tableName);
											
											String net_price = "0";
											String total_price = "0";
											String disc = "0";
											
											total = Money.add(total, "1");
										%>
										
										
											<tr>
												<td valign="top" align="left" width="5%"><%=WebUtils.getDateValue(entity.getCreate_date())%></td>
												<td valign="top" align="left" width="5%"><%=entity.getPo() %></td> 
												<td valign="top" align="left" width="10%"><%=part.getDescription() %></td>
												<td valign="top" align="left" width="10%"><%=vender.getVendor_name() %></td>
												<td valign="top" align="right" width="10%"><%=Money.money(entity.getOrder_price()) %></td>
												<td valign="top" align="right" width="10%"><%=entity.getOrder_qty() %></td>
												<!-- <td valign="top" align="center" width="10%"><%//=PurchaseRequest.status(entity.getStatus()) %></td> -->
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
								<table  align="center"  class="txt_18">
								<tr>
									<td colspan="6" align="center" >					
									<strong>รายงานรายการสั่งซื้อสถานะ  <%=PurchaseRequest.status(status) %></strong> : <%=Money.moneyInteger(total)%> รายการ
									</td>
								</tr>
								</table>
								</center>
							
							
						<%
						}	
						%> 
	<%}else if(type.equalsIgnoreCase("SUM_PR_STATUS")){ %>
	ตรงนี้
	
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
					while(ites.hasNext()) {
						PurchaseRequest entity = (PurchaseRequest) ites.next();
					%>
				<tr>
					<td><%=entity.getMat_code()%></td>
				    <td><%=entity.getUIcnt()%></td>
					<td align="center"><%=PurchaseRequest.CountByStatus("30",entity.getMat_code()) %></td>
					<td align="center"><%=PurchaseRequest.CountByStatus("41",entity.getMat_code()) %></td>
					<td align="center"><%=PurchaseRequest.CountByStatus("42",entity.getMat_code()) %></td>
					<td align="center"><%=PurchaseRequest.CountByStatus("45",entity.getMat_code()) %></td>
				</tr>
				<%} %>
				</tbody>
			</table>
			</center>
	<%} %>
	
</body>
</html>