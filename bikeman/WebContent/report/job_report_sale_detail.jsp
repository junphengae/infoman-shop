<%@page import="com.bmp.web.service.transaction.SystemInfoTS"%>
<%@page import="com.bmp.lib.date.thai.DateFormatThai"%>
<%@page import="com.bmp.lib.date.thai.DateDMYTH"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.bmp.report.html.bean.ServiceOtherDetailBean"%>
<%@page import="com.bmp.report.html.bean.ServiceRepairDetailBean"%>
<%@page import="com.bmp.report.html.bean.servicePartDetailBean"%>
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
	

	List<serviceInfoBean> list = null;
	
	list = jobTS.list_SaleDetail(paramList); 
	
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
		
		<% }
	
	else{
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
			Iterator<serviceInfoBean> ite = list.iterator();
			
			String total = "0";
			int number = 0;
			int Row_date = 0;
			if( ! list.isEmpty() ){
				while(ite.hasNext()){
					int total_qty = 0;
					Double total_amount = 0.00;
					Double total_discount = 0.00;
					Double total_vat = 0.00;
					serviceInfoBean entity = (serviceInfoBean) ite.next();
					List<serviceInfoBean> listJobNo = jobTS.list_SaleDetailJobNo(entity.getJob_close(),report_job_status,report_job_id);
					Iterator<serviceInfoBean> iteJobNo = listJobNo.iterator();
					int Row = 0;
					Row_date = jobTS.list_SaleDetailRow(entity.getJob_close(),report_job_status,report_job_id)+(2*listJobNo.size()+1);
					
			%>
			<tr>
				<td style='mso-number-format:"Short Date"' valign="top" align="center" rowspan="<%=Row_date%>"><%=DateFormatThai.getDDMMYYYYPattern(entity.getJob_close())%></td>
			</tr>
			<%
					while(iteJobNo.hasNext()){
						serviceInfoBean entityJobNo = (serviceInfoBean) iteJobNo.next();
						int qty = 0;
						Double amount = 0.00;
						Double discount = 0.00;
						Double vat = 0.00;
						int row_vat = 1;
						List<servicePartDetailBean> listPart = jobTS.list_SaleDetailPart(entityJobNo.getJob_id());
						Iterator<servicePartDetailBean> itePart = listPart.iterator();
						List<ServiceRepairDetailBean> listRepair = jobTS.list_SaleDetailRepair(entityJobNo.getJob_id());
						Iterator<ServiceRepairDetailBean> iteRepair = listRepair.iterator();
						List<ServiceOtherDetailBean> listOther = jobTS.list_SaleDetailOther(entityJobNo.getJob_id());
						Iterator<ServiceOtherDetailBean> iteOther = listOther.iterator();
						Row = listPart.size()+listRepair.size()+listOther.size()+1;
			%>
			<tr>
				<td style='mso-number-format:"\@"' valign="top" align="center" rowspan="<%=(Row+1)%>"><%=DateFormatThai.TimeTH(entityJobNo.getJob_close_datetime()) %></td>
				<td style='mso-number-format:"0"'  valign="top" align="center" rowspan="<%=Row%>"><%=entityJobNo.getJob_id() %></td>
				<td style='mso-number-format:"0"'  valign="top" align="center" rowspan="<%=Row%>"><%=entityJobNo.getBill_id()%></td>
				
				<td style='mso-number-format:"\@"' valign="top" align="left"   rowspan="<%=Row%>"><%=entityJobNo.getPerfix()+"  "+ entityJobNo.getName()+"  "+entityJobNo.getSurname()%>	
			</tr>
			<%		
						while(itePart.hasNext()){
							servicePartDetailBean entityPart = (servicePartDetailBean) itePart.next();
							qty = qty + Integer.parseInt(entityPart.getSum_qty());
							discount = discount + Double.parseDouble(entityPart.getSum_spd_dis_total()); 
							amount = amount + Double.parseDouble(entityPart.getSum_net_price());
							
			%>
			<tr>
				<td style='mso-number-format:"\@"' valign="top" align="left"><%=entityPart.getPn()%></td>
				<td style='mso-number-format:"\@"' valign="top" align="left"><%=entityPart.getDescription()%></td>
				<td style='mso-number-format:"\@"' valign="top" align="center"><%=entityPart.getType_name()%></td>
			<%
							if( entityPart.getUnit_price().length() > 0 && !(entityPart.getUnit_price().equalsIgnoreCase("0") || entityPart.getUnit_price().equalsIgnoreCase("0.00")) ){
			%>	
				<td style='mso-number-format:"\#\,\#\#0\.00"' valign="top" align="right"><%=Money.money(entityPart.getUnit_price())%></td>
			<%
							}else{
			%>	
				<td style='mso-number-format:"\@"' valign="top" align="center">-</td>
			<%
							}
							if( entityPart.getSum_qty().length()>0 && !(entityPart.getSum_qty().equalsIgnoreCase("0") || entityPart.getSum_qty().equalsIgnoreCase("0.00")) ){
			%>
				<td style='mso-number-format:"0"' valign="top" align="center"><%=Money.moneyInteger(entityPart.getSum_qty())%></td>
			<%
							}else{
			%>	
				<td style='mso-number-format:"\@"' valign="top" align="center">-</td>
			<%
							}
							if( entityPart.getSum_spd_dis_total().length()>0 && !(entityPart.getSum_spd_dis_total().equalsIgnoreCase("0") || entityPart.getSum_spd_dis_total().equalsIgnoreCase("0.00")) ){
			%>
				<td style='mso-number-format:"\#\,\#\#0\.00"' valign="top" align="right"><%=Money.money(entityPart.getSum_spd_dis_total())%></td>
			<%
							}else{
			%>
				<td style='mso-number-format:"\@"' valign="top" align="center">-</td>
			<%
							}
							if( entityPart.getSum_net_price().length()>0 && !(entityPart.getSum_net_price().equalsIgnoreCase("0") || entityPart.getSum_net_price().equalsIgnoreCase("0.00")) ){
			%>
				<td style='mso-number-format:"\#\,\#\#0\.00"' valign="top" align="right"><%=Money.money(entityPart.getSum_net_price())%></td>
			<%
							}else{
			%>
				<td style='mso-number-format:"\@"' valign="top" align="center">-</td>
			<%
							}
							if( row_vat == 1 ){
								if( (Row-1) == 1 ){
			%>
				<td style='mso-number-format:"\@"'></td>
			<%	
								}else{
			%>
				<td style='mso-number-format:"\@"' rowspan="<%=(Row-1)%>"></td>
			<%		
							}
						}
						row_vat++;
			%>
			</tr>
			<%				
						}
						
						while(iteRepair.hasNext()){
							ServiceRepairDetailBean entityRepair = (ServiceRepairDetailBean) iteRepair.next();
							discount = discount + Double.parseDouble(entityRepair.getSrd_dis_total()); 
							amount = amount + Double.parseDouble(entityRepair.getSrd_net_price());
			%>
			<tr>
				<td style='mso-number-format:"0"' valign="top" align="left"><%=entityRepair.getLabor_id()%></td>
				<td style='mso-number-format:"\@"' valign="top" align="left"><%=entityRepair.getLabor_name()%></td>
				<td style='mso-number-format:"\@"' valign="top" align="center">-</td>
			<%
							if( entityRepair.getLabor_rate().length()>0 && !(entityRepair.getLabor_rate().equalsIgnoreCase("0") || entityRepair.getLabor_rate().equalsIgnoreCase("0.00")) ){
			%>	
				<td style='mso-number-format:"\#\,\#\#0\.00"' valign="top" align="right"><%=Money.money(entityRepair.getLabor_rate())%></td>
			<%
							}else{
			%>
				<td style='mso-number-format:"\@"' valign="top" align="center">-</td>
			<%
							}
			%>
				<td style='mso-number-format:"\@"' valign="top" align="center">-</td>
			<%
							if( entityRepair.getSrd_dis_total().length()>0 && !(entityRepair.getSrd_dis_total().equalsIgnoreCase("0") || entityRepair.getSrd_dis_total().equalsIgnoreCase("0.00")) ){
			%>	
				<td style='mso-number-format:"\#\,\#\#0\.00"' valign="top" align="right"><%=Money.money(entityRepair.getSrd_dis_total())%></td>
			<%
							}else{
			%>
				<td style='mso-number-format:"\@"' valign="top" align="center">-</td>
			<%
							}
							if( entityRepair.getSrd_net_price().length()>0 && !(entityRepair.getSrd_net_price().equalsIgnoreCase("0") || entityRepair.getSrd_net_price().equalsIgnoreCase("0.00")) ){
			%>
				<td style='mso-number-format:"\#\,\#\#0\.00"' valign="top" align="right"><%=Money.money(entityRepair.getSrd_net_price())%></td>
			<%
							}else{
			%>
				<td style='mso-number-format:"\@"' valign="top" align="center">-</td>
			<%
							}
			%>
			</tr>
			<%
						}
						if( ! listOther.isEmpty() ){
			%>
			<tr>
			<%
							if(listOther.size() == 1){
			%>
				<td style='mso-number-format:"\@"' valign="top" align="left" >ค่าบริการอื่นๆ</td>
			<%
							}else{
			%>
				<td style='mso-number-format:"\@"' valign="top" align="left" rowspan="<%=listOther.size()%>">ค่าบริการอื่นๆ</td>
			
			<%	
							}
							while(iteOther.hasNext()){
								ServiceOtherDetailBean entityOther = (ServiceOtherDetailBean) iteOther.next();
								qty = qty + Integer.parseInt(entityOther.getOther_qty());
								discount = discount + Double.parseDouble(entityOther.getSod_dis_total()); 
								amount = amount + Double.parseDouble(entityOther.getSod_net_price());
			%>	
				<td style='mso-number-format:"\@"' valign="top" align="left"><%=entityOther.getOther_name()%></td>
				<td style='mso-number-format:"\@"' valign="top" align="center">-</td>
			<%
								if( entityOther.getOther_price().length()>0 && !(entityOther.getOther_price().equalsIgnoreCase("0")|| entityOther.getOther_price().equalsIgnoreCase("0.00")) ){
			%>	
				<td style='mso-number-format:"\#\,\#\#0\.00"' valign="top" align="right"><%=Money.money(entityOther.getOther_price())%></td>
			<%
								}else{
			%>	
				<td style='mso-number-format:"\@"' valign="top" align="center">-</td>
			<%
								}
								if( entityOther.getOther_qty().length()>0 && !(entityOther.getOther_qty().equalsIgnoreCase("0") || entityOther.getOther_qty().equalsIgnoreCase("0.00")) ){
			%>
				<td style='mso-number-format:"0"' valign="top" align="center"><%=Money.moneyInteger(entityOther.getOther_qty())%></td>
			<%
								}else{
			%>	
				<td style='mso-number-format:"\@"' valign="top" align="center">-</td>
			<%
								}
								if( entityOther.getSod_dis_total().length()>0 && !(entityOther.getSod_dis_total().equalsIgnoreCase("0") || entityOther.getSod_dis_total().equalsIgnoreCase("0.00")) ){
			%>
				<td style='mso-number-format:"\#\,\#\#0\.00"' valign="top" align="right"><%=Money.money(entityOther.getSod_dis_total())%></td>
			<%
								}else{
			%>	
				<td style='mso-number-format:"\@"' valign="top" align="center">-</td>
			<%
								}
								if( entityOther.getSod_net_price().length()>0 && !(entityOther.getSod_net_price().equalsIgnoreCase("0") || entityOther.getSod_net_price().equalsIgnoreCase("0.00")) ){
			%>
				<td style='mso-number-format:"\#\,\#\#0\.00"' valign="top" align="right"><%=Money.money(entityOther.getSod_net_price())%></td>
			<%
								}else{
			%>
				<td style='mso-number-format:"\@"' valign="top" align="center">-</td>
			<%
								}
			%>
			</tr>
			
			<%			
							}
						}
						vat = Double.parseDouble(entityJobNo.getPay() );	
						DecimalFormat vat_format = new DecimalFormat("0.00");
			%>	
				
			<tr>
				<td colspan="7"  bgcolor="#f0f0f0"><b>ยอดรวม Job</b></td>
			<%
						if( qty > 0 ){
			%>	
				<td style='mso-number-format:"0"' valign="top" align="center" bgcolor="#f0f0f0"><b><%=qty %></b></td>
			<%
						}else{
			%>
				<td style='mso-number-format:"\@"' valign="top" align="center"bgcolor="#f0f0f0"><b>-</b></td>
			<%
						}
						if( discount > 0 ){
			%>
				<td style='mso-number-format:"\#\,\#\#0\.00"' valign="top" align="right" bgcolor="#f0f0f0"><b><%=Money.money( discount ) %></b></td>
			<%
						}else{
			%>	
				<td style='mso-number-format:"\@"' valign="top" align="center" bgcolor="#f0f0f0"><b>-</b></td>
			<%
						}
						if( amount > 0 ){
			%>
				<td style='mso-number-format:"\#\,\#\#0\.00"' valign="top" align="right" bgcolor="#f0f0f0"><b><%=Money.money( amount ) %></b></td>
			<%
						}else{
			%>
				<td style='mso-number-format:"\@"' valign="top" align="center" bgcolor="#f0f0f0">-</td>	
			<%
						}
						if( vat > 0 ){
			%>
				<td style='mso-number-format:"\#\,\#\#0\.00"' valign="top" align="right" bgcolor="#f0f0f0"><b><%=Money.money( entityJobNo.getPay() ) %></b></td>
			<%
						}else{
			%>
				<td style='mso-number-format:"\@"' valign="top" align="center" bgcolor="#f0f0f0"><b>-</b></td>
			<%
						}
			%>
			</tr>
			<%	
						total_qty = total_qty + qty;
						total_discount = total_discount + discount;
						total_amount = total_amount + amount;
						total_vat = total_vat + vat;
					}
			%>
			<tr>
				<td colspan="9" bgcolor="#d8d8d8"><b>ยอดรวมประจำวัน</b></td>
			<%
					if( total_qty > 0 ){
			%>	
				<td style='mso-number-format:"0"' valign="top" align="center" bgcolor="#d8d8d8"><b> <%=total_qty %></b></td>
			<%
					}else{
			%>
				<td style='mso-number-format:"\@"' valign="top" align="center" bgcolor="#d8d8d8"><b>-</b></td>	
			<%
					}
					if( total_discount > 0 ){
			%>	
				<td style='mso-number-format:"\#\,\#\#0\.00"' valign="top" align="right" bgcolor="#d8d8d8"><b><%=Money.money( total_discount ) %></b></td>
			<%
					}else{
			%>
				<td style='mso-number-format:"\@"' valign="top" align="center" bgcolor="#d8d8d8">-</td>	
			<%
					}
					if( total_amount > 0 ){
			%>
				<td style='mso-number-format:"\#\,\#\#0\.00"' valign="top" align="right" bgcolor="#d8d8d8"><b><%=Money.money( total_amount ) %></b></td>
			<%
					}else{
			%>	
				<td style='mso-number-format:"\@"' valign="top" align="center" bgcolor="#d8d8d8"><b>-</b></td>
			<%
					}
					if( total_vat > 0 ){
			%>
				<td style='mso-number-format:"\#\,\#\#0\.00"' valign="top" align="right" bgcolor="#d8d8d8"><b><%=Money.money( total_vat ) %></b></td>
			<%
					}else{
			%>
				<td style='mso-number-format:"\@"' valign="top" align="center" bgcolor="#d8d8d8"><b>-</b></td>
			<%
					}
			%>
			</tr>
			<%
					
				} 
			}else{
			%>
				<tr>
					<td colspan="13" align="center">--- ไม่พบข้อมูล ---</td>
				</tr>
				<%
			}
			%>
		</tbody>
	</table>
</center>	
</body>
</html>
