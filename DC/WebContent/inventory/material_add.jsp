<%@page import="com.bitmap.bean.inventory.InventoryMasterTemp"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.min.js"></script>
<script src="../js/number.js"></script>

<!-- Date -->
<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>


<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>สร้างข้อมูลสินค้า</title>
<script type="text/javascript">
$(function(){

	$('#group_id').change(function(){
		ajax_load();
		$.post('../MaterialManage',{group_id: $(this).val(),action:'get_cat_th'}, function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				var options = '<option value="">--- เลือกชนิด ---</option>';
                var j = resData.cat;
	            for (var i = 0; i < j.length; i++) {
	                options += '<option value="' + j[i].cat_id + '">' + j[i].cat_name_th + ' ' + j[i].cat_name_short + '</option>';
	            }
             	$('#cat_id').html(options);
             	$('#sub_cat_id').html('<option value="">--- เลือกชนิดย่อย ---</option>');
			} else {
				alert(resData.message);
			}
        },'json');
		
		if($(this).val() != "") {
			$('#edit_group').fadeIn(500).attr('lang','group_edit.jsp?height=300&width=520&group_id=' + $(this).val());
			$('#new_cat').fadeIn(500).attr('lang','cat_new.jsp?height=300&width=520&group_id=' + $(this).val());
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
		$.post('../MaterialManage',{group_id: $('#group_id').val(),action:'get_cat_th'}, function(resData){
			if (resData.status == 'success') {
				var options = '<option value="">--- เลือกชนิด ---</option>';
                var j = resData.cat;
	            for (var i = 0; i < j.length; i++) {
	                options += '<option value="' + j[i].cat_id + '">' + j[i].cat_name_th + ' ' + j[i].cat_name_short + '</option>';
	            }
             	$('#cat_id').html(options);
             	$('#sub_cat_id').html('<option value="">--- เลือกชนิดย่อย ---</option>');
			} else {
				alert(resData.message);
			}
        },'json');
		$('#edit_group').fadeIn(500).attr('lang','group_edit.jsp?height=300&width=520&group_id=' + $('#group_id').val());
		$('#new_cat').fadeIn(500).attr('lang','cat_new.jsp?height=300&width=520&group_id=' +$('#group_id').val());
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
		$.post('../MaterialManage',{group_id:$('#group_id').val(),cat_id: $(this).val(),action:'get_sub_cat_th'}, function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				var options = '<option value="">--- เลือกชนิดย่อย ---</option>';
                var j = resData.sub_cat;
	            for (var i = 0; i < j.length; i++) {
	                options += '<option value="' + j[i].sub_cat_id + '">' + j[i].sub_cat_name_th + ' ' + j[i].sub_cat_name_short + '</option>';
	            }
             	$('#sub_cat_id').html(options);
			} else {
				alert(resData.message);
			}
        },'json');
		
		if($(this).val() != "") {
			$('#new_sub_cat').fadeIn(500).attr('lang','sub_cat_new.jsp?height=300&width=520&cat_id=' + $(this).val() + '&group_id=' + $('#group_id').val());
			$('#edit_cat').fadeIn(500).attr('lang','cat_edit.jsp?height=300&width=520&cat_id=' + $(this).val() + '&group_id=' + $('#group_id').val());
			$('#edit_sub_cat').hide();
		} else {
			$('#edit_cat').hide();
			$('#edit_sub_cat').hide();
			$('#new_sub_cat').hide();
		}
	});
	
	$('#sub_cat_id').change(function(){
		if($(this).val() != "") {
			$('#edit_sub_cat').fadeIn(500).attr('lang','sub_cat_edit.jsp?height=300&width=520&sub_cat_id=' + $(this).val() + '&cat_id=' + $('#cat_id').val() + '&group_id=' + $('#group_id').val());
		} else {
			$('#edit_sub_cat').hide();
		}
	});
	$('#code_manual').click(function(){
		check_manual();
	});
	
	check_manual();
	function check_manual(){
		if ($('#code_manual').attr('checked')) {
			$('#mat_code').show().addClass('required');
		} else {
			$('#mat_code').hide().removeClass('required');
		}
	}
	
	$('#code_auto').click(function(){
		check_auto();
	});
	
	check_auto();
	function check_auto(){
		if ($('#code_auto').attr('checked')) {
			$('#mat_code').hide().removeClass('required');
		} else {
			$('#mat_code').show().addClass('required');
		}
	}
	
	var form = $('#material_form');
	$.metadata.setType("attr", "validate");
	var v = form.validate({
		submitHandler: function(){
			ajax_load();
			$.post('../MaterialManage',form.serialize(),function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					if(resData.mat.serial == 'y'){
						if (confirm('ต้องการเพิ่มรายการส่วนประกอบตอนนี้เลยหรือไม่?')) {
							window.location='temp_view.jsp?mat_code=' + resData.mat.mat_code;
						}
					}
					if (confirm('ต้องการเพิ่มข้อมูลตัวแทนจำหน่ายตอนนี้เลยหรือไม่?')) {
						window.location='material_add_vendor.jsp?mat_code=' + resData.mat.mat_code;
					} else {
						window.location='inv_list.jsp';
					}
				} else {
					if (resData.message.indexOf('Duplicate entry') > 0) {
						alert('!! ไม่สามารถบันทึก เนื่องจากมีรหัสสินค้า ' + $('#mat_code').val() + ' ซ้ำในระบบ กรุณาตรวจสอบ !!');
					} else {
						alert(resData.message);
					}
				}
			},'json');
		}
	});
	
	form.submit(function(){
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
				<div class="left">1: สร้างข้อมูลสินค้า</div>
				<div class="right">
					<button class="btn_box" onclick="window.location='<%=LinkControl.link("inv_list.jsp", (List)session.getAttribute("INVT_SEARCH"))%>';">ย้อนกลับ</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				
				<form id="material_form" onsubmit="return false">
					<fieldset class="fset s600 left min_h100">
						<legend>หมวดหมู่สินค้า</legend>
						<table width="100%">
							<tr>
								<td width="150">กลุ่ม</td>
								<td width="450">: 
									<bmp:ComboBox name="group_id" styleClass="txt_box s150" listData="<%=Group.ddl_th()%>" validate="true" validateTxt="*">
										<bmp:option value="" text="--- เลือกกลุ่ม ---"></bmp:option>
									</bmp:ComboBox>
									<input type="button" class="btn_box thickbox" id="new_group" value="เพิ่มกลุ่ม" lang="group_new.jsp?height=180&width=440" title="เพิ่มกลุ่ม">
									<input type="button" class="btn_box thickbox hide" id="edit_group" value="แก้ไขกลุ่ม" lang="" title="แก้ไขกลุ่ม">
								</td>
							</tr>
							<tr>
								<td>ชนิด</td>
								<td>: 
									<bmp:ComboBox name="cat_id" styleClass="txt_box s150" validate="true" validateTxt="*">
										<bmp:option value="" text="--- เลือกชนิด ---"></bmp:option>
									</bmp:ComboBox>
									<input type="button" class="btn_box thickbox hide" id="new_cat" value="เพิ่มชนิด" lang="" title="เพิ่มชนิด">
									<input type="button" class="btn_box thickbox hide" id="edit_cat" value="แก้ไขชนิด" lang="" title="แก้ไขชนิด">
								</td>
							</tr>
							<tr>
								<td>ชนิดย่อย</td>
								<td>: 
									<bmp:ComboBox name="sub_cat_id" styleClass="txt_box s150">
										<bmp:option value="" text="--- เลือกชนิดย่อย ---"></bmp:option>
									</bmp:ComboBox>
									<input type="button" class="btn_box thickbox hide" id="new_sub_cat" value="เพิ่มชนิดย่อย" lang="" title="เพิ่มชนิด">
									<input type="button" class="btn_box thickbox hide" id="edit_sub_cat" value="แก้ไขชนิดย่อย" lang="" title="แก้ไขชนิดย่อย">
									<script type="text/javascript">
										
									</script>
								</td>
							</tr>
							
						</table>
					</fieldset>
					
					<fieldset class="fset s300 right min_h100">
						<legend>ต้นทุนสินค้า</legend>
						<table width="100%">
							<tr>
								<td width="100">ต้นทุน</td>
								<td width="200">: <input type="text" autocomplete="off" name="cost" class="txt_box s100"></td>
							</tr>
							<tr>
								<td>ราคากลาง</td>
								<td>: <input type="text" autocomplete="off" name="price" class="txt_box s100" title="ระบุราคากลาง(เป็นตัวเลขเท่านั้น)!"></td>
							</tr>
						</table>
					</fieldset>
					
					<div class="clear"></div>
					
					<fieldset class="fset">
						<legend>รายละเอียดสินค้า</legend>
						<table width="100%">
							<tr>
								<td width="200">รูปแบบสินค้า</td>
								<td width="734">: 
									<label><input type="radio" name="serial" class="txt_box" value="y" checked="checked">  มี serial</label> &nbsp;&nbsp;
									<label><input type="radio" name="serial" class="txt_box" value="n">  ไม่มี serial</label>  &nbsp;&nbsp;
								</td>
							</tr>
							<tr>
								<td width="200">รหัสสินค้า</td>
								<td width="734">: 
									<label><input type="radio" name="action" id="code_auto" class="txt_box" value="add_material" validate="required:true" title="*" checked="checked"> สร้างรหัสอัตโนมัติ</label> &nbsp;&nbsp;
									<label><input type="radio" name="action" id="code_manual" class="txt_box" value="add_material_with_matcode" validate="required:true" title="*"> กำหนดรหัสเอง</label>  &nbsp;&nbsp;
									<input type="text" class="txt_box hide" name="mat_code" id="mat_code" value="" title="*">
								</td>
							</tr>
							<tr>
								<td>ชื่อสินค้า</td>
								<td>: <input type="text" autocomplete="off" name="description" class="txt_box s300 required" title="*"></td>
							</tr>
							<tr>
								<td>ลักษณะการจัดเก็บ</td>
								<td>: 
									<input type="radio" name="fifo_flag" id="fifo_flag_y" class="txt_box" value="y" validate="required:true" title="*"><label for="fifo_flag_y"> FIFO</label> &nbsp;&nbsp;
									<input type="radio" name="fifo_flag" id="fifo_flag_n" class="txt_box" value="n" validate="required:true" title="*"><label for="fifo_flag_n"> Non FIFO</label>
								</td>
							</tr>
							<tr>
								<td>สถานที่จัดเก็บ</td>
								<td>: <input type="text" autocomplete="off" name="location" id="location" class="txt_box required" title="*"></td>
							</tr>
							<tr>
								<td>หน่วยกลาง</td>
								<td>: 
									<input type="text" autocomplete="off" name="des_unit" class="txt_box required" title="*">
								</td>
							</tr>
							<tr>
								<td>จำนวนต่ำสุดที่ต้องสั่งเพิ่ม</td>
								<td>: <input type="text" autocomplete="off" name="mor" id="mor" class="txt_box"></td>
							</tr>
							<tr>
								<td>mfg จากโรงงาน</td>
								<td>: <input type="text" name="mfg_date" id="mfg_date" class="txt_box"> เดือน</td>
							</tr>
							<tr>
								<td colspan="2" align="center" height="30">
									<input type="submit" name="add" class="btn_box btn_confirm" value="บันทึก">
									<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
								</td>
							</tr>
						</table>
					</fieldset>
					
				</form>
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>

</body>
</html>