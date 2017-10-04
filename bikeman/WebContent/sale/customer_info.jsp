<%@page import="com.bitmap.bean.sale.Models"%>
<%@page import="com.bitmap.bean.sale.Brands"%>
<%@page import="com.bitmap.bean.sale.VehicleMaster"%>
<%@page import="com.bitmap.bean.sale.Vehicle"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

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
Customer entity = new Customer();
WebUtils.bindReqToEntity(entity, request);
Customer.select(entity);
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Customer Information: <%=entity.getCus_name_th() + " " + entity.getCus_surname_th()%></title>

</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Customer ID: <%=entity.getCus_id() %></div>
				<div class="right">
					<button class="btn_box" onclick="window.location='<%=LinkControl.link("customer_manage.jsp", (List)session.getAttribute("CUS_SEARCH"))%>';">Back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				
				<fieldset class="fset s350 left min_h300">
					<legend>Information</legend>
					
					<table class="s_auto" cellspacing="5" cellpadding="5">
						<tbody>
							<tr>
								<td width="40%"><label>ID CARD</label></td>
								<td width="60%">: <%=entity.getCus_id_card()%></td>
							</tr>
							<tr>
								<td><label>Name</label></td>
								<td>: <%=entity.getCus_name_th()%></td>
							</tr>
							<tr>
								<td><label>Surname</label></td>
								<td>: <%=entity.getCus_surname_th()%></td>
							</tr>
							<tr>
								<td><label>Sex</label></td>
								<td>: <%=(entity.getCus_sex().equalsIgnoreCase("m"))?"Male":"Female"%></td>
							</tr>
							<tr>
								<td><label>Address</label></td>
								<td>: <%=entity.getCus_address()%></td>
							</tr>
							<tr>
								<td><label>Mobile</label></td>
								<td>: <%=entity.getCus_mobile()%></td>
							</tr>
							<tr>
								<td><label>Phone</label></td>
								<td>: <%=entity.getCus_phone()%></td>
							</tr>
							<tr>
								<td><label>Email</label></td>
								<td>: <%=entity.getCus_email()%></td>
							</tr>
							<tr>
								<td><label>Birthdate</label></td>
								<td>: <%=WebUtils.getDateValue(entity.getCus_birthdate())%></td>
							</tr>
							<tr>
								<td colspan="2" height="30" align="center" valign="bottom">
									<button type="button" class="btn_box thickbox" title="Update Customer Information"  lang="customer_edit.jsp?cus_id=<%=entity.getCus_id()%>">Update</button>
								</td>
							</tr>
						</tbody>
					</table>
					
				</fieldset>
				
				<fieldset class="fset s550 right min_h300">
					<legend>Vehicle List</legend>
					<table class="bg-image s_auto" style="margin-top: 10px;">
						<thead>
							<tr>
								<th align="center" width="10%">Brand</th>
								<th align="center" width="30%">Model</th>
								<th align="center" width="40%">Plate</th>
								<th align="center" width="15%">&nbsp;</th>
							</tr>
						</thead>
						<tbody>
							<%
							boolean hasVehicle = true;
							Iterator iteVehicle = Vehicle.selectByCusID(entity.getCus_id()).iterator();
							while (iteVehicle.hasNext()) {
								hasVehicle = false;
								Vehicle vehicle = (Vehicle) iteVehicle.next();
								VehicleMaster vmaster = vehicle.getUIMaster();
							%>
							<tr>
								<td align="center"><img src="../../images/motoshop/car_logo/40x27/<%=vmaster.getBrand()%>.gif"></td>
								<td><%=vmaster.getUIModel() %> <%=vmaster.getNameplate()%></td>
								<td><%=vehicle.getLicense_plate()%></td>
								<td align="center">
									<a class="btn_view thickbox" title="Vehicle Information" lang="vehicle_info_popup.jsp?vid=<%=vehicle.getId()%>"></a>
									<a class="btn_update thickbox" title="Update Vehicle Information" lang="vehicle_edit.jsp?vid=<%=vehicle.getId()%>&cus_id=<%=entity.getCus_id()%>"></a>
								</td>
							</tr>
								
							<%
							} 
							if (hasVehicle) {
							%>
							<tr><td align="center" colspan="5">- ไม่มีข้อมูล -</td></tr>
							<%} %>
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