<%@page import="com.bmp.utits.reference.transaction.BmpTumbolTS"%>
<%@page import="com.bmp.utits.reference.transaction.BmpAmphurTS"%>
<%@page import="com.bmp.utils.reference.bean.BmpProvinceBean"%>
<%@page import="com.bmp.utits.reference.transaction.BmpProvinceTS"%>
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


<%
	String cus_id =WebUtils.getReqString(request,"cus_id"); 
	String id =WebUtils.getReqString(request,"id"); 
	String cus_update =WebUtils.getReqString(request,"upadate"); 
	String status =WebUtils.getReqString(request,"status"); 
	
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

boolean corporate = false;
System.out.println(status+"-"+corporate);
if( (!entity.getForewordname().equalsIgnoreCase("นาย"))
		&& (!entity.getForewordname().equalsIgnoreCase("นาง")) 
		&& (!entity.getForewordname().equalsIgnoreCase("นางสาว")) 
		&& (!entity.getForewordname().equalsIgnoreCase("")))
{
	//นิติบุคคล
	corporate = true;
}else{
	
	corporate = false;
}
 //System.out.println(status+"-"+corporate);
	if(status.equalsIgnoreCase("forward")){
		if(corporate){
			//นิติบุคคล
		entity.setV_plate("");
		entity.setV_plate_province_cd("");
		entity.setBrand_id("");
		entity.setModel_id("");
		entity.setCus_surname("");			
			repair.setDriven_by("");		
			repair.setDriven_contact("");
			repair.setMile("");
			repair.setDue_date(null);
			repair.setProblem("");
			repair.setNote("");
		}else{
			repair.setMile("");
			repair.setDue_date(null);
			repair.setProblem("");
			repair.setNote("");
		}
	}

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
function  checkNumber_mile(data){
	  if(!data.value.match(/^\d*$/)){
				alert("กรอกเลขไมค์ เป็นตัวเลขเท่านั้น");
				data.value='';
				$('#mile').focus();
	  }
}
function  checkNumber_driven_contact(data){
	  if(!data.value.match(/^\d*$/)){
				alert("กรอกหมายเลขโทรศัพท์  เป็นตัวเลขเท่านั้น");
				data.value='';
				$('#driven_contact').focus();
	  }
}
$(function(){
	
	var province = $('#province_');//จังหวัด
	var prefecture = $('#prefecture_');//อำเภอ
	var district = $('#district_');//ตำบล
	var postalcode = $('#postalcode');//รหัสไปรษณีย์
	
	var v_plate_province =$('#v_plate_province'); // ทะเบียนจังหวัด
	
	var province_des = $('#province');//จังหวัด
	var prefecture_des = $('#prefecture');//อำเภอ
	var district_des = $('#district');//ตำบล
	
	
		
		v_plate_province.find('option[value="<%=entity.getV_plate_province_cd()%>"]').attr('selected','selected').trigger('liszt:updated');
		province.find('option[value="<%=entity.getProvince_cd()%>"]').attr('selected','selected').trigger('liszt:updated');		
		<%
		if(! entity.getProvince_cd().equalsIgnoreCase("")){
		%>			
			prefecture.html('<%=BmpAmphurTS.GenListAmphur(entity.getProvince_cd(), entity.getPrefecture_cd())%>').trigger('liszt:updated');
			district.html('<%=BmpTumbolTS.GenListTumbol(entity.getProvince_cd(), entity.getPrefecture_cd(), entity.getDistrict_cd())%>').trigger('liszt:updated'); 
		<%	
		}
		%>
		
		
		var tr_forewordname2 = $('#tr_forewordname2');
		$('#forewordname').change(function(){		  		
				if ($(this).val() == "4"){						
					tr_forewordname2.show();
				} 
				else{
					
					tr_forewordname2.hide();
				}	
		});	
	 if(<%=((!entity.getForewordname().equalsIgnoreCase("นาย"))&& (!entity.getForewordname().equalsIgnoreCase("นาง")) && (!entity.getForewordname().equalsIgnoreCase("นางสาว")) && (!entity.getForewordname().equalsIgnoreCase("")))%>){
		 	
		 	tr_forewordname2.show();
		 
	 }
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
	
	var cus_update = "<%=cus_update%>";
	var $form = $('#job_form');
	
	var v = $form.validate({submitHandler: function(){
			if(cus_update == "1" && $('#tax_id').val() == ""){			
					alert("โปรดระบุรหัสประจำตัวผู้เสียภาษี!"); 
					$('#tax_id').focus();
			}
			else if($('#repair_type').val() == ""){
				alert("โปรดระบุประเภทงานบริการ!"); 
				$('#repair_type').focus();
			}else if($('#mile').val() == "" &&  $('#repair_type').val() == "11"){
				alert("เลขระยะทางสามารถระบุได้สูงสุด 7 ตัวอักษร และเป็นตัวเลขเท่านั้น");
				$('#mile').focus();
			}else if($('#mile').val() == "" &&  $('#repair_type').val() == "10"){
				alert("เลขระยะทางสามารถระบุได้สูงสุด 7 ตัวอักษร และเป็นตัวเลขเท่านั้น");
				$('#mile').focus();
			}else if(!isNumber($('#mile').val()) &&  $('#repair_type').val() == "11"){
				alert("เลขระยะทางสามารถระบุเป็นตัวเลขเท่านั้น");
				$('#mile').focus();
			}
			else if(!isNumber($('#mile').val()) &&  $('#repair_type').val() == "10"){
				alert("เลขระยะทางสามารถระบุเป็นตัวเลขเท่านั้น");
				$('#mile').focus();
			}else{
				 <%
				 if(status.equalsIgnoreCase("forward")){
					 entity.setStatus(ServiceSale.STATUS_FORWARDJOB);
				  }
				 
				 if(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_FORWARDJOB)){
					 %>					 
					if (confirm('Confirm Forward Job?')) {																		 
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
					}
					
				<%
				 }else{
				 %>
					<%=(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_OPENING))?"if (confirm('Confirm Start Job?')) {":"if (confirm('Confirm Save Job?')) {"%>
	
				
							var addData = $form.serialize();
							ajax_load();
							$.post('../PartSaleManage',addData,function(resData){
								ajax_remove();
								if (resData.status == 'success') {
									
									if(cus_update == "1"){
										window.location='sv_job_description_closed.jsp?id=<%=entity.getId()%>';
									}else{
										window.location='sv_job_description.jsp?id=<%=entity.getId()%>';
									}
									
								} else {
									alert(resData.message);
								}
							},'json');
					
					<%=(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_OPENING))?"}":"}"%>
				
				<%}%>
			}			
		}	
	});
	
	$('#repair_type').change(function(){
		
		var pd="รายการสินค้า";
		var sv="ค่าบริการ";
		var psv="รายการสินค้าและค่าบริการ";
		var type = "<%=repair.getRepair_type()%>";
		
		
		
		if($('#repair_type').val() != <%=repair.getRepair_type()%>){
				
				if(type == "10"){
					alert("กรุณาตรวจสอบข้อมูล "+sv+" ก่อนเปลี่ยนประเภทงานบริการ");
				}else if (type == "11") {
					alert("กรุณาตรวจสอบข้อมูล"+psv+" ก่อนเปลี่ยนประเภทงานบริการ");
				}else if (type == "12") {
					alert("กรุณาตรวจสอบข้อมูล"+pd+" ก่อนเปลี่ยนประเภทงานบริการ");	
				}
			
		}
	});
			
	$('#update_sv').click(function(){
		 if ($('#repair_type').val() == "12") {			 //12 = ชื้อสินค้า
			 $form.submit();
		}else{
			
				 if ($('#v_plate').val() == "") { //เลขทะเบียนรถ
					alert("โปรดระบุเลขทะเบียนรถ!");
					$('#v_plate').focus();
				 }else 
					 if ($('#v_plate_province').val() == "") { //จังหวัดทะเบียนรถ
						alert("โปรดเลือกจังหวัด!");
						$('#v_plate_province').focus();
					
					}else 
						if ($('#forewordname').val() == "4") { //คำนำหน้าชื่อ
							if ($('#title_name').val() == "") { //คำนำหน้าชื่อ อื่นๆ
								alert("โปรดระบุคำนำหน้าชื่อ");
								$('#title_name').focus();
							
							}else 
								if ($('#cus_name').val() == "") { //ชื่อลูกค้า
									alert("โปรดระบุชื่อลูกค้า!");
									$('#cus_name').focus();
								
								 }else{
									 $form.submit();
								 }
								
						}else{
							if ($('#forewordname').val() == "") { //คำนำหน้าชื่อ
								alert("โปรดเลือกคำนำหน้าชื่อ");
								$('#forewordname').focus();
							
							}else 
								if ($('#cus_name').val() == "") { //ชื่อลูกค้า
								alert("โปรดระบุชื่อลูกค้า!");
								$('#cus_name').focus();
								
								 }else{
									 $form.submit();
								 }
						}  
				 
				
		} 		
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
					<legend><Strong>ข้อมูลลูกค้า</Strong></legend>
						<div class="left " style="width:450px;">																
							<table class="s_auto " cellspacing="5" width="100%">
								<tbody>
									<tr>
										<th width="34%"></th>
										<th width="66%"></th>
									</tr>
									<tr>
											<td> <Strong>เลขทะเบียนรถ</Strong></td>
											<td>:  
											
											<input type="text" class="txt_box s100 " name="v_plate" id="v_plate" maxlength="10" value="<%=entity.getV_plate()%>" title="โปรดระบุเลขทะเบียนรถ!" /> 
											<font color="red">*</font> 
											</td>
									</tr>
									<tr>
										<td > <Strong>จังหวัดทะเบียนรถ</Strong></td>
										<td>: 
												<select name="v_plate_province"  class="txt_box s150 "  id="v_plate_province" title="โปรดเลือกจังหวัด!">
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
											<bmp:ComboBox name="brand_id" styleClass="txt_box s200" width="150px" listData="<%=Brands.ddl()%>" validate="true"   value="<%=entity.getBrand_id()%>">
												<bmp:option value="" text="--- เลือก Brand ---"></bmp:option>
											</bmp:ComboBox>
											<!-- <font color="red">*</font> -->
										</td>
									</tr>	
									<tr>
										<td> <Strong>รุ่น</Strong></td>
										<td>: 
											<bmp:ComboBox name="model_id" styleClass="txt_box s200" width="150px" validate="true" listData="<%=Models.selectDDL(entity.getBrand_id())%>" value="<%=entity.getModel_id()%>">
												<bmp:option value="" text="--- เลือก Model ---"></bmp:option>
											</bmp:ComboBox>
										<!-- <font color="red">*</font> -->
										</td>
									</tr>
									<tr >
										<td valign="top"> <Strong>คำนำหน้าชื่อ</Strong></td> 
										<td valign="top">: 
										   <select name="forewordname" id="forewordname" class="txt_box s150 " value="<%=entity.getForewordname() %>">
										   <option value="">--- เลือกคำนำหน้าชื่อ ---</option>
											<option value="นาย"  <%=(entity.getForewordname().equalsIgnoreCase("นาย"))? "selected":""%> >นาย</option>
											<option value="นาง" <%=(entity.getForewordname().equalsIgnoreCase("นาง"))? "selected":""%>>นาง</option>
											<option value="นางสาว" <%=(entity.getForewordname().equalsIgnoreCase("นางสาว"))? "selected":""%>>นางสาว</option>
											<option value="4" <%=((!entity.getForewordname().equalsIgnoreCase("นาย"))&& (!entity.getForewordname().equalsIgnoreCase("นาง")) && (!entity.getForewordname().equalsIgnoreCase("นางสาว")) && (!entity.getForewordname().equalsIgnoreCase("")))? "selected":""%>>อื่น ๆ</option>											
										    </select>
											<font color="red">*</font>
										</td>
									</tr>
									<tr id="tr_forewordname2" class="hide">
										<td valign="top">  <!-- <Strong>คำนำหน้าชื่อ</Strong> --> </td> 
										<td valign="top">:
											<input type="text" class="txt_box s180 " name="title_name" id="title_name"  value="<%=entity.getForewordname()%>" title="โปรดเลือกคำนำหน้าชื่อ" /> 
											<font color="red">*</font> 
										</td>
									</tr>
									<tr>
										<td valign="top"> <Strong>ชื่อลูกค้า</Strong></td> 
										<td valign="top">: 
											<input type="text" class="txt_box s180  " name="cus_name" id="cus_name" value="<%=entity.getCus_name()%>" title="โปรดระบุชื่อลูกค้า!" /> 
										<font color="red">*</font>
										</td>
									</tr>
									<tr>
										<td valign="top"> <Strong>นามสกุล</Strong></td>
										<td valign="top">: 
											<input type="text" class="txt_box s180  " name="cus_surname" id="cus_surname" value="<%=entity.getCus_surname()%>"  /> 
											
										</td>
									</tr> 
									<tr>
										<td valign="top"> <Strong>รหัสประจำตัวผู้เสียภาษี</Strong></td>
										<td valign="top">: 
											<input type="text" class="txt_box s180  " name="tax_id" id="tax_id" 	value="<%=entity.getTax_id() %>"  /> 
	
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
															<th width="34%"></th>
															<th width="66%"></th>
												   		</tr>				
														<tr>
															<td valign="top"> <Strong>บ้านเลขที่</Strong></td>
															<td valign="top">: 
																<input type="text" class="txt_box s70  " name="addressnumber" id="addressnumber" 	value="<%=entity.getAddressnumber() %>" title="***" /> 
																
															</td>
														</tr> 
														<tr>
															<td valign="top"> <Strong>หมู่บ้าน</Strong></td>
															<td valign="top">: 
																<input type="text" class="txt_box s180" name="villege" id="villege" 	value="<%=entity.getVillege() %>" title="***" /> 
																
															</td>
														</tr> 
														<tr>
															<td valign="top"> <Strong>หมู่ที่</Strong></td>
															<td valign="top">: 
																<input type="text" class="txt_box s70" name="moo" id="moo" 	value="<%=entity.getMoo() %>" title="***" /> 
																
															</td>
														</tr> 
														<tr>
															<td valign="top"> <Strong>ถนน</Strong></td>
															<td valign="top">: 
																<input type="text" class="txt_box s180  " name="road" id="road" 	value="<%=entity.getRoad() %>" title="***" /> 
																
															</td>
														</tr> 
														<tr>
															<td valign="top"> <Strong>ซอย</Strong></td>
															<td valign="top">: 
																<input type="text" class="txt_box s70  " name="soi" id="soi" 	value="<%=entity.getSoi() %>" title="***" /> 
																
															</td>
														</tr> 
														
														<tr>			
														<td valign="top"><Strong>จังหวัด</Strong></td>
															<td valign="top">: 																
																<select  data-placeholder="เลือกจังหวัด..." class="txt_box s180 " style="max-width: 350px;" id="province_" name=province tabindex="12" >
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
																
																
																<font color="red">*</font>
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
																<option value="" bmp_tum_name="" >ลือกตำบล/แขวง...</option>
																</select>
															</td>														
															
														</tr> 
														<tr>
															<td valign="top"> <Strong>รหัสไปรษณีย์</Strong></td>
															<td valign="top">: 
																<input type="text" class="txt_box s100" name="postalcode" id="postalcode" onkeyup='checkNumber_postalcode(this)' maxlength="5"	value="<%=entity.getPostalcode() %>" title="***" /> 
															</td>
														</tr> 
														<tr>
															<td valign="top"> <Strong>เบอร์โทรศัพท์</Strong></td>
															<td valign="top">: 
																<input type="text" class="txt_box s100  " onkeyup='checkNumber_phonenumber(this)' name="phonenumber" id="phonenumber" maxlength="20"	value="<%=entity.getPhonenumber() %>" title="***" /> 
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
											<td width="50%"><input type="text" class="txt_box s150" name="driven_by" autocomplete="off" value="<%=status.equalsIgnoreCase("forward")?"":((repair.getDriven_by().length()>0)?repair.getDriven_by():entity.getCus_name())%>"></td>
										</tr>
										<tr>
											<td><label title="เบอร์โทรศัพท์"><Strong>เบอร์โทรศัพท์</Strong></label></td>
											<td>:</td>
											<td><input type="text" class="txt_box s150" name="driven_contact" autocomplete="off" onkeyup='checkNumber_driven_contact(this)' value="<%=repair.getDriven_contact()%>"  maxlength="20"></td>
										</tr>
										<tr>
											<td><label title="ลักษณะการรับบริการ"><Strong>ประเภทงานบริการ</Strong></label></td>
											<td>:</td>
											<td>
											<bmp:ComboBox name="repair_type" listData="<%=ServiceRepair.ddl_repair_type_th()%>" value="<%=repair.getRepair_type()%>" styleClass="txt_box s150"></bmp:ComboBox>
										<font color="red">*</font>
										</td>
										</tr>
										<tr>
											<td><label title="เลขไมล์"> <Strong>เลขไมล์</Strong></label></td>
											<td>:</td>
											<td>
												<input type="text" class="txt_box s150 required" title="โปรดระบุเลขไมล์!" autocomplete="off" onkeyup='checkNumber_mile(this)' name="mile" value="<%=status.equalsIgnoreCase("forward")?"":repair.getMile()%>" maxlength="7" id="mile" >
												<font color="red">*</font>
												<br/>
												<font color="red">( ใส่เป็นตัวเลขเท่านั้น )</font>
											</td>
										</tr>
										<tr>
											<td><label title="กำหนดส่งรถคืน"><Strong>ซ่อมเสร็จวันที่</Strong></label></td>
											<td>:</td>
											<td><input type="text" class="txt_box s150 required" autocomplete="off" name="due_date" id="due_date" value="<%=status.equalsIgnoreCase("forward")?"":WebUtils.getDateValue(repair.getDue_date())%>" readonly="readonly" title="โปรดระบุวันที่ซ่อมเสร็จ"/> <font color="red">*</font> </td>
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
											<textarea class="txt_box s350 required"  rows="5" cols="15" name="problem" id="problem" title="โปรดระบุบริการที่ร้องขอ!" ><%=status.equalsIgnoreCase("forward")?"":repair.getProblem()%></textarea>
											 <font color="red">*</font>
										</td>
									</tr>
									<tr>
										<td><label title="หมายเหตุ"><Strong>หมายเหตุ</Strong></label></td>
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
							<button type="button" class="btn_box btn_confirm" id="update_sv"><%=(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_OPENING))?"Start Job":"Save"%></button>
							<% } %>
									<input type="hidden" name="status" value="<%=(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_OPENING))?ServiceSale.STATUS_MA_REQUEST:entity.getStatus()%>">
								
						 	<%if(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_MA_REQUEST) || entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_OUTSOURCE)){ %>
									<input type="hidden" name="status" value="<%=(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_OPENING))?ServiceSale.STATUS_MA_REQUEST:entity.getStatus()%>">
									<button type="button" class="btn_box btn_confirm" id="update_sv"><%=(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_OPENING))?"Start Job":"Save Job"%></button>
							<%}%>	
							<%
							if(cus_update.equalsIgnoreCase("1")){
							%>
							<button type="button" class="btn_box btn_confirm" id="update_sv"><%=(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_OPENING))?"Start Job":"Save"%></button>
							<% } %>		
							
							<%
							if(status.equalsIgnoreCase("forward")){
							%>
							
							<button type="button" class="btn_box btn_confirm" id="update_sv">Forward Job</button>
							<input type="hidden" name="action" value="create_sale_order_forward">
							<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
							
							<% }else{ %>		
							<input type="hidden" name="id" value="<%=entity.getId()%>">
							<input type="hidden" name="flag" value="<%=RepairLaborTime.STATUS_CS%>">
							<input type="hidden" name="action" value="update_service_repair">
							<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
							<% } %>		
						
						
						</div>
				</form>
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>