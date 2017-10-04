<%@page import="com.bitmap.webutils.customtag.ComboBoxTag"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery-1.6.1.min.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/popup.js"></script>

<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.datepicker.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Human Resource Report</title>

<script type="text/javascript">
$(function(){
	
	var form = $('#report_form');
	var tr_type = $('#tr_type'); 
	var tr_date = $('#tr_date');
	var tr_month = $('#tr_month');
	
	
	$('#report_type').change(function(){
		if ($(this).val() == '2') {
			tr_type.show();
			$('input:radio[name=time]').removeAttr('checked'); 
			tr_date.hide();  
			tr_month.hide();
		} else if($(this).val() == '1' || $(this).val() == '3' || $(this).val() == '5') {
			tr_type.hide(); 
			tr_date.hide(); 
			tr_month.show();
		}else if ($(this).val() == '4') {
			tr_type.hide();
			tr_date.hide();
			tr_month.hide();
		}else{
			
		}
	});
	
	$('#type_date').click(function(){
		tr_date.hide();
		tr_month.show();
	});
	
	$('#type_month').click(function(){
		tr_date.hide();
		tr_month.show();
	});
	
	$('#btn_view').click(function(){
		if ($('#report_type').val() == '2') {
			
			if ($('#type_date').is(':checked')) {
				if ($('#type_date').val() != '') {
					popup('hr_report_review.jsp?salary_type=0&' + form.serialize());
				} else {
					alert('กรุณาระบุประเภทพนักงาน');
				}
			} else if ($('#type_month').is(':checked')) {
				popup('hr_report_review.jsp?salary_type=1&' + form.serialize());
			} else {
				alert('กรุณาระบุประเภทพนักงาน');
			}
		} else {
			popup('hr_report_review.jsp?' + form.serialize());
		}
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
				รายงานทรัพยากรบุคคล
			</div>
			
			
			<div class="content_body">
			<form id="report_form">
				<table>
					<tr>
						<td width="100">ประเภทรายงาน</td>
						<td>: 
							<bmp:ComboBox name="report_type" styleClass="txt_box s250" value="">
								<bmp:option value="1" text="รายงานการนำส่งเงินสมทบ"></bmp:option>
								<bmp:option value="2" text="รายงานสรุปเงินเดือนพนักงาน"></bmp:option>
								<bmp:option value="3" text="รายงานสรุปการขาดลามาสายของพนักงาน"></bmp:option>
								<bmp:option value="4" text="รายงานข้อมูลพนักงานทั้งหมด"></bmp:option>
								<bmp:option value="5" text="รายงานสรุปยอดผลิตมะพร้าวของพนักงาน"></bmp:option>
							</bmp:ComboBox>
						</td>
					</tr>
					<tr id="tr_date" class="hide">
						<td>วันที่</td>
						<td>: <input type="text" class="txt_box" name="create_date" id="date"></td>
					</tr>
					<tr id="tr_type" class="hide">
						<td>ประเภทพนักงาน</td>
						<td>: 
							<input type="radio" name="time" id="type_date" value="date"> <label for="type_date"> พนักงานรายวัน</label> &nbsp;&nbsp;
							<input type="radio" name="time" id="type_month" value="month"> <label for="type_month"> พนักงานรายเดือน</label>
						</td>
					</tr>
					<tr id="tr_month" >
						<td>เดือน / ปี</td>
						<td>: 
							<bmp:ComboBox name="month" styleClass="txt_box s100" style="<%=ComboBoxTag.EngMonthList%>" value=""></bmp:ComboBox>
							<bmp:ComboBox name="year" styleClass="txt_box s100" style="<%=ComboBoxTag.EngYearList%>" value="null"></bmp:ComboBox>
						</td>
					</tr>
				</table>
				<div class="center txt_center">
					<span class="btn_box btn_confirm" id="btn_view">ดูรายงาน</span>
					<span class="btn_box btn_confirm" id="btn_export">บันทึกเป็นไฟล์</span>
				</div>
			</form>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>

</body>
</html>