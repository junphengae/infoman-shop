<%@page import="com.bitmap.bean.service.LaborTime"%>
<%@page import="com.bitmap.bean.sale.Models"%>
<%@page import="com.bitmap.bean.sale.Brands"%>
<%@page import="com.bitmap.utils.SNCUtils"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.sale.VehicleMaster"%>
<%@page import="com.bitmap.bean.sale.Vehicle"%>
<%@page import="com.bitmap.bean.service.RepairLaborTime"%>
<%@page import="com.bitmap.bean.customerService.RepairOrder"%>
<%@page import="com.bitmap.barcode.Barcode128"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery-1.4.2.min.js"></script>

<link href="../css/barcode.css" rel="stylesheet" type="text/css">
<link href="../css/style.css" rel="stylesheet" type="text/css">
<link href="../css/theme_print_rp.css" rel="stylesheet" type="text/css">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<jsp:useBean id="repair_order" class="com.bitmap.bean.customerService.RepairOrder" scope="session"></jsp:useBean>
<jsp:useBean id="repair_order_remark" class="com.bitmap.bean.customerService.RepairOrderRemark" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Service Order</title>
<%
	String id = WebUtils.getReqString(request,"id");
	String vid = WebUtils.getReqString(request,"vid");
	String cus_id = WebUtils.getReqString(request,"cus_id");
	
	repair_order = RepairOrder.select(id);
	List laborTimeList = RepairLaborTime.select(id);
	
	Vehicle vehicle = Vehicle.select(repair_order.getVehicle_id());
	VehicleMaster vMaster = VehicleMaster.select(vehicle.getMaster_id());
	Personal per = securProfile.getPersonal();
	
	String fuel = "e";
	if(repair_order.getFuel_level().equalsIgnoreCase("1/4")){fuel="1_4";}
	if(repair_order.getFuel_level().equalsIgnoreCase("1/2")){fuel="1_2";}
	if(repair_order.getFuel_level().equalsIgnoreCase("3/4")){fuel="3_4";}
	if(repair_order.getFuel_level().equalsIgnoreCase("f")){fuel="f";}
	Barcode128.genBarcode(WebUtils.getInitParameter(session, SNCUtils.IMG_PATH_BARCODE), repair_order.getId());
%>
</head>
<script type="text/javascript">
	$(function(){
		setTimeout('window.print()',500); setTimeout('window.close()',1000);
	});
