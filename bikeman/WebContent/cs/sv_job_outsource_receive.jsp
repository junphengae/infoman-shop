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
<form id="receive_outsource_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%" class="center" id="tb_material_add" border="0" cellpadding="4" cellspacing="4">
		<tbody>
			<tr>
				<td width="25%" align="left">Outsource</td>
				<td width="75%" align="left">: <%=entity.getName()%></td>
			</tr>
			<tr>
				<td align="left">Contact</td>
				<td align="left">: <%=entity.getContact()%></td>
			</tr>
			<tr>
				<td colspan="2"><div class="dot_line"></div></td>
			</tr>
			<tr>
				<td align="left">Send By</td>
				<td align="left">: <%=entity.getUISend_by()%></td>
			</tr>
			<tr>
				<td align="left">Send Date</td>
				<td align="left">: <%=WebUtils.getDateValue(entity.getSend_date())%></td>
			</tr>
			<tr>
				<td align="left">Due Date</td>
				<td align="left">: <%=WebUtils.getDateValue(entity.getDue_date())%></td>
			</tr>
			<tr>
				<td align="left">Recipient</td>
				<td align="left">: 
					<input type="text" name="recipient_name" id="recipient_name" class="txt_box required" title="*" value="" autocomplete="off">
					<input type="hidden" name="recipient" id="recipient" value="">
				</td>
			</tr>
			<tr>
				<td align="left">Receive Date</td>
				<td align="left">: <input type="text" name="receive_date" id="receive_date" class="txt_box required" title="*" value="" autocomplete="off"></td>
			</tr>
			<tr>
				<td align="left">Note</td>
				<td align="left">: <input type="text" name="note" id="note" class="txt_box s280" title="*" autocomplete="off" value="<%=entity.getNote()%>" ></td>
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
	
	$(function(){
		$("#recipient_name").autocomplete({
		    source: "../GetEmployee",
		    minLength: 2,
		    select: function(event, ui) {
		      	$('#recipient').val(ui.item.id);
		    },
		    search: function(event, ui){
		   		$('#recipient').val('');
		    }
		});
		
		$( "#receive_date" ).datepicker({
			showOtherMonths: true,
			selectOtherMonths: true,
			changeYear: true,
			changeMonth: true
		});
		
		var form = $('#receive_outsource_form');	
		
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
		<input type="hidden" name="action" value="sale_outsource_receive">
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>