<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<form id="outsource_add_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%" class="center" id="tb_material_add" border="0" cellpadding="4" cellspacing="4">
		<tbody>
			<tr>
				<td width="25%" align="left">Outsource</td>
				<td width="75%" align="left">: <input type="text" name="name" id="name" class="txt_box s280 required input_focus" title="*" autocomplete="off"></td>
			</tr>
			<tr>
				<td align="left">Contact</td>
				<td align="left">: <input type="text" name="contact" id="contact" class="txt_box required s280" title="*" autocomplete="off"></td>
			</tr>
			<tr>
				<td colspan="2"><div class="dot_line"></div></td>
			</tr>
			<tr>
				<td align="left">Send By</td>
				<td align="left">: 
					<input type="text" name="send_by_name" id="send_by_name" class="txt_box required" title="*" autocomplete="off">
					<input type="hidden" name="send_by" id="send_by" value="">
				</td>
			</tr>
			<tr>
				<td align="left">Send Date</td>
				<td align="left">: <input type="text" name="send_date" id="send_date" class="txt_box required" title="*" autocomplete="off"></td>
			</tr>
			<tr>
				<td align="left">Due Date</td>
				<td align="left">: <input type="text" name="due_date" id="due_date" class="txt_box" title="*" autocomplete="off"></td>
			</tr>
			<tr>
				<td align="left">Note</td>
				<td align="left">: <input type="text" name="note" id="note" class="txt_box s280" title="*" autocomplete="off"></td>
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
		
		var form = $('#outsource_add_form');	
		/*material Form*/
		var v = form.validate({
			submitHandler: function(){
				ajax_load();
				$.post('../PartSaleManage',form.serialize(),function(resData){			
					ajax_remove();
					if (resData.status == 'success') {
						window.location.reload();
					} else {
						alert(resData.message);
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
		<input type="hidden" name="id" value="<%=WebUtils.getReqString(request, "id")%>">
		<input type="submit" name="add" class="btn_box btn_confirm" value="Submit">				
		<input type="button" class="btn_box btn_warn" value="Close Display" onclick="tb_remove();">				
		<input type="hidden" name="action" value="sale_outsource_add">
		<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>