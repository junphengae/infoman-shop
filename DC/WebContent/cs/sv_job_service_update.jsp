<%@page import="com.bitmap.bean.parts.ServiceRepairDetail"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%
ServiceRepairDetail entity = new ServiceRepairDetail();
WebUtils.bindReqToEntity(entity, request);
ServiceRepairDetail.select(entity);
%>
<form id="update_service_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%" class="center" id="tb_material_add" border="0" cellpadding="4" cellspacing="4">
		<tbody>
			<tr>
				<td width="25%" align="left">Service Detail</td>
				<td width="75%" align="left">: <input type="text" name="labor_name" id="labor_name" value="<%=entity.getLabor_name()%>" class="txt_box s280 required input_focus" title="*" autocomplete="off"></td>
			</tr>
			<tr>
				<td align="left">Hour</td>
				<td align="left">: <input type="text" name="labor_qty" id="labor_qty" value="<%=entity.getLabor_qty()%>" class="txt_box required" title="*" autocomplete="off"></td>
			</tr>
			<tr>
				<td align="left">Price</td>
				<td align="left">: <input type="text" name="labor_rate" id="labor_rate" value="<%=entity.getLabor_rate()%>" class="txt_box required" title="*" autocomplete="off"></td>
			</tr>
			<tr>
				<td align="left">Discount</td>
				<td align="left">: <input type="text" name="discount" id="discount" class="txt_box s50" value="<%=entity.getDiscount()%>" autocomplete="off"> %</td>
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
	
	$(function(){
		
		var form = $('#update_service_form');	
		
		var v = form.validate({
			submitHandler: function(){
				if (isNumber($('#labor_rate').val())) {
					if (isNumber($('#discount').val())) {
						if (isNumber($('#labor_qty').val())) {
							ajax_load();
							$.post('../PartSaleManage',form.serialize(),function(resData){			
								ajax_remove();
								if (resData.status == 'success') {
									window.location.reload();
								} else {
									alert(resData.status);
								}
							},'json');
						} else {
							alert('Please check Hour!');
							$('#labor_qty').focus();
						}
					} else {
						alert('โปรดตรวจสอบส่วนลด!');
						$('#discount').focus();
					}
				} else {
					alert('โปรดตรวจสอบราคา!');
					$('#labor_rate').focus();
				}
			}
		});
		
		form.submit(function(){
			v;
			return false;
		});	
	});
	</script>
	
	<div class="txt_center m_top20">
		<input type="hidden" name="id" value="<%=entity.getId()%>">
		<input type="hidden" name="number" value="<%=entity.getNumber()%>">
		<input type="submit" name="add" class="btn_box btn_confirm" value="Submit">				
		<input type="button" class="btn_box btn_warn" value="Close Display" onclick="tb_remove();">				
		<input type="hidden" name="action" value="sale_service_update">
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>