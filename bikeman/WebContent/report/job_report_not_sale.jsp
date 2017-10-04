<%@page import="com.bmp.report.html.bean.servicePartDetailBean"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.parts.ServicePartDetail"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.report.job.TS.jobTS"%>
<%@page import="com.bitmap.report.job.bean.servicePartBean"%>
<%@page import="com.bitmap.utils.ReportUtils"%>
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

	List<servicePartDetailBean> list = null;
	list =  jobTS.list_PartNotSale(paramList);

if (export.equalsIgnoreCase("true")) {

	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=Job_Part" + WebUtils.getDateValue(WebUtils.getCurrentDate()) + ".xls");

%>


 <style type="text/css">
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
<title>รายงานสรุปสินค้าที่ไม่ได้ขาย</title>
<body>
	<center>
	<div class="content_head"  >
			<Strong>รายงานสรุปสินค้าที่ไม่ได้ขาย</Strong>
			<br/>
			<Strong>
			
				<%=HeaderDate %> 
			</Strong>
	</div>
	<table class="tb" style="width: 100%;">
		<tbody>
			<tr align="center" >
				<th valign="top" align="center" width="15%">PN</th>
				<th valign="top" align="center" width="50%">Description</th>
				<th valign="top" align="center" width="10%">Units</th>
				<th valign="top" align="center" width="10%">QTY</th>				
				<th valign="top" align="center" width="15%">Unit Price(฿)</th>
			</tr>
			<%
			Iterator<servicePartDetailBean> ite = list.iterator();
			int total = list.size();
			if( ! list.isEmpty() ){
			while(ite.hasNext()){
				servicePartDetailBean entity = (servicePartDetailBean) ite.next();											
			%>
			<tr align="center">
				<td style='mso-number-format:"\@"' align="left"><%=entity.getPn()%></td>
				<td style='mso-number-format:"\@"' align="left"><%=entity.getDescription()%></td>
				<td style='mso-number-format:"\@"' align="left"><%=entity.getType_name()%></td>
				<td style='mso-number-format:"0"'  align="right"><%=Money.moneyInteger(entity.getSum_qty())%></td>				
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getUnit_price().length()>0 && !(entity.getUnit_price().equalsIgnoreCase("0")|| entity.getUnit_price().equalsIgnoreCase("0.00")))?Money.money(entity.getUnit_price())+"":"0.00"%></td>
				
			</tr>
			<%
				}
			}else{
				%>
				<tr>
					<td align="center" colspan="5">
						--- ไม่พบข้อมูล ---
					</td>
				</tr>
				<%
			}
			%>
		</tbody>
	</table>
			<table    class="txt_18" width="100%"> 
				<tr>
					<td  width="70%">
					</td>
					<td align="right"  width="15%">
					<strong>รายการทั้งหมด </strong> :
					</td> 
					<td width="15%" align="right" style='mso-number-format:"0"'> <%=Money.moneyInteger(total)%> </td>
					<td width="15%" align="left"> รายการ</td>
				</tr>
	</table>
</center>	
		
</body>
</html>
