<%@page import="com.bitmap.bean.parts.ServiceRepair"%>
<%@page import="com.bitmap.report.job.TS.jobTS"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="java.sql.Date"%>
<%@page import="com.bitmap.bean.parts.ServiceSale"%>
<%@page import="com.bitmap.utils.ReportUtils"%>
<%@page import="com.bitmap.webutils.customtag.ComboBoxTag"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.security.SecurityUnit"%>
<%@page import="com.bitmap.security.SecuritySystem"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.webutils.WebUtils"%>


<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	
	<script src="../js/jquery.min.js"></script>
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
	<title>Job Report</title>

	<script type="text/javascript">
		$(function(){
				
			$( "#date" ).datepicker({
				showOtherMonths: true,
				selectOtherMonths: true,
				changeMonth: true,
				dateFormat : 'dd-mm-yy',
				maxDate: new Date(),
				hideIfNoPrevNext : true
			});		
			
			$('#date_start').datepicker( {
		    	changeYear: true,
		    	changeMonth: true,
		   	 	numberOfMonths: 1,
		        showButtonPanel: true,
				maxDate: new Date(),
				hideIfNoPrevNext : true,
				dateFormat : 'dd-mm-yy',
		        onClose: function( selectedDate ) {
		        	$( "#date_end" ).datepicker( "option", "minDate", selectedDate );
		      	}
			});
			$('#date_end').datepicker( {
			   	changeYear: true,
			   	changeMonth: true,
			  	 numberOfMonths: 1,
				showButtonPanel: true,
				maxDate: new Date(),
				hideIfNoPrevNext : true,
				dateFormat : 'dd-mm-yy',
				onClose: function( selectedDate ) {
		            $( "#date_start" ).datepicker( "option", "maxDate", selectedDate );
		        }
			});
			
			
			
			
			$('#tr_type_time #rd_time').change(function(){
				
				$('#date').val("");
				$('#date_start').val("");
				$('#date_end').val("");
				$('#month').val("");
				$('#year').val("");
				
				if( $(this).is(":checked") ){ 
		            var val = $(this).val(); 
		            if(val == '1'){
			            $('#tr_date').show();
			            $('#tr_date_date').hide();
			            $('#tr_month').hide();
		            }else if (val == '2') {
		            	$('#tr_date').hide();	
			            $('#tr_date_date').show();
			            $('#tr_month').hide();	
					}else if (val == '3') {
						$('#tr_date').hide();	
			            $('#tr_date_date').hide();
			            $('#tr_month').show();
					}
		        }			
			 });
			
					
			
			$('#btn_view').click(function() {
				var reporttype = $("#report_type").val().trim();	
				var rd_time ="";	
				var date = $('#date').val();
				var date_start = $('#date_start').val();
				var date_end = $('#date_end').val();
				var month	 =$('#month').val();
				var year	 =$('#year').val();
								
				var repair_type  = $('#repair_type').val();
				var report_job_id  = $('#report_job_id').val();
				var report_job_status  = $('#report_job_status').val();
				
				 
				var data = "";
				
				if(reporttype != "0"){
					if( reporttype != "job_good_sale" ){
						if ($("input[type='radio'].rmd_time").is(':checked')) {
							rd_time = $('input[name=#tr_type_time #rd_time]:checked').val();
							//alert("Report Type :"+reporttype +" Time : "+rd_time );
						
						 
							if(rd_time == '1'){
								data =  "rd_time="+rd_time;
								if (date == "") {
									alert("คุณยังไม่ได้ระบุ วันที่ต้องการดูรายงาน");
									$('#date').focus();
									return false;
								}else {
									data += "&date="+date;
								}
								
				            }else if (rd_time == '2') {
				            	data =  "rd_time="+rd_time;
				            	if (date_start == "") {
									alert("คุณยังไม่ได้ระบุ วันที่เริ่มต้นที่ต้องการดูรายงาน");
									$('#date_start').focus();
									return false;
								}else {
									data += "&date_start="+date_start;
								}
				            	if (date_end == "") {
									alert("คุณยังไม่ได้ระบุ วันที่สินสุดที่ต้องการดูรายงาน");
									$('#date_end').focus();
									return false;
								}else {
									data += "&date_end="+date_end;
								}
								
								
							}else if (rd_time == '3') {
								data =  "rd_time="+rd_time;
								data += "&month="+month;
								data += "&year="+year;
							}
						
					
						} else {
							var No_time = "0";
							data =  "rd_time="+No_time;							
						}
					}else {
						var No_time = "0";
						data =  "rd_time="+No_time;	
						
					}
					
					
					data += "&repair_type="+repair_type;
					data += "&report_job_id="+report_job_id;
					data += "&report_job_status="+report_job_status;
				}else {
					alert("กรุณาเลือกประเภทรายงาน");
					return false;
				}
				
				if(reporttype == "job_sale"){
					window.popupReport('job_report_sale.jsp?'+data,'1000','700');
				}else 
				if(reporttype == "job_part"){
					window.popupReport('job_report_part.jsp?'+data,'1000','700');
				}else 
				if(reporttype == "job_service"){	
					window.popupReport('job_report_service.jsp?'+data,'1000','700');
				}else 
				if(reporttype == "job_other"){	
					window.popupReport('job_report_other.jsp?'+data,'1000','700');
				}else 
				if(reporttype == "job_part_sum"){
					window.popupReport('job_report_part_sum.jsp?'+data,'1000','700');
				}else
				if(reporttype == "job_part_not_sale"){
					window.popupReport('job_report_not_sale.jsp?'+data,'1000','700');
				}else
				if(reporttype == "job_good_sale"){
					window.popupReport('job_report_good_sale.jsp?'+data,'1000','700');
				}else
				if(reporttype == "job_sale_detail"){
					 window.popupReport('job_report_sale_detail.jsp?'+data,'1000','700'); 
					//window.popupReport('job_report_sale_detail_new.jsp?'+data,'1000','700');
				}else
					if(reporttype == "job_sale_bill"){
						window.popupReport('job_report_sale_bill.jsp?'+data,'1000','700');
					}else				 
				if(reporttype == "job_sale_bill_print"){
					window.popupReport('job_report_sale_bill_print.jsp?'+data,'1000','700');
				}
			
			});
			
			$('#btn_export').click(function() {
				var reporttype = $("#report_type").val().trim();	
				var rd_time ="";	
				var date = $('#date').val();
				var date_start = $('#date_start').val();
				var date_end = $('#date_end').val();
				var month	 =$('#month').val();
				var year	 =$('#year').val();
								
				var repair_type  = $('#repair_type').val();
				var report_job_id  = $('#report_job_id').val();
				var report_job_status  = $('#report_job_status').val();
				
				 
				var data = "";
				
				if(reporttype != "0"){
					if( reporttype != "job_good_sale" ){
						if ($("input[type='radio'].rmd_time").is(':checked')) {
							rd_time = $('input[name=#tr_type_time #rd_time]:checked').val();
							//alert("Report Type :"+reporttype +" Time : "+rd_time );
												 
							if(rd_time == '1'){
								data =  "rd_time="+rd_time;
								if (date == "") {
									alert("คุณยังไม่ได้ระบุ วันที่ต้องการดูรายงาน");
									$('#date').focus();
									return false;
								}else {
									data += "&date="+date;
								}
								
				            }else if (rd_time == '2') {
				            	data =  "rd_time="+rd_time;
				            	if (date_start == "") {
									alert("คุณยังไม่ได้ระบุ วันที่เริ่มต้นที่ต้องการดูรายงาน");
									$('#date_start').focus();
									return false;
								}else {
									data += "&date_start="+date_start;
								}
				            	if (date_end == "") {
									alert("คุณยังไม่ได้ระบุ วันที่สินสุดที่ต้องการดูรายงาน");
									$('#date_end').focus();
									return false;
								}else {
									data += "&date_end="+date_end;
								}
								
								
							}else if (rd_time == '3') {
								data =  "rd_time="+rd_time;
								data += "&month="+month;
								data += "&year="+year;
							}
						
								
								data += "&export=true";
						
						} else {
							var No_time = "0";
							data =  "rd_time="+No_time;	
							data += "&export=true";
						}
					}
					else {
						var No_time = "0";
						data =  "rd_time="+No_time;	
						data += "&export=true";
					}
					
					data += "&repair_type="+repair_type;
					data += "&report_job_id="+report_job_id;
					data += "&report_job_status="+report_job_status;
					
				}else {
					alert("กรุณาเลือกประเภทรายงาน");
					return false;
				}
				
				if(reporttype == "job_sale"){
					window.popupReport('job_report_sale.jsp?'+data,'1000','700');
				}else 
				if(reporttype == "job_part"){
					window.popupReport('job_report_part.jsp?'+data,'1000','700');
				}else 
				if(reporttype == "job_service"){	
					window.popupReport('job_report_service.jsp?'+data,'1000','700');
				}else 
				if(reporttype == "job_other"){	
					window.popupReport('job_report_other.jsp?'+data,'1000','700');
				}else 
				if(reporttype == "job_part_sum"){
					window.popupReport('job_report_part_sum.jsp?'+data,'1000','700');
				}else
				if(reporttype == "job_part_not_sale"){
					window.popupReport('job_report_not_sale.jsp?'+data,'1000','700');
				}else
				if(reporttype == "job_good_sale"){
					window.popupReport('job_report_good_sale.jsp?'+data,'1000','700');
				}else
				if(reporttype == "job_sale_detail"){
					window.popupReport('job_report_sale_detail.jsp?'+data,'1000','700');
					//window.popupReport('job_report_sale_detail_new.jsp?'+data,'1000','700');
				}else
					if(reporttype == "job_sale_bill"){
						window.popupReport('job_report_sale_bill.jsp?'+data,'1000','700');
					}
					else
						if(reporttype == "job_sale_bill_print"){
							window.popupReport('job_report_sale_bill_print.jsp?'+data,'1000','700');
						}
								
			});
						
			var tr_repair_type = $('#tr_repair_type');
			var tr_job_number = $('#tr_job_number');
			var tr_status = $('#tr_status');
			var tr_type_time = $('#tr_type_time');
			$('#report_type').change(function(){							
				if ($(this).val() == "job_service" || $(this).val() == "job_other" || $(this).val() == "job_part_sum" || $(this).val() == "job_sum"  || $(this).val() == "0" ){					
					tr_repair_type.hide();
					tr_job_number.show();
					tr_status.show();
					tr_type_time.show();
					$('#btn_view').show();
					if( $('#tr_type_time #rd_time').is(":checked") ){ 
			            var val = $('input:radio[Name=rd_time]:checked').val(); 
			            if(val == '1'){
				            $('#tr_date').show();
				            $('#tr_date_date').hide();
				            $('#tr_month').hide();
			            }else if (val == '2') {
			            	$('#tr_date').hide();	
				            $('#tr_date_date').show();
				            $('#tr_month').hide();	
						}else if (val == '3') {
							$('#tr_date').hide();	
				            $('#tr_date_date').hide();
				            $('#tr_month').show();
						}
			        }
				}else if( $(this).val() == "job_sale_detail" ){
					tr_repair_type.hide();
					tr_job_number.show();
					tr_status.hide();
					tr_type_time.show();
					$('#btn_view').show();
					if( $('#tr_type_time #rd_time').is(":checked") ){ 
			            var val = $('input:radio[Name=rd_time]:checked').val(); 
			            if(val == '1'){
				            $('#tr_date').show();
				            $('#tr_date_date').hide();
				            $('#tr_month').hide();
			            }else if (val == '2') {
			            	$('#tr_date').hide();	
				            $('#tr_date_date').show();
				            $('#tr_month').hide();	
						}else if (val == '3') {
							$('#tr_date').hide();	
				            $('#tr_date_date').hide();
				            $('#tr_month').show();
						}
			        }					
					
				}else
					if( $(this).val() == "job_sale_bill" ){
						tr_repair_type.show();
						tr_job_number.show();
						tr_status.hide();
						tr_type_time.show();
						$('#btn_view').show();
						if( $('#tr_type_time #rd_time').is(":checked") ){ 
				            var val = $('input:radio[Name=rd_time]:checked').val(); 
				            if(val == '1'){
					            $('#tr_date').show();
					            $('#tr_date_date').hide();
					            $('#tr_month').hide();
				            }else if (val == '2') {
				            	$('#tr_date').hide();	
					            $('#tr_date_date').show();
					            $('#tr_month').hide();	
							}else if (val == '3') {
								$('#tr_date').hide();	
					            $('#tr_date_date').hide();
					            $('#tr_month').show();
							}
				        }					
						
				}else
					if( $(this).val() == "job_sale_bill_print" ){
						tr_repair_type.hide();
						tr_job_number.hide();
						tr_status.hide();
						tr_type_time.show();
						$('#btn_view').hide();							
						if( $('#tr_type_time #rd_time').is(":checked") ){ 
				            var val = $('input:radio[Name=rd_time]:checked').val(); 
				            if(val == '1'){
					            $('#tr_date').show();
					            $('#tr_date_date').hide();
					            $('#tr_month').hide();
				            }else if (val == '2') {
				            	$('#tr_date').hide();	
					            $('#tr_date_date').show();
					            $('#tr_month').hide();	
							}else if (val == '3') {
								$('#tr_date').hide();	
					            $('#tr_date_date').hide();
					            $('#tr_month').show();
							}
				        }					
						
				}else
				if( $(this).val() == "job_part_not_sale" ){
					tr_repair_type.hide();
					tr_job_number.hide();
					tr_status.hide();
					tr_type_time.show();
					$('#btn_view').show();
					if( $('#tr_type_time #rd_time').is(":checked") ){ 
			            var val = $('input:radio[Name=rd_time]:checked').val(); 
			            if(val == '1'){
				            $('#tr_date').show();
				            $('#tr_date_date').hide();
				            $('#tr_month').hide();
			            }else if (val == '2') {
			            	$('#tr_date').hide();	
				            $('#tr_date_date').show();
				            $('#tr_month').hide();	
						}else if (val == '3') {
							$('#tr_date').hide();	
				            $('#tr_date_date').hide();
				            $('#tr_month').show();
						}
			        }
				}else
				if( $(this).val() == "job_good_sale" ){
					tr_repair_type.hide();
					tr_job_number.hide();
					tr_status.hide();
					tr_type_time.hide();
					$('#btn_view').show();
					$('#tr_month').hide();
					$('#tr_date_date').hide();
					$('#tr_date').hide();
				}
				else {
					tr_repair_type.show();
					tr_job_number.show();
					tr_status.show();
					tr_type_time.show();
					$('#btn_view').show();
					if( $('#tr_type_time #rd_time').is(":checked") ){ 
			            var val = $('input:radio[Name=rd_time]:checked').val(); 
			            if(val == '1'){
				            $('#tr_date').show();
				            $('#tr_date_date').hide();
				            $('#tr_month').hide();
			            }else if (val == '2') {
			            	$('#tr_date').hide();	
				            $('#tr_date_date').show();
				            $('#tr_month').hide();	
						}else if (val == '3') {
							$('#tr_date').hide();	
				            $('#tr_date_date').hide();
				            $('#tr_month').show();
						}
			        }
				}
			});
					
		});
		
	</script>
    <%
    	Integer CurrentYear = WebUtils.getCurrentYear();
    	Integer minYear = jobTS.checkMinYear();
    	if(minYear == null){
    		minYear = CurrentYear;
    	}	
    %>
