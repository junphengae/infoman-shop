<%@page import="com.bitmap.bean.parts.PartMaster"%>
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
String year = WebUtils.getReqString(request, "year");
String month = WebUtils.getReqString(request, "month");
String status = WebUtils.getReqString(request, "status");
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();
if (year.length() == 0) {
	//paramList.add(new String[]{"year",DBUtility.getCurrentYear() + ""});

} else {
	paramList.add(new String[]{"year",year});
}
paramList.add(new String[]{"status",status});
paramList.add(new String[]{"month",month});

session.setAttribute("PO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

Iterator ite = PurchaseOrder.selectWithCTRLapprove(ctrl, paramList).iterator();


%>
<script type="text/javascript">
//CallWSSevrlet();
$(function (){
	//====== ********** นัฐยา ทำเพื่ออัพเดทข้อมูล Web Service   *******************=============//
	//ajax_load();
	$.post('../CallWSSevrlet','action=updateShopToDc_popr',function(response){		
	//ajax_remove();  
		if (response.status == 'success') {
			//window.location.reload();			
		} 
		else {
			alert(response.message);
		}
	},'json'); 
	//=================================================================================//
});
</script>

</head>
<body>
<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายการใบสั่งซื้อ</div>
				<div class="right">
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="txt_center">
					<form style="margin: 0; padding: 0;" action="po_manage.jsp" id="search" method="get">
						สถานะ: 
						<bmp:ComboBox name="status" styleClass="txt_box s100" listData="<%=PurchaseRequest.statusDropdown4POapprove()%>" value="<%=status%>">
							<bmp:option value="" text="แสดงทั้งหมด"></bmp:option>
						</bmp:ComboBox>
						&nbsp;
						
						เดือน/ปี: 
						<bmp:ComboBox name="month" styleClass="txt_box s100" style="<%=ComboBoxTag.EngMonthList%>" value="<%=month%>">
							<bmp:option value="" text="แสดงทั้งหมด"></bmp:option>
						</bmp:ComboBox>
						
						<bmp:ComboBox name="year" styleClass="txt_box s100" style="<%=ComboBoxTag.EngYearList%>" value="<%=year%>">
							<bmp:option value="" text="แสดงทั้งหมด"></bmp:option>
						</bmp:ComboBox>

						<button class="btn_box btn_confirm" type="submit">แสดงผล</button>
					</form>
				</div>
				<div class="clear"></div>
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"po_manage.jsp",paramList)%></div>
				<div class="clear"></div>
				
			<!-- 	<div class="dot_line"></div> -->
				<div class="scroll">
				<table class="bg-image s_auto breakword columntop">
					<thead>
						<tr>
							<th valign="top" align="center" width="9%">เลขที่ PO</th>
							<th valign="top" align="center" width="12%">วันที่ออก</th>
							<th valign="top" align="center" width="12%">กำหนดส่ง</th>
							<th valign="top" align="center" width="12%">วันที่ปิด</th>
							<th valign="top" align="center" width="30%">หมายเหตุ</th>
							<th valign="top" align="right" width="12%">ยอดเงิน</th>
							<th valign="top" align="center" width="8%">สถานะ</th>
							<th align="center" width="5%"></th>
						</tr>
					</thead>
					
					<tbody>
						<%
							boolean has = true;
							while(ite.hasNext()) {
								PurchaseOrder entity = (PurchaseOrder) ite.next();
								has = false;
								

								
						%>
							<tr>
								<td align="center"><%=entity.getPo().trim()%></td>
								<td align="center"><%=WebUtils.getDateValue(entity.getCreate_date()).trim()%></td>
								<td align="center"><%=WebUtils.getDateValue(entity.getDelivery_date()).trim()%></td>
								<td align="center"><%=WebUtils.getDateValue(entity.getReceive_date()).trim()%></td>
								<td align="left"><%=entity.getNote().trim()%></td>
								<td align="right"><%=Money.money(entity.getGrand_total())%></td>
								<td align="center"><%=PurchaseRequest.status(entity.getStatus())%></td>
								<td align="center">
									<input type="button" class="btn_box thickbox pointer btn_confirm" value="ดู" title="รายละเอียดใบสั่งซื้อ" lang="po_approve_info.jsp?po=<%=entity.getPo()%>&width=750&height=500">
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
</div>

<jsp:include page="../index/footer.jsp"></jsp:include>
</div>


</body>
</html>