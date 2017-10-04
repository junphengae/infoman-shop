<%@page import="com.bitmap.bean.purchase.PurchaseOrder"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="java.util.Iterator"%>
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

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>สร้างใบสั่งซื้อ</title>

<%
String vendor_id = WebUtils.getReqString(request, "vendor_id");
String po = WebUtils.getReqString(request, "po");
PurchaseOrder PO_select = PurchaseOrder.selectpo(po);

String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();
paramList.add(new String[]{"status",PurchaseRequest.STATUS_ORDER});
paramList.add(new String[]{"vendor_id",vendor_id});

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

List list = new ArrayList();
if (vendor_id.length() > 0) {
	list = PurchaseRequest.selectWithCTRL(ctrl, paramList);
}
Iterator ite = list.iterator();
%>
<script type="text/javascript">
function issue_po(){
	var po = $('#po').val();
	//alert("submit");
		if ($('#po').val() != '') {
			ajax_load();
			$.post('../PurchaseManageServlet','vendor_id=<%=vendor_id%>&po=<%=po%>&action=issue_po_edit&create_by=<%=securProfile.getPersonal().getPer_id()%>',function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location='po_issue_review.jsp?po=' + resData.po;
				} else {
					alert(resData.message);
				}
			},'json');
		}else{
			
					if ($('#vendor_id').val() == '') {
						alert('ยังไม่ได้เลือกตัวแทนจำหน่ายสำหรับออกใบสั่งซื้อ!');
					} else {
						if (confirm('ยืนยันการสร้างใบสั่งซื้อ')) {
							ajax_load();
							$.post('../PurchaseManageServlet','vendor_id=<%=vendor_id%>&action=issue_po&create_by=<%=securProfile.getPersonal().getPer_id()%>',function(resData){
								ajax_remove();
								if (resData.status == 'success') {
									window.location='po_issue_review.jsp?po=' + resData.po;
								} else {
									alert(resData.message);
								}
							},'json');
						}
					}
		}
		
		
	}
<%-- $(function(){
		$('#vendor_id').find('option[value=<%=PO_select.getVendor_id()%>]').attr("selected","selected");
		
	}); --%>
</script>
</head>
<body>
<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายการใบสั่งซื้อ [PO] | สร้างใบสั่งซื้อ</div>
				<div class="right">
					<!--  <button type="button" class="btn_box" onclick="window.location='<%//=LinkControl.link("po_manage.jsp", (List) session.getAttribute("PO_SEARCH"))%>';">ย้อนกลับ</button> -->
					<button type="button" class="btn_box" onclick="window.location='po_list.jsp';">ย้อนกลับ</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="po_issue.jsp?" id="search" method="get">
						เลือกตัวแทนจำหน่ายสำหรับสร้างใบสั่งซื้อ:
						 <input type="hidden" id="po"  name="po" value="<%=WebUtils.getReqString(request, "po")%>" >
						<bmp:ComboBox name="vendor_id" styleClass="txt_box s200" listData="<%=PurchaseRequest.vendorDropdown()%>" value="<%=vendor_id%>" onChange="$('#search').submit();" > 
							
							<bmp:option value="" text="--- เลือกตัวแทนจำหน่าย ---"></bmp:option>
						</bmp:ComboBox> 
						<%if(list.size() > 0){%><input type="button" value="เริ่มสร้าง" class="btn_box btn_confirm" onclick="issue_po();"><%}%>
						
					</form>
				</div>
				
				<div class="clear"></div>
				
				<div class="dot_line m_top5"></div>
				
			</div>
			
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
</body>
</html>