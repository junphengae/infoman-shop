<%@page import="com.bitmap.bean.sale.VehicleMaster"%>
<%@page import="com.bitmap.bean.sale.Vehicle"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.sale.Models"%>
<%@page import="com.bitmap.bean.sale.Brands"%>


<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Customer Information</title>
<%
String vid = WebUtils.getReqString(request,"vid");
Vehicle vehicle = Vehicle.select(vid);
VehicleMaster vMaster = VehicleMaster.select(vehicle.getMaster_id());
%>
</head>
<body>
<div class="m_top10"></div>
<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="95%">
	<tbody>
		<tr>
			<td align="left" width="33%"><label>ยี่ห้อ - รุ่น</label></td>
			<td align="left">: <%=Brands.getUIName(vMaster.getBrand())%>&nbsp;<%=Models.getUIName(vMaster.getModel())%>&nbsp;<%=vMaster.getNameplate()%></td>
		</tr>
		<tr>
			<td align="left">ทะเบียนรถ</td>
			<td align="left">: <%=vehicle.getLicense_plate()%></td>
		</tr>
		<tr>
			<td align="left">หมายเลขเครื่องยนต์</td>
			<td align="left">: <%=vehicle.getEngine_no()%></td>
		</tr>
		<tr>
			<td align="left">หมายเลขตัวถัง</td>
			<td align="left">: <%=vehicle.getVin()%></td>
		</tr>
		<tr>
			<td align="left">สี</td>
			<td align="left">: <%=vehicle.getColor()%></td>
		</tr>
		
	</tbody>
</table>
</body>
</html>