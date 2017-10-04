<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.hr.AttendanceTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script type="text/javascript" src="../js/jquery.min.js"></script>
<script type="text/javascript" src="../js/thickbox.js"></script>
<script type="text/javascript" src="../js/loading.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="../js/jquery.metadata.js"></script>
<script type="text/javascript" src="../js/jquery.validate.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%
String id = "1";
AttendanceTime entity = new AttendanceTime();
entity = AttendanceTime.select(id);
%>

<script>

	

	$(function(){
		var $msg = $('.msg_error');
		var $form = $('#infoForm');
		
		var v = $form.validate({
			submitHandler: function(){
				
				/* 
				if($("input[name='sat_flag']:checked").size() > 0){
					
				}
				*/
				
				var addData = $form.serialize();
				
				/* if($('#sat_flag').attr('checked')){
					alert($('#sat_flag').attr('value'));
				}
				if($('#sun_flag').attr('checked')){
					alert($('#sun_flag').attr('value'));
				} */
							
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

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>กำหนดเวลาทำงาน</title>
</head>
<body>
<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">กำหนดเวลาทำงาน</div>
				<div class="right">
					<button class="btn_box" onclick="javascript: window.location='holidays_manage.jsp?year=<%=WebUtils.getCurrentYear()%>';">วันหยุดประจำปี</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<form id="infoForm" onsubmit="return false;" style="margin: 0;padding: 0;">
				<input type="hidden" name="id" id="id" value="1">
					<table cellpadding="3" cellspacing="3" border="0" class="center s350">
						<tbody>
							<tr>
								<td width="30%">เวลาเข้างาน</td>
								<td>: <input type="text" value="<%=entity.getTime_in() %>" autocomplete="off" name="time_in" id="time_in" class="txt_box s100 required" title="ระบุเวลาเข้างาน!"></td>
							</tr>
							<tr>
								<td>เวลาเลิกงาน</td>
								<td>: <input type="text" value="<%=entity.getTime_out() %>" autocomplete="off" name="time_out" id="time_out" class="txt_box s100 required" title="ระบุเวลาเลิกงาน!"></td>
							</tr>
							<tr>
								<td>เวลามาสาย</td>
								<td>: <input type="text" value="<%=entity.getTime_late() %>" autocomplete="off" name="time_late" id="time_late" class="txt_box s100 required" title="ระบุเวลามาสาย!"></td>
							</tr>
							<tr>
								<td>หยุดวันเสาร์</td>
								<%
									if (entity.getSat_flag().length()==0){
								%>
								<td>: 
									<input type="checkbox" id="sat_flag" name="sat_flag" value="1">
								</td>
								<%
									}else {
								%>
								<td>: 
									<input type="checkbox" id="sat_flag" name="sat_flag" value="1" checked="checked">
								</td>
								<%} %>
							</tr>
							<tr>
								<td>หยุดวันอาทิตย์</td>
								<%
									if (entity.getSun_flag().length()==0){
								%>
								<td>: <input type="checkbox" id="sun_flag" name="sun_flag" value="1"></td>
								<%
									}else{
								%>
								<td>: <input type="checkbox" id="sun_flag" name="sun_flag" value="1" checked="checked"></td>
								<%} %>
							</tr>
							<tr align="center" valign="bottom" height="30">
								<td colspan="2">
									<input type="submit" id="btnEdit" value="บันทึก" class="btn_box">
									<input type="hidden" name="action" value="edit_time">
									<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
									<input type="reset" value="ยกเลิก" class="btn_box">
								</td>
							</tr>
						</tbody>
					</table>
				</form>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
</body>
</html>