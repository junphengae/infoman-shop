<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.parts.PartBorrow"%>
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
<title>Borrow Parts</title>
<%
List paramList = new ArrayList();

String pn = WebUtils.getReqString(request, "pn");

paramList.add(new String[]{"pn",pn});

session.setAttribute("BORROW_SEARCH", paramList);

String page_ = WebUtils.getReqString(request, "page");
PageControl ctrl = new PageControl();
ctrl.setLine_per_page(20);

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("BORROW_PAGE", page_);
}

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("BORROW_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("BORROW_PAGE")));
}

List list = PartBorrow.selectWithCTRL(ctrl, paramList);
%>
</head>
<body onload="$('#pn').focus();">

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Borrow Parts</div>
				<div class="right">
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="borrow_parts.jsp" id="search" method="get">
						PN: <input type="text" name="pn" id="pn" class="txt_box" value="<%=pn%>" autocomplete="off"> 
						<input type="submit" name="submit" value="Search" class="btn_box btn_confirm">
						<input type="button" name="reset" value="Reset" class="btn_box s50 m_left5" onclick="clear_form('#search');$('#pn').focus();">
						<input type="hidden" name="action" value="search">
						
					</form>
				</div>
				<div class="clear"></div>
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"borrow_parts.jsp",paramList)%></div>
				<div class="clear"></div>
				
				<div class="dot_line"></div>
				
				<table class="bg-image s_auto">
					<thead>
						<tr>
							<th valign="top" align="center" width="15%">PN</th>
							<th valign="top" align="center" width="23%">Description</th>
							<th valign="top" align="center" width="15%">Borrow By</th>
							<th valign="top" align="center" width="20%">Borrow Date</th>
							<th valign="top" align="center" width="10%">Units</th>
							<th valign="top" align="center" width="8%">Borrow Qty</th>
							<th valign="top" align="center" width="8%">Return Qty</th>
							<th valign="top" align="center" width="10%"></th>
						</tr>
					</thead>
					<tbody>
					<%
						boolean has = true;
						Iterator ite = list.iterator();
						while(ite.hasNext()) {
							PartBorrow borrow = (PartBorrow) ite.next();
							PartMaster entity = borrow.getUIMaster();
							has = false;
							String UnitDesc = UnitType.selectName(entity.getDes_unit());
					%>
						<tr>
							<td align="left"><%=entity.getPn() %></td>
							<td align="left"><%=entity.getDescription() %></td>
							<td align="left"><%=Personal.selectOnlyPerson(borrow.getBorrow_by()).getName()%></td>
							<td align="center"><%=WebUtils.getDateTimeValue(borrow.getCreate_date())%></td>
							<td align="left"><%=UnitDesc%></td>
							<td align="right"><%=Money.moneyInteger(borrow.getQty())%></td>
							<td align="right"><%=Money.moneyInteger(borrow.getReturn_qty())%></td>
							<td align="center">
								<a class="btn_reload thickbox" title="Return" lang="borrow_return_part<%=(entity.getSn_flag().equalsIgnoreCase("1"))?"":"_non_sn"%>.jsp?pn=<%=entity.getPn().replaceAll(" ", "%20")%>&run=<%=borrow.getRun()%>"></a> 
								<a class="btn_bin thickbox" title="Scrap" lang="borrow_scrap_part<%=(entity.getSn_flag().equalsIgnoreCase("1"))?"":"_non_sn"%>.jsp?pn=<%=entity.getPn().replaceAll(" ", "%20")%>&run=<%=borrow.getRun()%>"></a>
							</td>
						</tr>
					<%
						}
						if(has){
					%>
						<tr><td colspan="7" align="center">Not found</td></tr>
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