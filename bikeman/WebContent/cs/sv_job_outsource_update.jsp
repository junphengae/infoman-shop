<%@page import="com.bitmap.bean.parts.ServiceOutsourceDetail"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%
ServiceOutsourceDetail entity = new ServiceOutsourceDetail();
WebUtils.bindReqToEntity(entity, request);
ServiceOutsourceDetail.select(entity);
%>
<form id="update_outsource_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%" class="center" id="tb_material_add" border="0" cellpadding="4" cellspacing="4">
		<tbody>
			<tr>
				<td width="25%" align="left">Outsource</td>
				<td width="75%" align="left">: <input type="text" name="name" id="name" value="<%=entity.getName()%>" class="txt_box s280 required input_focus" title="*" autocomplete="off"></td>
			</tr>
			<tr>
				<td align="left">Contact</td>
				<td align="left">: <input type="text" name="contact" id="contact" class="txt_box required s280" title="*" value="<%=entity.getContact()%>" autocomplete="off"></td>
			</tr>
			<tr>
				<td colspan="2"><div class="dot_line"></div></td>
			</tr>
			<tr>
				<td align="left">Send By</td>
				<td align="left">: 
					<input type="text" name="send_by_name" id="send_by_name" class="txt_box required" title="*" value="<%=entity.getUISend_by()%>" autocomplete="off">
					<input type="hidden" name="send_by" id="send_by" value="<%=entity.getSend_by()%>">
				</td>
			</tr>
			<tr>
				<td align="left">Send Date</td>
				<td align="left">: <input type="text" name="send_date" id="send_date" class="txt_box required" title="*" value="<%=WebUtils.getDateValue(entity.getSend_date())%>" autocomplete="off"></td>
			</tr>
			<tr>
				<td align="left">Due Date</td>
				<td align="left">: <input type="text" name="due_date" id="due_date" class="txt_box" title="*" value="<%=WebUtils.getDateValue(entity.getDue_date())%>" autocomplete="off"></td>
			</tr>
			<tr>
				<td align="left">Note</td>
				<td align="left">: <input type="text" name="note" id="note" class="txt_box s280" title="*" autocomplete="off" value="<%=entity.getNote()%>" ></td>
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
	
	$(function(){
		$("#send_by_name").autocomplete({
		    source: "../GetEmployee",
		    minLength: 2,
		    select: function(event, ui) {
		      	$('#send_by').val(ui.item.id);
		    },
		    search: function(event, ui){
		   		$('#send_by').val('');
		    }
		});
		
		$( "#send_date" ).datepicker({
			showOtherMonths: true,
			selectOtherMonths: true,
			changeYear: true,
			changeMonth: true
		});
		
		$( "#due_date" ).datepicker({
			showOtherMonths: true,
			selectOtherMonths: true,
			changeYear: true,
			changeMonth: true
		});
		
		
		var form = $('#update_outsource_form');	
		
		var v = form.validate({
			submitHandler: function(){
				ajax_load();
				$.post('../PartSaleManage',form.serialize(),function(resData){			
					ajax_remove();
					if (resData.status == 'success') {
						window.location.reload();
					} else {
						alert(resData.status);
					}
				},'json');
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
		<input type="hidden" name="action" value="sale_outsource_update">
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>