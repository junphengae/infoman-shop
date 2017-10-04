<%@page import="com.bitmap.bean.parts.ServiceSale"%>
<%@page import="com.bitmap.bean.parts.ServiceRepair"%>
<%@page import="com.bitmap.bean.sale.Models"%>
<%@page import="com.bitmap.bean.sale.Brands"%>
<%@page import="com.bitmap.bean.sale.VehicleMaster"%>
<%@page import="com.bitmap.bean.sale.Vehicle"%>
<%@page import="com.bitmap.bean.service.LaborTime"%>
<%@page import="com.bitmap.bean.service.RepairLaborMechanic"%>
<%@page import="com.bitmap.bean.service.RepairLaborTime"%>
<%@page import="com.bitmap.bean.customerService.RepairOrder"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css">
<link href="../css/unit.css" rel="stylesheet" type="text/css">

<script src="../js/jquery-1.4.2.min.js"></script>
<script src="../js/jquery.validate.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Mechanic: Task Detail</title>
<%
	String id = WebUtils.getReqString(request,"id");
	String labor_id = WebUtils.getReqString(request,"labor_id");
	String number = WebUtils.getReqString(request,"number");

// 	RepairOrder repair_order = RepairOrder.select(id);
	ServiceRepair servicerepair =  ServiceRepair.select(id);
	RepairLaborTime labor = RepairLaborTime.selectById(id,labor_id,number);
	
	RepairLaborMechanic laborMec = RepairLaborMechanic.selectByMecId_LaborId(id,labor_id,securProfile.getPersonal().getPer_id(),number);
	LaborTime laborTime = LaborTime.select(laborMec.getLabor_id());
	
	ServiceSale servicesale = ServiceSale.select(servicerepair.getId());
	Vehicle vehicle = Vehicle.select(servicesale.getV_id());
	//Vehicle vehicle = Vehicle.select(repair_order.getVehicle_id());
	VehicleMaster vMaster = VehicleMaster.select(vehicle.getMaster_id());
%>
</head>
<body onload="$('div.wrap_all').fadeIn(800);">
	
	<div class="wrap_all" style="display: none;">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Inbox Task : [ Task Detail ]</div>
				<div class="right">
					<div class="btn_box right" title="Back" onclick="javascript: window.location='../index/index.jsp'">ย้อนกลับ</div> 
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="right"> <!-- *0* --> </div>
					<div class="clear"></div>
					
					<div class="box_body">
					
							
					<fieldset class="fset s750 center" id="customer_info">
						<legend>ข้อมูลรถ</legend>
						
						<div class="center s650 detail_box">
							<div>
								<div class="s150 left">ยี่ห้อ - รุ่น</div><div class="s10 left"> : </div>
								<div class="s400 left" id="brand"><%=Brands.getUIName(vMaster.getBrand())%>&nbsp;<%=Models.getUIName(vMaster.getModel())%>&nbsp;<%=vMaster.getNameplate()%></div>
								<div class="clear"></div>
							</div>
							<div id="vehicle_detail">
								<div>
									<div class="s150 left">ทะเบียนรถ</div><div class="s10 left"> : </div>
									<div class="s400 left" id="div_license_plate"><%=vehicle.getLicense_plate()%></div><div class="clear"></div>
								</div>
								<div>
									<div class="s150 left">หมายเลขเครื่องยนต์</div><div class="s10 left"> : </div>
									<div class="s400 left" id="div_engine_no"><%=vehicle.getEngine_no()%></div><div class="clear"></div>
								</div>
								<div>
									<div class="s150 left">หมายเลขตัวถัง</div><div class="s10 left"> : </div>
									<div class="s400 left" id="div_vin"><%=vehicle.getVin()%></div><div class="clear"></div>
								</div>
								<div>
									<div class="s150 left">สี</div><div class="s10 left"> : </div>
									<div class="s400 left" id="div_color"><%=vehicle.getColor()%></div><div class="clear"></div>
								</div>
							</div>
						</div>
						<div>
							<div class="s150 left">อาการเบื้องต้น</div><div class="s10 left"> : </div>
							<div class="s550 left"><%=servicerepair.getProblem().replaceAll("\n","<br>")%></div><div class="clear"></div>
						</div>
						<div>
							<div class="s150 left">Note/หมายเหตุ</div><div class="s10 left"> : </div>
							<div class="s550 left"><%=servicerepair.getNote().replaceAll("\n","<br>")%></div><div class="clear"></div>
						</div>
					</fieldset>
					
			
			
			<fieldset class="fset s750 center m_top10" id="customer_info">
			
				<legend>รายละเอียดการซ่อม</legend>
