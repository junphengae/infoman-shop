<%@page import="com.bmp.utits.reference.transaction.BmpProvinceTS"%>
<%@page import="com.bmp.utils.reference.bean.BmpProvinceBean"%>
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

<jsp:useBean id="BMP_MST_PROVINCE" class="java.util.ArrayList" scope="application"></jsp:useBean>

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

List listPvrM = BmpProvinceTS.SelectThailandProvince();
Iterator<BmpProvinceBean> itePvrM = listPvrM.iterator();



List listPV = BmpProvinceTS.SelectThailandProvince();
Iterator<BmpProvinceBean> itr_pv = listPV.iterator();


%>
<script type="text/javascript">
function  checkNumber_phonenumber(data){
	  if(!data.value.match(/^\d*$/)){
				alert("กรอกหมายเลขโทรศัพท์  เป็นตัวเลขเท่านั้น");
				data.value='';
				$('#phonenumber').focus();
	  }
}

function  checkNumber_postalcode(data){
	  if(!data.value.match(/^\d*$/)){
				alert("กรอกรหัสไปรษณีย์  เป็นตัวเลขเท่านั้น");
				data.value='';
				$('#postalcode').focus();
	  }
}
function  checkNumber_driven_contact(data){
	  if(!data.value.match(/^\d*$/)){
				alert("กรอกหมายเลขโทรศัพท์  เป็นตัวเลขเท่านั้น");
				data.value='';
				$('#driven_contact').focus();
	  }
}
function  checkNumber_mile(data){
	  if(!data.value.match(/^\d*$/)){
				alert("กรอกเลขไมค์ เป็นตัวเลขเท่านั้น");
				data.value='';
				$('#mile').focus();
	  }
}

