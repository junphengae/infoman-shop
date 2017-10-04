
<%@page import="com.bitmap.bean.service.LaborCate"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Customer Information</title>
<%
String cate_id = WebUtils.getReqString(request,"cate_id");
LaborCate entity = LaborCate.select(cate_id);
%>
</head>
<body>
<div class="m_top10"></div>
<form id="add_item_form" onsubmit="return false;">
	<table width="100%">
		<tr>
			<td colspan="2" align="center" class="txt_bold">หมวดหลัก</td>
		</tr>
		<tr>
			<td width="35%">หมวดหลักที่</td>
			<td width="65%">: <%=entity.getCate_id()%></td>
		</tr>
		<tr>
			<td width="35%">ชื่อหมวด(ไทย)</td>
			<td width="65%">: <input type="text" autocomplete="off" name="cate_th" id="cate_th" value="<%=entity.getCate_th()%>" title="*ชื่อหมวด (ภาษาไทย)" class="txt_box s200 input_focus required"></td>
		</tr>
		<tr>
			<td width="35%">ชื่อหมวด(อังกฤษ)</td>
			<td width="65%">: <input type="text" autocomplete="off" name="cate_en" id="cate_en" value="<%=entity.getCate_en()%>" class="txt_box s200"></td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
				<input type="hidden" name="action" value="edit_labor_cate">
				<input type="hidden" name="cate_id" value="<%=entity.getCate_id()%>">
				<input type="button" class="btn_box" id="btn_add" value="ตกลง">
				<input type="button" class="btn_box" id="btn_cancel" value="ยกเลิก" onclick="javascript: tb_remove();">
			</td>
		</tr>
	</table>
</form>
<script type="text/javascript">
var form = $('#add_item_form');
var v = form.validate({
	submitHandler: function(){
		add();
	}
});

form.submit(function(){
	v;
	return false;
});

$('#btn_add').click(function(){
	form.submit();
});

function add(){
	ajax_load();
	$.post('LaborManagement',form.serialize(),function(resData){
		ajax_remove();
		if (resData.status == 'success') {
			window.location.reload();
			tb_remove();
		} else {
			alert(resData.message);
		}
	},'json');
}
</script>
</body>
</html>