<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.parts.PartGroups"%>
<%@page import="com.bitmap.bean.parts.PartCategories"%>
<%@page import="com.bitmap.bean.parts.PartCategoriesSub"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
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
<%@page import="com.bitmap.utils.Money"%>
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

<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<!-- <script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="../js/jquery.metadata.js"></script>
<script type="text/javascript" src="../js/jquery.validate.js"></script> -->

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Parts</title>
<%
List paramList = new ArrayList();

String keyword = WebUtils.getReqString(request, "keyword");
String id = WebUtils.getReqString(request, "id");

paramList.add(new String[]{"keyword",keyword});
paramList.add(new String[]{"id",id});

session.setAttribute("SALE_PART_SEARCH", paramList);

String page_ = WebUtils.getReqString(request, "page");
PageControl ctrl = new PageControl();
ctrl.setLine_per_page(20);

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("SALE_PART_PAGE", page_);
}

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("SALE_PART_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("SALE_PART_PAGE")));
}

List list = PartMaster.selectWithCTRL(ctrl, paramList);

String sumPO  = null;
%>
</head>
<body>

<div class="wrap_auto">
								
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Parts Search</div>
				<div class="right">
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body_bank">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="sale_part_search.jsp" id="search" method="get">
						Keyword: 
						<input type="text" class="s150 txt_box" name="keyword" value="<%=keyword%>" autocomplete="off">  
						<input type="hidden" name="id" value="<%=id%>">

						<input type="submit" name="submit" value="Search" class="btn_box btn_confirm">
						<input type="button" name="reset" value="Reset" class="btn_box s50 m_left5" onclick="clear_form('#search');">						
					</form>
				</div>
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"sale_part_search.jsp",paramList)%></div>
				<div class="clear"></div>
				
				<div class="dot_line"></div>
				
				<table class="bg-image s_auto columntop breakword">
					<thead>
						<tr>
							<th valign="top" align="left" width="12%">P/N</th>
							<th valign="top" align="left" width="30%">Description</th>
							<th valign="top" align="left" width="29%">Fit To</th>
							<th valign="top" align="right" width="6%">Qty</th>
							<th valign="top" align="left" width="10%">PO Qty</th>
							<th valign="top" align="center" width="3%">SS</th>
							<th align="center" width="10%"></th>
						</tr>
					</thead>
					<tbody>
					<%
						boolean has = true;
						Iterator ite = list.iterator();
						while(ite.hasNext()) {
							PartMaster entity = (PartMaster) ite.next();
							has = false;
							sumPO = "0";
							if(PurchaseRequest.sumPO(entity.getPn()).length()>0){
								sumPO = PurchaseRequest.sumPO(entity.getPn());
							}
					%>
						<tr>
							<td><%=entity.getPn() %></td>
							<td><%=entity.getDescription() %></td>
							<td><%=entity.getFit_to() %></td>
							<td align="right">
								<%=entity.getQty()%>
							</td>
							<td align="right">
								<%=Money.moneyInteger(sumPO)%>
							</td>
							<td align="center"><%if(entity.getSs_no().length() > 0){%><img src="../images/icon/flag.png" title="SS Flag"><%}%></td>
							<td align="left">
								<a class="btn_view" title="View" href="part_info_view.jsp?pn=<%=entity.getPn()%>" target="_blank"></a>
								<%if(entity.getQty().length() > 0 && !entity.getQty().equals("0")){ %>
								<a class="btn_accept thickbox" title="Select Parts" href="sale_part_select.jsp?pn=<%=entity.getPn()%>&id=<%=id%>&width=580&height=300"></a>
								<%--
									<a class="btn_accept thickbox" title="Select Parts" data_name="<%=entity.getDescription()%>" data_pn="<%=entity.getPn()%>" data_price="<%=entity.getPrice()%>" data_qty="<%=entity.getQty()%>"></a>
								 --%>
								
								<%}%>
								
							</td>
						</tr>
					<%
						}
						if(has){
					%>
						<tr><td colspan="7" align="center">Parts Master cannot be found</td></tr>
					<%
						}
					%>
					</tbody>
					<tfoot>
					<tr>
						<td colspan="8" align="center" height="35px" valign="bottom">
							<input type="button" id="close_form" class="btn_box btn_warn" value="Close Display" >	
						</td>
					</tr>
					</tfoot>
				</table>
				<script type="text/javascript">
				/*
				$(function(){
					$(".btn_accept").click(function(){ 
				        window.opener.$('#pn').val($(this).attr('data_pn'));
				        window.opener.$('#description').text($(this).attr('data_name'));
				        window.opener.$('#price').val($(this).attr('data_price'));
				        window.opener.$('#stock_qty').text($(this).attr('data_qty'));
				        window.opener.$('#qty').focus();
				       	window.close(); 
					}); 
				});
				*/
				$(function(){
					$("#close_form").click(function(){ 
					//	window.opener.location.reload(true);
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