<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.bean.parts.ServiceSale"%>
<%@page import="com.bitmap.bean.parts.ServiceRepair"%>
<%@page import="com.bitmap.bean.sale.Models"%>
<%@page import="com.bitmap.bean.sale.Brands"%>
<%@page import="com.bitmap.bean.service.RepairLaborTime"%>
<%@page import="com.bitmap.bean.sale.VehicleMaster"%>
<%@page import="com.bitmap.bean.sale.Vehicle"%>
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

<script src="../js/jquery-1.4.2.min.js" type="text/javascript"></script>
<script type="text/javascript">
	function refreshPage(){
		setTimeout("window.location='ServiceAdvisorViewJob';",600000);
	}
</script>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Service Advisor: Job List</title>
<%
	PageControl ctrl = (PageControl) session.getAttribute("PAGE_CTRL");
	List list = new ArrayList();
	list = (List)session.getAttribute("JOB_LIST");
	Iterator ite = list.iterator();
%>
</head>
<body onload="$('div.wrap_all').fadeIn(800);refreshPage();">


<div class="wrap_all" style="display: none;">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Service Table :[ สถานะการซ่อม ]</div>
				<div class="right">
					<div class="btn_box right" title="Back" onclick="javascript: window.location='../index/index.jsp'">ย้อนกลับ</div> 
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="right"><%=PageControl.navigator_en(ctrl,"ServiceAdvisorViewJob")%> </div>
					<div class="clear"></div>
					
					<div class="box_body">
					<table class="bg-image s950">
						<thead>
							<tr>
								<th width="15%" align="center">รหัสใบแจ้งซ่อม</th>
								<th width="5%" align="center">ยี่ห้อ</th>
								<th width="20%" align="center">ทะเบียน</th>
								<th width="10%" align="center">สถานะ</th>
								<th width="45%" align="center">รายละเอียด</th>
								<th width="5%" align="center">&nbsp;</th>
							</tr>
						</thead>
						<tbody>
						<%
						boolean hasData = true;
						while(ite.hasNext()){ 
							hasData = false;
// 							RepairOrder entity = (RepairOrder) ite.next();
// 							Personal per = Personal.select(entity.getReceived_by());
// 							Vehicle vehicle = Vehicle.select(entity.getVehicle_id());
// 							VehicleMaster vmaster = VehicleMaster.select(vehicle.getMaster_id());
							
							ServiceRepair entity = (ServiceRepair) ite.next(); 					
							
							ServiceSale servicesale = ServiceSale.select(entity.getId());
							Vehicle vehicle = Vehicle.select(servicesale.getV_id());
 							VehicleMaster vmaster = VehicleMaster.select(vehicle.getMaster_id());
							Customer customer = Customer.select(vehicle.getCus_id()); 
							
							
							String status = entity.getFlag();
							String jobStatus = ServiceRepair.getUIStatusTH(entity);
							String link = "";
							if (status.equalsIgnoreCase(RepairLaborTime.STATUS_SA)) {
								link = "sa_job_repaired_list.jsp";
							} else
							if (status.equalsIgnoreCase(RepairLaborTime.STATUS_OPENED_JOB)) {
								link = "sa_job_repaired_list.jsp";
							} else 
							if (status.equalsIgnoreCase(RepairLaborTime.STATUS_ACTIVATE)) {
								link = "sa_job_active_repaired_list.jsp";
							} else 
							if (status.equalsIgnoreCase(RepairLaborTime.STATUS_QC)) {
								link = "sa_job_active_repaired_list.jsp";
							} else 
							if (status.equalsIgnoreCase(RepairLaborTime.STATUS_SUBMIT)) {
								link = "sa_qc_detail.jsp";
							} else 
							if (status.equalsIgnoreCase(RepairLaborTime.STATUS_REJECT)) {
								jobStatus = "ตรวจสอบคุณภาพไม่ผ่าน กำลังกลับไปแก้ไข";
								link = "sa_job_reject_repaired_list.jsp";
							} else 
							if (status.equalsIgnoreCase(RepairLaborTime.STATUS_HOLDPART)) {
								jobStatus = "กำลังรออะไหล่";
								link = "sa_job_active_repaired_list.jsp";
							} else 
							if (status.equalsIgnoreCase(RepairLaborTime.STATUS_HOLD_OUTSOURCE)) {
								jobStatus = "ส่งซ่อมอู่นอก";
							}
						%>
							<tr>
								<td align="center"><%=entity.getId() %></td>
								<td align="center" title="<%=Brands.getUIName(vmaster.getBrand())%> <%=Models.getUIName(vmaster.getModel())%>"><img alt="" src="../../images/motoshop/car_logo/40x27/<%=vmaster.getBrand()%>.gif"></td>
								<td><%=vehicle.getLicense_plate()%></td>
								<td align="center" title="<%=jobStatus%>"><img alt=""  src="../images/status/status_<%=entity.getFlag()%>.png" width="28px"></td>
								<td><%=jobStatus %></td>
								<td align="center"><button class="btn_view" onclick="javascript: window.location='<%=link%>?id=<%=entity.getId()%>&vid=<%=vehicle.getId()%>&cus_id=<%=customer.getCus_id()%>';"></button></td>
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

<jsp:include page="../index/footer.jsp"></jsp:include>
</body>
</html>