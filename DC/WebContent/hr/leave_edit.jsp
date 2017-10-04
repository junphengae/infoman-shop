
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

Leave entity = new Leave();
WebUtils.bindReqToEntity(entity, request);
Leave.select(entity);
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
				$.post('../EmpManageServlet',addData,function(resData){
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
	<input type="hidden" name="per_id" id="per_id" value="<%=entity.getPer_id()%>">
	<input type="hidden" name="leave_date" id="leave_date" value=<%=WebUtils.getDateValue(entity.getLeave_date()) %>>
	<input type="hidden" name="update_by" id="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	<input type="hidden" name="status" id="status" value="1">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="455px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>แก้ไขข้อมูลการลางาน</h3></td></tr>
			<tr>
					<td width="30%"><label>วันที่ลางาน</label></td>
					<td align="left">: <%=WebUtils.getDateValue(entity.getLeave_date()) %> 
						<%-- <input value="<%=WebUtils.getDateValue(entity.getLeave_date()) %>" type="text" autocomplete="off" name="leave_date" id="leave_date" class="txt_box s100 required" title="ระบุวันที่ลา!"> --%>
					</td>
			</tr>
			<tr>
				<td><label>ประเภทการลา</label></td>
				<td align="left">: 
					<bmp:ComboBox value="<%=entity.getLeave_type_id() %>" name="leave_type_id" styleClass="txt_box s100" listData="<%=LeaveType.dropdownLeaveType()%>" >						
					</bmp:ComboBox>
				</td>
			</tr>
			<tr>
				<td><label>หมายเหตุ</label></td>
				<td align="left">: <input value="<%=entity.getLeave_remark() %>" type="text" autocomplete="off" name="leave_remark" id="leave_remark" class="txt_box s200" ></td>
			</tr>
			
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="แก้ไข" class="btn_box">
					<input type="hidden" name="action" value="edit_leave">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
			</td>
			</tr>
		</tbody>
	</table>
	<div class="msg_error"></div>
	</form>

</div>