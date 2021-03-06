<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<%
Customer entity = new Customer();
WebUtils.bindReqToEntity(entity, request);
Customer.select(entity);
%>

<script type="text/javascript">
$(function(){
	
	$( "#cus_birthdate" ).datepicker({
		showOtherMonths: true,
		selectOtherMonths: true,
		changeYear: true,
		changeMonth: true
	});
	
	var $msg = $('.msg_error');
	var $form = $('#infoForm');

	var v = $form.validate({
		submitHandler: function(){
			var addData = $form.serialize();
			ajax_load();
			$.post('../SaleManagement',addData,function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					$msg.text('Success').show().delay(500).queue(function(){window.location.reload();$(this).dequeue();});
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
<div>
	<form id="infoForm">
	<input type="hidden" name="cus_id" value="<%=entity.getCus_id()%>">
	<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="485px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>Update Customer Information</h3></td></tr>
			<tr>
				<td align="left" width="25%"><label>ID CARD</label></td>
				<td align="left" width="75%">: <input type="text" autocomplete="off" name="cus_id_card" id="cus_id_card" class="txt_box s150 input_focus" minlength="13" maxlength="13" value="<%=entity.getCus_id_card()%>"></td>
			</tr>
			<tr>
				<td><label>Name</label></td>
				<td>: <input type="text" autocomplete="off" name="cus_name_th" id="cus_name_th" class="txt_box s200 required" title="**" value="<%=entity.getCus_name_th()%>"></td>
			</tr>
			<tr>
				<td><label>Surname</label></td>
				<td>: <input type="text" autocomplete="off" name="cus_surname_th" id="cus_surname_th" class="txt_box s200" value="<%=entity.getCus_surname_th()%>"></td>
			</tr>
			<tr>
				<td><label>Sex</label></td>
				<td>: 
					<bmp:ComboBox name="cus_sex" styleClass="txt_box s50" value="<%=entity.getCus_sex()%>">
						<bmp:option value="m" text="Male"></bmp:option>
						<bmp:option value="f" text="Female"></bmp:option>
					</bmp:ComboBox>
				</td>
			</tr>
			<tr>
				<td><label>Address</label></td>
				<td>: <input type="text" autocomplete="off" name="cus_address" id="cus_address" class="txt_box s300" value="<%=entity.getCus_address()%>"></td>
			</tr>
			<tr>
				<td><label>Mobile</label></td>
				<td>: <input type="text" autocomplete="off" name="cus_mobile" id="cus_mobile" class="txt_box s200 required" title="**" value="<%=entity.getCus_mobile()%>"></td>
			</tr>
			<tr>
				<td><label>Phone</label></td>
				<td>: <input type="text" autocomplete="off" name="cus_phone" id="cus_phone" class="txt_box s200" value="<%=entity.getCus_phone()%>"></td>
			</tr>
			<tr>
				<td><label>Email</label></td>
				<td>: <input type="text" autocomplete="off" name="cus_email" id="cus_email" class="txt_box email s200" value="<%=entity.getCus_email()%>"></td>
			</tr>
			<tr>
				<td><label>Birthdate</label></td>
				<td>: 
					<input type="text" autocomplete="off" name="cus_birthdate" id="cus_birthdate" class="txt_box s100" value="<%=WebUtils.getDateValue(entity.getCus_birthdate())%>">
				</td>
			</tr>
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="Submit" class="btn_box">
					<input type="hidden" name="action" value="customer_edit">
					<input type="reset" onclick="tb_remove();" value="Close" class="btn_box">
				</td>
			</tr>
		</tbody>
	</table>
	<div class="msg_error"></div>
	</form>

</div>