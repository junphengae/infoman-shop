<%@page import="com.bitmap.utils.ReportUtils"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.PartGroups"%>
<%@page import="com.bitmap.bean.parts.PartCategories"%>
<%@page import="com.bitmap.bean.parts.PartCategoriesSub"%>
<%@page import="com.bitmap.bean.hr.Division"%>
<%@page import="com.bitmap.bean.hr.Position"%>
<%@page import="com.bitmap.bean.hr.Department"%>
<%@page import="com.bitmap.security.SecurityUser"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%> 
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
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
<script src="../js/number.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.position.js"></script>
<script src="../js/ui/jquery.ui.autocomplete.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Parts</title>

<script type="text/javascript">
$(function(){
	$('.btn_update_dc').click(function(){
		ajax_load();
		$.post('../CallWSSevrlet','action=updateDcToShop',function(response){
			ajax_remove();  
			if (response.status == 'success') {
				alert("อัพเดทข้อมูลจากสำนักงานใหญ่เรียบร้อบแล้ว");
			} else {
				alert(response.message);
			}
		},'json');
	});
	$('.btn_update_shop').click(function(){
		ajax_load();
		$.post('../CallWSSevrlet','action=updateShopToDc',function(response){	
			ajax_remove();  
			if (response.status == 'success') {
				alert("อัพเดทข้อมูลจากสาขาเรียบร้อบแล้ว");
			} else {
				alert(response.message);
			}
		},'json');
	});
	$('.btn_update_shop_popr').click(function(){
		ajax_load();
		$.post('../CallWSSevrlet','action=updateShopToDc_popr',function(response){	
			ajax_remove();  
			if (response.status == 'success') {
				alert("อัพเดทข้อมูลจากสาขาเรียบร้อบแล้ว");
			} else {
				alert(response.message);
			}
		},'json');
	});
	$('.btn_update_shop_bill').click(function(){
		ajax_load();
		$.post('../CallWSSevrlet','action=updateShopToDc_bill',function(response){	
			ajax_remove();  
			if (response.status == 'success') {
				alert("อัพเดทข้อมูลจากสาขาเรียบร้อบแล้ว");
			} else {
				alert(response.message);
			}
		},'json');
	});
	$('.btn_update_shop_branch').click(function(){
		ajax_load();
		$.post('../CallWSSevrlet','action=updateBranchMaster',function(response){	
			ajax_remove();  
			if (response.status == 'success') {
				alert("อัพเดทข้อมูลจากสาขาเรียบร้อบแล้ว");
			} else {
				alert(response.message);
			}
		},'json');
	});
	
	
	$('.btn_update_discount').click(function(){
		var name_table = $(this).attr('name_table');
		var start = $('.'+$(this).attr('start')).val();
		var end = $('.'+$(this).attr('end')).val();
		
		if( start == '' && end == '' ){
			alert("กรุณากรอก ID");
			$('.'+$(this).attr('start')).focus();
			return false;
		}else if( start == '' && end != '' ){
			start = end;
			$('.'+$(this).attr('start')).val(end);
		}else if( start != '' && end == '' ){
			end = start;
			$('.'+$(this).attr('end')).val(start);
		}
		
		ajax_load();
		$.post('../PartSaleManage','action=update_discount&name_table='+name_table+'&start='+start+'&end='+end,function(res){
			ajax_remove();
			if( res.status == 'success' ){
				alert("อัพเดตข้อมูล  Discount ของ Table "+name_table+" เรียบร้อยแล้ว");
			}else{
				alert(res.message);
			}
		},'json');
	});
	$('input:radio[name="table"]').click(function(){
		$('.table_name').hide();
		$('.'+$(this).val()).show();
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
				<div class="left">ทดสอบเว็บเซอร์วิส</div>
					<div class="right">
					 	
					</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<table width="100%">
						<tr>
							<th align="center" width="100%">
							อัพเดทข้อมูลจากสำนักงานใหญ่ให้กับสาขา
							</th>
						</tr>
						<tr>
							<td>
							<br />
							</td>
						</tr>
						<tr>
							<td  align="center">
							<button class="btn_box btn_update_dc">UPDATE DATA DC TO SHOP</button>
							<br /><br />
							</td>
						</tr>
						<tr>
							<td  align="center">
								<input type="radio" name="table" value="service_other_detail"> service_other_detail
								<br /><br />
								<div class="table_name service_other_detail">
									<label>ID : </label><input type="text" name="start_other" class="txt_box s50 start_other txt_center">&nbsp;
									<label> ถึง </label>&nbsp;<input type="text" name="end_other" class="txt_box s50 end_other txt_center">&nbsp;&nbsp;&nbsp;
									<button class="btn_box btn_update_discount" name_table="service_other_detail" start="start_other" end="end_other" >UPDATE DISCOUNT OTHER DETAIL</button>
									<br /><br />
								</div>
							</td>
						</tr>
						<tr>
							<td  align="center">
								<input type="radio" name="table" value="service_part_detail"> service_part_detail
								<br /><br />
								<div class="table_name service_part_detail">
									<label>ID : </label><input type="text" name="start_part" class="txt_box s50 start_part txt_center">&nbsp;
									<label> ถึง </label>&nbsp;<input type="text" name="end_part" class="txt_box s50 end_part txt_center">&nbsp;&nbsp;&nbsp;
									<button class="btn_box btn_update_discount" name_table="service_part_detail" start="start_part" end="end_part">UPDATE DISCOUNT PART DETAIL</button>
									<br /><br />
								</div>
							</td>
						</tr>
						<tr>
							<td  align="center">
								<input type="radio" name="table" value="service_repair_detail"> service_repair_detail
								<br /><br />
								<div class="table_name service_repair_detail">
									<label>ID : </label><input type="text" name="start_repair" class="txt_box s50 start_repair txt_center">&nbsp;
									<label> ถึง </label>&nbsp;<input type="text" name="end_repair" class="txt_box s50 end_repair txt_center">&nbsp;&nbsp;&nbsp;
									<button class="btn_box btn_update_discount" name_table="service_repair_detail" start="start_repair" end="end_repair">UPDATE DISCOUNT REPAIR DETAIL</button>
									<br /><br />
								</div>
							</td>
						</tr>
						 <tr>
							<th align="center" width="100%">
							อัพเดทข้อมูลจากสาขาให้กับสำนักงานใหญ่
							</th>
						</tr>
						<tr>
							<td>
							<br />
							</td>
						</tr>
						<tr>
							<td  align="center">
							<button class="btn_box btn_update_shop">UPDATE DATA SHOP TO DC</button>
							<br /><br />
							</td>
						</tr> 
						
						<tr>
							<td  align="center">
							<button class="btn_box btn_update_shop_popr">UPDATE DATA SHOP TO DC POPR</button>
							<br /><br />
							</td>
						</tr> 
						<tr>
							<td  align="center">
							<button class="btn_box btn_update_shop_bill">UPDATE DATA SHOP TO DC Bill</button>
							<br /><br />
							</td>
						</tr> 
						<tr>
							<td  align="center">
							<button class="btn_box btn_update_shop_branch">UPDATE DATA Branch</button>
							<br /><br />
							</td>
						</tr> 
				</table>
				 
				
				
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>