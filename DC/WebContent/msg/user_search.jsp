<%@page import="com.bitmap.bean.hr.Department"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Search</title>
<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/thickbox.css" rel="stylesheet" type="text/css" media="all">
<script src="../js/clear_form.js"></script>

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%

String page_ = WebUtils.getReqString(request, "page");
String name = WebUtils.getReqString(request, "name");
String surname = WebUtils.getReqString(request, "surname");
String dep_id = WebUtils.getReqString(request, "dep_id");

List paramList = new ArrayList();
paramList.add(new String[]{"name",name});
paramList.add(new String[]{"surname",surname});
paramList.add(new String[]{"dep_id",dep_id});
PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

Iterator IteUser= Personal.selectWithCTRL(ctrl, paramList).iterator();
//Iterator IteUser = Per_Personal.selectWithCTRL(ctrl, paramList).iterator();
%>


</head>
<body>
<div class="wrap_all">
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<b>Search</b>
			</div>
			<div class="content_body">
			<div class="txt_center">
					<form style="margin: 0; padding: 0;" action="user_search.jsp" id="searchForm" method="get">
						Name: <input type="text" name="name" id="name" class="txt_box s200" value="<%=name%>"  autocomplete="off"> 
						Surname: <input type="text" name="surname" id="surname" class="txt_box s200" value="<%=surname%>"  autocomplete="off"> 
					    Department: <bmp:ComboBox name="dep_id" styleClass="txt_box s200" listData="<%=Department.list()%>" value="<%=dep_id%>" >
							<bmp:option value="" text="แสดงทั้งหมด"></bmp:option>
						</bmp:ComboBox>
					
						<button type="submit" name="btn_search" value="true" class="btn_box btn_confirm">ค้นหา</button>
						<!-- <button type="reset" name="btn_reset" id="btn_reset" class="btn_box" onclick="$('#search').val('');">ล้าง</button> -->
						<input type="button" name="reset" value="ล้าง" class="btn_box s50 m_left5 btn_reset" onclick="clear_form('#searchForm');">
					</form>
			</div>
			<br/>
			
			
			<!-- next page -->  
				<div class="center txt_center m_right20"><%=PageControl.navigator_en(ctrl,"user_search.jsp",paramList)%></div>
				<div class="clear"></div>
			<!-- next page  -->
				<table class="bg-image m_top5" width="100%">
					<thead>
						<tr>
						
							<!-- <th align="center">username</th> -->
							<th align="center">Name</th>
							<th align="center">Surname</th>
							<th align="center" width="100"></th>
						</tr>			
					</thead>
						<tr>
						<%
							while (IteUser.hasNext()) {
								Personal per = (Personal) IteUser.next();
							
						%>
							<!-- <td></td> -->
							<td><%=per.getName() %></td>
							<td><%=per.getSurname() %></td>
							<td align="center">
								<button class="btn_box btn_select" data_name="<%=per.getName()%>" data_sur="<%=per.getSurname()%>" data_id="<%=per.getPer_id() %>" >select</button>
							</td>
						</tr>
						<%
							}
						%>
					<tbody>
					</tbody>
				</table>				
	<script type="text/javascript">
	$(function(){
		$(".btn_select").click(function(){ 
			var name = $(this).attr('data_name')+ " " +$(this).attr('data_sur');
			var rec_name = window.opener.$("#receiver_name");
			var rec = window.opener.$("#receiver");
			
			if (rec_name.val().indexOf(name) == -1) {
				if (rec_name.val() != '') {
					rec_name.val(rec_name.val() + ', ' + name);
					rec.val(rec.val() + ',' + $(this).attr('data_id'));
				} else {
					rec_name.val(name);
					rec.val($(this).attr('data_id'));
				}
			}
		    window.close(); 
		}); 
	});
	</script>
			</div>
		</div>
	</div>
</div>
</body>
</html>