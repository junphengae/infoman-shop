<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.sale.VehicleMaster"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Brochure Information:</title>


<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="../js/jquery.metadata.js"></script>
<script type="text/javascript" src="../js/jquery.validate.js"></script>
 
 
<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">
 
 <%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
 
<%
VehicleMaster entity = new VehicleMaster();
WebUtils.bindReqToEntity(entity, request);
VehicleMaster.select(entity);
%>
 
</head>
<body>
<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Information: <%=entity.getBrand() %> <%=entity.getModel() %></div>
				<div class="right">
					<button class="btn_box" onclick="window.location='<%=LinkControl.link("vehicle_spec_manage.jsp", (List)session.getAttribute("BROCH_SEARCH"))%>';">Back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<fieldset class="fset s550 center">
					<legend>Information</legend>
					<table class="s_auto" cellspacing="5" cellpadding="5">
						<tbody>
							<tr>
								<td width="30%"><label>Brand</label></td>
								<td width="70%">:<img src="../../images/motoshop/car_logo/40x27/<%=entity.getBrand()%>.gif"> </td>
							</tr>
							
							<tr>
								<td><label>Model</label></td>
								<td>: <%=entity.getUIModel()%></td>
							</tr>
							<tr>
								<td><label>Name Plate</label></td>
								<td>: <%=entity.getNameplate()%></td>
							</tr>
							<tr>
								<td><label>Year</label></td>
								<td>: <%=entity.getYear()%></td>
							</tr>
							<tr>
								<td><label>Engine</label></td>
								<td>: <%=entity.getEngine()%></td>
							</tr>
							<tr>
								<td><label>CC.</label></td>
								<td>: <%=entity.getEngine_cc()%></td>
							</tr>
							<tr>
								<td><label>Horse Power</label></td>
								<td>: <%=entity.getHorsepower()%></td>
							</tr>
							<tr>
								<td><label>Torque</label></td>
								<td>: <%=entity.getTorque()%></td>
							</tr>
							<tr>
								<td><label>Transmission</label></td>
								<td>: <%=entity.getTransmission()%></td>
							</tr>
							<tr>
								<td><label>Brake [Front]</label></td>
								<td>: <%=entity.getBrake_front()%></td>
							</tr>
							<tr>
								<td><label>Brake [Rear]</label></td>
								<td>: <%=entity.getBrake_rear()%></td>
							</tr>
							<tr>
								<td><label>Length</label></td>
								<td>: <%=entity.getD_length()%></td>
							</tr>
							<tr>
								<td><label>Width</label></td>
								<td>: <%=entity.getD_width()%></td>
							</tr>
							<tr>
								<td><label>Height</label></td>
								<td>: <%=entity.getD_height()%></td>
							</tr>
							<tr>
								<td><label>Wheel Base</label></td>
								<td>: <%=entity.getD_wheelbase()%></td>
							</tr>
							<tr>
								<td><label>Note</label></td>
								<td>: <%=entity.getNote()%></td>
							</tr>
							<tr>
								<td colspan="2" height="30" align="center" valign="bottom">
									<button type="button" class="btn_box"  onclick="javascript: window.location = 'spec_edit.jsp?id=<%=entity.getId()%>';">Edit</button>
								</td>
							</tr>
						</tbody>
					</table>
				</fieldset>
				<div class="clear"></div>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>

</div>



</body>
</html>