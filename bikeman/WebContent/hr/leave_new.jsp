<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.hr.LeaveType"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script src="../js/jquery.validate.js" type="text/javascript"></script>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<%
String per_id = WebUtils.getReqString(request,"per_id");
%>

<script>
	$(function(){
		
		var tr_end_date = $('#tr_end_date');
		
		$('#chk1').click(function () {
			if($('#chk1:checked').length>0) {
				tr_end_date.show();
			}else{
				tr_end_date.hide();
			}
		});
		
		$( "#leave_date" ).datepicker({
			showOtherMonths: true,
			selectOtherMonths: true,
			changeYear: true,
			changeMonth: true
		});
		
		$( "#leave_date_end" ).datepicker({
			showOtherMonths: true,
			selectOtherMonths: true,
			changeYear: true,
			changeMonth: true
		});
		
		var $msg = $('.msg_error');
		var $form = $('#infoForm');
		
		$.metadata.setType("attr", "validate");
		var v = $form.validate({
			submitHandler: function(){
				var check = true;
				
				if ($('#chk1').is(':checked')) {
					if ($('#leave_date_end').val()==''){
						check = false;
						alert('กรุณาระบุวันลา!');
						$('#leave_date_end').focus();
					} else {
						var s = $('#leave_date').val().split('/');
						var e = $('#leave_date_end').val().split('/');
						
						var ss = new Date(s[2],s[1]-1,s[0]);
						var ee = new Date(e[2],e[1]-1,e[0]);
						if (ee < ss) {
							check = false;
							alert('กำหนดวันลาไม่ถูกต้อง!');
						} else {
							check = true;
						}
					}
				}
				
				if (check) {
					ajax_load();
					
					var addData = $form.serialize();
					$.post('../EmpManageServlet',addData,function(resData){
						ajax_remove();
						if (resData.status == "success") {
							$msg.text('เพิ่มรายการลางานเรียบร้อยแล้ว').show();
							window.location.reload();
						} else {
							//$msg.text('Error: ' + resData.message).show();
							if (resData.message.indexOf('Duplicate entry')>0) {
								alert('ระบุวันลาซ้ำ !');
							} else {
								alert(resData.message);
							}
						}
					},'json');
				}
				
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
	<input type="hidden" name="per_id" id="per_id" value="<%=per_id%>">
	<input type="hidden" name="create_by" id="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	<input type="hidden" name="status" id="status" value="1">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="455px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>เพิ่มข้อมูลการลางาน</h3></td></tr>
			<tr>
				<td width="30%"><label>วันที่ลางาน</label></td>
				<td align="left">: 
					<input type="text" autocomplete="off" name="leave_date" id="leave_date" class="txt_box s100 required" title="ระบุวันที่ลา!">
					<input type="checkbox" name="chk1" id="chk1" value="1" > ลาต่อเนื่อง
				</td>
			</tr>
			
			
			<tr id="tr_end_date" class="hide">
				<td>ถึงวันที่</td>
				<td>: 
					<input type="text" autocomplete="off" name="leave_date_end" id="leave_date_end" class="txt_box s100">
				</td>
			</tr>
			
			<tr>
				<td><label>ประเภทการลา</label></td>
				<td align="left">: 
					<%-- <bmp:ComboBox name="leave_type_id" styleClass="txt_box s100" validate="true">
						<bmp:option value="1" text="ลาป่วย"></bmp:option>
						<bmp:option value="2" text="ลากิจ"></bmp:option>
						<bmp:option value="3" text="ลาพักร้อน"></bmp:option>
					</bmp:ComboBox> --%>
					<bmp:ComboBox name="leave_type_id" styleClass="txt_box s100" listData="<%=LeaveType.dropdownLeaveType()%>" validate="true" validateTxt=" *">
						<bmp:option value="" text="--เลือก--"></bmp:option>				
					</bmp:ComboBox>
				</td>
			</tr>
			<tr>
				<td><label>หมายเหตุ</label></td>
				<td align="left">: <input type="text" autocomplete="off" name="leave_remark" id="leave_remark" class="txt_box s200"></td>
			</tr>
			
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="เพิ่ม" class="btn_box btn_confirm">
					<input type="hidden" name="action" value="add_leave">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
				</td>
			</tr>
		</tbody>
	</table>
	<div class="msg_error"></div>
	</form>

</div>