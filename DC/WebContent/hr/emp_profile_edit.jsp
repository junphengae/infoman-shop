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

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>แก้ไขข้อมูลพื้นฐานพนักงาน</title>
<%
String user = WebUtils.getReqString(request, "user");
String per_id = WebUtils.getReqString(request,"per_id");
Personal per = Personal.select(per_id);
%>
<script type="text/javascript">
$(function(){
/* 	$( "#date_start" ).datepicker({
		showOtherMonths: true,
		selectOtherMonths: true,
		changeYear: true,
		changeMonth: true
	}); */
	
	var form = $('#infoForm');
/* 	var dep_id = $('#dep_id');
	var div_id = $('#div_id');
	var pos_id = $('#pos_id'); */
	
/* 	dep_id.change(function(){
		ajax_load();
		$.getJSON('EmpManageServlet',{action:'getDivision',dep_id:$(this).val()},
			function(j){
				ajax_remove();
				var options = '<option value="">--- เลือกแผนก ---</option>';
	            for (var i = 0; i < j.length; i++) {
	                options += '<option value="' + j[i].div_id + '">' + j[i].div_name_th + '</option>';
	            }
             	div_id.html(options);
			}
		);
	}); */
	
	$.metadata.setType("attr", "validate");
	var v = form.validate({
		submitHandler: function(){
			ajax_load();
			var addData = form.serialize();
			$.post('../EmpManageServlet',addData,function(data){
				ajax_remove();
				if (data.status == 'success') {
					window.location ="emp_profile.jsp?per_id=<%=per_id%>";
				} else {
					alert(data.message);
				}
			},'json');
		}
	});
	
	form.submit(function(){
		v;
		return false;
	});
	
	
<%-- 	$.getJSON('EmpManageServlet',{action:'getDivision',dep_id:'<%=per.getDep_id()%>'},
		function(j){
			var options = '<option value="">--- เลือกแผนก ---</option>';
            for (var i = 0; i < j.length; i++) {
            	var selected = '';
            	if (j[i].div_id == '<%=per.getDiv_id()%>') {
					selected = ' selected';
				}
                options += '<option value="' + j[i].div_id + '"' + selected + '>' + j[i].div_name_th + '</option>';
            }
           	div_id.html(options);
		}
	); --%>
});
</script>

</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายชื่อพนักงาน &gt; ข้อมูลพนักงาน &gt; แก้ไขข้อมูลพื้นฐานพนักงาน</div>
				<div class="right m_right15">
					<button class="btn_box" onclick="javascript: history.back();">ย้อนกลับ</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
			
			<form id="infoForm" onsubmit="return false;" style="margin: 0;padding: 0;">
				<table cellpadding="3" cellspacing="3" border="0" class="center s550">
					<tbody>
						<tr>
							<td><label>รหัสพนักงาน</label></td>
							<td align="left">: <%=per.getPer_id()%></td>
						</tr>
						<tr>
							<td><label>คำนำหน้า</label></td>
							<td>: 
								<bmp:ComboBox name="prefix" styleClass="txt_box input_focus" width="100px" value="<%=per.getPrefix()%>">
									<bmp:option value="นาย" text="นาย"></bmp:option>
									<bmp:option value="นาง" text="นาง"></bmp:option>
									<bmp:option value="นางสาว" text="นางสาว"></bmp:option>
								</bmp:ComboBox>
							</td>
						</tr>
						<tr>
							<td width="20%"><label>ชื่อ</label></td>
							<td align="left">: <input value="<%=per.getName()%>" type="text" autocomplete="off" name="name" id="name" class="txt_box s200 required" title="Please insert Name!"></td>
						</tr>
						<tr>
							<td><label>นามสกุล</label></td>
							<td align="left">: <input value="<%=per.getSurname()%>" type="text" autocomplete="off" size="30" name="surname" id="surname" class="txt_box s200 required" title="Please insert Surname!"></td>
						</tr>
						<tr>
							<td><label>มือถือ</label></td>
							<td align="left">: <input value="<%=per.getMobile()%>" type="text" autocomplete="off" size="30" name="mobile" id="mobile" class="txt_box s200"></td>
						</tr>
						<tr>
							<td><label>Email</label></td>
							<td align="left">: <input value="<%=per.getEmail()%>" type="text" autocomplete="off" size="30" name="email" id="email" class="txt_box s200 email"></td>
						</tr>
						<tr>
							<td><label>ฝ่าย</label></td>
							<td align="left">: 
								<%=per.getUIDepartment().getDep_name_th() %>
								<input type="hidden" name="dep_id" value="<%=per.getDep_id() %>"> 
							</td>
						</tr>
						<tr>
							<td><label>แผนก</label></td>
							<td align="left">: 
								<%= per.getUIDivision().getDiv_name_th() %>
								<input type="hidden" name="div_id" value="<%=per.getDiv_id() %>">
							</td>
						</tr>
						<tr>
							<td><label>ตำแหน่ง</label></td>
							<td align="left">: 
								<%=per.getUIPosition().getPos_name_th() %>
								<input type="hidden" name="pos_id" value="<%=per.getPos_id() %>">
							</td>
						</tr>
						<tr>
							<td><label>วันที่บรรจุ</label></td>
							<td align="left">: 
								<%=WebUtils.getDateValue(per.getDate_start())%>
								<input type="hidden" name="date_start_" value="<%=WebUtils.getDateValue(per.getDate_start()) %>"> 
							</td>		
						</tr>
						<tr align="center" valign="bottom" height="30">
							<td colspan="2">
								<input type="submit" id="btnAdd" value="บันทึก" class="btn_box">
								<input type="hidden" name="action" value="edit">
								<input type="hidden" name="per_id" value="<%=per_id%>">
								<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
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