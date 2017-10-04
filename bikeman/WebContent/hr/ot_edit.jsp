<%@page import="com.bitmap.bean.hr.OTRequest"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script src="../js/jquery.validate.js" type="text/javascript"></script>
<%
OTRequest entity = new OTRequest();
WebUtils.bindReqToEntity(entity, request);
OTRequest.select(entity);

%>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<script>
	$(function(){
		
		$( "#ot_date" ).datepicker({
			showOtherMonths: true,
			selectOtherMonths: true,
			changeYear: true,
			changeMonth: true
		});
		
		var $msg = $('.msg_error');
		var $form = $('#infoForm');
		
		var v = $form.validate({
			submitHandler: function(){
				ajax_load();
				var addData = $form.serialize();
				$.post('../OrgManagement',addData,function(resData){
					ajax_remove();
					if (resData.status == "success") {
						$msg.text('แก้ไขรายการโอทีเรียบร้อยแล้ว').show();
						window.location.reload();
					} else {
						//$msg.text('Error: ' + resData.message).show();
						if (resData.message.indexOf('Duplicate entry')>0) {
						alert('ข้อมูลวันที่ทำโอทีไม่ถูกต้อง !');
						} else {
							alert(resData.message);
						}
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
	<form id="infoForm" style="margin: 0;padding: 0;">
	<input type="hidden" name="per_id" id="per_id" value="<%=entity.getPer_id()%>">
	<input type="hidden" name="ot_date" id="ot_date" value="<%=WebUtils.getDateValue(entity.getOt_date())%>">
	<input type="hidden" name="update_by" id="update_by" value="<%=securProfile.getPersonal().getPer_id() %>"> 
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="455px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>แก้ไขข้อมูลโอที</h3></td></tr>
			<tr>
				<td width="30%"><label>วันที่ทำโอที</label></td>
				<td align="left">: <%=WebUtils.getDateValue(entity.getOt_date())%> </td>
			</tr>
			<tr>
				<td><label>จำนวนชั่วโมง</label></td>
				<td align="left">: <input type="text" value="<%=entity.getOt_hours() %>" autocomplete="off" name="ot_hours" id="ot_hours" class="txt_box s150 required" title="ระบุจำนวนชั่วโมง!"></td>
			</tr>
			<tr>
				<td><label>อัตราค่าแรง</label></td>
				<td align="left">: <input type="text" value="<%=entity.getOt_rate() %>" autocomplete="off" name="ot_rate" id="ot_rate" class="txt_box s150 required" title="ระบุอัตราค่าแรง!"></td>
			</tr>
			<tr>
				<td><label>หมายเหตุ</label></td>
				<td align="left">: <input type="text" value="<%=entity.getRemark() %>" autocomplete="off" name="remark" id="remark" class="txt_box s150"></td>
			</tr>
			
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="แก้ไข" class="btn_box btn_confirm">
					<input type="hidden" name="action" value="edit_ot">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
				</td>
			</tr>
		</tbody>
	</table>
	<div class="msg_error"></div>
	</form>

</div>