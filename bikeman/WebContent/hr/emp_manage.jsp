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

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/barcode.css" rel="stylesheet" type="text/css" media="all"> 
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายชื่อพนักงาน</title>
<%
List paramList = new ArrayList();

String search = WebUtils.getReqString(request, "search");

paramList.add(new String[]{"search",search});

session.setAttribute("EMP_SEARCH", paramList);
/*
String dep_id = WebUtils.getReqString(request, "dep_id");
String div_id = WebUtils.getReqString(request, "div_id");
String pos_id = WebUtils.getReqString(request, "pos_id");

paramList.add(new String[]{"dep_id",dep_id});
paramList.add(new String[]{"div_id",div_id});
paramList.add(new String[]{"pos_id",pos_id});*/

String page_ = WebUtils.getReqString(request, "page");
PageControl ctrl = new PageControl();
ctrl.setLine_per_page(20);

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("EMP_PAGE", page_);
}

if (WebUtils.getReqString(request, "btn_search").length() == 0 && session.getAttribute("EMP_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("EMP_PAGE")));
}

Iterator perIte = Personal.selectWithCTRL(ctrl, paramList).iterator();
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายชื่อพนักงาน</div>
				<div class="right">
					<!-- 
						<button type="button"   class="btn_box" onclick="javascript : window.location='emp_sum_salary.jsp'">ข้อมูลเงินเดือนพนักงาน</button>
					 -->
					</div>
				
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="txt_center">
					<form style="margin: 0; padding: 0;" action="emp_manage.jsp" id="searchForm" method="get">
						ค้นหา: <input type="text" name="search" id="search" value="<%=search%>" class="txt_box s200" autocomplete="off"> 
						<button type="submit" name="btn_search" value="true" class="btn_box btn_confirm">ค้นหา</button>
						<button type="button" name="btn_reset" id="btn_reset" class="btn_box" onclick="$('#search').val('');">ล้าง</button>
					</form>
				</div>
				
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"emp_manage.jsp",paramList)%></div>
				<div class="clear"></div>
				 
				<table class="columntop bg-image breakword "  width="100%">
					<thead>
						<tr>
						
							<th width="9.5%" align="center">ID</th>
							<th width="9.5%" align="center">ชื่อ</th>
							<th width="14.5%" align="center">นามสกุล</th>
							<th width="14.5%" align="center">ฝ่าย</th>
							<th width="14.5%" align="center">แผนก</th>
							<th width="14.5%" align="center">ตำแหน่ง</th>
							<th width="10.5%" align="center">สถานะ</th>
							<th width="6.5%" align="center"></th>
							
						</tr>
					</thead>
					<tbody>
						<tr> 
						 <td colspan="10" style="padding: 0px 0px 0px 0px;" width="100%">
							 <div class="scroll">
							  <table class="bg-image breakword"  style="border-collapse: collapse;" width="100%">
					
								   <%
									while(perIte.hasNext()){ 
									Personal per = (Personal) perIte.next();
									
									if(!per.getPer_id().equalsIgnoreCase("dev01")){
										
								  %>
								   <tr>
									<td align="center" width="10%"><%=per.getPer_id()%></td>
									<td width="10%"><%=per.getName()%></td>
									<td width="15%"><%=per.getSurname()%></td>
									<td width="15%"><%=per.getUIDepartment().getDep_name_th()%></td>
									<td width="15%"><%=per.getUIDivision().getDiv_name_th()%></td>
									<td width="15%"><%=per.getUIPosition().getPos_name_th()%></td>
									<td align="right" width="10%">
										<%=per.getUISecurity().getActive()%> 
										<a class="btn_update thickbox" lang="emp_status.jsp?user_id=<%=per.getPer_id()%>&width=500&height=220" title="Update Employee Status"></a>
									 </td>
									<td align="center" width="5%">
										<a class="btn_view" id="getEmp" href="emp_info.jsp?per_id=<%=per.getPer_id()%>"></a>
									</td>
									
								   </tr>
								   <%
								   }
								   } %>
								   </table>
								</div>
							</td>
						</tr>
							
					</tbody>
					
				</table>
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>