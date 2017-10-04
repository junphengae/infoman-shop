<%@page import="com.bitmap.bean.inventory.WithdrawType"%>
<%@page import="com.bitmap.bean.inventory.InventoryLotControl"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.inventory.InventoryLot"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.position.js"></script>
<script src="../js/ui/jquery.ui.autocomplete.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>
<script src="../js/number.js"></script>

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<jsp:useBean id="invMaster" class="com.bitmap.bean.inventory.InventoryMaster" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>เบิกออก</title>
<%
	String mat_code = invMaster.getMat_code();
%>
<script type="text/javascript">
$(function(){
	$('#btn_info').click(function(){
		
	});
	
	$('#request_date').datepicker({
		showOtherMonths : true,
		slectOtherMonths : true,
		changeYear : true,
		changeMonth : true,
		yearRange: 'c-5:c+10'
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
				<div class="left">
					1: เบิกสินค้า
				</div>
				<div class="right m_right20">
					<div class="pointer thickbox" id="btn_see_photo" title="รูปสินค้า <%=mat_code%>" lang="../info/view_img.jsp?width=400&height=300&img=<%=mat_code%>"><img src="../images/btn_see_photo.png" width="30" height="24" title="ดูรูป" alt="ดูรูป"></div>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<!-- ข้อมูลสินค้า -->
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
								<td>หน่วยกลาง</td>
								<td>: <%=invMaster.getDes_unit()%></td>
							</tr>
							<tr>
								<td>mfg โรงงาน</td>
								<td>: <%=invMaster.getMfg_date()+" เดือน"%></td>
							</tr>
						</tbody>
					</table>
				</fieldset>
				
				<!-- ข้อมูลการเบิก -->
				<form id="withdrawForm" onsubmit="return false;">
					<fieldset class="s430 right fset">
						<legend>ข้อมูลการเบิก</legend>					
							<table width="100%">
								<tbody>
									<tr>
										<td width="40%">ประเภทการเบิก</td>
										<td width="60%">: 
											<bmp:ComboBox name="request_type" listData="<%=WithdrawType.dropdown()%>" styleClass="txt_box s150" validate="true" validateTxt="เลือกประเภทการเบิก!">
												<bmp:option value="" text="--- เลือกประเภท ---"></bmp:option>
											</bmp:ComboBox>	
										</td>
									</tr>
									<tr>
										<td width="30%">เลขอ้างอิงการเบิก</td>
										<td width="70%">: <%=WebUtils.getReqString(request,"request_no")%></td>
									</tr>
									<!-- <tr id="tr_lot_no">
										<td>Lot สินค้า</td>
										<td>: <input type="text" autocomplete="off" name="lot_no" id="lot_no" class="txt_box s150"></td>
									</tr> -->
									<tr id="tr_lot_no">
										<td>หมายเลข Serial</td>
										<td>: <input type="text" autocomplete="off" name="serial" id="serial" class="txt_box s150"></td>
									</tr>
									<tr>
										<td>วันที่เบิกออก</td>
										<td>: <input type="text" autocomplete="off" name="request_date" id="request_date" class="txt_box s150"></td>
									</tr>
									<tr><td colspan="2" height="10"></td></tr>
									
									<tr>
										<td colspan="2" align="center">
											<input type="hidden" name="request_qty" id="request_qty" value="1">		
											<input type="hidden" name="lot_balance" id="lot_balance" value="1">		
											<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
											<input type="hidden" name="request_by" value="<%=securProfile.getPersonal().getPer_id()%>">
											<input type="hidden" name="action" value="withdraw_serial"> 
											<input type="hidden" name="mat_code" value="<%=mat_code%>">
											<input type="hidden" name="request_id" id="request_no" value="<%=WebUtils.getReqString(request,"request_no")%>"> 
											<button type="button" class="btn_box" id="btn_withdraw">เบิกสินค้า</button>
											<button type="button" class="btn_box" onclick="window.location.reload();">ยกเลิก</button>
										</td>
									</tr>
								</tbody>
							</table>
							
							<script type="text/javascript">
								var serial = $('#serial');
								
								$('#btn_withdraw').click(function(){
									if($('#request_type').val() == ''){
										alert("กรุณาเลือกประเภทการเบิก");
										$('#request_type').focus();
										
									}else{
										ajax_load();
										var data = $('#withdrawForm').serialize();
										$.post('../OutletManagement',data,function(resData){
											ajax_remove();
											if (resData.status == 'success') {
												alert('เบิกสินค้าเรียบร้อย');
												window.location.reload();
											} else {
												alert(resData.message);
											}
										},'json');
									}
								});
							</script>
					</fieldset>
					
				</form>
				<div class="clear"></div>
				<!-- ข้อมูลสินค้า -->
				
				
				<fieldset class="s900 fset">
					<legend>รายการ Lot</legend>
					<table class="bg-image s900">
						<thead>
							<tr>
								<th valign="top" align="center" width="20%">Serial </th>
								<th valign="top" align="center" width="20%">เลขที่ใบสั่งซื้อ/สั่งผลิต</th>
								<th valign="top" align="center" width="30%">วันที่นำเข้า</th>
							</tr>
						</thead>
						<tbody>
						<%
						String up = "0";
						Double total = 0.0;
						Iterator iteLot = InventoryLot.selectActiveList(mat_code).iterator();
						while (iteLot.hasNext()){
							InventoryLot lot = (InventoryLot) iteLot.next();
							InventoryLotControl lot_control = lot.getUILot_control();
							////System.out.println("lot_control.getLot_balance() "+lot_control.getLot_balance());
							total += Double.parseDouble(lot_control.getLot_balance());
						%>
							<tr>
								<td><div class="thickbox pointer" title="ข้อมูลสินค้า Serial No. <%=lot.getSerial()%>" lang="lot_view.jsp?lot_no=<%=lot.getLot_no()%>"><%=lot.getSerial()%></div></td>
								<td><div class="thickbox pointer" title="ข้อมูลสินค้า Serial NO. <%=lot.getSerial()%>" lang="lot_view.jsp?lot_no=<%=lot.getLot_no()%>"><%=lot.getPo()%></div></td>
								<td align="center"><div class="thickbox pointer" title="ข้อมูลสินค้า Serial NO. <%=lot.getSerial()%>" lang="lot_view.jsp?lot_no=<%=lot.getLot_no()%>"><%=WebUtils.getDateTimeValue(lot.getCreate_date())%></div></td>
							</tr>
						<%
						}
						%>
							<tr>
								<td colspan="5" align="right" class="txt_bold">ยอดที่สามารถเบิกได้: <%=Money.money(total)%> <%=invMaster.getDes_unit()%></td>
							</tr>
						</tbody>
					</table>
				</fieldset>
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>

</body>
</html>