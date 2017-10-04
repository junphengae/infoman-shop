<%@page import="com.bitmap.utils.ReportUtils"%>
<%@page import="com.bitmap.security.SecurityUserRole"%>
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
<link href="../css/barcode.css" rel="stylesheet" type="text/css" media="all">

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

Iterator ite = PurchaseOrder.selectWithCTRL(ctrl, paramList).iterator();

Boolean checkOpenPO = true ; 
String checkOpenPONO = "";

%>



<script type="text/javascript">
	
	function issue_po(){
		if(<%=checkOpenPO%> == true ){
				if (confirm('ยืนยันการสร้างใบสั่งซื้อ')) {
						ajax_load();
						$.post('../PurchaseManage','action=issue_po&create_by=<%=securProfile.getPersonal().getPer_id()%>',function(resData){
							ajax_remove();
							if (resData.status == 'success') {
								window.location='po_issue_review.jsp?po=' + resData.po;
							} else {
								alert(resData.message);
							}
						},'json');
				}
			}else{

			
				alert("มีการเปิด PO เลขที่ ['<%=checkOpenPONO%>'] อยู่ คุณต้องการเพิ่มรายการสั่งซื้อลงใน PO เลขที่ ['<%=checkOpenPONO%>'] หรือไม่");  
			}
	}

	
	function Send_dc_PO(po){
		
		if (confirm('ยืนยันการส่งข้อมูลให้สำนักงานใหญ่ของ PO เลขที: '+po)) {
			
			ajax_load();
			$.post('../PurchaseManage','action=restatusPO&update_by=<%=securProfile.getPersonal().getPer_id()%>&po='+po,function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					ajax_load();
					//window.location='po_list.jsp';
				} else {
					alert(resData.message);
				}
			},'json');
			
			//====== ********** นัฐยา ทำเพื่ออัพเดทข้อมูล Web Service   *******************=============//
			ajax_load();
			$.post('../CallWSSevrlet','action=updateShopToDc_poprWherePO&po='+po,function(response){		
			ajax_remove();  
				if (response.status == 'success') {
					//window.location='po_list.jsp';
					//alert("update po pr สำเร็จ");
				} 
				else {
					alert(response.message);
				}
			},'json'); 
			//=================================================================================//
			
		}else {
			window.location='po_list.jsp';
		}
	
   }
	
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
				<div class="txt_center">
					<form style="margin: 0; padding: 0;" action="po_list.jsp" id="search" method="get">
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
					</form>
				</div>
				<div class="clear"></div>
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"po_list.jsp",paramList)%></div>
				<div class="clear"></div>
				
			<!-- 	<div class="dot_line"></div> -->
				
				<table class="columntop bg-image breakword "  width="100%">
					<thead>
						<tr>
							<th valign="top" align="center" width="11%">เลขที่ PO</th>
							<th valign="top" align="center" width="11%">วันที่ออก</th>
							<th valign="top" align="center" width="11%">กำหนดส่ง</th>
							<th valign="top" align="center" width="11%">วันที่ปิด</th>
							<th valign="top" align="center" width="30%">ยอดเงิน</th>
							<th valign="top" align="center" width="15%">สถานะ</th>
							<th align="center" width="11%"></th>
						</tr>
					</thead>
					
					<tbody>
					 <tr> 
						 <td colspan="7" style="padding: 0px 0px 0px 0px;" width="100%">
							 <div class="scroll">
							  <table class="bg-image breakword"  style="border-collapse: collapse;" width="100%">
										<%
											boolean has = true;
										
											while(ite.hasNext()) {
												PurchaseOrder entity = (PurchaseOrder) ite.next();
												has = false;
												
													if(entity.getStatus().equalsIgnoreCase(PurchaseRequest.STATUS_PO_OPENING)){
					
														
														checkOpenPO = false;
														checkOpenPONO = entity.getPo();
														
													}
										%>
											<tr>
												<td align="center"  width="11%"><%=entity.getPo()%></td>
												<td align="center"  width="11%"><%=WebUtils.getDateValue(entity.getCreate_date())%></td>
												<td align="center" width="11%"><%=WebUtils.getDateValue(entity.getDelivery_date())%></td>
												<td align="center" width="11%"><%=WebUtils.getDateValue(entity.getReceive_date())%></td>
												<td align="right" width="30%"><%=Money.money(entity.getGrand_total())%></td>
												<td align="center" width="15%"><%=PurchaseRequest.status(entity.getStatus())%></td>
												<td align="center" width="11%">
													<input type="button" class="btn_box" value="ดู" title="ดูรายละเอียดใบสั่งซื้อ" onclick="javascript: window.location='po_info.jsp?po=<%=entity.getPo()%>';">
												  <% 
												   String po_no = entity.getPo();
												   String statusPo = entity.getStatus();
												   String CheckRole = SecurityUserRole.admin(securProfile.getPersonal().getPer_id());
												     int  CheckRoleCount = Integer.parseInt(CheckRole);
													 if(CheckRoleCount > 0){ 
														 if(statusPo.equalsIgnoreCase("30")){
												  %>	
												   <button class="btn_reload"  onclick="Send_dc_PO('<%=po_no%>');"  title="Send PO to Dc"></button>
												  <%} }%>
												
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