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
<title>Brands: </title>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="snc" %>
<script type="text/javascript">
$(function(){
	var $msg = $('#vendor_msg_error');
	var $form = $('#groupForm');

	var v = $form.validate({
		submitHandler: function(){
			ajax_load();
			$.post('../BrandsManagement',$form.serialize(),function(json){
				ajax_remove();
				if (json.status == 'success') {
				
					alert("แก้ไขเรียบร้อยแล้ว");
					window.location.reload();
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
		var $msg = $('#msg_error');
		var $form = $('#infoForm');

		var v = $form.validate({
			submitHandler: function(){
				ajax_load();
				$.post('../BrandsManagement',$form.serialize(),function(json){
					ajax_remove();
					if (json.status == 'success') {
						
						if (json.check == 'IdName') {
							
							alert("รหัสยี่ห้อและชื่อยี่ห้อซ้ำ !");
						}
						if (json.check == 'Id') {
							alert("รหัสยี่ห้อ ซ้ำ !");
						}
						if (json.check == 'Name') {
							alert("ชื่อยี่ห้อ ซ้ำ !");
						}
						if (json.check == 'success') {
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
</script>
</head>
<body>
<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Create Brands: </div>
				<div class="right">
					<button class="btn_box" type="button" onclick="history.back();">back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<form id="infoForm" name="infoForm" action="" method="post" style="margin: 0;padding: 0;">
					<table cellpadding="3" cellspacing="3" border="0" class="center s400">
						<tbody>
						<tr height="30px">
							<td  width="30%"><Strong>Brand Name</Strong></td>
							<td align="left">: 
							<input type="text" autocomplete="off" name="brand_name" id="brand_name"  class="txt_box s150 required" title="Please insert Brand Name."> 
							</td>	
						</tr>	
						<!-- <tr height="30px">
							<td width="30%"><Strong>Brand Code</Strong></td>
							<td align="left">: 
							<input type="text"  maxlength="6" autocomplete="off" name="brand_id" id="brand_id"  class="txt_box s100 required" title="Please insert Brand Code."> 
							</td>
						</tr> -->
						<tr> 
						 	<td colspan="2" height="10px">  </td> 
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
					<input type="hidden" name="action" value="add_brands">

					</form>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
</body>
</html>