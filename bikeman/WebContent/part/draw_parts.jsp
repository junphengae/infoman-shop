<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.ServiceSale"%>
<%@page import="com.bitmap.bean.parts.ServicePartDetail"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.parts.PartGroups"%>
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
<script src="../js/validator.js"></script>
<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/barcode.css" rel="stylesheet" type="text/css" media="all"> 

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Request Parts Order</title>
<%
	List paramList = new ArrayList();
	
	String status = WebUtils.getReqString(request, "status");
	String search = WebUtils.getReqString(request, "search");
	
	paramList.add(new String[]{"status",status});
	paramList.add(new String[]{"search",search});
	
	session.setAttribute("DRAW_SEARCH", paramList);
	
	String page_ = WebUtils.getReqString(request, "page");
	PageControl ctrl = new PageControl();
	ctrl.setLine_per_page(20);
	
	if(page_.length() > 0){
		ctrl.setPage_num(Integer.parseInt(page_));
		session.setAttribute("DRAW_PAGE", page_);
	}
	
	if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("DRAW_PAGE") != null){
		ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("DRAW_PAGE")));
	}
	
// 	List list = ServiceSale.selectWithCTRL(ctrl, paramList);
	
	List list2 = ServicePartDetail.selectallWithCTRL(ctrl, paramList);
	%>
	
	<script type="text/javascript">
		function validCurrencyOnKeyUp(thisObj, thisEvent) {
			  var temp = thisObj.value;
			  temp = currencyToNumber(temp); // convert to number
			  thisObj.value = formatCurrency(temp);// convert to currency forma
		}
		
		function validNumberOnKeyUp(thisObj, thisEvent) {
			  var temp = thisObj.value;
			  temp = currencyToNumber(temp); // convert to number
			  thisObj.value = formatIntegerWithComma(temp);// convert to currency format
		}
</script>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left"> Draw Parts</div>
				<div class="right">
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="draw_parts.jsp" id="search" method="get">
						Search: <input type="text" name="search" class="txt_box" value="<%=search%>"> 
						Status:
						<bmp:ComboBox name="status" styleClass="txt_box s200" listData="<%=ServiceSale.ddl_draw() %>" value="<%=status%>">
							<bmp:option value="" text="--- SHOW All ---"></bmp:option>
						</bmp:ComboBox> 
						<input type="submit" name="submit" value="Search" class="btn_box btn_confirm">
						<input type="button" name="reset" value="Reset" class="btn_box s50 m_left5" onclick="clear_form('#search');">
						<input type="hidden" name="action" value="search">
						
					</form>
				</div>
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"draw_parts.jsp",paramList)%></div>
				<div class="clear"></div>
				
				<div class="dot_line"></div>
				<table class="columntop bg-image breakword "  width="100%">
					<thead>
						<tr>
							<th valign="top" align="center" width="7%">Job ID</th>
							<th valign="top" align="center" width="16%">Customer</th>
							<th valign="top" align="center" width="13%">Code</th>
							<th valign="top" align="center" width="20%">Description</th>
							<th valign="top" align="center" width="14%">Location</th>
							<th valign="top" align="center" width="12%">Date/Time</th>
							<th valign="top" align="center" width="10%">STATUS</th>
							<th valign="top" align="left" width="7%"></th>
						</tr>
					</thead>
					<tbody>
						<td colspan="10" style="padding: 0px 0px 0px 0px;" width="100%">
							 <div class="scroll">
							  <table class="bg-image breakword"  style="border-collapse: collapse;" width="100%">
					
									<%
										Iterator ite2 = list2.iterator();
													while(ite2.hasNext()) {
														ServicePartDetail entity = (ServicePartDetail) ite2.next();
									%>
				
										<tr>
											<td align="center" width="7%"><%=entity.getId()%></td>
											<td align="left" width="17%"><%=entity.getUIforewordname()+" "+ entity.getUICus_name()+" "+entity.getUIcus_surname()%></td>
											<td align="left" width="13%"><%=entity.getPn()%></td>
											<td align="left" width="20%"><%=entity.getUIDescription()%></td>
											<td align="left" width="15%"><%=entity.getUILocation() %></td>
											<td align="center" width="12%"><%=WebUtils.getDateValue(entity.getCreate_date())%></td>
											<td align="center" width="10%"><%=(entity.getQty().equalsIgnoreCase(entity.getCutoff_qty())?"Closed":"MA Request")%></td>
											<td align="center" width="5%">
												<%
													if(entity.getQty().equalsIgnoreCase(entity.getCutoff_qty())){
												%>
												<a class="btn_view" href="draw_parts_info.jsp?id=<%=entity.getId()%>" title="View Sale Order"></a>
												<%} else {%>
												<a class="btn_update" href="draw_parts_update.jsp?id=<%=entity.getId()%>" title="Update Sale Order"></a>
												<%}%>
											</td>
										</tr>
											<%
											}
											%>
							 		</table>
								</div>
							</td>
						</tr>
							
					</tbody>
				</table>
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>