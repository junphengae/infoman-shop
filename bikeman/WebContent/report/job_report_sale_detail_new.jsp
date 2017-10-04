<%@page import="java.sql.Timestamp"%>
<%@page import="com.bmp.report.html.TS.JobReportSaleDetailTS"%>
<%@page import="com.bmp.report.html.bean.JobReportSaleDetailBean"%>
<%@page import="com.bmp.web.service.transaction.SystemInfoTS"%>
<%@page import="com.bmp.lib.date.thai.DateFormatThai"%>
<%@page import="com.bmp.lib.date.thai.DateDMYTH"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.bmp.lib.util.JMoney"%>
<%@page import="com.bitmap.utils.report.Mobile"%>
<%@page import="com.bitmap.utils.report.getTimeTH"%>
<%@page import="com.bitmap.utils.Money"%>
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

	 List<String[]> paramList = new ArrayList<String[]>();
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
			HeaderDate = "วันที่  "+DateDMYTH.getFullDMYTH(date.replaceAll("-", "/"));
			paramList.add(new String[]{"date",date});
		}
	}else
	if(rd_time.equalsIgnoreCase("2")){
		if(! date_start.equalsIgnoreCase("") && ! date_end.equalsIgnoreCase("")){
			
			HeaderDate = "ระหว่างวันที่ "+DateDMYTH.getFullDMYTH(date_start.replaceAll("-", "/"), date_end.replaceAll("-", "/"));
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
	

	List<JobReportSaleDetailBean> list = null;
	
	list = JobReportSaleDetailTS.JobReportSaleDetailList(paramList);
	
	if (export.equalsIgnoreCase("true")) {
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=Job_Sale" + WebUtils.getDateValue(WebUtils.getCurrentDate()) + ".xls");

%>


<style type="text/css">
.tb{border-collapse: collapse; font-size: 10px !important; font-family:Tahoma !important;    }
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
<title>รายงานสรุปการขาย  <%=SystemInfoTS.select().getName()%></title>
<body>
	<center>
	<div class="content_head"  >
			<Strong>รายงานสรุปการขาย <%=SystemInfoTS.select().getName()%></Strong>
			<br/>
			<Strong>
				<%=HeaderDate %>
			</Strong>
	</div>
	<table class="tb" style="width: 100%;">
		<tbody>
			<tr align="center" >
				<th valign="top" align="center" width="6%" bgcolor="#ababab">วันที่ปิด Job</th>
				<th valign="top" align="center" width="5%" bgcolor="#ababab">เวลาปิด Job</th>
				<th valign="top" align="center" width="4%" bgcolor="#ababab">เลขที่ Job</th>
				<th valign="top" align="center" width="4%" bgcolor="#ababab">เลขที่ใบเสร็จ</th>
				<th valign="top" align="center" width="15%" bgcolor="#ababab">ลูกค้า</th>
				<th valign="top" align="center" width="10%" bgcolor="#ababab">รหัส</th>
				<th valign="top" align="center" width="20%" bgcolor="#ababab">รายละเอียด</th>
				<th valign="top" align="center" width="5%" bgcolor="#ababab">หน่วย</th>
				<th valign="top" align="center" width="6%" bgcolor="#ababab">ราคา/หน่วย</th>
				<th valign="top" align="center" width="6%" bgcolor="#ababab">จำนวน</th>
				<th valign="top" align="center" width="6%" bgcolor="#ababab">ส่วนลด</th>				
				<th valign="top" align="center" width="6%" bgcolor="#ababab">รวม</th>
				<th valign="top" align="center" width="6%" bgcolor="#ababab">ภาษี</th>			
			</tr>
			<%
			Iterator<JobReportSaleDetailBean> ite = list.iterator();
			
			String total = "0";
			String OldDate = "";
			String NewDate = "";
			String Oldjob = "";
			String Newjob = "";
			int number = 0;
			int Row_date = 0;
			if( ! list.isEmpty() ){
				while(ite.hasNext()){
					int total_qty = 0;
					Double total_amount = 0.00;
					Double total_discount = 0.00;
					Double total_vat = 0.00;
					JobReportSaleDetailBean entity = (JobReportSaleDetailBean) ite.next();
					
					NewDate = DateFormatThai.getDDMMYYYYPattern(entity.getJobdate());
					
					System.out.println("NewDate :"+NewDate);
					System.out.println("OldDate :"+OldDate);
					
					if(OldDate.equalsIgnoreCase(NewDate) && !OldDate.equalsIgnoreCase("")){
						Newjob  = entity.getId();
						System.out.println("Newjob :"+Newjob);
						System.out.println("Oldjob :"+Oldjob);
						/* if(Oldjob.equalsIgnoreCase(Newjob) && !Oldjob.equalsIgnoreCase("")){ */
							
					%>
				<tr>
					<td style='mso-number-format:"Short Date"' valign="top" align="center" >
					<%=DateFormatThai.getDDMMYYYYPattern(entity.getJobdate())%></td>
					<td style='mso-number-format:"\@"' valign="top" align="center" ><%=DateFormatThai.TimeTH(entity.getJobdate()) %></td>
					<td style='mso-number-format:"0"'  valign="top" align="center" ><%=entity.getId() %></td>
					<td style='mso-number-format:"0"'  valign="top" align="center" ><%=entity.getBill_id()%></td>				
					<td style='mso-number-format:"\@"' valign="top" align="left"   ><%=entity.getForewordname()+"  "+ entity.getCus_name()+"  "+entity.getCus_surname()%>
					<td style='mso-number-format:"\@"' valign="top" align="left"  ><%=entity.getPn()%></td>
					<td style='mso-number-format:"\@"' valign="top" align="left"  ><%=entity.getName()%></td>
					<td style='mso-number-format:"\@"' valign="top" align="center" ><%=entity.getType()%></td>
					<td style='mso-number-format:"\#\,\#\#0\.00"' valign="top" align="right"><%=Money.money(entity.getPrice())%></td>
					<td style='mso-number-format:"\#\,\#\#0\"' valign="top" align="right"><%=Money.money(entity.getQty())%></td>
					<td style='mso-number-format:"\#\,\#\#0\.00"' valign="top" align="right"><%=Money.money(entity.getDis_total())%></td>
					<td style='mso-number-format:"\#\,\#\#0\.00"' valign="top" align="right"><%=Money.money(entity.getNet_price())%></td>
					<td style='mso-number-format:"\#\,\#\#0\.00"' valign="top" align="right"><%=Money.money(entity.getPay())%></td>
				</tr>	
				<%   //}
						//if(!Oldjob.equalsIgnoreCase(Newjob) && !Oldjob.equalsIgnoreCase("")){ 
							//System.out.println(Newjob+"-------------"+Oldjob);	
						%>
						<%-- <tr>	
						<td colspan="7"  bgcolor="#f0f0f0"><b>ยอดรวม Job<%=entity.getId()  %></b></td>
						</tr> --%>													
						<%
						//}
						//Oldjob  = entity.getId(); 
				}
						
				if(!OldDate.equalsIgnoreCase(NewDate) && !OldDate.equalsIgnoreCase("")){ 
					System.out.println(NewDate+"-------------"+OldDate);
				%>
				<tr>
					<td colspan="9" bgcolor="#d8d8d8"><b>ยอดรวมประจำวัน</b></td>
				</tr>								
				<%}%>
				
			    <%
			    
			     OldDate = DateFormatThai.getDDMMYYYYPattern(entity.getJobdate());		    
				} 				
			}else{
			%>
			<tr><td colspan="13" align="center">--- ไม่พบข้อมูล ---</td></tr>
			<%
			}
			%>
		</tbody>
	</table>
</center>	
</body>
</html>
