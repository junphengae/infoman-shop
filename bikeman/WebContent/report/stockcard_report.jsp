<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="java.util.Date"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.servlet.parts.PartManagement"%>
<%@page import="com.bitmap.bean.parts.StockCardReport"%>
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
		paramList.add(new String[]{"repair_type",repair_type});
		paramList.add(new String[]{"report_job_id",report_job_id});
		paramList.add(new String[]{"report_job_status",report_job_status});

			

	 
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
<title>สรุปรายงาน Stock Card</title>
<body>
	<center>
	<div class="content_head"  >
			<Strong>สรุปรายงาน Stock Card</Strong>
			<br/>
			<Strong>
				<%=HeaderDate %>
			</Strong>
	</div>
	<table class="tb" style="width: 100%;">
		<tbody>
			<tr align="center" >
				<th valign="top" align="center" width="10%">วันที่ทำรายการ	</th>
				<th valign="top" align="center" width="10%">รหัสสินค้า</th>
				<th valign="top" align="center" width="10%">คำอธิบาย  </th>
				<th valign="top" align="center" width="10%">ราคาต่อหน่วย</th>
				<th valign="top" align="center" width="10%">ราคารับเข้า </th>
				<th valign="top" align="center" width="10%">ราคาที่เบิก</th>
				<th valign="top" align="center" width="10%">จำนวนรับเข้า</th>
				<th valign="top" align="center" width="10%">จำนวนที่เบิก </th>
				<th valign="top" align="center" width="10%">ราคาคงเหลือ</th>
				<th valign="top" align="center" width="10%">จำนวนคงเหลือ</th>
			</tr>
			<%
				Iterator iteMas = PartMaster.selectListPn().iterator();
				
				while(iteMas.hasNext()){
					//has = true;
					PartMaster part = (PartMaster) iteMas.next();
				
						Date dd  = DBUtility.getDBCurrentDate();
							//Boolean hasCheck = false;
					//System.out.println("dd:"+dd);
					
							Iterator ite = StockCardReport.report_stockCard(part.getPn(), dd).iterator();
							while(ite.hasNext()){
								//hasCheck = true;
								StockCardReport entity = (StockCardReport)ite.next();
								
							%>  
								<tr >
									<td align="left"><%//=%></td>
									<td align="left"><%=entity.getPn() %></td>
									<td align="left"><%=entity.getDescription() %></td>
									<td align="right"><%=Money.money(entity.getPrice()) %></td>
									<td align="right"><%=Money.money(entity.getPrice_lot()) %></td>
									<td align="right"><%=Money.money(entity.getPrice_draw()) %></td>
									<td align="right"><%=entity.getQty_lot() %></td>
									<td align="right"><%=entity.getQty_draw() %></td>
									<td align="right"><%=Money.money(entity.getTotal_price()) %></td>
									<td align="right"><%=entity.getQty() %></td>
								</tr>
							<%
								}
				}%>
		       <%-- if(!hasCheck){
				%>
				<tr>
					<td colspan="8">
						--- ไม่พบข้อมูล ---
					</td>
				</tr>
				<%
			}
			%>   --%>
		</tbody>
	</table>
			<table    class="txt_18" width="100%"> 
				<tr>
					<td    width="80%">
					</td>
					<td align="left"  width="10%">
					<strong>รายการทั้งหมด </strong> :
					</td> 
					<td width="10%" align="right"> <%//=Money.moneyInteger(total)%> รายการ</td>
				</tr>
				<tr>
					<td    width="80%">
					</td>
					<td align="left"  width="10%">
					<strong>รายได้ทั้งหมด </strong> :
					</td>
					<td width="10%" align="right"> <%//=Money.money(total_price)%> บาท</td>
				</tr>
	</table>
</center>	
		
</body>
</html>
