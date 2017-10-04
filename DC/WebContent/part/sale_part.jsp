<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.ServiceSale"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>

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
<script src="../js/clear_form.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Sale Parts</title>
<%
	List paramList = new ArrayList();

String status = WebUtils.getReqString(request, "status");
String service_type = WebUtils.getReqString(request, "service_type");
String search = WebUtils.getReqString(request, "search");

if(service_type.length() == 0){
	service_type = ServiceSale.SERVICE_SALE_PARTS;
}

paramList.add(new String[]{"status",status});
paramList.add(new String[]{"service_type",service_type});
paramList.add(new String[]{"search",search});

session.setAttribute("SALE_SEARCH", paramList);

String page_ = WebUtils.getReqString(request, "page");
PageControl ctrl = new PageControl();
ctrl.setLine_per_page(20);

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("SALE_PAGE", page_);
}

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("SALE_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("SALE_PAGE")));
}

List list = ServiceSale.selectWithCTRL(ctrl, paramList);
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Sale Parts Order</div>
				<div class="right">
					<button class="btn_box btn_add" onclick="window.location='sale_part_create.jsp';">Create Sale Order</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="sale_part.jsp" id="search" method="get">
						Search: <input type="text" name="search" class="txt_box" value="<%=search%>"> 
						Type: 
						<bmp:ComboBox name="service_type" styleClass="txt_box s150" listData="<%=ServiceSale.ddl_service_en()%>" value="<%=service_type%>"></bmp:ComboBox> 
						Status:
						<bmp:ComboBox name="status" styleClass="txt_box s200" listData="<%=ServiceSale.ddl_en() %>" value="<%=status%>">
							<bmp:option value="" text="--- SHOW All ---"></bmp:option>
						</bmp:ComboBox> 
						<input type="submit" name="submit" value="Search" class="btn_box btn_confirm">
						<input type="button" name="reset" value="Reset" class="btn_box s50 m_left5" onclick="clear_form('#search');">
						<input type="hidden" name="action" value="search">
						
					</form>
				</div>
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"sale_part.jsp",paramList)%></div>
				<div class="clear"></div>
				
				<div class="dot_line"></div>
				
				<table class="bg-image s_auto">
					<thead>
						<tr>
							<th valign="top" align="center" width="10%">ID</th>
							<th valign="top" align="center" width="20%">Customer</th>
							<th valign="top" align="center" width="20%">Plate</th>
							<th valign="top" align="center" width="20%">Date/Time</th>
							<th valign="top" align="center" width="15%">TOTAL</th>
							<th valign="top" align="center" width="10%">STATUS</th>
							<th valign="top" align="left" width="5%"></th>
						</tr>
					</thead>
					<tbody>
					<%
						Iterator ite = list.iterator();
									while(ite.hasNext()) {
										ServiceSale entity = (ServiceSale) ite.next();
					%>
						<tr>
							<td align="center"><%=entity.getId()%></td>
							<td align="left"><%=entity.getCus_name()%></td>
							<td align="left"><%=entity.getV_plate()%></td>
							<td align="center"><%=WebUtils.getDateTimeValue(entity.getCreate_date())%></td>
							<td align="right"><%=Money.money(entity.getTotal_amount())%></td>
							<td align="center"><%=ServiceSale.status(entity.getStatus())%></td>
							<td align="center">
								<%
									if(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_OPENING)){
								%>
								<a class="btn_update" href="sale_part_update.jsp?id=<%=entity.getId()%>" title="Edit Sale Order"></a>
								<%} else {%>
								<a class="btn_view" href="sale_part_info.jsp?id=<%=entity.getId()%>" title="View Sale Order"></a>
								<%}%>
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