<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<title>Insert title here</title>
<script type="text/javascript">
$(function(){
	$('#qty').focus();
	
});

var form = $('#material_form');

var v = form.validate({
	submitHandler: function(){
		ajax_load();
		$.post('../MaterialManage',form.serialize(),function(resData){			
			ajax_remove();
			if (resData.status == 'success') {
				window.location.reload();
			} else {
				alert(resData.message);
			}
		},'json'); 		
		
		
	}
});

form.submit(function(){
	v;
	return false;
});

</script>
</head>
<body>
	<form onsubmit="return false;" id="material_form">
			<div class="s400 center m_top20">
				<div class="left s100">จำนวนคงเหลือ :</div>
				<div class="left s200"><input name="qty" class="required number txt_box" title="กรุณากรอกอีกครั้ง!" id="qty" type="text" size="15"></div>
				<div class="clear"></div>
				<div class="txt_center"><button class="btn_submit btn_box m_top10" type="submit">ตกลง</button></div>
			</div>
			
			<input type="hidden" name = "action"  value="check_qty">
			<input type="hidden" name = "qty_use" value="<%=WebUtils.getReqString(request,"qty")%>">
			<input type="hidden" name = "mat_code" value="<%=WebUtils.getReqString(request,"mat_code")%>">
			<input type="hidden" name = "update_by" value="<%=securProfile.getPersonal().getPer_id()%>">	 
	</form>
</body>
</html>