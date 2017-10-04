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
	
		<%-- function OpenJob(){
					if(confirm('Open Job Confirm. ')) {
						ajax_load();
						$.post('../PartSaleManage',{'service_type':<%=ServiceSale.SERVICE_MA%>,'create_by':'<%=securProfile.getPersonal().getPer_id()%>','action':'create_sale_order'},function(json){
							ajax_remove();
							if (json.status == 'success') {
								//window.location='sv_job_create.jsp?id=' + json.id;
								window.location='sv_job_info.jsp?id=' + json.id;
							} else {
								alert(json.message);
							}
						},'json');
					} 
			} --%>
	
			var $form = $('#job_form');

			var v = $form.validate({
				submitHandler: function(){
					<%=(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_OPENING))?"if (confirm('Confirm Start Job?')) {":"if (confirm('Confirm Save Job?')) {"%>
						var addData = $form.serialize();
						ajax_load();
						$.post('../PartSaleManage',addData,function(resData){
							ajax_remove();
							if (resData.status == 'success') {
								window.location='sv_job_description.jsp?id='+resData.id;
							} else {
								alert(resData.message);
							}
						},'json');
					<%=(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_OPENING))?"}":"}"%>
				}
			});
			
			$('#create_sv').click(function(){
				$form.submit();
			});
			
			$form.submit(function(){
				v;
				return false;
			});
});

