<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
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
		

			
	List<servicePartBean> list = null;
	list =  jobTS.list_servicePart(paramList); 
	 
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
<title>รายงานสินค้าที่ขาย</title>
<body>
	<center>
	<div class="content_head"  >
			<Strong>รายงานสินค้าที่ขาย</Strong>
			<br/>
			<Strong>
			<%=HeaderDate %> 
			</Strong>
	</div>
	<table class="tb" style="width: 100%;">
		<tbody>
			<tr align="center" >
				<th valign="top" align="center" width="5%">	Job No</th>
				<th valign="top" align="center" width="9%">	Create Date</th>
				<th valign="top" align="center" width="9%">	Close Job Date</th>
				<th valign="top" align="center" width="10%"> pn</th>
				<th valign="top" align="center" width="24%"> Description</th>
				<th valign="top" align="center" width="5%">	Units</th>
				<th valign="top" align="center" width="5%">	QTY	</th>				
				<th valign="top" align="center" width="9%"> Price(฿)</th>
				<th valign="top" align="center" width="5%">	Discount(%)</th>
				<th valign="top" align="center" width="5%">	Discount Cash</th>
				<th valign="top" align="center" width="9%">	Total Discount(฿)</th>
				<th valign="top" align="center" width="6%">	Total Vat(฿)</th>
				<th valign="top" align="center" width="9%">	Total Amount(฿)</th>
			</tr>
			<%
			Iterator ite = list.iterator();
			Boolean hasCheck = false;
			String total = "0";
			Double total_price = 0.00;
			Double total_Dis = 0.00;
			Double total_vat = 0.00;
			
			//String total_price_net = "0";
			while(ite.hasNext()){
				hasCheck = true;
				servicePartBean entity = (servicePartBean) ite.next();
				
				total = Money.add(total, "1"); //รายการทั้งหมด
				
				total_Dis 	+= Double.parseDouble(Money.removeCommas( Money.money(entity.getDis_total())	)); //ส่วนลดทั้งหมด
				total_vat 	+= Double.parseDouble(Money.removeCommas( Money.money(entity.getTotal_vat())	)); //ภาษีทั้งหมด
				total_price += Double.parseDouble(Money.removeCommas( Money.money(entity.getNet_price())	)); //รายได้ทั้งหมด
				String des_unit = PartMaster.SelectUnitDesc(entity.getPn());//Units
				
				//total_price_net = Money.add(total_price_net, String.valueOf( Double.parseDouble(entity.getPrice())*Double.parseDouble(entity.getDraw()) )  ); //ยอดรวมก่อนลด
				
				
			%>
			<tr align="center">
				<td style='mso-number-format:"0"' align="center">	<%=entity.getJob_id() %></td>
				<td style='mso-number-format:"Short Date"' align="center"><%=WebUtils.getDateValue(entity.getCreate_date()) %></td>
				<td style='mso-number-format:"Short Date"' align="center"><%=WebUtils.getDateValue(entity.getJob_close_date()) %></td>
				<td style='mso-number-format:"\@"' align="left"><%=entity.getPn()%></td>
				<td style='mso-number-format:"\@"' align="left"><%=entity.getPart_name()%></td>
				<td style='mso-number-format:"\@"' align="left"><%=UnitType.selectName(des_unit)%></td>
				<td style='mso-number-format:"0"'  align="right"><%=Money.moneyInteger(entity.getDraw()	)%></td>				
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getPrice().length()>0 && !(entity.getPrice().equalsIgnoreCase("0")|| entity.getPrice().equalsIgnoreCase("0.00")))?Money.money(entity.getPrice())+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getDiscount().length()>0 && !(entity.getDiscount().equalsIgnoreCase("0") || entity.getDiscount().equalsIgnoreCase("0.00")))?Money.money(entity.getDiscount())+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getCash_discount().length()>0 && !(entity.getCash_discount().equalsIgnoreCase("0") || entity.getCash_discount().equalsIgnoreCase("0.00")))?Money.money(entity.getCash_discount())+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getDis_total().length()>0 && !(entity.getDis_total().equalsIgnoreCase("0")|| entity.getDis_total().equalsIgnoreCase("0.00")))?Money.money(entity.getDis_total())+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getTotal_vat().length()>0 && !(entity.getTotal_vat().equalsIgnoreCase("0")|| entity.getTotal_vat().equalsIgnoreCase("0.00")))?Money.money(entity.getTotal_vat())+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getNet_price().length()>0 && !(entity.getNet_price().equalsIgnoreCase("0")|| entity.getNet_price().equalsIgnoreCase("0.00")))?Money.money(entity.getNet_price())+"":"0.00"%></td>
			</tr>
			<%
			}
			if(!hasCheck){
				%>
				<tr>
					<td align="center" colspan="12">
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
					<td width="15%" align="right" style='mso-number-format:"\#\,\#\#0\.00"'> <%=Money.money(String.valueOf(total_price+total_Dis))%> </td>
					<td width="15%" align="left"> บาท</td>
				</tr>
				<tr>
					<td    width="70%">
					</td>
					<td align="right"  width="15%">
					<strong>ส่วนลดทั้งหมด  </strong> :
					</td>
					<td width="15%" align="right" style='mso-number-format:"\#\,\#\#0\.00"'> <%=Money.money(String.valueOf(total_Dis))%> </td>
					<td width="15%" align="left"> บาท</td>
				</tr>
				<tr>
					<td    width="70%">
					</td>
					<td align="right"  width="15%">
					<strong>ภาษีทั้งหมด  </strong> :
					</td>
					<td width="15%" align="right" style='mso-number-format:"\#\,\#\#0\.00"'> <%=Money.money(String.valueOf(total_vat))%></td>
					<td width="15%" align="left">บาท</td>
				</tr>
				<tr>
					<td    width="70%">
					</td>
					<td align="right"  width="15%">
					<strong>รายได้ทั้งหมด </strong> :
					</td>
					<td width="15%" align="right" style='mso-number-format:"\#\,\#\#0\.00"'> <%=Money.money(String.valueOf(total_price))%></td>
					<td width="15%" align="left"> บาท</td>
				</tr>
	</table>
</center>			
</body>
</html>
