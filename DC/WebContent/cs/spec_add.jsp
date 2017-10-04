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
<title>Add New Brochure</title>


<script type="text/javascript">
$(function(){
	
	$('#brand').change(function(){
		ajax_load();
		$.post('../GetModel',{brand: $(this).val(),action:'get_model'}, function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				var options = '<option value="">---Choose Model---</option>';
                var j = resData.model;
	            for (var i = 0; i < j.length; i++) {
	                options += '<option value="' + j[i].model_id + '">' + j[i].model_name + '</option>';
	            }
             	$('#model').html(options);
             	/* $('#sub_cat_id').html('<option value="">--- เลือกชนิดย่อย ---</option>'); */
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
			$('#btnAdd').attr('disabled',true);
			ajax_load();
			$.post('../VehicleManage',addData,function(resData){
				ajax_remove();
				$('#btnAdd').attr('disabled',false);
				if (resData.status == 'success') {
					//$msg.text('Success').show().delay(500).queue(function(){window.location = "customer_info.jsp?cus_id=" + resData.cus_id;$(this).dequeue();});
					$msg.text('Success').show().delay(500).queue(function(){window.location = "vehicle_spec_manage.jsp";});
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
</script>

</head>

<body> 

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Create New Vehicle Spec</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<form id="infoForm" onsubmit="return false;" style="margin: 0;padding: 0;">
				<input type="hidden" name="create_by" id="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
					<table cellpadding="3" cellspacing="3" border="0" class="center s550">
					<tbody>
						
						<tr>
							<td align="left" width="25%">Brand</td>
							<td align="left" width="75%">:
								<bmp:ComboBox name="brand" styleClass="txt_box s150" validate="true" validateTxt="*" listData="<%=Brands.ddl() %>">
									<bmp:option value="" text="--Choose Brand--"></bmp:option>
								</bmp:ComboBox>
								<script type="text/javascript">										
									$('#brand').change(function(){
										if($(this).val() != "") {
											$('#new_model').fadeIn(500).attr('lang','../sale/model_new.jsp?height=300&width=520&brand_id=' + $(this).val());
											$('#edit_model').hide();
										} else {
											$('#new_model').hide();
										}
									});
								</script>
							</td>
						</tr>
						<tr>
							<td>Model</td>
							<td>:
								<bmp:ComboBox name="model" styleClass="txt_box s150" validate="true" validateTxt="*" >
									<bmp:option value="" text="--Choose Model--"></bmp:option>
								</bmp:ComboBox>
								<input type="button" class="btn_box thickbox hide" id="new_model" value="Add Model" lang="" title="Add New Model">
								<input type="button" class="btn_box thickbox hide" id="edit_model" value="Edit Model" lang="" title="Edit Model">
								<script type="text/javascript">										
									$('#model').change(function(){
										if($(this).val() != "") {
											$('#edit_model').fadeIn(500);
											var attr = '../sale/model_edit.jsp?height=300&width=520&model_id=' + $(this).val() + '&brand_id=' + $('#brand').val();
											$('#edit_model').attr('lang',attr);
										} else {
											$('#edit_model').hide();
										}
									});
								</script>			
							</td>
						</tr>
						<tr>
							<td>Name Plate</td>
							<td>: <input type="text" autocomplete="off" name="nameplate" id="nameplate" class="txt_box s200"></td>
						</tr>
						<tr>
							<td>Year</td>
							<td>: <input type="text" autocomplete="off" name="year" id="year" class="txt_box s200"></td>
						</tr>
						<tr>
							<td>Engine</td>
							<td>: <input type="text" autocomplete="off" name="engine" id="engine" class="txt_box s200"></td>
						</tr>
						<tr>
							<td>CC</td>
							<td>: <input type="text" autocomplete="off" name="engine_cc" id="engine_cc" class="txt_box s200"></td>
						</tr>
						<tr>
							<td>Horse Power</td>
							<td>: <input type="text" autocomplete="off" name="horsepower" id="horsepower" class="txt_box s200"></td>
						</tr>
						<tr>
							<td>Torque</td>
							<td>: <input type="text" autocomplete="off" name="torque" id="torque" class="txt_box s200"></td>
						</tr>
						<tr>
							<td>Transmission</td>
							<td>: <input type="text" autocomplete="off" name="transmission" id="transmission" class="txt_box s200"></td>
						</tr>
						<tr>
							<td>Brake (Front)</td>
							<td>: <input type="text" autocomplete="off" name="brake_front" id="brake_front" class="txt_box s200"></td>
						</tr>
						<tr>
							<td>Brake (Rear)</td>
							<td>: <input type="text" autocomplete="off" name="brake_rear" id="brake_rear" class="txt_box s200"></td>
						</tr>
						<tr>
							<td>Length</td>
							<td>: <input type="text" autocomplete="off" name="d_length" id="d_length" class="txt_box s200"></td>
						</tr>
						<tr>
							<td>Width</td>
							<td>: <input type="text" autocomplete="off" name="d_width" id="d_width" class="txt_box s200"></td>
						</tr>
						<tr>
							<td>Height</td>
							<td>: <input type="text" autocomplete="off" name="d_height" id="d_height" class="txt_box s200"></td>
						</tr>
						<tr>
							<td>Wheel Base</td>
							<td>: <input type="text" autocomplete="off" name="d_wheelbase" id="d_wheelbase" class="txt_box s200"></td>
						</tr>
						<tr>
							<td>Note</td>
							<td>: <input type="text" autocomplete="off" name="note" id="note" class="txt_box s200"></td>
						</tr>
						<tr align="center" valign="bottom" height="30">
							<td colspan="2">
								<input type="submit" id="btnAdd" value="Submit" class="btn_box">
								<input type="hidden" name="action" value="brochure_add">
								<input type="reset" onclick="javascript: history.back();" value="Back" class="btn_box">
							</td>
						</tr>
					</tbody>
				</table>
				<div class="msg_error"></div>
				</form>
			
			
			</div>
		</div>
	</div>
</div>









<div>

</div>
</body>
</html>