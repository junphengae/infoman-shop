<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.parts.PartGroups"%>
<%@page import="com.bitmap.bean.parts.PartCategories"%>
<%@page import="com.bitmap.bean.parts.PartCategoriesSub"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

<script src="../js/validator.js"></script>

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Parts: </title>

<%
	PartMaster entity = new PartMaster(); 
	WebUtils.bindReqToEntity(entity, request);
	PartMaster.select(entity);
%>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>

<script type="text/javascript">
	$(function(){
		var $msg = $('.msg_error');
		var $form = $('#infoForm');
		
		$.metadata.setType("attr", "validate");
		var v = $form.validate({
			submitHandler: function(){
				var addData = $form.serialize() + '&action=edit';
				ajax_load();
				$.post('../PartManagement',addData,function(data){
					ajax_remove();
					if (data.status == 'success') {
						//$msg.text('Update Success.').fadeIn(500);
						var urlredirect = 'part_info.jsp?pn='+$('#pn').val();
						//setTimeout("window.location.href('"+urlredirect+"')",1500);
						window.location =  urlredirect;
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
		

		if($('#group_id').val() != "") {
			$('#edit_group').fadeIn(500).attr('lang','part_group_edit.jsp?height=180&width=440&group_id=' + $('#group_id').val());
			$('#new_cat').fadeIn(500).attr('lang','part_cat_new.jsp?height=180&width=440&group_id=' +$('#group_id').val());
		}
		else{
			$('#edit_group').hide();
			$('#new_cat').hide();
			$('#edit_cat').hide();
			$('#edit_sub_cat').hide();
			$('#new_sub_cat').hide();
		}
		if($('#cat_id').val() != ""){
			$('#new_sub_cat').fadeIn(500).attr('lang','part_sub_cat_new.jsp?height=180&width=440&cat_id=' +$('#cat_id').val() + '&group_id=' + $('#group_id').val());
			$('#edit_cat').fadeIn(500).attr('lang','part_cat_edit.jsp?height=180&width=440&cat_id=' +$('#cat_id').val() + '&group_id=' + $('#group_id').val());
			
		}else{
			$('#edit_cat').hide();
			$('#new_sub_cat').hide();
			$('#edit_sub_cat').hide();
		}
		if($('#sub_cat_id').val() != ""){
			$('#edit_sub_cat').fadeIn(500).attr('lang','part_sub_cat_edit.jsp?height=180&width=440&sub_cat_id=' + $('#sub_cat_id').val() + '&cat_id=' + $('#cat_id').val() + '&group_id=' + $('#group_id').val());
		}else{
			$('#edit_sub_cat').hide();
		}
		
		$('#group_id').change(function(){
			ajax_load();
			$.post('../PartManagement',{group_id: $('#group_id').val(),action:'get_cat_th'}, function(resData){
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
			
			if($('#group_id').val() != "") {
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
		});
		
		
		$('#cat_id').change(function(){
			ajax_load();
			$.post('../PartManagement',{group_id:$('#group_id').val(),cat_id: $(this).val(),action:'get_sub_cat_th'}, function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					var options = '<option value="">--- เลือกชนิดย่อย ---</option>';
	                var j = resData.sub_cat;
		            $.each(j , function (index , object){
	                	 options += '<option value="' + object.sub_cat_id + '">' + object.sub_cat_name_th + ' ' + object.sub_cat_name_short + '</option>';
	                });
	             	$('#sub_cat_id').html(options);
				} else {
					alert(resData.message);
				}
	        },'json');
			
			if($('#cat_id').val() != "") {
				$('#new_sub_cat').fadeIn(500).attr('lang','part_sub_cat_new.jsp?height=180&width=440&cat_id=' +$('#cat_id').val() + '&group_id=' + $('#group_id').val());
				$('#edit_cat').fadeIn(500).attr('lang','part_cat_edit.jsp?height=180&width=440&cat_id=' +$('#cat_id').val() + '&group_id=' + $('#group_id').val());
				$('#edit_sub_cat').hide();
			} else {
				$('#edit_cat').hide();
				$('#edit_sub_cat').hide();
				$('#new_sub_cat').hide();
			}
		});
		
		$('#sub_cat_id').change(function(){
			if($(this).val() != "") {
				$('#edit_sub_cat').fadeIn(500).attr('lang','part_sub_cat_edit.jsp?height=180&width=440&sub_cat_id=' + $('#sub_cat_id').val() + '&cat_id=' + $('#cat_id').val() + '&group_id=' + $('#group_id').val());
			} else {
				$('#edit_sub_cat').hide();
			}
		});
		
		
	});
	
	/*  onkeyUp  validate Number  */
	function validCurrencyOnKeyUp(thisObj, thisEvent) {
		  var temp = thisObj.value;
		  temp = currencyToNumber(temp); // convert to number
		  thisObj.value = formatCurrency(temp);// convert to currency forma
		
	}

	function validNumberOnKeyUp(thisObj, thisEvent) {
		  var temp = thisObj.value;
		  temp = currencyToNumber(temp); // convert to number
		  thisObj.value = formatIntegerWithComma(temp);// convert to currency format
	}
</script>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Parts Edit: </div>
				<div class="right">
					<button class="btn_box" type="button" onclick="history.back();">back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
	<form id="infoForm" style="margin: 0;padding: 0;" onsubmit="return false;">
	<table cellpadding="3" cellspacing="3" border="0" class="s_auto center">
		<tbody>
			<tr>
				<td width="23%"><Strong>Parts Number</Strong></td>
				<td>: <%=entity.getPn()%><input type="hidden" name="pn" id="pn" value="<%=entity.getPn()%>"></td>
			</tr>
			<tr height="20px">
								<td><Strong>Reference Number</Strong></td>
								<td>: 
									<input type="text" autocomplete="off" maxlength="20" name="reference" id="reference"  class="txt_box s200 required" title="**** Required!" value="<%=entity.getReference()%>"> 
								</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>			
			
			
			<tr>
				<td><Strong>กลุ่ม</Strong></td>
				<td align="left">: 
					<bmp:ComboBox name="group_id" styleClass="txt_box s200" width="200px" listData="<%=PartGroups.ddl_th()%>" validate="true" validateTxt=" *** Required!" value="<%=entity.getGroup_id()%>">
						<bmp:option value="" text="--- select ---"></bmp:option>
					</bmp:ComboBox>

				</td>
			</tr>			
			<tr>
				<td><Strong>ชนิด</Strong></td>
				<td align="left">: 
					<bmp:ComboBox name="cat_id" styleClass="txt_box s200" width="200px" listData="<%=PartCategories.ddl_th(entity.getGroup_id())%>" validate="true" validateTxt=" *** Required!" value="<%=entity.getCat_id()%>">
						<bmp:option value="" text="--- select ---"></bmp:option>
					</bmp:ComboBox>
				</td>
			</tr>	
			<tr>
				<td><Strong>ชนิดย่อย</Strong></td>
				<td align="left">: 
					<bmp:ComboBox name="sub_cat_id" styleClass="txt_box s200" width="200px" listData="<%=PartCategoriesSub.ddl_th(entity.getCat_id(), entity.getGroup_id())%>" validate="true" validateTxt=" *** Required!" value="<%=entity.getSub_cat_id()%>">
						<bmp:option value="" text="--- select ---"></bmp:option>
					</bmp:ComboBox>
					
				</td>
			</tr>
			<tr>
				<td><Strong>หน่วยกลาง<Strong></td>
					<td>: 
						<%if(!entity.getDes_unit().equalsIgnoreCase("")){ 
						%>
						<bmp:ComboBox name="des_unit" styleClass="txt_box s150" listData="<%=UnitType.unit_th()%>" validate="true" validateTxt="*"  value="<%=entity.getDes_unit()%>">
							<bmp:option value="" text="--- เลือกหน่วยนับ ---"></bmp:option>
						</bmp:ComboBox>
						<%}else{
						%>
							<bmp:ComboBox name="des_unit" styleClass="txt_box s150" listData="<%=UnitType.ddl_th()%>" validate="true" validateTxt="*">
								<bmp:option value="" text="--- เลือกหน่วยนับ ---"></bmp:option>
							</bmp:ComboBox>
						
						<%} %>
					</td>
				</tr>
			<tr><td colspan="2">&nbsp;</td></tr>			
			<tr>
				<td><Strong>Description</Strong></td>
				<td align="left">: <input type="text" autocomplete="off" name="description" id="description" class="s350 txt_box required" title=" *** Required!" value="<%=entity.getDescription()%>"></td>
			</tr>
			<tr>
				<td><Strong>Fit-To</Strong></td>
				<td align="left">: <input type="text" autocomplete="off" name="fit_to" id="fit_to" class="txt_box s200" value="<%=entity.getFit_to()%>"></td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>			

			<tr valign="top">
				<td><label title="Serial Number"><Strong>Store Type</Strong></label></td>
				<td align="left"><div class="left">:&nbsp;</div>
					<div id="sn_flag_wrap" class="left txt_left">
						<input type="radio" name="sn_flag" id="sn_flag_1" value="1" <%=entity.getSn_flag().equalsIgnoreCase("1")?"checked='checked'":"" %>><label for="sn_flag_1">  Serial Number</Strong><br>
						<input class="m_top5" type="radio" name="sn_flag" id="sn_flag_0" value="0" <%=entity.getSn_flag().equalsIgnoreCase("0")?"checked='checked'":"" %>><label for="sn_flag_0"> Non-Serial</Strong>
					</div>
					<div class="clear"></div>
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>			
			<tr>
				<td><Strong>Location</Strong></td>
				<td align="left">: <input type="text" autocomplete="off" name="location" id="location" class="txt_box s200" value="<%=entity.getLocation()%>"></td>
			</tr>
			<tr>
				<td><Strong>Weight</Strong></td>
				<td align="left">: <input type="text" autocomplete="off" name="weight" id="weight" class="txt_box s50" value="<%=entity.getWeight()%>"> Kg.</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td><Strong>Price</Strong></td>
				<td align="left">: 
					<input type="text" autocomplete="off" name="price" id="price" class="txt_box s80" value="<%=entity.getPrice()%>" onblur="$(this).val(addCommas($(this).val()));" onchange="return validCurrencyOnKeyUp(this, event)"> 
					<bmp:ComboBox name="price_unit" styleClass="txt_box s40" listData="<%=PartMaster.unitList()%>" value="<%=entity.getPrice_unit()%>"></bmp:ComboBox>
				</td>
			</tr>
			<tr>
				<td><Strong>Cost</Strong></td>
				<td align="left">: 
					<input type="text" autocomplete="off" name="cost" id="cost" class="txt_box s80" value="<%=entity.getCost()%>" onblur="$(this).val(addCommas($(this).val()));" onchange="return validCurrencyOnKeyUp(this, event)"> 
					<bmp:ComboBox name="cost_unit" styleClass="txt_box s40" listData="<%=PartMaster.unitList()%>" value="<%=entity.getCost_unit()%>"></bmp:ComboBox>
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td><Strong>Balance Qty</Strong></td>
				<td align="left">: <%=entity.getQty()%></td>
			</tr>
			<tr>
				<td><label title="Minimum Order Quantity"><Strong>MOQ</Strong></label></td>
				<td align="left">: <input type="text" autocomplete="off" name="moq" id="moq" class="txt_box s50 digits" value="<%=entity.getMoq()%>"></td>
			</tr>
			<tr>
				<td><label title="Minimum Order Replete"><Strong>MOR</Strong></label></td>
				<td align="left">: <input type="text" autocomplete="off" name="mor" id="mor" class="txt_box s50 required digits" title="Please insert MOR!" value="<%=entity.getMor()%>"></td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>				
			<tr align="center" valign="bottom" height="20">
				<td colspan="2">
					<input type="submit" id="btnUpdate" value="Update" class="btn_box ">
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
				<!-- 	<input type="button" value="close" onclick="tb_remove();" class="btn_box "> -->
				</td>
			</tr>
			<tr><td colspan="2" align="center">	<div class="msg_error"></div></td></tr>	
		</tbody>
	</table>

	</form>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>