$(function(){
	
	var province = $('#province_');//จังหวัด
	var prefecture = $('#prefecture_');//อำเภอ
	var district = $('#district_');//ตำบล
	var postalcode = $('#postalcode');//รหัสไปรษณีย์
	
	var province_des = $('#province');//จังหวัด
	var prefecture_des = $('#prefecture');//อำเภอ
	var district_des = $('#district');//ตำบล
	
	
	/***********************************************เพิ่ม จังหวัด อำเภอ ตำบล********************************************************/
	
	
	province.change(function(){
		if (province.val()!= "") {
		
				ajax_load();
				$.post('../ReferenceUtilsServlet','action=get_amphur&pv=' + province.val(),function(res){
					ajax_remove();
					
					if (res.result) {
						var amphur_list = res.bmp_amphur_list;
						var amp_html = '<option value="">เลือกอำเภอ/เขต...</option>';
						$.each(amphur_list, function(index, object) {
							amp_html += '<option value="' + object.bmp_ampr_cd + '" bmp_ampr_pc="' + object.bmp_ampr_pc + '" bmp_ampr_name="' + object.bmp_ampr_name + '">' + object.bmp_ampr_sname + '</option>';
						});
						prefecture.html(amp_html).trigger('liszt:updated');
						var tumbol_html = '<option value="" selected="selected">เลือกตำบล/แขวง.....</option>';
						district.html(tumbol_html).trigger('liszt:updated');	
					} else {
						alert(res.message);
					}
				},'json');
				var province_des_ = $(this).find('option[value='+ $(this).val()+']').attr('provnc_name');
				province_des.val( province_des_ );
		}else{
			window.location.reload();
		}
	});
	
	prefecture.change(function(){		
		ajax_load();
		$.post('../ReferenceUtilsServlet','action=get_tumbol&amp=' + prefecture.val()+'&pv='+province.val() ,function(res){
			ajax_remove();
			if (res.result) {
				var tumbol_list = res.bmp_tumbol_list;
				var tumbol_html = '<option value="" bmp_tum_name="" selected="selected" >เลือกตำบล/แขวง.....</option>';
				$.each(tumbol_list, function(index, object) {
					tumbol_html += '<option value="' + object.bmp_tum_cd  + '" bmp_tum_name="' + object.bmp_tum_name + '">' + object.bmp_tum_sname + '</option>';
				});
				district.html(tumbol_html).trigger('liszt:updated');	
			} else {
				alert(res.message);						
			}
		},'json');
		
		var ampr_pc = $(this).find('option[value='+ $(this).val()+']').attr('bmp_ampr_pc');
		postalcode.val(ampr_pc);
		var ampr_desc = $(this).find('option[value='+ $(this).val()+']').attr('bmp_ampr_name');
		prefecture_des.val(ampr_desc);
		district_des.val('');
		 
		 
	});
	
	district.change(function(){
		
		var dist_desc = $(this).find('option[value='+ $(this).val()+']').attr('bmp_tum_name');
		district_des.val(dist_desc );
		
	});	
/*******************************************************************************************************/

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
					
						
						/* if(isNumber($('#postalcode').val())){
							if(isNumber($('#phonenumber').val()) || ""){ */
								if($('#repair_type').val() == ""){
									alert("โปรดระบุประเภทงานบริการ!"); 
									$('#repair_type').focus();
								}else{
									
									
								if(isNumber($('#mile').val())){
									if(isNumber($('#mile').val().length <=  7)){
									<%=(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_OPENING))?"if (confirm('ยืนยันการเปิดใบซ่อม ?')) {":"if (confirm('ยืนยันการบันทึกข้อมูลใบซ่อม?')) {"%>
				
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
									
									
									}else{
										alert("เลขระยะทางสามารถระบุได้สูงสุด 7 ตัวเท่านั้น");
										$('#mile').focus();
									}
								}else{
									alert("เลขระยะทางใส่ได้เฉพาะตัวเลขเท่านั้น"); 
									$('#mile').focus();
								}
							}		
							
				}	
			});
			
			$('#create_sv').click(function(){
				
					$form.submit();
				
								
			});
			
			$form.submit(function(){
				v;
				return false;
			});
			
			//var forewordname = $('#forewordname2');
			var tr_forewordname2 = $('#tr_forewordname2');
			$('#forewordname').change(function(){		  		
					if ($(this).val() == "4"){
						//alert("tr_forewordname2:::"+$(this).val());
						tr_forewordname2.show();
					} 
					else{
						
						tr_forewordname2.hide();
					}
					 
					
					
			});	
			

});
	

