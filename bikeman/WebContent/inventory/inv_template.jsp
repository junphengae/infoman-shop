<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
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
<script src="../js/number.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Template</title>
<%
String page_ = WebUtils.getReqString(request, "page");
PageControl ctrl = new PageControl();
ctrl.setLine_per_page(10);

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("INVT_PAGE", page_);
}

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("INVT_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("INVT_PAGE")));
}

List list = InventoryMaster.selectHaveSerial(ctrl);
%>

</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Component</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"inv_template.jsp")%></div>
				<div class="clear"></div>
				
				<div class="dot_line"></div>
				
				<table class="bg-image s_auto">
					<thead>
						<tr>
							<th valign="top" align="center" width="12%">รหัสสินค้า</th>
							<th valign="top" align="center" width="10%">ชื่อสินค้า</th>
							<th align="center" width="10%"></th>
						</tr>
					</thead>
					<tbody>
					<%
						boolean has = true;
						Iterator ite = list.iterator();
						while(ite.hasNext()) {
							InventoryMaster entity = (InventoryMaster) ite.next();
							has = false;
					%>
						<tr>
							<td align="right"><%=entity.getMat_code()%></td>
							<td align="left"><%=entity.getDescription()%></td>
							<td align="left">
								<button class="btn_view" onclick="window.location='temp_view.jsp?mat_code=<%=entity.getMat_code()%>';" title="view component"></button>
							</td>
						</tr>
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