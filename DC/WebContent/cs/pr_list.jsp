<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="java.util.Map"%>
<%@page import="com.bitmap.bean.dc.SaleOrderService"%>
<%@page import="com.bitmap.bean.dc.SaleServicePartDetail"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="com.bitmap.webutils.customtag.ComboBoxTag"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterVendor"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.dc.DcpurchaseRequest"%>
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
<title>Sale Order Item</title>
<%
String year = WebUtils.getReqString(request, "year");
String month = WebUtils.getReqString(request, "month");
String status = WebUtils.getReqString(request, "status");
String page_ = WebUtils.getReqString(request, "page");
String pn = WebUtils.getReqString(request, "pn");

List paramList = new ArrayList();
if (year.length() == 0 || year.equals("")) {
	//paramList.add(new String[]{"year",DBUtility.getCurrentYear() + ""});
} else {
	paramList.add(new String[]{"year",year});
}
paramList.add(new String[]{"status",status});
paramList.add(new String[]{"pn",pn});
paramList.add(new String[]{"month",month});

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(25);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}
session.setAttribute("PR_SEARCH", paramList);

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("PR_SEARCH_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("PR_SEARCH_PAGE")));
}

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("PR_SEARCH_PAGE", page_);
}

Iterator ite = SaleServicePartDetail.selectWithCTRL(ctrl, paramList).iterator();
if(month.length() > 0 ){
	if(year.length() > 0){
	 ite = SaleServicePartDetail.selectWithCTRL(ctrl, paramList).iterator();
	}else{
%>
			<script type="text/javascript">
			alert("กรุณาเลือกปีที่ต้องการค้นหา");
			</script>
<%  }
}

%>
<script type="text/javascript">
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
				<div class="left">Sale Order Item</div>
				<div class="right">
					<button class="btn_box" onclick="javascript: history.back();">Back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<div class="left">
					<form style="margin: 0; padding: 0;" action="pr_list.jsp" id="search" method="get">
							Status: 
							<bmp:ComboBox name="status" styleClass="txt_box s150" listData="<%=SaleOrderService.ddl_en()%>" value="<%=status%>">
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
							&nbsp;&nbsp;
							PN:
							<input type="text" name="pn" value="" size="20">
							&nbsp;&nbsp;
							<button  class="btn_box btn_confirm" type="submit">Search</button>
							<input type="button" name="reset" value="Reset" class="btn_box s50 m_left5" onclick="clear_form('#search');">
						</form>
				</div>
					<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"pr_list.jsp",paramList)%></div>
				<div class="clear"></div>
				
				<div class="dot_line"></div>
					
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th valign="top" align="center" width="14%">Job ID</th>
								<th valign="top" align="center" width="11%">PN</th>
								<th valign="top" align="center" width="30%">Description</th>
								<th valign="top" align="center" width="11%">Create Date</th>
								<th valign="top" align="center" width="5%">Units</th>	
								<th valign="top" align="center" width="8%">QTY</th>							
								<th valign="top" align="center" width="10%">Price(฿)</th>
								<th valign="top" align="center" width="8%">Status</th>
								<th align="center" width="8%"></th>
							</tr>
						</thead>
						<tbody>
						<%
							boolean has = true;
							while(ite.hasNext()) {
								SaleServicePartDetail entity = (SaleServicePartDetail) ite.next();
								Map map = entity.getUImap();
								PartMaster master = (PartMaster)map.get(PartMaster.tableName);
								
								has = false;
						%>
							<tr valign="top">
								<td align="center" valign="top"><%=entity.getNumber()%></td>
								<td align="left" valign="top"><%=entity.getPn()%></td>
								<td align="left" valign="top"><%=master.getDescription()%></td>
								<td align="center" valign="top"><%=WebUtils.getDateValue(entity.getCreate_date())%></td>
								<td align="left" valign="top"><%=UnitType.selectName(master.getDes_unit())%></td>
								<td align="center" valign="top"><%=Money.moneyInteger(entity.getQty())%></td>
								<td align="right" valign="top"><%=Money.money(entity.getPrice())%></td>
								<td align="center" valign="top"><%=SaleOrderService.status(entity.getStatus())%></td>
								<td align="center" valign="top">
								<input type="hidden" name="number" id="number" value="<%=entity.getNumber()%>">
									<%
									if (entity.getStatus().equalsIgnoreCase(SaleOrderService.STATUS_OPENING)){
									%>
									<a class="btn_view thickbox"  title="Detail Sale Order Item : <%=master.getDescription()%>" href="pr_info.jsp?mat_code=<%=entity.getPn()%>&id=<%=entity.getId()%>&number=<%=entity.getNumber()%>&width=650&height=200"></a>
									<%-- <a class="btn_update thickbox" title="Update Sale Order Iten / แก้ไขรายการขาย" href="pr_parts_update.jsp?mat_code=<%=entity.getPn()%>&id=<%=entity.getId()%>&number=<%=entity.getNumber()%>&width=850&height=350"></a> --%>
									<a class="btn_bin thickbox" title="Cancel Sale Order Iten / ยกเลิกรายการขาย  " href="pr_parts_cancel.jsp?mat_code=<%=entity.getPn()%>&id=<%=entity.getId()%>&number=<%=entity.getNumber()%>&width=450&height=200"></a>
									<%} else if(entity.getStatus().equalsIgnoreCase(SaleOrderService.STATUS_CLOSED)){%>
									<a class="btn_view thickbox"  title="Detail Sale Order Item : <%=master.getDescription()%>" href="pr_info.jsp?mat_code=<%=entity.getPn()%>&id=<%=entity.getId()%>&number=<%=entity.getNumber()%>&width=650&height=200"></a>
									<%}%>
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