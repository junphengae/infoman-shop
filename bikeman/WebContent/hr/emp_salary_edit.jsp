<%@page import="com.bitmap.bean.hr.Salary"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="../js/jquery.validate.js" type="text/javascript"></script>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<%
String per_id = WebUtils.getReqString(request,"per_id");
String salary = WebUtils.getReqString(request,"salary");
String flag_tax = WebUtils.getReqString(request,"flag_tax");
%>

<script>
	$(function(){
		
		var $msg = $('.msg_error');
		var $form = $('#infoForm');
		
		var v = $form.validate({
			submitHandler: function(){
				ajax_load();
				var addData = $form.serialize();
				$.post('../EmpManageServlet',addData,function(resData){
					ajax_remove();
					if (resData.status == "success") {
						alert('บันทึกเรียบร้อยแล้ว');
						window.location ="emp_info.jsp?per_id=<%=per_id%>";
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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ปรับปรุงข้อมูลฐานเงินเดือน</title>
</head>
<body>
<div>
	<form id="infoForm" style="margin: 0;padding: 0;">
		<input type="hidden" name="per_id" id="per_id" value="<%=per_id%>">
		<input type="hidden" name="create_by" id="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
		<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="455px">
			<tbody>
				<tr align="center" height="25"><td colspan="2"><h3>แก้ไขข้อมูลฐานเงินเดือน</h3></td></tr>
			<tr>
				<td width="30%"><label>ฐานเงินเดือนเก่า</label></td>
				<td align="left">: 
					<input type="hidden" name="salary_old" class="txt_box" value="<%=salary%>"> 
					<%=Money.money(salary) %> &nbsp;บาท
				</td>
			</tr>
			<tr>
				<td width="30%"><label>ระบุฐานเงินเดือนใหม่</label></td>
				<td align="left">:
					<input type="text" class="txt_box required digits "  title="ต้องเป็นตัวเลขเท่านั้น"name="salary_new" id="salary_new">
				</td>
			</tr>
			<!-- <tr>
				<td colspan="2">
					<input type="checkbox" id="flag_tax" name="flag_tax" value="2"> เสียภาษี
				</td>
			</tr> -->
			<tr>
				<td>การเสียภาษี
				</td>
				<td>: 
					<bmp:ComboBox name="flag_tax" listData="<%=Salary.flagTaxList() %>"  styleClass="txt_box input_focus" width="100px" value="<%=flag_tax %>" >
					</bmp:ComboBox>
				</td>
				
			</tr>
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="บันทึก" class="btn_box btn_confirm">
					<input type="hidden" name="action" value="add_salary_history">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
				</td>
			</tr>
			
			</tbody>
		</table>
	</form>
</div>
</body>
</html>