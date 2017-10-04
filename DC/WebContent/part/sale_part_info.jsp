<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.ServicePartDetail"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="com.bitmap.bean.parts.ServiceSale"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.hr.Division"%>
<%@page import="com.bitmap.bean.hr.Position"%>
<%@page import="com.bitmap.bean.hr.Department"%>
<%@page import="com.bitmap.security.SecurityUser"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/clear_form.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/popup.js"></script>
<script src="../js/number.js"></script>
<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.position.js"></script>
<script src="../js/ui/jquery.ui.autocomplete.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Sale Parts</title>
<%
	ServiceSale entity = new ServiceSale();
WebUtils.bindReqToEntity(entity, request);
ServiceSale.select(entity);

List list = entity.getUIListDetail();
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Order ID: <%=entity.getId()%></div>
				<div class="right">
					<button class="btn_box" onclick="window.location='<%=LinkControl.link("sale_part.jsp", (List)session.getAttribute("SALE_SEARCH"))%>';">Back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<form id="sale_part_form" onsubmit="return false;">
				<fieldset class="fset">
					<legend>Parts Sale Order</legend>
						<div class="left s400">
							<table class="s_auto">
								<tbody>
									<tr>
										<td width="30%">Order ID</td>
										<td width="70%">: <%=entity.getId()%></td>
									</tr>
									<tr>
										<td>Customer Name</td>
										<td>: <%=entity.getCus_name()%></td>
									</tr>
								</tbody>
							</table>
						</div>
						
						<div class="right s400">
							<table class="s_auto">
								<tbody>
									<tr>
										<td width="30%">Order Date</td>
										<td width="70%">: <%=WebUtils.getDateTimeValue(entity.getCreate_date())%></td>
									</tr>
									<tr>
										<td></td>
										<td></td>
									</tr>
								</tbody>
							</table>
						</div>
					
						<div class="clear"></div>
				</fieldset>
				
				<fieldset class="fset">
					<legend>Parts List</legend>
					<table class="bg-image s_auto">
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
						<tbody>
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
								<td align="right"><%=detail.getDiscount()%> %</td>
								<td align="right"><%=Money.money(disc) %></td>
								<td align="right"><%=Money.money(total_price) %></td>
							</tr>
						<%
							}
						%>
						</tbody>
						<tfoot>
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
						</tfoot>
					</table>
					<table class="s_auto">
						<tbody>
							<tr>
								<td colspan="2" height="10"><div class="dot_line"></div></td>
							</tr>
							<tr>
								<td colspan="2" height="10" align="center">
									<button type="button" class="btn_box" onclick="window.open('sale_part_print.jsp?id=<%=entity.getId()%>','part','location=0,toolbar=0,menubar=0,width=800,height=500').focus();">Print</button>
								</td>
							</tr>
						</tbody>
					</table>
				</fieldset>
				</form>
				<div class="clear"></div>
					
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>