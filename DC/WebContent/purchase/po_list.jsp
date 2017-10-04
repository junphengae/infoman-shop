
<%@page import="com.bmp.purchase.transaction.PurchaseOrderTS"%>
<%@page import="com.bmp.purchase.bean.PurchaseOrderBean"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.webutils.customtag.ComboBoxTag"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="com.bitmap.bean.purchase.PurchaseOrder"%>
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
<title>รายการใบสั่งซื้อ [PO List]</title>

<%
String year = WebUtils.getReqString(request, "year");
String month = WebUtils.getReqString(request, "month");
String vendor_id = WebUtils.getReqString(request, "vendor_id");
String status = WebUtils.getReqString(request, "status");
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();
if (year.length() == 0) {
	//paramList.add(new String[]{"year",DBUtility.getCurrentYear() + ""});
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

Iterator ite = PurchaseOrderTS.selectWithCTRL(ctrl, paramList).iterator();

Boolean checkOpenPO = true ; 
String checkOpenPONO = "";

if( month.length() > 0  ){
	if( year.length() > 0 ){
		ite = PurchaseOrderTS.selectWithCTRL(ctrl, paramList).iterator();
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
				<div class="left">รายการใบสั่งซื้อ</div>
				<div class="right">
					<!-- 
					<button class="btn_box btn_confirm" onclick="window.location='po_issue.jsp';">สร้างใบสั่งซื้อ</button>
					
					 -->
					 <!-- 
					<button class="btn_box btn_confirm" onclick="window.location='po_issue_review.jsp';">สร้างใบสั่งซื้อ</button>
					 -->
					<button class="btn_box btn_confirm" onclick="issue_po();">สร้างใบสั่งซื้อ</button>
					  
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="po_list.jsp" id="search" method="get">
						<Strong>Status: </Strong>
						<bmp:ComboBox name="status" styleClass="txt_box s100" listData="<%=PurchaseRequest.statusDropdown4PO()%>" value="<%=status%>">
							<bmp:option value="" text="--- All ---"></bmp:option>
						</bmp:ComboBox>
						&nbsp;
						
						<Strong>Agent:</Strong>
						<bmp:ComboBox name="vendor_id" styleClass="txt_box s120" listData="<%=PurchaseRequest.vendorDropdown()%>" value="<%=vendor_id%>">
							<bmp:option value="" text="--- All ---"></bmp:option>
						</bmp:ComboBox>
						&nbsp;
						
						<Strong>Month/Year: </Strong>
						<bmp:ComboBox name="month" styleClass="txt_box s80" style="<%=ComboBoxTag.EngMonthList%>" value="<%=month%>">
							<bmp:option value="" text="--- All ---"></bmp:option>
						</bmp:ComboBox>
						<bmp:ComboBox name="year" styleClass="txt_box s80" style="<%=ComboBoxTag.EngYearList%>" value="<%=year%>">
								<bmp:option value="" text="--- All ---"></bmp:option>
						</bmp:ComboBox>

						<button class="btn_box btn_confirm" type="submit">Search</button>
						<input type="button" name="btn_reset" value="Reset" class="btn_box s50 m_left5" onclick="clear_form('#search');">
					</form>
				</div>
				<div class="clear"></div>
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"po_list.jsp",paramList)%></div>
				<div class="clear"></div>
				
			<!-- 	<div class="dot_line"></div> -->
				
				<table class="bg-image s_auto">
					<thead>
						<tr>
							<th valign="top" align="center" width="10%">เลขที่ PO</th>
							<th valign="top" align="center" width="10%">วันที่ออก</th>
							<th valign="top" align="center" width="10%">กำหนดส่ง</th>
							<th valign="top" align="center" width="10%">วันที่ปิด</th>
							<th valign="top" align="center" width="15%">ยอดเงิน(฿)</th>
							<th valign="top" align="center" width="12%">สถานะ</th>
							<th align="center" width="7%"></th>
						</tr>
					</thead>
					
					<tbody>
						<%
							boolean has = true;
						
							while(ite.hasNext()) {
								PurchaseOrderBean entity = (PurchaseOrderBean) ite.next();
								has = false;
								
									if(entity.getStatus().equalsIgnoreCase(PurchaseRequest.STATUS_PO_OPENING)){
	
										
										checkOpenPO = false;
										checkOpenPONO = entity.getPo();
										
									}
						%>
							<tr>
								<td align="center" ><%=entity.getPo()%></td>
								<td align="center"><%=WebUtils.getDateValue(entity.getCreate_date())%></td>
								<td align="center"><%=WebUtils.getDateValue(entity.getDelivery_date())%></td>
								<td align="center"><%=WebUtils.getDateValue(entity.getReceive_date())%></td>
								<td align="right"><%=Money.money(entity.getGrand_total())%></td>
								<td align="center"><%=PurchaseRequest.status(entity.getStatus())%></td>
								<td align="center">
									<input type="button" class="btn_box" value="ดู" title="ดูรายละเอียดใบสั่งซื้อ" onclick="javascript: window.location='po_info.jsp?po=<%=entity.getPo()%>';">
								</td>
							</tr>
						<%
							}
							if(has){
						%>
							<tr><td colspan="8" align="center">---- ไม่พบรายการใบสั่งซื้อสินค้า ---- </td></tr>
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


<script type="text/javascript">
	
	function issue_po(){
		if(<%=checkOpenPO%> == true ){
			window.location='po_issue.jsp';
		}else{

			alert("มีการเปิด PO เลขที่ ['<%=checkOpenPONO%>'] อยู่ คุณต้องการเพิ่มรายการสั่งซื้อลงใน PO เลขที่ ['<%=checkOpenPONO%>'] หรือไม่");  
		}
	}

	
</script>
</body>
</html>
