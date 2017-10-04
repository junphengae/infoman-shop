<%@page import="com.bitmap.bean.service.LaborTime"%>
<%@page import="com.bitmap.bean.service.LaborCate"%>
<%@page import="com.bitmap.bean.sale.Brands"%>
<%@page import="com.bitmap.bean.sale.Models"%>
<%@page import="com.bitmap.bean.service.RepairLaborTime"%>
<%@page import="com.bitmap.bean.sale.VehicleMaster"%>
<%@page import="com.bitmap.bean.sale.Vehicle"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.bean.customerService.RepairOrder"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css">
<link href="../css/unit.css" rel="stylesheet" type="text/css">
<link href="../css/table.css" rel="stylesheet" type="text/css">
<link href="../css/loading.css" rel="stylesheet" type="text/css">

<script src="../js/jquery-1.4.2.min.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/number.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Service Advisor: Edit Repaired List</title>
<%
String id = WebUtils.getReqString(request,"id");
String vid = WebUtils.getReqString(request,"vid");
String cus_id = WebUtils.getReqString(request,"cus_id");

RepairOrder repair_order = RepairOrder.select(id);
Customer customer = Customer.select(cus_id);
Vehicle vehicle = Vehicle.select(vid);
VehicleMaster vMaster = VehicleMaster.select(vehicle.getMaster_id());
%>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="snc" %>
<script type="text/javascript">
	$(function(){
		$('#btn_vehicle_detail_toggle').click(function(){
			var txt = $(this).text();
			$('#vehicle_detail').slideToggle(600);
			if (txt == 'ซ่อน') {
				$(this).text('แสดง');
			} else {
				$(this).text('ซ่อน');
			}
		});
		
		var $cate_id = $('#cate_id');
		var $main_id = $('#main_id');
		var $DIV_laborTimeGuide = $('#laborTimeGuide');
		var $labor_time_list = $('#labor_time_list');
		
		$cate_id.change(function(){
			ajax_load();
			$.getJSON('GetLaborTime',{action:'GetMain',cate_id: $(this).val()},
				function(m){
					ajax_remove();
					var options = '<option value="">--- เลือกหมวดย่อย ---</option>';
		            for (var i = 0; i < m.length; i++) {
		                options += '<option value="' + m[i].main_id + '">' + m[i].main_en +  ' / ' + m[i].main_th + '</option>';
		            }
              		$main_id.html(options);
              		$DIV_laborTimeGuide.fadeOut(700);
              		$('#msg_labor').hide();
				}
			);
		});
		
		$main_id.change(function(){
			ajax_load();
			$.getJSON('GetLaborTime',{action:'GetLabor',main_id:$(this).val()},
				function(data){
					ajax_remove();
					var li = '';
					for (var i = 0; i < data.length; i++) {
						li += '<tr id="' + data[i].labor_id + '">'
							+ '<td align="center">' + data[i].labor_id + '</td>'
							+ '<td>' + data[i].labor_en + ' / ' + data[i].labor_th + '</td>'
							+ '<td align="center">' + data[i].labor_hour + '</td>'
							+ '<td align="center"><div class="pointer btn_box'
							+ '" id="' + data[i].labor_id 
							+ '" title="' + data[i].labor_en + ' / ' + data[i].labor_th 
							+ '" lang="' + data[i].labor_hour
						   	+ '" onclick="setLaborTime(this);">เลือก</div></td>'
							+ '</tr>';
					}
					$labor_time_list.html(li);
					$DIV_laborTimeGuide.fadeIn(1000);
					$('#msg_labor').hide();
				}
			);
		});
	});
	
	function setLaborTime(obj) {
		var $id = $('#id').val();
		var $create_by = $('#create_by').val();
		var $labor_id = $(obj).attr('id');
		var $labor_hour = $(obj).attr('lang');
		var $labor_name = $(obj).attr('title');
		var unit_price = prompt('ค่าแรงต่อหน่วย','<%=RepairLaborTime.standardPrice()%>');
		
		if (unit_price != '' && isNumber(unit_price)) {
			ajax_load();
			$.post('ServiceAdvisor',{action:'qt_save_labor',id:$id,labor_id:$labor_id,labor_hour:$labor_hour,create_by:$create_by,'unit_price':unit_price},
				function(resData){
					ajax_remove();
					if (resData.status.indexOf('success') == -1) {
						$('#msg_labor').text(resData.message).show();
					} else {
						var li = '<tr id="list_' + $labor_id + '_' + resData.number + '">'
						+ '<td align="center">' + $labor_id + '</td>'
						+ '<td>' + $labor_name + '</td>'
						+ '<td align="center">' + money(unit_price) + '</td>'
						+ '<td align="center">' + $labor_hour + '</td>'
						+ '<td align="center"><div class="pointer btn_box" lang="' + $labor_id + '" number="' + resData.number + '" id="list_' + $labor_id + '_' + resData.number + '" title="ยืนยันการยกเลิก: [' + $labor_id + ']?" onclick="javascript: if(confirmRemove(this)){removeRepairList(this);}">ยกเลิก</div></td>'
						+ '</tr>';
						$('#repair_list').append(li).show();
						$('#msg_labor').hide();
					}
				},'json'
			);
		} else {
			setLaborTime(obj);
		}
	}
	
	function confirmRemove(obj){
		return confirm($(obj).attr('title'));
	}
	
	function removeRepairList(obj){
		var $id = $('#id').val();
		var $number = $(obj).attr('number');
		var $labor_id = $(obj).attr('lang');
		var $create_by = $('#create_by').val();
		ajax_load();
		$.post('ServiceAdvisor',{action:'remove_labor',id:$id,labor_id:$labor_id,number:$number,create_by:$create_by},
			function(resData){
				ajax_remove();
				if (resData.status.indexOf('success') == -1) {
					alert(resData.message);
				} else {
					$('tr#' + $(obj).attr('id')).fadeOut(400).remove();
				}
			},'json'
		);
	}
