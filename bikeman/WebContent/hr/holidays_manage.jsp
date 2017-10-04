<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.hr.YearHolidays"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.webutils.customtag.ComboBoxTag"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="../js/jquery.min.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.min.js"></script>
<script src="../js/thickbox.js"></script>
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

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>วันหยุดประจำปี</title>


<%
String year = WebUtils.getReqString(request, "year");
List Hlist = YearHolidays.selectList(year); 
%>

<script type="text/javascript">
function delete_holiday(holidays_date,year) {
	if(confirm('ยืนยันการลบวันหยุด วันที่' + holidays_date + '!')){
		ajax_load();
		$.post('../OrgManagement?action=holidays_del&holidays_date=' + holidays_date + '&year=' + year,function(resData) {
			tb_remove();
				if (resData.status == 'success'){
					window.location.reload();
				} else {
					alert(resData.message);
				}
		},'json');
	}
}
</script>

</head>
<body>
<div class="wrap_all">
<jsp:include page="../index/header.jsp"></jsp:include>

	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">วันหยุดประจำปี</div>
				<div class="right">
					<button type="button" class="btn_box btn_confirm thickbox" lang="holidays_new.jsp?1=1" title="เพิ่มวันหยุดประจำปี">เพิ่มวันหยุดประจำปี</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="holidays_manage.jsp" id="search" method="get">
						ปี: <bmp:ComboBox name="year" styleClass="txt_box s100" style="<%=ComboBoxTag.EngYearList%>" value="<%=year%>"></bmp:ComboBox>
					
						<input type="submit" name="submit" value="ค้นหา" class="btn_box s50 btn_confirm m_left5">
						<input type="button" name="reset" value="ล้าง" class="btn_box s50 m_left5" onclick="clear_form(this.form)">
						<input type="hidden" name="action" value="search">
						<input type="hidden" name="year" value="<%=year%>">
					</form>
				</div>
				<div class="right txt_center">
					<%-- <%=PageControl.navigator_en(ctrl,"inlet.jsp",param)%> --%>
				</div>
				<div class="clear"></div>
				<div class="dot_line"></div>
				
				<table class="bg-image s_auto">
					<thead>
						<tr>
							<th valign="top" align="center" width="20%">วันที่</th>
							<th valign="top" align="center" width="25%">วันหยุด</th>
							<th valign="top" align="center" width="25%">หมายเหตุ</th>
							<th width="20%"></th>
						</tr>
					</thead>
					<tbody>
					 	<%
					 		//Iterator<YearHolidays> IteH = YearHolidays.selectList(year).iterator();
						 	boolean has = true;	
						 	Iterator ite = Hlist.iterator();							
						 	while (ite.hasNext()){
						 		YearHolidays holiday = (YearHolidays) ite.next();
						 		has = false;
					 	%>
						<tr>
							<td><%=WebUtils.getDateValue(holiday.getHolidays_date()) %></td>
							<td><%=holiday.getHolidays_name() %></td>
							<td><%=holiday.getRemark() %></td>
							<td>
								<button class="btn_box thickbox" lang="holidays_edit.jsp?year=<%=year%>&holidays_date=<%=WebUtils.getDateValue(holiday.getHolidays_date())%>"> แก้ไข </button>
							    <button class="btn_box btn_del" onclick="delete_holiday('<%=WebUtils.getDateValue(holiday.getHolidays_date())%>','<%=year%>')">ลบ</button>
							</td>
						</tr>
						<%
						 	}
						 	if (has){
						%>
							<tr><td colspan="4" align="center"> -- ไม่พบข้อมูล -- </td></tr>
						<%
						 	}
						%>
						
					</tbody>
				</table>
				
			</div>
			
			
		</div>
	</div>
</div>
</body>
</html>