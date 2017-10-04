<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.inventory.InventoryWeightType"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.inventory.WeightType"%> 
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.inventory.InventoryPacking"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
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
<title>ข้อมูลบรรจุภัณฑ์</title>

<%
List paramList = new ArrayList();
String mat_code = WebUtils.getReqString(request, "mat_code");
String id = WebUtils.getReqString(request, "id");

PartMaster inv = PartMaster.select(mat_code);



paramList.add(new String[]{"mat_code",mat_code});
paramList.add(new String[]{"id",id});

session.setAttribute("TYPE_SEARCH", paramList);

String page_ = WebUtils.getReqString(request, "page");
PageControl ctrl = new PageControl();
ctrl.setLine_per_page(20);

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("TYPE_PAGE", page_);
}

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("TYPE_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("TYPE_PAGE")));
}

List list = InventoryPacking.selectWithCTRL(ctrl, paramList);

%>

</head>

<body>
<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">ข้อมูลบรรจุภัณฑ์ (<%=mat_code + " : " + inv.getDescription() %>)</div>
				<div class="right">
					<button class="btn_box btn_add" onclick="window.location='packing_add.jsp?mat_code=<%=mat_code%>&des_unit=<%=inv.getDes_unit()%>';">Create New Packing</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="inventory_list_branch.jsp" id="search" method="get">
					</form>
				</div>
				
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"packing_view.jsp",paramList)%></div>
				<div class="clear"></div>
				<div class="dot_line"></div>
				
				<table class="bg-image s_auto">
					<thead>
						<tr>
							<th valign="top" align="center" width="70%">บรรจุภัณฑ์</th>
							<th valign="top" align="center" width="20%">จำนวน / <%=UnitType.selectName(inv.getDes_unit()) %> </th>
							<th valign="top" align="center" width="10%"></th>
						</tr>
					</thead>
					
					<tbody>
					<%
						Iterator ite = list.iterator();
						while (ite.hasNext()){
							InventoryPacking entity = (InventoryPacking) ite.next();
					%>
						<tr>
							<td align="left"><%=entity.getDescription() %></td>
							<td align="center"><%-- <%=Money.money(entity.getUnit())%> --%><%=entity.getUnit()%></a></td>
							<td align="center">
								<a class="btn_update thickbox" lang="packing_edit.jsp?mat_code=<%=entity.getMat_code()%>&run_id=<%=entity.getRun_id()%>&des_unit=<%=inv.getDes_unit()%>&width=500&height=220" title="Update Packing "></a>
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