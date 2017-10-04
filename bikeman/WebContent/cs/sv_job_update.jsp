<%@page import="com.bitmap.bean.service.RepairLaborTime"%>
<%@page import="com.bitmap.bean.sale.Vehicle"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.bean.parts.ServiceRepairCondition"%>
<%@page import="com.bitmap.bean.parts.ServiceRepair"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.ServicePartDetail"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="com.bitmap.bean.parts.ServiceSale"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.security.SecurityUser"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/clear_form.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/popup.js"></script>
<script src="../js/number.js"></script>
<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.datepicker.js"></script>
<script src="../js/ui/jquery.ui.button.js"></script>
<script src="../js/ui/jquery.ui.position.js"></script>
<script src="../js/ui/jquery.ui.autocomplete.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%
ServiceSale entity = new ServiceSale();
WebUtils.bindReqToEntity(entity, request);
ServiceSale.select(entity);

ServiceRepair repair = ServiceRepair.select(entity.getId());
Personal recv = Personal.select(repair.getCreate_by());

Customer cus = new Customer();
if (entity.getCus_id().length() > 0) {
	cus = Customer.select(entity.getCus_id());
} else {
	cus.setCus_name_th(entity.getCus_name());
}

Vehicle vehicle = new Vehicle();
if (entity.getV_id().length() > 0) {
	vehicle = Vehicle.select(entity.getV_id());
} else {
	vehicle.setLicense_plate(entity.getV_plate());
}
%>
<script type="text/javascript">
$(function(){
	$( "#due_date" ).datepicker({
		showOtherMonths: true,
		selectOtherMonths: true,
		changeYear: true,
		changeMonth: true
	});
	
	$('#fuel_radio_wrap').buttonset();
	
	var $form = $('#job_form');

	var v = $form.validate({
		submitHandler: function(){
			var addData = $form.serialize();
			ajax_load();
			$.post('../PartSaleManage',addData,function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location='sv_job_info.jsp?id=<%=entity.getId()%>';
				} else {
					alert(resData.message);
				}
			},'json');
		}
	});
	
	$('#update_sv').click(function(){
		$form.submit();
	});
	
	$form.submit(function(){
		v;
		return false;
	});
});

function del_condition(id,con_number){
	if (confirm('Remove Condition?')) {
		$.post('../PartSaleManage',{'id':id,'con_number':con_number,'action':'delete_condition'},function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				window.location='sv_job_info.jsp?id=<%=entity.getId()%>';
			} else {
				alert(resData.message);
			}
		},'json');
	}
}

