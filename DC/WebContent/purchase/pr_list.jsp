<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.parts.Vendor"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="com.bitmap.webutils.customtag.ComboBoxTag"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css">
<link href="../css/unit.css" rel="stylesheet" type="text/css">
<link href="../css/table.css" rel="stylesheet" type="text/css">
<link href="../css/loading.css" rel="stylesheet" type="text/css">

<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/thickbox.js" type="text/javascript"></script>
<script src="../js/loading.js" type="text/javascript"></script>
<script src="../js/clear_form.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Purchase Request</title>
<%

String year = WebUtils.getReqString(request, "year");
String month = WebUtils.getReqString(request, "month");
String vendor_id = WebUtils.getReqString(request, "vendor_id");
String status = WebUtils.getReqString(request, "status");
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();
if (year.length() == 0 || year.equalsIgnoreCase("")) {
	//paramList.add(new String[]{"year",""});
} else {
	paramList.add(new String[]{"year",year});
}
paramList.add(new String[]{"vendor_id",vendor_id});
paramList.add(new String[]{"status",status});
paramList.add(new String[]{"month",month});

session.setAttribute("PO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

Iterator ite = PurchaseRequest.selectWithCTRL(ctrl, paramList).iterator();
if( month.length() > 0  ){
	if( year.length() > 0 ){
		ite = PurchaseRequest.selectWithCTRL(ctrl, paramList).iterator();
	}else{
%>
		 <script type="text/javascript">
		 	alert("กรุณาเลือกปีที่ต้องการค้นหา !");
		 </script>
<%
	}
}
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Purchase Request Lists</div>
				<div class="right">
					<button class="btn_box" onclick="javascript: history.back();">Back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<div class="left">
					<form style="margin: 0; padding: 0;" action="pr_list.jsp" id="search" method="get">
							Status: 
							<bmp:ComboBox name="status" styleClass="txt_box s150" listData="<%=PurchaseRequest.statusDropdown_pr()%>" value="<%=status%>">
								<bmp:option value="" text="--- all ---"></bmp:option>
							</bmp:ComboBox>
							&nbsp;&nbsp;
							
							Month/Year: 
							<bmp:ComboBox name="month" styleClass="txt_box s100" style="<%=ComboBoxTag.EngMonthList%>" value="<%=month%>">
								<bmp:option value="" text="--- all ---"></bmp:option>
							</bmp:ComboBox>
							<bmp:ComboBox name="year" styleClass="txt_box s100" style="<%=ComboBoxTag.EngYearList%>" value="<%=year%>"> <%//=(year.length()>0)?year:null%>
							<bmp:option value="" text="--- all ---"></bmp:option>
							</bmp:ComboBox>
							
							<button  class="btn_box btn_confirm" type="submit">Search</button>
							<input type="button" name="reset" value="Reset" class="btn_box s50 m_left5" onclick="clear_form('#search');">
						</form>
				</div>
				<div class="clear"></div>
					<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"pr_list.jsp",paramList)%></div>
					
				<div class="clear"></div>
				
				<div class="dot_line"></div>
					
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th valign="top" align="center" width="10%">PO/NO.</th>
								<th valign="top" align="center" width="10%">Create Date</th>
								<th valign="top" align="center" width="20%">Description</th>
								<th valign="top" align="center" width="15%">Vender</th>
							    <th valign="top" align="center" width="5%">Units</th>
								<th valign="top" align="center" width="10%">QTY</th>
								<th valign="top" align="center" width="10%">Price(฿)</th>
								<th valign="top" align="center" width="10%">Status</th>
								<th valign="top" align="center" width="10%"></th>
							</tr>
						</thead>
						<tbody>
						<%
							boolean has = true;
							while(ite.hasNext()) {
								PurchaseRequest entity = (PurchaseRequest) ite.next();
								PartMaster master = entity.getUIPartMaster();
								String UnitDesc = UnitType.selectName(master.getDes_unit());
								has = false;
						%>
							<tr valign="top">
							<td align="center" valign="top"><%=entity.getPo()%></td>
								<td align="center" valign="top"><%=WebUtils.getDateValue(entity.getCreate_date())%></td>
								<td align="left" valign="top">
								<%=master.getDescription()%>
								</td>
								<td align="left" valign="top">
								<div class="thickbox pointer" lang="vendor_info.jsp?vendor_id=<%=entity.getVendor_id()%>&width=500&height=280&"><%=Vendor.select(entity.getVendor_id()).getVendor_name()%>
								</div></td>
								<td align="left" valign="top"><%=UnitDesc%></td>
								<td align="right" valign="top">
									<%=Money.moneyInteger(entity.getOrder_qty())%>
									<input type="hidden" name="order_qty" value="<%=entity.getOrder_qty()%>">
								</td>
								<td align="right" valign="top"><%=Money.money(entity.getOrder_price())%></td>
								<td align="center" valign="top">
								<%if(entity.getStatus().equalsIgnoreCase("10")){
								%>
									รอสร้าง PO	
								<%}else{ %>
								
								<%=PurchaseRequest.status(entity.getStatus())%>
								<%} %>
								</td>
								<td  valign="top">
									
									<%
									//if (entity.getStatus().equalsIgnoreCase(PurchaseRequest.STATUS_ORDER) || entity.getStatus().equalsIgnoreCase(PurchaseRequest.STATUS_MD_REJECT_EDIT)){
									if (entity.getStatus().equalsIgnoreCase(PurchaseRequest.STATUS_ORDER)){
									%>
									<a class="btn_view thickbox"  title="รายละเอียดการขอจัดซื้อ :  <%=master.getDescription()%>" href="pr_info.jsp?pn=<%=entity.getMat_code()%>&id=<%=entity.getId()%>&width=750&height=350"></a>
									<a class="btn_update thickbox" title="Update PR / แก้ไขการขอจัดซื้อ" href="pr_parts_update.jsp?pn=<%=entity.getMat_code()%>&id=<%=entity.getId()%>&width=850&height=450"></a>
									<a class="btn_bin thickbox" title="Cancel PR / ยกเลิกการขอจัดซื้อ" href="pr_parts_cancel.jsp?pn=<%=entity.getMat_code()%>&id=<%=entity.getId()%>&order_qty=<%=entity.getOrder_qty()%>&width=450&height=200"></a>
									<%}else{ %>
									<%-- <%} else if(entity.getStatus().equalsIgnoreCase(PurchaseRequest.STATUS_MD_APPROVED)){%>
									<a class="btn_bin thickbox" title="Cancel PR / ยกเลิกการขอจัดซื้อ" href="pr_parts_cancel.jsp?pn=<%=entity.getMat_code()%>&id=<%=entity.getId()%>&width=450&height=200"></a>
									<a class="btn_view thickbox"  title="รายละเอียดการขอจัดซื้อ :  <%=master.getDescription()%>" href="pr_info.jsp?pn=<%=entity.getMat_code()%>&id=<%=entity.getId()%>&width=750&height=350"></a>
									<%} else if(entity.getStatus().equalsIgnoreCase(PurchaseRequest.STATUS_CANCEL)){%> --%>
										<a class="btn_view thickbox"  title="รายละเอียดการขอจัดซื้อ :  <%=master.getDescription()%>" href="pr_info.jsp?pn=<%=entity.getMat_code()%>&id=<%=entity.getId()%>&width=750&height=350"></a>
									<%}%>
								</td>
							</tr>
						<%
							}
							if(has){
						%>
							<tr><td colspan="8" align="center">---- Purchase request not found ---- </td></tr>
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