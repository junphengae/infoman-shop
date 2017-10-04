<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="com.bitmap.bean.hr.LeaveType"%>
<%@page import="com.bitmap.bean.hr.Leave"%>
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
<title>ข้อมูลการลางาน </title>

<%
String per_id = WebUtils.getReqString(request,"per_id");
String page_ = WebUtils.getReqString(request, "page");
String keyword = WebUtils.getReqString(request, "keyword");
String year = WebUtils.getReqString(request, "year");
String month = WebUtils.getReqString(request, "month");
String leave_type_id = WebUtils.getReqString(request, "leave_type_id");

List params = new ArrayList();
if (year.length() == 0) {
	params.add(new String[]{"year",DBUtility.getCurrentYear() + ""});
} else {
	params.add(new String[]{"year",year});
}
params.add(new String[]{"per_id",per_id});
params.add(new String[]{"month",month});
params.add(new String[]{"keyword",keyword});
params.add(new String[]{"leave_type_id",leave_type_id});

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(35);

/* session.setAttribute("LEAVE_SEARCH", params);

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("LEAVE_SEARCH_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("LEAVE_SEARCH_PAGE")));
}
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("LEAVE_SEARCH_PAGE", page_);
}   */

session.setAttribute("ST_SEARCH", params);

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("ST_SEARCH_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("ST_SEARCH_PAGE")));
}

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("ST_SEARCH_PAGE", page_);
}
List list = Leave.selectWithCTRL(ctrl, params);
%>

<script type="text/javascript">
function delete_leave(leave_date,per_id,leave_type_id){
	if (confirm('ยืนยันลบรายการลางานวันที่ ' + leave_date + '!')) {
		 ajax_load();
	     $.post('../OrgManagement?action=leave_del_per&leave_date=' + leave_date + '&per_id=' + per_id + '&leave_type_id=' + leave_type_id,function(resData){	
			tb_remove();
				if (resData.status == 'success') {
		   	   		window.location.reload();
			} else {
				alert(resData.message);
			}
		},'json');
	}
}

