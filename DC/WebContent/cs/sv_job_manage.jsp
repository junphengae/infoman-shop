<%@page import="java.util.Map"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.ServiceSale"%>
<%@page import="com.bitmap.bean.sale.Brands"%>
<%@page import="com.bitmap.bean.sale.Models"%>
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
<title>Service Job</title>
<%
List paramList = new ArrayList();

String status = WebUtils.getReqString(request, "status");
//String service_type = WebUtils.getReqString(request, "service_type");
String search = WebUtils.getReqString(request, "search");


paramList.add(new String[]{"status",status});
/* paramList.add(new String[]{"service_type",service_type}); */
paramList.add(new String[]{"search",search});

session.setAttribute("CS_ORDER_SEARCH", paramList);

//if(service_type.length() == 0){

/* ปิดทิ้งไปเนื่องจาก มันเปนการ fix  select dropdown
if(service_type.length() > 0){
	service_type = ServiceSale.SERVICE_MA;
}
*/
String page_ = WebUtils.getReqString(request, "page");
PageControl ctrl = new PageControl();
ctrl.setLine_per_page(20);

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("CS_ORDER_PAGE", page_);
}

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("CS_ORDER_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("CS_ORDER_PAGE")));
}

List list = ServiceSale.selectWithCTRL(ctrl, paramList);
%>


<script type="text/javascript">
		function OpenJob(){
			window.location='sv_job_create.jsp';
			<%-- if(confirm('Open Job Confirm. ')) {
				ajax_load();
				$.post('../PartSaleManage',{'service_type':<%=ServiceSale.SERVICE_MA%>,'create_by':'<%=securProfile.getPersonal().getPer_id()%>','action':'create_sale_order'},function(json){
					ajax_remove();
					if (json.status == 'success') {
						//window.location='sv_job_create.jsp?id=' + json.id;
						window.location='sv_job_info.jsp?id=' + json.id;
					} else {
						alert(json.message);
					}
				},'json');
			} --%> 
		}
</script>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Service Job</div>
				<div class="right">
					<button class="btn_box btn_add" onclick="OpenJob();" >Open Job</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="sv_job_manage.jsp" id="search" method="get">
						Search: <input type="text" name="search" class="txt_box" value="<%=search%>"> 
						&nbsp;&nbsp;
						<%-- Type: 
						<bmp:ComboBox name="service_type" styleClass="txt_box s150" listData="<%=ServiceSale.ddl_service_en()%>" value="<%=service_type%>">
							<bmp:option value="" text="--- SHOW All ---"></bmp:option>
						</bmp:ComboBox> 
						&nbsp;&nbsp; --%>
						Status: 
						<bmp:ComboBox name="status" styleClass="txt_box s150" listData="<%=ServiceSale.ddl_en() %>" value="<%=status %>">
							<bmp:option value="" text="--- SHOW All ---"></bmp:option>
						</bmp:ComboBox> 
						&nbsp;&nbsp;
						<input type="submit" name="submit" value="Search" class="btn_box btn_confirm"> 
						<input type="button" name="reset" value="Reset" class="btn_box s50 m_left5" onclick="clear_form('#search');">
						<input type="hidden" name="action" value="search">
						
					</form>
				</div>
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"sv_job_manage.jsp",paramList)%></div>
				<div class="clear"></div>
				
				<div class="dot_line"></div>
				
				<table class="columntop bg-image s_auto breakword ">
					<thead>
						<tr >
							<th valign="top" align="center" width="7%">ID</th>
							<th valign="top" align="center" width="17%">Customer</th>
							<th valign="top" align="center" width="15%">Brand</th>
							<!-- <th valign="top" align="center" width="13%">Model</th> -->
							<th valign="top" align="center" width="12%">Plate</th>
							<th valign="top" align="center" width="10%">Date</th>
							<th valign="top" align="center" width="10%">Close Job</th>
							<th valign="top" align="center" width="10%">Total Time</th>
							<th valign="top" align="center" width="11%">STATUS</th>
							<th  width="8%"></th>
						</tr>
					</thead>
					<tbody>
					<%
						Iterator ite = list.iterator();
						while(ite.hasNext()) {
							ServiceSale entity = (ServiceSale) ite.next();
							Map map = entity.getUImap();
					%>
						<tr>
							<td align="center"><%=entity.getId()%></td>
							<td align="left"><%=entity.getCus_name()%></td>
							<td align="center" >
								<%// if(entity.getUIVehicle().getUIMaster().getBrand().equalsIgnoreCase("")){ }else{ %>
								<!-- <img src="../../images/motoshop/car_logo/40x27/<%//=entity.getUIVehicle().getUIMaster().getBrand()%>.gif"> -->	
								<% //} %>
								<% if(Brands.getUIName(entity.getBrand_id()) !=  null){ %>
										<%=Brands.getUIName(entity.getBrand_id())%>
								<% } %>
									
							</td>
							<%-- <td align="center">
							
								<% if(Models.getUIName(entity.getModel_id()) !=  null){ %>
										<%=Models.getUIName(entity.getModel_id())%>
								<% } %>
									
								<%//=(entity.getUIVehicle().getUIMaster().getUIModel() == null?"":entity.getUIVehicle().getUIMaster().getUIModel())%> 
								<%//=(entity.getUIVehicle().getUIMaster().getNameplate().equalsIgnoreCase(""))?" ":":"%> 
								<%//=entity.getUIVehicle().getUIMaster().getNameplate()%> 
							</td> --%>
							<td align="center"><%=entity.getV_plate()%> </td>
							<td align="center"><%=WebUtils.getDateValue(entity.getCreate_date()) %></td>
							<td align="center"><%=WebUtils.getDateValue(entity.getJob_close_date()) %></td>
							<td align="right">
								<%//=map.get("complete_date")%>
								<%
									if(map.get("complete_minute") != null && !map.get("complete_minute").equals("")){
										out.print(map.get("complete_minute")+" นาที");
									}
								
								%>
							
							</td>
							<%--<td align="right"><%=Money.money(entity.getTotal_amount())%></td> --%>
							<td align="center"><%=ServiceSale.status(entity.getStatus())%></td>
							<td align="left" >
								<%
								if(entity.getService_type().equals(ServiceSale.SERVICE_MA)){
									if(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_OPENING)){ %>
										<a class="btn_update" href="sv_job_info.jsp?id=<%=entity.getId()%>" title="Edit Job Order"></a>
									<% } else if(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_CLOSED)){ %>
										<a class="btn_view" href="sv_job_description_closed.jsp?id=<%=entity.getId()%>" title="View Job Order"></a>
									<% } else { %>
										<a class="btn_view" href="sv_job_info.jsp?id=<%=entity.getId()%>" title="View Job Order"></a>
									<% }
								} else { %>
									<a class="btn_view" href="sv_job_description_closed.jsp?id=<%=entity.getId()%>" title="View Job Order"></a>
								<%}%>
								<%if(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_MA_REQUEST)){ %>
									<a class="btn_viewlist" href="sv_job_description.jsp?id=<%=entity.getId()%>" title="View Service"></a>
								<%} %>
							
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