<%@page import="com.bitmap.bean.hr.Salary"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.hr.SumSalary"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.webutils.customtag.ComboBoxTag"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ข้อมูลเงินเดือนพนักงาน</title>

<%
String search = WebUtils.getReqString(request, "search");
String month = WebUtils.getReqString(request, "month");
String year = WebUtils.getReqString(request, "year");
String status_tax = WebUtils.getReqString(request, "status_tax");

List param = new ArrayList();
param.add(new String[]{"search",search});
if (year.length() == 0) {
	year = DBUtility.getCurrentYear() + "";
	param.add(new String[]{"year",DBUtility.getCurrentYear() + ""});
} else {
	param.add(new String[]{"year",year});
}
if (month.length() == 0) {
	Calendar c = DBUtility.calendar();
	month = (c.get(Calendar.MONTH) + 1) + "";
	param.add(new String[]{"month",(c.get(Calendar.MONTH) + 1) + ""});
} else {
	param.add(new String[]{"month",month});
}
param.add(new String[]{"status_tax",status_tax});

session.setAttribute("EMP_SEARCH", param);

String page_ = WebUtils.getReqString(request, "page");
PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("EMP_PAGE", page_);
}

if (WebUtils.getReqString(request, "btn_search").length() == 0 && session.getAttribute("EMP_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("EMP_PAGE")));
}

Iterator ite = Personal.selectPerSalaryWithCTRL(ctrl, param).iterator();


%>

</head>
<body>
<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div>ข้อมูลเงินเดือนพนักงาน</div>
				
			</div>
			<div class="content_body">
			<div class="left">
					<form style="margin: 0; padding: 0;" action="emp_sum_salary.jsp" id="searchForm" method="get">
						ประเภท : 	<bmp:ComboBox name="status_tax" listData="<%=SumSalary.statusTaxList() %>"  styleClass="txt_box input_focus" width="100px" value="<%=status_tax %>" >
									<bmp:option value="" text="ทั้งหมด"></bmp:option>
								</bmp:ComboBox>
						เดือน :<bmp:ComboBox name="month" styleClass="txt_box s100" style="<%=ComboBoxTag.EngMonthList%>" value="<%=month %>"></bmp:ComboBox>
						ปี :<bmp:ComboBox name="year" styleClass="txt_box s100" style="<%=ComboBoxTag.EngYearList%>" value="<%=year %>"></bmp:ComboBox>
						<button type="submit" name="btn_search" value="true" class="btn_box btn_confirm">ค้นหา</button>
					</form>
			</div>	
			<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"emp_sum_salary.jsp",param)%></div>
			<div class="clear"></div>
			
				<table class="bg-image s_auto m_top5">
					<thead>
						<tr>
							<th width="10%" align="center">ID</th>
							<th width="10%" align="center">ชื่อ</th>
							<th width="15%" align="center">นามสกุล</th>
							<th width="10%" align="center">ฐานเงินเดือน</th>
							<th width="10%" align="center">ภาษี</th>
							<th width="15%" align="center">เงินเดือนสุทธิ</th>
							<th width="15%" align="center">&nbsp;</th>
						</tr>
					</thead>
					<%
					while(ite.hasNext()){
						Personal per = (Personal)ite.next();
						Salary salary = Salary.select(per.getPer_id());
					%>
					<tbody>
						<tr>
							<td><%=per.getPer_id() %></td>
							<td><%=per.getName() %></td>
							<td><%=per.getSurname() %></td>
							<td>
								<%=Money.money(salary.getSalary()) %>
								<%if(per.getUISalary().getFlag_tax().equalsIgnoreCase("2")){%>
								<img src="../images/icon/fav.png" alt="เสียภาษี" title="เสียภาษี">
								<%} %>
							</td>
							<td>
							
								<%= Money.money(per.getUISumSalary().getTax()) %>
								<%if(per.getUISalary().getFlag_tax().equalsIgnoreCase("2")){ 
									if(per.getUISumSalary().getTax().length()==0){ %>
										 <font color="red">กรุณากรอกภาษี!</font>
									<%} %>
								<%} %>
							</td>
							<td><%=Money.money(per.getUISumSalary().getSalary_net()) %></td>
							<td>
							<%
							if(per.getUISumSalary().getSalary_net().length()>0) {
							%>
							<button class="btn_box" onclick="javascript: window.location='emp_summary.jsp?per_id=<%=per.getPer_id()%>&month=<%=month%>&year=<%=year%>';">ดู/แก้ไข</button>
							<%}else{ %>
							
								<%  
									if(salary.getSalary().length()>0){ %>
									<button class="btn_box btn_confirm" onclick="javascript: window.location='emp_summary.jsp?per_id=<%=per.getPer_id()%>&month=<%=month%>&year=<%=year%>';">สร้าง</button> 
								<% }else{ %>
									ต้องระบุฐานเงินเดือนก่อน!
								<% } %>
							<%} %>
							</td>
						</tr>
					</tbody>
					<%
					}
					%>
				</table>
			
			</div>
		</div>
	</div>
</div>
</body>
</html>