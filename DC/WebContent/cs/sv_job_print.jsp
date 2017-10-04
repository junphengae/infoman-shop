<%@page import="com.bitmap.bean.parts.ServiceRepairCondition"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.sale.Brands"%>
<%@page import="com.bitmap.bean.sale.Vehicle"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.utils.SNCUtils"%>
<%@page import="com.bitmap.barcode.Barcode128"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.parts.ServiceRepair"%>
<%@page import="com.bitmap.bean.parts.ServiceSale"%>
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

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Repair Order Review</title>
<%
ServiceSale entity = new ServiceSale();
WebUtils.bindReqToEntity(entity, request);
ServiceSale.select(entity);

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

ServiceRepair repair = ServiceRepair.select(entity.getId());
Personal recv = Personal.select(repair.getCreate_by());

Barcode128.genBarcode(WebUtils.getInitParameter(session, SNCUtils.IMG_PATH_BARCODE), entity.getId());
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
			<div class="center txt_center"><img src="../../images/motoshop/barcode/<%=entity.getId()%>.png"></div>
			<div class="clear"></div>
		</div>
		
		<div class="clear"></div>
	</div>
	
	<div class="print_name center txt_center txt_bold txt_28">ใบบันทึกการรับรถและแจ้งซ่อม</div>
	
	<div class="customer_info center m_top-10">
		<fieldset class="fset_print"> 
			<legend>ข้อมูลลูกค้า</legend>
			<div>
				<span>คุณ<%=cus.getCus_name_th() + " " + cus.getCus_surname_th()%></span>
				<span class="m_left20">โทร. <%=cus.getCus_mobile() + " " + cus.getCus_phone()%></span>
				<span class="m_left20">Email: <%=cus.getCus_email()%></span>
				<span class="m_left20">นำมาโดย: คุณ<%=repair.getDriven_by() + " " + repair.getDriven_contact()%></span>
			</div>
			<div class="left s300">
				<div>
					<div class="s80 left">ทะเบียนรถ</div><div class="s10 left"> : </div>
					<div class="s200 left" id="div_license_plate"><%=vehicle.getLicense_plate()%>&nbsp;</div><div class="clear"></div>
				</div>
				<div>
					<div class="s80 left">ยี่ห้อ - รุ่น</div><div class="s10 left"> : </div>
					<div class="s200 left" id="brand"><%=vehicle.getUIMaster().getUIBrand()%>&nbsp;<%=vehicle.getUIMaster().getUIModel()%>&nbsp;<%=vehicle.getUIMaster().getNameplate()%></div><div class="clear"></div>
				</div>
				<div>
					<div class="s80 left">สี</div><div class="s10 left"> : </div>
					<div class="s200 left" id="div_color"><%=vehicle.getColor()%>&nbsp;</div><div class="clear"></div>
				</div>
				<div>
					<div class="s80 left">กิโลเมตร</div><div class="s10 left"> : </div>
					<div class="s200 left" id="div_km"><%=repair.getMile()%>&nbsp;</div><div class="clear"></div>
				</div>
			</div>
			
			<div class="s80 right txt_center box">
				<img src="../images/showroom/fuel_<%=repair.getFuel_level()%>.png" width="80" height="50">
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
					<div class="s150 left" ><%=WebUtils.getDateTimeValue(repair.getCreate_date())%>&nbsp;</div><div class="clear"></div>
				</div>
				<div>
					<div class="s120 left">วันกำหนดส่งรถ (โดยประมาณ)</div><div class="s10 left"> : </div>
					<div class="s150 left" ><%=WebUtils.getDateValue(repair.getDue_date())%>&nbsp;</div><div class="clear"></div>
				</div>
			</div>
			
			<div class="clear"></div>
		</fieldset>
	</div>
	
	<div class="precheck_info m_top5">
		<fieldset class="fset_print">
			<legend>ข้อมูลการแจ้งซ่อม</legend>
			<div class="s700 min_h150">
				<div class="s80 left">อาการเบื้องต้น</div><div class="s10 left"> : </div>
				<div class="s600 left"><%=repair.getProblem().replaceAll("\n","<br>")%>&nbsp;</div><div class="clear"></div>
			</div>
			<div class="s700">
				<div class="s80 left">หมายเหตุ</div><div class="s10 left"> : </div>
				<div class="s600 left"><%=repair.getNote().replaceAll("\n","<br>")%>&nbsp;</div><div class="clear"></div>
			</div>
		</fieldset>
	</div>

	<div class="remark_info m_top5">
		<fieldset class="fset_print">
			<legend>สภาพรถก่อนรับบริการ</legend>
			
				<table width="100%">
					<%
					Iterator iteCon = ServiceRepairCondition.selectList(entity.getId()).iterator();
					while(iteCon.hasNext()){
						ServiceRepairCondition cond = (ServiceRepairCondition) iteCon.next();
					%>
					<tr>
						<td width="30%"><%=cond.getCon_name()%></td>
						<td width="70%">: <%=cond.getCon_detail()%></td>
					</tr>
					<%
					}
					%>
				</table>
			
		</fieldset>
	</div>
	
	<div class="signature_info m_top5">
		<fieldset class="fset_print">
			<div class="argument s700">
				<p>- ใบสั่งซ่อมฉบับนี้ให้ใช้เพื่อแสดงว่า ข้าพเจ้ายินยอมให้บริษัทฯ ซ่อม/เปลี่ยนชิ้นส่วนอะไหล่ที่ชำรุดบกพร่องตามที่ช่างของบริษัทฯเห็นสมควรนำรถของข้าพเจ้าออกวิ่งเพื่อทำการตรวจสอบสภาพก่อนหรือหลังซ่อมได้ตามความเหมาะสม บรรดาค่าใช้จ่ายในการซ่อมยอมให้บริษัทฯคิดเอาจากข้าพเจ้าได้</p>
				<p>- บริษัทฯ ไม่ต้องรับผิดชอบต่อบรรดาทรัพย์สินที่สูญหายนอกเหนือจากที่แจ้งไว้ก่อนซ่อม / ความเสียหายใดที่เกิดขึ้น เนื่องจากการกระทำของบุคคลภายนอกซึ่งมิใช่พนักงานของบริษัทฯ / วินาศภัยหรือภัยอื่นใดซึ่งนอกเหนืออำนาจหรือความรับผิดชอบของบริษัทฯ</p>
			</div>
			<div class="left txt_center s300 m_top20">
				<div>___________________________________</div>
				<div><%=recv.getName() + " " + recv.getSurname()%></div>
				<div>ผู้รับรถ</div>
			</div>
			<div class="right txt_center s300 m_top20">
				<div>___________________________________</div>
				<div>ลูกค้า/Customer Signature</div>
				<div>วันที่/Date_______/_______/_______</div>
			</div>
			<div class="clear"></div>
		</fieldset>
	</div>
</div>
</body>
</html>