</script>
</head>
<body onload="$('div.wrap_all').fadeIn(800);">


<div class="wrap_all" style="display: none;">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Job List : [ Edit Repaired List ]</div>
				<div class="right">
					<div class="btn_box right" title="Back" onclick="javascript: window.location='../index/index.jsp'">ย้อนกลับ</div> 
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				
					<div class="clear"></div>
					
					<div class="box_body">
					<fieldset class="fset s940 center" id="customer_info">
						<legend>ข้อมูลลูกค้า</legend>
						<div>
							<span>คุณ <%=customer.getCus_name_th() + " " + customer.getCus_surname_th()%></span>
							<span class="m_left20">โทร. <%=customer.getCus_mobile() + "&nbsp;"%><%=customer.getCus_phone()%></span>
							<span class="m_left20">Email: <%=(customer.getCus_email().length() > 0)?customer.getCus_email():"-"%></span>
						</div>
						<div>
							
						</div>
						<div class="center s650 detail_box">
							<div>
								<div class="s150 left">ยี่ห้อ - รุ่น</div><div class="s10 left"> : </div>
								<div class="s400 left" id="brand"><%=Brands.getUIName(vMaster.getBrand())%>&nbsp;<%=Models.getUIName(vMaster.getModel())%>&nbsp;<%=vMaster.getNameplate()%></div>
								<button class="btn_box right s80" id="btn_vehicle_detail_toggle">แสดง</button><div class="clear"></div>
							</div>
							<div class="hide" id="vehicle_detail">
								<div>
									<div class="s150 left">ทะเบียนรถ</div><div class="s10 left"> : </div>
									<div class="s400 left" id="div_license_plate"><%=vehicle.getLicense_plate()%></div><div class="clear"></div>
								</div>
								<div>
									<div class="s150 left">หมายเลขเครื่องยนต์</div><div class="s10 left"> : </div>
									<div class="s400 left" id="div_engine_no"><%=vehicle.getEngine_no()%></div><div class="clear"></div>
								</div>
								<div>
									<div class="s150 left">หมายเลขตัวถัง</div><div class="s10 left"> : </div>
									<div class="s400 left" id="div_vin"><%=vehicle.getVin()%></div><div class="clear"></div>
								</div>
								<div>
									<div class="s150 left">สี</div><div class="s10 left"> : </div>
									<div class="s400 left" id="div_color"><%=vehicle.getColor()%></div><div class="clear"></div>
								</div>
							</div>
						</div>
						<div>
							<div class="s150 left">อาการเบื้องต้น</div><div class="s10 left"> : </div>
							<div class="s600 left"><%=repair_order.getInitial_symptoms().replaceAll("\n","<br>")%></div><div class="clear"></div>
						</div>
						<div>
							<div class="s150 left">Note/หมายเหตุ</div><div class="s10 left"> : </div>
							<div class="s600 left"><%=repair_order.getNote().replaceAll("\n","<br>")%></div><div class="clear"></div>
						</div>
					</fieldset>
					
					<fieldset class="fset s940" >
						<legend>เลือกหมวดการซ่อม</legend>
						<div class="center s800 txt_center">
							<div class="s150 left">หมวดการซ่อม</div><div class="s20 left"> : </div>
							<div class="s220 left">
								<snc:ComboBox name="cate_id" styleClass="txt_box" width="220px" listData="<%=LaborCate.listDropDownEN()%>">
									<snc:option value="" text="--- เลือกหมวดหลัก ---"></snc:option>
								</snc:ComboBox>
							</div>
							<div class="s100 left" style="margin-left: 20px;">หมวดย่อย</div><div class="s20 left"> : </div>
							<div class="s220 left">
								<snc:ComboBox name="main_id" styleClass="txt_box" width="220px">
									<snc:option value="" text="--- เลือกหมวดย่อย ---"></snc:option>
								</snc:ComboBox>
							</div>
							<div class="clear"></div>
						</div>
						<div id="laborTimeGuide" class="center s950 hide">
							<div class="center s950 dot_line m_top5"></div>
							<table class="bg-image s950 center">
								<thead>
									<tr>
										<th width="80px" align="center">รหัส</th>
										<th width="655px" align="center">รายการ</th>
										<th width="70px" align="center">เวลา</th>
										<th width="60px" align="center">&nbsp;</th>
									</tr>
								</thead>
								<tbody id="labor_time_list">
									
								</tbody>
							</table>
							<div class="msg_error" id="msg_labor"></div>
						</div>
					</fieldset>
				</div>
			</div>
			</div>
			</div>
			<br>
			<div class="body_content s1000">
				<div class="box_head">
					<div class="content_head ">รายการซ่อม </div>
					<div class="clear"></div> 
				</div>
				
				<div class="content_body">
				<div class="box_body">
					<table class="bg-image s950 center" >
						<thead>
							<tr>
								<th width="80px" align="center">รหัส</th>
								<th width="580px" align="center">รายการ</th>
								<th width="75px" align="center">ค่าแรง/หน่วย</th>
								<th width="70px" align="center">เวลา</th>
								<th width="60px" align="center">&nbsp;</th>
							</tr>
						</thead>
						<tbody id="repair_list">
						<%
							Iterator iteLabor = RepairLaborTime.select(id).iterator();
							while (iteLabor.hasNext()) { 
								RepairLaborTime labor = (RepairLaborTime) iteLabor.next();
								LaborTime laborTime = LaborTime.select(labor.getLabor_id()); 
					%>
							<tr id="list_<%=labor.getLabor_id()%>_<%=labor.getNumber()%>">
								<td align="center"><%=labor.getLabor_id() %></td>
								<td><%=laborTime.getLabor_en() + " / " + laborTime.getLabor_th()%></td>
								<td align="center"><%=Money.money(labor.getUnit_price())%></td>
								<td align="center"><%=labor.getLabor_hour() %></td>
								<td align="center">
								<%
 									if (labor.getStatus().equalsIgnoreCase(RepairLaborTime.STATUS_CLOSED)) { 
								%> 
									งานจบ
								<%} else if (labor.getStatus().equalsIgnoreCase(RepairLaborTime.STATUS_SUBMIT)) {
								%> 
									QC ผ่าน
								<%} else {%>
									<div class="pointer btn_box" number="<%=labor.getNumber()%>" id="list_<%=labor.getLabor_id() %>_<%=labor.getNumber()%>" title="Do you want to delete: [<%=labor.getLabor_id() %>]?" onclick="javascript: if(confirmRemove(this)){removeRepairList(this);}" lang="<%=labor.getLabor_id() %>">ยกเลิก</div>
								<%}%>
								</td>
							</tr>
						<%
							}
					%> 
						</tbody>
					</table>
					
				</div>
			
			
			<div class="txt_center" style="margin: 5px 0 5px 0;">
				<input type="button" name="next" class="btn_box" value="เลือกช่าง" onclick="javascript: window.location='sa_job_repaired_assign_mechanic.jsp?id=<%=id%>&vid=<%=vid%>&cus_id=<%=cus_id%>';">
				<input type="hidden" name="id" id="id" value="<%=id %>">