function product(){
	if (confirm('ยืนยันการสั่งซื้อสินค้า')) {
		
	//	alert("จังหวัด: "+$('#province').val()+"อำเภอ : "+$('#prefecture').val()+"ตำบล :"+$('#district').val());
		ajax_load();
		$.post('../PartSaleManage','action=create_sale_order&cus_name=ซื้อสินค้า&create_by=<%=securProfile.getPersonal().getPer_id()%>&repair_type=12',function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				window.location='sv_job_description.jsp?id='+resData.id;
			} else {
				alert(resData.message);
			}
		},'json');
		
	}else {
		//window.location='sv_job_create.jsp';
	}
}	
		


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
					
					<!-- <button class="btn_box btn_confirm" onclick="issue_po();">สร้างใบสั่งซื้อ</button> -->
					<button class="btn_box" onclick="window.location='<%=LinkControl.link("sv_job_manage.jsp", (List)session.getAttribute("CS_ORDER_SEARCH"))%>';">Back</button>
				</div>
				<div class="clear"></div>
			</div>
			<div class="content_body">
				<form id="job_form" onsubmit="return false;">
				<fieldset class="fset">
					<legend><Strong>ข้อมูลลูกค้า</Strong></legend>
						<div class="center txt_center"> 
								<center>
								<button type="button" class="btn_box btn_confirm" onclick="product()"  title="Irregular customer">ซื้อสินค้า</button>
								</center>
							</div>
						<div class="left " style="width:500px;">
							<table class="s_auto " cellspacing="5" width="100%">
								<tbody>
									<tr>
										<th width="30%"></th>
										<th width="70%"></th>
									</tr>
									<tr>
											<td> <Strong>เลขทะเบียนรถ</Strong></td>
											<td>:  <input type="text" class="txt_box s100 required" name="v_plate" id="v_plate" maxlength="10" value="" title="โปรดระบุเลขทะเบียนรถ!" /><font color="red">*</font> 
											</td>
									</tr>
									<tr>
										<td > <Strong>จังหวัดทะเบียนรถ</Strong></td>
										<td>: 
												<select name="v_plate_province"  class="txt_box s150 required"  id="v_plate_province" title="โปรดเลือกจังหวัด!">
											      <option value="" selected>--------- เลือกจังหวัด ---------</option>
											      <% 
																	while(itePvrM.hasNext())
																	{
																		BmpProvinceBean ptbM = (BmpProvinceBean) itePvrM.next();
																		
																%>
																		<option value="<%=ptbM.getBmp_pt_gov_cd()%>"  provnc_name=" <%=ptbM.getBmp_pt_name()%>" ><%=ptbM.getBmp_pt_name()%></option>
																<%  
																	} 
																%>
											</select>
																					
										 <!-- <input type="text" class="txt_box s150 required" name="v_plate_province" id="v_plate_province" value="" title="***" />  -->
										<font color="red">*</font>
										</td>
									</tr>
									<tr>
										<td>  <Strong>ยี่ห้อ</Strong></td> 
										<td>: 
											<bmp:ComboBox name="brand_id" styleClass="txt_box s200" width="150px" listData="<%=Brands.ddl()%>" validate="true"   value="">
												<bmp:option value="" text="--- เลือก Brand ---"></bmp:option>
											</bmp:ComboBox>
											<!-- <font color="red">*</font> -->
										</td>
									</tr>	
									<tr>
										<td> <Strong>รุ่น</Strong></td>
										<td>: 
											<bmp:ComboBox name="model_id" styleClass="txt_box s200" width="150px" validate="true" listData="<%=Models.selectDDL(entity.getBrand_id())%>" value="">
												<bmp:option value="" text="--- เลือก Model ---"></bmp:option>
											</bmp:ComboBox>
										<!-- <font color="red">*</font> -->
										</td>
									</tr>
									<tr >
										<td valign="top"> <Strong>คำนำหน้าชื่อ</Strong></td> 
										<td valign="top">: 
										<select name="forewordname" id="forewordname" class="txt_box s150 required"  title="โปรดเลือกคำนำหน้าชื่อ" >
										<option value="">-เลือกคำนำหน้าชื่อ -</option>
										<option value="นาย">นาย</option>
										<option value="นาง">นาง</option>
										<option value="นางสาว">นางสาว</option>
										<option value="4">อื่น ๆ</option>
										</select>
											<font color="red">*</font>
										</td>
									</tr>
									<tr id="tr_forewordname2" class="hide">
										<td valign="top">  <!-- <Strong>คำนำหน้าชื่อ</Strong> --> </td> 
										<td valign="top">:
											<input type="text" class="txt_box s180" name="title_name" id="title_name"  value="" title="โปรดกรอกคำนำหน้าชื่อ" /> 
											<font color="red">*</font> 
										</td>
									</tr>
									<tr>
										<td valign="top"> <Strong>ชื่อลูกค้า</Strong></td> 
										<td valign="top">: 
											<input type="text" class="txt_box s180  required" name="cus_name" id="cus_name"  value="" title="โปรดระบุชื่อลูกค้า!" /> 
										<font color="red">*</font>
										</td>
									</tr>
									<tr>
										<td valign="top"> <Strong>นามสกุล</Strong></td>
										<td valign="top">: 
											<input type="text" class="txt_box s180  " name="cus_surname" id="cus_surname" 	value=""  /> 
											
										</td>
									</tr> 
									<tr>
										<td valign="top"> <Strong>รหัสประจำตัวผู้เสียภาษี</Strong></td>
										<td valign="top">: 
											<input type="text" class="txt_box s180  " name="tax_id" id="tax_id" 	value=""  /> 
											
										</td>
									</tr> 
									<tr id="tr_customer" class="hide">
										<td colspan="2">
											<fieldset class="fset min_h200">
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
							<fieldset class="fset" width="100%">
												<legend><Strong>ที่อยู่</Strong></legend>
													<table width="100%">
														<tr>
															<th width="30%"></th>
															<th width="70%"></th>
												   		</tr>				
														<tr>
															<td valign="top"> <Strong>บ้านเลขที่</Strong></td>
															<td valign="top">: 
																<input type="text" class="txt_box s70  " name="addressnumber" id="addressnumber" 	value="" title="***" /> 
																
															</td>
														</tr> 
														<tr>
															<td valign="top"> <Strong>หมู่บ้าน</Strong></td>
															<td valign="top">: 
																<input type="text" class="txt_box s180" name="villege" id="villege" 	value="" title="***" /> 
																
															</td>
														</tr> 
														<tr>
															<td valign="top"> <Strong>หมู่ที่</Strong></td>
															<td valign="top">: 
																<input type="text" class="txt_box s70" name="moo" id="moo" 	value="" title="***" /> 
																
															</td>
														</tr> 
														<tr>
															<td valign="top"> <Strong>ถนน</Strong></td>
															<td valign="top">: 
																<input type="text" class="txt_box s180  " name="road" id="road" 	value="" title="***" /> 
																
															</td>
														</tr> 
														<tr>
															<td valign="top"> <Strong>ซอย</Strong></td>
															<td valign="top">: 
																<input type="text" class="txt_box s70  " name="soi" id="soi" 	value="" title="***" /> 
																
															</td>
														</tr> 
														
														<tr>			
														<td valign="top"><Strong>จังหวัด</Strong></td>
															<td valign="top">: 																
																<select  data-placeholder="เลือกจังหวัด..." class="txt_box s180 " style="max-width: 350px;" id="province_" name=province tabindex="12">
																<option value="">เลือกจังหวัด...</option>
																<% 
																	while(itr_pv.hasNext())
																	{
																		BmpProvinceBean ptb = (BmpProvinceBean) itr_pv.next();
																		
																%>
																		<option value="<%=ptb.getBmp_pt_gov_cd()%>"  provnc_name=" <%=ptb.getBmp_pt_name()%>" ><%=ptb.getBmp_pt_name()%></option>
																<%  
																	} 
																%>
																</select>
																
																
																
															</td>
														
															
														</tr> 
														<tr>													
															<td valign="top"> <Strong>อำเภอ/เขต</Strong></td>
															<td valign="top">: 
																<!-- <input type="text" class="txt_box s180  required" name="prefecture" id="prefecture_" 	value="" title="***" />  -->
																<select data-placeholder="เลือกอำเภอ/เขต..." class="txt_box s180 " style="max-width: 350px;"  id="prefecture_" name="prefecture" tabindex="13">
																<option value="" >เลือกอำเภอ/เขต...</option>
																</select>
																
																
																
															</td>
														</tr> 
														<tr>
															<td valign="top"> <Strong>ตำบล/แขวง</Strong></td>
															<td valign="top">: 
																<!-- <input type="text" class="txt_box s180  required" name="district" id="district_" 	value="" title="***" />  -->
																<select data-placeholder="เลือกตำบล/แขวง..." class="txt_box s180 " style="max-width: 350px;"  id="district_" name="district"  tabindex="14">
																<option value="" bmp_tum_name="" >เลือกตำบล/แขวง...</option>
																</select>
																
																
															</td>														
															
														</tr> 
														<tr>
															<td valign="top"> <Strong>รหัสไปรษณีย์</Strong></td>
															<td valign="top">: 
																<input type="text" class="txt_box s100"  onkeyup='checkNumber_postalcode(this)' name="postalcode" id="postalcode"  maxlength="5"	value="" title="***" /> 
																
															</td>
														</tr> 
														<tr>
															<td valign="top"> <Strong>เบอร์โทรศัพท์</Strong></td>
															<td valign="top">: 
																<input type="text" class="txt_box s100  " onkeyup='checkNumber_phonenumber(this)' name="phonenumber" onkeyup='checkNumber_driven_contact(this)' id="phonenumber" maxlength="20"	value="" title="***" /> 
																
															</td>
														</tr> 
													</table>	
											</fieldset>
							
						</div>
						
				</fieldset>
						<fieldset class="fset min_h200">
							<legend><Strong>บริการที่ร้องขอ</Strong></legend>
							<div class="left s350">
								<table class="s_auto" cellspacing="5">
									<tbody valign="top">
										<tr>
											<td width="45%"><label title="ชื่อผู้ที่นำรถมา"><Strong>ชื่อผู้ติดต่อ</Strong></label></td>
											<td width="5%">:</td>
											<td width="50%"><input type="text" class="txt_box s150" name="driven_by" autocomplete="off" value=""></td>
										</tr>
										<tr>
											<td><label title="เบอร์โทรศัพท์"><Strong>เบอร์โทรศัพท์</Strong></label></td>
											<td>:</td>
											<td><input type="text" class="txt_box s150" name="driven_contact" autocomplete="off" onkeyup='checkNumber_driven_contact(this)' value=""  maxlength="20"></td>
										</tr>
										<tr>
											<td><label title="ลักษณะการรับบริการ"><Strong>ประเภทงานบริการ</Strong></label></td>
											<td>:</td>
											<td>
												<bmp:ComboBox name="repair_type"  listData="<%=ServiceRepair.ddl_repair_type_th()%>" value="" styleClass="txt_box s150 " >
													<bmp:option value="" text="---เลือกประเภทงานบริการ ---"></bmp:option> 
												</bmp:ComboBox>
												
												<font color="red">*</font>
											</td>
										</tr>
										<tr>
											<td><label title="เลขไมล์"> <Strong>เลขไมล์</Strong></label></td>
											<td>:</td>
											<td>
												<input type="text" class="txt_box s150 " autocomplete="off" name="mile" onkeyup='checkNumber_mile(this)' value="" maxlength="7" id="mile"><font color="red">*</font>
												<br/>
												<font color="red">( ใส่เป็นตัวเลขเท่านั้น )</font>
											</td>
										</tr>
										<tr>
											<td><label title="กำหนดส่งรถคืน"><Strong>ซ่อมเสร็จวันที่</Strong></label></td>
											<td>:</td>
											<td><input type="text" class="txt_box s150 required" autocomplete="off" name="due_date" id="due_date" value=""  readonly="readonly" title="โปรดระบุวันที่ซ่อมเสร็จ"/> <font color="red">*</font> </td>
										</tr>
									</tbody>
								</table>
							</div>
						<div class="right s550">
							<table class="s_auto" cellspacing="5">
								<tbody valign="top">
									<tr valign="top">
										<td width="25%"><label title="อาการของรถ"><Strong>บริการที่ร้องขอ</Strong></label></td>
										<td width="3%">:</td>
										<td width="72%">
											<textarea class="txt_box s350 required"  rows="5" cols="15" name="problem" title="โปรดระบุบริการที่ร้องขอ!" ></textarea>
											 <font color="red">*</font>
										</td>
									</tr>
									<tr>
										<td><label title="หมายเหตุ"><Strong>หมายเหตุ</Strong></label></td>
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
						<% System.out.println(securProfile.getPersonal().getPer_id()); %>
								</div>
				</form>
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>