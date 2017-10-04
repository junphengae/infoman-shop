<%@page import="com.bitmap.bean.hr.Late"%>
<%@page import="com.bitmap.bean.hr.Missing"%>
<%@page import="com.bitmap.bean.hr.Attendance"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.bitmap.bean.hr.YearHolidays"%>
<%@page import="com.bitmap.bean.hr.AttendanceTime"%>
<%@page import="com.bitmap.bean.hr.SalaryHistory"%>
<%@page import="com.bitmap.bean.hr.SumSalary"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.hr.OTRequest"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.bitmap.bean.hr.Leave"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.webutils.customtag.ComboBoxTag"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.bean.hr.Salary"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="../js/jquery.min.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/number.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/clear_form.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<%
String per_id = WebUtils.getReqString(request, "per_id");
String year = WebUtils.getReqString(request, "year");
String month = WebUtils.getReqString(request, "month");

List param = new ArrayList();
if (year.length() == 0) {
	year = DBUtility.getCurrentYear() + "";
	param.add(new String[]{"year",DBUtility.getCurrentYear() + ""});
} else {
	param.add(new String[]{"year",year});
}
if (month.length() == 0) {
	Calendar c = DBUtility.calendar();
	month = (c.get(Calendar.MONTH) + 1) + "";
	param.add(new String[]{"month",(c.get(Calendar.MONTH) + 1) + ""});
} else {
	param.add(new String[]{"month",month});
}
param.add(new String[]{"per_id",per_id});

SumSalary entity = SumSalary.select(param);




Calendar cd = DBUtility.calendar();
cd.set(Calendar.YEAR, WebUtils.getInteger(year));
cd.set(Calendar.MONTH, WebUtils.getInteger(month)-1);
cd.set(Calendar.DATE, 1);
cd.add(Calendar.MONTH, +1);
cd.add(Calendar.DATE, -1);
int dom = cd.get(Calendar.DAY_OF_MONTH);
Calendar sd = DBUtility.calendar();
sd.set(Calendar.YEAR, WebUtils.getInteger(year));
sd.set(Calendar.MONTH, WebUtils.getInteger(month)-1);

AttendanceTime at = AttendanceTime.select("1");
HashMap yh = YearHolidays.selectList(year, month);
HashMap ld = Leave.selectMap(year, month, per_id);

int total_missing = 0;
int total_late = 0;

