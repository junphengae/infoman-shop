<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterVendor"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
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

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>สร้างใบสั่งซื้อ</title>
<%
String vendor_id = WebUtils.getReqString(request, "vendor_id");
String page_ = WebUtils.getReqString(request, "page");

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

%>
<script type="text/javascript">
function issue_po(){
		if (confirm('ยืนยันการสร้างใบสั่งซื้อ')) {
			ajax_load();
			$.post('PurchaseManage','action=issue_p',function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location='po_issue_review.jsp?po=' + resData.po;
				} else {
					alert(resData.message);
				}
			},'json');
		}
	
}
</script>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	<input type="button" value="เริ่มสร้าง" class="btn_box btn_confirm" onclick="issue_po();">
	
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>

</body>
</html>