</script>
<title>Open Job</title>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">	New Open Job</div>
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
										<td width="40%">	</td>
										<td width="60%">	</td>
									</tr>
									<tr>
											<td><font color="red">*</font> <Strong>Vehicle Plate</Strong></td>
											<td>:  <input type="text" class="txt_box s100 required" name="v_plate" id="v_plate" maxlength="10" value="" title="***" /> 
										</td>
									</tr>
									<tr>
										<td><font color="red">*</font> <Strong>Vehicle Plate Province</Strong></td>
										<td>: 
												<select name="v_plate_province""  class="txt_box s150 required"  id="v_plate_province" >
											      <option value="" selected>--------- เลือกจังหวัด ---------</option>
											      <option value="กรุงเทพมหานคร">กรุงเทพมหานคร</option>
											      <option value="กระบี่">กระบี่ </option>
											      <option value="กาญจนบุรี">กาญจนบุรี </option>
											      <option value="กาฬสินธุ์">กาฬสินธุ์ </option>
											      <option value="กำแพงเพชร">กำแพงเพชร </option>
											      <option value="ขอนแก่น">ขอนแก่น</option>
											      <option value="จันทบุรี">จันทบุรี</option>
											      <option value="ฉะเชิงเทรา">ฉะเชิงเทรา </option>
											      <option value="ชัยนาท">ชัยนาท </option>
											      <option value="ชัยภูมิ">ชัยภูมิ </option>
											      <option value="ชุมพร">ชุมพร </option>
											      <option value="ชลบุรี">ชลบุรี </option>
											      <option value="เชียงใหม่">เชียงใหม่ </option>
											      <option value="เชียงราย">เชียงราย </option>
											      <option value="ตรัง">ตรัง </option>
											      <option value="ตราด">ตราด </option>
											      <option value="ตาก">ตาก </option>
											      <option value="นครนายก">นครนายก </option>
											      <option value="นครปฐม">นครปฐม </option>
											      <option value="นครพนม">นครพนม </option>
											      <option value="นครราชสีมา">นครราชสีมา </option>
											      <option value="นครศรีธรรมราช">นครศรีธรรมราช </option>
											      <option value="นครสวรรค์">นครสวรรค์ </option>
											      <option value="นราธิวาส">นราธิวาส </option>
											      <option value="น่าน">น่าน </option>
											      <option value="นนทบุรี">นนทบุรี </option>
											      <option value="บึงกาฬ">บึงกาฬ</option>
											      <option value="บุรีรัมย์">บุรีรัมย์</option>
											      <option value="ประจวบคีรีขันธ์">ประจวบคีรีขันธ์ </option>
											      <option value="ปทุมธานี">ปทุมธานี </option>
											      <option value="ปราจีนบุรี">ปราจีนบุรี </option>
											      <option value="ปัตตานี">ปัตตานี </option>
											      <option value="พะเยา">พะเยา </option>
											      <option value="พระนครศรีอยุธยา">พระนครศรีอยุธยา </option>
											      <option value="พังงา">พังงา </option>
											      <option value="พิจิตร">พิจิตร </option>
											      <option value="พิษณุโลก">พิษณุโลก </option>
											      <option value="เพชรบุรี">เพชรบุรี </option>
											      <option value="เพชรบูรณ์">เพชรบูรณ์ </option>
											      <option value="แพร่">แพร่ </option>
											      <option value="พัทลุง">พัทลุง </option>
											      <option value="ภูเก็ต">ภูเก็ต </option>
											      <option value="มหาสารคาม">มหาสารคาม </option>
											      <option value="มุกดาหาร">มุกดาหาร </option>
											      <option value="แม่ฮ่องสอน">แม่ฮ่องสอน </option>
											      <option value="ยโสธร">ยโสธร </option>
											      <option value="ยะลา">ยะลา </option>
											      <option value="ร้อยเอ็ด">ร้อยเอ็ด </option>
											      <option value="ระนอง">ระนอง </option>
											      <option value="ระยอง">ระยอง </option>
											      <option value="ราชบุรี">ราชบุรี</option>
											      <option value="ลพบุรี">ลพบุรี </option>
											      <option value="ลำปาง">ลำปาง </option>
											      <option value="ลำพูน">ลำพูน </option>
											      <option value="เลย">เลย </option>
											      <option value="ศรีสะเกษ">ศรีสะเกษ</option>
											      <option value="สกลนคร">สกลนคร</option>
											      <option value="สงขลา">สงขลา </option>
											      <option value="สมุทรสาคร">สมุทรสาคร </option>
											      <option value="สมุทรปราการ">สมุทรปราการ </option>
											      <option value="สมุทรสงคราม">สมุทรสงคราม </option>
											      <option value="สระแก้ว">สระแก้ว </option>
											      <option value="สระบุรี">สระบุรี </option>
											      <option value="สิงห์บุรี">สิงห์บุรี </option>
											      <option value="สุโขทัย">สุโขทัย </option>
											      <option value="สุพรรณบุรี">สุพรรณบุรี </option>
											      <option value="สุราษฎร์ธานี">สุราษฎร์ธานี </option>
											      <option value="สุรินทร์">สุรินทร์ </option>
											      <option value="สตูล">สตูล </option>
											      <option value="หนองคาย">หนองคาย </option>
											      <option value="หนองบัวลำภู">หนองบัวลำภู </option>
											      <option value="อำนาจเจริญ">อำนาจเจริญ </option>
											      <option value="อุดรธานี">อุดรธานี </option>
											      <option value="อุตรดิตถ์">อุตรดิตถ์ </option>
											      <option value="อุทัยธานี">อุทัยธานี </option>
											      <option value="อุบลราชธานี">อุบลราชธานี</option>
											      <option value="อ่างทอง">อ่างทอง </option>
											      <option value="อื่นๆ">อื่นๆ</option>
											</select>
																					
										 <!-- <input type="text" class="txt_box s150 required" name="v_plate_province" id="v_plate_province" value="" title="***" />  -->
										
										</td>
									</tr>
									<tr>
										<td>  <Strong>Brand</Strong></td>
										<td>: 
											<bmp:ComboBox name="brand_id" styleClass="txt_box s200" width="200px" listData="<%=Brands.ddl()%>" validate="true"   value="">
												<bmp:option value="" text="--- เลือก Brand ---"></bmp:option>
											</bmp:ComboBox>
										</td>
									</tr>	
									<tr>
										<td> <Strong>Model</Strong></td>
										<td>: 
											<bmp:ComboBox name="model_id" styleClass="txt_box s200" width="200px" validate="true" listData="<%=Models.selectDDL(entity.getBrand_id())%>" value="">
												<bmp:option value="" text="--- เลือก Model ---"></bmp:option>
											</bmp:ComboBox>
										</td>
									</tr>
									<tr>
										<td valign="top"><font color="red">*</font> <Strong>Customer Name</Strong></td>
										<td valign="top">: 
											<input type="text" class="txt_box s200  required" name="cus_name" id="cus_name"  value="" title="***" /> 
										</td>
									</tr>
									<tr>
										<td valign="top"><font color="red">*</font> <Strong>Customer Surname </Strong></td>
										<td valign="top">: 
											<input type="text" class="txt_box s200  required" name="cus_surname" id="cus_surname" 	value="" title="***" /> 
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
															<td width="70%">:  </td>
														</tr>
														<tr>
															<td><font color="red">*</font> <Strong>Address</Strong></td>
															<td>: </td>
														</tr>
													</tbody>
												</table>
											</fieldset>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						
				</fieldset>
				
				
					
						<fieldset class="fset min_h200">
							<legend><Strong>Service required / Problems</Strong></legend>
							<div class="left s350">
								<table class="s_auto" cellspacing="5">
									<tbody valign="top">
										<tr>
											<td width="40%"><label title="ชื่อผู้ที่นำรถมา"><Strong>Driven By</Strong></label></td>
											<td width="5%">:</td>
											<td width="55%"><input type="text" class="txt_box s150" name="driven_by" autocomplete="off" value=""></td>
										</tr>
										<tr>
											<td><label title="เบอร์ติดต่อผู้ที่นำรถมา"><Strong>Driver contact</Strong></label></td>
											<td>:</td>
											<td><input type="text" class="txt_box s150" name="driven_contact" autocomplete="off" value=""></td>
										</tr>
										<tr>
											<td><label title="ลักษณะการรับบริการ"><Strong>Service Type</Strong></label></td>
											<td>:</td>
											<td>
												<bmp:ComboBox name="repair_type" listData="<%=ServiceRepair.ddl_repair_type_en()%>" value="" styleClass="txt_box s150"></bmp:ComboBox>
											</td>
										</tr>
										<tr>
											<td><label title="เลขไมล์"><font color="red">*</font> <Strong>Odometer Mile/Km</Strong></label></td>
											<td>:</td>
											<td>
												<input type="text" class="txt_box s150 digits  required" autocomplete="off" name="mile" value="" title="***" >
												<br/>
												<font color="red">( ใส่เป็นตัวเลขเท่านั้น )</font>
											</td>
										</tr>
										<tr>
											<td><label title="กำหนดส่งรถคืน"><Strong>Return date</Strong></label></td>
											<td>:</td>
											<td><input type="text" class="txt_box s150" autocomplete="off" name="due_date" id="due_date" value=""  readonly="readonly"/> </td>
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
											<textarea class="txt_box s350 required"  rows="5" cols="15" name="problem" title="***" ></textarea>
										</td>
									</tr>
									<tr>
										<td><label title="หมายเหตุ"><Strong>Note</Strong></label></td>
										<td>:</td>
										<td><textarea class="txt_box s350" rows="2" cols="15" name="note"></textarea></td>
									</tr>
								</tbody>
							</table>
						</div>
						
						<div class="clear"></div>
					</fieldset>
					
					<div class="dot_line m_top5"></div>
					<div class="center txt_center">
						
							<button type="button" class="btn_box btn_confirm"  id="create_sv"  >Start Job</button>
										
						<input type="hidden" name="action" value="create_sale_order">
						<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
								</div>
				</form>
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>