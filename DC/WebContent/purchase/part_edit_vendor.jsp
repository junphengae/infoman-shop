<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.parts.Vendor"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterVendor"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%
String mat_code = WebUtils.getReqString(request, "pn");

PartMaster MAT = PartMaster.select(mat_code);
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Edit Vendor</title>

<script type="text/javascript">
$(function(){
	var form = $('#material_vendor_form');
	
	
	$.metadata.setType("attr", "validate");
	var v = form.validate({
		submitHandler: function(){
			if (isNaN($('#vendor_moq').val())) {
				alert("กรุณากรอก จำนวนต่ำสุดที่ตัวแทนจัดส่งเป็นตัวเลขเท่านั้น!");
			}
			else if (isNaN($('#vendor_delivery_time').val())) {
				alert("กรุณากรอก ระยะเวลาในการจัดส่งเป็นตัวเลขเท่านั้น!");
			}else{
				
					ajax_load();
					$.post('../MaterialManage',form.serialize(),function(resData){
						ajax_remove();
						if (resData.status == 'success') {
							var vendor = resData.vendor;
							var vendor_detail = vendor.vendor;
							var table =	'<tr id="vendor_' + vendor.vendor_id + '">' +
											'<td>' + vendor_detail.vendor_name + '</td>' +
											'<td align="center">' + vendor.vendor_moq + '</td>' + 
											'<td align="center">' + vendor.vendor_delivery_time + '</td>' +
											'<td align="center">' +
												'<button class="btn_box" onclick="delete_vendor(this);" vendor_id="' + vendor.vendor_id + '">ลบ</button>' +
											'</td>' +
										'</tr>';
							$('#vendor_list').append(table);
							
							$('#edit_vendor').hide();
							$('#vendor_id').val('');
							$('#vendor_moq').val('');
							$('#vendor_delivery_time').val('');
						} else {
							if (resData.message.indexOf('Duplicate entry') != -1) {
								alert('คุณได้บันทึกตัวแทนจำหน่ายลงในตารางด้านล่างแล้ว \n\rกรุณาตรวจสอบ!');
								$('#vendor_id').focus();
							} else {
								alert(resData.message);
							}
						}
					},'json');
					
			
			}
			
		}
	});
	
	form.submit(function(){
		v;
		return false;
	});
});

function delete_vendor(obj){
	var vendor_id = $(obj).attr('vendor_id');
	var mat_code = '<%=MAT.getPn()%>';
	if (confirm('ยืนยันการลบตัวแทนจำหน่าย?')) {
		ajax_load();
		$.post('../MaterialManage',{'vendor_id': vendor_id, 'mat_code': mat_code, 'action': 'delete_material_vendor'},function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				$('tr#vendor_' + vendor_id).fadeOut(500).queue(function(){$(this).remove();$(this).dequeue();});
			} else {
				alert(resData.message);
			}
		},'json');
	}
}
</script>

