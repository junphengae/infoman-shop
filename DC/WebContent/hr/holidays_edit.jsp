
<%@page import="com.bitmap.bean.hr.YearHolidays"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Date"%>
<%@page import="com.bitmap.bean.hr.LeaveType"%>
<%@page import="com.bitmap.bean.hr.Leave"%>

<%@page import="com.bitmap.bean.hr.Department"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script src="../js/jquery.validate.js" type="text/javascript"></script>
<%

YearHolidays entity = new YearHolidays();
WebUtils.bindReqToEntity(entity, request);
YearHolidays.select(entity);
%>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<script>
	$(function(){
		
		$( "#leave_date" ).datepicker({
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
				$.post('../OrgManagement',addData,function(resData){
					if (resData.status == "success") {
						$msg.text('แก้ไขเรียบร้อยแล้ว').show();
						window.location.reload();
					} else {
						$msg.text('Error: ' + resData.message).show();
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
	<input type="hidden" name="year" id="year" value="<%=entity.getYear()%>">
	<input type="hidden" name="holidays_date" id="holidays_date" value=<%=WebUtils.getDateValue(entity.getHolidays_date()) %>>
	<input type="hidden" name="update_by" id="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="455px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>แก้ไขข้อมูลวันหยุด</h3></td></tr>
			<tr>
					<td width="30%"><label>วันที่</label></td>
					<td align="left">: 
						<%=WebUtils.getDateValue(entity.getHolidays_date()) %> 
					</td>
			</tr>
			<tr>
				<td><label>ชื่อวันหยุด</label></td>
				<td align="left">: 
					<input type="text" value="<%=entity.getHolidays_name() %>" name="holidays_name" autocomplete="off" class="txt_box s200 required" title="**">									
				</td>
			</tr>
			<tr>
				<td><label>หมายเหตุ</label></td>
				<td align="left">: 
					<input value="<%=entity.getRemark() %>" type="text" autocomplete="off" name="remark" id="remark" class="txt_box s200"  >
				</td>
			</tr>
			
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="แก้ไข" class="btn_box">
					<input type="hidden" name="action" value="edit_holidays">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
			</td>
			</tr>
		</tbody>
	</table>
	<div class="msg_error"></div>
	</form>

</div>