<%@page import="com.bitmap.utils.Money"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bmp.report.web.service.WebServiceReportBean"%>
<%@page import="com.bmp.report.web.service.WebServiceReportTS"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<% 
String branch = WebUtils.getReqString(request, "branch");
String export = WebUtils.getReqString(request, "export");

List<WebServiceReportBean> list = null;
List<String[]> paramList = new ArrayList<String[]>();
if(!branch.equalsIgnoreCase("")){
	paramList.add(new String[]{"branch_id",branch});
}
	session.setAttribute("report_search",paramList );
	list = WebServiceReportTS.ReportListWebService(paramList);
	

if (export.equalsIgnoreCase("true")) {
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=WebService_" + WebUtils.getDateValue(WebUtils.getCurrentDate()) + ".xls");
%>
<style type="text/css">
.tb{border-collapse: collapse;}
.tb tr, .tb td, .tb th{border: .5pt solid #000;border-top: .5pt solid #000; border-bottom: .5pt solid #000;}
.breakword tr  td {
	word-break:break-all;
} 
</style>
<%
} else {
%>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/theme_print.css" rel="stylesheet" type="text/css" media="all">

<%}%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายงานการ ทำงานของ Web Service</title>
</head>
<body>
<center>
	<div class="content_head"  >
			<Strong>รายงานการ ทำงานของ Web Service</Strong>
	</div>
	<table class="tb" style="width: 100%;">
	<tbody>
		<tr align="center">
		<th valign="top" align="center" width="5%" >No.</th>
		<th valign="top" align="center" width="20%">สาขา</th>
		<th valign="top" align="center" width="20%">ตาราง ฝั่ง SH</th>
		<th valign="top" align="center" width="20%">ตาราง ฝั่ง DC</th>
		<th valign="top" align="center" width="10%">จำนวนข้อมูล ฝั่ง SH</th>
		<th valign="top" align="center" width="10%">จำนวนข้อมูล ฝั่ง DC</th>
		<th valign="top" align="center" width="15%">วันที่มีการอัปเดทล่าสุด</th>
		</tr>
	    <%
	    if( ! list.isEmpty() ){
	    	Iterator<WebServiceReportBean> itr = list.iterator();
	    	int i = 1;
	    	while(itr.hasNext()){
	    		WebServiceReportBean en = (WebServiceReportBean) itr.next();
	    		
	    	%>
	    	<tr align="center" >
	    	<td style='mso-number-format:"0"' align="center"><%=i%> </td>
	    	<td style='mso-number-format:"\@"' align="Left"><%=en.getBranch_id() %></td>
	    	<td style='mso-number-format:"\@"' align="Left"><%=en.getTable_sh()  %></td>
	    	<td style='mso-number-format:"\@"' align="Left"><%=en.getTable_dc()  %></td>
	    	<td style='mso-number-format:"0"' align="right"><%=Money.moneyInteger(en.getCount_sh())%> </td>
	    	<td style='mso-number-format:"0"' align="right"><%=Money.moneyInteger(en.getCount_dc())%> </td>
	    	<td style='mso-number-format:"d\/m\/yyyy\ h\:mm\ AM\/PM"' align="center"><%=WebUtils.getDateTimeValue(en.getSync_date())%></td>
	    	</tr>
	    	
	    	<%
	    	i++;
	    	}
	    }else{
	    %>
		    <tr>
		    <td colspan="7" align="center">--ไม่พบข้อมูล --</td>
		    </tr>
	    <%	
	    }
	    %>
	
	</tbody>
	
	
	</table>
</center>
</body>
</html>