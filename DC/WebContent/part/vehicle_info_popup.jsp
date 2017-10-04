<%@page import="com.bitmap.bean.sale.VehicleMaster"%>
<%@page import="com.bitmap.bean.sale.Vehicle"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<%
String vid = WebUtils.getReqString(request, "vid");
String master_id = WebUtils.getReqString(request, "master_id");

Vehicle ver = Vehicle.select(vid);
VehicleMaster vmaster = VehicleMaster.select(master_id);


%>

<div class="m_top15">
		<table cellpadding="3" cellspacing="3" border="0" class="center s_auto">
			<tbody>
				<%-- <tr>
					<td align="left" width="30%">Brand</td>
					<td width="70%">: <%=vmaster.getUIBrand() %> </td>
				</tr>
				<tr>
					<td align="left" width="30%">Name Plate</td>
					<td width="70%">: <%=vmaster.getNameplate() %></td>
				</tr> --%>
				<tr>
					<td align="left" width="30%">License Plate</td>
					<td width="70%">: <%=ver.getLicense_plate() %></td>
				</tr>
				<tr>
					<td>Engine NO.</td>
					<td>: <%=ver.getEngine_no() %></td>
				</tr>
				<tr>
					<td>VIN.</td>
					<td>: <%=ver.getVin() %></td>
				</tr>
				<tr>
					<td>Color</td>
					<td>: <%=ver.getColor() %></td>
				</tr>
				<tr>
					<td>Note</td>
					<td>: <%=ver.getNote() %></td>
				</tr>
				<tr align="center" valign="bottom" height="30">
					<td colspan="2">
						<input type="button" onclick="tb_remove();" value="Close" class="btn_box">
					</td>
				</tr>
			</tbody>
		</table>
</div>