</head>
<body>


<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				Sale Reports
			</div>
			
			<div class="content_body txt_center">
				<form id="job_report_form" name="job_report_form" >
						<table class="s_auto">
							<tr>
								<td width="25%"></td>
								<td width="15%"></td>
								<td width="15%"></td>
								<td width="15%"></td>
								<td width="15%"></td>
								<td></td> 
							</tr>		
							<tr>
								<td align="right"></td>
								<td align="right" ><strong>เลือกรายงาน &nbsp;&nbsp;  : &nbsp;&nbsp;</strong></td>
								<td align="left" colspan="4"> 
									<bmp:ComboBox name="report_type"  styleClass="txt_box s200" value="">
										<bmp:option value="0"  text="--------  กรุณาเลือก -------"></bmp:option>
										<bmp:option value="job_sale" text="รายงานการขาย"></bmp:option>
										<bmp:option value="job_sale_bill" text="รายงานใบเสร็จฉบับเต็ม"></bmp:option>
										<bmp:option value="job_sale_bill_print" text="รายงานพิมพ์ใบเสร็จฉบับเต็ม"></bmp:option>
										<bmp:option value="job_sale_detail" text="รายงานการขายสรุปรวม"></bmp:option>
										<bmp:option value="job_part" text="รายงานสินค้าที่ขาย"></bmp:option>
										<bmp:option value="job_service" text="รายงานการขายบริการ"></bmp:option>
										<bmp:option value="job_other" text="รายงานการขายอื่นๆ"></bmp:option>
										<bmp:option value="job_good_sale" text="รายงานการสินค้าขายดี"></bmp:option>
										<bmp:option value="job_part_sum" text="รายงานสรุปสินค้าที่ขาย"></bmp:option>
										<bmp:option value="job_part_not_sale" text="รายงานสรุปสินค้าที่ไม่ได้ขาย"></bmp:option>										
									</bmp:ComboBox>
								</td>
							</tr>	
							<tr id="tr_repair_type" class="hide">
								<td align="right"></td>
								<td align="left" ><label title="ลักษณะการรับบริการ"><Strong>ประเภทงานบริการ</Strong></label>&nbsp;&nbsp; :</td>
								<td align="left" colspan="4"> 
									<bmp:ComboBox  name="repair_type" listData="<%=ServiceRepair.ddl_repair_type_th()%>" value="" styleClass="txt_box s150">
									<bmp:option value=""  text="--------  ALL -------"></bmp:option>
									</bmp:ComboBox>
									
								</td>
							</tr>	
							<tr id="tr_job_number" style="line-height: 30px">
								<td align="right"></td>
								<td align="right" ><strong> Job No. &nbsp;&nbsp;&nbsp; : &nbsp;&nbsp;</strong></td>
								<td align="left" colspan="4"> 
									<input type="text"  id="report_job_id"  name="report_job_id"  class="txt_box s150"" />
								</td>
							</tr>
							
							<tr id="tr_status">
								<td align="right"></td>
								<td align="right" ><strong>Status &nbsp;&nbsp; : &nbsp;&nbsp;</strong></td>
								<td align="left" colspan="4"> 	
									<bmp:ComboBox  name="report_job_status" styleClass="txt_box s150" listData="<%=ServiceSale.ddl_en() %>"  >
										<bmp:option value="" text="--- SHOW All ---"></bmp:option>
									</bmp:ComboBox> 
								</td>
							</tr>

							

							<tr>
								<td colspan="6">&nbsp;</td>
							</tr>
					<!-- /************************ New 07-03-2557 **********************************/ -->		
					<tr id="tr_type_time" >
						<td align="right" ></td>
						<td align="right"><strong>ช่วงเวลา&nbsp;&nbsp; : &nbsp;&nbsp; </strong></td>
						<td align="left" colspan="4">
							<input type="radio" name="rd_time" id="rd_time" value="1"  class="rmd_time" ><label for="type_date"> ประจำวัน</label> &nbsp;&nbsp;
							<input type="radio" name="rd_time" id="rd_time" value="2"  class="rmd_time" > <label for="type_date_date">ระหว่างวัน</label>&nbsp;&nbsp;
							<input type="radio" name="rd_time" id="rd_time" value="3"  class="rmd_time" > <label for="type_month"> ประจำเดือน</label> 
						
						</td>
					</tr>
					<tr>
								<td colspan="6">&nbsp;</td>
					</tr>
					<tr id="tr_date" class="hide">
						<td align="right" ></td>
						<td align="right"><strong>วันที่&nbsp;&nbsp; : &nbsp;&nbsp; </strong></td> 
						<td align="left" colspan="4"> 
						<input type="text" class="txt_box" name="create_date1" id="date"  readonly="readonly">						
						<input type="hidden" name="create_date" id="create_date" value="">
						</td>
						
					</tr>
					<tr id="tr_date_date" class="hide" >
					<td align="right" ></td>
					<td align="right" ><strong>ระหว่างวัน&nbsp;&nbsp; : &nbsp;&nbsp;</strong></td>
					<td align="left" colspan="4">
					<input type="text" class="txt_box" name="date1" id="date_start" readonly="readonly"> &nbsp;ถึงวันที่ &nbsp;
					<input type="text" class="txt_box" name="date2" id="date_end">
					<input type="hidden" name="date_send2" id="date_send2" value="" >
					<input type="hidden" name="date_send3" id="date_send3" value="">
					</td>	 
					</tr>
					<tr id="tr_month" class="hide">
						<td align="right" ></td>
						<td align="right" ><strong>เดือน / ปี &nbsp;&nbsp; : &nbsp;&nbsp;</strong></td>
						<td align="left" colspan="4"> 
							<bmp:ComboBox name="month" styleClass="txt_box s100" style="<%=ComboBoxTag.EngMonthList%>" value=""></bmp:ComboBox>						
							<select  name="year" id="year"  class="txt_box s100 txt_center"  >
									
										<%
											for(int year = CurrentYear; year >= minYear; year--){
												
												%>
													<option value="<%=year%>"><%=year%></option>
												<%
											}
										%>
										
							</select>
							
							
							<input type="hidden" name="year_month" id="year_month" value="">
						</td>
					</tr>
					
					<!-- /**********************************************************/ -->
					<%-- 		<tr class="day_from">
								<td align="right">	
									<input type="radio" name="job_report_choice_r"  id="job_report_choice_1"  class="job_report_choice_r"  value="1"  />	&nbsp;&nbsp;&nbsp;
								</td>
								<td align="left">
									 ระหว่างวันที่
								</td>
								<td align="left"  colspan="3">
									<input type="text"  id="report_job_startdate"  name="report_job_startdate"  readonly="readonly"  style="text-align: center;"   class="txt_box s100"  />
									&nbsp;&nbsp;&nbsp;
									ถึง
									&nbsp;&nbsp;&nbsp;
									<input type="text"  id="report_job_enddate"  name="report_job_enddate"  readonly="readonly"  style="text-align: center;"  class="txt_box s100"   />
								</td>
								<td></td>
								
							</tr>
							<tr style="line-height: 30px" class="month_from">
								<td align="right">	
									<input type="radio" name="job_report_choice_r" id="job_report_choice_2"  value="2"  class="job_report_choice_r"  />	&nbsp;&nbsp;&nbsp;
								</td>
								<td align="left" >
									 ประจำเดือน
								</td>
								<td align="left" colspan="4">
									<bmp:ComboBox  name="report_job_month"  styleClass="txt_box s100 txt_center" style="<%=ComboBoxTag.EngMonthList%>" value="">
									
									</bmp:ComboBox>
									&nbsp;&nbsp;&nbsp;
									<select  id="report_job_month_year"  name="report_job_month_year"   class="txt_box s100 txt_center"  >
									
										<%
											for(int year = CurrentYear; year >= minYear; year--){
												
												%>
													<option value="<%=year%>"><%=year%></option>
												<%
											}
										%>
										
									</select>
							
								</td>
								
							</tr> --%>
				<!-- /****************************************************************************/	 -->		
							<tr>
								<td colspan="6">&nbsp;</td>
							</tr>
							
							<tr>
								<td colspan="3" align="right">
									<span class="btn_box btn_confirm" id="btn_view">ดูรายงาน</span>
									&nbsp;&nbsp;
									 <span class="btn_box btn_confirm" id="btn_export">บันทึกเป็นไฟล์</span>
								</td>
								<td colspan="3" align="left">
								</td>
								
							</tr>
							
						</table>							
					</form>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
</body>
</html>
                                                                    