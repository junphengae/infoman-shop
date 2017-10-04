<%@page import="com.bitmap.utils.SNCUtils"%>
<%@page import="com.bitmap.barcode.Barcode128"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.ServicePartDetail"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.parts.ServiceSale"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css">
<link href="../css/unit.css" rel="stylesheet" type="text/css">
<link href="../css/theme_print.css" rel="stylesheet" type="text/css">

<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/jquery.metadata.js" type="text/javascript"></script>
<script src="../js/jquery.validate.js" type="text/javascript"></script>
<script src="../js/thickbox.js" type="text/javascript"></script>
<script src="../js/loading.js" type="text/javascript"></script>
<script src="../js/number.js" type="text/javascript"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
	ServiceSale entity = new ServiceSale();
WebUtils.bindReqToEntity(entity, request);
ServiceSale.select(entity);

Barcode128.genBarcode(WebUtils.getInitParameter(session, SNCUtils.IMG_PATH_BARCODE), entity.getId());

List list = entity.getUIListDetail();
%>
<title>Invoice : <%=entity.getId()%></title>
<style type="text/css">
.tb{border-collapse: collapse;}
.tb tr, .tb td, .tb th{border: .5pt solid #000;border-top: .5pt solid #000; border-bottom: .5pt solid #000;}

.tb tfoot td
{
	border: none;
}

.bb{border: 1px solid #000;}
</style>
<script type="text/javascript">
$(function(){
	setTimeout('window.print()',500); 
	setTimeout('window.close()',1000);
});
</script>
</head>
<body style="background-color: #fff; color: #000;">

<div class="wrap_print">
	
	<div class="head_info">
		<div class="head_logo">
			<img src="../images/showroom/logo.png" width="130" height="80">
		</div>
		<div class="head_address">
			<p>บริษัท ศรณรงค์ คาร์ จำกัด</p>
			<p>16/13 ม.2 ถ.แจ้งวัฒนะ ต.คลองเกลือ อ.ปากเกร็ด จ.นนทบุรี 11120</p>
			<p>โทร. 0-2980-8655-6  แฟกซ์ กด 111  www.sncshowroom.com</p>
		</div>
		<div class="clear"></div>
	</div>

	<div class="bb right txt_center">
		<div class="txt_bold txt_18 m_left5 m_right5 m_top5">เลขที่ใบแจ้งหนี้</div>
		<div class="center txt_center"><img src="../../images/motoshop/barcode/<%=entity.getId()%>.png"></div>
	</div>
	<div class="clear"></div>
	
	<div>
		<div class="left s250">
			Customer: <%=entity.getCus_name()%>
		</div>
		
		<div class="left">
			Date/Time : <%=WebUtils.getDateTimeValue(entity.getCreate_date())%>
		</div>
		
		<div class="clear"></div>
	</div>
	
	<div class="s_auto m_top5">
		<table class="tb s_auto">
			<thead>
				<tr>
					<th valign="top" align="center" width="15%">Code</th>
					<th valign="top" align="center" width="20%">Description</th>
					<th valign="top" align="center" width="5%">Qty</th>
					<th valign="top" align="center" width="12%">Unit Price</th>
					<th valign="top" align="center" width="15%">Net Price</th>
					<th valign="top" align="center" width="10%">Disct(%)</th>
					<th valign="top" align="center" width="10%">Total Disct</th>
					<th valign="top" align="center" width="18%">Total Price</th>
				</tr>
			</thead>
			<%
				String total = "0";
					String total_net_price = "0";
					String total_discount = "0";
					
					Iterator ite = list.iterator();
					while(ite.hasNext()) {
						ServicePartDetail detail = (ServicePartDetail) ite.next();
						String net_price = "0";
						String total_price = "0";
						String disc = "0";
						
						net_price = Money.multiple(detail.getQty(), detail.getPrice());
						total_price = Money.discount(net_price, detail.getDiscount());
						disc = Money.subtract(net_price, total_price);
						
						total_net_price = Money.add(total_net_price, net_price);
						total_discount = Money.add(total_discount, disc);
						total = Money.add(total, total_price);
			%>
				<tr>
					<td><%=detail.getPn() %></td>
					<td><%=detail.getUIDescription() %></td>
					<td align="right"><%=detail.getQty()%></td>
					<td align="right"><%=Money.money(detail.getPrice()) %></td>
					<td align="right"><%=Money.money(net_price) %></td>
					<td align="right"><%=detail.getDiscount()%></td>
					<td align="right"><%=Money.money(disc) %></td>
					<td align="right"><%=Money.money(total_price) %></td>
				</tr>
			<%
				}
			%>
			</tbody>
		</table>
		
		<table>
			<tbody>
				<tr>
					<td width="15%"></td>
					<td width="20%"></td>
					<td width="5%"></td>
					<td width="12%"></td>
					<td width="15%"></td>
					<td width="10%"></td>
					<td width="10%"></td>
					<td width="18%"></td>
				</tr>
				<tr>
					<td colspan="8" height="20"></td>
				</tr>
				<tr>
					<td colspan="5"></td>
					<td colspan="1" align="left">Before Disct.</td>
					<td align="right" colspan="2"><%=Money.money(total_net_price)%></td>
				</tr>
				<tr>
					<td colspan="5"></td>
					<td colspan="1" align="left">Discount</td>
					<td align="right" colspan="2"><%=Money.money(total_discount)%></td>
				</tr>
				<tr>
					<td colspan="5"></td>
					<td colspan="1" align="left">Net</td>
					<td align="right" colspan="2"><%=Money.money(total)%></td>
				</tr>
				<tr>
					<td colspan="5"></td>
					<td colspan="1" align="left">V.A.T. <%=(entity.getVat().equalsIgnoreCase("7"))?"7":"0"%> %</td>
					<td align="right" colspan="2"><span id="show_vat"><%=(entity.getVat().equalsIgnoreCase("7"))?Money.money(Money.vat(total)):"0.00"%></span></td>
				</tr>
				<tr class="txt_bold">
					<td colspan="5"></td>
					<td colspan="2" align="left">Total Amount</td>
					<td align="right" colspan="1">
						<span id="total_amount"><%=(entity.getVat().equalsIgnoreCase("7"))?Money.money(Money.add(total, Money.vat(total))): Money.money(total)%></span>
						<input type="hidden" name="total" id="total" value="<%=(entity.getVat().equalsIgnoreCase("7"))?Money.money(Money.add(total, Money.vat(total))): Money.money(total)%>">
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="dot_line"></div>
	
	<div class="s_auto m_top10">
		<table class="tb s_auto">
			<tbody>
				<tr>
					<td width="25%" align="center">
						<br>
						<br>
						<br>
						.....................................................<br>
						Delivery By
					</td>
					<td width="25%" align="center">
						<br>
						<br>
						.....................................................<br>
						Customer Signature<br>
						Date ........../........../..........
					</td>
					<td width="25%" align="center">
						<br>
						<br>
						.....................................................<br>
						Cashier<br>
						Date ........../........../..........
					</td>
					<td width="25%" align="center">
						<br>
						<br>
						<br>
						.....................................................<br>
						Manager
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	
</div>
</body>
</html>