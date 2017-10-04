<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.service.RepairLaborMechanic"%>
<%@page import="com.bitmap.bean.service.LaborTime"%>
<%@page import="com.bitmap.bean.sale.VehicleMaster"%>
<%@page import="com.bitmap.bean.sale.Vehicle"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.bean.service.RepairLaborTime"%>
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
<script src="../js/loading.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Service Advisor: Assign Mechanic</title>
<%
	String id = WebUtils.getReqString(request,"id");
	String vid = WebUtils.getReqString(request,"vid");
	String cus_id = WebUtils.getReqString(request,"cus_id");
	
	RepairOrder repair_order = RepairOrder.select(id);
	List laborTimeList = RepairLaborTime.selectIncludeMechanic(id);
	Customer customer = Customer.select(repair_order.getCus_id());
	Vehicle vehicle = Vehicle.select(repair_order.getVehicle_id());
	VehicleMaster vMaster = VehicleMaster.select(vehicle.getMaster_id());
%>
</head>
<body onload="$('div.wrap_all').fadeIn(800);">

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Assign Mechanic</div>
				<div class="right">
					<div class="btn_box right" title="Back" onclick="javascript: window.location='../index/index.jsp'">ย้อนกลับ</div> 
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="right m_top10"><!-- page --> </div>
					<div class="clear"></div>
					
					<div class="box_body">
					
					<table class="bg-image s970 center">
						<thead>
							<tr>
								<th width="80px" align="center">รหัส</th>
								<th width="450px" align="center">รายการ</th>
								<th width="60px" align="center">เวลา</th>
								<th width="60px" align="center">สถานะ</th>
								<th width="165px" align="center">ช่าง</th>
								<th width="100px" align="center">&nbsp;</th>
							</tr>
						</thead>
						<tbody>
							<%
								Iterator laborIte = laborTimeList.iterator();
								while(laborIte.hasNext()) {
									RepairLaborTime repairLaborTime = (RepairLaborTime) laborIte.next();
									LaborTime laborTime = LaborTime.select(repairLaborTime.getLabor_id());
									
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
											
										}
									}
							%>
							<tr id="main_<%=repairLaborTime.getLabor_id()%>_<%=repairLaborTime.getNumber()%>">
								
								<td align="center"><%=laborTime.getLabor_id() %></td>
								<td><%=laborTime.getLabor_en() %> / <%=laborTime.getLabor_th() %></td>
								<td align="center" id="labor_hour"><%=laborTime.getLabor_hour() %></td>
								<td align="center" id="labor_status"><%=repairLaborTime.getStatus() %></td>
								<td id="mechanic_field" lang="<%=mec_id%>"><%=mec_name%></td>
								<td align="center">
								<%if(!repairLaborTime.getStatus().equalsIgnoreCase(RepairLaborTime.STATUS_CLOSED)){ %>
									<button class="btn_box txt_center thickbox" id="selectMechanic" title="เลือกช่าง" lang="sa_assign_mechanic.jsp?width=850&height=440&modal=false&id=<%=id%>&labor_id=<%=repairLaborTime.getLabor_id()%>&number=<%=repairLaborTime.getNumber()%>">เลือกช่าง</button>
								<%}%>
								</td>
							</tr>
							<%} %>
						</tbody>
					</table>
					
				</div>
			</div>
			
		</div>
	</div>
				
</div>
	
	
	
	
<!-- 	<div class="wrap_content"> -->
	
<!-- 		<div class="content"> -->
			
<!-- 			<div class="box_wrap s1000"> -->
<!-- 				<div class="box_head"> -->
<%-- 					<div class="left txt_bold">เลขที่ใบแจ้งซ่อม: <%=repair_order.getId()%>  | <a class="thickbox btn_box" lang="../info/vehicle_info.jsp?width=400&height=250&vid=<%=vid%>" title="ข้อมูลรถ">ทะเบียนรถ: <%=vehicle.getLicense_plate()%></a> | <a class="thickbox btn_box" lang="../info/customer_info.jsp?width=400&height=250&cus_id=<%=cus_id%>" title="ข้อมูลลูกค้า">ข้อมูลลูกค้า: คุณ<%=customer.getCus_name_th()%></a></div> --%>
<%-- 					<div class="right btn_box" onclick="javascript: window.location='sa_job_repaired_list.jsp?id=<%=id%>&vid=<%=vid%>&cus_id=<%=cus_id%>';">ย้อนกลับ</div> --%>
<!-- 					<div class="clear"></div> -->
<!-- 				</div> -->
				
<!-- 				<div class="box_body"> -->
					
<!-- 					<div class="txt_center" style="margin: 5px 0 5px 0;"> -->
<!-- 						<input type="button" name="next" class="btn_box" value="ไปหน้า Control Board" onclick="javascript: window.location='ServiceAdvisorViewJob';"> -->
<!-- 					</div> -->
					
<!-- 				</div> -->
<!-- 			</div> -->
			<script type="text/javascript">
			function assign(){
				var $id = $('#assign_id').val();
				var $labor_id = $('#assign_labor').val();
				var $number = $('#assign_number').val();
				var $mechanic = $('#tbody input:checkbox:checked');
				
				var $selectMechanic = $('#main_' + $labor_id + '_' + $number).children('#mechanic_field');
				var $labor_hour = $('#main_' + $labor_id + '_' + $number).children('#labor_hour').text();
				var $divide = $('#div_divide').children('#divide').attr('checked');
				
				// Get Mechanic Data for checkbox
				var mec_id = '';
				var valMec = '';
				$.each($mechanic, function() {
					var arrayMec = $(this).val().split('_');
					valMec += arrayMec[1] + ',';
					mec_id += arrayMec[0] + '_';
				});
				
				// Verify Checkbox
				if (mec_id == '') {
					alert('กรุณาระบุช่าง!');
				} else {
					mec_id = mec_id.substring(0,mec_id.length - 1);
					ajax_load();
					var sendData = {action:'save_mechanic',id:$id,number:$number,labor_id:$labor_id,mec_id:mec_id,create_by:$('#create_by').val(),labor_hour:$labor_hour,divide:$divide};
					$.post('ServiceAdvisor',sendData
						,function(resData){
							ajax_remove();
							if (resData.status.indexOf('success') == -1) {
								alert('System Error! : ' + resData.message);
							} else {
								window.location.reload();/*
								$selectMechanic.attr({lang:mec_id,divide:$divide});
								$selectMechanic.html(valMec.substring(0,valMec.length - 1));
								tb_remove();*/
							}
						}
						,'json'
					);
					
				}
			}
			</script>
<!-- 		</div> -->
<!-- 	</div> -->

	
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
</body>
</html>