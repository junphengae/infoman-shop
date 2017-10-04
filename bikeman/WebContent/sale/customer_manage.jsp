<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.security.SecurityUser"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
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
<script src="../js/clear_form.js"></script>
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
<title>Customer List</title>
<%
List paramList = new ArrayList();

String keyword = WebUtils.getReqString(request, "keyword");

paramList.add(new String[]{"keyword",keyword});

session.setAttribute("CUS_SEARCH", paramList);

String page_ = WebUtils.getReqString(request, "page");
PageControl ctrl = new PageControl();
ctrl.setLine_per_page(20);

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("CUS_PAGE", page_);
}

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("CUS_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("CUS_PAGE")));
}

List list = Customer.selectWithCTRL(ctrl, paramList);
%>
</head>
<body onload="$('#keyword').focus();">

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Customer Search</div>
				<div class="right">
					<button class="btn_box btn_add thickbox" title="Create New Customer" lang="customer_add.jsp?1=1">Create New Customer</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="customer_manage.jsp" id="search" method="get">
						Search: 
						<input type="text" class="s150 txt_box" name="keyword" id="keyword" value="<%=keyword%>" autocomplete="off">  
						<input type="submit" name="submit" value="Search" class="btn_box btn_confirm">
						<input type="button" name="reset" value="Reset" class="btn_box s50 m_left5" onclick="clear_form('#search');$('#keyword').focus();">
						<input type="hidden" name="action" value="search">
						
					</form>
				</div>
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"customer_manage.jsp",paramList)%></div>
				<div class="clear"></div>
				
				<div class="dot_line"></div>
				
				<table class="bg-image s_auto">
					<thead>
						<tr>
							<th valign="top" align="left" width="20%">Name</th>
							<th valign="top" align="left" width="20%">Mobile</th>
							<th valign="top" align="left" width="20%">Phone</th>
							<th valign="top" align="left" width="30%">Address</th>
							<th valign="top" align="right" width="10%"></th>
						</tr>
					</thead>
					<tbody>
					<%
						boolean has = true;
						Iterator ite = list.iterator();
						while(ite.hasNext()) {
							Customer entity = (Customer) ite.next();
							has = false;
					%>
						<tr>
							<td><%=entity.getCus_name_th() + " " + entity.getCus_surname_th()%></td>
							<td><%=entity.getCus_mobile() %></td>
							<td><%=entity.getCus_phone() %></td>
							<td><%=entity.getCus_address() %></td>
							<td align="center">
								<a class="btn_view" href="vehiclelist_info.jsp?cus_id=<%=entity.getCus_id()%>" title="View Customer Information"></a>
							</td>
						</tr>
					<%
						}
						if(has){
					%>
						<tr><td colspan="5" align="center">Customer cannot be found : <button class="btn_box btn_add thickbox" title="Create New Customer" lang="customer_add.jsp?1=1">Create New Customer</button></td></tr>
					<%
						}
					%>
					</tbody>
				</table>
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>