function cancel_condition(id){
	if (confirm('Cancel Job?')) {
		$.post('../PartSaleManage',{'id':id,'action':'cancel_condition'},function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				window.location='sv_job_manage.jsp';
			} else {
				alert(resData.message);
			}
		},'json');
	}
}
</script>
<title>Job ID: <%=entity.getId()%> - <%=entity.getV_plate()%></title>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Job ID: <%=entity.getId()%></div>
				<div class="right">
					<button class="btn_box" onclick="window.location='<%=LinkControl.link("sv_job_manage.jsp", (List)session.getAttribute("CS_ORDER_SEARCH"))%>';">Back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				
				<fieldset class="fset">
					<legend>Job Information</legend>
						<div class="left s400">
							<table class="s_auto" cellspacing="5">
								<tbody>
									<tr>
										<td width="30%">Order ID</td>
										<td width="70%">: <%=entity.getId()%></td>
									</tr>
									<tr>
										<td>Customer Name</td>
										<td>: 
											<input type="text" class="txt_box s200" readonly="readonly" disabled="disabled" value="<%=entity.getCus_name()%>"> 
											<a class="btn_view" onclick="$('#tr_customer').toggle();"></a> 
											<a class="btn_update thickbox" lang="sv_job_update_customer.jsp?id=<%=entity.getId()%>&height=400&width=800" title="Update Customer"></a> 
										</td>
									</tr>
									<tr id="tr_customer" class="hide">
										<td colspan="2">
											<fieldset class="fset">
												<legend>Customer Profile</legend>
												<table class="s_auto" cellspacing="5">
													<tbody>
														<tr>
															<td width="30%">Contact</td>
															<td width="70%">: <%=cus.getCus_phone()%> &nbsp; <%=cus.getCus_mobile()%></td>
														</tr>
														<tr>
															<td>Address</td>
															<td>: <%=cus.getCus_address()%></td>
														</tr>
													</tbody>
												</table>
											</fieldset>
										</td>
									</tr>
									<tr>
										<td>Vehicle Plate</td>
										<td>: 
											<input type="text" class="txt_box s200" readonly="readonly" disabled="disabled" value="<%=entity.getV_plate()%>"> 
											<a class="btn_view" onclick="$('#tr_vehicle').toggle();"></a>
										</td>
									</tr>
									<tr id="tr_vehicle" class="hide">
										<td colspan="2">
											<fieldset class="fset">
												<legend>Vehicle Detail</legend>
												<table class="s_auto" cellspacing="5">
													<tbody>
														<tr>
															<td width="30%">Brand</td>
															<td width="70%">: <%=vehicle.getUIMaster().getUIBrand()%>&nbsp;<%=vehicle.getUIMaster().getUIModel()%>&nbsp;<%=vehicle.getUIMaster().getNameplate()%></td>
														</tr>
														<tr>
															<td>Year</td>
															<td>: <%=vehicle.getUIMaster().getYear()%></td>
														</tr>
														<tr>
															<td>Engine NO.</td>
															<td>: <%=vehicle.getEngine_no()%></td>
														</tr>
														<tr>
															<td>VIN.</td>
															<td>: <%=vehicle.getVin()%></td>
														</tr>
														<tr>
															<td>Color</td>
															<td>: <%=vehicle.getColor()%></td>
														</tr>
													</tbody>
												</table>
											</fieldset>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						
						<div class="right s400">
							<table class="s_auto" cellspacing="5">
								<tbody>
									<tr>
										<td width="30%">Order Date</td>
										<td width="70%">: <%=WebUtils.getDateTimeValue(entity.getCreate_date())%></td>
									</tr>
									<tr>
										<td><label title="ประเภทการเข้ารับบริการ">Service Type</label></td>
										<td>: <%=ServiceSale.service(entity.getService_type()) %></td>
									</tr>
									<tr>
										<td><label title="พนักงานรับรถ">Received by</label></td>
										<td>: <%=recv.getName() + " " + recv.getSurname()%></td>
									</tr>
								</tbody>
							</table>
						</div>
					
						<div class="clear"></div>
				</fieldset>
				
				<form id="job_form" onsubmit="return false;">
				
					<fieldset class="fset min_h200">
						<legend>Service required / Problems</legend>
						<div class="left s350">
							<table class="s_auto" cellspacing="5">
								<tbody valign="top">
									<tr>
										<td width="33%"><label title="ชื่อผู้ที่นำรถมา">Driven By</label></td>
										<td width="2%">:</td>
										<td width="65%"><input type="text" class="txt_box s150" name="driven_by" autocomplete="off" value="<%=(repair.getDriven_by().length()>0)?repair.getDriven_by():entity.getCus_name()%>"></td>
									</tr>
									<tr>
										<td><label title="เบอร์ติดต่อผู้ที่นำรถมา">Driver contact</label></td>
										<td>:</td>
										<td><input type="text" class="txt_box s150" name="driven_contact" autocomplete="off" value="<%=repair.getDriven_contact()%>"></td>
									</tr>
									<tr>
										<td><label title="ลักษณะการรับบริการ">Service Type</label></td>
										<td>:</td>
										<td>
											<bmp:ComboBox name="repair_type" listData="<%=ServiceRepair.ddl_repair_type_th()%>" value="<%=repair.getRepair_type()%>" styleClass="txt_box s150"></bmp:ComboBox>
										</td>
									</tr>
									<tr>
										<td><label title="ระดับน้ำมัน">Fuel</label></td>
										<td>:</td>
										<td>
											<div id="fuel_radio_wrap">
												<input type="radio" name="fuel_level" id="e" value="e" <%=(repair.getFuel_level().equalsIgnoreCase("e"))?"checked='checked'":""%>><label for="e">E</label>
												<input type="radio" name="fuel_level" id="1_4" value="1_4" <%=(repair.getFuel_level().equalsIgnoreCase("1_4"))?"checked='checked'":""%>><label for="1_4">1/4</label>
												<input type="radio" name="fuel_level" id="1_2" value="1_2" <%=(repair.getFuel_level().equalsIgnoreCase("1_2"))?"checked='checked'":""%>><label for="1_2">1/2</label>
												<input type="radio" name="fuel_level" id="3_4" value="3_4" <%=(repair.getFuel_level().equalsIgnoreCase("3_4"))?"checked='checked'":""%>><label for="3_4">3/4</label>
												<input type="radio" name="fuel_level" id="f" value="f" <%=(repair.getFuel_level().equalsIgnoreCase("f"))?"checked='checked'":""%>><label for="f">F</label>
											</div> 
										</td>
									</tr>
									<tr>
										<td><label title="เลขไมล์">Odometer Mile/Km</label></td>
										<td>:</td>
										<td><input type="text" class="txt_box s150 required digits" title="*" autocomplete="off" name="mile" value="<%=repair.getMile()%>"></td>
									</tr>
									<tr>
										<td><label title="กำหนดส่งรถคืน">Return date</label></td>
										<td>:</td>
										<td><input type="text" class="txt_box s150 required" title="*" autocomplete="off" name="due_date" id="due_date" value="<%=WebUtils.getDateValue(repair.getDue_date())%>"></td>
									</tr>
								</tbody>
							</table>
						</div>
					
					
						<div class="right s550">
							<table class="s_auto" cellspacing="5">
								<tbody valign="top">
									<tr valign="top">
										<td width="28%"><label title="อาการของรถ">Service required / Problems</label></td>
										<td width="2%">:</td>
										<td width="70%"><textarea class="txt_box s350 required" title="*" rows="5" cols="15" name="problem"><%=repair.getProblem()%></textarea></td>
									</tr>
									<tr>
										<td><label title="หมายเหตุ">Note</label></td>
										<td>:</td>
										<td><textarea class="txt_box s350" rows="2" cols="15" name="note"><%=repair.getNote()%></textarea></td>
									</tr>
								</tbody>
							</table>
						</div>
						
						<div class="clear"></div>
					</fieldset>
					
					<div class="dot_line m_top5"></div>
					<div class="center txt_center">
						<button type="button" class="btn_box btn_confirm" id="update_sv">Save</button>
						<button type="button" class="btn_box btn_warn" id="cancel_sv" onclick="cancel_condition(<%=entity.getId()%>)">Cancel Job</button>
						<input type="hidden" name="status" value="<%=entity.getStatus()%>">
						<input type="hidden" name="flag" value="<%=RepairLaborTime.STATUS_CS%>">
						<input type="hidden" name="id" value="<%=entity.getId()%>">
						<input type="hidden" name="action" value="update_service_repair">
						<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
					</div>
				</form>
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>