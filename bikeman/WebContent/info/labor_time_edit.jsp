<%@page import="com.bitmap.bean.service.LaborTime"%>
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
String main_id = WebUtils.getReqString(request,"main_id");
String labor_id = WebUtils.getReqString(request,"labor_id");
LaborTime entity = LaborTime.select(labor_id);
%>
</head>
<body>
<div class="m_top10"></div>
<form id="edit_labor_time_form" onsubmit="return false;">
	<table width="100%">
		<tr>
			<td colspan="2" align="center" class="txt_bold">รายการซ่อม</td>
		</tr>
		<tr>
			<td width="35%">ชื่อรายการซ่อม(ไทย)</td>
			<td width="65%">: <input type="text" autocomplete="off" name="labor_th" id="labor_th" value="<%=entity.getLabor_th()%>" title="*ชื่อรายการซ่อม (ภาษาไทย)" class="txt_box s200 input_focus required"></td>
		</tr>
		<tr>
			<td width="35%">ชื่อรายการซ่อม(อังกฤษ)</td>
			<td width="65%">: <input type="text" autocomplete="off" name="labor_en" id="labor_en" value="<%=entity.getLabor_en()%>" class="txt_box s200"></td>
		</tr>
		<tr>
			<td width="35%">ระยะเวลา</td>
			<td width="65%">: <input type="text" autocomplete="off" name="labor_hour" id="labor_hour" value="<%=entity.getLabor_hour()%>" class="txt_box s200 required" title="*ระบุระยะเวลา เช่น 0.5 หรือ 1.5"></td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
				<input type="hidden" name="action" value="edit_labor_time">
				<input type="hidden" name="labor_id" value="<%=labor_id%>">
				<input type="hidden" id="main_id" value="<%=main_id%>">
				<input type="button" class="btn_box" id="btn_add" value="ตกลง">
				<input type="button" class="btn_box" id="btn_cancel" value="ยกเลิก" onclick="javascript: tb_remove();">
			</td>
		</tr>
	</table>
</form>
<script type="text/javascript">
var mid = $('#main_id').val();
var form = $('#edit_labor_time_form');
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
			refreshLabor();
			tb_remove();
		} else {
			alert(resData.message);
		}
	},'json');
}

function refreshLabor(){
	$.post('LaborManagement',{action:'GetLabor',main_id: mid},function(lt){
		if (lt.status == 'success') {
			var data = "";
			var m = lt.laborTime;
            for (var i = 0; i < m.length; i++) {
            	data += '<tr id="' + m[i].labor_id + '">'
				+ '<td align="center">' + m[i].labor_id + '</td>'
				+ '<td>' + m[i].labor_en + ' / ' + m[i].labor_th + '</td>'
				+ '<td align="center">' + m[i].labor_hour + '</td>'
				+ '<td align="center">'
				+'<input class="pointer btn_accept'
				+ '" id="' + m[i].labor_id 
				+ '" title="' + m[i].labor_en + ' / ' + m[i].labor_th 
				+ '" lang="' + m[i].labor_hour
			   	+ '" onclick="setLaborTime(this);"/>'
				+ '<input class="btn_update" lang="../info/labor_time_edit.jsp?width=550&amp;height=250&amp;labor_id='+m[i].labor_id +'&amp;main_id='+m[i].main_id+'" type="button" title="แก้ไขรายการซ่อม" onclick="thickbox_init(this);"></td></tr>';
            }
            $('#labor_time_list').html(data);
		} else {
			alert(lm.message);
		}
	},'json');
}
</script>
</body>
</html>