</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">1: แสดงข้อมูลสินค้า | 2: แก้ไขข้อมูลตัวแทนจำหน่าย</div>
				<div class="right">
				 	<%-- <%if(InventoryMasterVendor.check(mat_code)){ %>
					<button class="btn_box thickbox"  lang="pr_parts_add_vendor.jsp?pn=<%=mat_code%>&width=850&height=500">ย้อนกลับ</button>
					<%} %> --%>
					<button class=" btn_box btn_confirm thickbox"  title="Purchase Parts" lang="pr_parts.jsp?pn=<%=mat_code%>&width=850&height=500">สั่งซื้อสินค้า</button>
					 <button class="btn_box" onclick="window.location='purchase_manage.jsp';">ย้อนกลับ</button> 
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				
				<form id="material_vendor_form" onsubmit="return false">
					<table width="100%">
						<tbody>
							<tr>
								<td width="25%">รหัสสินค้า</td>
								<td width="75%">: <%=MAT.getPn()%></td>
							</tr>
							<tr>
								<td>ชื่อสินค้า</td>
								<td>: <%=MAT.getDescription()%></td>
							</tr>
							<tr><td colspan="2" height="20"></td></tr>
							<tr>
								<td>ตัวแทนจำหน่าย</td>
								<td>: 
									<bmp:ComboBox name="vendor_id" styleClass="txt_box s200" validate="true" validateTxt="เลือกตัวแทนจำหน่าย!" listData="<%=Vendor.selectList()%>">
										<bmp:option value="" text="--- select ---"></bmp:option>
									</bmp:ComboBox> 
									<input type="button" class="btn_box thickbox" id="new_vendor" value="เพิ่มตัวแทนจำหน่าย" lang="vendor_new.jsp?height=300&width=520" title="เพิ่มข้อมูลตัวแทนจำหน่าย">
									<input type="button" class="btn_box thickbox hide" id="edit_vendor" value="แก้ไขตัวแทนจำหน่าย" lang="" title="แก้ไขข้อมูลตัวแทนจำหน่าย">
									<script type="text/javascript">
										$('#vendor_id').change(function(){
											if($(this).val() != "") {
												$('#edit_vendor').fadeIn(500);
												var attr = 'vendor_edit.jsp?height=300&width=520&vendor_id=' + $(this).val();
												$('#edit_vendor').attr('lang',attr);
											} else {
												$('#edit_vendor').hide();
											}
										});
									</script>
								</td>
							</tr>
							<tr>
								<td>จำนวนต่ำสุดที่ตัวแทนจัดส่ง</td>
								<td>: <input type="text" autocomplete="off" name="vendor_moq" id="vendor_moq" class="txt_box required" title="ระบุจำนวนต่ำสุดที่ตัวแทนจัดส่ง!"></td>
							</tr>
							<tr>
								<td>ระยะเวลาในการจัดส่ง</td>
								<td>: <input type="text" autocomplete="off" name="vendor_delivery_time" id="vendor_delivery_time" class="txt_box required" title="ระบุระยะเวลาในการจัดส่ง!"></td>
							</tr>
							<tr>
								<td colspan="2" align="center" height="30">
									<input type="submit" name="add" class="btn_box" value="บันทึก">
									<input type="reset" name="reset" class="btn_box" value="ยกเลิก" onclick="$('#edit_vendor').hide();">
									<input type="hidden" name="action" value="add_material_vendor">
									<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
									<input type="hidden" name="mat_code" value="<%=MAT.getPn()%>">
								</td>
							</tr>
						</tbody>
					</table>
				</form>
				
				<div class="m_top10"></div>
				
				<table class="bg-image s700">
					<thead>
						<tr>
							<th valign="top" align="center" width="30%">ชื่อตัวแทนจำหน่าย</th>
							<th valign="top" align="center" width="25%">จัดส่งขั้นต่ำ</th>
							<th valign="top" align="center" width="25%">เวลาจัดส่ง</th>
							<th width="20%"></th>
						</tr>
					</thead>
					<tbody id="vendor_list">
					<%
					Iterator ite = InventoryMasterVendor.selectList(MAT.getPn()).iterator();
					while(ite.hasNext()) {
						InventoryMasterVendor masterVendor = (InventoryMasterVendor) ite.next();
						Vendor vendor = masterVendor.getUIVendor();
					%>
						<tr id="vendor_<%=vendor.getVendor_id()%>">
							<td><%=vendor.getVendor_name()%></td>
							<td align="center"><%=masterVendor.getVendor_moq()%></td>
							<td align="center"><%=masterVendor.getVendor_delivery_time()%></td>
							<td align="center">
								<button class="btn_box" onclick="delete_vendor(this);" vendor_id="<%=vendor.getVendor_id()%>">ลบ</button>
							</td>
						</tr>
					<%
					}
					%>
					</tbody>
				</table>				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>

</body>
</html>