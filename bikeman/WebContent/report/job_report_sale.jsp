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
	
	list = jobTS.list_serviceInfo_report(paramList); 

	if (export.equalsIgnoreCase("true")) {
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=Job_Sale" + WebUtils.getDateValue(WebUtils.getCurrentDate()) + ".xls");

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
<title>รายงานการขาย</title>
<body>
	<center>
	<div class="content_head"  >
			<Strong>รายงานการขาย</Strong>
			<br/>
			<Strong>
				<%=HeaderDate %>
			</Strong>
	</div>
	<table class="tb" style="width: 100%;">
		<tbody>
			<tr align="center" >
				<th valign="top" align="center" width="5%">	Job No	</th>
				<th valign="top" align="center" width="6%">	Name	</th>
				<th valign="top" align="center" width="5%">	Surname	</th>
				<th valign="top" align="center" width="5%">	Brand	</th>
				<th valign="top" align="center" width="5%">	Model	</th>
				<th valign="top" align="center" width="6%">	Plate	</th>
				<th valign="top" align="center" width="6%">	Plate Province	</th>
				<th valign="top" align="center" width="6%">	Open Job		</th>
				<th valign="top" align="center" width="6%"> Open Job Time 	</th>
				<th valign="top" align="center" width="6%"> Close Job		</th>
				<th valign="top" align="center" width="8%"> Driver contact	</th>
				<th valign="top" align="center" width="8%"> Service Type	</th>
				<th valign="top" align="center" width="8%"> Service required</th>
				<th valign="top" align="center" width="5%">	เวลาที่ใช้(นาที)			</th>
				<!-- ------------------------------------ -->
				<th valign="top" align="center" width="5%">Sub Total(฿)	</th>
				<!-- ------------------------------------ -->
				<th valign="top" align="center" width="5%">	Total Discount(฿)	</th>
				<th valign="top" align="center" width="5%">	Total Amount(฿)	</th>
				<th valign="top" align="center" width="5%">	Total Vat(฿)		</th>
				<th valign="top" align="center" width="5%">	Total Price(฿)		</th>
				
						
			</tr>
			<%
			Iterator ite = list.iterator();
			Boolean hasCheck = false;
			
			
			String total_job = "0";
			Double sub_total =0.00;
			Double discount_total = 0.00;
			Double amount_total = 0.00;
			Double vat_total = 0.00; 
			Double Total_Price =0.00;
			
			String total_price_job = "";
			
			while(ite.hasNext()){
				hasCheck = true;
				
				serviceInfoBean entity = (serviceInfoBean) ite.next();
				 
				total_price_job = BMMoney.MoneySubtract(Money.removeCommas( Money.money(entity.getTotal_amount())), Money.removeCommas( Money.money(entity.getPay()))); 
				
				
				total_job = Money.add(total_job,"1");// จำนวนวน job
				sub_total  		+= Double.parseDouble(Money.removeCommas( Money.money(entity.getTotal()) 	 ));
				discount_total  += Double.parseDouble(Money.removeCommas( Money.money(entity.getDiscount()) 	 ));
				amount_total 	+= Double.parseDouble(Money.removeCommas( Money.money(entity.getTotal_amount())  )); 
				vat_total 		+= Double.parseDouble(Money.removeCommas( Money.money(entity.getPay())			 ));
				Total_Price		+= Double.parseDouble( Money.removeCommas( Money.money(total_price_job) ) );
				
			%>
			<tr align="center">
				
				<td style='mso-number-format:"0"'  align="center"><%=entity.getJob_id() %></td>
				<td style='mso-number-format:"\@"' align="left"><%=entity.getPerfix()+" "+entity.getName()%></td>
				<td style='mso-number-format:"\@"' align="left"><%=entity.getSurname() %></td>
				<td style='mso-number-format:"\@"' align="left"><%=entity.getBrand().length()>0?entity.getBrand():"-"%></td>
				<td style='mso-number-format:"\@"' align="left"><%=entity.getModel().length()>0?entity.getModel():"-"%></td>
				<td style='mso-number-format:"\@"' align="left"><%=entity.getPlate()%></td>
				<td style='mso-number-format:"\@"' align="left"><%=entity.getPlate_province()%></td>
				<td style='mso-number-format:"Short Date"' align="center"><%=WebUtils.getDateValue(entity.getCreate_date()) %></td>
				<td style='mso-number-format:"\@"' align="center"><%=getTimeTH.TimeTH(entity.getCreate_date_time())%></td>
				<td style='mso-number-format:"Short Date"' align="center"><%=WebUtils.getDateValue(entity.getJob_close()) %></td>
				<td style='mso-number-format:"\@"' align="left"><%=(entity.getDriven_contact()== null || entity.getDriven_contact().equalsIgnoreCase("") ||entity.getDriven_contact().equalsIgnoreCase("0")?"-":Mobile.mobile(entity.getDriven_contact()))%>	</td>
				<td style='mso-number-format:"\@"' align="left"> <%=ServiceRepair.repairType_th(entity.getRepair_type()) %></td>
				<td style='mso-number-format:"\@"' align="left"> <%=entity.getProblem() %></td>
				<td style='mso-number-format:"\#\,\#\#0"'  align="right">		
					<div style="margin-right: 1%">
						<%=entity.getTime_complete().length()>0? Money.moneyInteger(entity.getTime_complete())+"":"-" %>	
					</div>	
				</td>	
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getTotal().length()>0 && !(entity.getTotal().equalsIgnoreCase("0")|| entity.getTotal().equalsIgnoreCase("0.00")))?Money.money(entity.getTotal())+"":"0.00"%></td> <!-- Sub Total -->
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getDiscount().length()>0 && !(entity.getDiscount().equalsIgnoreCase("0")|| entity.getDiscount().equalsIgnoreCase("0.00")))?Money.money(entity.getDiscount())+"":"0.00"%></td><!-- Discount(บาท) -->
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getTotal_amount().length()>0 && !(entity.getTotal_amount().equalsIgnoreCase("0")|| entity.getTotal_amount().equalsIgnoreCase("0.00")))?Money.money(entity.getTotal_amount())+"":"0.00"%></td><!-- Total Amount -->				
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getPay().length()>0 && !(entity.getPay().equalsIgnoreCase("0")|| entity.getPay().equalsIgnoreCase("0.00")))?Money.money(entity.getPay())+"":"0.00"%></td><!-- Vat -->
				
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(total_price_job.length()>0 && !(total_price_job.equalsIgnoreCase("0")|| total_price_job.equalsIgnoreCase("0.00")))?Money.money(total_price_job)+"":"0.00"%></td><!-- Total Price -->
				
			</tr>
			<%
			} 
			if(!hasCheck){
				%>
				<tr>
					<td colspan="19" align="center">
						--- ไม่พบข้อมูล ---
					</td>
				</tr>
				<%
			}
			%>
		</tbody>
	</table>
	<table  class="txt_19" width="100%"> 
				<tr>
					<td colspan="11"   width="70%">
					</td>
					<td colspan="3" align="right"  width="20%">
					<strong>รายการทั้งหมด </strong> :
					</td> 
					<td colspan="3" width="15%" align="right" style='mso-number-format:"0"'> <%=Money.moneyInteger(String.valueOf(total_job))%></td>
					<td colspan="2" width="15%" align="left">รายการ</td>
				</tr>
				<tr>
					<td colspan="11"   width="70%">
					</td>
					<td colspan="3" align="right"  width="20%">
					<strong>ยอดก่อนหักส่วนลดทั้งหมด </strong> :
					</td> 
					<td colspan="3" width="15%" align="right" style='mso-number-format:"\#\,\#\#0\.00"'> <%=Money.money(sub_total)%></td>
					<td colspan="2" width="15%" align="left">รายการ</td>
				</tr>
				<tr>
					<td  colspan="11"  width="70%">
					</td>
					<td colspan="3" align="right"  width="20%">
					<strong>ส่วนลดทั้งหมด </strong> :
					</td>
					<td colspan="3" width="15%" align="right" style='mso-number-format:"\#\,\#\#0\.00"'><%=Money.money(discount_total)%>  </td>
					<td colspan="2" width="15%" align="left">บาท</td>
				</tr>
				<tr>
					<td colspan="11" width="70" > 
					</td>
					<td colspan="3" align="right"  width="20%" >
					<strong>รายได้ทั้งหมด </strong> :
					</td>
					<td colspan="3" width="15%" align="right" style='mso-number-format:"\#\,\#\#0\.00"'>  <%=JMoney.money(amount_total )%></td>
					<td colspan="2" width="15%" align="left"> บาท</td>
				</tr>
				<tr>
					<td colspan="11"   width="70%">
					</td>
					<td colspan="3" align="right"  width="20%">
					<strong>ภาษีทั้งหมด </strong> :
					</td>
					<td colspan="3" width="15%" align="right" style='mso-number-format:"\#\,\#\#0\.00"'>  <%=Money.money(vat_total)%> </td>
					<td colspan="2" width="15%" align="left">บาท</td>
				</tr>
				<tr>
					<td colspan="11"   width="70%">
					</td>
					<td colspan="3" align="right"  width="20%">
					<strong>ราคาไม่รวมภาษีทั้งหมด </strong> :
					</td>
					<td colspan="3" width="15%" align="right" style='mso-number-format:"\#\,\#\#0\.00"'>  <%=Money.money(Total_Price)%> </td>
					<td colspan="2" width="15%" align="left">บาท</td>
				</tr>
				
	</table>
</center>	
</body>
</html>
