<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/number.js"></script>

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รับคืนวัตถุดิบ</title>
<%
	String mat_code = WebUtils.getReqString(request, "mat_code");
	String lot_no = WebUtils.getReqString(request, "lot_no");
%>
<script type="text/javascript">
$(function(){
	check_material();
	
	$('#mat_code').keypress(function(e){
		if (e.keyCode == 13) {
			check_material();
		}
	});
});

function check_material(){
	
	$('.btn_check').click(function(){
		if ($('#mat_code').val() == '') {
			alert("กรุณาใส่รหัสวัตดิบ!");
			$('#mat_code').focus();
		}else if($('#lot_no').val() == ''){
			alert("กรุณาใส่หมายเลข Lot!");
			$('#lot_no').focus();
		}else if($('#qty').val() == ''){
			alert("กรุณาใส่จำนวน!");
			$('#qty').focus();
		} else if(!isNumber($('#qty').val())){
			alert("กรุณาใส่จำนวนเป็นตัวเลข!");
			$('#qty').focus();
		} else {
			ajax_load();
			var data = {'action':'check_code_lotno',
						'mat_code':$('#mat_code').val(),
						'lot_no':$('#lot_no').val(),
						'qty':$('#qty').val()};
			$.post('OutletManagement',data,function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					alert('รับคืนวัตถุดิบเรียบร้อยแล้ว');
					window.location='receive_store.jsp';	
				}else{
						alert(resData.message);
					}
			},'json');
		}
	});
}
</script>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">
					1: รับคืนวัตถุดิบ
				</div>
				<div class="right m_right20"></div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				
				<table width="100%" id="tb_check_mat">
					<tbody>
						<tr>
							<td width="25%">รหัสวัตถุดิบ</td>
							<td width="75%">: 
								<input type="text" autocomplete="off" name="mat_code" id="mat_code" class="txt_box s150">
							</td>
						</tr>
						<tr>
							<td width="25%">Lot_no</td>
							<td width="75%">: 
								<input type="text" autocomplete="off" name="lot_no" id="lot_no" class="txt_box s150">

							</td>
						</tr>
						<tr>
							<td width="25%">จำนวน</td>
							<td width="75%">: 
								<input type="text" autocomplete="off" name="qty" id="qty" class="txt_box s150">

							</td>
						</tr>
					</tbody>
				</table>
				
			<div class="txt_center">
				<button class="btn_box btn_check">คืนวัตถุดิบ</button>
			</div>	
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>

</body>
</html>