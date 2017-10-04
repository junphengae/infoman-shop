<%@page import="com.bitmap.bean.service.RepairLaborMechanic"%>
<%@page import="com.bitmap.bean.service.LaborTime"%>
<%@page import="com.bitmap.bean.sale.VehicleMaster"%>
<%@page import="com.bitmap.bean.sale.Vehicle"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.bean.service.RepairLaborTime"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.customerService.RepairOrder"%>
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
<link href="../css/loading.css" rel="stylesheet" type="text/css">

<script src="../js/jquery-1.4.2.min.js"></script>
<script src="../js/thickbox.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Service Advisor: QC Detail</title>
<%
	String id = WebUtils.getReqString(request,"id");
	String vid = WebUtils.getReqString(request,"vid");
	String cus_id = WebUtils.getReqString(request,"cus_id");

	RepairOrder repair_order = RepairOrder.select(id);
	List laborTimeList = RepairLaborTime.selectIncludeMechanic(id);
	Personal per = Personal.select(repair_order.getReceived_by());
	Customer customer = Customer.select(repair_order.getCus_id());
	Vehicle vehicle = Vehicle.select(repair_order.getVehicle_id());
	VehicleMaster vMaster = VehicleMaster.select(vehicle.getMaster_id());
%>
</head>
<body onload="$('div.wrap_all').fadeIn(800);">


<div class="wrap_all" style="display: none;">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">เลขที่ใบแจ้งซ่อม: <%=repair_order.getId()%>  | <a class="thickbox btn_box" lang="../info/vehicle_info.jsp?width=400&height=250&vid=<%=vid%>" title="ข้อมูลรถ">ทะเบียนรถ: <%=vehicle.getLicense_plate()%></a> | <a class="thickbox btn_box" lang="../info/customer_info.jsp?width=400&height=250&cus_id=<%=cus_id%>" title="ข้อมูลลูกค้า">ข้อมูลลูกค้า: คุณ<%=customer.getCus_name_th()%></a></div>
				<div class="right">
					<div class="btn_box right" title="Back" onclick="javascript: window.location='ServiceAdvisorViewJob'">ย้อนกลับ</div> 
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="right"></div>
					<div class="clear"></div>
					
					<div class="box_body">
					
					<table class="bg-image s970 center">
						<thead>
							<tr>
								<th width="80px" align="center">รหัส</th>
								<th width="500px" align="center">รายการ</th>
								<th width="60px" align="center">เวลา</th>
								<th width="50px" align="center">สถานะ</th>
								<th width="165px" align="center">ช่าง</th>
							</tr>
						</thead>
						<tbody>
							<%
								Iterator laborIte = laborTimeList.iterator();
								while(laborIte.hasNext()) {
									RepairLaborTime repairLaborTime = (RepairLaborTime) laborIte.next();
									LaborTime laborTime = LaborTime.select(repairLaborTime.getLabor_id());
									
									String divide = "false";
									String mec_id = "";
									String mec_name = "";
									String mec_hour = "0.0";
									Iterator mechanicIte = repairLaborTime.getUIMechanicList().iterator();
									while (mechanicIte.hasNext()){
										RepairLaborMechanic mechanic = (RepairLaborMechanic)mechanicIte.next();
										mec_id += mechanic.getMechanic_id() + "_";
										mec_name += Personal.selectOnlyPerson(mechanic.getMechanic_id()).getName() + ",";
										mec_hour = mechanic.getLabor_hour();
									}
									
									if (mec_id.length() > 0){
										mec_id = mec_id.substring(0,mec_id.length() - 1);
										mec_name = mec_name.substring(0,mec_name.length() - 1);
										if (!mec_hour.equalsIgnoreCase(laborTime.getLabor_hour())) {
											divide = "true";
										}
									}
							%>
							<tr id="main_<%=laborTime.getLabor_id() %>">
								<td align="center" id="labor_id"><%=laborTime.getLabor_id() %></td>
								<td id="labor_name"><%=laborTime.getLabor_en() %> / <%=laborTime.getLabor_th() %></td>
								<td align="center"><%=laborTime.getLabor_hour() %></td>
								<td align="center"><div id="status_show_<%=laborTime.getLabor_id()%>"><%=RepairLaborTime.getthstatus(repairLaborTime.getStatus()) %></div><input type="hidden" id="remark_hidden_<%=laborTime.getLabor_id() %>" value="<%=repairLaborTime.getRemark()%>"></td>
								<td><%=mec_name%></td>
							</tr>
							<%} %>
						</tbody>
					</table>
					
				</div>
			</div>
			
		</div>
	</div>
				
</div>





	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
</body>
</html>