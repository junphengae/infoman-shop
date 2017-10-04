<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Customer Information</title>
<%
String cus_id = WebUtils.getReqString(request,"cus_id");
Customer customer = Customer.select(cus_id);
String cus_id_card = (customer.getCus_id_card().length() > 10)? customer.getCus_id_card().substring(0,customer.getCus_id_card().length() - 4) + "xxxx":"-";
%>
</head>
<body>
<div class="m_top10"></div>
<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="95%">
	<tbody>
		<tr>
			<td align="left" width="33%"><label>รหัสลูกค้า</label></td>
			<td align="left">: <%=customer.getCus_id()%></td>
		</tr>
		<tr>
			<td align="left"><label>รหัสบัตรประชาชน</label></td>
			<td align="left">: <%=cus_id_card%></td>
		</tr>
		<tr>
			<td align="left"><label>ชื่อ</label></td>
			<td align="left">: <%=customer.getCus_name_th() %> &nbsp;<%=customer.getCus_surname_th()%></td>
		</tr>
		<tr>
			<td align="left"><label>เพศ</label></td>
			<td align="left">: <%=(customer.getCus_sex().equalsIgnoreCase("m"))?"ชาย":"หญิง"%></td>
		</tr>
		<tr>
			<td align="left"><label>โทรศัพท์มือถือ</label></td>
			<td align="left">: <%=customer.getCus_mobile() %></td>
		</tr>
		<tr>
			<td align="left"><label>โทรศัพท์</label></td>
			<td align="left">: <%=customer.getCus_phone()%></td>
		</tr>
		<tr valign="top">
			<td align="left"><label>ที่อยู่</label></td>
			<td align="left">: <%=customer.getCus_address()%></td>
		</tr>
		<tr>
			<td align="left"><label>Email</label></td>
			<td align="left">: <%=customer.getCus_email() %></td>
		</tr>
		<tr>
			<td align="left"><label>วันเดือนปีเกิด</label></td>
			<td align="left">: <%=(customer.getCus_birthdate()!=null)?WebUtils.DATE_FORMAT_EN.format(customer.getCus_birthdate()):""%></td>
		</tr>
		
	</tbody>
</table>
</body>
</html>