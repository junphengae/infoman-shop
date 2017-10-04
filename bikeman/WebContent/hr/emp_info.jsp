<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="com.bitmap.bean.hr.SumSalary"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.hr.Salary"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="com.bitmap.security.SecurityRole"%>
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
<title>ข้อมูลพนักงาน</title>
<%
	String per_id = WebUtils.getReqString(request,"per_id");
	Personal per = Personal.select(per_id);
	SecurityUser user = SecurityUser.select(per_id);
	PersonalDetail perDetail = per.getUIPerDetail();
	Salary salary = Salary.select(per_id); 
	
	String year = DBUtility.getCurrentYear()+"";
	SumSalary sum_leave = SumSalary.countLeaveAmount(year, per_id);
%>
<script type="text/javascript">
$(function(){
	$( "#date_start" ).datepicker({
		showOtherMonths: true,
		selectOtherMonths: true,
		changeYear: true,
		changeMonth: true
	});
	
	var form = $('#infoForm');
	var dep_id = $('#dep_id');
	var div_id = $('#div_id');
	var pos_id = $('#pos_id');
	
	dep_id.change(function(){
		ajax_load();
		$.getJSON('../EmpManageServlet',{action:'getDivision',dep_id:$(this).val()},
			function(j){
				ajax_remove();
				var options = '<option value="">--- select ---</option>';
	            for (var i = 0; i < j.length; i++) {
	                options += '<option value="' + j[i].div_id + '">' + j[i].div_name_th + '</option>';
	            }
             	div_id.html(options);
             	pos_id.html('<option value="">--- select ---</option>');
			}
		);
	});
	
	div_id.change(function(){
		ajax_load();
		$.getJSON('../EmpManageServlet',{action:'getPosition',div_id:$(this).val()},
			function(j){
				ajax_remove();
				var options = '<option value="">--- select ---</option>';
	            for (var i = 0; i < j.length; i++) {
	                options += '<option value="' + j[i].pos_id + '">' + j[i].pos_name_th + '</option>';
	            }
             	pos_id.html(options);
			}
		);
	});
	
	$.metadata.setType("attr", "validate");
	var v = form.validate({
		submitHandler: function(){
			ajax_load();
			var addData = form.serialize();
			$.post('../EmpManageServlet',addData,function(data){
				ajax_remove();
				if (data.status == 'success') {
					window.location ="emp_manage.jsp";
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
				<div class="left">รายชื่อพนักงาน &gt; ข้อมูลพนักงาน</div>
				<div class="right">
					<%-- <button class="btn_box" onclick="javascript: window.location='emp_summary.jsp?per_id=<%=per.getPer_id()%>';">สรุปข้อมูลพนักงาน</button> --%>
					
					<%--
						<button class="btn_box" onclick="javascript: window.location='leave_manage.jsp?per_id=<%=per_id%>';">การขาด/ลา/มาสาย</button>
						<button class="btn_box" onclick="javascript: window.location='ot_manage.jsp?per_id=<%=per.getPer_id()%>';">ข้อมูล OT</button>
					 --%>
					<button class="btn_box" onclick="javascript: window.location='<%=LinkControl.link("emp_manage.jsp", (List) session.getAttribute("EMP_SEARCH"))%>';">ย้อนกลับ</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<fieldset class="fset s450 left min_h300">
					<legend>ข้อมูลพื้นฐาน</legend>
					<table cellpadding="3" cellspacing="3" border="0"  width="100%">
						<tbody>
							<tr>
								<td align="left" width="25%"><label>ID ระบบ</label></td>
								<td align="left" width="75%">: <%=per.getPer_id()%></td>
							</tr>
							
							<%-- <tr>
								<td><label>รหัสพนักงาน</label></td>
								<td align="left">: 
								<%if (per.getTag_id().length()>0) { %>
									<%=per.getTag_id() %>
								<%}else{ %>	
									<button id="btn_emp_id" class="btn_box thickbox" lang="emp_id.jsp?per_id=<%=per_id%>&emp_type=<%=per.getEmp_type() %>&date_start=<%=WebUtils.getDateValue(per.getDate_start())%>" title="กำหนดรหัสพนักงาน"> กำหนดรหัสพนักงาน </button>
								<%} %>
								</td>
							</tr> --%>
							
							<tr>
								<td><label>รหัสพนักงาน</label></td>
								<td align="left">: 
									<%=per.getTag_id() %>
									<button id="btn_emp_id" class="btn_box thickbox" lang="emp_id.jsp?per_id=<%=per_id%>" title="กำหนดรหัสพนักงาน"> กำหนดรหัสพนักงาน </button>
								</td>
							</tr>
							
							<%-- <tr>
								<td align="left" width="30%"><label>ประเภทพนักงาน</label></td>
								<td align="left" width="70%">: 
								  <%=(per.getEmp_type().length()>0)?Personal.empType(per.getEmp_type()):""%>
								</td>
							</tr> --%>
							
							<tr>
								<td><label>ชื่อ</label></td>
								<td>: <%=per.getPrefix() %> <%=per.getName() %> &nbsp;<%=per.getSurname() %></td>
							</tr>
							<tr>
								<td><label>เพศ</label></td>
								<td>: <%=(per.getSex().equalsIgnoreCase("m"))?"ชาย":"หญิง"%></td>
							</tr>
							<tr>
								<td><label>โทรศัพท์มือถือ</label></td>
								<td>: <%=per.getMobile() %></td>
							</tr>
							<tr>
								<td><label>Email</label></td>
								<td>: <%=per.getEmail() %></td>
							</tr>
							<tr>
								<td><label>ฝ่าย</label></td>
								<td>: <%=per.getUIDepartment().getDep_name_th()%></td>
							</tr>
							<tr>
								<td><label>แผนก</label></td>
								<td>: <%=per.getUIDivision().getDiv_name_th()%></td>
							</tr>
							<tr>
								<td><label>ตำแหน่ง</label></td>
								<td>: <%=per.getUIPosition().getPos_name_th()%></td>
							</tr>
							<tr>
								<td><label>วันที่บรรจุ</label></td>
								<td>: <%=(per.getDate_start()!=null)?WebUtils.DATE_FORMAT_EN.format(per.getDate_start()):""%></td>
							</tr>
						</tbody>
					</table>
					<div class="center txt_center"><button class="btn_box btn_confirm" onclick="javascript: window.location='emp_edit.jsp?per_id=<%=per_id%>';">แก้ไข</button></div>
				</fieldset>
				
				<fieldset class="fset s450 right min_h300">
					<legend>ข้อมูลเพิ่มเติม</legend>
					<table cellpadding="3" cellspacing="3" border="0"  width="100%">
						<tbody>
							<tr>
								<td align="left" width="33%"><label>รหัสบัตร ปชช.</label></td>
								<td align="left" width="67%">: <%=perDetail.getId_card()%></td>
							</tr>
							<tr valign="top">
								<td><label>ที่อยู่</label></td>
								<td>: <%=perDetail.getAddress()%></td>
							</tr>
							<tr>
								<td><label>โทรศัพท์</label></td>
								<td>: <%=perDetail.getPhone()%></td>
							</tr>
							<tr>
								<td><label>วัน/เดือน/ปีเกิด</label></td>
								<td>: <%=(perDetail.getBirthdate()!=null)?WebUtils.DATE_FORMAT_EN.format(perDetail.getBirthdate()):""%></td>
							</tr>
							<tr>
								<td><label>บุคคลอ้างอิง</label></td>
								<td>: <%=perDetail.getRef_name()%></td>
							</tr>
							<tr>
								<td><label>เบอร์โทรบุคคลอ้างอิง</label></td>
								<td>: <%=perDetail.getRef_phone()%></td>
							</tr>
						</tbody>
					</table>
						<div class="center txt_center"><button class="btn_box btn_confirm" onclick="javascript: window.location='emp_edit_detail.jsp?per_id=<%=per_id%>';">แก้ไข</button></div>
				</fieldset>
				<div class="clear"></div>
				
			<%-- 	
				<fieldset class="fset">
					<legend>ข้อมูลการทำงาน</legend>
					<div class="left s600">
					<table cellpadding="3" cellspacing="3" border="0"  width="98%">
						<tbody>
							
							<% String flag = Salary.flagTax(salary.getFlag_tax()); %>
							<tr>
								<td align="left"><label>การเสียภาษี</label></td>
								<td align="left">: 
								  <%=flag %>
								  <%=(salary.getFlag_tax().length()>0)?Salary.flagTax(salary.getFlag_tax()):""%>
								</td>
							</tr>
							<tr>
								<td align="left"><label>ฐานเงินเดือน</label></td>
								<td align="left">: 
									<%=Money.money(salary.getSalary())%> <%if (salary.getSalary().length()==0){%> <i><font color="red" size="2">ยังไม่ได้ระบุฐานเงินเดือน</font></i>    <% }else{ %>&nbsp;บาท <%} %>
									<%if (salary.getSalary_type().length()>0){ %>
									&nbsp;<button id="btn_chg_salary" class="btn_box thickbox" lang="emp_salary_edit.jsp?per_id=<%=per_id%>&salary=<%=salary.getSalary() %>&height=150&width=440" title="แก้ไขข้อมูลฐานเงินเดือนพนักงาน" >แก้ไขฐานเงินเดือน</button>
									<%} %>
								</td>
							</tr>
							
							<tr>
								<td align="left" width="30%"><label>ประเภทพนักงาน</label></td>
								<td align="left" width="70%">: 
								  <%=(salary.getSalary_type().length()>0)?Salary.salaryType(salary.getSalary_type()):""%>
								</td>
							</tr>
							
							<tr valign="top">
								<td><label>สิทธิ์ลาพักร้อน</label></td>
								<td>: <%=salary.getLimit_vacation()%> <%if (salary.getLimit_vacation().length()==0){}else{ %>&nbsp;วัน <%} %></td>
							</tr>
							<tr>
								<td><label>สิทธิ์ลาป่วย</label></td>
								<td>: <%=salary.getLimit_sick()%> <%if (salary.getLimit_sick().length()==0){}else{ %>&nbsp;วัน <%} %></td>
							</tr>
							<tr>
									<td><label>สิทธิ์ลากิจ</label></td>
								<td>: <%=salary.getLimit_business()%> <%if (salary.getLimit_business().length()==0){}else{ %>&nbsp;วัน<%} %></td>
							</tr>
						
							
						</tbody>
					</table>
					</div>
					
					<div class="right s300">
						<div class="box">
							<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="90%">
								<tbody>
							 	<%
									Double bus_used = Double.parseDouble(sum_leave.getLeave_business()) ;
									Double bus_limit = Double.parseDouble(salary.getLimit_business());
									Double bus_total = bus_limit-bus_used;
									String bus = Double.toString(bus_total);
									
									Double sik_used = Double.parseDouble(sum_leave.getLeave_sick()) ;
									Double sik_limit = Double.parseDouble(salary.getLimit_sick());
									Double sik_total = sik_limit-sik_used;
									String sik = Double.toString(sik_total);
									
									Double vac_used = Double.parseDouble(sum_leave.getLeave_vacation()) ;
									Double vac_limit = Double.parseDouble(salary.getLimit_vacation());
									Double vac_total = vac_limit-vac_used;
									String vac = Double.toString(vac_total);
								%> 
										<tr>
											<td align="left" width="70%">ลากิจใช้ไป</td>
											<td>:  
											<%=bus %>
											<%=sum_leave.getLeave_business() %>  
											<%if(sum_leave.getLeave_business().length()>0){%>
												<%=sum_leave.getLeave_business() %> วัน
											<% }else {%>
												0
											<% } %>
											</td>
										<tr>
										<tr>
											<td align="left" width="70%">ลาป่วยใช้ไป</td>
											<td>:
											 <%=sik %>
											<%=sum_leave.getLeave_sick() %> 
											<%if(sum_leave.getLeave_sick().length()>0){%>
												<%=sum_leave.getLeave_sick() %> วัน
											<% }else {%>
												0
											<% } %>
											 </td>
										<tr>
										<tr>
											<td align="left" width="70%">ลาพักร้อนใช้ไป</td>
											<td>: 
											<%=vac %>
											<%=sum_leave.getLeave_vacation() %>  
											<%if(sum_leave.getLeave_vacation().length()>0){%>
												<%=sum_leave.getLeave_vacation() %> วัน
											<% }else {%>
												0
											<% } %>
											</td>
										<tr>
							</table>
						</div>
					</div>
					
					<div class="clear"></div>
					
					
					<div class="center txt_center">
						<button class="btn_box btn_confirm" onclick="javascript: window.location='emp_salary.jsp?per_id=<%=per_id%>';">แก้ไข</button>
						
					</div>
				</fieldset>
				 --%>
				
				<fieldset class="fset">
					<legend>User &amp; Password</legend>
					<input type="hidden" name="user_id" id="user_id" value="<%=per_id%>">
					<div class="s500 detail_wrap">
						<div>
							<div class="s150 left">User Name</div><div class="s10 left">:</div>
							<div class="s300 left"><input type="text" name="user_name" id="user_name" class="txt_box s250" value="<%=user.getUser_name() %>"></div><div class="clear"></div>
						</div>
						<div>
							<div class="s150 left">Password</div><div class="s10 left">:</div>
							<div class="s300 left"><input type="password" name="password" id="password" class="txt_box s250"></div><div class="clear"></div>
						</div>
						<div>
							<div class="s150 left">Confirm Password</div><div class="s10 left">:</div>
							<div class="s300 left"><input type="password" name="confirm-password" id="confirm-password" class="txt_box s250"></div><div class="clear"></div>
						</div>
						<div class="center txt_center">
							<input type="button" class="btn_box s60" id="btn_save_pass" value="Save">
							<input type="button" class="btn_box s60 m_left5" id="btn_reset_pass" value="Reset">
							<div class="clear"></div>
						</div>
						<div class="msg_error" id="msg_password"></div>
					</div>
				</fieldset>
				
				
				<fieldset class="fset">
					<legend>สิทธิ์การเข้าใช้งานระบบ</legend>
					<div class="s500 detail_wrap">
						<div class="s200 left">
							<div class="s200">สิทธิ์ทั้งหมดในระบบ</div>
							<div class="s200 ">
								<bmp:ComboBox name="addRoleId" styleClass="s200 h200"  multiple="true" listData="<%=SecurityRole.selectList(per_id)%>"></bmp:ComboBox>
							</div>
						</div>
						<div class="s100 left txt_center">
							<div id="btn_addRole" class="s60 center btn_box" style="margin-top: 85px;">มอบสิทธิ์ &gt;&gt;</div>
							<div id="btn_delRole" class="s60 center btn_box" style="margin-top: 10px;">ยกเลิกสิทธิ์ &lt;&lt;</div>
						</div>
						<div class="s200 left">
							<div class="s200">สิทธิ์ที่พนักงานได้รับ</div>
							<div class="s200 ">
								<bmp:ComboBox name="delRoleId" styleClass="s200 h200" multiple="true" listData="<%=SecurityRole.selectUserRole(per_id)%>"></bmp:ComboBox>
							</div>
						</div>
						<div class="clear"></div>
					</div>
				</fieldset>
				
				<script type="text/javascript">
				$(function(){
					var $addRole = $('#addRoleId');
					var $delRole = $('#delRoleId');
					var $user_id = $('#user_id').val();
					var $user_name = $('#user_name');
					var $pass = $('#password');
					var $pass2 = $('#confirm-password');
					var $msg_password = $('#msg_password');
					
					$('#btn_reset_pass').click(function(){
						$user_name.val('').css({'border-color':'#cccccc'}).focus();
						$pass.val('').css({'border-color':'#cccccc'});
						$pass2.val('').css({'border-color':'#cccccc'});
					});
					
					$('#btn_save_pass').click(function(){
						if ($user_name.val()=='') {
							$user_name.css({'border-color':'red'}).focus();
						} else {
							$user_name.css({'border-color':'#cccccc'});
							if ($pass.val()=='') {
								$pass.css({'border-color':'red'}).focus();
							} else {
								$pass.css({'border-color':'#cccccc'});
								if ($pass2.val()=='') {
									$pass2.css({'border-color':'red'}).focus();
								} else {
									if ($pass.val()==$pass2.val()) {
										$pass.css({'border-color':'#cccccc'});
										$pass2.css({'border-color':'#cccccc'});
										tb_load();
										$.post('../EmpManageServlet',{action:'savePass',user_id:$user_id,user_name:$user_name.val(),password:$pass.val()},
												function(resData){
													tb_remove();
													if (resData.status == 'success') {
														$msg_password.text('Save User Name & Password ' + resData.status).show().fadeOut(3500);
													}else {
														tb_remove();
														$msg_password.text(resData.message).show().fadeOut(3500);
														$( "#user_name" ).val("");
														$( "#user_name" ).focus();
													}
													
												},'json');
										return false;
									} else {
										$pass.css({'border-color':'red'}).focus().val('');
										$pass2.css({'border-color':'red'}).val('');
										$msg_password.text('Password ทั้ง 2 ช่องไม่ตรงกัน กรุณาตรวจสอบใหม่').show().fadeOut(3500);
									}
								}
							}
						}
					});
					
					$('#btn_addRole').click(function(){
						var $addRoleSelect = $addRole.children('option:selected');
						if ($addRoleSelect.size() == 1) {
							ajax_load();
							$.post('../EmpManageServlet',{action:'addRole',user_id:$user_id,role_id:$addRoleSelect.val()},
									function(resData){
										ajax_remove();
										if (resData.status == 'success') {
											$delRole.append('<option value="' + $addRoleSelect.val() + '">' + $addRoleSelect.text() + '</option>');//append(new Option($addRoleSelect.text(),$addRoleSelect.val()));//
											$addRoleSelect.remove();
										}
									},
								'json'
							);
						} else if ($addRoleSelect.size() == 0) {
							alert('โปรดเลือกสิทธิ์ที่ต้องการมอบ!');
						} else if ($addRoleSelect.size() > 1) {
							alert('สามารถเลือกสิทธิ์ที่ต้องการมอบได้ครั้งละ 1 สิทธิ์เท่านั้น!');
						} 
					});
					
					$('#btn_delRole').click(function(){
						var $delRoleSelect = $delRole.children('option:selected');
						if ($delRoleSelect.size() == 1) {
							ajax_load();
							$.post('../EmpManageServlet',{action:'delRole',user_id:$user_id,role_id:$delRoleSelect.val()},
									function(resData){
										ajax_remove();
										if (resData.status == 'success') {
											$addRole.append('<option value="' + $delRoleSelect.val() + '">' + $delRoleSelect.text() + '</option>');//append(new Option($delRoleSelect.text(),$delRoleSelect.val()));//
											$delRoleSelect.remove();
										}
									},
								'json'
							);
						} else if ($delRoleSelect.size() == 0) {
							alert('โปรดเลือกสิทธิ์ที่ต้องการยกเลิก!');
						} else if ($delRoleSelect.size() > 1) {
							alert('สามารถเลือกสิทธิ์ที่ต้องการยกเลิกได้ครั้งละ 1 สิทธิ์เท่านั้น!');  
						} 
					});
				});
			</script>
				
				<div class="clear"></div>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>