<%@page import="com.bitmap.bean.inventory.InventoryMasterTempDetail"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="com.bitmap.bean.util.ImagePathUtils"%>
<%@page import="com.bitmap.bean.inventory.SubCategories"%>
<%@page import="com.bitmap.bean.inventory.InventoryLotControl"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.inventory.InventoryLot"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterVendor"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<script src="../js/jquery-1.4.2.min.js" type="text/javascript"></script>
<script src="../js/ajaxfileupload.js" type="text/javascript"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.webcam.js"></script>

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Material Information</title>
<%
String mat_code = WebUtils.getReqString(request, "mat_code");
InventoryMaster invMaster = InventoryMaster.select(mat_code);
%>

<script type="text/javascript">
function ajaxImgUpload(){
	$up = $('#fileToUpload');
	$showImg = $('#showImg');
	var mat_code = '<%=mat_code%>';
	
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
			url:'../PhotoSnap', 
			secureuri:false,
			fileElementId:'fileToUpload',
			param: 'mat_code:' + mat_code,
			dataType: 'json',
			success: function (data, status){
				window.location.reload();
			},
			error: function (){
				window.location.reload();
			}
		});
	}
	return false;
}
</script>

</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">1: แสดงข้อมูลสินค้า</div>
				<div class="right">
					<button class="btn_box" onclick="window.location='<%=LinkControl.link("inv_list.jsp", (List)session.getAttribute("INVT_SEARCH"))%>';">ย้อนกลับ</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				
				<fieldset class="s450 left fset">
					<legend>ข้อมูลสินค้า</legend>
					<table width="100%">
						<tbody>
							<tr>
								<td width="40%">กลุ่ม</td>
								<td width="60%">: <%=invMaster.getUISubCat().getUICat().getUIGroup().getGroup_name_th()%></td>
							</tr>
							<tr>
								<td>ชนิด</td>
								<td>: <%=invMaster.getUISubCat().getUICat().getCat_name_th()%></td>
							</tr>
							<tr>
								<td>ชนิดย่อย</td>
								<td>: <%=invMaster.getUISubCat().getSub_cat_name_th()%></td>
							</tr>
							<tr><td colspan="2" height="20"></td></tr>
							<tr>
								<td>รูปแบบสินค้า</td>
								<td>: <%=(invMaster.getSerial().equalsIgnoreCase("y")?"มี serial":"ไม่มี serial")%></td>
							</tr>
							<tr>
								<td>รหัสสินค้า</td>
								<td>: <%=mat_code%></td>
							</tr>
							<tr>
								<td>ชื่อสินค้า</td>
								<td>: <%=invMaster.getDescription()%></td>
							</tr>
							<tr>
								<td>ลักษณะการจัดเก็บ</td>
								<td>: <%=(invMaster.getFifo_flag().equalsIgnoreCase("y"))?"FIFO":"Non FIFO"%></td>
							</tr>
							<tr>
								<td>สถานที่จัดเก็บ</td>
								<td>: <%=invMaster.getLocation()%></td>
							</tr>
							<tr><td colspan="2" height="20"></td></tr>
							<tr>
								<td>ต้นทุน</td>
								<td>: <%=invMaster.getCost()%></td>
							</tr>
							<tr>
								<td>ราคากลาง</td>
								<td>: <%=invMaster.getPrice()%></td>
							</tr>
							<tr>
								<td>จำนวนต่ำสุดที่ต้องสั่งเพิ่ม</td>
								<td>: <%=invMaster.getMor()%></td>
							</tr>
							<tr>
								<td>หน่วยกลาง</td>
								<td>: <%=invMaster.getDes_unit()%></td>
							</tr>
							<tr>
								<td>mfg โรงงาน</td>
								<td>: <%=invMaster.getMfg_date()+" เดือน"%></td>
							</tr>
							
						</tbody>
					</table>
					<div class="center txt_center m_top5">
						<button class="btn_box" onclick="javascript: window.location='material_edit.jsp?mat_code=<%=mat_code%>';">แก้ไขข้อมูลสินค้า</button>
					</div>
				</fieldset>
				
				<fieldset class="s430 right fset">
					<legend>รูปสินค้า</legend>
					
					<div id="div_img" class="center txt_center min_h240">
						<div class="min_h240 center txt_center" style="width: 320px; box-shadow: 0 0px 3px rgba(0,0,0,0.3);">
							<img width="320" height="240" src="<%=ImagePathUtils.img_path%>/inventory/<%=mat_code%>.jpg?state=<%=Math.random()%>">
						</div>
						
						<div class="m_top10">
							<input type="radio" name="uploadType" id="upImg"> <label for="upImg">อัพโหลดจากไฟล์</label> &nbsp;&nbsp; 
							<input type="radio" name="uploadType" id="camImg"> <label for="camImg">ถ่ายภาพจากเวปแคม</label>
							<script type="text/javascript">
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
						</div>
					</div>
					
					<div id="uploadImg" class="txt_center center hide">
						<form enctype="multipart/form-data" method="post" action="" name="imgForm" style="margin: 0px; padding: 0px;">
							<input type="file" id="fileToUpload" name="fileToUpload" readonly="readonly" class="txt_box" onchange="return ajaxImgUpload();">
						</form>
					</div>
					
					<div id="webcam" class="s400 txt_center center hide"></div>
					<div class="clear"></div>
				</fieldset>
				
				<div class="clear"></div>
				
				<fieldset class="s430 fset hide">
					<legend>สินค้าที่ใช้ทดแทน</legend>
					รอพบกับฟังก์ชั่นสินค้าที่ใช้ทดแทนเร็ว ๆ นี้
				</fieldset>
				
				<div class="clear"></div>
				
				<fieldset class="s_950 fset">
					<legend>ข้อมูลตัวแทนจำหน่าย</legend>
					<table class="bg-image s700">
						<thead>
							<tr>
								<th valign="top" align="center" width="30%">ชื่อตัวแทนจำหน่าย</th>
								<th valign="top" align="center" width="25%">จำนวนจัดส่งขั้นต่ำ</th>
								<th valign="top" align="center" width="25%">ระยะเวลาในการจัดส่ง</th>
							</tr>
						</thead>
						<tbody id="vendor_list">
						<%
						Iterator ite = InventoryMasterVendor.selectList(mat_code).iterator();
						while(ite.hasNext()) {
							InventoryMasterVendor masterVendor = (InventoryMasterVendor) ite.next();
							Vendor vendor = masterVendor.getUIVendor();
						%>
							<tr id="vendor_<%=vendor.getVendor_id()%>">
								<td><div class="thickbox" lang="vendor_info.jsp?vendor_id=<%=vendor.getVendor_id()%>&mat_code=<%=mat_code%>&height=300&width=520" title="รายละเอียดตัวแทน: <%=vendor.getVendor_name()%>"><%=vendor.getVendor_name()%></div></td>
								<td align="center"><%=masterVendor.getVendor_moq()%></td>
								<td align="center"><%=masterVendor.getVendor_delivery_time()%></td>
							</tr>
						<%
						}
						%>
						</tbody>
					</table>
					
					<div class="center txt_center m_top5">
						<button class="btn_box" onclick="javascript: window.location='material_edit_vendor.jsp?mat_code=<%=mat_code%>';">แก้ไขข้อมูลตัวแทนจำหน่าย</button>
					</div>
				</fieldset>
				
				<div class="clear"></div>
				
				<%
				if(invMaster.getSerial().equalsIgnoreCase("y")){
				%>
				<fieldset class="s_950 fset">
					<legend>รายการส่วนประกอบมาตรฐาน</legend>
					<table class="bg-image s700">
						<thead>
							<tr>
								<th valign="top" align="center" width="20%">รหัสอะไหล่</th>
								<th valign="top" align="center" width="60%">ชื่ออะไหล่</th>
								<th valign="top" align="center" width="20%">ที่อยู่</th>
							</tr>
						</thead>
						<tbody id="vendor_list">
						<%
							Iterator iteCom = InventoryMasterTempDetail.selectList(mat_code).iterator();
							while (iteCom.hasNext()){
								InventoryMasterTempDetail entity = (InventoryMasterTempDetail) iteCom.next();
						%>
							<tr>
								<td><%=entity.getMat_code()%></td>
								<td><%=entity.getUIdes()%></td>
								<td align="center"></td>
							</tr>
						<%
						}
						%>
						</tbody>
					</table>		
					<div class="center txt_center m_top5">
						<button class="btn_box" onclick="javascript: window.location='temp_view.jsp?mat_code=<%=mat_code%>';">แก้ไขรายการส่วนประกอบ</button>
					</div>
				</fieldset>
				<div class="clear"></div>
				
				<%} %>
				<fieldset class="s_950 fset">
					<legend>ข้อมูล Lot</legend>
						<table class="bg-image s900">
							<thead>
								<tr>
									<th valign="top" align="center" width="15%">Lot เลขที่ </th>
									<th valign="top" align="center" width="15%">Serial</th>
									<th valign="top" align="center" width="15%">เลขที่ใบแจ้งหนี้</th>
									<th valign="top" align="center" width="5%">จำนวน</th>
									<th valign="top" align="center" width="15%">ราคาต่อหน่วย</th>
									<th valign="top" align="center" width="15%">วันที่นำเข้า</th>
									<th valign="top" align="center" width="10%"></th>
								</tr>
							</thead>
							<tbody>
							<%
							List list = InventoryLot.selectList(mat_code);
							Double total = 0.0;
							Iterator iteLot = list.iterator();
							while (iteLot.hasNext()){
								InventoryLot lot = (InventoryLot) iteLot.next();
								if(lot.getLot_status().equalsIgnoreCase("A")){
									total += Double.parseDouble(lot.getLot_qty());
								}
							%>
								<tr>
									<td><%=lot.getLot_no()%></td>
									<td><%=lot.getSerial()%></td>
									<td><%=lot.getInvoice()%></td>
									<td align="right"><%=lot.getLot_qty()%></td>
									<td align="right"><%=lot.getLot_price()%></td>
									<td align="center"><%=WebUtils.getDateValue(lot.getCreate_date())%></td>
									<% if(invMaster.getSerial().equalsIgnoreCase("y")){ %>
									<td align="center"><button class="btn_box" onclick="window.location='print_barcode_serial.jsp?serial=<%=lot.getSerial()%>&mat_code=<%=lot.getMat_code()%>';">ปริ้นบาร์โค๊ด</button></td>
									<%}else{ %>
									<td align="center"><button class="btn_box" onclick="window.location='print_barcode.jsp?lot_no=<%=lot.getLot_no()%>&mat_code=<%=lot.getMat_code()%>';">ปริ้นบาร์โค๊ด</button></td>
									<%} %>
								</tr>
							<%
							}
							%>
							</tbody>
						</table>
				</fieldset>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
<script language="JavaScript">
$("#webcam").webcam({
	upload_url: '../PhotoSnap?name=<%=mat_code%>&action=material',
	redirect_url: 'material_view.jsp?mat_code=<%=mat_code%>'
});
</script>
</body>
</html>