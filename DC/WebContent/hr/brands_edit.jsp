<%@page import="com.bitmap.ajax.PartPicture"%>
<%@page import="com.bitmap.utils.SNCUtils"%>
<%@page import="com.bitmap.bean.sale.*"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery-1.4.2.min.js" type="text/javascript"></script>
<script src="../js/ajaxfileupload.js" type="text/javascript"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.webcam.js"></script>
<script src="../js/jquery.validate.min.js"></script>
<script src="../js/jquery.metadata.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Brands: upload</title>
<%
	Brands entity = new Brands();
WebUtils.bindReqToEntity(entity, request);
Brands.select(entity);
%>

<script type="text/javascript">

function ajaxImgUpload(){
	$up = $('#fileToUpload');
	var order_by_id = '<%=entity.getOrder_by_id()%>';
	
	
	if ($up.val() == '') {
		alert('Please select image!');
		$up.focus();
	} else {
		$("#loadingImg")
		.ajaxStart(function(){
			$(this).show();
			$showImg.hide();
		})
		.ajaxComplete(function(){
			$(this).hide();
			$showImg.show();
		});
		
		$.ajaxFileUpload({
			url:'../PhotoBrands', 
			secureuri:false,
			fileElementId:'fileToUpload',
			param: 'order_by_id:' + order_by_id,
			dataType: 'json',
			success: function (data, status){
				
				//alert("อัพโหลดเรียบร้อยแล้ว");
				window.location.reload();
			},
			error: function (){
				//alert("no");
				window.location.reload();
			}
		});
	}
	return false;
}

	$(function(){
		var $msg = $('#vendor_msg_error');
		var $form = $('#groupForm');

		var v = $form.validate({
			submitHandler: function(){
				ajax_load();
				$.post('../BrandsManagement',$form.serialize(),function(json){
					ajax_remove();
					if (json.status == 'success') {
						
						if (json.check == 'IdName') {
							
							alert("รหัสยี่หัอและชื่อยี่ห้อ ซ้ำ !");
						}
						if (json.check == 'Id') {
							alert("รหัสยี่ห้อ ซ้ำ !");
						}
						if (json.check == 'Name') {
							alert("ชื่อยี่ห้อ ซ้ำ !");
						}
						if (json.check == 'success') {
							
							alert("แก้ไขเรียบร้อยแล้ว");
							window.location="brands_manage.jsp";
						}
						
					} else {
						alert(json.message);
					}
				},'json');
			}
		});
		
		$form.submit(function(){
			v;
			return false;
		});
	});
	
	
	
	$(function(){
		$('#upImg').click(function(){
			if ($('#upImg').is(':checked')) {
				$('#uploadImg').fadeIn(500);
				$('#webcam').hide();
			}
		});
		
		$('#camImg').click(function(){
			if ($('#camImg').is(':checked')) {
				$('#uploadImg').hide();
				$('#webcam').fadeIn(500);
			}
		});
		
		if ($('#upImg').is(':checked')) {
			$('#uploadImg').show();
			$('#webcam').hide();
		}
		
		if ($('#camImg').is(':checked')) {
			$('#uploadImg').hide();
			$('#webcam').show();
		}
		
	});


</script>



</head>
<body>
<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Brands: </div>
				<div class="right">
					<button class="btn_box" type="button" onclick="history.back();">back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
			<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="420px">
				<tbody>
					<tr align="center" height="25"><td colspan="2"><h3>Update Brand Information</h3></td></tr>
					<tr align="center" height="10px"><td colspan="2"></td></tr>
				</tbody>
			</table>

			<div id="div_img" class="center txt_center min_h240">
						<div class="min_h240 center txt_center" style="width: 320px; box-shadow: 0 0px 3px rgba(0,0,0,0.3);" id="testimg">
							<img width="320" height="240" src="../PartPicture?order_by_id=<%=entity.getOrder_by_id()%>">
						</div>
						
						<div class="m_top10">
						</div> 
					</div>
					
					 <div id="uploadImg" class="txt_center center"> 
						<form enctype="multipart/form-data" method="post" action="" name="imgForm" style="margin: 0px; padding: 0px;">
							<input type="file" id="fileToUpload" name="fileToUpload" readonly="readonly" class="txt_box" onchange="return ajaxImgUpload();">
						</form>
					 </div> 
				<div class="clear"></div>
					<form id="groupForm" action="" method="post" style="margin: 0;padding: 0;">
					<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="420px">
					<tbody>
					<tr align="center" height="25"><td colspan="2"><h3></h3></td></tr>
					<tr align="center" height="10px"><td colspan="2"></td></tr>
					<tr align="center" height="10px"><td colspan="2"></td></tr>
					<tr>
						<td><label><Strong>Brand Name</Strong></label></td>
						<td>: <input type="text" autocomplete="off" name="brand_name" id="brand_name" class="txt_box s200 required" title="Please insert Brand Name." value="<%=entity.getBrand_name()%>" ></td>
					</tr>
					<%-- <tr>
						<td align="left" width="20%"><label><Strong>Brand Code</Strong></label></td>
						<td align="left" width="80%">: <input type="text" autocomplete="off" name="brand_id" id="brand_id" class="txt_box s40 required input_focus" title="Please insert Brand Code." value="<%=entity.getBrand_id()%>" maxlength="6"></td>
					</tr> --%>
					<tr align="center" height="10px"><td colspan="2"></td></tr>
					<tr align="center" valign="bottom" height="30">
						<td colspan="2">
							<input type="submit" id="btnAdd" value="Update" class="btn_box btn_confirm">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="hidden" name="action" value="edit_Brands">
							<input type="reset" onclick="history.back();" value="Cancel" class="btn_box">
							<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
							<input type="hidden" name="order_by_id" value="<%=entity.getOrder_by_id() %>"> 
						</td>
					</tr>
					</tbody>
					</table>
					<div class="msg_error" id="vendor_msg_error"></div>
					</form>
				</div>
				</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
						
</div>
			
</body>
</html>