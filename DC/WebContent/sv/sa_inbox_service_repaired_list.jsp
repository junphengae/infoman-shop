<%@page import="com.bitmap.bean.parts.ServicePartDetail"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.parts.ServiceOtherDetail"%>
<%@page import="com.bitmap.bean.parts.ServiceRepairDetail"%>
<%@page import="com.bitmap.bean.parts.ServiceOutsourceDetail"%>
<%@page import="com.bitmap.bean.parts.ServiceSale"%>
<%@page import="com.bitmap.bean.parts.ServiceRepair"%>
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
<link href="../css/thickbox.css" rel="stylesheet" type="text/css">
<link href="../css/loading.css" rel="stylesheet" type="text/css">
<script src="../js/popup.js"></script>
<script src="../js/jquery-1.4.2.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/number.js"></script>

<script src="../js/jquery.min.js"></script>


<script src="../js/clear_form.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>

<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.datepicker.js"></script>
<script src="../js/ui/jquery.ui.button.js"></script>
<script src="../js/ui/jquery.ui.position.js"></script>
<script src="../js/ui/jquery.ui.autocomplete.js"></script>


<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
ServiceSale entity = new ServiceSale();
WebUtils.bindReqToEntity(entity, request);
ServiceSale.select(entity);

List listOutsource = ServiceOutsourceDetail.list(entity.getId());
List listRepair = ServiceRepairDetail.list(entity.getId());
List listOther = ServiceOtherDetail.list(entity.getId());
List listPart = entity.getUIListDetail();

ServiceRepair repair = ServiceRepair.select(entity.getId());
Personal recv = Personal.select(repair.getCreate_by());

Customer cus = new Customer();
if (entity.getCus_id().length() > 0) {
	cus = Customer.select(entity.getCus_id());
} else {
	cus.setCus_name_th(entity.getCus_name());
}