for(int i=1;i<dom+1;i++){
	sd.set(Calendar.DATE, i);
	//System.out.print(WebUtils.DATE_DATABASE_FORMAT.format(sd.getTime()));
	// เช็คว่าเป็นวันหยุดประจำปีหรือไม่
	if (yh.get(WebUtils.DATE_DATABASE_FORMAT.format(sd.getTime())) == null) { // ถ้าวันที่นั้นเป็นค่าว่าง == ไม่ใช่วันหยุดประจำปี
	// กรณีไม่ใช่วันหยุดประจำปี == เป็นเสาร์ อาทิตย์หรือไม่?
		int day_flag  = sd.get(Calendar.SATURDAY);		
		if (day_flag == 7){  
			// กรณีเป็นวันเสาร์ == เช็คว่าทำงานวันเสาร์หรือไม่?
			//System.out.print(" - Saturday");
			if(at.getSat_flag().length() == 0){ 
				// กรณีทำงานวันเสาร์ == เช็คว่าขาดงานหรือไม่?
				//System.out.print(" \t- Working");
				Attendance attn = Attendance.select(sd.getTime(), per_id);			
				if(attn.getTime1().length()==0) {  
					// ขาดงาน == เช็คว่าเป็นวันลาหรือไม่
					//System.out.print(" \t- Absent");
						if (ld.get(WebUtils.DATE_DATABASE_FORMAT.format(sd.getTime())) == null ) {	//ถ้าวันที่นั้นเป็นค่าว่าง == ไม่ใช่วันลางาน										
							// ไม่ใช่วันลา == บันทึกว่าขาดงาน
							// Missing.insertOrUpdate(per_id, sd.getTime());
							Leave.insertOrUpdate(per_id, sd.getTime(), "6");
							//System.out.print(" missing");
						}else{ 
							//System.out.print(" leave");
							// เป็นวันลา == ไม่ทำอะไร	
								
						}
				}else{
					//System.out.print(" \t- Check late");
				    // ไม่ขาดงาน == เช็คว่าสายหรือไม่?
				    int h = WebUtils.getInteger(at.getTime_late().split("\\.")[0]);
				    int m = WebUtils.getInteger(at.getTime_late().split("\\.")[1]);
				    sd.set(Calendar.HOUR, h);
				    sd.set(Calendar.MINUTE, m);   
				    long std_in = sd.getTimeInMillis();
				    
				    h = WebUtils.getInteger(attn.getTime1().split("\\.")[0]);
				    m = WebUtils.getInteger(attn.getTime1().split("\\.")[1]);
				    sd.set(Calendar.HOUR, h);
				    sd.set(Calendar.MINUTE, m);
				    long per_in = sd.getTimeInMillis();	
				    
				    long result = std_in - per_in;
				    ////System.out.print(" long: " + std_in + " - " + per_in + " = " + (result<0));
				    if (result < 0 ){
				   		// สาย == บันทึกว่าสาย
				   		//System.out.print("\t - late");
				   		Leave.insertOrUpdate(per_id, sd.getTime(), "5");
				    }else {
				    	// ไม่สาย == ไม่ทำอะไร
				    	//System.out.print("\t - no late");
				    }		
				}
			}else{
				// กรณีไม่ทำงานวันเสาร์ == ไม่ทำอะไร
				//System.out.print(" - No working");
			}
		} else if (day_flag == 1){ 
			// กรณีเป็นวันอาทิตย์ == เช็คว่าทำงานวันอาทิตย์หรือไม่?
			//System.out.print(" - Sunday");
			if(at.getSun_flag().length() == 0){ 
				// กรณีทำงานวันอาทิตย์ == เช็คว่าขาดงานหรือไม่?
				//System.out.print(" - Working");
				Attendance attn = Attendance.select(sd.getTime(), per_id);			
				if(attn.getTime1().length()==0) {  
					// ขาดงาน == เช็คว่าเป็นวันลาหรือไม่
					//System.out.print(" \t- Absent");
						if (ld.get(WebUtils.DATE_DATABASE_FORMAT.format(sd.getTime())) == null ) {	//ถ้าวันที่นั้นเป็นค่าว่าง == ไม่ใช่วันลางาน										
							// ไม่ใช่วันลา == บันทึกว่าขาดงาน
							// Missing.insertOrUpdate(per_id, sd.getTime());
							Leave.insertOrUpdate(per_id, sd.getTime(), "6");
							//System.out.print(" missing");
						}else{ 
							//System.out.print(" leave");
							// เป็นวันลา == ไม่ทำอะไร		
						}
				}else{
					//System.out.print(" \t- Check late");
					 // ไม่ขาดงาน == เช็คว่าสายหรือไม่?
				    int h = WebUtils.getInteger(at.getTime_late().split("\\.")[0]);
				    int m = WebUtils.getInteger(at.getTime_late().split("\\.")[1]);
				    sd.set(Calendar.HOUR, h);
				    sd.set(Calendar.MINUTE, m);   
				    long std_in = sd.getTimeInMillis();
				    
				    h = WebUtils.getInteger(attn.getTime1().split("\\.")[0]);
				    m = WebUtils.getInteger(attn.getTime1().split("\\.")[1]);
				    sd.set(Calendar.HOUR, h);
				    sd.set(Calendar.MINUTE, m);
				    long per_in = sd.getTimeInMillis();	
				    
				    long result = std_in - per_in;
				    ////System.out.print(" long: " + std_in + " - " + per_in + " = " + (result<0));
				    if (result < 0 ){
				   		// สาย == บันทึกว่าสาย
				   		//System.out.print("\t - late");
				   		Leave.insertOrUpdate(per_id, sd.getTime(), "5");
				    }else {
				    	// ไม่สาย == ไม่ทำอะไร
				    	//System.out.print("\t - no late");
				    }				
				}
				
			}else{
				// กรณีไม่ทำงานวันอาทิตย์ == ไม่ทำอะไร
				//System.out.print(" \t- No working");
			}
		}else { 
			// กรณีเป็นวันธรรมดา == เช็คว่าขาดงานหรือไม่?
			//System.out.print(" - Weekdays");
			Attendance attn = Attendance.select(sd.getTime(), per_id);			
			if(attn.getTime1().length()==0) {  
				// ขาดงาน == เช็คว่าเป็นวันลาหรือไม่
				//System.out.print(" \t- Absent");
					if (ld.get(WebUtils.DATE_DATABASE_FORMAT.format(sd.getTime())) == null ) {	//ถ้าวันที่นั้นเป็นค่าว่าง == ไม่ใช่วันลางาน										
						// ไม่ใช่วันลา == บันทึกว่าขาดงาน
						// Missing.insertOrUpdate(per_id, sd.getTime());
						Leave.insertOrUpdate(per_id, sd.getTime(), "6");
						//System.out.print(" missing");
					}else{ 
						//System.out.print(" leave");
						// เป็นวันลา == ไม่ทำอะไร	
							
					}
			}else{
				//System.out.print(" \t- Check late");
				 // ไม่ขาดงาน == เช็คว่าสายหรือไม่?
			    int h = WebUtils.getInteger(at.getTime_late().split("\\.")[0]);
			    int m = WebUtils.getInteger(at.getTime_late().split("\\.")[1]);
			    sd.set(Calendar.HOUR, h);
			    sd.set(Calendar.MINUTE, m);   
			    long std_in = sd.getTimeInMillis();
			    
			    h = WebUtils.getInteger(attn.getTime1().split("\\.")[0]);
			    m = WebUtils.getInteger(attn.getTime1().split("\\.")[1]);
			    sd.set(Calendar.HOUR, h);
			    sd.set(Calendar.MINUTE, m);
			    long per_in = sd.getTimeInMillis();	
			    
			    long result = std_in - per_in;
			    ////System.out.print(" long: " + std_in + " - " + per_in + " = " + (result<0));
			    if (result < 0 ){
			   		// สาย == บันทึกว่าสาย
			   		//System.out.print("\t - late");
			   		//Late.insertOrUpdate(per_id, sd.getTime());
			   		Leave.insertOrUpdate(per_id, sd.getTime(), "5");
			    }else {
			    	// ไม่สาย == ไม่ทำอะไร
			    	//System.out.print("\t - no late");
			    }				
			}
		}
	} else {
		// กรณีเป็นวันหยุดประจำปี == ไม่ทำอะไร
		//System.out.print(" - Holiday");
	}	
	//System.out.println();
}

