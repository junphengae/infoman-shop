<%@page import="com.bmp.web.service.transaction.SystemInfoTS"%>
<%@page import="com.bmp.special.fn.BMMoney"%>
<%@page import="com.bmp.lib.util.JMoney"%>
<%@page import="com.bitmap.utils.report.Mobile"%>
<%@page import="com.bitmap.bean.parts.ServiceRepair"%>
<%@page import="com.bitmap.utils.report.getTimeTH"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.report.job.TS.jobTS"%>
<%@page import="com.bitmap.report.job.bean.serviceInfoBean"%>
<%@page import="com.bitmap.utils.ReportUtils"%>
<%@page import="com.bitmap.webutils.customtag.ComboBoxTag"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.security.SecurityUnit"%>
<%@page import="com.bitmap.security.SecuritySystem"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>


<%
	String export = WebUtils.getReqString(request, "export");
	String rd_time = WebUtils.getReqString(request, "rd_time");
	
	String date = WebUtils.getReqString(request, "date");
	
	String date_start = WebUtils.getReqString(request, "date_start");
	String date_end = WebUtils.getReqString(request, "date_end");
	
	String month = WebUtils.getReqString(request, "month");
	String year = WebUtils.getReqString(request, "year");
	
	String repair_type = WebUtils.getAjaxReqString(request, "repair_type");
	String report_job_id = WebUtils.getAjaxReqString(request, "report_job_id");
	String report_job_status = WebUtils.getAjaxReqString(request, "report_job_status");

	 List paramList = new ArrayList();
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
	paramList.add(new String[]{"repair_type",repair_type});
	paramList.add(new String[]{"report_job_id",report_job_id});
	paramList.add(new String[]{"report_job_status",report_job_status});
	if(rd_time.equalsIgnoreCase("0")){
		HeaderDate ="";
	}else
	if(rd_time.equalsIgnoreCase("1")){
		if(! date.equalsIgnoreCase("")){
			HeaderDate = "วันที่  "+date;
			paramList.add(new String[]{"date",date});
		}
	}else
	if(rd_time.equalsIgnoreCase("2")){
		if(! date_start.equalsIgnoreCase("") && ! date_end.equalsIgnoreCase("")){
			HeaderDate = "ระหว่างวันที่ "+date_start+" ถึงวันที่ "+date_end;
			paramList.add(new String[]{"report_job_startdate",date_start});
			paramList.add(new String[]{"report_job_enddate",date_end});
		}
		
	}
	else
	if(rd_time.equalsIgnoreCase("3")){
		if(! month.equalsIgnoreCase("") && ! year.equalsIgnoreCase("")){
			HeaderDate = "ประจำเดือน "+month_name[WebUtils.getInteger(month)]+" ปี "+year;
			paramList.add(new String[]{"report_job_month",month});
			paramList.add(new String[]{"report_job_month_year",year});
		}
			
	}
	

	List<serviceInfoBean> list = null;
	
	list = jobTS.list_serviceBillInfo(paramList); 

	if (export.equalsIgnoreCase("true")) {
	//response.setContentType("application/pdf");
	//response.setHeader("Content-Disposition", "inline;filename=Job_Sale" + WebUtils.getDateValue(WebUtils.getCurrentDate()) + ".pdf");
	
%>
<script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script>
<script src="../js/number.js"></script>
<script src="../js/two_decimal_places.js" type="text/javascript"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css">
<link href="../css/theme_print_rp.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
	$(function(){
		setTimeout('window.print()',500); 
		setTimeout('window.close()',1000);
	});
</script>

<style type="text/css" media="print"> 
.tb{border-collapse: collapse;}
.tb tr, .tb td, .tb th{border: .5pt solid #000;border-top: .5pt solid #000; border-bottom: .5pt solid #000;}
.breakword tr  td {
	word-break:break-all;
} 
</style>  

<% }else{
%>
<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/theme_print.css" rel="stylesheet" type="text/css" media="all">
<%
}
%>


<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายงานใบเสร็จฉบับเต็ม</title>
<body>
	<center>
	<div class="content_head"  >
			<Strong>รายงานใบเสร็จฉบับเต็ม</Strong>
			<br/>
			<Strong>
				<%=HeaderDate %>
			</Strong>
	</div>
	<table class="tb" style="width: 100%;">
		<tbody>
			<tr align="center" >
				<th valign="top" align="center" width="10%">Branch</th>
				<th valign="top" align="center" width="20%">Job</th>
				<th valign="top" align="center" width="20%">Doc</th>
				<th valign="top" align="center" width="50%">Customer</th>									
			</tr>
			<%
			Iterator ite = list.iterator();
			Boolean hasCheck = false;
			while(ite.hasNext()){
				hasCheck = true;				
				serviceInfoBean entity = (serviceInfoBean) ite.next();				 							
			%>
			<tr align="center">				
				<td  align="left"><%=SystemInfoTS.select().getBranch_name_en()%></td>
				<td  align="left"><%=entity.getJob_id() %></td>
				<td  align="left"><%=entity.getBill_id() %></td>			
				<td  align="left"><%=entity.getPerfix()+" "+entity.getName()+" "+entity.getSurname()%></td>
			</tr>
			<%
			} 
			if(!hasCheck){
				%>
				<tr>
					<td colspan="4" align="center">
						--- ไม่พบข้อมูล ---
					</td>
				</tr>
				<%
			}
			%>
		</tbody>
	</table>	
</center>	
</body>
</html>
