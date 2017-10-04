
<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="java.util.Map"%>
<%@page import="com.bitmap.bean.dc.SaleServicePartDetail"%>
<%@page import="com.bitmap.bean.dc.SaleOrderService"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.hr.Department"%>
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
										<td width="70%">: <%=WebUtils.getDateTimeValue(entity.getCreate_date())%></td>
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
					<%
						if(!(entity.getStatus().equalsIgnoreCase(SaleOrderService.STATUS_CANCEL) || entity.getStatus().equalsIgnoreCase(SaleOrderService.STATUS_CLOSED) || entity.getStatus().equalsIgnoreCase(SaleOrderService.STATUS_REQUEST))){
					%>
					<div class="right">
<%-- 						<button class="btn_box btn_add thickbox" title="Select parts" lang="draw_parts_select.jsp?id=<%=entity.getId()%>&width=420&height=230">Select Parts</button> --%>
					</div>
					<div class="clear"></div>
					<%
						}
					%>
					<table class="bg-image s_auto">
						<thead>
							<tr>
							
								<th valign="top" align="center" width="20%">Code</th>
								<th valign="top" align="center" width="30%">Description</th>
								<th valign="top" align="center" width="10%">Units</th>
								<th valign="top" align="center" width="10%">Qty</th>
								<th valign="top" align="center" width="10%">Qty had drawn</th>
								<th valign="top" align="center" width="15%">Withdraw</th>
							</tr>
						</thead>
						<tbody>
						<%
							Iterator ite = SaleServicePartDetail.selectList(paramsList).iterator();
							while(ite.hasNext()) {
								SaleServicePartDetail detail = (SaleServicePartDetail) ite.next();
								Map map = detail.getUImap();
								PartMaster part = (PartMaster)map.get(PartMaster.tableName);
								

								String UnitDesc = UnitType.selectName(part.getDes_unit());
						%>
							<tr>
								<td align="left"><%=detail.getPn() %></td>
								<td align="left"><%=part.getDescription() %></td>
								<td align="left"><%=UnitDesc%></td>
								<td align="right"><%=Money.moneyInteger(detail.getQty())%></td>
								<td align="right"><%=detail.getCutoff_qty().equalsIgnoreCase("")?"0"+" ":Money.moneyInteger(detail.getCutoff_qty())%></td>
								<td align="center">
									<%if(detail.getCutoff_qty().equalsIgnoreCase(detail.getQty())){ %>
									Completed
									<%} else { %>
									
											<% if(part.getSn_flag().equalsIgnoreCase("1")){ %>
												<a class="btn_upload thickbox" title="Withdraw Parts PN: <%=detail.getPn() %> - <%=part.getDescription() %>" lang="draw_parts_cut.jsp?id=<%= detail.getId() %>&pn=<%=detail.getPn()%>&number=<%=detail.getNumber()%>&width=400&height=150"></a>
											<% }else{%>		
												<a class="btn_upload thickbox" title="Withdraw Parts PN: <%=detail.getPn() %> - <%=part.getDescription() %>" lang="draw_parts_cut_non_sn.jsp?id=<%= detail.getId() %>&pn=<%=detail.getPn()%>&number=<%=detail.getNumber()%>&width=400&height=150"></a>
											<% } %>
									<%} %>
									<%if((!detail.getCutoff_qty().equalsIgnoreCase("0")) && (!detail.getCutoff_qty().equalsIgnoreCase(""))){   System.out.println("open"); %>
											
											<% if(part.getSn_flag().equalsIgnoreCase("1")){ %>
													<a class="btn_reload thickbox" title="Return Parts PN: <%=detail.getPn() %> - <%=part.getDescription() %>" lang="draw_parts_return.jsp?id=<%= detail.getId() %>&pn=<%=detail.getPn()%>&number=<%=detail.getNumber()%>&width=400&height=150"></a>
											<% }else{%>	
											
													<a class="btn_reload thickbox" title="Return Parts PN: <%=detail.getPn() %> - <%=part.getDescription() %>" lang="draw_parts_return_non_sn.jsp?id=<%= detail.getId() %>&pn=<%=detail.getPn()%>&number=<%=detail.getNumber()%>&width=400&height=150"></a>
											<% } %>
									<%} %>
								</td>
							</tr>
						<%
							}
						%>
						</tbody>
					</table>
				</fieldset>
				<div class="clear"></div>
					
				<script type="text/javascript">
				function deletePart(id,number,desc,pn){
					if (confirm('Remove Part PN: ' + pn + ' [' + desc + ']?')) {
						ajax_load();
						$.post('../PartSaleManage',{'id':id,'number':number,'action':'sale_order_part_delete'},function(resData){
							ajax_remove();
							if (resData.status == 'success') {
								window.location.reload();
							} else {
								alert(resData.message);
							}
						},'json');
					}
				}
				</script>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>