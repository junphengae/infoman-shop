<%@page import="com.bitmap.bean.service.RepairLaborTime"%>
<%@page import="com.bitmap.bean.sale.Vehicle"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.bean.sale.Brands" %>
<%@page import="com.bitmap.bean.sale.Models" %>
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

<% String cus_id =WebUtils.getReqString(request,"cus_id"); %>
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
	

	$('#brand_id').change(function(){
		ajax_load();
		$.post('../PartSaleManage',{brand_id: $(this).val(),action:'get_models'}, function(resData){
		ajax_remove();
		if (resData.status == 'success') {
			var options = '<option value="">--- เลือก Model---</option>';
	        var data = resData.model;
	        $.each(data , function (index , object){
	        	options += '<option value="' + object.model_id + '">' + object.model_name + '</option>';
			});
	        $('#model_id').html(options);
		} else {
			alert(resData.message);
		}
	},'json');
	});	
	
	$( "#due_date" ).datepicker({
		showOtherMonths: true,
		selectOtherMonths: true,
		changeYear: true,
		changeMonth: true,
		minDate: new Date(),
		hideIfNoPrevNext : true
	});
	
	$('#fuel_radio_wrap').buttonset();
	
	var $form = $('#job_form');

	var v = $form.validate({
		submitHandler: function(){
			<%=(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_OPENING))?"if (confirm('Confirm Start Job?')) {":"if (confirm('Confirm Save Job?')) {"%>
				var addData = $form.serialize();
				ajax_load();
				$.post('../PartSaleManage',addData,function(resData){
					ajax_remove();
					if (resData.status == 'success') {

						startDownload();
						
						
						window.location='sv_job_description.jsp?id=<%=entity.getId()%>';
					} else {
						alert(resData.message);
					}
				},'json');
			<%=(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_OPENING))?"}":"}"%>
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

function startDownload()
{
var url= "../../images/motoshop/part/tmp.zip"; 
window.open(url,'Download');
}
function del_condition(id,con_number){
	if (confirm('Remove Condition?')) {
		$.post('../PartSaleManage',{'id':id,'con_number':con_number,'action':'delete_condition'},function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				window.location.reload();
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
				<form id="job_form" onsubmit="return false;">
				<fieldset class="fset">
					<legend><Strong>Job Information</Strong></legend>
						<div class="left s430">
							<table class="s_auto" cellspacing="5">
								<tbody>
									<tr>
										<td width="40%"><Strong>Job ID</Strong></td>
										<td width="60%">: <%=entity.getId()%></td>
									</tr>
									<tr>
											<td><font color="red">*</font> <Strong>Vehicle Plate</Strong></td>
											<td>: 
											<input type="text" class="txt_box s100 required" name="v_plate" id="v_plate" maxlength="10" value="<%=entity.getV_plate()%>" title="***" /> 
											<!-- 
											<a class="btn_view" onclick="$('#tr_vehicle').toggle();"></a>
											 -->
										</td>
									</tr>
									<tr>
										<td><font color="red">*</font> <Strong>Vehicle Plate Province</Strong></td>
										<td>: 
											<input type="text" class="txt_box s150 required" name="v_plate_province" id="v_plate_province" value="<%=entity.getV_plate_province()%>" title="***" /> 
										</td>
									</tr>
									<tr>
										<td>  <Strong>Brand</Strong></td>
										<td>: 
											<bmp:ComboBox name="brand_id" styleClass="txt_box s200" width="200px" listData="<%=Brands.ddl()%>" validate="true"   value="<%=entity.getBrand_id()%>">
												<bmp:option value="" text="--- เลือก Brand ---"></bmp:option>
											</bmp:ComboBox>
										</td>
									</tr>	
									<tr>
										<td> <Strong>Model</Strong></td>
										<td>: 
											<bmp:ComboBox name="model_id" styleClass="txt_box s200" width="200px" validate="true" listData="<%=Models.selectDDL(entity.getBrand_id())%>" value="<%=entity.getModel_id()%>">
												<bmp:option value="" text="--- เลือก Model ---"></bmp:option>
											</bmp:ComboBox>
										</td>
									</tr>
									<tr>
										<td valign="top"><font color="red">*</font> <Strong>Customer Name</Strong></td>
										<td valign="top">: 
											<input type="text" class="txt_box s200  required" name="cus_name" id="cus_name" value="<%=entity.getCus_name()%>" title="***" /> 
											<input type="hidden" name="cus_id" id="cus_id" value="<%=cus_id%>">
											<!-- 
											<a class="btn_view hide" onclick="$('#tr_customer').toggle();"></a> 
											<a class="btn_update" href="#"  title="Update Customer" onclick="popup('sv_job_customer_search.jsp');"></a> 
											 -->
											<!-- <button class="btn_search btn_box" onclick="popup('sv_job_customer_search.jsp');">search</button>  -->
									
										</td>
									</tr>
									<tr>
										<td valign="top"><font color="red">*</font> <Strong>Customer Surname </Strong></td>
										<td valign="top">: 
											<input type="text" class="txt_box s200  required" name="cus_surname" id="cus_surname" value="<%=entity.getCus_surname()%>" title="***" /> 
											<!-- 
											<a class="btn_view hide" onclick="$('#tr_customer').toggle();"></a> 
											<a class="btn_update" href="#"  title="Update Customer" onclick="popup('sv_job_customer_search.jsp');"></a> 
											 -->
											<!-- <button class="btn_search btn_box" onclick="popup('sv_job_customer_search.jsp');">search</button>  -->
									
										</td>
									</tr> 
									<tr id="tr_customer" class="hide">
										<td colspan="2">
											<fieldset class="fset">
												<legend><Strong>Customer Profile</Strong></legend>
												<table class="s_auto" cellspacing="5">
													<tbody>
														<tr>
															<td width="30%"><font color="red">*</font> <Strong>Contact</Strong></td>
															<td width="70%">: <%=cus.getCus_phone()%> &nbsp; <%=cus.getCus_mobile()%></td>
														</tr>
														<tr>
															<td><font color="red">*</font> <Strong>Address</Strong></td>
															<td>: <%=cus.getCus_address()%></td>
														</tr>
													</tbody>
												</table>
											</fieldset>
										</td>
									</tr>
									<tr id="tr_vehicle" class="hide">
										<td colspan="2">
											<fieldset class="fset">
												<legend><Strong>Vehicle Detail</Strong></legend>
												<table class="s_auto" cellspacing="5">
													<tbody>
														<tr>
															<td width="30%"><Strong>Brand</Strong></td>
															<td width="70%">: <%=vehicle.getUIMaster().getUIBrand()%>&nbsp;<%=vehicle.getUIMaster().getUIModel()%>&nbsp;<%=vehicle.getUIMaster().getNameplate()%></td>
														</tr>
														<tr>
															<td><Strong>Year</Strong></td>
															<td>: <%=vehicle.getUIMaster().getYear()%></td>
														</tr>
														<tr>
															<td><Strong>Engine NO.</Strong></td>
															<td>: <%=vehicle.getEngine_no()%></td>
														</tr>
														<tr>
															<td><Strong>VIN.</Strong></td>
															<td>: <%=vehicle.getVin()%></td>
														</tr>
														<tr>
															<td><Strong>Color</Strong></td>
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
										<td width="30%"><Strong>Order Date</Strong></td>
										<td width="70%">: <%=WebUtils.getDateTimeValue(entity.getCreate_date())%></td>
									</tr>
									<%-- <tr>
										<td><label title="ประเภทการเข้ารับบริการ"><Strong>Service Type</Strong></label></td>
										<td>: <%=ServiceSale.service(entity.getService_type()) %></td>
									</tr> --%>
									<tr>
										<td><label title="พนักงานรับรถ"><Strong>Received by</Strong></label></td>
										<td>: <%=recv.getName() + " " + recv.getSurname()%></td>
									</tr>
								</tbody>
							</table>
						</div>
					
						<div class="clear"></div>
				</fieldset>
				
				
					
						<fieldset class="fset min_h200">
						<legend><Strong>Service required / Problems</Strong></legend>
						<div class="left s350">
							<table class="s_auto" cellspacing="5">
								<tbody valign="top">
									<tr>
										<td width="40%"><label title="ชื่อผู้ที่นำรถมา"><Strong>Driven By</Strong></label></td>
										<td width="5%">:</td>
										<td width="55%"><input type="text" class="txt_box s150" name="driven_by" autocomplete="off" value="<%=(repair.getDriven_by().length()>0)?repair.getDriven_by():entity.getCus_name()%>"></td>
									</tr>
									<tr>
										<td><label title="เบอร์ติดต่อผู้ที่นำรถมา"><Strong>Driver contact</Strong></label></td>
										<td>:</td>
										<td><input type="text" class="txt_box s150" name="driven_contact" autocomplete="off" value="<%=repair.getDriven_contact()%>"></td>
									</tr>
									<tr>
										<td><label title="ลักษณะการรับบริการ"><Strong>Service Type</Strong></label></td>
										<td>:</td>
										<td>
											<bmp:ComboBox name="repair_type" listData="<%=ServiceRepair.ddl_repair_type_en()%>" value="<%=repair.getRepair_type()%>" styleClass="txt_box s150"></bmp:ComboBox>
										</td>
									</tr>
									<tr>
										<td><label title="เลขไมล์"><font color="red">*</font> <Strong>Odometer Mile/Km</Strong></label></td>
										<td>:</td>
										<td>
											<input type="text" class="txt_box s150 digits  required" autocomplete="off" name="mile" value="<%=repair.getMile()%>"title="***" >
											<br/>
											<font color="red">( ใส่เป็นตัวเลขเท่านั้น )</font>
										</td>
									</tr>
									<tr>
										<td><label title="กำหนดส่งรถคืน"><Strong>Return date</Strong></label></td>
										<td>:</td>
										<td><input type="text" class="txt_box s150" autocomplete="off" name="due_date" id="due_date" value="<%=WebUtils.getDateValue(repair.getDue_date())%>"></td>
									</tr>
								</tbody>
							</table>
						</div>
					
					
						<div class="right s550">
							<table class="s_auto" cellspacing="5">
								<tbody valign="top">
									<tr valign="top">
										<td width="25%"><label title="อาการของรถ"><font color="red">*</font><Strong> Service required / Problems</Strong></label></td>
										<td width="3%">:</td>
										<td width="72%">
											<textarea class="txt_box s350 required"  rows="5" cols="15" name="problem" title="***" ><%=repair.getProblem()%></textarea>
										</td>
									</tr>
									<tr>
										<td><label title="หมายเหตุ"><Strong>Note</Strong></label></td>
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
						<%
							if(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_OPENING)){
							%>
							<button type="button" class="btn_box btn_confirm" id="update_sv"><%=(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_OPENING))?"Start Job":"Save Job"%></button>
							<% } %>
									<input type="hidden" name="status" value="<%=(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_OPENING))?ServiceSale.STATUS_MA_REQUEST:entity.getStatus()%>">
									<%--
										 <button type="button" class="btn_box btn_printer" onclick="window.open('sv_job_print.jsp?id=<%=entity.getId()%>','_blank');">Print Received Car</button> 
										 --%>
						 	<%if(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_MA_REQUEST) || entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_OUTSOURCE)){ %>
									<input type="hidden" name="status" value="<%=(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_OPENING))?ServiceSale.STATUS_MA_REQUEST:entity.getStatus()%>">
									 <%-- <button type="button" class="btn_box btn_printer" onclick="window.open('sv_job_print.jsp?id=<%=entity.getId()%>','_blank');">Print Received Car</button> 
										&nbsp; | &nbsp;
										 --%>
									<%-- <button type="button" class="btn_box" onclick="window.location='sv_job_description.jsp?id=<%=entity.getId()%>';">Manage Job</button> --%>
									<button type="button" class="btn_box btn_confirm" id="update_sv"><%=(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_OPENING))?"Start Job":"Save Job"%></button>
						<%}%>						
						<input type="hidden" name="id" value="<%=entity.getId()%>">
						<input type="hidden" name="flag" value="<%=RepairLaborTime.STATUS_CS%>">
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