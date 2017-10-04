<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.parts.PartBorrow"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%
PartBorrow entity = new PartBorrow();
WebUtils.bindReqToEntity(entity, request);
PartBorrow.select(entity);

PartMaster part = entity.getUIMaster();

%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
$(function(){
	$("#return_by_autocomplete").autocomplete({
        source: "../GetEmployee",
        minLength: 2,
        select: function(event, ui) {
           $('#return_by').val(ui.item.id);
        }
    });
	
	$('#return_qty').blur(function(){
		if ($('#return_qty').val() != '') {
			if (isNumber($('#return_qty').val())) {
				if ($('#return_qty').val()*1 > (<%=entity.getQty()%> - <%=entity.getReturn_qty()%>)) {
					alert('ระบุจำนวนที่ต้องการคืน มากกว่า จำนวนที่ยืม');
					$('#return_qty').val('').focus();
				}
			} else {
				alert('โปรดระบุจำนวนที่ต้องการคืนเป็นตัวเลข');
				$('#return_qty').val('').focus();
			}
		}
	});
	
	var $form = $('#return_non_sn_form');
	var v = $form.validate({
		submitHandler: function(){
			if ($('#pn_non_sn').val() == '<%=entity.getPn()%>') {
				if($('#return_by').val() != ''){
					ajax_load();
					$.post('../BorrowPartManagement',$form.serialize(),function(data){
						ajax_remove();
						if (data.status == 'success') {
							alert('บันทึกข้อมูลการคืนเรียบร้อย');
							window.location.reload();
						} else {
							alert(data.message);
							$('#' + data.focus).focus();
						}
					},'json');
				} else {
					alert('ระบุชื่อผู้คืนไม่ถูกต้อง');
					$('#return_by_autocomplete').focus();
				}
			} else {
				alert('ระบุ หมายเลขรห้สสินค้าไม่ถูกต้อง');
				$('#pn_non_sn').focus();
			}
		}
	});
	
	$form.submit(function(){
		v;
		return false;
	});
});
</script>

</head>
<body>
<form id="return_non_sn_form" onsubmit="return false;">
	<div class="center txt_center txt_bold m_top5">
		การคืน อะไหล่/เครื่องมือ
	</div>
	
	<div class="center m_top10 s600">
		<table>
			<tr>
				<td width="50%">รหัสอะไหล่</td>
				<td width="50%">: <input type="text" name="pn" id="pn_non_sn" autocomplete="off" class="txt_box s150 required input_focus" title="ระบุ *"></td>
			</tr>
			<tr>
				<td>จำนวนที่ยืมทั้งหมด</td>
				<td>: <%=entity.getQty()%></td>
			</tr>
			<tr>
				<td>จำนวนที่คืนแล้ว</td>
				<td>: <%=entity.getReturn_qty()%></td>
			</tr>
			<tr>
				<td>จำนวนที่ทำการคืน</td>
				<td>: <input type="text" name="return_qty" id="return_qty" autocomplete="off" class="txt_box s150 required" title="ระบุ *"></td>
			</tr>
			<tr>
				<td>ชื่อผู้คืน (พิมพ์ชื่อเพื่อค้นหา)</td>
				<td>: <input type="text" class="txt_box s150 required" id="return_by_autocomplete" value="" title="ระบุ *"><input type="hidden" name="return_by" id="return_by" value=""></td>
			</tr>
			<tr>
				<td>หมายเหตุ</td>
				<td>: <input type="text" name="note" autocomplete="off" class="txt_box s180"></td>
			</tr>
		</table>
	</div>
	
	<div class="center txt_center m_top10">
		<input type="hidden" name="action" value="return_part">
		<input type="hidden" name="run" value="<%=entity.getRun()%>">
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
		<input type="submit" class="btn_box btn_confirm" value="บันทึกการคืน">
		<input type="button" class="btn_box" value="ปิดหน้าต่าง" onclick="javascript: tb_remove();">
	</div>
				
</form>
</body>
</html>