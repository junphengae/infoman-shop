<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.purchase.PurchaseOrder"%>
<%@page import="Component.Accounting.Money.MoneyAccounting"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
String po = WebUtils.getReqString(request, "po");
String status = WebUtils.getReqString(request, "status");
%>
<title>แก้ไขสถานะใบสั่งซื้อ</title>
<style type="text/css">
.main_body {
width:490px !important;

}
.main_body_sub {
width:450px !important;

}
</style>
</head>
<body >
<div class="wrap_all main_body">	
	<div class="wrap_body main_body" >
		<div class="body_content main_body">
			<div class="content_head main_body">
			<div class="left">ใบสั่งซื้อ เลขที่ [<%= po %>]</div> 				
				<div class="clear"></div>
			</div>
			
			<div class="content_body main_body_sub">
					<form id="po_form_restatus" onsubmit="return true;">
					<br/>
					<div align="center">
						สถานะ: 
						<bmp:ComboBox name="status" styleClass="txt_box s100" listData="<%=PurchaseRequest.statusDropdownReStatusPO()%>" value="<%=status%>">
						</bmp:ComboBox>
					</div>
					<br/>
					<br/>
						<input type="hidden" name="po" value="<%=po%>">
						<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
						<input type="hidden" name="action" value="restatus_po">
					<div align="center">
					<input type="reset" id="close_form" onclick="tb_remove();" value="Close" class="btn_box btn_warn">
					<input type="button" id="btn_restatus" value="บันทึก" class="btn_box btn_confirm">
					</div>	
					</form>
					
			</div>
			
		</div>
	</div>
	<script type="text/javascript">
				$(function(){
					$("#close_form").click(function(){ 					
				       	window.close(); 
					});
					
					$( "#btn_restatus" ).click(function() {
						
						if (confirm('ยืนยันการบันทึกใบสั่งซื้อ')) {
							ajax_load();
							$.post('../PurchaseManage',$('#po_form_restatus').serialize(),function(resData){
								ajax_remove();
								if (resData.status == 'success') {
									window.location ="po_restatus.jsp";
								} else {
									alert(resData.message);
								}
							},'json');
					}
						
					});
					
					
					
				});
	</script>
</div>
</body>
</html>