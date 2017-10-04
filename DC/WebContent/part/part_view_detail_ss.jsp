<%@page import="com.bitmap.bean.parts.PartCategories"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="snc" %>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Part Detail</title>
</head>

<%
String pn = WebUtils.getReqString(request, "pn");
PartMaster pm = new PartMaster();
pm.setPn(pn);
PartMaster.select(pm);
%>
<body>
<div class="wrap_body">
	<div class="body_content">
		<div class="content_body">
			<table cellpadding="3" cellspacing="3" border="0" class="s400 center">
				<tbody>
					<tr>
						<td width="35%"><label>Parts Number</label></td>
						<td align="left">: <%=pm.getPn()%></td>
					</tr>
					<tr>
						<td><label>Description</label></td>
						<td align="left">: <%=pm.getDescription()%></td>
					</tr>
					<tr>
						<td><label>Fit to</label></td>
						<td align="left">: <%=pm.getFit_to()%></td>
					</tr>
					<tr>
						<td><label>Category</label></td>
						<td align="left">: <%=PartCategories.SelectCat_name(pm.getCat_id(),pm.getGroup_id())%></td>
					</tr>
					<tr>
						<td><label>Price</label></td>
						<td align="left">: <%=pm.getPrice()%> <%=PartMaster.unit(pm.getPrice_unit())%></td>
					</tr>
					<tr>
						<td><label>Cost</label></td>
						<td align="left">: <%=pm.getCost()%> <%=PartMaster.unit(pm.getCost_unit())%></td>
					</tr>
					<tr>
						<td><label>MOQ</label></td>
						<td align="left">: <%=pm.getMoq()%></td>
					</tr>
					<tr>
						<td><label>MOR</label></td>
						<td align="left">: <%=pm.getMor()%></td>
					</tr>
					<tr>
						<td><label>Weight</label></td>
						<td align="left">: <%=pm.getWeight()%></td>
					</tr>
					<tr>
						<td><label>Location</label></td>
						<td align="left">: <%=pm.getLocation()%></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>
</html>