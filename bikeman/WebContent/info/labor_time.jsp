<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายการซ่อม</title>

</head>
<body>
<div class="m_top10"></div>
<form id="add_item_form" onsubmit="return false;">
	<table width="100%">
		<tr>
			<td colspan="2" align="center" class="txt_bold">รายการซ่อม</td>
		</tr>
		<tr>
			<td width="35%">ชื่อรายการซ่อม(ไทย)</td>
			<td width="65%">: <input type="text" autocomplete="off" name="labor_th" id="labor_th" value="" title="*ชื่อรายการซ่อม (ภาษาไทย)" class="txt_box s200 input_focus required"></td>
		</tr>
		<tr>
			<td width="35%">ชื่อรายการซ่อม(อังกฤษ)</td>
			<td width="65%">: <input type="text" autocomplete="off" name="labor_en" id="labor_en" value="" class="txt_box s200"></td>
		</tr>
		<tr>
			<td width="35%">ระยะเวลา</td>
			<td width="65%">: <input type="text" autocomplete="off" name="labor_hour" id="labor_hour" value="0.0" class="txt_box s200 required" title="*ระบุระยะเวลา เช่น 0.5 หรือ 1.5"></td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="hidden" name="main_id" value="<%=WebUtils.getReqString(request,"main_id")%>">
				<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
				<input type="hidden" name="action" value="add_labor_time">
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
		var li = '';
		var $labor_time_list = $('#labor_time_list');
		
		
		if (resData.status == 'success') {
		//var txt = '<tr><td><div class="lt left pointer s650" lang="' + resData.labor_id + '">' + resData.labor_id + ": " + resData.labor_th + ' / ' + resData.labor_en + '</div><div class="right s60"><input type="button" class="btn_box" onclick="thickbox_init(this);" value="แก้ไข" lang="../info/labor_time_edit.jsp?width=550&height=250&main_id=' + resData.main_id + '&labor_id=' + resData.labor_id + '" title="แก้ไขรายการซ่อม"></div><div class="right s50 txt_center">' + resData.labor_hour + '</div></td></tr>';

 				li += '<tr id="' + resData.labor_id+ '">'
							+ '<td align="center">' + resData.labor_id + '</td>'
							+ '<td>' + resData.labor_en  + ' / ' + resData.labor_th + '</td>'
							+ '<td align="center">' +  resData.labor_hour  + '</td>'
							+ '<td align="center">'
							+'<input class="pointer btn_accept'
							+ '" id="' + resData.labor_id 
							+ '" title="' + resData.labor_en + ' / ' + resData.labor_th 
							+ '" lang="' + resData.labor_hour
						   	+ '" onclick="setLaborTime(this);"/>'
							+'<input class="btn_update" lang="../info/labor_time_edit.jsp?width=550&amp;height=250&amp;labor_id='+resData.labor_id +'&amp;main_id='+resData.main_id+'" type="button" title="แก้ไขรายการซ่อม" onclick="thickbox_init(this);" >'
							+'</td>'
							+ '</tr>';
			$labor_time_list.append(li);
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