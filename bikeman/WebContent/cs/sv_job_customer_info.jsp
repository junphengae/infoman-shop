<%@page import="sun.awt.SunHints.Value"%>
<%@page import="com.bitmap.bean.sale.Models"%>
<%@page import="com.bitmap.bean.sale.Brands"%>
<%@page import="com.bitmap.bean.sale.VehicleMaster"%>
<%@page import="com.bitmap.bean.sale.Vehicle"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
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
<%
Customer entity = new Customer();
WebUtils.bindReqToEntity(entity, request);
Customer.select(entity);

%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Customer Information: <%=entity.getCus_name_th() + " " + entity.getCus_surname_th()%></title>
<script type="text/javascript">
$(function(){
	var vspec = $('#tbody_vspec');
	
	$('#brand').change(function(){
		if ($(this).val() != '') {
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
		} else {
			var options = '<option value="">---Choose Model---</option>';
			$('#model').html(options);
		}
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
	
	var $form = $('#vehicle_add');
	$('#btnAdd').click(function(){
		if ($('#master_id').val() != '') {
			$form.submit();
		}
	});
	
	var v = $form.validate({
		submitHandler: function(){
			var addData = $form.serialize();
			ajax_load();
			$.post('../VehicleManage',addData,function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location='sv_job_create.jsp?cus_id=<%=entity.getCus_id()%>';
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
	
	<div class="wrap_body">
		<div class="m_top15"></div>
		<div class="body_content">
			<div class="content_head">
				<div class="left">Customer ID: <%=entity.getCus_id() %></div>
				<div class="right">
					<%-- <button class="btn_box" onclick="window.location='<%=LinkControl.link("sv_job_customer_search.jsp", (List)session.getAttribute("SV_CUS_SEARCH"))%>';">Back</button> --%>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				
				<fieldset class="fset s350 left h300">
					<legend>Owner Information</legend>
					
					<table class="s_auto" cellspacing="5" cellpadding="5">
						<tbody>
							<tr>
								<td width="40%"><label>ID CARD</label></td>
								<td width="60%">: <%=entity.getCus_id_card()%></td>
							</tr>
							<tr>
								<td><label>Name</label></td>
								<td>: <%=entity.getCus_name_th()%></td>
							</tr>
							<tr>
								<td><label>Surname</label></td>
								<td>: <%=entity.getCus_surname_th()%></td>
							</tr>
							<tr>
								<td><label>Sex</label></td>
								<td>: <%=(entity.getCus_sex().equalsIgnoreCase("m"))?"Male":"Female"%></td>
							</tr>
							<tr>
								<td><label>Address</label></td>
								<td>: <%=entity.getCus_address()%></td>
							</tr>
							<tr>
								<td><label>Mobile</label></td>
								<td>: <%=entity.getCus_mobile()%></td>
							</tr>
							<tr>
								<td><label>Phone</label></td>
								<td>: <%=entity.getCus_phone()%></td>
							</tr>
							<tr>
								<td><label>Email</label></td>
								<td>: <%=entity.getCus_email()%></td>
							</tr>
							<tr>
								<td><label>Birthdate</label></td>
								<td>: <%=WebUtils.getDateValue(entity.getCus_birthdate())%></td>
							</tr>
							<tr>
								<td colspan="2" height="30" align="center" valign="bottom">
									<button type="button" class="btn_box thickbox btn_confirm" title="Update Customer Information"  lang="customer_edit.jsp?cus_id=<%=entity.getCus_id()%>">Update</button>
								</td>
							</tr>
						</tbody>
					</table>
					
				</fieldset>			
			
				
				<fieldset class="fset s550 right minh300">
					<legend>Add New Car</legend>
				
					<form id="search_form" onsubmit="return false;">
						<div>
							<input type="hidden" name="action" value="get_vspec">
							Brand:
							<bmp:ComboBox name="brand" styleClass="txt_box s120" validate="true" validateTxt="*" listData="<%=Brands.ddl() %>">
								<bmp:option value="" text="--Choose Brand--"></bmp:option>
							</bmp:ComboBox> 
							
							Model:
							<bmp:ComboBox name="model" styleClass="txt_box s120" validate="true" validateTxt="*" >
								<bmp:option value="" text="--Choose Model--"></bmp:option>
							</bmp:ComboBox> 
							
						
								<button class="btn_box btn_add" onclick="window.location='sv_job_spec_add.jsp?cus_id=<%=entity.getCus_id()%>'">Create Vehicle Spec</button>
						</div>
					</form>
					
					<table class="bg-image s_auto">
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
					
					<form id="vehicle_add" onsubmit="return false;">
						
						<table class="s_auto" cellspacing="5" cellpadding="5">
							<tbody>
								<tr>
									<td align="left" width="30%">Brand</td>
									<td width="70%">: <img id="img_brand"></td>
								</tr>
								<tr>
									<td>Model</td>
									<td>: <span id="brand_detail"></span></td>
								</tr>
								<tr>
									<td>Plate</td>
									<td>: <input type="text" autocomplete="off" name="license_plate" id="license_plate" class="txt_box s200"></td>
								</tr>
								<tr>
									<td>Engine NO.</td>
									<td>: <input type="text" autocomplete="off" name="engine_no" id="engine_no" class="txt_box s200 required" title="*"></td>
								</tr>
								<tr>
									<td>VIN.</td>
									<td>: <input type="text" autocomplete="off" name="vin" id="vin" class="txt_box s200 required" title="*"></td>
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
										<input type="button" id="btnAdd" value="Submit" class="btn_box btn_confirm">
										<input type="hidden" name="action" value="select_vehicle">
										<input type="hidden" name="cus_id" value="<%=entity.getCus_id()%>">
										<input type="hidden" name="master_id" id="master_id" value="">
										<input type="hidden" name="create_by" id="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
									</td>
								</tr>
							</tbody>
						</table>
					</form>
				</fieldset>
				<div class="clear"></div>
					<fieldset class="fset m_top20" style="width: 940px;">
					<legend>Vehicle List</legend>
					<table class="bg-image s_auto" style="margin-top: 10px;">
						<thead>
							<tr>
								<th align="center" width="10%">Brand</th>
								<th align="center" width="30%">Model</th>
								<th align="center" width="40%">Plate</th>
								<th align="center" width="15%">&nbsp;</th>
							</tr>
						</thead>
						<tbody>
							<%
							Iterator iteVehicle = Vehicle.selectByCusID(entity.getCus_id()).iterator();
							while (iteVehicle.hasNext()) {
								Vehicle vehicle = (Vehicle) iteVehicle.next();
								VehicleMaster vmaster = vehicle.getUIMaster();
							%>
							<tr>
								<td align="center"><img src="../../images/motoshop/car_logo/40x27/<%=vmaster.getBrand()%>.gif"></td>
								<td><%=vmaster.getUIModel() %> <%=vmaster.getNameplate()%></td>
								<td><%=vehicle.getLicense_plate()%></td>
								<td align="center">
									<a class="btn_view thickbox" title="Vehicle Information" lang="vehicle_info_popup.jsp?vid=<%=vehicle.getId()%>&master_id=<%=vmaster.getId()%>&width=500&height=220"></a>
									<a class="btn_update thickbox" title="Update Vehicle Information" lang="vehicle_edit.jsp?vid=<%=vehicle.getId()%>&cus_id=<%=entity.getCus_id()%>&master_id=<%=vmaster.getId()%>&width=500&height=220"></a>
								</td>
							</tr>
								
							<%
							} 
							%>
						</tbody>
					</table>
					
				</fieldset>
				<center>
				<br>
			
				<button class="btn_box btn_warn" id="" onclick="tb_remove();" type="button">Close</button>
				</center>
				<div class="clear"></div>
					
			</div>
		</div>
	</div>	
</div>
</body>
</html>