<%@page import="com.bmp.sale.transaction.SaleOderServiceTS"%>
<%@page import="com.bmp.sale.bean.SaleOderServiceBean"%>
<%@page import="com.bitmap.bean.branch.BranchMaster"%>
<%@page import="com.bitmap.bean.hr.Branch"%>
<%@page import="java.util.Map"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.webutils.customtag.ComboBoxTag"%>
<%@page import="com.bitmap.bean.dc.DcpurchaseRequest"%>
<%@page import="com.bitmap.bean.dc.SaleOrderService"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
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
<title>รายการขาย [Sale Order]</title>

<%
String year = WebUtils.getReqString(request, "year");
String month = WebUtils.getReqString(request, "month");
String cus_id = WebUtils.getReqString(request, "cus_id");
String status = WebUtils.getReqString(request, "status");
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();
if (year.length() == 0 || year.equalsIgnoreCase("")) {
	//paramList.add(new String[]{"year",DBUtility.getCurrentYear() + ""});
} else {
	paramList.add(new String[]{"year",year});
}
paramList.add(new String[]{"cus_id",cus_id});
paramList.add(new String[]{"status",status});
paramList.add(new String[]{"month",month});

session.setAttribute("PO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}
Iterator<SaleOderServiceBean> ite = SaleOderServiceTS.selectWithCTSaleOrder(ctrl, paramList).iterator();
if(month.length() > 0 ){
	if(year.length() > 0){
	 ite = SaleOderServiceTS.selectWithCTSaleOrder(ctrl, paramList).iterator();
	}else{
%>
			<script type="text/javascript">
			alert("กรุณาเลือกปีที่ต้องการค้นหา");
			</script>
<%  }
}
%>

<script type="text/javascript">
 function issue_po(){
			ajax_load();
			$.post('../Dc_purchaseManagement','action=issue_po&approve_by=<%=securProfile.getPersonal().getPer_id()%>',function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location='po_issue_review.jsp?po=' + resData.po;
				} else {
					alert(resData.message);
				}
			},'json');
		} 
 function timedRefresh(timeoutPeriod) {
		setTimeout("location.reload(true);",timeoutPeriod);
	}
</script>
</head>
<body  onload="JavaScript:timedRefresh(300000);">
<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Sale Order</div>
				<div class="right">
					 
					  
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="so_manage.jsp" id="search" method="get">
						Status: 
						<bmp:ComboBox name="status" styleClass="txt_box s100" listData="<%=SaleOrderService.ddl_en()%>" value="<%=status%>">
							<bmp:option value="" text="--- all ---"></bmp:option>
						</bmp:ComboBox>
						&nbsp;
						Month/Year:
						<bmp:ComboBox name="month" styleClass="txt_box s80" style="<%=ComboBoxTag.EngMonthList%>" value="<%=month%>">
							<bmp:option value="" text="--- all ---"></bmp:option>
						</bmp:ComboBox>
						<bmp:ComboBox name="year" styleClass="txt_box s80" style="<%=ComboBoxTag.EngYearList%>" value="<%=year%>"> <%-- <%=(year.length()>0)?year:null%> --%>
							<bmp:option value="" text="--- all ---"></bmp:option>
						</bmp:ComboBox>
						&nbsp; 
						Branch:
					 	<bmp:ComboBox name="cus_id" styleClass="txt_box s120" listData="<%=BranchMaster.branchDropdown()%>" value="<%=cus_id%>">
							<bmp:option value="" text="--- all ---"></bmp:option>
						</bmp:ComboBox>
						&nbsp;  
						
						
						<button class="btn_box btn_confirm bth_search" type="submit" onclick="">Search</button> 
						<input type="button" name="reset" value="Reset" class="btn_box s50 m_left5" onclick="clear_form('#search');">
					</form>
				</div>
				<div class="clear"></div>
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"so_manage.jsp",paramList)%></div>
				<div class="clear"></div>
				
			<!-- 	<div class="dot_line"></div> -->
				
				<table class="bg-image s_auto">
					<thead>
						<tr align="center">
							<th valign="top"  width="10%">Job ID</th>
							<th valign="top"  width="25%">Branch</th>
							<th valign="top"  width="10%">Delivery Date</th><!-- //วันที่ร้องขอ  -->
							<th valign="top"  width="10%">Price(฿)</th>
							<th valign="top"  width="15%">Status</th>
							<th align="center" width="5%"></th>
						</tr>
					</thead>
					
					<tbody>
						<%
							boolean has = true;
							while(ite.hasNext()) {
								SaleOderServiceBean entity = (SaleOderServiceBean) ite.next();
								
								 Map map = entity.getUImap();
								 BranchMaster branch =(BranchMaster)map.get(BranchMaster.tableName);  
								
								 has = false;
						%>
							<tr>
								<td align="center"><%=entity.getId()%></td>
								<td align="left"><%=branch.getBranch_name() %> </td>
								<input type="hidden" name="branch_name" value="<%=branch.getBranch_name() %>">
								<td align="center"><%=WebUtils.getDateValue(entity.getDuedate())%></td>
								<td align="right"><%=Money.money(entity.getGrand_total())%></td>
								<td align="center"><%=SaleOrderService.status(entity.getStatus())%></td>
								<input type="hidden" name="status" value="<%=entity.getStatus()%>">
								<td align="center">
									<input type="button" class="btn_box" value="ดู" title="ดูรายละเอียดใบสั่งซื้อ" onclick="javascript: window.location='so_info.jsp?po=<%=entity.getId()%>&branch_name=<%=branch.getBranch_name() %>&status=<%=entity.getStatus()%>';">
								</td>
							</tr>
						<%
							}
							if(has){
						%>
							<tr><td colspan="8" align="center">---- not found ---- </td></tr>
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