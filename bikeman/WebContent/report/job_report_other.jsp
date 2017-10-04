<%@page import="com.bmp.special.fn.BMMoney"%>
<%@page import="com.bitmap.report.job.bean.serviceMiscellaneousBean"%>
<%@page import="com.bitmap.report.job.bean.serviceServiceBean"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.report.job.TS.jobTS"%>
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
		
	
			
		
	List<serviceMiscellaneousBean> list = null;
	list =  jobTS.list_serviceMiscellaneous(paramList);
	 
if (export.equalsIgnoreCase("true")) {

	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=Job_Other" + WebUtils.getDateValue(WebUtils.getCurrentDate()) + ".xls");

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
<title>รายงานการขายอื่นๆ</title>
<body>
	<center>
	<div class="content_head"  >
			<Strong>รายงานการขายอื่นๆ</Strong>
			<br/>
			<Strong>
			<%=HeaderDate %>
			</Strong>
	</div>
	<table class="tb" style="width: 100%;">
		<tbody>
			<tr align="center" >
				<th valign="top" align="center" width="9%">Job No</th>
				<th valign="top" align="center" width="9%">Create Date</th>
				<th valign="top" align="center" width="9%">Close Job Date</th>
				<th valign="top" align="center" width="25%">Description</th>
				<th valign="top" align="center" width="5%">Qty</th>
				<th valign="top" align="center" width="9%">Unit Price(฿)</th>
				<th valign="top" align="center" width="9%">Price(฿)</th>
				<th valign="top" align="center" width="5%">Discount(%)</th>
				<th valign="top" align="center" width="5%">Discount Cash</th>
				<th valign="top" align="center" width="6%">Total Discount(฿)</th>
				<th valign="top" align="center" width="5%">Total Vat(฿)</th>
				<th valign="top" align="center" width="9%">Total Amount(฿)</th>					
			</tr>
			<%
			Iterator ite = list.iterator();
			Boolean hasCheck = false;
			String total = "0";
			
			Double total_price = 0.00;
			Double total_Discount = 0.00;
			Double total_Vat = 0.00;
			
			while(ite.hasNext()){
				hasCheck = true;
				serviceMiscellaneousBean entity = (serviceMiscellaneousBean) ite.next();
				total = Money.add(total, "1");
				
				total_Discount 	+= Double.parseDouble(Money.removeCommas( Money.money(entity.getSod_dis_total())	));
				total_Vat 		+= Double.parseDouble(Money.removeCommas( Money.money(entity.getTotal_vat())		));
				total_price 	+= Double.parseDouble(Money.removeCommas( Money.money(entity.getSod_net_price())	));
				
			%>
			<tr align="center">
				<!-- /* 04-03-2557 */ --> 
				<td style='mso-number-format:"0"'  align="center">	<%=entity.getJob_id() %></td>
				<td style='mso-number-format:"Short Date"' align="center"><%=WebUtils.getDateValue(entity.getCreate_date()) %></td>
				<td style='mso-number-format:"Short Date"' align="center"><%=WebUtils.getDateValue(entity.getJob_close_date())%></td>
				<td style='mso-number-format:"\@"' align="left"><%=entity.getName()%></td>
				<td style='mso-number-format:"0"' align="right"><%=Money.moneyInteger(entity.getQty())%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getPrice().length()>0 && !(entity.getPrice().equalsIgnoreCase("0")|| entity.getPrice().equalsIgnoreCase("0.00")))?Money.money(entity.getPrice())+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=Money.money( BMMoney.MoneyMultiple(entity.getPrice(), entity.getQty()) )%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getDiscount().length()>0 && !(entity.getDiscount().equalsIgnoreCase("0")|| entity.getDiscount().equalsIgnoreCase("0.00")))?Money.money(entity.getDiscount())+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getCash_discount().length()>0 && !(entity.getCash_discount().equalsIgnoreCase("0")|| entity.getCash_discount().equalsIgnoreCase("0.00")))?Money.money(entity.getCash_discount())+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getSod_dis_total().length()>0 && !(entity.getSod_dis_total().equalsIgnoreCase("0")|| entity.getSod_dis_total().equalsIgnoreCase("0.00")))?Money.money(entity.getSod_dis_total())+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getTotal_vat().length()>0 && !(entity.getTotal_vat().equalsIgnoreCase("0")|| entity.getTotal_vat().equalsIgnoreCase("0.00")))?Money.money(entity.getTotal_vat())+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getSod_net_price().length()>0 && !(entity.getSod_net_price().equalsIgnoreCase("0")|| entity.getSod_net_price().equalsIgnoreCase("0.00")))?Money.money(entity.getSod_net_price())+"":"0.00"%></td>
				
			</tr>
			<%
			}
			if(!hasCheck){
				%>
				<tr>
					<td colspan="11" align="center">
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
					<td width="15%" align="right" style='mso-number-format:"0"'> <%=Money.moneyInteger(total)%></td>
					<td width="15%" align="left">รายการ</td>
				</tr>
				<tr>
					<td    width="70%">
					</td>
					<td align="right"  width="15%">
					<strong>ยอดรวมก่อนลด </strong> :
					</td>
					<td width="15%" align="right" style='mso-number-format:"\#\,\#\#0\.00"'> <%=Money.money(String.valueOf(total_price + total_Discount))%></td>
					<td width="15%" align="left">บาท</td>
				</tr>
				<tr>
					<td    width="70%">
					</td>
					<td align="right"  width="15%">
					<strong>ส่วนลดทั้งหมด </strong> :
					</td>
					<td width="15%" align="right" style='mso-number-format:"\#\,\#\#0\.00"'> <%=Money.money(String.valueOf(total_Discount))%> </td>
					<td width="15%" align="left"> บาท</td>
				</tr>
				<tr>
					<td    width="70%">
					</td>
					<td align="right"  width="15%">
					<strong>ภาษีทั้งหมด </strong> :
					</td>
					<td width="15%" align="right" style='mso-number-format:"\#\,\#\#0\.00"'> <%=Money.money(String.valueOf(total_Vat))%> </td>
					<td width="15%" align="left">บาท</td>
				</tr>
				<tr>
					<td    width="70%">
					</td>
					<td align="right"  width="15%">
					<strong>รายได้ทั้งหมด </strong> :
					</td>
					<td width="15%" align="right" style='mso-number-format:"\#\,\#\#0\.00"'> <%=Money.money(String.valueOf(total_price))%> </td>
					<td width="15%" align="left">  บาท</td>
				</tr>
	</table>
</center>		
</body>
</html>
