<%@page import="com.bitmap.bean.hr.Salary"%>
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
<title>แก้ไขข้อมูลการทำงาน</title>
<%
String per_id = WebUtils.getReqString(request,"per_id");
//Personal per = Personal.select(per_id);
Salary salary = Salary.select(per_id);
%>
<script type="text/javascript">
$(function(){
	
	var form = $('#infoForm');

	$.metadata.setType("attr", "validate");
	var v = form.validate({
		submitHandler: function(){
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
	});
	
	form.submit(function(){
		v;
		return false;
	});
	
});
</script>

</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายชื่อพนักงาน &gt; ข้อมูลพนักงาน &gt; แก้ไขข้อมูลการทำงาน</div>
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
							<td><label>ID</label></td>
							<td align="left">: <%=salary.getPer_id()%></td>
						</tr>

						
						<tr>
							<td><label>ประเภทพนักงาน</label></td>
							 <td>: 
								<bmp:ComboBox name="salary_type"  styleClass="txt_box input_focus" width="100px" listData="<%=Salary.salaryTypeList()%>" value="<%=salary.getSalary_type() %>" >
								</bmp:ComboBox>
							</td> 
						</tr>
						
						
						
						
						<tr>
							<td width="20%"><label>เงินเดือน</label></td>
							<td align="left">: 
								<%-- <input value="<%=salary.getSalary()%>" type="text" autocomplete="off" name="salary" id="salary" class="txt_box s100 required" title="กรุณาระบุเงินเดือน!"> --%>
								<input type="hidden" name="salary" value="<%=salary.getSalary()%>">
								<% if (salary.getSalary().length()==0){  %>  <font size="2" color="red"><i>ยังไม่มีข้อมูลเงินเดือน</i></font>  <% }else{ %> <%=salary.getSalary()%>&nbsp;บาท/เดือน <%}%> 
								
							</td>
						</tr>
						
						
						<tr>
							<td><label>สิทธิ์ลาพักร้อน</label></td>
							<td align="left">: <input value="<%=salary.getLimit_vacation()%>" type="text" autocomplete="off" size="30" name="limit_vacation" id="limit_vacation" class="txt_box s100">&nbsp;วัน</td>
						</tr>
						<tr>
							<td><label>สิทธิ์ลาป่วย</label></td>
							<td align="left">: <input value="<%=salary.getLimit_sick()%>" type="text" autocomplete="off" size="30" name="limit_sick" id="limit_sick" class="txt_box s100">&nbsp;วัน</td>
						</tr>
						<tr>
							<td><label>สิทธิ์ลากิจ</label></td>
							<td align="left">: <input value="<%=salary.getLimit_business()%>" type="text" autocomplete="off" size="30" name="limit_business" id="limit_business" class="txt_box s100">&nbsp;วัน
							</td>
						</tr>
						<tr align="center" valign="bottom" height="30">
							<td colspan="2">
								<input type="submit" id="btnAdd" value="บันทึก" class="btn_box">
								<input type="hidden" name="action" value="editSalary">
								<input type="hidden" name="per_id" value="<%=per_id%>">
								<input type="hidden" name="flag_tax" value="<%=salary.getFlag_tax()%>">
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