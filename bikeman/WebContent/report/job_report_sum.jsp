<%@page import="com.bmp.report.html.TS.ReportServiceJobTS"%>
<%@page import="com.bmp.report.html.bean.ServiceRepairDetailBean"%>
<%@page import="com.bmp.report.html.bean.ServiceOtherDetailBean"%>
<%@page import="com.bmp.report.html.bean.ServicePartDetailAllBean"%>
<%@page import="com.bmp.report.html.bean.ServiceSumBean"%>
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

			

			List<ServiceSumBean> list = null;
			list =  ReportServiceJobTS.ListServiceSum(paramList);

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

<%
 	}else{
 %>
<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/theme_print.css" rel="stylesheet" type="text/css" media="all">
<%
	}
%>


<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายงานสรุปสินค้าที่ขาย</title>
<body>
	<center>
	<div class="content_head"  >
			<Strong>รายงานสรุปสินค้าที่ขาย</Strong>
			<br/>
			<Strong>			
				<%=HeaderDate%> 
			</Strong>
	</div>
	<table class="tb" style="width: 100%;">
		<tbody>
			<tr align="center" >
				<th valign="top" align="center" width="7%">วันที่ปิด</th>
				<th valign="top" align="center" width="5%">เวลาปิด</th>
				<th valign="top" align="center" width="5%">ลำดับ</th>
				<th valign="top" align="center" width="5%">JOB</th>
				<th valign="top" align="center" width="15%">ชื่อลูกค้า</th>
				<th valign="top" align="center" width="10%">รหัส</th>
				<th valign="top" align="center" width="15%">รายละเอียด</th>
				<th valign="top" align="center" width="7%">หน่วยนับ</th>
				<th valign="top" align="center" width="7%">ราคา/หน่วย </th>
				<th valign="top" align="center" width="7%">จำนวน </th>
				<th valign="top" align="center" width="7%">ส่วนลด(บาท)</th>
				<th valign="top" align="center" width="7%">ยอดรวม</th>
				<th valign="top" align="center" width="7%">ภาษี</th>
			</tr>
			<%
				Iterator ite = list.iterator();
					Boolean hasCheck = false;
					String number_job = "0";
					
					while(ite.hasNext()){
						hasCheck = true;
						ServiceSumBean entity = (ServiceSumBean) ite.next();							
						number_job = Money.add(number_job, "1");
						
						/* List<ServicePartDetailAllBean> listPart = ReportServiceJobTS.ListServicePartDetail(entity.getJob_id());
						List<ServiceOtherDetailBean>   listOther = ReportServiceJobTS.ListServiceOtherDetail(entity.getJob_id());
						List<ServiceRepairDetailBean>  listRepair = ReportServiceJobTS.ListServiceRepairDetail(entity.getJob_id());
						 */
			%>
			<tr align="center">
				<td style='mso-number-format:"\@"' align="center"><%=entity.getJob_close_date()%></td>
				<td style='mso-number-format:"\@"' align="center"><%=entity.getTime_job_close()%></td>
				<td style='mso-number-format:"0"'  align="center"><%=Money.moneyInteger(number_job)%></td>
				<td style='mso-number-format:"\@"' align="center"><%=entity.getJob_id()%></td>
				<td style='mso-number-format:"\@"' align="left"><%=entity.getPrefix()+" "+entity.getName()+"  "+entity.getSurname()%></td>

				
			</tr>
			<%
				}
			if(!hasCheck){
				%>
				<tr>
					<td align="center" colspan="13">
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
					<td    width="70%">
					</td>
					<td align="right"  width="15%">
					<strong>รายการทั้งหมด </strong> :
					</td> 
					<td width="15%" align="right" style='mso-number-format:"0"'> </td>
					<td width="15%" align="left"> รายการ</td>
				</tr>
				<tr>
					<td    width="70%">
					</td>
					<td align="right"  width="15%">
					<strong>รายได้ทั้งหมด </strong> :
					</td>
					<td width="15%" align="right" style='mso-number-format:"0\.00"'></td>
					<td width="15%" align="left"> บาท</td>
				</tr>
	</table>
</center>	
		
</body>
</html>