function cancel_leave(leave_date,per_id,leave_type_id){
	if (confirm('ยืนยันการยกเลิกข้อมูลวันที่ ' + leave_date + '!')) {
		 ajax_load();
	     $.post('../OrgManagement?action=leave_cancel_per&leave_date=' + leave_date + '&per_id=' + per_id + '&leave_type_id=' + leave_type_id,function(resData){	
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
				<div class="left">รายชื่อพนักงาน &gt; ข้อมูลพนักงาน &gt; ข้อมูลการลางาน</div>
				<div class="right">
					<button type="button" class="btn_box btn_confirm thickbox" lang="leave_new.jsp?per_id=<%=per_id %>" title="เพิ่มรายการ ลางาน">เพิ่มรายการลา</button>
					<button type="button" class="btn_box" onclick="javascript:window.location='emp_info.jsp?per_id=<%=per_id%>';">ย้อนกลับ</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="leave_manage.jsp" id="search" method="get">
						<!-- ค้นหา: <input type="text" class="s150 txt_box" name="keyword" autocomplete="off"> &nbsp; -->
						วันที่ลางาน: 
						<bmp:ComboBox name="month" styleClass="txt_box s100" style="<%=ComboBoxTag.EngMonthList%>" value="<%=month%>">
								<bmp:option value="" text="--- ทั้งหมด ---"></bmp:option>
						</bmp:ComboBox>
						<bmp:ComboBox name="year" styleClass="txt_box s100" style="<%=ComboBoxTag.EngYearList%>" value="<%=year%>"></bmp:ComboBox>
						
						ประเภท:
						<bmp:ComboBox name="leave_type_id" styleClass="txt_box s100" listData="<%=LeaveType.dropdownLeaveType() %>" value="<%=leave_type_id%>">
								<bmp:option value="" text="--- ทั้งหมด ---"></bmp:option>
						</bmp:ComboBox>
								
						<input type="submit" name="submit" value="ค้นหา" class="btn_box s50 btn_confirm m_left5">
						<input type="button" name="reset" value="ล้าง" class="btn_box s50 m_left5" onclick="clear_form(this.form)">
						<input type="hidden" name="action" value="search">
						<input type="hidden" name="per_id" value="<%=per_id%>">
					</form>
				</div>
				<div class="right txt_center">
					<%=PageControl.navigator_en(ctrl,"leave_manage.jsp",params)%>
				</div>
				<div class="clear"></div>
				<div class="dot_line"></div>
				
				<table class="bg-image s_auto">
					<thead>
						<tr>
							<th valign="top" align="center" width="20%">วันที่ลางาน</th>
							<th valign="top" align="center" width="20%">ประเภท</th>
							<th valign="top" align="center" width="20%">สาเหตุ</th>
							<th valign="top" align="center" width="20%">สถานะ</th>
							<th></th>
						</tr>
					</thead>
					<tbody>
						<%
						boolean has=true;
						Iterator ite = list.iterator();
						while(ite.hasNext()) {
							Leave entity = (Leave) ite.next();	
							LeaveType type = entity.getUILeaveType(); 
							has = false;
						%>
						<tr>
							<td align="center"><%=WebUtils.getDateValue(entity.getLeave_date())%></td>
							<td align="center"><%=type.getLeave_detail() %></td>
							<td ><%=entity.getLeave_remark() %></td>
							<td align="center"><%=Leave.StatusMap(entity.getStatus()) %></td>
							
							
							
							<%-- <%
							// type = 5 6
							if(entity.getLeave_type_id().equalsIgnoreCase("5") || entity.getLeave_type_id().equalsIgnoreCase("6")){
								if (entity.getStatus().equalsIgnoreCase("3")) {
								//Pending
							%>
								<td>
									<button class="btn_box thickbox btn_confirm" lang="leave_confirm.jsp?height=250&width=480&modal=true&per_id=<%=entity.getPer_id()%>&leave_date=<%=WebUtils.getDateValue(entity.getLeave_date())%>">ยืนยัน</button>
									<button class="btn_box btn_del" onclick="cancel_leave('<%=WebUtils.getDateValue(entity.getLeave_date())%>','<%=entity.getPer_id()%>','<%=entity.getLeave_type_id() %>')" >ยกเลิก</button>
								</td>
							<%
								}else if(entity.getStatus().equalsIgnoreCase("1")){
								// approve
							%>
								<td>
									<button class="btn_box thickbox" lang="leave_edit.jsp?height=250&width=480&modal=true&per_id=<%=entity.getPer_id()%>&leave_date=<%=WebUtils.getDateValue(entity.getLeave_date())%>">แก้ไข</button>
									<button class="btn_box btn_del" onclick="cancel_leave('<%=WebUtils.getDateValue(entity.getLeave_date())%>','<%=entity.getPer_id()%>','<%=entity.getLeave_type_id() %>')" >ยกเลิก</button>
								</td>
							<%
								}else{
								// cancel -- แก้ไข แล้วเปลี่ยนสถานะเป็น Approve
							%>
								<td>
									<button class="btn_box thickbox" lang="leave_edit.jsp?height=250&width=480&modal=true&per_id=<%=entity.getPer_id()%>&leave_date=<%=WebUtils.getDateValue(entity.getLeave_date())%>">แก้ไข</button>
								</td>
							<%
								}
							}else{
								// type = 1 2 3 4 -- edit del
								
							%>
							<td>
								<button class="btn_box thickbox" lang="leave_edit.jsp?height=250&width=480&modal=true&per_id=<%=entity.getPer_id()%>&leave_date=<%=WebUtils.getDateValue(entity.getLeave_date())%>">แก้ไข</button>
								<button class="btn_box btn_del" onclick="cancel_leave('<%=WebUtils.getDateValue(entity.getLeave_date())%>','<%=entity.getPer_id()%>','<%=entity.getLeave_type_id() %>')" >ยกเลิก</button>
							</td>
							<%
							}
							%> --%>
							
							
							
							 <%
							// type = 5 6
							if(entity.getLeave_type_id().equalsIgnoreCase("5") || entity.getLeave_type_id().equalsIgnoreCase("6")){
							%>	
							<td>
								<button class="btn_box thickbox btn_confirm" lang="leave_confirm.jsp?height=250&width=480&modal=true&per_id=<%=entity.getPer_id()%>&leave_date=<%=WebUtils.getDateValue(entity.getLeave_date())%>">ยืนยัน</button>
								<button class="btn_box btn_del" onclick="cancel_leave('<%=WebUtils.getDateValue(entity.getLeave_date())%>','<%=entity.getPer_id()%>','<%=entity.getLeave_type_id() %>')" >ยกเลิก</button>
							</td>
							<%
							}else{
								// type = 1 2 3 4 -- edit del	
							%>
							<td>
								<button class="btn_box thickbox" lang="leave_edit.jsp?height=250&width=480&modal=true&per_id=<%=entity.getPer_id()%>&leave_date=<%=WebUtils.getDateValue(entity.getLeave_date())%>">แก้ไข</button>
								<button class="btn_box" onclick="delete_leave('<%=WebUtils.getDateValue(entity.getLeave_date())%>','<%=entity.getPer_id()%>','<%=entity.getLeave_type_id() %>')" >ลบ</button>
							</td>
							<%
								}
							%>
							
							
							
							
							
							
							
							
							
							<%-- <%
							if (entity.getLeave_type_id().equalsIgnoreCase("1")){
							%>
							<td>
								<button class="btn_box thickbox" lang="leave_edit.jsp?height=250&width=480&modal=true&per_id=<%=entity.getPer_id()%>&leave_date=<%=WebUtils.getDateValue(entity.getLeave_date())%>">แก้ไข</button>
								<button class="btn_box" onclick="delete_leave('<%=WebUtils.getDateValue(entity.getLeave_date())%>','<%=entity.getPer_id()%>','<%=entity.getLeave_type_id() %>')" >ลบ</button>
							</td> 
							<%
							}else if(entity.getLeave_type_id().equalsIgnoreCase("2")){
							%>
							<td>
								<button class="btn_box thickbox" lang="leave_edit.jsp?height=250&width=480&modal=true&per_id=<%=entity.getPer_id()%>&leave_date=<%=WebUtils.getDateValue(entity.getLeave_date())%>">แก้ไข</button>
								<button class="btn_box" onclick="delete_leave('<%=WebUtils.getDateValue(entity.getLeave_date())%>','<%=entity.getPer_id()%>','<%=entity.getLeave_type_id() %>')" >ลบ</button>
							</td> 
							<%
							}else if(entity.getLeave_type_id().equalsIgnoreCase("3")){
							%>
							<td>
								<button class="btn_box thickbox" lang="leave_edit.jsp?height=250&width=480&modal=true&per_id=<%=entity.getPer_id()%>&leave_date=<%=WebUtils.getDateValue(entity.getLeave_date())%>">แก้ไข</button>
								<button class="btn_box" onclick="delete_leave('<%=WebUtils.getDateValue(entity.getLeave_date())%>','<%=entity.getPer_id()%>','<%=entity.getLeave_type_id() %>')" >ลบ</button>
							</td> 
							<%
							}else if(entity.getLeave_type_id().equalsIgnoreCase("4")){
							%>
							<td>
								<button class="btn_box thickbox" lang="leave_edit.jsp?height=250&width=480&modal=true&per_id=<%=entity.getPer_id()%>&leave_date=<%=WebUtils.getDateValue(entity.getLeave_date())%>">แก้ไข</button>
								<button class="btn_box" onclick="delete_leave('<%=WebUtils.getDateValue(entity.getLeave_date())%>','<%=entity.getPer_id()%>','<%=entity.getLeave_type_id() %>')" >ลบ</button>
							</td> 
							<%
							}else if(entity.getLeave_type_id().equalsIgnoreCase("5")){
							%>
							<td>
								<button class="btn_box thickbox btn_confirm" lang="leave_confirm.jsp?height=250&width=480&modal=true&per_id=<%=entity.getPer_id()%>&leave_date=<%=WebUtils.getDateValue(entity.getLeave_date())%>">ยืนยัน</button>
								<button class="btn_box btn_del" onclick="delete_leave('<%=WebUtils.getDateValue(entity.getLeave_date())%>','<%=entity.getPer_id()%>','<%=entity.getLeave_type_id() %>')" >ยกเลิก</button>
							</td> 	
							<%
							}else{
							%>
							<td>
								<button class="btn_box thickbox btn_confirm" lang="leave_confirm.jsp?height=250&width=480&modal=true&per_id=<%=entity.getPer_id()%>&leave_date=<%=WebUtils.getDateValue(entity.getLeave_date())%>">ยืนยัน</button>
								<button class="btn_box btn_del" onclick="delete_leave('<%=WebUtils.getDateValue(entity.getLeave_date())%>','<%=entity.getPer_id()%>','<%=entity.getLeave_type_id() %>')" >ยกเลิก</button>
							</td>
							<% 
							}
							%> --%>
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