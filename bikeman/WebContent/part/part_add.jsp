<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.parts.PartGroups"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"z
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
				var addData = $form.serialize() + '&action=add';
				ajax_load();
				$.post('../PartManagement',addData,function(data){
					ajax_remove();
					if (data.status == 'success') {
						$msg.text('Success').show();
						setTimeout('window.location="part_info.jsp?pn=' + data.pn + '"',1500);
					} else {
						alert(data.message);
						$('#' + data.focus).focus();
					}
				},'json');
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
				<div class="left">Parts: </div>
				<div class="right">
					<button class="btn_box" type="button" onclick="history.back();">back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<form id="infoForm" action="" method="post" style="margin: 0;padding: 0;">
					<table cellpadding="3" cellspacing="3" border="0" class="s_auto center">
						<tbody>
							<tr height="20px">
								<td width="20%" valign="top"><Strong>Type of Part Number</Strong></td>
								<td width="80%" valign="top">:  
									<input type="radio" name="gen_pn_type" id="gen_custom" value="<%=PartMaster.PN_TYPE_CUSTOM%>" checked="checked"> <label for="gen_custom">Custom</Strong> &nbsp;&nbsp;
									<br/>
									&nbsp;&nbsp;<input type="radio" name="gen_pn_type" id="gen_snc" value="<%=PartMaster.PN_TYPE_SNC%>"> <label for="gen_snc">Auto SNC Number</Strong> 
									<br/>
									&nbsp;&nbsp;<input type="radio" name="gen_pn_type" id="gen_use" value="<%=PartMaster.PN_TYPE_USE%>"> <label for="gen_use">Auto USE Number</Strong>
									<script type="text/javascript">
									$(function(){
										var pn = $('#pn');
										$('#gen_custom').click(function(){
											pn.val('').addClass('required').show().focus();
										});
										$('#gen_snc').click(function(){
											pn.val('').removeClass('required').hide();
										});
										$('#gen_use').click(function(){
											pn.val('').removeClass('required').hide();
										});
									});
									</script>
								</td>
							</tr>
							<tr height="20px">
								<td><Strong>Part Number</Strong></td>
								<td>: 
									<input type="text" autocomplete="off" name="pn" id="pn" value="<%=pn%>" class="txt_box s200 required" title="**** Required!"> 
								</td>
							</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr height="30px">
								<td><Strong>กลุ่ม</Strong></td>
								<td align="left">: 
									<snc:ComboBox name="group_id" styleClass="txt_box s200" width="200px" listData="<%=PartGroups.ddl_en()%>" validate="true" validateTxt="***** Required!">
										<snc:option value="" text="--- เลือกกลุ่ม ---"></snc:option>
									</snc:ComboBox>
									&nbsp;&nbsp;&nbsp;
									<input type="button" class="btn_box thickbox" id="new_group" value="เพิ่มกลุ่ม" lang="part_group_new.jsp?height=180&width=440" title="เพิ่มกลุ่ม">
									&nbsp;&nbsp;&nbsp;
									<input type="button" class="btn_box thickbox hide" id="edit_group" value="แก้ไขกลุ่ม" lang="" title="แก้ไขกลุ่ม">
									
								</td>
							</tr>
							
							<tr height="30px">
								<td><Strong>ชนิด</Strong></td>
								<td >: 
									<bmp:ComboBox name="cat_id" styleClass="txt_box s200" validate="true" validateTxt="*">
										<bmp:option value="" text="--- เลือกชนิด ---"></bmp:option>
									</bmp:ComboBox>
									&nbsp;&nbsp;&nbsp;
									<input type="button" class="btn_box thickbox hide" id="new_cat" value="เพิ่มชนิด" lang="" title="เพิ่มชนิด">
									&nbsp;&nbsp;&nbsp;
									<input type="button" class="btn_box thickbox hide" id="edit_cat" value="แก้ไขชนิด" lang="" title="แก้ไขชนิด">
								</td>
							</tr>
							<tr height="30px" >
								<td><Strong>ชนิดย่อย</Strong></td>
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
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr height="20px">
								<td><Strong>Description</Strong></td>
								<td align="left">: <input type="text" autocomplete="off" name="description" id="description" class="s350 txt_box  required" title="***** Required!"></td>
							</tr>
							<tr height="20px">
								<td><Strong>Fit-To</Strong></td>
								<td align="left">: <input type="text" autocomplete="off" name="fit_to" id="fit_to" class="txt_box s200"></td>
							</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr valign="top" >
								<td><label title="Serial Number"><Strong>Store type</Strong></label></td>
								<td align="left"><div class="left">:&nbsp;</div>
									<div id="sn_flag_wrap" class="left txt_left">
										<input type="radio" name="sn_flag" id="sn_flag_1" value="1" checked="checked"><label for="sn_flag_1"> Serial Number</Strong><br>
										<input class="m_top5" type="radio" name="sn_flag" id="sn_flag_0" value="0"><label for="sn_flag_0"> Non-Serial</Strong>
									</div>
									<div class="clear"></div>
								</td>
							</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr height="20px">
								<td><Strong>Location</Strong></td>
								<td align="left">: <input type="text" autocomplete="off" name="location" id="location" class="txt_box s200"></td>
							</tr>
							<tr height="20px">
								<td><Strong>Weight</Strong></td>
								<td align="left">: <input type="text" autocomplete="off" name="weight" id="weight" class="txt_box s50"> Kg.</td>
							</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr height="20px">
								<td><Strong>Price</Strong></td>
								<td align="left">: 
									<input type="text" autocomplete="off" name="price" id="price" class="s80 txt_box " onblur="$(this).val(addCommas($(this).val()));"> 
									<snc:ComboBox name="price_unit" styleClass="txt_box s50" listData="<%=PartMaster.unitList()%>"></snc:ComboBox>
								</td>
							</tr>
							<tr height="20px">
								<td><Strong>Cost</Strong></td>
								<td align="left">: 
									<input type="text" autocomplete="off" name="cost" id="cost" class="s80 txt_box" onblur="$(this).val(addCommas($(this).val()));"> 
									<snc:ComboBox name="cost_unit" styleClass="txt_box s50" listData="<%=PartMaster.unitList()%>"></snc:ComboBox>
								</td>
							</tr>
							<tr ><td colspan="2">&nbsp;</td></tr>
							<tr height="20px">
								<td><label title="Minimum Order Quantity"><Strong>MOQ</Strong></td>
								<td align="left">: <input type="text" autocomplete="off" name="moq" id="moq" class="txt_box s50 digits" value="0"></td>
							</tr>
							<tr height="20px">
								<td><label title="Minimum Order Replete"><Strong>MOR</Strong></label></td>
								<td align="left">: <input type="text" autocomplete="off" name="mor" id="mor" class="txt_box s50 required digits" title="Please insert MOR!" value="0"></td>
							</tr>
							<tr align="center" valign="bottom" height="20">
								<td colspan="2">
									<input type="submit" id="btnAdd" value="Create" class="s70 btn_box ">
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
									<input type="reset" value="Reset" class="s70 btn_box " onclick="$('#edit_vendor').hide();">
								</td>
							</tr>
						</tbody>
					</table>
					<div class="msg_error"></div>
					</form>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>