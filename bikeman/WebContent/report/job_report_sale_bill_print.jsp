<%@page import="java.util.Collections"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Date"%>
<%@page import="com.bmp.web.service.transaction.SystemInfoTS"%>
<%@page import="com.bmp.special.fn.BMMoney"%>
<%@page import="com.bmp.lib.util.JMoney"%>
<%@page import="com.bitmap.utils.report.Mobile"%>
<%@page import="com.bitmap.bean.parts.ServiceRepair"%>
<%@page import="com.bitmap.utils.report.getTimeTH"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.report.job.TS.jobTS"%>
<%@page import="com.bitmap.report.job.bean.serviceInfoBean"%>
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
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/clear_form.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/popup.js"></script>
<script src="../js/number.js"></script>
<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.datepicker.js"></script>
<script src="../js/ui/jquery.ui.button.js"></script>
<script src="../js/ui/jquery.ui.position.js"></script>
<script src="../js/ui/jquery.ui.autocomplete.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<%
	String export = WebUtils.getReqString(request, "export");
	String rd_time = WebUtils.getReqString(request, "rd_time");
	
	String date = WebUtils.getReqString(request, "date");
	
	String date_start = WebUtils.getReqString(request, "date_start");
	String date_end = WebUtils.getReqString(request, "date_end");
	
	String month = WebUtils.getReqString(request, "month");
	String year = WebUtils.getReqString(request, "year");
	
	String repair_type = WebUtils.getAjaxReqString(request, "repair_type");
	String report_job_id = WebUtils.getAjaxReqString(request, "report_job_id");
	String report_job_status = WebUtils.getAjaxReqString(request, "report_job_status");

	 List paramList = new ArrayList();
	 String[] month_name = {
			 "",
			 "มกราคม ",  
			 "กุมภาพันธ์ ",  
			 "มีนาคม " , 
			 "เมษายน  ", 
			 "พฤษภาคม  ",
			 "มิถุนายน  ",
			 "กรกฎาคม   " , 
			 "สิงหาคม  ", 
			 "กันยายน  ",  
			 "ตุลาคม   " , 
			 "พฤศจิกายน  ", 
			 "ธันวาคม   " };
	 
	String HeaderDate = "";
	paramList.add(new String[]{"repair_type",repair_type});
	paramList.add(new String[]{"report_job_id",report_job_id});
	paramList.add(new String[]{"report_job_status",report_job_status});
	if(rd_time.equalsIgnoreCase("0")){
		HeaderDate ="";
	}else
	if(rd_time.equalsIgnoreCase("1")){
		if(! date.equalsIgnoreCase("")){
			HeaderDate = "วันที่  "+date;
			paramList.add(new String[]{"date",date});
		}
	}else
	if(rd_time.equalsIgnoreCase("2")){
		if(! date_start.equalsIgnoreCase("") && ! date_end.equalsIgnoreCase("")){
			HeaderDate = "ระหว่างวันที่ "+date_start+" ถึงวันที่ "+date_end;
			paramList.add(new String[]{"report_job_startdate",date_start});
			paramList.add(new String[]{"report_job_enddate",date_end});
		}
		
	}
	else
	if(rd_time.equalsIgnoreCase("3")){
		if(! month.equalsIgnoreCase("") && ! year.equalsIgnoreCase("")){
			HeaderDate = "ประจำเดือน "+month_name[WebUtils.getInteger(month)]+" ปี "+year;
			paramList.add(new String[]{"report_job_month",month});
			paramList.add(new String[]{"report_job_month_year",year});
		}
			
	}
	

	List<serviceInfoBean> list = null;
	
	list = jobTS.list_serviceBillInfo(paramList); 
	Iterator ite = list.iterator();
	
	String id = "0";
	String start_date = "0000-00-00";
	String end_date = "0000-00-00";
	Boolean hasCheck = false;
	List<Date> dates = new ArrayList<Date>();
	while(ite.hasNext()){
		hasCheck = true;				
		serviceInfoBean entity = (serviceInfoBean) ite.next();				
		Date close_date =  new Date(entity.getJob_close().getTime());
		dates.add(close_date);			
	} 	
	if(hasCheck){
		Date start = Collections.min(dates);
		Date end = Collections.max(dates);		
		start_date = WebUtils.getDateDBValue(start);
		end_date = WebUtils.getDateDBValue(end);
		System.out.println(start_date+" - "+end_date);
	}

%>

		<script type="text/javascript">
		$(function(){
		$('#sale_part_form').submit();
		});	
		</script>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>รายงานพิมพ์ใบเสร็จฉบับเต็ม</title>
		<body>	
		<form id="sale_part_form"  action="../ReportUtilsServlet" target="_blank"  method="post" onsubmit="return true;">
			<input type="hidden" name="start_date" value="<%=start_date%>">	
			<input type="hidden" name="end_date" value="<%=end_date%>">		
			<input type="hidden" name="type" value="OPENJOBBILL">
		
		</form>
		</body>



</html>