Vehicle vehicle = new Vehicle();
if (entity.getV_id().length() > 0) {
	vehicle = Vehicle.select(entity.getV_id());
} else {
	vehicle.setLicense_plate(entity.getV_plate());
}
%>
<title>SA: Assign Repaired List</title>
<%
	String id = WebUtils.getReqString(request,"id");
	String vid = WebUtils.getReqString(request,"vid");
	String cus_id = WebUtils.getReqString(request,"cus_id");
	
	//RepairOrder repair_order = RepairOrder.select(id);
	ServiceRepair service_repair = ServiceRepair.select(id);
	Customer customer = Customer.select(cus_id);;
	Vehicle vehicle2 = Vehicle.select(vid);
	VehicleMaster vMaster = VehicleMaster.select(vehicle2.getMaster_id());
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
		                options += '<option value="' + m[i].main_id + '">' + m[i].main_en + ' / ' + m[i].main_th + '</option>';
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
						+ '<td align="center"><div class="pointer btn_del2" lang="' + $labor_id + '" number="' + resData.number + '" id="list_' + $labor_id + '_' + resData.number + '" title="ยืนยันการยกเลิก: [' + $labor_id + ']?" onclick="javascript: if(confirmRemove(this)){removeRepairList(this);}"></div></td>'
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
		$.post('ServiceAdvisor',{action:'qt_remove_labor',id:$id,labor_id:$labor_id,number:$number,create_by:$create_by},
			function(resData){
				ajax_remove();
				if (resData.status.indexOf('success') == -1) {
					$('#msg_labor').text(resData.message).show();
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
				<div class="left">Assign Repaired List [ ใบแจ้งซ่อมเลขที่: <%=service_repair.getId()%> ]</div>
				 <div class="right">
					<div class="btn_box right" title="Back" onclick="javascript: window.location='ServiceAdvisor';">ย้อนกลับ</div> 
				 </div>
				<div class="clear"></div>
			</div>
			<div class="content_body">
				<div class="right"> </div>
					<div class="clear"></div>
					<div class="box_body">
						<fieldset class="fset s920 center" id="customer_info">
						<legend>ข้อมูลลูกค้า</legend>
							<div>
								<span>คุณ <%=customer.getCus_name_th() + " " + customer.getCus_surname_th()%></span>
								<span class="m_left20">โทร. <%=customer.getCus_mobile() + "&nbsp;"%><%=customer.getCus_phone()%></span>
								<span class="m_left20">Email: <%=(customer.getCus_email().length() > 0)?customer.getCus_email():"-"%></span>
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
							<div class="s600 left"><%=service_repair.getProblem().replaceAll(" ", "&nbsp;").replaceAll("\n", "<br>")%></div><div class="clear"></div>
						</div>
						<div>
							<div class="s150 left">Note/หมายเหตุ</div><div class="s10 left"> : </div>
							<div class="s600 left"><%=service_repair.getNote().replaceAll("\n","<br>")%></div><div class="clear"></div>
						</div>
					</fieldset>
					<fieldset class="fset s920"  style="display: none;" ><!-- style="display: none;" -->
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
						<div id="laborTimeGuide" class="center s920 hide">
							<div class="center s920 dot_line m_top5"></div>
							<table class="bg-image s920 center">
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
					<br>	
				<fieldset class="fset s920" >
				<legend>รายการซ่อม</legend>
				<div align="right" style="padding-right: 20px;">
					<input type="button" class="btn_box btn_add" name="next" value="เลือกหมวดการซ่อม" onclick="popup('sa_labortimeguide_search.jsp')">
				</div>
				<div class="clear"> </div>
					<div class="box_body">
						<table class="bg-image s920 center">
							<thead>
								<tr>
									<th width="80px" align="center">รหัส</th>
									<th width="580px" align="center">รายการ</th>
									<th width="55px" align="center">ค่าแรง/หน่วย</th>
									<th width="50px" align="center">เวลา</th>
									<th  align="center">&nbsp</th>
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
									<td align="center"><div class="pointer btn_del2" number="<%=labor.getNumber()%>" id="list_<%=labor.getLabor_id() %>_<%=labor.getNumber()%>" title="ยืนยันการยกเลิก: [<%=labor.getLabor_id() %>]?" onclick="javascript: if(confirmRemove(this)){removeRepairList(this),deleteService('<%=id %>','<%=labor.getLabor_id()%>','<%=laborTime.getLabor_en() + '/' + laborTime.getLabor_th()%>');}" lang="<%=labor.getLabor_id() %>"></div></td>
								</tr>
							<%
								}
							
							%>
							</tbody>
						</table>					
					</div>
				<div class="txt_center" style="margin: 5px 0 5px 0;">
					<input type="button" class="btn_box" name="next" value="เลือกช่าง" onclick="javascript: window.location='sa_inbox_service_assign.jsp?id=<%=id%>&vid=<%=vid%>&cus_id=<%=cus_id%>';">
					<input type="hidden" name="id" id="id" value="<%=id %>">
					<input type="hidden" name="create_by" id="create_by" value="<%=securProfile.getPersonal().getPer_id() %>">
				</div>
				</fieldset>	
				<br>
				<fieldset class="fset" >
					<legend>Parts List &amp; Service Description </legend>					
					<div class="right">
						<button class="btn_box btn_add thickbox s120" title="Select parts" lang="../part/sale_part_select.jsp?id=<%=entity.getId()%>&width=420&height=230">Parts</button>
					</div>
					<div class="clear"></div>
					
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th valign="top" align="left" width="27"></th>
								<th valign="top" align="left" width="22"></th>
								<th valign="top" align="center" width="88">Code</th>
								<th valign="top" align="center" width="192">Description</th>
								<th valign="top" align="center" width="27">Qty</th>
								<th valign="top" align="center" width="111">Unit Price</th>
								<th valign="top" align="center" width="111">Net Price</th>
								<th valign="top" align="center" width="47">Disc(%)</th>
								<th valign="top" align="center" width="126">Total Price</th>
							</tr>
						</thead>
						<tbody>
						<%
							boolean check_close = true;
							String total = "0";
							String total_net_price = "0";
							String total_discount = "0";
							
							String part_total_net_price = "0";
							String part_total_discount = "0";
							
							Iterator ite = listPart.iterator();
							while(ite.hasNext()) {
								ServicePartDetail detailPart = (ServicePartDetail) ite.next();
								String net_price = "0";
								String total_price = "0";
								String disc = "0";
								
								net_price = Money.multiple(detailPart.getQty(), detailPart.getPrice());
								total_price = Money.discount(net_price, detailPart.getDiscount());
								disc = Money.subtract(net_price, total_price);
								
								total_net_price = Money.add(total_net_price, net_price);
								total_discount = Money.add(total_discount, disc);
								total = Money.add(total, total_price);
						%>
							<tr>
								<%if(!detailPart.getCutoff_qty().equalsIgnoreCase("0")){//Case มีการเบิกอะไหล่แล้ว จะไม่สามารถลบหรือแก้ไขจำนวนได้%>
								<td align="center">
									<a class="btn_accept" title="Draw Parts Complete"></a>
								</td>
								<td align="center">
									<a title="Update Parts Detail PN: <%=detailPart.getPn()%>" class="btn_update thickbox" lang="../part/sale_part_update_discount.jsp?id=<%=detailPart.getId()%>&number=<%=detailPart.getNumber()%>&width=420&height=230"></a>
								</td>
								<%}else{ //Case ยังไม่ได้เบิกอะไหล่ จะสามารถลบหรือแก้ไขจำนวนได้%>
								<td align="center">
									<a class="btn_del" onclick="deletePart('<%=detailPart.getId()%>','<%=detailPart.getNumber()%>','<%=detailPart.getUIDescription()%>','<%=detailPart.getPn()%>');"></a>
								</td>
								<td align="center">
									<a title="Update Parts Detail PN: <%=detailPart.getPn()%>" class="btn_update thickbox" lang="../part/sale_part_update_detail.jsp?id=<%=detailPart.getId()%>&number=<%=detailPart.getNumber()%>&width=420&height=230"></a>
								</td>
								<%}%>
								<td><%=detailPart.getPn() %></td>
								<td><%=detailPart.getUIDescription() %></td>
								<td align="right"><%=detailPart.getQty()%></td>
								<td align="right"><%=Money.money(detailPart.getPrice()) %></td>
								<td align="right"><%=Money.money(net_price) %></td>
								<td align="right"><%=detailPart.getDiscount()%></td>
								<td align="right"><%=Money.money(total_price) %></td>
							</tr>
						<%
								if ( !detailPart.getCutoff_qty().equalsIgnoreCase(detailPart.getQty()) ){//check เผื่อปิดจ๊อบ
									check_close = false;
								}
							}
						%>
						</tbody>
					</table>
					
					<div class="dot_line"></div>
					
					<div class="right m_top10">
						<button class="btn_box btn_add thickbox s120" title="Add Service Detail" lang="sv_job_service_add.jsp?id=<%=entity.getId()%>&width=420&height=230">Service</button>
					</div>
					<div class="clear"></div>
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th valign="top" align="left" width="27"></th>
								<th valign="top" align="left" width="22"></th>
								<th valign="top" align="center" width="300">Description</th>
								<th valign="top" align="center" width="27">Hr.</th>
								<th valign="top" align="center" width="111">Unit Price</th>
								<th valign="top" align="center" width="111">Net Price</th>
								<th valign="top" align="center" width="47">Disc(%)</th>
								<th valign="top" align="center" width="126">Total Price</th>
							</tr>
						</thead>
						<tbody>
						<%
							//String sv_total_net_price = "0";
							//String sv_total_discount = "0";
							
							Iterator iteSV = listRepair.iterator();
							while(iteSV.hasNext()) {
								ServiceRepairDetail detailRepair = (ServiceRepairDetail) iteSV.next();
								String net_price = "0";
								String total_price = "0";
								String disc = "0";
								
								net_price = Money.multiple(detailRepair.getLabor_qty(), detailRepair.getLabor_rate());
								total_price = Money.discount(net_price, detailRepair.getDiscount());
								disc = Money.subtract(net_price, total_price);
								
								total_net_price = Money.add(total_net_price, net_price);
								total_discount = Money.add(total_discount, disc);
								total = Money.add(total, total_price);
						%>
							<tr>
								<td align="center">
<%-- 									<a class="btn_del" onclick="deleteService('<%=detailRepair.getId()%>','<%=detailRepair.getNumber()%>','<%=detailRepair.getLabor_name()%>');"></a> --%>
								</td>
								<td align="center">
									<a title="Update Service Detail: <%=detailRepair.getLabor_name()%>" class="btn_update thickbox" lang="../cs/sv_job_service_update.jsp?id=<%=detailRepair.getId()%>&number=<%=detailRepair.getNumber()%>&width=420&height=230"></a>
								</td>
								<td><%=detailRepair.getLabor_name() %></td>
								<td align="right"><%=detailRepair.getLabor_qty()%></td>
								<td align="right"><%=Money.money(detailRepair.getLabor_rate()) %></td>
								<td align="right"><%=Money.money(net_price) %></td>
								<td align="right"><%=detailRepair.getDiscount()%></td>
								<td align="right"><%=Money.money(total_price) %></td>
							</tr>
						<%
							}
						%>
						</tbody>
					</table>
					
					<div class="dot_line"></div>
									
					
				</fieldset>
				
				</div>
			</div>
		</div>
	</div>
	
		
				
</div>


<script type="text/javascript">
				$(function(){
					var net = parseFloat('<%=total%>');
					var total = money(net + (net * (7 / 100)));
					
					$('#vat').click(function(){
						if ($(this).is(':checked')) {
							$('#total_amount_text').text(total);
							$('#total_amount').val(total);
							$('#show_vat').text('<%=Money.money(Money.vat(total))%>');
						} else {
							$('#total_amount_text').text('<%= Money.money(total)%>');
							$('#total_amount').val('<%= Money.money(total)%>');
							$('#show_vat').text('0.00');
						}
					});
					
					if ($('#vat').is(':checked')) {
						$('#total_amount_text').text(total);
						$('#total_amount').val(total);
						$('#show_vat').text('<%=Money.money(Money.vat(total))%>');
					} else {
						$('#total_amount_text').text('<%= Money.money(total)%>');
						$('#total_amount').val('<%= Money.money(total)%>');
						$('#show_vat').text('0.00');
					}
				});			
			
				
				function deletePart(id,number,desc,pn){
					if (confirm('Remove Part PN: ' + pn + ' [' + desc + ']?')) {
						ajax_load();
						$.post('../PartSaleManage',{'id':id,'number':number,'action':'sale_part_delete'},function(resData){
							ajax_remove();
							if (resData.status == 'success') {
								window.location.reload();
							} else {
								alert(resData.message);
							}
						},'json');
					}
				}
				
				function deleteService(id,number,labor_name){
					if (true) {
						ajax_load();
						$.post('../PartSaleManage',{'id':id,'number':number,'action':'sale_service_delete'},function(resData){
							ajax_remove();
							if (resData.status == 'success') {
								window.location.reload();
							} else {
								alert(resData.message);
							}
						},'json');
					}
				}
				
				</script>


	
	<jsp:include page="../index/footer.jsp"></jsp:include>

</body>
</html>