%>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>สรุปข้อมูลพนักงาน</title>
</head>
<body>
<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">สรุปข้อมูลพนักงาน ' <%=Personal.selectOnlyPerson(per_id).getName() %> <%=Personal.selectOnlyPerson(per_id).getSurname() %> '</div>
				<div class="right">
					<%-- <button class="btn_box" onclick="javascript: window.location='emp_info.jsp?per_id=<%=per_id%>';">ย้อนกลับ</button> --%>
					<!-- <button class="btn_box" onclick="javascript: window.location='emp_sum_salary.jsp';">ย้อนกลับ</button> -->
					<!-- <button class="btn_box" onclick="javascript: history.back();">ย้อนกลับ</button> -->
					<button class="btn_box" onclick="javascript: window.location='emp_sum_salary.jsp?per_id=<%=per_id%>&month=<%=month%>&year=<%=year%>';">ย้อนกลับ</button> 
				</div>
				<div class="clear"></div>
			</div>
				<%
					Salary salary = Salary.select(per_id);
				%>
			<div class="content_body">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="emp_summary.jsp" id="search" method="get">
						เดือน: 
						<bmp:ComboBox name="month" styleClass="txt_box s100" style="<%=ComboBoxTag.EngMonthList%>" value="<%=month%>">
								<bmp:option value="" text="--- ทั้งหมด ---"></bmp:option>
						</bmp:ComboBox>
						ปี:
						<bmp:ComboBox name="year" styleClass="txt_box s100" style="<%=ComboBoxTag.EngYearList%>" value="<%=year%>">
						</bmp:ComboBox>
						
						<input type="submit" name="submit" value="ค้นหา" class="btn_box s50 btn_confirm m_left5">
						<input type="button" name="reset" value="ล้าง" class="btn_box s50 m_left5" onclick="clear_form(this.form)">
						<input type="hidden" name="action" value="search">
						<input type="hidden" name="per_id" value="<%=per_id%>">
					</form>
				</div>
				<div class="clear"></div>
				<div class="dot_line"></div>
				
				<script type="text/javascript">
					
					$(function() {
						var salary_show = $('#total_salary_show');
						var salary_net_show = $('#salary_net_show');
						var tax_show = $('#tax_show');
						
						var i_salary = $('#total_salary');
						var i_salary_net = $('#salary_net');
						var i_bonus = $('#bonus');
						var i_diligence = $('#diligence');
						var i_bal_salary = $('#bal_salary');
						
						var i_allowance = $('#allowance');
						var i_missing = $('#missing');
						
						var i_ss = $('#ss');
						var i_savings = $('#savings');
						var i_pay_advance = $('#pay_advance');
						var i_deduction = $('#deduction');
						var i_tax_rate = $('#tax_rate');
						var i_tax = $('#tax');
						
						var i_leave_missing = $('#leave_missing');
						var i_missing = $('#missing');
						var i_salary_base = $('#salary');
												
						var total = 0;
						//var salary = parseFloat($('#salary').val());
						//var total_ot = parseFloat($('#total_ot').val());
						total = parseFloat($('#total').val());
						
						salary_show.text(total);
						salary_total();
						
						cal_ss();
						function cal_ss(){
							var s = 0;
							s = parseFloat(i_salary_base.val());
							s = s*0.05;
							//alert(s);
							if (s<=750){
								i_ss.val(s);
								//alert('<750');
							}else{
								s=750;
								i_ss.val(s);
								//alert('>750');
							}							
							
							salary_total();
						};
						
						cal_missing();
						function cal_missing(){
							
							var x = 0;
							x = parseFloat(i_leave_missing.val());
							x = x*200;
							//alert(x);
							i_missing.val(x);
							salary_total();
						};
						
						i_tax.blur(function(){
							salary_total();
						});
						
						
						i_diligence.blur(function(){
							salary_total();
						});
						
						i_bal_salary.blur(function(){
							salary_total();
						});
						
						i_allowance.blur(function(){
							salary_total();
						});
						
						i_missing.blur(function(){
							salary_total();
						});
						
						i_bonus.blur(function(){
							salary_total();
						});
						i_ss.blur(function() {
							salary_total();
						});
						i_savings.blur(function() {
							salary_total();
						});
						i_pay_advance.blur(function() {
							salary_total();
						});
						i_deduction.blur(function() {
							salary_total();
						});	
						i_tax_rate.blur(function() {	
							var sa = parseFloat(i_salary.val()); 
							var rate = parseFloat(i_tax_rate.val())/100;
							var tax_cal = sa * rate;
							i_tax.val(tax_cal);
							tax_show.text(money(tax_cal));
							salary_total();
						});
						
						function salary_total(){
							var bonus = 0; if(i_bonus.val() != ''){bonus = parseFloat(i_bonus.val());}
							var diligence = 0; if(i_diligence.val() != ''){diligence = parseFloat(i_diligence.val());}
							var bal_salary = 0; if(i_bal_salary.val() != ''){bal_salary = parseFloat(i_bal_salary.val());}
							
							var allowance = 0; if(i_allowance.val() != ''){allowance = parseFloat(i_allowance.val());}
							var missing = 0; if(i_missing.val() != ''){missing = parseFloat(i_missing.val());}
							var ss = 0; if(i_ss.val() != ''){ss = parseFloat(i_ss.val());}
							var savings = 0; if(i_savings.val() != ''){savings = parseFloat(i_savings.val());}
							var pay_advance = 0; if(i_pay_advance.val() != ''){pay_advance = parseFloat(i_pay_advance.val());}
							var deduction = 0; if(i_deduction.val() != ''){deduction = parseFloat(i_deduction.val());}
							var tax = 0; if(i_tax.val() != ''){tax = parseFloat(i_tax.val());}
							
							salary_show.text(money(total + bonus + diligence + allowance + bal_salary));
							i_salary.val(total + bonus + diligence + allowance + bal_salary);
							var income = parseFloat(i_salary.val());

							i_salary_net.val(income - tax - ss - savings - pay_advance - deduction - missing);
							salary_net_show.text(money(income - tax - ss - savings - pay_advance - deduction - missing));
						}
						
						var $msg = $('.msg_error');
						var $form = $('#sumForm');
						
						var v = $form.validate({
							submitHandler: function(){
								ajax_load();
								var addData = $form.serialize();
								$.post('../EmpManageServlet',addData,function(resData){
									ajax_remove();
									if (resData.status == "success") {
										alert('บันทึกข้อมูลเรียบร้อยแล้ว');
										window.location.reload();
									} else {	
										$msg.text('Error: ' + resData.message).show();
									}
								},'json');
							}
						});
						
						$form.submit(function(){
							v;
							return false;
						});
						
					});
				
				</script>
				
				<%
					if(entity.getMonth().length()==0) {		
				%>
				
				<form id="sumForm" onsubmit="return false;" style="margin: 0;padding: 0;">
				<input type="hidden" name="per_id" value="<%=per_id%>">
				<input type="hidden" name="salary_type" value="<%=salary.getSalary_type()%>">
				<input type="hidden" name="month" value="<%=month%>">
				<input type="hidden" name="year" value="<%=year%>">
				<input type="hidden" id="salary" name="salary" value="<%=salary.getSalary()%>">
				<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
					<fieldset class="fset">
						<legend>รายการเงินได้</legend>
						<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="95%">
							<tbody>
								<tr>
									<td align="left" width="30%">เดือน/ปี</td>
									<td align="left" width="70%">: <%=month %> / <%=year %></td>
								</tr>
							
								<tr>
									<td><label>ประเภทเงินเดือน</label></td>
									<td>: <%=Salary.salaryType(salary.getSalary_type()) %> </td>
								</tr>
								<tr>
									<td><label>ฐานเงินเดือน</label></td>
									<td>: <%=Money.money(salary.getSalary()) %> <% if (salary.getSalary().length()==0){}else{ %>&nbsp;บาท <%}%></td>
								</tr>
								<%
								 	String t = salary.getSalary_type() ;
									if (t.equals("1")) {
										
										String[] ot = OTRequest.count_ot(per_id, month, year, salary.getSalary());
								%>
								<tr>
									<td><label>จำนวนชั่วโมงโอที </label></td>
									<td>: <%=ot[0]%> <% if (ot[0].length()==0){}else{ %>&nbsp;ชั่วโมง<%}%>
											<input type="hidden" name="ot_hrs_sum" value="<%=ot[0]%>">  
									</td>
								</tr>
								<tr>
									<td><label>โอทีที่ได้รับ</label></td>
									<td>: <%=Money.money(ot[1])%> <% if (ot[1].length()==0){}else{ %>&nbsp;บาท<%}%> 
									<input type="hidden" id="total_ot" name="total_ot" value="<%=ot[1]%>">
									<input type="hidden" id="total" value="<%=Money.add(salary.getSalary(), ot[1])%>">
									</td>
								</tr>
								<%
										String iday = Money.add(salary.getSalary(), ot[1]);
								
									}
								%>
								
								<%-- <%
										String iday = Money.add(salary.getSalary(), ot[1]);
										////System.out.println("month :" + iday);
									
										
									}else{
										
										String[] coco = CocoTotal.count_coco(per_id, month, year);
								%>
								<tr>
									<td><label>จำนวนมะพร้าว</label></td>
									<td>: <%=coco[0] %> <% if (coco[0].isEmpty()){}else{ %>&nbsp;ลูก<%}%>  
											<input type="hidden" name="coco_sum" value="<%=coco[0] %>">
									</td>
								</tr>
								<tr>
									<td><label>ค่าแรงมะพร้าว </label></td>
									<td>: <%=Money.money(coco[1]) %> <% if (coco[1].isEmpty()){}else{ %>&nbsp;บาท<%}%>
									<input type="hidden" name="amount_coco_sum" value="<%=coco[1] %>">
									</td>
								</tr>
								<tr>
									<td><label>จำนวนมะพร้าวโอที </label></td>
									<td>: <%=coco[2] %> <% if (coco[2].isEmpty()){}else{ %>&nbsp;ลูก<%}%> 
											<input type="hidden" name="coco_ot_sum" value="<%=coco[2] %>">
									</td> 
								</tr>
								<tr>
									<td><label>ค่าแรงมะพร้าวโอที</label></td>
									<td>: <%=Money.money(coco[3]) %> <% if (coco[3].isEmpty()){}else{ %>&nbsp;บาท<%}%>
									<input type="hidden" name="amount_coco_ot_sum" value="<%=coco[3]%>">
									<input type="hidden" id="total" value="<%=Money.add(coco[1],coco[3])%>">
									</td>
								</tr>
								<%
										String iday = Money.add(coco[1],coco[3]);
										////System.out.println("day :" + iday );
									}
								%> --%>
								
								
								<tr>
									<td><label>โบนัส </label></td>
									<td>: <input type="text" name="bonus" id="bonus" class="txt_box"  autocomplete="off" > บาท</td>
								</tr>
								<tr>
									<td><label>เบี้ยขยัน </label></td>
									<td>: <input type="text" name="diligence" id="diligence" class="txt_box"  autocomplete="off" > บาท</td>
								</tr>
								<tr>
									<td><label>เบี้ยเลี้ยง</label></td>
									<td>: <input type="text" name="allowance" id="allowance" class="txt_box" autocomplete="off" > บาท</td>
								</tr>
								<tr>
									<td><label>เงินเดือนส่วนต่าง</label></td>
									<td>: <input type="text" name="bal_salary" id="bal_salary" class="txt_box" autocomplete="off" > บาท</td>
								</tr>
								<tr>
									<td><label>ยอดเงินรับ</label></td>
									<td>: <span id="total_salary_show"></span>
									<input type="hidden" id="total_salary" name="total_salary">
									</td>
								</tr>
								<tr>
									<td><label>เงินเดือนสุทธิ</label></td>
									<td>: <span id="salary_net_show"></span>
									<input type="hidden" id="salary_net" name="salary_net">
									</td>
								</tr>
							</tbody>
						</table>
					</fieldset>
				
					<fieldset class="fset">
						<legend>รายการเงินหัก</legend>
						<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="95%">
							<tbody>
								<tr>
									<td align="left" width="30%"></td>
									<td align="left" width="70%"></td>
								</tr>
								<tr>
									<td><label>ภาษี </label> <input type="text" name="tax_rate" id="tax_rate" class="txt_box s50" value="0" autocomplete="off" > %</td>
									<td>: 
										<input type="text" name="tax" id="tax" class="txt_box" > บาท
										<span class="hide" id="tax_show" ></span> 
									</td>
								</tr>
								<tr>
									<td><label>ประกันสังคม </label> </td>
									<td>: <input type="text" name="ss" id="ss" class="txt_box"  autocomplete="off" > บาท</td>
								</tr>
								<tr>
									<td><label>เงินสะสม</label></td>
									<td>: <input type="text" id="savings" name="savings" class="txt_box" autocomplete="off" > บาท</td>
								</tr>
								<tr>
									<td><label>เบิกล่วงหน้า</label></td>
									<td>: <input type="text" id="pay_advance" name="pay_advance" class="txt_box" autocomplete="off" > บาท</td>
								</tr>
								<tr>
									<td><label>ขาดงาน</label></td>
									<td>: <input type="text" id="missing" name="missing" class="txt_box"  autocomplete="off" > บาท</td>
								</tr>
								<tr>
									<td><label>เงินหักอื่นๆ </label></td>
									<td>: 
										<input type="text" id="deduction" name="deduction" class="txt_box" autocomplete="off" > 
										บาท
										<label> &nbsp; หมายเหตุ  &nbsp; </label>
										
										<input type="text" id="remark" name="remark" class="txt_box s250"  autocomplete="off" >
										</td>
								</tr>
								
							</tbody>
						</table>
					</fieldset>
					<%
							// ผลรวมวันลากิจในเดือนนี้
							String leave_b = Leave.count_leave(per_id, "2", month, year);
							// ผลรวมวันลาป่วยในเดือนนี้
							String leave_s = Leave.count_leave(per_id, "1", month, year);
							// ผลรวมวันลาพักร้อนในเดือนนี้
							String leave_v = Leave.count_leave(per_id, "3", month, year);
					%>
					<fieldset class="fset">
						<legend>สถิติการทำงาน</legend>
						
						<div class="left s600">
							<!-- <div class="box">  -->
								<table cellpadding="1" cellspacing="1" border="0" style="margin: 0 auto;" width="90%">
									<tbody>
										<tr>
											<td align="left" width="49%"></td>
											<td align="left" width="51%"></td>
										</tr>
										<%
										//String txt = Missing.count_missing_month(per_id, WebUtils.getCurrentDate());
										%>
										<tr>
											<td><label>มาสาย</label></td>
											<%
											//String cnt_late = Late.count_late_month(per_id, sd.getTime());
											String cnt_late = Leave.count_late_month(per_id, sd.getTime(), "5");
											Double sum_l = Double.parseDouble(cnt_late);
											%>
											<td> 
												<div title="รายละเอียด" class="thickbox pointer" lang="leave_view.jsp?per_id=<%=per_id%>&leave_type_id=5&leave_type_id1=0&month=<%=month%>&year=<%=year%>&width=800&height=650">: 
													<%-- <%=cnt_late %> --%>
													<%=sum_l %> &nbsp;วัน
													<input type="hidden" name="late_hrs_sum" value="<%=sum_l%>">
												</div>
											</td>
										</tr>
										<tr>
											<td><label>ขาดงาน</label></td>
											<% 
											  //String cnt_missing = Missing.count_missing_month(per_id, sd.getTime());
											 String cnt_missing = Leave.count_missing_month(per_id, sd.getTime(), "6");
											 
											 // หาค่าขาดงานครึ่งวัน
											 String mh_cnt = Leave.count_leave_half(per_id, "10", year, month);
											 Double sum_mh = Double.parseDouble(mh_cnt)/2;
											 Double sum_m = Double.parseDouble(cnt_missing)+sum_mh;
											%>
											<td>
												<div title="รายละเอียด" class="thickbox pointer" lang="leave_view.jsp?per_id=<%=per_id%>&leave_type_id=6&leave_type_id1=10&month=<%=month%>&year=<%=year%>&width=800&height=650">:  
													
													<%=sum_m %> &nbsp;วัน
													<input id="leave_missing" type="hidden" name="leave_missing" value="<%=sum_m %>">
												</div>
											</td>
										</tr>
										
										<%
										
										// หาค่าลากิจครึ่งวัน
										String cnt_half = Leave.count_leave_half(per_id, "8", year, month);		
										Double sum_hb = 0.0;
										sum_hb = Double.parseDouble(cnt_half)/2;
										////System.out.println(sum_hb);
										Double sum_b = 0.0;
										sum_b = Double.parseDouble(leave_b)+ sum_hb;
										////System.out.println(sum_b);
										
										// หาค่าลาป่วยครึ่งวัน
										String sh_cnt = Leave.count_leave_half(per_id, "7", year, month);
										Double sum_sh = Double.parseDouble(sh_cnt)/2;
										Double sum_s = Double.parseDouble(leave_s)+sum_sh;
										
										// หาค่าลาพักร้อนครึ่งวัน
										String vh_cnt = Leave.count_leave_half(per_id, "9", year, month);
										Double sum_vh = Double.parseDouble(vh_cnt)/2;
										Double sum_v = Double.parseDouble(leave_v)+sum_vh;
										%>
										
										<tr>
											<td><label>ลากิจ</label></td>
											<td> 
												<div title="รายละเอียด" class="thickbox pointer" lang="leave_view.jsp?per_id=<%=per_id%>&leave_type_id=2&leave_type_id1=8&month=<%=month%>&year=<%=year%>&width=800&height=650">: 
													<%=sum_b%>  <%if (Double.toString(sum_b).length()==0){ %> 0 <%}else{ %>&nbsp;วัน <%} %>
													<%-- <%=leave_b%>  <%if (leave_b.length()==0){}else{ %>&nbsp;วัน <%} %> --%>
													<input type="hidden" name="leave_business" value="<%=sum_b%>">
												</div>
											</td>
										</tr>
										
										<tr>
											<td><label>ลาป่วย</label></td>
											<td>
												<div title="รายละเอียด" class="thickbox pointer" lang="leave_view.jsp?per_id=<%=per_id%>&leave_type_id=1&leave_type_id1=7&month=<%=month%>&year=<%=year%>&width=800&height=650">: 
													<%=sum_s%>  <%if (Double.toString(sum_s).length()==0){}else{ %>&nbsp;วัน <%} %>
													<%-- <%=leave_s %> <% if (leave_s.length()==0){}else{ %>&nbsp;วัน <%}%>  --%>
													<input type="hidden" name="leave_sick" value="<%=sum_s%>">
												</div>
											</td>
										</tr>
										<tr>
											<td><label>ลาพักร้อน </label></td>
											<td> 
												<div title="รายละเอียด" class="thickbox pointer" lang="leave_view.jsp?per_id=<%=per_id%>&leave_type_id=3&leave_type_id1=9&month=<%=month%>&year=<%=year%>&width=800&height=650">: 
													<%=sum_v%>  <%if (Double.toString(sum_v).length()==0){}else{ %>&nbsp;วัน <%} %>
													<%-- <%=leave_v %> <% if (leave_v.length()==0){}else{ %>&nbsp;วัน <%}%> --%>
													<input type="hidden" name="leave_vacation" value="<%=sum_v%>">
												</div>
											</td>
										</tr>
										
									</tbody>
								</table>
							<!-- </div> -->
						</div>
						
						
						
						<div class="clear"></div>
					</fieldset>
					
					<fieldset class="fset">
					<legend>ประวัติเงินเดือน</legend>
						<table class="bg-image s_auto m_top5">
							<thead>
								
								<tr>
									<th width="10%" align="center">วันที่</th>
									<th width="10%" align="center">ฐานเงินเดือน</th>
								</tr>
							</thead>
							<tbody>
								<%
									Iterator<SalaryHistory> IteSh = SalaryHistory.selectList(per_id).iterator();
									while (IteSh.hasNext()) {
										SalaryHistory history = (SalaryHistory) IteSh.next();
									
								%>
								<tr>
									<td align="center"><%=WebUtils.getDateValue(history.getCreate_date()) %></td>
									<td align="center"><%=Money.money(history.getSalary_new()) %></td>
								</tr>
								<%
									}
								%>
							</tbody>
						</table>
					</fieldset>
					
					<div class="center txt_center m_top10">
						<input type="submit" id="btnAdd" value="บันทึก" class="btn_box btn_confirm">
						<input type="hidden" name="action" value="add_emp_sum">
					</div>
				</form>
			<%
					}else {
			%>
			
			<form id="editForm" onsubmit="return false;" style="margin: 0;padding: 0;">
				<input type="hidden" name="per_id" value="<%=per_id%>">
				<input type="hidden" name="salary_type" value="<%=salary.getSalary_type()%>">
				<input type="hidden" name="month" value="<%=month%>">
				<input type="hidden" name="year" value="<%=year%>">
				<input type="hidden" id="salary" name="salary" value="<%=salary.getSalary()%>">
				<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
					<fieldset class="fset">
						<legend>รายการเงินได้</legend>
						<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="95%">
							<tbody>
								<tr>
									<td align="left" width="30%">เดือน/ปี</td>
									<td align="left" width="70%">: <%=entity.getMonth()%> / <%=entity.getYear() %></td>
								</tr>
							
								<tr>
									<td><label>ประเภทเงินเดือน</label></td>
									<td>: <%=Salary.salaryType(entity.getSalary_type()) %> </td>
								</tr>
								<tr>
									<td><label>ฐานเงินเดือน</label></td>
									<td>: <%=Money.money(entity.getSalary()) %> <% if (entity.getSalary().length()==0){}else{ %>&nbsp;บาท <%}%></td>
								</tr>
								<%
								 	String t = salary.getSalary_type() ;
									if (t.equals("1")) {
								%>
								<tr>
									<td><label>จำนวนชั่วโมงโอที </label></td>
									<td>: <%=entity.getOt_hrs_sum()%> <% if (entity.getOt_hrs_sum().length()==0){}else{ %>&nbsp;ชั่วโมง<%}%>		
									</td>
								</tr>
								<tr>
									<td><label>โอทีที่ได้รับ</label></td>
									<td>: <%=Money.money(entity.getTotal_ot())%> <% if (entity.getTotal_ot().length()==0){}else{ %>&nbsp;บาท<%}%> 
									</td>
								</tr>
								<%
									}else{
								%>
								<tr>
									<td><label>จำนวนมะพร้าว</label></td>
									<td>: <%=entity.getCoco_sum() %> <% if (entity.getCoco_sum().length()==0){}else{ %>&nbsp;ลูก<%}%>  </td>
								</tr>
								<tr>
									<td><label>ค่าแรงมะพร้าว </label></td>
									<td>: <%=Money.money(entity.getAmount_coco_sum()) %> <% if (entity.getAmount_coco_sum().length()==0){}else{ %>&nbsp;บาท<%}%>
									</td>
								</tr>
								<tr>
									<td><label>จำนวนมะพร้าวโอที </label></td>
									<td>: <%=entity.getCoco_ot_sum() %> <% if (entity.getCoco_ot_sum().length()==0){}else{ %>&nbsp;ลูก<%}%> </td> 
								</tr>
								<tr>
									<td><label>ค่าแรงมะพร้าวโอที</label></td>
									<td>: <%=Money.money(entity.getAmount_coco_ot_sum()) %> <% if (entity.getAmount_coco_ot_sum().length()==0){}else{ %>&nbsp;บาท<%}%>
									</td>
								</tr>
								<%
									}
								%>
								<tr>
									<td><label>โบนัส </label></td>
									<td>: <%=Money.money(entity.getBonus()) %>  <% if (entity.getBonus().length()==0){}else{ %>&nbsp;บาท<%}%></td>
								</tr>
								<tr>
									<td><label>เบี้ยขยัน </label></td>
									<td>: <%=Money.money(entity.getDiligence()) %> <% if (entity.getDiligence().length()==0) {}else{%>&nbsp;บาท<%} %> </td>
								</tr>
								
								
								
								<tr>
									<td><label>เบี้ยเลี้ยง </label></td>
									<td>: <%=Money.money(entity.getAllowance()) %> <% if (entity.getAllowance().length()==0) {}else{%>&nbsp;บาท<%} %> </td>
								</tr>
								<tr>
									<td><label>เงินเดือนส่วนต่าง</label></td>
									<td>: <%=Money.money(entity.getBal_salary()) %></td>
								</tr>
								<tr>
									<td><label>ยอดเงินรับ</label></td>
									<td>: <%=Money.money(entity.getTotal_salary()) %> <% if (entity.getTotal_salary().length()==0) {}else{%>&nbsp;บาท<%} %>
									
									</td>
								</tr>
								<tr>
									<td><label>เงินเดือนสุทธิ</label></td>
									<td>: 
										<%=Money.money(entity.getSalary_net()) %> <% if (entity.getSalary_net().length()==0) {}else{%>&nbsp;บาท<%} %>
									</td>
								</tr>
							</tbody>
						</table>
					</fieldset>
				
					<fieldset class="fset">
						<legend>รายการเงินหัก</legend>
						<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="95%">
							<tbody>
								<tr>
									<td align="left" width="30%"></td>
									<td align="left" width="70%"></td>
								</tr>
								<tr>
									<td><label>ภาษี </label> <%=Money.money(entity.getTax_rate()) %> <% if (entity.getTax_rate().length()==0) {}else{%>&nbsp;%<%} %> </td>
									<td>: 
										<%=Money.money(entity.getTax()) %> <% if (entity.getTax().length()==0) {}else{%>&nbsp;บาท<%} %>
									</td>
								</tr>
								<tr>
									<td><label>ประกันสังคม </label> </td>
									<td>: <%=Money.money(entity.getSs()) %> <% if (entity.getSs().length()==0) {}else{%>&nbsp;บาท<%} %> </td>
								</tr>
								<tr>
									<td><label>เงินสะสม</label></td>
									<td>: <%=Money.money(entity.getSavings()) %> <% if (entity.getSavings().length()==0) {}else{%>&nbsp;บาท<%} %></td>
								</tr>
								<tr>
									<td><label>เบิกล่วงหน้า</label></td>
									<td>: <%=Money.money(entity.getPay_advance()) %> <% if (entity.getPay_advance().length()==0) {}else{%>&nbsp;บาท<%} %></td>
								</tr>
								<tr>
									<td><label>ขาดงาน</label></td>
									<td>: <%=Money.money(entity.getMissing()) %> <% if (entity.getMissing().length()==0) {}else{%>&nbsp;บาท<%} %></td>
								</tr>
								<tr>
									<td><label>เงินหักอื่นๆ </label></td>
									<td>: <%=Money.money(entity.getDeduction()) %> <% if (entity.getDeduction().length()==0) {}else{%>&nbsp;บาท<%} %></td>
								</tr>
								<tr>
									<td><label>หมายเหตุ</label></td>
									<td>: <%=entity.getRemark() %> <% if (entity.getRemark().length()==0) {%> - <%  }else{ %> <%} %></td>
								</tr>
							</tbody>
						</table>
					</fieldset>
					
				
					
					<fieldset class="fset">
						<legend>สถิติการทำงาน</legend>
						
						
						<%
							// ผลรวมวันลากิจในเดือนนี้
							String leave_b = Leave.count_leave(per_id, "2", month, year);
							// ผลรวมวันลาป่วยในเดือนนี้
							String leave_s = Leave.count_leave(per_id, "1", month, year);
							// ผลรวมวันลาพักร้อนในเดือนนี้
							String leave_v = Leave.count_leave(per_id, "3", month, year);
					%>
						<div class="left s600">
						
								<table cellpadding="1" cellspacing="1" border="0" style="margin: 0 auto;" width="90%">
									<tbody>
										<tr>
											<td align="left" width="49%"></td>
											<td align="left" width="51%"></td>
										</tr>
										<%
										//String txt = Missing.count_missing_month(per_id, WebUtils.getCurrentDate());
										%>
										<tr>
											<td><label>มาสาย</label></td>
											<%
											//String cnt_late = Late.count_late_month(per_id, sd.getTime());
											String cnt_late = Leave.count_late_month(per_id, sd.getTime(), "5");
											Double sum_l = Double.parseDouble(cnt_late);
											%>
											<td> 
												<div title="รายละเอียด" class="thickbox pointer" lang="leave_view.jsp?per_id=<%=per_id%>&leave_type_id=5&leave_type_id1=0&month=<%=month%>&year=<%=year%>&width=800&height=650">: 
													<%-- <%=cnt_late %> --%>
													<%=sum_l %> &nbsp;วัน
													<input type="hidden" name="late_hrs_sum" value="<%=sum_l%>">
												</div>
											</td>
										</tr>
										<tr>
											<td><label>ขาดงาน</label></td>
											<% 
											  //String cnt_missing = Missing.count_missing_month(per_id, sd.getTime());
											 String cnt_missing = Leave.count_missing_month(per_id, sd.getTime(), "6");
											 
											 // หาค่าขาดงานครึ่งวัน
											 String mh_cnt = Leave.count_leave_half(per_id, "10", year, month);
											 Double sum_mh = Double.parseDouble(mh_cnt)/2;
											 Double sum_m = Double.parseDouble(cnt_missing)+sum_mh;
											%>
											<td>
												<div title="รายละเอียด" class="thickbox pointer" lang="leave_view.jsp?per_id=<%=per_id%>&leave_type_id=6&leave_type_id1=10&month=<%=month%>&year=<%=year%>&width=800&height=650">:  
													
													<%=sum_m %> &nbsp;วัน
													<input type="hidden" name="leave_missing" value="<%=sum_m %>">
												</div>
											</td>
										</tr>
										
										<%
										
										// หาค่าลากิจครึ่งวัน
										String cnt_half = Leave.count_leave_half(per_id, "8", year, month);		
										Double sum_hb = 0.0;
										sum_hb = Double.parseDouble(cnt_half)/2;
										////System.out.println(sum_hb);
										Double sum_b = 0.0;
										sum_b = Double.parseDouble(leave_b)+ sum_hb;
										////System.out.println(sum_b);
										
										// หาค่าลาป่วยครึ่งวัน
										String sh_cnt = Leave.count_leave_half(per_id, "7", year, month);
										Double sum_sh = Double.parseDouble(sh_cnt)/2;
										Double sum_s = Double.parseDouble(leave_s)+sum_sh;
										
										// หาค่าลาพักร้อนครึ่งวัน
										String vh_cnt = Leave.count_leave_half(per_id, "9", year, month);
										Double sum_vh = Double.parseDouble(vh_cnt)/2;
										Double sum_v = Double.parseDouble(leave_v)+sum_vh;
										%>
										
										<tr>
											<td><label>ลากิจ</label></td>
											<td> 
												<div title="รายละเอียด" class="thickbox pointer" lang="leave_view.jsp?per_id=<%=per_id%>&leave_type_id=2&leave_type_id1=8&month=<%=month%>&year=<%=year%>&width=800&height=650">: 
													<%=sum_b%>  <%if (sum_b.SIZE == 0){ %> 0 <%}else{ %>&nbsp;วัน <%} %>
													<%-- <%=leave_b%>  <%if (leave_b.length()==0){}else{ %>&nbsp;วัน <%} %> --%>
													<input type="hidden" name="leave_business" value="<%=sum_b%>">
												</div>
											</td>
										</tr>
										
										<tr>
											<td><label>ลาป่วย</label></td>
											<td>
												<div title="รายละเอียด" class="thickbox pointer" lang="leave_view.jsp?per_id=<%=per_id%>&leave_type_id=1&leave_type_id1=7&month=<%=month%>&year=<%=year%>&width=800&height=650">: 
													<%=sum_s%>  <%if (sum_s.SIZE == 0){}else{ %>&nbsp;วัน <%} %>
													<%-- <%=leave_s %> <% if (leave_s.length()==0){}else{ %>&nbsp;วัน <%}%>  --%>
													<input type="hidden" name="leave_sick" value="<%=sum_s%>">
												</div>
											</td>
										</tr>
										<tr>
											<td><label>ลาพักร้อน </label></td>
											<td> 
												<div title="รายละเอียด" class="thickbox pointer" lang="leave_view.jsp?per_id=<%=per_id%>&leave_type_id=3&leave_type_id1=9&month=<%=month%>&year=<%=year%>&width=800&height=650">: 
													<%=sum_v%>  <%if (sum_v.SIZE == 0){}else{ %>&nbsp;วัน <%} %>
													<%-- <%=leave_v %> <% if (leave_v.length()==0){}else{ %>&nbsp;วัน <%}%> --%>
													<input type="hidden" name="leave_vacation" value="<%=sum_v%>">
												</div>
											</td>
										</tr>
										
									</tbody>
								</table>
			
						</div>
						
						
						
						
						
						
						
						
						
						
	<%-- 					<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="95%">
							<tbody>
								<tr>
									<td align="left" width="30%"></td>
									<td align="left" width="70%"></td>
								</tr>
								<tr>
									<td><label>มาสาย</label></td>
									<td>: 
									<input type="hidden" name="late_hrs_sum">
									</td>
								</tr>
								<tr>
									<td><label>ขาดงาน</label></td>
									<td>:
									<input type="hidden" name="leave_missing">
									</td>
								</tr>
								
								<tr>
									<td><label>ลากิจ</label></td>
	
									<td>: <%=entity.getLeave_business()%> <% if (entity.getLeave_business().length()==0) {}else{%>&nbsp;วัน<%} %>
									</td>									
								</tr>								
								<tr>
									<td><label>ลาป่วย</label></td>
									<td>: <%=entity.getLeave_sick()%> <% if (entity.getLeave_sick().isEmpty()) {}else{%>&nbsp;วัน<%} %>
									</td>
								</tr>
								<tr>
									<td><label>ลาพักร้อน </label></td>
									<td>: <%=entity.getLeave_vacation()%> <% if (entity.getLeave_vacation().isEmpty()) {}else{%>&nbsp;วัน<%} %>
									</td>
								</tr>
								<%
										String leave_b_y = Leave.count_leave_year(per_id, "2", year,month);
										int limit_b = Integer.parseInt(Salary.select(per_id).getLimit_business());
										int leav_b = Integer.parseInt(leave_b_y);
										int lb_total = limit_b - leav_b ;
										String slb_total = Integer.toString(lb_total);
								%> 
								<tr>
									<td><label>ลากิจคงเหลือ/ปี</label></td>
									<td>: <%=slb_total %> <% if (slb_total.isEmpty()){}else{ %>&nbsp;วัน <%}%> 
									<input type="hidden" name="bal_business" value="<%=slb_total%>">
									</td>
								</tr>
								<%
										String leave_s_y = Leave.count_leave_year(per_id, "1", year,month);
										int limit_s = Integer.parseInt(Salary.select(per_id).getLimit_sick());
										int leav_s = Integer.parseInt(leave_s_y);
										int ls_total = limit_s - leav_s;
										String sls_total = Integer.toString(ls_total);
								%> 
								<tr>
									<td><label>ลาป่วยคงเหลือ/ปี</label></td>
									<td>: <%=sls_total %> <% if (sls_total.isEmpty()){}else{ %>&nbsp;วัน <%}%> 
									<input type="hidden" name="bal_sick" value="<%=sls_total%>">
									</td>
								</tr>
								<%
										String leave_v_y = Leave.count_leave_year(per_id, "3", year,month);
										int limit_v = Integer.parseInt(Salary.select(per_id).getLimit_vacation());
										int leav_v = Integer.parseInt(leave_v_y);
										int lv_total = limit_v - leav_v ;
										String slv_total = Integer.toString(lv_total);
								%> 
								<tr>
									<td><label>ลาพักร้อนคงเหลือ/ปี</label></td>
									<td>: <%=slv_total %> <% if (slv_total.isEmpty()){}else{ %>&nbsp;วัน <%}%> 
									<input type="hidden" name="bal_vacation" value="<%=slv_total%>">
									</td>
								</tr>
								
								
															
								<tr>
									<td><label>ลากิจคงเหลือ/ปี</label></td>
									<td>: <%=entity.getBal_business()%> <% if (entity.getBal_business().isEmpty()) {}else{%>&nbsp;วัน<%} %>
									</td>
								</tr>						
								<tr>
									<td><label>ลาป่วยคงเหลือ/ปี</label></td>
									<td>: <%=entity.getBal_sick()%> <% if (entity.getBal_sick().isEmpty()) {}else{%>&nbsp;วัน<%} %>
									</td>
								</tr>
								<tr>
									<td><label>ลาพักร้อนคงเหลือ/ปี</label></td>
									<td>: <%=entity.getBal_vacation()%> <% if (entity.getBal_vacation().isEmpty()) {}else{%>&nbsp;วัน<%} %>
									</td>
								</tr>
								
								
								
								
							</tbody>
						</table> --%>
						
						
						
						
						
						
						
					</fieldset>
					
					<fieldset class="fset">
					<legend>ประวัติเงินเดือน</legend>
						<table class="bg-image s_auto m_top5">
							<thead>
								
								<tr>
									<th width="10%" align="center">วันที่</th>
									<th width="10%" align="center">ฐานเงินเดือน</th>
								</tr>
							</thead>
							<tbody>
								<%
									Iterator<SalaryHistory> IteSh = SalaryHistory.selectList(per_id).iterator();
									while (IteSh.hasNext()) {
										SalaryHistory history = (SalaryHistory) IteSh.next();
									
								%>
								<tr>
									<td align="center"><%= WebUtils.getDateValue(history.getCreate_date()) %></td>
									<td align="center"><%=Money.money(history.getSalary_new()) %></td>
								</tr>
								<%
									}
								%>
							</tbody>
						</table>
					</fieldset>

					<div class="center txt_center m_top10">
						<input type="button" id="btnEdit" value="แก้ไข" class="btn_box btn_confirm" onclick="javascript: window.location='emp_summary_edit.jsp?per_id=<%=per_id %>&month=<%=month%>&year=<%=year%>';">
					</div>
				</form>
			<%
					}
			%>
			</div>
			
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>

</body>
</html>