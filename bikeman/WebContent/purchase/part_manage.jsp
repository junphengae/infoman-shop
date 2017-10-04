<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.parts.PartCategories"%>
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
<script src="../js/number.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.position.js"></script>
<script src="../js/ui/jquery.ui.autocomplete.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Parts</title>
<%
List paramList = new ArrayList();

String keyword = WebUtils.getReqString(request, "keyword");
String cate = WebUtils.getReqString(request, "cate");

paramList.add(new String[]{"keyword",keyword});
paramList.add(new String[]{"cate",cate});

session.setAttribute("PART_SEARCH", paramList);

String page_ = WebUtils.getReqString(request, "page");
PageControl ctrl = new PageControl();
ctrl.setLine_per_page(20);

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("PART_PAGE", page_);
}

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("PART_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("PART_PAGE")));
}

List list = PartMaster.selectWithCTRL(ctrl, paramList);
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Parts Search</div>
<!-- 				<div class="right">
					<button class="btn_box btn_add" onclick="window.location='part_add.jsp';">Create New Parts</button>
				</div> -->
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="part_manage.jsp" id="search" method="get">
						Keyword: 
						<input type="text" class="s150 txt_box" name="keyword" value="<%=keyword%>" autocomplete="off">  
						<%-- Category:
						<bmp:ComboBox name="cate" styleClass="txt_box s200" listData="<%=PartCategories.ddl_th(group_id) %>" value="<%=cate%>">
							<bmp:option value="" text="--- All ---"></bmp:option>
						</bmp:ComboBox>  --%>
						<input type="submit" name="submit" value="Search" class="btn_box btn_confirm">
						<input type="button" name="reset" value="Reset" class="btn_box s50 m_left5" onclick="clear_form('#search');">
						<input type="hidden" name="action" value="search">
						
					</form>
				</div>
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"part_manage.jsp",paramList)%></div>
				<div class="clear"></div>
				
				<div class="dot_line"></div>
				
				<table class="bg-image s_auto">
					<thead>
						<tr>
							<th valign="top" align="left" width="15%">P/N</th>
							<th valign="top" align="left" width="27%">Description</th>
							<th valign="top" align="left" width="25%">Fit To</th>
							<th valign="top" align="left" width="8%">Location</th>
							<th valign="top" align="right" width="7%">Qty</th>
							<th valign="top" align="center" width="5%">MOR</th>
							<th align="center" width="13%"></th>
						</tr>
					</thead>
					<tbody>
					<%
						boolean has = true;
						Iterator ite = list.iterator();
						while(ite.hasNext()) {
							PartMaster entity = (PartMaster) ite.next();
							has = false;
					%>
						<tr>
							<td><%=entity.getPn() %> &nbsp;&nbsp;&nbsp;<%if(entity.getSs_no().length() > 0){%><img src="../images/icon/flag.png" title="SS Flag"><%}%></td>
							<td><%=entity.getDescription() %></td>
							<td><%=entity.getFit_to() %></td>
							<td align="center"><%=entity.getLocation() %></td>
							<td align="right"><%=entity.getQty()%></td>
							<td align="center">
								<!--  ใส่ค่า MOR -->
							</td>
							<td align="left">
								<a class="btn_view" href="part_info.jsp?pn=<%=entity.getPn()%>" title="View Parts Information"></a>
								<!-- 
								<a class="btn_download" href="part_add_stock_detail.jsp?pn=<%//=entity.getPn()%>" title="Add Stock"></a>
								 -->
								<a class="btn_import thickbox" title="Purchase Parts" lang="../part/pr_parts.jsp?pn=<%=entity.getPn()%>&width=850&height=500"></a>
								<!-- 
								<%if(!entity.getQty().equalsIgnoreCase("0")){%>
								
								<a class="btn_export thickbox" title="Borrow Parts" lang="borrow_part_create.jsp?pn=<%=entity.getPn()%>"></a>
								
								<%}%>
								 -->
							</td>
						</tr>
					<%
						}
						if(has){
					%>
						<tr><td colspan="7" align="center">Parts Master cannot be found!</td></tr>
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