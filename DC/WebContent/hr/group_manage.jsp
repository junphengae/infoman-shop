<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.parts.PartGroups"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/clear_form.js"></script>

<script src="../js/jquery.validate.min.js"></script>
<script src="../js/jquery.metadata.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Parts: </title>
<%String pn = WebUtils.getReqString(request, "pn");%>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="snc" %>
<script type="text/javascript">
	$(function(){
		var $msg = $('.msg_error');
		var $form = $('#infoForm');
		
		
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
		$('#code_manual').click(function(){
			check_manual();
		});
		
		
		
		$.metadata.setType("attr", "validate");
		var v = $form.validate({
			submitHandler: function(){
				
				window.location="group_manage.jsp";
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

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Create Group: </div>
				<div class="right">
					<button class="btn_box" type="button" onclick="history.back();">back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<form id="infoForm" action="" method="post" style="margin: 0;padding: 0;">
					<table cellpadding="3" cellspacing="3" border="0" class="s_auto center">
						<tbody>
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr height="30px">
								<td width="200px"><Strong>กลุ่มข้อมูล</Strong></td>
								<td align="left">: 
								    
									<snc:ComboBox name="group_id" styleClass="txt_box s200" width="200px" listData="<%=PartGroups.ddl_en_th()%>" validate="true" validateTxt="***** Required!">
										<snc:option value="" text="--- เลือกกลุ่ม ---"></snc:option>
									</snc:ComboBox>
									&nbsp;&nbsp;&nbsp;
									<input type="button" class="btn_box thickbox" id="new_group" value="เพิ่มกลุ่ม" lang="part_group_new.jsp?height=180&width=440" title="เพิ่มกลุ่ม">
									&nbsp;&nbsp;&nbsp;
									<input type="button" class="btn_box thickbox hide" id="edit_group" value="แก้ไขกลุ่ม" lang="" title="แก้ไขกลุ่ม">
									
								</td>
							</tr>
							
							<tr height="30px">
								<td><Strong>ชนิดของกลุ่มข้อมูล</Strong></td>
								<td >: 
									<bmp:ComboBox name="cat_id" styleClass="txt_box s200" >
										<bmp:option value="" text="--- เลือกชนิด ---"></bmp:option>
									</bmp:ComboBox>
									&nbsp;&nbsp;&nbsp;
									<input type="button" class="btn_box thickbox hide" id="new_cat" value="เพิ่มชนิด" lang="" title="เพิ่มชนิด">
									&nbsp;&nbsp;&nbsp;
									<input type="button" class="btn_box thickbox hide" id="edit_cat" value="แก้ไขชนิด" lang="" title="แก้ไขชนิด">
								</td>
							</tr>
							<tr height="30px" >
								<td><Strong>ชนิดย่อยของกลุ่มข้อมูล</Strong></td>
								<td >: 
									<bmp:ComboBox name="sub_cat_id" styleClass="txt_box s200">
										<bmp:option value="" text="--- เลือกชนิดย่อย ---"></bmp:option>
									</bmp:ComboBox>
									&nbsp;&nbsp;&nbsp;
									<input type="button" class="btn_box thickbox hide" id="new_sub_cat" value="เพิ่มชนิดย่อย" lang="" title="เพิ่มชนิด">
									&nbsp;&nbsp;&nbsp;
									<input type="button" class="btn_box thickbox hide" id="edit_sub_cat" value="แก้ไขชนิดย่อย" lang="" title="แก้ไขชนิดย่อย">
									
								</td>
							</tr>
							<tr align="center" valign="bottom" height="20">
								<td colspan="2">
								
									<%-- <input type="submit" id="btnAdd" value="Create" class="s70 btn_box ">
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
									<input type="reset" value="Reset" class="s70 btn_box " onclick="$('#edit_vendor').hide();"> --%>
								</td>
							</tr>
						</tbody>
					</table>
					<div class="msg_error"></div>
					</form>
			</div>
		</div>
	</div> 
	<div> <p Style="color: black;"> <strong>หมายเหตุ  :</strong> ข้อมูลถูกเพิ่มเมื่อท่านทำการเพิ่มข้อมูลแล้วกดบันทึกข้อมูล  </p></div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>