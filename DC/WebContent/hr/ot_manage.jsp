<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="com.bitmap.webutils.customtag.ComboBoxTag"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.hr.OTRequest"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
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
<title>ข้อมูล OT ของพนักงาน </title>

<%
String per_id = WebUtils.getReqString(request,"per_id");
String keyword = WebUtils.getReqString(request, "keyword");
String page_ = WebUtils.getReqString(request, "page");
String year = WebUtils.getReqString(request, "year");
String month = WebUtils.getReqString(request, "month");

List params = new ArrayList();
if (year.length() == 0) {
	params.add(new String[]{"year",DBUtility.getCurrentYear() + ""});
} else {
	params.add(new String[]{"year",year});
}
params.add(new String[]{"month",month});
params.add(new String[]{"keyword",keyword});

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);

session.setAttribute("OT_SEARCH", params);

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("OT_SEARCH_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("OT_SEARCH_PAGE")));
}

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("OT_SEARCH_PAGE", page_);
} 

List list = OTRequest.selectWithCTRL(ctrl, params, per_id);
%>

<script type="text/javascript">
function delete_ot(ot_date,per_id){
	if (confirm('ยืนยันลบรายการทำโอทีวันที่ ' + ot_date + '!')) {
		 ajax_load();
	     $.post('../OrgManagement?action=ot_del_per&ot_date=' + ot_date + '&per_id=' + per_id,function(resData){	
			tb_remove();
				if (resData.status == 'success') {
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
				<div class="left">รายชื่อพนักงาน &gt; ข้อมูลพนักงาน &gt; รายการ OT</div>
				<div class="right">
					<button type="button" class="btn_box btn_confirm thickbox" lang="ot_new.jsp?per_id=<%=per_id %>" title="เพิ่มรายการ OT">เพิ่มรายการ OT</button>
					<button type="button" class="btn_box" onclick="javascript:window.location='emp_info.jsp?per_id=<%=per_id%>';">ย้อนกลับ</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="ot_manage.jsp" id="search" method="get">
						<!-- ค้นหา: <input type="text" class="s150 txt_box" name="keyword" autocomplete="off"> &nbsp; -->
						วันที่ทำโอที: 
						<bmp:ComboBox name="month" styleClass="txt_box s100" style="<%=ComboBoxTag.EngMonthList%>" value="<%=month%>">
								<bmp:option value="" text="--- All ---"></bmp:option>
						</bmp:ComboBox>
						<bmp:ComboBox name="year" styleClass="txt_box s100" style="<%=ComboBoxTag.EngYearList%>" value="<%=year%>"></bmp:ComboBox>
								
						<input type="submit" name="submit" value="ค้นหา" class="btn_box s50 btn_confirm m_left5">
						<input type="button" name="reset" value="ล้าง" class="btn_box s50 m_left5" onclick="clear_form(this.form)">
						<input type="hidden" name="action" value="search">
						<input type="hidden" name="per_id" value="<%=per_id%>">
					</form>
				</div>
				<div class="right txt_center">
					<%=PageControl.navigator_en(ctrl,"ot_manage.jsp",params)%>
				</div>
				<div class="clear"></div>
				<div class="dot_line"></div>
				
				<table class="bg-image s_auto">
					<thead>
						<tr>
							<th valign="top" align="center" width="20%">วันที่ทำโอที</th>
							<th valign="top" align="center" width="15%">จำนวนชั่วโมง</th>
							<th valign="top" align="center" width="15%">อัตราค่าแรง</th>
							<th valign="top" align="center" width="35%">หมายเหตุ</th>
							<th width="10"></th>
						</tr>
					</thead>
					<tbody>
						<%
						boolean has=true;
						Iterator ite = list.iterator();
						while(ite.hasNext()) {
							OTRequest entity = (OTRequest) ite.next();	
							has = false;
						%>
						<tr>
							<td align="center"><%=WebUtils.getDateValue(entity.getOt_date()) %></td>
							<td align="center"><%=entity.getOt_hours()%></td>
							<td align="center"><%=entity.getOt_rate() %></td>
							<td><%=entity.getRemark() %></td>
							<td>
								<button class="btn_box thickbox" lang="ot_edit.jsp?per_id=<%=entity.getPer_id() %>&ot_date=<%=WebUtils.getDateValue(entity.getOt_date()) %>" title="แก้ไขรายการ OT">แก้ไข</button>
								<button class="btn_box btn_del" onclick="delete_ot('<%=WebUtils.getDateValue(entity.getOt_date())%>','<%=entity.getPer_id()%>')">ลบ</button>
							</td> 
						</tr>
						<% }
						if (has) { %>
							<tr><td colspan="5" align="center"> -- ไม่พบข้อมูล -- </td></tr>
						<% } %>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
</body>
</html>