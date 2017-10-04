<%@page import="com.bitmap.bean.customerService.RepairOrder"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Customer Information</title>

</head>
<body>
<div class="m_top10"></div>
<form id="add_item_form" onsubmit="return false;">
	<table width="100%">
		<tr>
			<td colspan="2" align="center" class="txt_bold">หมวดย่อย</td>
		</tr>
		<tr>
			<td width="35%">ชื่อหมวด(ไทย)</td>
			<td width="65%">: <input type="text" autocomplete="off" name="main_th" id="main_th" value="" title="*ชื่อหมวด (ภาษาไทย)" class="txt_box s200 input_focus required"></td>
		</tr>
		<tr>
			<td width="35%">ชื่อหมวด(อังกฤษ)</td>
			<td width="65%">: <input type="text" autocomplete="off" name="main_en" id="main_en" value="" class="txt_box s200"></td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="hidden" name="cate_id" value="<%=WebUtils.getReqString(request,"cate_id")%>">
				<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
				<input type="hidden" name="action" value="add_labor_main">
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
// 			var txt = '<tr><td><div class="lm left pointer" lang="' + resData.main_id + '" id="' + resData.main_id + '" onclick="javascript: getLabor(this);">' + resData.main_th + ' / ' + resData.main_en + '</div><div class="right"><input type="button" class="btn_box" onclick="thickbox_init(this);" value="แก้ไข" lang="../info/labor_main_edit.jsp?width=550&height=250&main_id=' + resData.main_id + '&cate_id=' + resData.cate_id + '" title="แก้ไขหมวดย่อย"></div></td></tr>';
// 			$('#labor_main tbody').append(txt);
// 			resize_main();
			window.location.reload();
			tb_remove();
		} else {
			alert(resData.message);
		}
	},'json');
}

/*
function add_new_item(){
	ajax_load();
	$.post('LaborManagement',$('#add_item_form').serialize(),function(resData){
		ajax_remove();
		if(resData.status == 'success'){
			var txt = '<tr><td><div class="lc left pointer" lang="' + resData.cate_id + '">' + resData.cate_th + ' / ' + resData.cate_en + '</div><div class="right"><input type="button" class="btn_box" value="แก้ไข"></div>';
			$('#labor_cate tbody').append(txt);
		</td>
	</tr>'
		} else {
			alert(resData.message);
		}
	},'json');
}*/

</script>
</body>
</html>