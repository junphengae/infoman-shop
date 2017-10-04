<%@page import="com.bitmap.bean.sale.VehicleMaster"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.sale.Vehicle"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<%
String vid = WebUtils.getReqString(request, "vid");
String master_id = WebUtils.getReqString(request, "master_id");

Vehicle entity = new Vehicle();
WebUtils.bindReqToEntity(entity, request);
Vehicle.select(entity);

Vehicle ver = Vehicle.select(vid);
%>

<script type="text/javascript">
$(function(){
		
	var $msg = $('.msg_error');
	var $form = $('#infoForm');
	
	var v = $form.validate({
		submitHandler: function(){
			var addData = $form.serialize();
			
			ajax_load();
			$.post('../VehicleManage',addData,function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					<%-- $msg.text('Success').show().delay(500).queue(function(){window.location = "spec_info.jsp?id=<%=entity.getId()%>";}); --%> 
					window.location.reload();
					
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

<div class="m_top15">
	<form id="infoForm">
		<table cellpadding="3" cellspacing="3" border="0" class="center s_auto">
			<tbody>
				<tr>
					<td align="left" width="30%">Plate</td>
					<td width="70%">: <input value="<%=ver.getLicense_plate() %>" type="text" autocomplete="off" name="license_plate" id="license_plate" class="txt_box s200"></td>
				</tr>
				<tr>
					<td>Engine NO.</td>
					<td>: <input type="text" value="<%=ver.getEngine_no() %>" autocomplete="off" name="engine_no" id="engine_no" class="txt_box s200"></td>
				</tr>
				<tr>
					<td>VIN.</td>
					<td>: <input type="text" value="<%=ver.getVin() %>" autocomplete="off" name="vin" id="vin" class="txt_box s200"></td>
				</tr>
				<tr>
					<td>Color</td>
					<td>: <input type="text" value="<%=ver.getColor() %>" autocomplete="off" name="color" id="color" class="txt_box s200"></td>
				</tr>
				<tr>
					<td>Note</td>
					<td>: <input type="text" value="<%=ver.getNote() %>" autocomplete="off" name="note" id="note" class="txt_box s200"></td>
				</tr>
				<tr align="center" valign="bottom" height="30">
					<td colspan="2">
						<input type="submit" id="btnAdd" value="Submit" class="btn_box btn_confirm">
						<input type="hidden" name="action" value="vehicle_edit">
						<input type="hidden" name="cus_id" value="<%=entity.getCus_id()%>">
						<input type="hidden" name="id" value="<%=vid%>">
						<%-- <input type="hidden" name="master_id" value="<%=master_id%>"> --%>
						<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
						<input type="button" onclick="tb_remove();" value="Close" class="btn_box">
					</td>
				</tr>
			</tbody>
		</table>
	
	</form>
</div>