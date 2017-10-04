<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.sale.Brands"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html> 
<head>
<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/clear_form.js"></script>
<script src="../js/popup.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="../js/jquery.metadata.js"></script>
<script type="text/javascript" src="../js/jquery.validate.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

 
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Create New Vehicle</title>


<script type="text/javascript">
$(function(){
	var vspec = $('#tbody_vspec');
	
	$('#brand').change(function(){
		ajax_load();
		$.post('../GetModel',{brand: $(this).val(),action:'get_model'}, function(resData){
			if (resData.status == 'success') {
				var options = '<option value="">---Choose Model---</option>';
                var j = resData.model;
	            for (var i = 0; i < j.length; i++) {
	                options += '<option value="' + j[i].model_id + '">' + j[i].model_name + '</option>';
	            }
             	$('#model').html(options);
			} else {
				alert(resData.message);
			}
        },'json');
		
		
		$.post('../VehicleManage',$('#search_form').serialize(),function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				var html = '';
				var specs = resData.spec;
				for ( var i = 0; i < specs.length; i++) {
					var spec = specs[i];
					html +=
						'<tr>' +
							'<td align="center"><img src="../../images/motoshop/car_logo/40x27/' + spec.brand + '.gif"></td>' +
							'<td>' + spec.UIModel + ' ' + spec.nameplate + '</td>' +
							'<td>' + spec.year + '</td>' +
							'<td align="center">' +
								'<button class="btn_box btn_confirm" onclick="select(\'' + spec.id + '\',\'' + spec.UIBrand + '\',\''+ spec.UIModel + ' ' + spec.nameplate + '\');">Select</button>' + 
							'</td>' +
						'</tr>';
				}
				$.bind(html);
				vspec.html(html);
			} else {
				alert(resData.message);
			}
		},'json');
	});
	
	$('#model').change(function(){
		$.post('../VehicleManage',$('#search_form').serialize(),function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				var html = '';
				var specs = resData.spec;
				for ( var i = 0; i < specs.length; i++) {
					var spec = specs[i];
					html +=
						'<tr>' +
							'<td align="center"><img src="../../images/motoshop/car_logo/40x27/' + spec.brand + '.gif"></td>' +
							'<td>' + spec.UIModel + ' ' + spec.nameplate + '</td>' +
							'<td>' + spec.year + '</td>' +
							'<td align="center">' +
								'<button class="btn_box btn_confirm" onclick="select(\'' + spec.id + '\',\'' + spec.brand + '\',\''+ spec.UIModel + ' ' + spec.nameplate + '\');">Select</button>' + 
							'</td>' +
						'</tr>';
				}
				$.bind(html);
				vspec.html(html);
			} else {
				alert(resData.message);
			}
		},'json');
	});
		
	var $msg = $('.msg_error');
	var $form = $('#infoForm');
	
	$.metadata.setType("attr", "validate");

	var v = $form.validate({
		submitHandler: function(){
			var addData = $form.serialize();
			//$('#btnAdd').attr('disabled',true);
			ajax_load();
			$.post('../VehicleManage',addData,function(resData){
				ajax_remove();
				//$('#btnAdd').attr('disabled',false);
				if (resData.status == 'success') {
					//$msg.text('Success').show().delay(500).queue(function(){window.location = "customer_info.jsp?cus_id=" + resData.cus_id;$(this).dequeue();});
					$msg.text('Success').show().delay(500).queue(function(){window.location = "<%=LinkControl.link("vehicle_manage.jsp", (List)session.getAttribute("VEHICLE_SEARCH"))%>";});
				} else {
					alert(resData.message);
				}
			},'json');
		}
	});
	
	$form.submit(function(){
		v;
		return false;
	});
});

function select(id,uibrand,detail){
	$('#master_id').val(id);
	$('#brand_detail').text(detail);
	$('#img_brand').attr('src','../../images/motoshop/car_logo/40x27/' + uibrand + '.gif').show();
}
</script>

</head>

<body> 

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Create New Vehicle</div>
				<div class="right">
					<button class="btn_box" onclick="history.back();">&lt;&lt; Back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<fieldset class="fset s350 left">
					<legend>Vehicle Information</legend>
					<form id="infoForm" onsubmit="return false;" style="margin: 0;padding: 0;">
						<input type="hidden" name="master_id" id="master_id" value="">
						<input type="hidden" name="create_by" id="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
						<div class="center txt_center">
							<img id="img_brand">
							<span id="brand_detail"></span>
						</div>
						<table cellpadding="3" cellspacing="3" border="0" class="center s_auto">
							<tbody>
								<tr>
									<td align="left" width="30%">Plate</td>
									<td width="70%">: <input type="text" autocomplete="off" name="license_plate" id="license_plate" class="txt_box s200"></td>
								</tr>
								<tr>
									<td>Engine NO.</td>
									<td>: <input type="text" autocomplete="off" name="engine_no" id="engine_no" class="txt_box s200"></td>
								</tr>
								<tr>
									<td>VIN.</td>
									<td>: <input type="text" autocomplete="off" name="vin" id="vin" class="txt_box s200"></td>
								</tr>
								<tr>
									<td>Color</td>
									<td>: <input type="text" autocomplete="off" name="color" id="color" class="txt_box s200"></td>
								</tr>
								<tr>
									<td>Note</td>
									<td>: <input type="text" autocomplete="off" name="note" id="note" class="txt_box s200"></td>
								</tr>
								<tr align="center" valign="bottom" height="30">
									<td colspan="2">
										<input type="submit" id="btnAdd" value="Submit" class="btn_box">
										<input type="hidden" name="action" value="select_vehicle">
										<input type="reset" onclick="javascript: history.back();" value="Back" class="btn_box">
									</td>
								</tr>
							</tbody>
						</table>
						<div class="msg_error"></div>
					</form>
				</fieldset>
				
				<fieldset class="fset s550 right">
					<legend>Vehicle Spec Search</legend>
					<form id="search_form" onsubmit="return false;">
						<input type="hidden" name="action" value="get_vspec">
						<table cellpadding="3" cellspacing="3" border="0" class="center s_auto" id="tb_select">
							<tbody>
								<tr>
									<td align="left" width="20%">Brand</td>
									<td align="left" width="80%">:
										<bmp:ComboBox name="brand" styleClass="txt_box s150" validate="true" validateTxt="*" listData="<%=Brands.ddl() %>">
											<bmp:option value="" text="--Choose Brand--"></bmp:option>
										</bmp:ComboBox>
									</td>
								</tr>
								<tr>
									<td>Model</td>
									<td>:
										<bmp:ComboBox name="model" styleClass="txt_box s150" validate="true" validateTxt="*" >
											<bmp:option value="" text="--Choose Model--"></bmp:option>
										</bmp:ComboBox>
									</td>
								</tr>
							</tbody>
						</table>
					</form>
					
					<table class="bg-image s_auto" id='tb_show'>
						<thead>
							<tr>
								<th valign="top" align="left" width="20%">Brand</th>
								<th valign="top" align="left" width="40%">Model</th>
								<th valign="top" align="left" width="20%">Year</th>
								<th valign="top" align="right" width="20%"></th>
							</tr>
						</thead>
						<tbody id="tbody_vspec">
						
						</tbody>
					</table>
				</fieldset>
				
				<div class="clear"></div>
				
			</div>
		</div>
	</div>
</div>









<div>

</div>
</body>
</html>