</script>
<body>
<div class="wrap_print">
	<div class="form_header">
		<div class="showroom_info">
			<div class="showroom_logo">
				<img alt="" src="../images/showroom/logo.png" width="150" height="120">
			</div>
			<div class="showroom_address">
				<div>บริษัท ศรณรงค์ คาร์ จำกัด</div>
				<div>16/13 ม.2 ถ.แจ้งวัฒนะ ต.คลองเกลือ อ.ปากเกร็ด จ.นนทบุรี 11120</div>
				<div>โทร. 0-2980-8655-6  แฟกซ์ กด 111  www.sncshowroom.com</div>
			</div>
			<div class="clear"></div>
		</div>
		
		<div class="form_info right box_head txt_center">
			<div class="txt_bold txt_18 m_left20 m_right20">เลขที่ใบรับรถ</div>
			<div class="center txt_center"><img src="../images/motoshop/barcode/<%=repair_order.getId()%>.png"></div>
			<div class="clear"></div>
		</div>
		
		<div class="clear"></div>
	</div>
	
	<div class="print_name center txt_center txt_bold txt_28">ใบบันทึกรายการซ่อมรถ</div>
	
	<div class="customer_info center m_top-10">
		<fieldset class="fset_print"> 
			<legend>ข้อมูลลูกค้า</legend>
			<div class="left s300">
				<div>
					<div class="s80 left">ทะเบียนรถ</div><div class="s10 left"> : </div>
					<div class="s200 left" id="div_license_plate"><%=vehicle.getLicense_plate()%>&nbsp;</div><div class="clear"></div>
				</div>
				<div>
					<div class="s80 left">ยี่ห้อ - รุ่น</div><div class="s10 left"> : </div>
					<div class="s200 left" id="brand"><%=Brands.getUIName(vMaster.getBrand())%>&nbsp;<%=Models.getUIName(vMaster.getModel())%>&nbsp;<%=vMaster.getNameplate()%></div><div class="clear"></div>
				</div>
				<div>
					<div class="s80 left">สี</div><div class="s10 left"> : </div>
					<div class="s200 left" id="div_color"><%=vehicle.getColor()%>&nbsp;</div><div class="clear"></div>
				</div>
				<div>
					<div class="s80 left">กิโลเมตร</div><div class="s10 left"> : </div>
					<div class="s200 left" id="div_km"><%=repair_order.getKm()%>&nbsp;</div><div class="clear"></div>
				</div>
			</div>
			
			<div class="right s300">
				<div>
					<div class="s120 left">หมายเลขเครื่องยนต์</div><div class="s10 left"> : </div>
					<div class="s150 left" id="div_engine_no"><%=vehicle.getEngine_no()%>&nbsp;</div><div class="clear"></div>
				</div>
				<div>
					<div class="s120 left">หมายเลขแชสซีส์</div><div class="s10 left"> : </div>
					<div class="s150 left" id="div_vin"><%=vehicle.getVin()%>&nbsp;</div><div class="clear"></div>
				</div>
				<div>
					<div class="s120 left">วัน/เวลาที่นำรถเข้าซ่อม</div><div class="s10 left"> : </div>
					<div class="s150 left" id="nameplate"><%=WebUtils.DATETIME_FORMAT_EN.format(repair_order.getReceived_date())%>&nbsp;</div><div class="clear"></div>
				</div>
				<div>
					<div class="s120 left">วันส่งรถ (โดยประมาณ)</div><div class="s10 left"> : </div>
					<div class="s150 left" id="nameplate"><%=WebUtils.DATE_FORMAT_EN.format(repair_order.getDue_date())%>&nbsp;</div><div class="clear"></div>
				</div>
			</div>
			
			<div class="clear"></div>
		</fieldset>
	</div>
	
	<div class="precheck_info m_top5">
		<fieldset class="fset_print">
			<legend>ข้อมูลการแจ้งซ่อม</legend>
			<div class="s700">
				<div class="s80 left">อาการเบื้องต้น</div><div class="s10 left"> : </div>
				<div class="s600 left"><%=repair_order.getInitial_symptoms().replaceAll("\n","<br>")%>&nbsp;</div><div class="clear"></div>
			</div>
			<div class="s700">
				<div class="s80 left">หมายเหตุ</div><div class="s10 left"> : </div>
				<div class="s600 left"><%=repair_order.getNote().replaceAll("\n","<br>")%>&nbsp;</div><div class="clear"></div>
			</div>
		</fieldset>
	</div>

	<div class="labor_info m_top5">
		<fieldset class="fset_print">
			<legend>รายการซ่อม</legend>
			<table>
				<tbody>
				<%
					Iterator laborIte = laborTimeList.iterator();
					while(laborIte.hasNext()) {
						RepairLaborTime repairLaborTime = (RepairLaborTime) laborIte.next();
						LaborTime laborTime = LaborTime.select(repairLaborTime.getLabor_id());
				%>
					<tr>
						<td width="15%" valign="top"><%=laborTime.getLabor_id() %></td>
						<td valign="top"><%=laborTime.getLabor_en() %> / <%=laborTime.getLabor_th() %></td>
					</tr>
				<%
					}
				%>
					
				</tbody>
			</table>
		</fieldset>
	</div>
	
	<div class="mechanic_info m_top5">
		<fieldset class="fset_print">
			<legend>รายชื่อช่างผู้รับผิดชอบ</legend>
			<table>
				<tbody>
				<%	
					int i = 1;
					Iterator mechIte = RepairOrder.selectMechanicInRepairOrder(id).iterator();
					while(mechIte.hasNext()) {
						Personal personal = (Personal) mechIte.next();
				%>
					<tr>
						<td valign="top"><%=i + ". " + personal.getName() + " " + personal.getSurname()%></td>
					</tr>
				<%
					i++;
					}
				%>
					
				</tbody>
			</table>
			
			<div class="s350 right txt_center m_top20">
				<div>ลงชื่อ___________________________________</div>
				<div><%=per.getName() + " " + per.getSurname()%></div>
				<div>หัวหน้าช่างผู้รับผิดชอบ</div>
			</div>
		</fieldset>
	</div>
	
</div>
</body>
</html>