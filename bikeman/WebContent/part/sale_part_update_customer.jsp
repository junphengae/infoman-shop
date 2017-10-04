<%@page import="com.bitmap.bean.sale.Vehicle"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.parts.ServiceSale"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%
	ServiceSale entity = new ServiceSale();
WebUtils.bindReqToEntity(entity, request);
ServiceSale.select(entity);
%>
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
	   		$('#vehicle_show').html('');
	    }
	});
	
	$('#submit').click(function(){
		if ($("#cus_name").val() != '') {
			ajax_load();
			$.post('../PartSaleManage',$('#cus_form').serialize(),function(json){
				ajax_remove();
				if (json.status == 'success') {
					window.location.reload();
				} else {
					alert(json.message);
				}
			},'json');
		} else {
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
</script>

<form id="cus_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%"  class="center" id="tb_material_add" border="0" >
		<tbody>
			<tr>
				<td width="15%"><label title="ชื่อลูกค้า">Customer Name</label></td>
				<td width="85%">: 
					<input type="text" class="txt_box s200" name="cus_name" autocomplete="off" id="cus_name" value="<%=entity.getCus_name()%>">
					<input type="hidden" name="cus_id" id="cus_id" value="<%=entity.getCus_id()%>"> 
					<button class="btn_search btn_box" onclick="popup('sv_job_customer_search.jsp');">search</button> 
					<label title="สามารถพิมพ์ตั้งแต่ 2 ตัวอักษรขึ้นไปเพื่อค้นหา หรือกดปุ่ม Search" class="txt_12">(Type or click search button for search customer)</label>
				</td>
			</tr>
			<tr valign="top">
				<td><label title="ทะเบียนรถ">Vehicle Plate</label></td>
				<td valign="top"><div class="left">: </div>
					<div class="left m_left5">
						<table class="bg-image s400" align="left">
							<tbody>
								<tr>
									<td width="70%">
										<input name="v_id" id="input_blank" value="" onclick="custom_plate();" type="radio" <%=(entity.getV_id().length() > 0)?"":"checked=\"checked\""%>>
										<label title="กำหนดเอง" for="input_blank">&nbsp;Customized</label> 
										<input type="text" id="v_plate_blank" name="v_plate_blank" class="txt_box s120" autocomplete="off" value="<%=(entity.getV_id().length() > 0)?"":entity.getV_plate()%>">
										<input type="hidden" id="v_plate" name="v_plate" value="<%=entity.getV_plate()%>">
									</td>
									<td width="30%">&nbsp;</td>
								</tr>
							</tbody>
							<tbody id="vehicle_show">
								<%
								if(entity.getCus_id().length() > 0){
									Iterator ite = Vehicle.selectByCusID(entity.getCus_id()).iterator();
									while(ite.hasNext()){
										Vehicle vhc = (Vehicle) ite.next();
								%>
								<tr>
									<td>
										<input name="v_id" id="input_<%=vhc.getId()%>" value="<%=vhc.getId()%>" onclick="select_plate('<%=vhc.getLicense_plate()%>');" type="radio" <%=(entity.getV_id().equalsIgnoreCase(vhc.getId()))?"checked=\"checked\"":""%>>
										<label for="input_<%=vhc.getId()%>">&nbsp;&nbsp;<%=vhc.getLicense_plate()%></label>
									</td>
									<td align="center">
										<img src="../../images/motoshop/car_logo/40x27/<%=vhc.getUIMaster().getBrand()%>.gif">
									</td>
								</tr>
								<%
									}
								}
								%>
							</tbody>
						</table>
					</div>
					<div class="clear"></div>
				</td>
			</tr>
		</tbody>
	</table>
	
	<div class="txt_center m_top20">
		<input type="hidden" name="id" value="<%=entity.getId()%>">
		<button type="button" id="submit" class="btn_box btn_confirm">Submit</button>			
		<input type="button" class="btn_box btn_warn" value="Close Display" onclick="tb_remove();">				
		<input type="hidden" name="action" value="update_customer">
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>
