<%@page import="com.bitmap.bean.hr.PersonalDetail"%>
<%@page import="com.bitmap.security.SecurityProfile"%>
<%@page import="com.bitmap.bean.hr.Division"%>
<%@page import="com.bitmap.bean.hr.Position"%>
<%@page import="com.bitmap.bean.hr.Department"%>
<%@page import="com.bitmap.security.SecurityUser"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>แก้ไขข้อมูลเพิ่มเติมพนักงาน</title>
<%
String per_id = WebUtils.getReqString(request,"per_id");
Personal per = Personal.select(per_id);

PersonalDetail perDetail = per.getUIPerDetail();
%>
<script type="text/javascript">
$(function(){
 	$( "#birthdate" ).datepicker({
		showOtherMonths: true,
		selectOtherMonths: true,
		changeYear: true,
		changeMonth: true
	}); 
	
	var form = $('#infoForm');

	 
	 $.metadata.setType("attr", "validate");
		var v = form.validate({
			submitHandler: function(){
				if (isNaN($('#id_card').val())) {
					alert("โปรดระบุ รหัสบัตรประชาชนเป็นตัวเลขเท่านั้น");
				}
				else if (isNaN($('#phone').val())) {
					alert("โปรดระบุหมายเลขโทรศัพท์เป็นตัวเลขเท่านั้น"); 
					
				}else if(isNaN($('#ref_phone').val())){
					alert("โปรดระบุหมายเลขโทรศัพท์เป็นตัวเลขเท่านั้น");		
					$('#ref_phone').val('');
					$('#ref_phone').focus();
					return false;
				}else{
					if(confirm("แก้ไขข้อมูลเรียบร้อย")){
							ajax_load();
							var addData = form.serialize();
							$.post('../EmpManageServlet',addData,function(data){
								ajax_remove();
								if (data.status == 'success') {
									window.location ="emp_info.jsp?per_id=<%=per_id%>";
									
								} else {
									alert(data.message);
								}
							},'json');
					}
				} 
			
			}
		});
	 
	 
	 
	 
	 
	form.submit(function(){
		v;
		return false;
	});
	
	
	
});
</script>

</head>
<body>
			<fieldset class="fset s440 center min_h200">
					<legend><Strong>แก้ไขข้อมูลเพิ่มเติมพนักงาน</Strong></legend>
			<form id="infoForm" onsubmit="return false;" style="margin: 0;padding: 0;">
				<table cellpadding="3" cellspacing="3" border="0" class="center s400">
					<tbody>
						<tr>
							<td width="30%"><label>รหัสบัตรประชาชน</label></td>
							<td align="left">: <input value="<%=perDetail.getId_card()%>" type="text" maxlength="13" autocomplete="off" name="id_card" id="id_card" class="txt_box s200" ></td>
						</tr>					
						<tr>
							<td width="20%"><label>ที่อยู่</label></td>
							<td align="left">: <input value="<%=perDetail.getAddress()%>" type="text" autocomplete="off" name="address" id="address" class="txt_box s200" ></td>
						</tr>
						<tr>
							<td><label>โทรศัพท์</label></td>
							<td align="left">: <input value="<%=perDetail.getPhone()%>" type="text" maxlength="10" autocomplete="off" size="30" name="phone" id="phone" class="txt_box s200" ></td>
						</tr>
						<tr>
							<td><label>วัน/เดือน/ปี เกิด</label></td>
							<td align="left">: <input value="<%=(perDetail.getBirthdate()!=null)?WebUtils.DATE_FORMAT_EN.format(perDetail.getBirthdate()):""%>" type="text" autocomplete="off" size="30" name="birthdate" id="birthdate" class="txt_box s200 required" title="กรุณาใส่ วัน/เดือน/ปี เกิด !!"></td>
						</tr>
						<tr>
							<td><label>ชื่อบุคคลอ้างอิง</label></td>
							<td align="left">: <input value="<%=perDetail.getRef_name()%>" type="text" autocomplete="off" size="30" name="ref_name" id="ref_name" class="txt_box s200"></td>
						</tr>
						<tr>
							<td><label>เบอร์บุคคลอ้างอิง</label></td>
							<td align="left">: <input value="<%=perDetail.getRef_phone()%>" type="text" autocomplete="off" size="30" name="ref_phone" id="ref_phone" class="txt_box s200"></td>
						</tr>
						
						
						<tr align="center" valign="bottom" height="30">
							<td colspan="2">
								<input type="submit" id="btnAdd" value="บันทึก" class="btn_box">
								<input type="hidden" name="action" value="edit_detail">
								<input type="hidden" name="per_id" value="<%=per_id%>">
								<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
								<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
								
							</td>
						</tr>
					</tbody>
				</table>
				
			</form>
			</fieldset>
			
		
</body>
</html>