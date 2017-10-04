<%@page import="com.bmp.purchase.bean.PurchaseOrderBean"%>
<%@page import="com.bmp.purchase.transaction.PurchaseOrderTS"%>
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
<link href="../css/barcode.css" rel="stylesheet" type="text/css" media="all"> 

<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/thickbox.js" type="text/javascript"></script>
<script src="../js/loading.js" type="text/javascript"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายการใบสั่งซื้อ [PO List]</title>

<%
String status = "30" ;
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();

paramList.add(new String[]{"status",status});
session.setAttribute("PO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(10);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

Iterator ite = PurchaseOrderTS.selectWithCTRL(ctrl, paramList).iterator();

%>


</head>
<body>
<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Add Stock</div>
				<div class="right">
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="txt_center">
					<%-- <form style="margin: 0; padding: 0;" action="po_list.jsp" id="search" method="get">
						สถานะ: 
						<bmp:ComboBox name="status" styleClass="txt_box s100" listData="<%=PurchaseRequest.statusDropdown4PO()%>" value="<%=status%>">
							<bmp:option value="" text="แสดงทั้งหมด"></bmp:option>
						</bmp:ComboBox>
						&nbsp;
						
						ตัวแทนจำหน่าย:
						<bmp:ComboBox name="vendor_id" styleClass="txt_box s120" listData="<%=PurchaseRequest.vendorDropdown()%>" value="<%=vendor_id%>">
							<bmp:option value="" text="แสดงทั้งหมด"></bmp:option>
						</bmp:ComboBox>
						&nbsp;
						
						เดือน/ปี: 
						<bmp:ComboBox name="month" styleClass="txt_box s80" style="<%=ComboBoxTag.EngMonthList%>" value="<%=month%>">
							<bmp:option value="" text="ทุกเดือน"></bmp:option>
						</bmp:ComboBox>
						<bmp:ComboBox name="year" styleClass="txt_box s80" style="<%=ComboBoxTag.EngYearList%>" value="<%=(year.length()>0)?year:null%>"></bmp:ComboBox>

						<button class="btn_box btn_confirm" type="submit">แสดงผล</button>
					</form> --%>
				</div>
				<div class="clear"></div>
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"po_list.jsp",paramList)%></div>
				<div class="clear"></div>
				
				<table class="columntop bg-image breakword "  width="100%" >
					<thead>
						<tr>
							<th valign="top" align="center" width="13.3%">เลขที่ PO</th>
							<th valign="top" align="center" width="13.3%">วันที่ออก</th>
							<th valign="top" align="center" width="13.3%">กำหนดส่ง</th>
							<th valign="top" align="center" width="13.3%">วันที่อนุมัติ</th>
							<th valign="top" align="center" width="19.8%">ยอดเงิน</th>
							<th valign="top" align="center" width="16%">สถานะ</th> 
							<th align="center" width="11%"></th>
						</tr>
					</thead>
					
					<tbody>
					
					<!-- <tr> 
						 <td colspan="7" style="padding: 0px 0px 0px 0px;" width="100%">
							 <div class="scroll">
							  <table class="bg-image breakword"  style="border-collapse: collapse;" width="100%"> -->
											<%
												boolean has = true;
												while(ite.hasNext()) {
													PurchaseOrderBean entity = (PurchaseOrderBean) ite.next();
													has = false;
											%>
												<tr>
													<td align="center" width="9%"><%=entity.getPo()%></td>
													<td align="center" width="10%"><%=WebUtils.getDateValue(entity.getCreate_date())%></td>
													<td align="center" width="10%"><%=WebUtils.getDateValue(entity.getDelivery_date())%></td>
													<td align="center" width="10%"><%=WebUtils.getDateValue(entity.getApprove_date())%></td>
													<td align="right"  width="15%"><%=Money.money(entity.getGrand_total())%></td>
													<td align="center" width="12%"><%=PurchaseRequest.status(entity.getStatus())%></td>
													<td align="center"  width="7%">
														<input type="button" class="btn_box" value="ดู" title="ดูรายละเอียด" onclick="javascript: window.location='part_add_stock_item.jsp?po=<%=entity.getPo()%>';">
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
											
						<!-- 					</table>
								</div>
							</td>
						</tr> -->
					</tbody>
				</table>
			
		</div>
	
	</div>
</div>

<jsp:include page="../index/footer.jsp"></jsp:include>
</div>


</body>
</html>