<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<script type="text/javascript">
	$(function(){
		var $form = $('#subCatForm');

		var v = $form.validate({
			submitHandler: function(){
				ajax_load();
				$.post('../PartManagement',$form.serialize(),function(data){
					ajax_remove();
					if (data.status == 'success') {
						$('select[name=sub_cat_id]').append('<option value="' + data.sub_cat_id + '">' + data.sub_cat_name_th + ' ' + data.sub_cat_name_short + '</option>');
						$('select[name=sub_cat_id]').val(data.sub_cat_id);
						$('#edit_sub_cat').fadeIn(500).attr('lang','sub_cat_edit.jsp?height=180&width=440&cat_id=' + data.cat_id + '&sub_cat_id=' + data.sub_cat_id + '&group_id=' + data.group_id);
						tb_remove();
					} else {
						alert(data.message);
						$('#subCatForm #sub_cat_name_short').focus();
					}
				},'json');
			}
		});
		
		$form.submit(function(){
			v;
			return false;
		});
	});
	
	
	

	$('#group_id').change(function(){
		ajax_load();
		$.post('../PartManagement',{group_id: $(this).val(),action:'get_cat_th'}, function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				var options = '<option value="">--- เลือกชนิด ---</option>';
                var j = resData.cat;
                $.each(j , function (index , object){
                	 options += '<option value="' + object.cat_id + '">' + object.cat_name_th + ' ' + object.cat_name_short + '</option>';

                });
                	
             	$('#cat_id').html(options);
             	$('#sub_cat_id').html('<option value="">--- เลือกชนิดย่อย ---</option>');
			} else {
				alert(resData.message);
			}
        },'json');
		
		if($(this).val() != "") {
			$('#edit_group').fadeIn(500).attr('lang','part_group_edit.jsp?height=180&width=440&group_id=' + $(this).val());
			$('#new_cat').fadeIn(500).attr('lang','part_cat_new.jsp?height=180&width=440&group_id=' + $(this).val());
			$('#edit_cat').hide();
			$('#edit_sub_cat').hide();
			$('#new_sub_cat').hide();
		} else {
			$('#edit_group').hide();
			$('#new_cat').hide();
			$('#edit_cat').hide();
			$('#edit_sub_cat').hide();
			$('#new_sub_cat').hide();
		}
	});
	
	if($('#group_id').val() != "") {
		$.post('../PartManagement',{group_id: $('#group_id').val(),action:'get_cat_th'}, function(resData){
			if (resData.status == 'success') {
				var options = '<option value="">--- เลือกชนิด ---</option>';
                var k = resData.cat;

                $.each(j , function (index , object){
                	 options += '<option value="' + object.cat_id + '">' + object.cat_name_th + ' ' + object.cat_name_en + '</option>';
                	
                });
             	$('#cat_id').html(options);
             	$('#sub_cat_id').html('<option value="">--- เลือกชนิดย่อย ---</option>');
			} else {
				alert(resData.message);
			}
        },'json');
		$('#edit_group').fadeIn(500).attr('lang','part_group_edit.jsp?height=180&width=440&group_id=' + $('#group_id').val());
		$('#new_cat').fadeIn(500).attr('lang','part_cat_new.jsp?height=180&width=440&group_id=' +$('#group_id').val());
		$('#edit_cat').hide();
		$('#edit_sub_cat').hide();
		$('#new_sub_cat').hide();
	} else {
		$('#edit_group').hide();
		$('#new_cat').hide();
		$('#edit_cat').hide();
		$('#edit_sub_cat').hide();
		$('#new_sub_cat').hide();
	}
	
	
	$('#cat_id').change(function(){
		ajax_load();
		$.post('../PartManagement',{group_id:$('#group_id').val(),cat_id: $(this).val(),action:'get_sub_cat_th'}, function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				var options = '<option value="">--- เลือกชนิดย่อย ---</option>';
                var j = resData.sub_cat;
	          //  for (var i = 0; i < j.length; i++) {
	            //    options += '<option value="' + j[i].sub_cat_id + '">' + j[i].sub_cat_name_th + ' ' + j[i].sub_cat_name_short + '</option>';
	            //}
	            $.each(j , function (index , object){
                	 options += '<option value="' + object.sub_cat_id + '">' + object.sub_cat_name_th + ' ' + object.sub_cat_name_short + '</option>';
                });
             	$('#sub_cat_id').html(options);
			} else {
				alert(resData.message);
			}
        },'json');
		
		if($(this).val() != "") {
			$('#new_sub_cat').fadeIn(500).attr('lang','part_sub_cat_new.jsp?height=180&width=440&cat_id=' + $(this).val() + '&group_id=' + $('#group_id').val());
			$('#edit_cat').fadeIn(500).attr('lang','part_cat_edit.jsp?height=180&width=440&cat_id=' + $(this).val() + '&group_id=' + $('#group_id').val());
			$('#edit_sub_cat').hide();
		} else {
			$('#edit_cat').hide();
			$('#edit_sub_cat').hide();
			$('#new_sub_cat').hide();
		}
	});
	
	$('#sub_cat_id').change(function(){
		if($(this).val() != "") {
			$('#edit_sub_cat').fadeIn(500).attr('lang','part_sub_cat_edit.jsp?height=180&width=440&sub_cat_id=' + $(this).val() + '&cat_id=' + $('#cat_id').val() + '&group_id=' + $('#group_id').val());
		} else {
			$('#edit_sub_cat').hide();
		}
	});
</script>
<div>
	<form id="subCatForm" action="" method="post" style="margin: 0;padding: 0;">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="420px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>เพิ่มชนิดย่อย</h3></td></tr>
			<tr align="center" height="10px"><td colspan="2"></td></tr>
			<tr>
				<td align="left" width="20%"><label>ชื่อชนิดย่อย</label></td>
				<td align="left" width="80%">: <input type="text" autocomplete="off" name="sub_cat_name_th" id="sub_cat_name_th" class="txt_box s200 required input_focus"></td>
			</tr>
			<tr align="center" height="10px"><td colspan="2"></td></tr>
			<tr>
				<td><label>ชื่อย่อ</label></td>
				<td>: <input type="text" autocomplete="off" name="sub_cat_name_short" id="sub_cat_name_short" class="txt_box s200 required"  maxlength="4"></td>
			</tr>
			<tr align="left" height="25px"><td></td><td > <font color="red"> * ชื่อย่อ * ใส่ได้ไม่เกิน 4 ตัวอักษร</font></td></tr>
			<tr align="center" height="10px"><td colspan="2"></td></tr>
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="บันทึก" class="btn_box btn_confirm">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="hidden" name="action" value="sub_cat_add">
					<input type="hidden" name="cat_id" value="<%=WebUtils.getReqString(request, "cat_id")%>">
					<input type="hidden" name="group_id" value="<%=WebUtils.getReqString(request, "group_id")%>">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
					<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
				</td>
			</tr>
		</tbody>
	</table>
	<div class="msg_error" id="vendor_msg_error"></div>
	</form>

</div>