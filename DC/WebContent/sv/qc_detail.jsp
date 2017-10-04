<%@page import="com.bitmap.bean.parts.ServiceRepair"%>
<%@page import="com.bitmap.bean.service.RepairLaborMechanic"%>
<%@page import="com.bitmap.bean.service.LaborTime"%>
<%@page import="com.bitmap.bean.service.RepairLaborTime"%>
<%@page import="com.bitmap.bean.sale.VehicleMaster"%>
<%@page import="com.bitmap.bean.sale.Vehicle"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
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
<link href="../css/basic.css" rel="stylesheet" type="text/css">
<link href="../css/loading.css" rel="stylesheet" type="text/css">

<script src="../js/jquery-1.4.2.min.js"></script>
<script src="../js/jquery.simplemodal.js"></script>
<script src="../js/thickbox.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Quality Control: QC Detail</title>
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
					<div class="btn_box right" title="Back" onclick="javascript: window.location='QualityControl'">ย้อนกลับ</div> 
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="right"></div>
					<div class="clear"></div>
					
				<table class="bg-image s970 center">
						<thead>
							<tr>
								<th width="80px" align="center">รหัส</th>
								<th width="500px" align="center">รายการ</th>
								<th width="90px" align="center">สถานะ</th>
								<th width="135px" align="center">ช่าง</th>
								<th width="110px" align="center">&nbsp;</th>
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
							<tr id="main_<%=laborTime.getLabor_id()%>_<%=repairLaborTime.getNumber()%>">
								
								<td align="center" id="labor_id"><%=laborTime.getLabor_id() %></td>
								<td id="labor_name"><%=laborTime.getLabor_en() %> / <%=laborTime.getLabor_th() %></td>
								<td align="center"><div id="status_show_<%=laborTime.getLabor_id()%>"><%=(repairLaborTime.getStatus().equalsIgnoreCase((RepairLaborTime.STATUS_CLOSED))?"เสร็จงาน":"")%><%=(repairLaborTime.getStatus().equalsIgnoreCase(RepairLaborTime.STATUS_REJECT)?"Reject":"") %><%=(repairLaborTime.getStatus().equalsIgnoreCase(RepairLaborTime.STATUS_SUBMIT)?"Submit":"") %></div><input type="hidden" id="remark_hidden_<%=laborTime.getLabor_id() %>" value="<%=repairLaborTime.getRemark()%>"></td>
								<td><%=mec_name%></td>
								<td align="center">
									<div class="btn_box txt_center" id="selectMechanic" onclick="openDialogMechanic('<%=laborTime.getLabor_id()%>');">ผลการตรวจสอบ</div>
									
									<div id="<%=laborTime.getLabor_id()%>" class="basic-modal-content">
										
										<div id="mec_list" class="s700 center" lang="<%=laborTime.getLabor_id()%>">
											<div style="margin: 4px;"><div class="s120 left">รหัสงาน</div><div class="s10 left">:</div><div class="s550 left"><%=laborTime.getLabor_id() %></div><div class="clear"></div></div>
											<div style="margin: 4px;"><div class="s120 left">รายละเอียดงาน</div><div class="s10 left">:</div><div class="s550 left"><%=laborTime.getLabor_en() %> / <%=laborTime.getLabor_th() %></div><div class="clear"></div></div>
											<div style="margin: 4px;"><div class="s120 left">สถานะ</div><div class="s10 left">:</div><div class="s550 left" id="status_<%=laborTime.getLabor_id() %>"></div><div class="clear"></div></div>
											<div style="margin: 4px;"><div class="s120 left">หมายเหตุ</div><div class="s10 left">:</div><div class="s550 left"><input type="text" class="txt_box s400" id="remark_<%=laborTime.getLabor_id() %>" value="<%=repairLaborTime.getRemark() %>"> <input type="button" value="เคลียร์ค่า" class="btn_box" onclick="$('#remark_<%=laborTime.getLabor_id() %>').val('');"></div><div class="clear"></div></div>
											
										</div>
										
										<div class="center s450 txt_center" style="margin-top: 15px;">
											<input type="button" value="ผ่านการตรวจสอบ" class="btn_box" labor_id="<%=laborTime.getLabor_id()%>" id="<%=id%>" number="<%=repairLaborTime.getNumber()%>" onclick="confirmSubmit(this)">
											<input type="button" value="ไม่ผ่านการตรวจสอบ" class="btn_box" labor_id="<%=laborTime.getLabor_id()%>" id="<%=id%>" number="<%=repairLaborTime.getNumber()%>" onclick="confirmReject(this)">
											<input type="button" value="ปิดหน้าจอ" class="simplemodal-close btn_box">
										</div>
										
										<div class="msg_error" id="msg_mec_error_<%=laborTime.getLabor_id()%>"></div>
										
									</div>
									
								</td>
							</tr>
							<%} %>
						</tbody>
					</table>
					
					<input type="hidden" id="update_by" value="<%=securProfile.getPersonal().getPer_id() %>">
				
			</div>
			<script type="text/javascript">
				var STATUS_SUBMIT = 'Submit';
				var STATUS_REJECT = 'Reject';
				var $update_by = $('#update_by').val();
				
				function openDialogMechanic(id){
					var $div = $('#' + id);
					var $statusShow = $('#status_show_' + id);
					var $status = $('#status_' + id);
					var $remark = $('#remark_' + id);
					var $remarkHidden = $('#remark_hidden_' + id);
					
					$remark.val($remarkHidden.val());
					$status.html($statusShow.html());
					$div.modal();
				}
				
				function confirmSubmit(obj){
					if (confirm('คุณต้องการยืนยันผลการตรวจคุณภาพ "ผ่าน" ใช่หรือไม่?')) {
						var $id = $(obj).attr('id');
						var $number = $(obj).attr('number');
						var $labor_id = $(obj).attr('labor_id');
						var $statusShow = $('#status_show_' + $labor_id);
						var $status = $('#status_' + $labor_id);
						var $remark = $('#remark_' + $labor_id);
						var $remarkHidden = $('#remark_hidden_' + $labor_id);
						
						$.post('QualityControl',{action:'submit',id:$id,number:$number,labor_id:$labor_id,update_by:$update_by,remark:$remark.val()}
							,function(resData){
								
							}
						,'json');
						
						$remarkHidden.val($remark.val());
						$statusShow.html(STATUS_SUBMIT);
						$.modal.impl.close();
					}
				}
				
				function confirmReject(obj){
					if (confirm('คุณต้องการ Reject งานนี้ เนื่องจาก "ไม่ผ่าน" ใช่หรือไม่?')) {
						var $id = $(obj).attr('id');
						var $number = $(obj).attr('number');
						var $labor_id = $(obj).attr('labor_id');
						var $statusShow = $('#status_show_' + $labor_id);
						var $status = $('#status_' + $labor_id);
						var $remark = $('#remark_' + $labor_id);
						var $remarkHidden = $('#remark_hidden_' + $labor_id);
						
						$.post('QualityControl',{action:'reject',id:$id,number:$number,labor_id:$labor_id,update_by:$update_by,remark:$remark.val()}
							,function(resData){
								
							}
						,'json');
						
						$remarkHidden.val($remark.val());
						$statusShow.html(STATUS_REJECT);
						$.modal.impl.close();
					}
				}
			</script>
		</div>
	</div>
	<!-- End Wrap Content -->	
							
							
							
				</div>


	<jsp:include page="../index/footer.jsp"></jsp:include>
</body>
</html>