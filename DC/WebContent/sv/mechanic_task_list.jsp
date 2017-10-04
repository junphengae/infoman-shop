<%@page import="com.bitmap.bean.parts.ServiceSale"%>
<%@page import="com.bitmap.bean.parts.ServiceRepair"%>
<%@page import="com.bitmap.bean.sale.Models"%>
<%@page import="com.bitmap.bean.sale.Brands"%>
<%@page import="com.bitmap.bean.service.LaborTime"%>
<%@page import="com.bitmap.bean.sale.VehicleMaster"%>
<%@page import="com.bitmap.bean.customerService.RepairOrder"%>
<%@page import="com.bitmap.bean.sale.Vehicle"%>
<%@page import="com.bitmap.bean.service.RepairLaborMechanic"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css">
<link href="../css/unit.css" rel="stylesheet" type="text/css">
<link href="../css/table.css" rel="stylesheet" type="text/css">

<script src="../js/jquery-1.4.2.min.js" type="text/javascript"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Mechanic: Inbox Task</title>
<%
	List list = new ArrayList();
	list = RepairLaborMechanic.selectMyLabor(securProfile.getPersonal().getPer_id());
	Iterator ite = list.iterator();
%>
</head>
<body onload="$('div.wrap_all').fadeIn(800);">
<div class="wrap_all" style="display: none;">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Inbox Task</div>
				<div class="right">
					<div class="btn_box right" title="Back" onclick="javascript: window.location='../index/index.jsp'">ย้อนกลับ</div> 
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="right"> </div>
					<div class="clear"></div>
					
					<div class="box_body">
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th width="13%" align="center">รหัสใบแจ้งซ่อม</th>
								<th width="5%" align="center">ยี่ห้อ</th>
								<th width="12%" align="center">ทะเบียน</th>
								<th width="5%" align="center">สถานะ</th>
								<th width="60%" align="center">รายการซ่อม</th>
								<th width="5%" align="center">&nbsp;</th>
							</tr>
						</thead>
						<tbody>
						<%
						boolean hasData = true;
						while(ite.hasNext()){ 
							hasData = false;
							RepairLaborMechanic entity = (RepairLaborMechanic) ite.next();
							//RepairOrder repairOrder = RepairOrder.select(entity.getId());
							ServiceRepair servicerepair = ServiceRepair.select(entity.getId());
							
							ServiceSale servicesale = ServiceSale.select(entity.getId());
							Vehicle vehicle = Vehicle.select(servicesale.getV_id());
							VehicleMaster vmaster = VehicleMaster.select(vehicle.getMaster_id());
							LaborTime laborTime = LaborTime.select(entity.getLabor_id());
						%>
							<tr>
								<td align="center"><%=entity.getId() %></td>
								<td align="center" title="<%=Brands.getUIName(vmaster.getBrand())%> <%=Models.getUIName(vmaster.getModel())%>"><img alt="" src="../../images/motoshop/car_logo/40x27/<%=(vmaster.getBrand())%>.gif"></td>
								<td><%=vehicle.getLicense_plate()%></td>
								<td align="center" title="<%=entity.getStatus()%>"><img alt=""  src="../images/status/status_mac_<%=entity.getStatus()%>.png" width="22px"></td>
								<td><%=laborTime.getLabor_en() + " / " + laborTime.getLabor_th()%></td>
								<td><div class="btn_view" onclick="javascript: window.location='mechanic_task_detail.jsp?id=<%=entity.getId()%>&labor_id=<%=entity.getLabor_id()%>&number=<%=entity.getNumber()%>';"></div></td>
							</tr>
						<%
						} 
						if (hasData) {
						%>
						<tr><td colspan="6" align="center">- ไม่มีข้อมูล -</td></tr>
						<%} %>
						</tbody>
					</table>
					
					
					
				
				</div>
			
			</div>
			
		</div>
	</div>
	
		
</div>
	
		<div class="box txt_center s900 center m_top10">
							<img src="../images/status/status_mac_opened_job.png" width="17px"> = รอเปิดการซ่อม &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp; 
							<img src="../images/status/status_mac_active.png" width="17px"> = กำลังดำเนินการซ่อม &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp; 
							<img src="../images/status/status_mac_holdpart.png" width="17px" > = พักการซ่อม  &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp; 
							<img src="../images/status/status_mac_reject.png" width="17px" > = ไม่ผ่าน QC ต้องตรวจสอบและทำการซ่อมอีกครั้ง
					</div>

	
	<jsp:include page="../index/footer.jsp"></jsp:include>


</body>
</html>