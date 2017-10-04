<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.webutils.customtag.ComboBoxTag"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.hr.Salary"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="../js/jquery.validate.js" type="text/javascript"></script>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
.tb{border-collapse: collapse;}
.tb tr, .tb td, .tb th{border: .5pt solid #000;border-top: .5pt solid #000; border-bottom: .5pt solid #000;}

</style>
<%
String per_id = WebUtils.getReqString(request,"per_id");
/* String emp_type = WebUtils.getReqString(request,"emp_type");
String date_start = WebUtils.getReqString(request,"date_start");
Salary salary = Salary.select(per_id); */
Personal per = Personal.select(per_id);

/* String cnt_run = Personal.countRunID(emp_type);
String type = emp_type;
String m = date_start.substring(3, 5);
String month = Integer.parseInt(date_start.substring(3, 5))+"";
String year1 = date_start.substring(6, 8);
String year = date_start.substring(8, date_start.length());  */

%>
</head>
<body>
<div>
	
		<%-- <table class="tb" style="margin: 0 auto;" width="455px">
			<tbody>
				<tr align="center">
					<td>ประเภทพนักงาน</td>
					<td>ปี ที่เข้าทำงาน</td>
					<td>เดือน ที่เข้าทำงาน</td>
					<td>เลข Run</td>
				</tr>
				<tr align="center">
					<td> 
						<%=Personal.empType(per.getEmp_type()) %>
					</td>
					<td>
						<bmp:ComboBox name="year" styleClass="txt_box s100 readonly" style="<%=ComboBoxTag.EngYearList%>" value="<%=year1+year %>"></bmp:ComboBox>
					</td>
					<td>
						<bmp:ComboBox name="month" styleClass="txt_box s100 readonly" style="<%=ComboBoxTag.EngMonthList%>" value="<%=month %>"></bmp:ComboBox>
					</td>
					<td> 
						<input name="cnt_run" id="cnt_run" type="text" class="txt_box s100" value="<%=cnt_run %>" />
					</td>
				</tr>
			</tbody>
		</table> --%>
		
		<br>
		<br>
		
		<script type="text/javascript">
		
		<%-- 	var cnt_run = "<%=cnt_run%>";
			var type = "<%=type%>";
			var m = "<%=m%>";
			var month = "<%=month%>";
			var year1 = "<%=year1%>";
			var year = "<%=year%>";
			
			var i_tag_id = $('#tag_id');
			i_tag_id.val(type+year+m+cnt_run);
			
			var i_cnt_run = $('#cnt_run');
			i_cnt_run.blur(function() {
				x = i_cnt_run.val();
				i_tag_id.val(type+year+m+x);
			}); --%>

			$.metadata.setType("attr","validate");
			var $form = $('#infoForm');
			
			var v = $form.validate({
				submitHandler: function(){
					var addData = $form.serialize();
					/* if(confirm('ยืนยันการบันทึกรหัสพนักงาน\n\r เมื่อกดยินยันแล้ว คุณจะไม่สามารถแก้ไขได้อีก')){ */
					if(confirm('ยืนยันการบันทึกรหัสพนักงาน')){
						ajax_load();
						$.post('../EmpManageServlet',addData,function(resData){
							ajax_remove();
							if (resData.status == "success") {
								window.location = 'emp_info.jsp?per_id=<%=per_id%>';
								}else {
								alert(resData.message);
							}
						},'json');
					}
					
					
				}
			});
			
			$form.submit(function(){
				v;
				return false;
			});
			
		</script>
		
		<form id="infoForm" style="margin: 0;padding: 0;">
		<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="455px">
			<tr align="center">
				<td>
					รหัสพนักงาน : <input type="text" class="txt_box s100" name="tag_id" id="tag_id" value="<%=per.getTag_id()%>">
					<input type="submit" id="btnAddID" value="บันทึก" class="btn_box btn_confirm">
					<input type="hidden" name="per_id" value="<%=per_id%>">
					<input type="hidden" name="action" value="add_tag_id">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
				</td>
			</tr>
		</table>
		
		
	</form>
</div>
</body>
</html>