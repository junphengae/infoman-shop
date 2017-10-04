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


	List<servicePartDetailBean> list = null;
	list =  jobTS.list_PartGoodSale();

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
<title>รายงานสินค้าขายดี</title>
<body>
	<center>
	<div class="content_head"  >
			<Strong>รายงานสินค้าขายดี</Strong>
			<br/>
	</div>
	<table class="tb" style="width: 100%;">
		<tbody>
			<tr align="center" >
				<th valign="middle" align="center" rowspan="2" width="12%">PN</th>
				<th valign="middle" align="center" rowspan="2" width="37%">Description</th>
				<th valign="middle" align="center" rowspan="2" width="5%">Units</th>
				<th valign="middle" align="center" rowspan="2" width="5%">QTY</th>				
				<th valign="middle" align="center" rowspan="2" width="8%">Unit Price(฿)</th>
				<th valign="middle" align="center" rowspan="2" width="8%">Total Vat(฿)</th>
				<th valign="middle" align="center" rowspan="2" width="8%">Total Discount(฿)</th>
				<th valign="middle" align="center" rowspan="2" width="8%">Total Amount(฿)</th>
				<th valign="top" align="center" colspan="2" width="16%">Date</th>
			</tr>
			<tr align="center" >
				<th valign="top" align="center">Newest</th>
				<th valign="top" align="center">Oldest</th>
			</tr>
			<%
			Iterator<servicePartDetailBean> ite = list.iterator();
			int total = list.size();
			String date_null = "-";
			String net_price = "0";
			
			Double total_price = 0.00;
			Double total_Discount = 0.00;
			Double total_Vat = 0.00;
			if( ! list.isEmpty() ){
				while(ite.hasNext()){
					servicePartDetailBean entity = (servicePartDetailBean) ite.next();					
					if(!entity.getSum_net_price().equalsIgnoreCase("")){						
						total_Discount 	+= Double.parseDouble(Money.removeCommas( Money.money(entity.getSum_spd_dis_total())	));	
						total_Vat 		+= Double.parseDouble(Money.removeCommas( Money.money(entity.getSum_spd_vat_total())	));
						total_price 	+= Double.parseDouble(Money.removeCommas( Money.money(entity.getSum_net_price())	));
					}
					
					
			
			%>
			<tr align="center">
				<td style='mso-number-format:"\@"' align="left" valign="top"><%=entity.getPn()%></td>
				<td style='mso-number-format:"\@"' align="left" valign="top"><%=entity.getDescription()%></td>
				<td style='mso-number-format:"\@"' align="left" valign="top"><%=entity.getType_name()%></td>
				<td style='mso-number-format:"0"'  align="right" valign="top"><%=Money.moneyInteger(entity.getSum_qty())%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right" valign="top"><%=(entity.getUnit_price().length()>0 && !(entity.getUnit_price().equalsIgnoreCase("0")|| entity.getUnit_price().equalsIgnoreCase("0.00")))?Money.money(entity.getUnit_price())+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right" valign="top"><%=(entity.getSum_spd_vat_total().length()>0 && !(entity.getSum_spd_vat_total().equalsIgnoreCase("0")|| entity.getSum_spd_vat_total().equalsIgnoreCase("0.00")))?Money.money(entity.getSum_spd_vat_total())+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right" valign="top"><%=(entity.getSum_spd_dis_total().length()>0 && !(entity.getSum_spd_dis_total().equalsIgnoreCase("0")|| entity.getSum_spd_dis_total().equalsIgnoreCase("0.00")))?Money.money(entity.getSum_spd_dis_total())+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right" valign="top"><%=(entity.getSum_net_price().length()>0 && !(entity.getSum_net_price().equalsIgnoreCase("0")|| entity.getSum_net_price().equalsIgnoreCase("0.00")))?Money.money(entity.getSum_net_price())+"":"0.00"%></td>
				<td style='mso-number-format:"Short Date"'  align="center" valign="top"><%if( entity.getDate_sale_max() == null ){%>-<%}else{ %><%=WebUtils.getDateValue( entity.getDate_sale_max() ) %><%} %></td>
				<td style='mso-number-format:"Short Date"'  align="center" valign="top"><%if( entity.getDate_sale_min() == null ){%>-<%}else{ %><%=WebUtils.getDateValue( entity.getDate_sale_min() ) %><%} %></td>
			</tr>
			<%
				}
			}else{
				%>
				<tr>
					<td align="center" colspan="8">
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
					<td width="15%" align="right" style='mso-number-format:"0"'> <%=Money.moneyInteger(total)%> </td>
					<td width="15%" align="left"> รายการ</td>
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
					<td width="70%">
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
					<td width="15%" align="right" style='mso-number-format:"0\.00"'> <%=Money.money(String.valueOf(total_price))%> </td>
					<td width="15%" align="left"> บาท</td>
				</tr>
	</table>
</center>	
		
</body>
</html>
