<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.dc.SaleOrderService"%>
<%@page import="com.bitmap.bean.dc.SaleServicePartDetail"%>
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
String report_status= WebUtils.getReqString(request, "report_status");

String year_month = WebUtils.getReqString(request, "year_month");
String id = WebUtils.getReqString(request, "id");
String create_date = WebUtils.getReqString(request, "create_date");

String date_send2 = WebUtils.getReqString(request,"date_send2");
String date_send3 = WebUtils.getReqString(request, "date_send3");


List paramsList = new ArrayList();
paramsList.add(new String[]{"id",id});
if(report_type.equalsIgnoreCase(ReportUtils.SALE_STATUS_PO) || report_type.equalsIgnoreCase(ReportUtils.SALE_STATUS_PR)){
	paramsList.add(new String[]{"report_status",report_status});
}
if(report_type.equalsIgnoreCase(ReportUtils.SALE_STATUS_PO)){
	
}else{
	paramsList.add(new String[]{"branch",branch});
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

if (export.equalsIgnoreCase("true")) {
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=" + report_type + "_" + WebUtils.getDateValue(WebUtils.getCurrentDate()) + ".xls");
	
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
	<% if(report_type.equalsIgnoreCase(ReportUtils.SALE_REQUEST)) {%>
	<center>
		<div class="content_head"  >
				<Strong>สรุปรายการสั่งซื้อ</Strong>
		</div>
	<table  class="tb" style="width: 100%;">
		<tbody>
			<tr align="center">
				<th>รายการ</th>
				<th>จำนวน</th>
			
			<%
			String name[]   	= {"Opening","Request","MA Request","Outsource Service","Closed","Cancel"};
			String status_pr[]  = {"10","11","12","15","100","00"};
			for(int i=0;i<=5;i++){ %>
			</tr>
				<td style='mso-number-format:"\@"'><%=name[i]%></td>
				<td align="center" style='mso-number-format:"\@"'><%=SaleServicePartDetail.CountByStatus(status_pr[i],branch)%> รายการ</td>
			</tr>
			<%} %>
		</tbody>
	</table>
	</center>
	<%}else if(report_type.equalsIgnoreCase(ReportUtils.SALE_ORDER)) {%>
		<center>
		<div class="content_head"  >
				<Strong>สรุปรายการสั่งซื้อ</Strong>
		</div>
		<table  class="tb" style="width: 100%;">
		<tbody>
			<tr align="center">
				<th>รายการ</th>
				<th>จำนวน</th>
			
			<%
			String name[]   	= {"Opening","Request","MA Request","Outsource Service","Closed","Cancel"};
			String status_pr[]  = {"10","11","12","15","100","00"};
			for(int i=0;i<=5;i++){ %>
			</tr>
				<td style='mso-number-format:"\@"'><%=name[i]%></td>
				<td align="center" style='mso-number-format:"\@"'><%=SaleOrderService.CountByStatus(status_pr[i])%> รายการ</td>
			</tr>
			<%} %>
		</tbody>
	</table>
	</center>
	<% }else if (report_type.equalsIgnoreCase(ReportUtils.SALE_STATUS_PR)) { %>
		<center>
		<div class="content_head"  >
				<Strong>รายการสั่งซื้อตามสถานะ</Strong>
		</div>
		<table  class="tb" style="width: 100%;">
		<tbody>
			<tr align="center">
				<th>Job ID</th>
				<th>PN</th>
				<th>Description</th>
				<th>Create Date</th>
				<th>Price</th>
				<th>QTY</th>
				<th>Units</th>
				<th>Status</th>
			<%
			boolean has = true;
			int count = 0;
			List list = SaleServicePartDetail.listreport2(paramsList);
			Iterator itr = list.iterator();
			
			if(!list.isEmpty()){
			while(itr.hasNext()){ 
			SaleServicePartDetail entity2 = (SaleServicePartDetail) itr.next();
			String des_unit = PartMaster.SelectUnitDesc(entity2.getPn());
			
			Map map = entity2.getUImap();
			PartMaster master = (PartMaster)map.get(PartMaster.tableName);
			has = false;
			count++;
			
			%>
			</tr>
				<td style='mso-number-format:"\@"'><%=entity2.getNumber()%></td>
				<td style='mso-number-format:"\@"'><%=entity2.getPn()%></td>
				<td style='mso-number-format:"\@"'><%=master.getDescription()%></td>
				<td style='mso-number-format:"Short Date"' align="center"><%=WebUtils.getDateValue(entity2.getCreate_date())%></td> 
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity2.getPrice().length()>0 && !(entity2.getPrice().equalsIgnoreCase("0")|| entity2.getPrice().equalsIgnoreCase("0.00")))?Money.money(entity2.getPrice())+"":"0.00"%></td>
				<td style='mso-number-format:"0"' align="right"><%=entity2.getQty()%></td>
				<td style='mso-number-format:"\@"' align="center"><%=UnitType.selectName(des_unit)%></td>
				<td style='mso-number-format:"\@"' align="center"><%=SaleOrderService.status(entity2.getStatus())%></td>
			</tr>
			
			<% }%>
		<%}else{ %>
				<tr>
					<td colspan="8" align="center">--- ไม่พบรายการ ---</td>
				</tr>
			<%}%>
		</tbody>
	</table>
	<div align="right">ทั้งหมด <%=count%> รายการ </div>
	</center>
	<% }else if (report_type.equalsIgnoreCase(ReportUtils.SALE_STATUS_PO)) {%>
		<center>
		<div class="content_head"  >
				<Strong>รายการใบสั่งซื้อตามสถานะ</Strong>
		</div>
		<table  class="tb" style="width: 100%;">
		<tbody>
			<tr align="center">
				<th>Job ID</th>
				<th>Branch</th>
				<th>Delivery Date</th>
				<th>Price</th>
				<th>Status</th>
			<%
			boolean has = true;
			int count = 0;
			List lst = SaleOrderService.listreport2(paramsList);
			Iterator itr_ = lst.iterator();
			
			if(!lst.isEmpty()){
			while(itr_.hasNext()){ 
				SaleOrderService entity = (SaleOrderService) itr_.next();
				Map map = entity.getUImap();
				BranchMaster entityBranch =(BranchMaster)map.get(BranchMaster.tableName);  
				has = false;
				count++;
			%>
			</tr>
				<td style='mso-number-format:"\@"' align="center"><%=entity.getId()%></td>
				<td style='mso-number-format:"\@"' align="left"><%=entityBranch.getBranch_name()%></td>
				<td style='mso-number-format:"Short Date"' align="center"><%=WebUtils.getDateValue(entity.getDuedate())%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getTotal().length()>0 && !(entity.getTotal().equalsIgnoreCase("0")|| entity.getTotal().equalsIgnoreCase("0.00")))?Money.money(entity.getTotal())+"":"0.00"%></td>
				<td style='mso-number-format:"\@"' align="center"><%=SaleOrderService.status(entity.getStatus())%></td>
			</tr>
			
			<% }%>
		<%}else{ %>
				<tr>
					<td colspan="5" align="center">--- ไม่พบรายการ ---</td>
				</tr>
			<%}%>
		</tbody>
	</table>
	<div align="right">ทั้งหมด <%=count%> รายการ </div>
	</center>
	<% }%>
</body>
</html>