<%-- 				<INPUT TYPE="HIDDEN" NAME="CREATE_BY" ID="CREATE_BY" VALUE="<%=securProfile.getPersonal().getPer_id()%>"> --%>
			</div>
			
		</div>
		</div>
			
			</div>
			
	






<!-- <div class="wrap_all"> -->
<%-- 	<jsp:include page="../index/header.jsp"></jsp:include> --%>
<!-- 	<div class="wrap_navigate"> -->
<!-- 		<span onclick="javascript: window.location='../index.jsp';" class="pointer">Home</span> /  -->
<!-- 		<span onclick="javascript: window.location='ServiceAdvisorViewJob';" class="pointer">Job List</span> /  -->
<!-- 		<span>Edit Repaired List</span> -->
<!-- 	</div> -->
<!-- 	Start Wrap Content -->
<!-- 	<div class="wrap_content"> -->
	
<!-- 		<div class="content"> -->
			
<!-- 			<div class="box_wrap s1000"> -->
<!-- 				<div class="box_head"> -->
<%-- 					<div class="left txt_bold">เลขที่ใบแจ้งซ่อม: <%=repair_order.getId()%>  | <a class="thickbox btn_box" lang="../info/vehicle_info.jsp?width=400&height=250&vid=<%=vid%>" title="ข้อมูลรถ">ทะเบียนรถ: <%=vehicle.getLicense_plate()%></a> | <a class="thickbox btn_box" lang="../info/customer_info.jsp?width=400&height=250&cus_id=<%=cus_id%>" title="ข้อมูลลูกค้า">ข้อมูลลูกค้า: คุณ<%=customer.getCus_name_th()%></a></div> --%>
<!-- 					<div class="btn_box right" title="Back" onclick="javascript: window.location='ServiceAdvisorViewJob';">ย้อนกลับ</div> -->
<!-- 					<div class="clear"></div> -->
<!-- 				</div> -->
				
<!-- 				<div class="box_body"> -->
					
<!-- 	End Wrap Content -->
	
	<jsp:include page="../index/footer.jsp"></jsp:include>

</body>
</html>