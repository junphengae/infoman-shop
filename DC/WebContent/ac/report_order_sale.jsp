<%@page import="com.bitmap.bean.inventory.Master"%>
<%@page import="com.bitmap.bean.branch.BranchMaster"%>
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
<title>Sale Order Report</title>
<script type="text/javascript">
 
$(function(){
	
	$( "#date" ).datepicker({
		showOtherMonths: true,
		selectOtherMonths: true,
		changeMonth: true
	});
	$( "#date1" ).datepicker({
		showOtherMonths: true,
		selectOtherMonths: true,
		changeMonth: true
	});
	$( "#date2" ).datepicker({
		showOtherMonths: true,
		selectOtherMonths: true,
		changeMonth: true
	});

	var form = $('#report_form');
	var tr_type_time = $('#tr_type_time');
	var tr_date = $('#tr_date');
	var tr_month = $('#tr_month');
	var tr_matcode = $('#tr_matcode');
	var tr_date_date = $('#tr_date_date');
	var tr_branch     = $('#tr_branch');
	var tr_type =  $('#tr_type');
	
	
	$('#btn_view').click(function(){
			
			 /* if (document.getElementById("type_date").checked == true){
				var dd = document.getElementById("date").value;
				var str = dd.split("/");
				var date_farmat_str = str[2]+"-"+str[1]+"-"+str[0];
				document.getElementById("create_date").value = date_farmat_str; 
			}
			else if (document.getElementById("type_month").checked == true){ 
				
				var mm = document.getElementById("month").value;
				var yy = document.getElementById("year").value;
			
				if(mm < 10){
					
					var ymd = yy+"-"+"0"+mm; 
					document.getElementById("year_month").value = ymd;
						
				}
				else{ 
				
				var ymd = yy+"-"+mm; 
				document.getElementById("year_month").value = ymd;
				}
				
			}
			else if (document.getElementById("type_date_date").checked == true){
				
				var dd1 = document.getElementById("date1").value;
				var str1 = dd1.split("/");
				var date_farmat_str1 = str1[2]+"-"+str1[1]+"-"+str1[0];
				document.getElementById("date_send2").value = date_farmat_str1;
				
				
				var dd2 = document.getElementById("date2").value;
				var str2 = dd2.split("/");
				var date_farmat_str2 = str2[2]+"-"+str2[1]+"-"+str2[0];
				document.getElementById("date_send3").value = date_farmat_str2;
				
			}
			if(document.getElementById("report_type").value != "1"){
				
				popup('report_review_order_sale.jsp?' + form.serialize());
			}
			else{
				
				alert("กรุณาเลือกประเภทรายงาน");
			} */
			
		if(document.getElementById("report_type").value != "1"){
			
			if (document.getElementById("report_type").value == "sale_order"  ){
				popup('report_review_order_sale.jsp?' + form.serialize());
			}else{
				if($('#report_type').val() == "sale_request"){
					popup('report_review_order_sale.jsp?' + form.serialize());
				}else{
					if($('#report_status').val() == "1"){
						alert("กรุณาเลือกสถานะ");
					}else {
						if (document.getElementById("type_date").checked || document.getElementById("type_month").checked ||  document.getElementById("type_date_date").checked == true) {
							
							 var date = $('#date').val();
							 var date1 = $('#date1').val();
							 var date2 = $('#date2').val();
							 
								 		if (document.getElementById("type_date").checked == true){
								 			if(date == ""){
												
												alert("คุณยังไม่ได้ระบุวันที่ต้องการดูรายงาน");
												$('#date').focus();
											}else{
												var dd = document.getElementById("date").value;
												var str = dd.split("/");
												var date_farmat_str = str[2]+"-"+str[1]+"-"+str[0];
												document.getElementById("create_date").value = date_farmat_str; 
												popup('report_review_order_sale.jsp?' + form.serialize());
											} 	
										}else if (document.getElementById("type_month").checked == true){ 
												var mm = document.getElementById("month").value;
												var yy = document.getElementById("year").value;
												
												if(mm < 10){
													var ymd = yy+"-"+"0"+mm; 
													document.getElementById("year_month").value = ymd;
												}else{ 
													var ymd = yy+"-"+mm; 
													document.getElementById("year_month").value = ymd;
												}
												popup('report_review_order_sale.jsp?' + form.serialize());
										}else if (document.getElementById("type_date_date").checked == true){
													if(date1 && date2  == ""){
														alert("คุณยังไม่ได้ระบุวันที่ต้องการดูรายงาน");
														$('#date2').focus();
													} else{
														if(date1 == ""){
															alert("คุณยังไม่ได้ระบุวันที่ต้องการดูรายงาน");
															$('#date1').focus();
														}
														else if(date2 == ""){
															alert("คุณยังไม่ได้ระบุวันที่ต้องการดูรายงาน");
															$('#date2').focus();
														}else{
															
															var dd1 = document.getElementById("date1").value;
															var str1 = dd1.split("/");
															var date_farmat_str1 = str1[2]+"-"+str1[1]+"-"+str1[0];
															document.getElementById("date_send2").value = date_farmat_str1;
															
															
															var dd2 = document.getElementById("date2").value;
															var str2 = dd2.split("/");
															var date_farmat_str2 = str2[2]+"-"+str2[1]+"-"+str2[0];
															document.getElementById("date_send3").value = date_farmat_str2;
															popup('report_review_order_sale.jsp?' + form.serialize());
															
														}
													} 
										}
											
										
											
						}else{
							alert("คุณยังไม่ได้ระบุวันที่ต้องการดูรายงาน");
												
						}
					}
					}
				  }//	
		}else{
			alert("กรุณาเลือกประเภทรายงาน");
		}	
					
			
	});
	
	$('#btn_export').click(function(){
		
		/* if (document.getElementById("type_date").checked == true){
			var dd = document.getElementById("date").value;
			var str = dd.split("/");
			var date_farmat_str = str[2]+"-"+str[1]+"-"+str[0];
			document.getElementById("create_date").value = date_farmat_str; 
		}
		else if (document.getElementById("type_month").checked == true){ 
			
			var mm = document.getElementById("month").value;
			var yy = document.getElementById("year").value;
		
			if(mm < 10){
				
				var ymd = yy+"-"+"0"+mm; 
				document.getElementById("year_month").value = ymd;
					
			}
			else{ 
			
			var ymd = yy+"-"+mm; 
			document.getElementById("year_month").value = ymd;
			}
			
		}
		else if (document.getElementById("type_date_date").checked == true){
			
			var dd1 = document.getElementById("date1").value;
			var str1 = dd1.split("/");
			var date_farmat_str1 = str1[2]+"-"+str1[1]+"-"+str1[0];
			document.getElementById("date_send2").value = date_farmat_str1;
			
			
			var dd2 = document.getElementById("date2").value;
			var str2 = dd2.split("/");
			var date_farmat_str2 = str2[2]+"-"+str2[1]+"-"+str2[0];
			document.getElementById("date_send3").value = date_farmat_str2;
			
		}
		
				if(document.getElementById("report_type").value != "1"){
					
				popup('report_review_order_sale.jsp?export=true&' + form.serialize());
				
				}
				else{
					alert("กรุณาเลือกประเภทรายงาน");
				} */
				
	if(document.getElementById("report_type").value != "1"){
			
			if (document.getElementById("report_type").value == "sale_order"  ){
				popup('report_review_order_sale.jsp?export=true&' + form.serialize());
			}else{
				if($('#report_type').val() == "sale_request"){
					popup('report_review_order_sale.jsp?export=true&' + form.serialize());
				}else{
					if($('#report_status').val() == "1"){
						alert("กรุณาเลือกสถานะ");
					}else {
						if (document.getElementById("type_date").checked || document.getElementById("type_month").checked ||  document.getElementById("type_date_date").checked == true) {
							
							 var date = $('#date').val();
							 var date1 = $('#date1').val();
							 var date2 = $('#date2').val();
							 
								 		if (document.getElementById("type_date").checked == true){
								 			if(date == ""){
												
												alert("คุณยังไม่ได้ระบุวันที่ต้องการดูรายงาน");
												$('#date').focus();
											}else{
												var dd = document.getElementById("date").value;
												var str = dd.split("/");
												var date_farmat_str = str[2]+"-"+str[1]+"-"+str[0];
												document.getElementById("create_date").value = date_farmat_str; 
												popup('report_review_order_sale.jsp?export=true&' + form.serialize());
											} 	
										}else if (document.getElementById("type_month").checked == true){ 
												var mm = document.getElementById("month").value;
												var yy = document.getElementById("year").value;
												
												if(mm < 10){
													var ymd = yy+"-"+"0"+mm; 
													document.getElementById("year_month").value = ymd;
												}else{ 
													var ymd = yy+"-"+mm; 
													document.getElementById("year_month").value = ymd;
												}
												popup('report_review_order_sale.jsp?export=true&' + form.serialize());
										}else if (document.getElementById("type_date_date").checked == true){
													if(date1 && date2  == ""){
														alert("คุณยังไม่ได้ระบุวันที่ต้องการดูรายงาน");
														$('#date2').focus();
													} else{
														if(date1 == ""){
															alert("คุณยังไม่ได้ระบุวันที่ต้องการดูรายงาน");
															$('#date1').focus();
														}
														else if(date2 == ""){
															alert("คุณยังไม่ได้ระบุวันที่ต้องการดูรายงาน");
															$('#date2').focus();
														}else{
															
															var dd1 = document.getElementById("date1").value;
															var str1 = dd1.split("/");
															var date_farmat_str1 = str1[2]+"-"+str1[1]+"-"+str1[0];
															document.getElementById("date_send2").value = date_farmat_str1;
															
															
															var dd2 = document.getElementById("date2").value;
															var str2 = dd2.split("/");
															var date_farmat_str2 = str2[2]+"-"+str2[1]+"-"+str2[0];
															document.getElementById("date_send3").value = date_farmat_str2;
															popup('report_review_order_sale.jsp?export=true&' + form.serialize());
															
														}
													} 
										}
											
										
											
						}else{
							alert("คุณยังไม่ได้ระบุวันที่ต้องการดูรายงาน");
												
						}
					}
					}
				  }//	
		}else{
			alert("กรุณาเลือกประเภทรายงาน");
		}	
		
	});
	
	$('#report_type').change(function(){
		if (($(this).val() == 'sale_request')) { 
			tr_matcode.hide();
			tr_type_time.hide();
			tr_date.hide();
			tr_month.hide();
			tr_branch.hide();
			tr_branch.show();
			tr_type.hide();
		}else if($(this).val() == 'sale_order'){
			tr_matcode.hide();
			tr_type_time.hide();
			tr_date.hide();
			tr_month.hide();
			tr_branch.hide();
			tr_branch.hide();
			tr_type.hide();
		}else if($(this).val() == 'sale_status_po'){
			tr_matcode.show();
			tr_type_time.show();
			$('input:radio[name=time]').removeAttr('checked');
			tr_date.hide();
			tr_month.hide();
			tr_type.show();
			tr_branch.hide();
			$('#branch').find('option[value='+provs+']').attr('selected','selected').trigger('lisz:updated'); 
		}else {
			tr_matcode.show();
			tr_type_time.show();
			$('input:radio[name=time]').removeAttr('checked');
			tr_date.hide();
			tr_month.hide();
			tr_branch.show();
			tr_type.show();
		}
	});
	
	$('#type_date').click(function(){
		tr_date.show();
		tr_month.hide();
		tr_date_date.hide();
	});
	
	$('#type_month').click(function(){
		tr_date.hide();
		tr_date_date.hide();
		tr_month.show();
	});
	$('#type_date_date').click(function(){
		tr_date.hide();
		tr_month.hide();
		tr_date_date.show();
		
	});
});
</script>
<style type="text/css">
body table td {padding: 3px 1px;}
</style>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				Sale Order Report
			</div>
			
			<div class="content_body">
			<form id="report_form">
				<table>
					<tr>
						<td width="100">ประเภท</td>
						<td>: 
							<bmp:ComboBox name="report_type" styleClass="txt_box s320" value="">
								<bmp:option value="1"  text="----------------  กรุณาเลือก   ----------------"></bmp:option>
								 <bmp:option  value="<%=ReportUtils.SALE_REQUEST%>" text="สรุปรายการสั่งซื้อ"></bmp:option> 
								<bmp:option value="<%=ReportUtils.SALE_ORDER%>" text="สรุปใบสั่งซื้อ "></bmp:option>
								<bmp:option value="<%=ReportUtils.SALE_STATUS_PR%>" text="รายการสั่งซื้อตามสถานะ "></bmp:option>
								<bmp:option value="<%=ReportUtils.SALE_STATUS_PO%>" text="รายการใบสั่งซื้อตามสถานะ "></bmp:option>
							</bmp:ComboBox>
						</td>
					</tr>
					<tr id="tr_type" class="hide">
						<td width="70">สถานะ</td>
						<td>: 
							<bmp:ComboBox name="report_status" styleClass="txt_box s320" value="">
								<bmp:option value="1"  text="----------------  กรุณาเลือก   ---------------"></bmp:option>
								<bmp:option value="00" text="Cancel"></bmp:option> 
								<bmp:option value="100" text="Closed "></bmp:option>
								<bmp:option value="10" text="Opening "></bmp:option>
								<bmp:option value="11" text="Request "></bmp:option>
								<bmp:option value="12" text="MA Request"></bmp:option> 
								<bmp:option value="15" text="Outsource Service"></bmp:option>
							</bmp:ComboBox>
						</td>
						
					</tr>
					<tr id="tr_branch" class="hide">
						<td width="70">สาขา</td>
						<td>:
							<bmp:ComboBox name="branch" styleClass="txt_box s320" listData="<%=BranchMaster.branchDropdown()%>" >
								<bmp:option value="all" text="-------------- เลือกทั้งหมด  ---------------"></bmp:option>
							</bmp:ComboBox> 
						</td>
					</tr>
					<tr id="tr_matcode" class="hide">
						<td>Job ID</td>
						<td>: 
							 <input type="text" class="txt_box" name="id" id="id" >
						</td>
					</tr>
					<tr id="tr_type_time" class="hide">
						<td>ช่วงเวลา</td>
						<td>: 
							<input type="radio" name="rd_time" id="type_date" value="1"> <label for="type_date"> ประจำวัน</label> &nbsp;&nbsp;
							<input type="radio" name="rd_time" id="type_month" value="2"> <label for="type_month"> ประจำเดือน</label> <br/>&nbsp;
							<input type="radio" name="rd_time" id="type_date_date" value="3"> <label for="type_date_date">ระหว่างวัน</label>
						</td>
					</tr>
					<tr id="tr_date" class="hide">
						<td>วันที่</td> 
						<td>: <input type="text" class="txt_box" name="create_date1" id="date">
								<input type="hidden" name="create_date" id="create_date" value="">
						</td>
						
					</tr>
					<tr id="tr_date_date" class="hide" >
						<td>ระหว่างวัน</td>
						<td>: <input type="text" class="txt_box" name="date1" id="date1"> &nbsp;ถึงวันที่ &nbsp;
							 	<input type="hidden" name="date_send2" id="date_send2" value="">
							  	<input type="text" class="txt_box" name="date2" id="date2"></td>
								<input type="hidden" name="date_send3" id="date_send3" value="">
					</tr>
					<tr id="tr_month" class="hide">
						<td>เดือน / ปี</td>
						<td>: 
							<bmp:ComboBox name="month" styleClass="txt_box s100" style="<%=ComboBoxTag.EngMonthList%>" value=""></bmp:ComboBox>
							<bmp:ComboBox name="year" styleClass="txt_box s100" style="<%=ComboBoxTag.EngYearList%>" value="null"></bmp:ComboBox>
							<input type="hidden" name="year_month" id="year_month" value="">
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
	