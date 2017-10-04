<%@page import="com.bitmap.bean.sale.Models"%>
<%@page import="com.bitmap.bean.sale.Brands"%>
<%@page import="com.bitmap.bean.sale.VehicleMaster"%>
<%@page import="com.bitmap.bean.sale.Vehicle"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.customerService.RepairOrder"%>
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
<link href="../themes/ui-darkness/jquery.ui.all.css" rel="stylesheet" type="text/css">

<script src="../js/jquery-1.4.2.min.js"></script>
<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.button.js"></script>
<script src="../js/ui/jquery.ui.datepicker.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Customer Service</title>
<%
	String id = WebUtils.getReqString(request,"id");
	String vid = WebUtils.getReqString(request,"vid");
	String cus_id = WebUtils.getReqString(request,"cus_id");

	RepairOrder repair_order = RepairOrder.select(id);
	
	Personal per = Personal.select(repair_order.getReceived_by());
	Customer customer = Customer.select(cus_id);
	Vehicle vehicle = Vehicle.select(vid);
	VehicleMaster vMaster = VehicleMaster.select(vehicle.getMaster_id());
%>

<script type="text/javascript">
	$(function(){
		$('#fuel_radio_wrap').buttonset();
	});
</script>
</head>
<body onload="$('div.wrap_all').fadeIn(800);">

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	<div class="wrap_navigate">
		<span onclick="javascript: window.location='../index.jsp';" class="pointer">Home</span> / 
		<span onclick="javascript: window.location='ServiceAdvisor';" class="pointer">Inbox Service</span> / 
		<span>Service Detail</span>
	</div>
	<!-- Start Wrap Content -->
	<div class="wrap_content">
	
		<div class="content">
			
			<div class="box_wrap s1000">
				<div class="box_head">
					<div class="left txt_bold">ใบบันทึกการรับรถและแจ้งซ่อมเลขที่: <%=repair_order.getId()%></div>
					<div class="btn_box right" title="Back" onclick="javascript: window.location='ServiceAdvisor'">ย้อนกลับ</div>
					<div class="clear"></div>
				</div>
				
				<div class="box_body">
					<fieldset class="fset s450 h200 left m_left10" id="customer_info">
						<legend>ข้อมูลลูกค้า</legend>
						<div>
							<div class="s100 left">Name/ชื่อ</div><div class="s10 left"> : </div>
							<div class="s300 left"><%=customer.getCus_name_th() + " " + customer.getCus_surname_th()%></div><div class="clear"></div>
						</div>
						<div class="m_top15">
							<div class="s100 left">Mobile/มือถือ</div><div class="s10 left"> : </div>
							<div class="s300 left"><%=customer.getCus_mobile()%></div><div class="clear"></div>
						</div>
						<div>
							<div class="s100 left">Tel./โทร.</div><div class="s10 left"> : </div>
							<div class="s300 left"><%=customer.getCus_phone()%></div><div class="clear"></div>
						</div>
						<div>
							<div class="s100 left">Email</div><div class="s10 left"> : </div>
							<div class="s300 left"><%=customer.getCus_email()%></div><div class="clear"></div>
						</div>
						<div class="m_top15">
							<div class="s100 left">Address/ที่อยู่</div><div class="s10 left"> : </div>
							<div class="s300 left"><%=customer.getCus_address()%></div><div class="clear"></div>
						</div>
						
					</fieldset>
						
					<fieldset class="fset s450 h200 left m_left20" id="vehicle_info">
						<legend>ข้อมูลรถ</legend>
						<div>
							<div class="s230 left">Brand/ยี่ห้อ</div><div class="s10 left"> : </div>
							<div class="s150 left" id="brand"><%=Brands.getUIName(vMaster.getBrand())%></div><div class="clear"></div>
						</div>
						<div>
							<div class="s230 left">Model/รุ่น</div><div class="s10 left"> : </div>
							<div class="s150 left" id="model"><%=Models.getUIName(vMaster.getModel())%></div><div class="clear"></div>
						</div>
						<div>
							<div class="s230 left">Nameplate/รายละเอียดรุ่น</div><div class="s10 left"> : </div>
							<div class="s150 left" id="nameplate"><%=vMaster.getNameplate()%></div><div class="clear"></div>
						</div>
						
						<div class="m_top15">
							<div class="s230 left">Registration/ทะเบียนรถ</div><div class="s10 left"> : </div>
							<div class="s150 left" id="div_license_plate"><%=vehicle.getLicense_plate()%></div><div class="clear"></div>
						</div>
						<div>
							<div class="s230 left">Engine No./หมายเลขเครื่องยนต์</div><div class="s10 left"> : </div>
							<div class="s150 left" id="div_engine_no"><%=vehicle.getEngine_no()%></div><div class="clear"></div>
						</div>
						<div>
							<div class="s230 left">Chassis No.(Vin)/หมายเลขแชสซีส์</div><div class="s10 left"> : </div>
							<div class="s150 left" id="div_vin"><%=vehicle.getVin()%></div><div class="clear"></div>
						</div>
						<div>
							<div class="s230 left">Color/สี</div><div class="s10 left"> : </div>
							<div class="s150 left" id="div_color"><%=vehicle.getColor()%></div><div class="clear"></div>
						</div>
					</fieldset>
					<div class="clear"></div>
					
					<div class="center s950 dot_line m_top10"></div>
					
					<fieldset class="fset s950" id="precheck_info">
						<legend>ข้อมูลการแจ้งซ่อม</legend>
						<div>
							<div class="s250 left">Received Date/วันที่รับรถ</div><div class="s10 left"> : </div>
							<div class="s450 left"><%=WebUtils.DATETIME_FORMAT_EN.format(repair_order.getReceived_date())%></div><div class="clear"></div>
						</div>
						<div>
							<div class="s250 left">Received By/ผู้รับรถ</div><div class="s10 left"> : </div>
							<div class="s450 left"><%=per.getName() + " " + per.getSurname()%></div><div class="clear"></div>
						</div>
						<div>
							<div class="s250 left">Brought In/นำมาโดย</div><div class="s10 left"> : </div>
							<div class="s450 left"><%=repair_order.getBrought_in()%></div><div class="clear"></div>
						</div>
						<div>
							<div class="s250 left">Km/กม.</div><div class="s10 left"> : </div>
							<div class="s450 left"><%=repair_order.getKm()%></div><div class="clear"></div>
						</div>
						<div>
							<div class="s250 left">Fuel/จำนวนน้ำมัน</div><div class="s10 left"> : </div>
							<div class="left" id="fuel_radio_wrap" >
								<input disabled="disabled" type="radio" name="fuel_level" id="e" value="e" <%=(repair_order.getFuel_level().equalsIgnoreCase("e"))?"checked='checked'":""%>><label for="e">E</label>
								<input disabled="disabled" type="radio" name="fuel_level" id="1/4" value="1/4" <%=(repair_order.getFuel_level().equalsIgnoreCase("1/4"))?"checked='checked'":""%>><label for="1/4">1/4</label>
								<input disabled="disabled" type="radio" name="fuel_level" id="1/2" value="1/2" <%=(repair_order.getFuel_level().equalsIgnoreCase("1/2"))?"checked='checked'":""%>><label for="1/2">1/2</label>
								<input disabled="disabled" type="radio" name="fuel_level" id="3/4" value="3/4" <%=(repair_order.getFuel_level().equalsIgnoreCase("3/4"))?"checked='checked'":""%>><label for="3/4">3/4</label>
								<input disabled="disabled" type="radio" name="fuel_level" id="f" value="f" <%=(repair_order.getFuel_level().equalsIgnoreCase("f"))?"checked='checked'":""%>><label for="f">F</label>
							</div><div class="clear"></div>
						</div>
						<div>
							<div class="s250 left">Due Date/วันกำหนดเสร็จ</div><div class="s10 left"> : </div>
							<div class="s450 left"><%=WebUtils.DATE_FORMAT_EN.format(repair_order.getDue_date())%></div><div class="clear"></div>
						</div>
					</fieldset>
				</div>
			</div>
			
			<div class="box_wrap s1000">
				<div class="box_head">
					<div class="left txt_bold">อาการเบื้องต้น :</div>
					<div class="clear"></div>
				</div>
				
				<div class="box_body">
					<div class="detail_box s700 center" id="precheck_info">
						<div>
							<div class="s200 left">อาการเบื้องต้น</div><div class="s10 left"> : </div>
							<div class="s450 left"><%=repair_order.getInitial_symptoms().replaceAll("\n","<br>")%></div><div class="clear"></div>
						</div>
						<div>
							<div class="s200 left">Note/หมายเหตุ</div><div class="s10 left"> : </div>
							<div class="s450 left"><%=repair_order.getNote().replaceAll("\n","<br>")%></div><div class="clear"></div>
						</div>
					</div>
					<div class="txt_center">
						<input type="button" class="btn_box" name="create" value="ไปหน้าถัดไปเพื่อกำหนดรายการซ่อม" onclick="javascript: window.location='sa_inbox_service_repaired_list.jsp?id=<%=id%>&vid=<%=vid%>&cus_id=<%=cus_id%>';">
					</div>
				</div>
			</div>
			
		</div>
	</div>
	<!-- End Wrap Content -->
	
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>


</body>
</html>