<!-- 				<div class="box_head m_top10 "> -->
<!-- 					รายละเอียดการซ่อม : -->
<!-- 				</div> -->
				
				<div class="box_body">
					
					<div>
						<div class="s150 left">รหัสใบแจ้งซ่อม</div><div class="s10 left"> : </div>
						<div class="s550 left"><%=laborMec.getId()%></div><div class="clear"></div>
					</div>
					<div>
						<div class="s150 left">รหัสการซ่อม</div><div class="s10 left"> : </div>
						<div class="s550 left"><%=laborMec.getLabor_id()%></div><div class="clear"></div>
					</div>
					<div>
						<div class="s150 left">รายละเอียดการซ่อม</div><div class="s10 left"> : </div>
						<div class="s550 left"><%=laborTime.getLabor_en() + " / " + laborTime.getLabor_th()%></div><div class="clear"></div>
					</div>
					
					<%
						String status = laborMec.getStatus();
						if (status.equalsIgnoreCase(RepairLaborTime.STATUS_REJECT)) {
					%>
					<div class="s700 dot_line" style="margin-top: 10px;"></div>
					<div style="color: red;">
						<div class="s150 left">หมายเหตุที่ไม่ผ่าน QC</div><div class="s10 left"> : </div>
						<div class="s550 left"><%=labor.getRemark()%></div><div class="clear"></div>
					</div>
					<%} %>
					<div class="txt_center" style="margin: 10px 0;">
					<%
				
						if (status.equalsIgnoreCase(RepairLaborTime.STATUS_OPENED_JOB)) {
							
							if (!RepairLaborMechanic.checkActive(securProfile.getPersonal().getPer_id())) {
					%>
						<input type="button" name="create" class="btn_box" value="เริ่มงาน" onclick="javascript: active();">
						<script type="text/javascript">
							function active(){
								if(confirm('คุณต้องการเริ่มงานนี้ใช่หรือไม่? เวลาการทำงานจะเริ่มทันทีเมื่อคุณตอบตกลง')) {
									window.location='MechanicTaskManage?action=active&id=<%=id%>&labor_id=<%=laborMec.getLabor_id()%>&update_by=<%=securProfile.getPersonal().getPer_id()%>&number=<%=number%>';
								}
							}
						</script>
					<%
							}
						} else 
						if (status.equalsIgnoreCase(RepairLaborTime.STATUS_ACTIVATE)) {
					%>
						<input type="button" name="hold" class="btn_box" value="พักงาน" onclick="javascript: hold();">
						<input type="button" name="close" class="btn_box" value="เสร็จงาน" onclick="javascript: closeJob();">
						<script type="text/javascript">
							function hold(){
								if(confirm('คุณต้องการพักงานนี้ใช่หรือไม่? เวลาการทำงานจะหยุดทันทีเมื่อคุณตอบตกลง')) {
									window.location='MechanicTaskManage?action=hold&id=<%=id%>&labor_id=<%=laborMec.getLabor_id()%>&update_by=<%=securProfile.getPersonal().getPer_id()%>&mechanic_id=<%=securProfile.getPersonal().getPer_id()%>&number=<%=number%>';
								}
							}
							
							function closeJob(){
								if(confirm('คุณได้ทำงานนี้เสร็จแล้วใช่หรือไม่?')) {
									window.location='MechanicTaskManage?action=close&id=<%=id%>&labor_id=<%=laborMec.getLabor_id()%>&update_by=<%=securProfile.getPersonal().getPer_id()%>&number=<%=number%>';
								}
							}
						</script>
					<%
						} else 
						if (status.equalsIgnoreCase(RepairLaborTime.STATUS_HOLDPART)) {
							if (!RepairLaborMechanic.checkActive(securProfile.getPersonal().getPer_id())) {
					%>
						<input type="button" name="unhold" class="btn_box" value="เริ่มทำงานต่อ" onclick="javascript: unhold();">
						<script type="text/javascript">
							function unhold(){
								if(confirm('คุณต้องการเริ่มงานนี้อีกครั้งใช่หรือไม่? เวลาพักการทำงานจะเริ่มเดินต่อทันทีเมื่อคุณตอบตกลง')) {
									window.location='MechanicTaskManage?action=unhold&id=<%=id%>&labor_id=<%=laborMec.getLabor_id()%>&update_by=<%=securProfile.getPersonal().getPer_id()%>&mechanic_id=<%=securProfile.getPersonal().getPer_id()%>&number=<%=number%>';
								}
							}
						</script>
					<%
							}
						}else
						if (status.equalsIgnoreCase(RepairLaborTime.STATUS_REJECT)) {
							%>
							<input type="button" name="create" class="btn_box" value="เริ่มงาน" onclick="javascript: active();">
							<script type="text/javascript">
								function active(){
									if(confirm('คุณต้องการเริ่มงานนี้ใช่หรือไม่? เวลาการทำงานจะเริ่มทันทีเมื่อคุณตอบตกลง')) {
										window.location='MechanicTaskManage?action=active&id=<%=id%>&labor_id=<%=laborMec.getLabor_id()%>&update_by=<%=securProfile.getPersonal().getPer_id()%>&number=<%=number%>';
									}
								}
							</script>
						<%
						}
					%>
					</div>
				</div>
				</fieldset>
				
				</div>
			</div>
			
		</div>
	</div>
				
</div>

	
	<jsp:include page="../index/footer.jsp"></jsp:include>



</body>
</html>