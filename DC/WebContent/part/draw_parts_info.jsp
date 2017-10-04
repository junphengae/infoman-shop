<%@page import="java.util.Map"%>
<%@page import="com.bitmap.bean.dc.SaleServicePartDetail"%>
<%@page import="com.bitmap.bean.dc.SaleOrderService"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.ServicePartDetail"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="com.bitmap.bean.parts.ServiceSale"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.parts.PartCategories"%>
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
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/popup.js"></script>
<script src="../js/number.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Sale Parts</title>
<%
String branch_name = WebUtils.getReqString(request, "branch_name");
String id = WebUtils.getReqString(request, "id");
SaleOrderService entity = new SaleOrderService();
WebUtils.bindReqToEntity(entity, request);
SaleOrderService.select(entity);

List paramsList = new ArrayList();

paramsList.add(new String[]{"number",id});
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Order ID: <%=entity.getId()%></div>
				<div class="right">
					<button class="btn_box" onclick="window.location='<%=LinkControl.link("draw_parts.jsp", (List)session.getAttribute("DRAW_SEARCH"))%>';">Back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<form id="sale_part_form" onsubmit="return false;">
				<fieldset class="fset">
					<legend>Parts Sale Order</legend>
						<div class="left s400">
							<table class="s_auto">
								<tbody>
									<tr>
										<td width="30%">Order ID</td>
										<td width="70%">: <%=entity.getId()%></td>
									</tr>
									<tr>
										<td>Customer Name</td>
										<td>: <%=branch_name%></td>
									</tr>
								</tbody>
							</table>
						</div>
						
						<div class="right s400">
							<table class="s_auto">
								<tbody>
									<tr>
										<td width="30%">Order Date</td>
										<td width="70%">: <%=WebUtils.getDateTimeValue(entity.getDuedate())%></td>
									</tr>
									<tr>
										<td></td>
										<td></td>
									</tr>
								</tbody>
							</table>
						</div>
					
						<div class="clear"></div>
				</fieldset>
				
				<fieldset class="fset">
					<legend>Parts List</legend>
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th valign="top" align="center" width="21%">Code</th>
								<th valign="top" align="center" width="40%">Description</th>
								<th valign="top" align="center" width="12%">Qty</th>
								<th valign="top" align="center" width="13%">Qty had drawn</th>
								<th valign="top" align="center" width="10%">Withdraw</th>
								
							</tr>
						</thead>
						<tbody>
						<%
											Iterator ite = SaleServicePartDetail.selectList(paramsList).iterator();
											while(ite.hasNext()) {
												SaleServicePartDetail detail = (SaleServicePartDetail) ite.next();
												Map map = detail.getUImap();
												PartMaster part = (PartMaster)map.get(PartMaster.tableName);
						%>
							<tr>
								<td><%=detail.getPn() %></td>
								<td><%=part.getDescription() %></td>
								<td align="right"><%=detail.getQty()%></td>
								<td align="right">
									<%=detail.getCutoff_qty()%>
								</td>
								<td>
									<!--  เช็คเงื่อนไขอีกที -->
									<%if(!detail.getCutoff_qty().equalsIgnoreCase(detail.getQty())){ %>
										<a class="btn_upload thickbox" title="Withdraw Parts PN: <%=detail.getPn() %> - <%=detail.getUIDescription() %>" lang="draw_parts_cut.jsp?id=<%= entity.getId() %>&pn=<%=detail.getPn()%>&number=<%=detail.getNumber()%>&width=400&height=150"></a>
									<%} %>
										
								</td>
							</tr>
						<%
							}
						%>
						</tbody>
					</table>
				</fieldset>
				</form>
				<div class="clear"></div>
					
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>