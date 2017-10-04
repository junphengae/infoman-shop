<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.bean.parts.ServiceSale"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="com.bitmap.security.SecurityUser"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
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
<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
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
<title>Service Job: Create Job</title>
<% String cus_id =WebUtils.getReqString(request,"cus_id"); %>
<script type="text/javascript">
$(function(){
	if ($('#cus_name').val() == '') {
		$('#cus_id').val('');
		$('#v_plate').val('');
		$('#v_plate_blank').val('');
	}
	$("#cus_name").focus();
	$("#cus_name").autocomplete({
	    source: "../GetCustomer",
	    minLength: 2,
	    select: function(event, ui) {
	      	$('#cus_id').val(ui.item.id);
	    	getVehicle(ui.item.id);
	    },
	    search: function(event, ui){
	   		$('#cus_id').val('');
	   		$('#v_plate').val('');
	    }
	});
	
	$('#submit').click(function(){
		
		if ($("#cus_name").val().length>1) {
			ajax_load();
			$.post('../PartSaleManage',$('#cus_form').serialize(),function(json){
				ajax_remove();
				if (json.status == 'success') {
					window.location='sv_job_update.jsp?id=' + json.id;
				} else {
					alert(json.message);
				}
			},'json');
		} else {
			alert("Select Customer Name");
			$("#cus_name").focus();
		}
	});
	
	$('#v_plate_blank').blur(function(){
		$('#v_plate').val($(this).val());
	});
});

function getVehicle(cus_id){
	$.post('../VehicleManage',{'action':'get_vehicle','cus_id':cus_id},function(json){
		if (json.status == 'success') {
			var vhc = json.vehicle;
			var html = '';
			for ( var i = 0; i < vhc.length; i++) {
				html += '<tr>'+
							'<td>'+ 
								'<input type=\"radio\" name=\"v_id\" id=\"input_' + vhc[i].id + '\" value=\"' + vhc[i].id + '\" onclick=\"select_plate(\'' + vhc[i].license_plate + '\');\">'+
								'<label for=\"input_' + vhc[i].id + '\">&nbsp;&nbsp;' + vhc[i].license_plate + '</label>'+
							'</td>'+
							'<td align=\"center\">'+
								'<img src=\"../../images/motoshop/car_logo/40x27/' + vhc[i].UIMaster.brand + '.gif\">'+
							'</td>'+
						'</tr>';
			}
			$('#vehicle_show').html(html);
		} else {
			alert(json.message);
		}
	},'json');
}

function select_plate(txt){
	$('#v_plate').val(txt);
	$('#v_plate_blank').attr('disabled','disabled');
}

function custom_plate(){
	$('#v_plate_blank').removeAttr('disabled');
	$('#v_plate').val($('#v_plate_blank').val());
}

<% 
String langs ="";
if(!cus_id.equalsIgnoreCase(""))
{
%>
	getVehicle('<%=cus_id%>');
<%
langs = "sv_job_customer_info.jsp?width=1000&height=600&cus_id="+cus_id;
}
%>
//
</script>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Service Job &gt; Create Job</div>
				<div class="right">
					<button class="btn_box" onclick="window.location='<%=LinkControl.link("sv_job_manage.jsp", (List)session.getAttribute("CS_ORDER_SEARCH"))%>';">Back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
			
				<fieldset class="fset">
					<legend>Customer Detail</legend>
					<form id="cus_form" onsubmit="return false;">
					<table class="s_auto">
						<tbody>
							<tr>
								<td width="15%"><label title="ชื่อลูกค้า">Customer Name</label></td>
								<td width="85%">: 
									<input type="text" class="txt_box s200" name="cus_name" autocomplete="off" id="cus_name" value="<%=Customer.selectName(cus_id)%>">
									<input type="hidden" name="cus_id" id="cus_id" value="<%=cus_id%>"> 
									<button class="btn_search btn_box" onclick="popup('sv_job_customer_search.jsp');">search</button> 
									<label title="สามารถพิมพ์ตั้งแต่ 2 ตัวอักษรขึ้นไปเพื่อค้นหา หรือกดปุ่ม Search" class="txt_12">(Type or click search button for search customer)</label>
								</td>
							</tr>
						
							<tr valign="top">
								<td><label title="ทะเบียนรถ">Vehicle Plate</label></td>
								<td valign="top">
								<div class="left">: 
									<button id="bt" class="btn_add btn_box thickbox" lang="<%=langs%>">Add Car</button>
									<input type="hidden" id="v_plate" name="v_plate" />
								</div>
									
									<div class="clear"></div>
									<div class="left m_left5" >
										<table class="bg-image s400" align="left">
											 <tbody>
											<!-- 	<tr>
													<td width="70%">
														<input name="v_id" id="input_blank" value="" onclick="custom_plate();" type="radio" checked="checked">
														<label title="กำหนดเอง" for="input_blank">&nbsp;Customized</label> 
														<input type="text" id="v_plate_blank" name="v_plate_blank" class="txt_box s120">
													
													</td>
													<td width="30%">
														
													</td>
												</tr> -->
											</tbody> 
											
											<tbody id="vehicle_show">
												
											</tbody>
										
										</table>
									</div>
									<div class="clear"></div>
								</td>
							</tr>
							<tr>
								<td colspan="2" height="25"><div class="dot_line"></div></td>
							</tr>
							<tr>
								<td colspan="2" align="center">
									<button type="button" id="submit" class="btn_box btn_confirm">Submit</button>
									<input type="hidden" name="action" value="create_sale_order">
									<input type="hidden" name="service_type" value="<%=ServiceSale.SERVICE_MA%>">
									<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
								</td>
							</tr>
						</tbody>
					</table>
					</form>
				</fieldset>
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>