<%-- <%@page import="com.bitmap.bean.hr.CocoTotal"%> --%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.hr.PersonalDetail"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.hr.SumSalary"%>
<%@page import="com.bitmap.bean.hr.Leave"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<%
String export = WebUtils.getReqString(request, "export");
String report_type = WebUtils.getReqString(request, "report_type");
String salary_type = WebUtils.getReqString(request, "salary_type");
String time = WebUtils.getReqString(request, "time");
String year = WebUtils.getReqString(request, "year");
String month = WebUtils.getReqString(request, "month");


List params = new ArrayList();
params.add(new String[]{"year",year});
params.add(new String[]{"month",month});

//Iterator iteLeave = Leave.selectReport(params).iterator();
//Iterator iteSum = SumSalary.selectReport(params).iterator();
Iterator iteSum = SumSalary.selectReport(month, year).iterator();
Iterator iteSumType = SumSalary.selectReportBySalaryType(month, year, salary_type).iterator();
Iterator iteType4 = Personal.reportList().iterator();

%>
<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/theme_print.css" rel="stylesheet" type="text/css" media="all">
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Report Viewer</title>
</head>
<body>
<%
if (report_type.equalsIgnoreCase("3")) {
%>
<div>รายงานการขาดลามาสายของพนักงานประจำ</div>
<div>บริษัท เค-เฟรช จำกัด</div>
<div>ประจำเดือนที่ <%=month %>/ปี <%=year %></div>
<table class="tb">
	<tbody>
		<tr align="center">
			<td>รหัสพนักงาน</td>
			<td>ชื่อ</td>
			<td width="15%">ลากิจ</td>
			<td width="15%">ลาป่วย</td>
			<td width="15%">ลาพักร้อน</td>
			<td width="15%">ขาดงาน</td>
			<td width="15%">มาสาย</td>
		</tr>
		
		<%
		  while(iteSum.hasNext()){
			  SumSalary entity = (SumSalary)iteSum.next();
		%>
		<tr>
			<td><%=entity.getPer_id() %></td>
			<td><%=Personal.selectOnlyPerson(entity.getPer_id()).getName() %> &nbsp;
		<%=Personal.selectOnlyPerson(entity.getPer_id()).getSurname() %></td>
			<td><%=entity.getLeave_business() %></td>
			<td><%=entity.getLeave_sick() %></td>
			<td><%=entity.getLeave_vacation() %></td>
			<td><%=entity.getLeave_missing() %></td>
			<td><%=entity.getLate_hrs_sum() %></td>
		</tr>
		<%
		  } 
		%>
		
		
		
		
		
	</tbody>
</table>

<%
} else if (report_type.equalsIgnoreCase("1")) {
%>

<div>รายงานการนำส่งเงินสมทบ</div>
<div>สำหรับค่าจ้างรายเดือนที่ <%=month %>  /ปี   <%=year %></div>
<div>ชื่อผู้ประกอบการ บริษัท เค-เฟรช จำกัด</div>
<table class="tb">
	<tbody>
		<tr align="center">
			<td>รหัสพนักงาน</td>
			
			<td>ชื่อ นามสกุล</td>
			<td>รหัสบัตรประชาชน</td>
			<td>ฐานเงินเดือน</td>
			<td>ส่ง ปกส</td>
			
		</tr>
		
		<%
		  while(iteSum.hasNext()){
			  SumSalary entity = (SumSalary)iteSum.next();
			  PersonalDetail perDetail = entity.getUIPersonalDetail();
		%>
		<tr>
			<td><%=entity.getPer_id() %></td>
			
			<td>
				<%=Personal.selectOnlyPerson(entity.getPer_id()).getName() %> &nbsp;
				<%=Personal.selectOnlyPerson(entity.getPer_id()).getSurname() %>
			</td>
			<td><%=perDetail.getId_card() %></td>
			<td><%=Money.money(entity.getSalary()) %></td>
			<td><%=Money.money(entity.getSs()) %></td>
			
		</tr>
		<%
		  } 
		%>
	</tbody>
</table>

<%
} else if(report_type.equalsIgnoreCase("2")){
	if (salary_type.equalsIgnoreCase("1")){
%>
<div>รายงานเงินเดือนพนักงานรายเดือน</div>
<div>ประจำเดือนที่ <%=month %> / ปี <%=year %></div>
<table class="tb">
	<tbody>
		<tr align="center">
			<td>รหัส</td>
			<td>ชื่อ นามสกุล</td>
			<td>เลขบัตรประชาชน</td>
			<td>ที่อยู่</td>
			<td>เงินเดือน</td>
			<td>โอที</td>
			<td>เบี้ยเลี้ยง</td>
			<td>โบนัส</td>
			<td>เบี้ยขยัน</td>
			<td>ส่วนต่าง</td>
			<td><u>รวม</u></td>
			<td>ปกส.</td>
			<td>ภาษี</td>
			<td>สะสม</td>
			<td>เบิกล่วงหน้า</td>
			<td>ขาดงาน</td>
			<td>อื่นๆ</td>
			<td><u>สุทธิ</u></td>
			
		</tr>
		
		<%
		  while(iteSumType.hasNext()){
			  SumSalary entity = (SumSalary)iteSumType.next();
			  PersonalDetail perDetail = entity.getUIPersonalDetail();
		%>
		<tr>
			<td><%=entity.getPer_id() %></td>
			<td>
				<%=Personal.selectOnlyPerson(entity.getPer_id()).getName() %>&nbsp;
				<%=Personal.selectOnlyPerson(entity.getPer_id()).getSurname() %>
			</td>
			<td><%=perDetail.getId_card() %></td>
			<td><%=perDetail.getAddress() %></td>
			<td><%=Money.money(entity.getSalary()) %></td>
			<td><%=Money.money(entity.getTotal_ot()) %></td>
			<td><%=Money.money(entity.getAllowance()) %></td>
			<td><%=Money.money(entity.getBonus()) %></td>
			<td><%=Money.money(entity.getDiligence()) %></td>
			<td><%=Money.money(entity.getBal_salary()) %></td>
			<td><%=Money.money(entity.getTotal_salary()) %></td>
			<td><%=Money.money(entity.getSs()) %></td>
			<td><%=Money.money(entity.getTax()) %></td>
			<td><%=Money.money(entity.getSavings()) %></td>
			<td><%=Money.money(entity.getPay_advance()) %></td>
			<td><%=Money.money(entity.getMissing()) %></td>
			<td><%=Money.money(entity.getDeduction()) %></td>
			<td><%=Money.money(entity.getSalary_net()) %></td>
		</tr>
		<%
		  } 
		%>
	</tbody>
</table>	
<%
	}else{
%>
<div>รายงานเงินเดือนพนักงานรายวัน</div>
<div>ประจำเดือนที่  <%=month %>/ ปี <%=year %></div>
<table class="tb">
	<tbody>
		<tr align="center">
			<td>รหัส</td>
			<td>ชื่อ นามสกุล</td>
			<td>เลขบัตรประชาชน</td>
			<td>ที่อยู่</td>
			<td>เงินเดือน</td>
			<td>โอที</td>
			<td>เบี้ยเลี้ยง</td>
			<td>โบนัส</td>
			<td>เบี้ยขยัน</td>
			<td>ส่วนต่าง</td>
			<td><u>รวม</u></td>
			<td>ปกส.</td>
			<td>ภาษี</td>
			<td>สะสม</td>
			<td>เบิกล่วงหน้า</td>
			<td>ขาดงาน</td>
			<td>อื่นๆ</td>
			<td><u>สุทธิ</u></td>
			
		</tr>
		
		<%
		  while(iteSumType.hasNext()){
			  SumSalary entity = (SumSalary)iteSumType.next();
			  PersonalDetail perDetail = entity.getUIPersonalDetail();
		%>
		<tr>
			<td><%=entity.getPer_id() %></td>
			<td>
				<%=Personal.selectOnlyPerson(entity.getPer_id()).getName() %>&nbsp;
				<%=Personal.selectOnlyPerson(entity.getPer_id()).getSurname() %>
			</td>
			<td><%=perDetail.getId_card() %></td>
			<td><%=perDetail.getAddress() %></td>
			<td><%=Money.money(entity.getAmount_coco_sum()) %></td>
			<td><%=Money.money(entity.getAmount_coco_ot_sum()) %></td>
			<td><%=Money.money(entity.getAllowance()) %></td>
			<td><%=Money.money(entity.getBonus()) %></td>
			<td><%=Money.money(entity.getDiligence()) %></td>
			<td><%=Money.money(entity.getBal_salary()) %></td>
			<td><%=Money.money(entity.getTotal_salary()) %></td>
			<td><%=Money.money(entity.getSs()) %></td>
			<td><%=Money.money(entity.getTax()) %></td>
			<td><%=Money.money(entity.getSavings()) %></td>
			<td><%=Money.money(entity.getPay_advance()) %></td>
			<td><%=Money.money(entity.getMissing()) %></td>
			<td><%=Money.money(entity.getDeduction()) %></td>
			<td><%=Money.money(entity.getSalary_net()) %></td>
			
		</tr>
		<%
		  } 
		%>	
	</tbody>
</table>		
<%
	}
}else if (report_type.equalsIgnoreCase("4")) {
%>
<div>รายงานข้อมูลพนักงานทั้งหมด</div>
<div>บริษัท เค-เฟรช จำกัด</div>
<table class="tb">
	<tbody>
		<tr align="center">
			<td>รหัส</td>
			<td>ชื่อ นามสกุล</td>
			<td>เพศ</td>
			<td>เลขบัตรประชาชน</td>
			<td>ที่อยู่</td>
			<td>มือถือ</td>
			<td>โทรศัพท์</td>
			<td>วันเกิด</td>
			<td>email</td>
			<td>วันบรรจุ</td>
			
			
		</tr>
		
		<%
			  while(iteType4.hasNext()) {
				  Personal entity = (Personal)iteType4.next();
				  PersonalDetail perDetail = entity.getUIPerDetail();
		%>
		<tr>
			<td><%=entity.getPer_id() %></td>
			<td>
				<%=entity.getPrefix() %>
				<%=Personal.selectOnlyPerson(entity.getPer_id()).getName() %>&nbsp;
				<%=Personal.selectOnlyPerson(entity.getPer_id()).getSurname() %>
			</td>
			<td><%=(entity.getSex().equalsIgnoreCase("m"))?"ชาย":"หญิง" %></td>
			<td><%=perDetail.getId_card() %></td>
			<td><%=perDetail.getAddress() %></td>
			<td><%=entity.getMobile() %></td>
			<td><%=perDetail.getPhone() %></td>
			<td><%=WebUtils.getDateValue(perDetail.getBirthdate()) %></td>
			<td><%=entity.getEmail() %></td>
			<td><%=WebUtils.getDateValue(entity.getDate_start()) %></td>
		</tr>
		<%
		  } 
		%>	
	</tbody>
</table>		

<%-- <%
} else if (report_type.equalsIgnoreCase("5")) {
%>
<div>รายงานสรุปยอดผลิตมะพร้าวของพนักงาน</div>
<div>ประจำเดือนที่ <%=month %> / ปี <%=year %></div>
<div>บริษัท เค-เฟรช จำกัด</div>
<table class="tb">
	<tbody>
		<tr align="center">
			<td>รหัส</td>
			<td>ชื่อ นามสกุล</td>
			<td>ยอดผลิตมะพร้าว (ลูก)</td>
			<td>ยอดผลิตมะพร้าวโอที (ลูก)</td>
		</tr>
		
		<%
			  while(iteType4.hasNext()) {
				  Personal entity = (Personal)iteType4.next();
				  PersonalDetail perDetail = entity.getUIPerDetail();
				  
				  
		%>
		<tr>
			<td><%=entity.getPer_id() %></td>
			<td>
				<%=entity.getPrefix() %>
				<%=Personal.selectOnlyPerson(entity.getPer_id()).getName() %>&nbsp;
				<%=Personal.selectOnlyPerson(entity.getPer_id()).getSurname() %>
			</td>
			
			<%
						String coco[] = CocoTotal.count_coco(entity.getPer_id(), month, year); 
			%>
			<td><%=coco[0] %> </td>
			<td><%=coco[2] %></td>
			
		    	<td><%=(entity.getSex().equalsIgnoreCase("m"))?"ชาย":"หญิง" %></td>
			<td> <%=perDetail.getId_card() %></td>
		
		</tr>
		<%
		  } 
		%>	
	</tbody>
</table>	 --%>
<%
}
%>
</body>
</html>