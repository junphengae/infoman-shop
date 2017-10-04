<%@page import="com.bitmap.bean.hr.Msg"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>

<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.webutils.customtag.ComboBoxTag"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>General Message</title>
<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/thickbox.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%
String year = WebUtils.getReqString(request, "year");
String month = WebUtils.getReqString(request, "month");
String page_ = WebUtils.getReqString(request, "page");
String priority = WebUtils.getReqString(request, "priority");
String name = WebUtils.getReqString(request, "name");
String flag_read = WebUtils.getReqString(request, "flag_read");

List paramList = new ArrayList();
if (year.length() == 0) {
	paramList.add(new String[]{"year",DBUtility.getCurrentYear() + ""});
} else {
	paramList.add(new String[]{"year",year});
}
paramList.add(new String[]{"month",month});
paramList.add(new String[]{"priority",priority});
paramList.add(new String[]{"name",name});
paramList.add(new String[]{"flag_read",flag_read});

session.setAttribute("MSG_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(10);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

Iterator IteMsg = Msg.selectGeneralWithCTRL(ctrl, paramList, securProfile.getPersonal().getPer_id()).iterator();
%>


<!-- <script type="text/javascript">
	function delete_msg(msg_id,per_id){
		if (confirm('ยืนยันการลบข้อความ!')) {
			 ajax_load();
		     $.post('../OrgManagement?action=del_msg&msg_id=' + msg_id + '&per_id=' + per_id,function(resData){	
				tb_remove();
					if (resData.status == 'success') {
			   	   		window.location.reload();
				} else {
					alert(resData.message);
				}
			},'json');
		}
	}
</script> -->


</head>
<body>
<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
			<b>Message Box</b>
			<button class="btn_confirm btn_box right m_right15" onclick="javascript:window.location='msg_new.jsp';">New Message</button> 
			<button class="btn_box right m_right5" onclick="javascript:window.location='msg_sent.jsp';">Sent Box</button> 
		</div>
		<div class="content_body">
			<div class="txt_center">
				<form style="margin: 0; padding: 0;" action="msg_list.jsp" id="searchForm" method="get">
				
					Sender: <input type="text" name="name" id="name" class="txt_box s200" value="<%=name %>" autocomplete="off"> 
					Priority: 
						<bmp:ComboBox name="priority" styleClass="txt_box s100" value="<%=priority%>" listData="<%=Msg.PriorList()%>">
							<bmp:option value="" text="--- All ---"></bmp:option>
						</bmp:ComboBox>
					Status: 
						<bmp:ComboBox name="flag_read" styleClass="txt_box s100" listData="<%=Msg.FlagList() %>" value="<%=flag_read %>">
							<bmp:option value="" text="--- All ---"></bmp:option>
						</bmp:ComboBox>
					Date: 
						<bmp:ComboBox name="month" styleClass="txt_box s100" style="<%=ComboBoxTag.EngMonthList%>" value="<%=month%>">
							<bmp:option value="" text="--- All ---"></bmp:option>
						</bmp:ComboBox>
						<bmp:ComboBox name="year" styleClass="txt_box s100" style="<%=ComboBoxTag.EngYearList%>" value="<%=year%>"></bmp:ComboBox>
				
					<button type="submit" name="btn_search" value="true" class="btn_box btn_confirm">ค้นหา</button>
					<button type="button" name="btn_reset" id="btn_reset" class="btn_box" onclick="$('#search').val('');">ล้าง</button>
				</form>
			</div>
			<br/>
			<!-- next page -->  
				<div class="center txt_center m_right20"><%=PageControl.navigator_en(ctrl,"msg_list.jsp",paramList)%></div>
				<div class="clear"></div>
			<!-- next page  -->
			<table class="bg-image s_auto m_top5">
				<thead>
					<tr>
					<!-- 	<th></th> -->
						<th align="center">Status</th>
						<th align="center">Title</th>
						<th align="center">Sender</th>
						<th align="center">Date</th>
						
						<th></th>
					</tr>
				</thead>
				<tbody>
					<%
						while(IteMsg.hasNext()) {
							Msg msg = (Msg) IteMsg.next();
					%>
					
					
					
					<tr <%=(Msg.checkFlagRead(msg, securProfile.getPersonal().getPer_id()))?"class='txt_bold'":""%>>
					
						<td align="center">
							<%-- <%=(Msg.checkFlagRead(msg, securProfile.getPersonal().getPer_id()))?"New":"Read"%> --%>
							<% 
							boolean val = msg.checkFlagRead(msg, securProfile.getPersonal().getPer_id());
								if(val==true){
							%>
									<img alt="unread" src="../images/icon/unread.png" title="Unread">
								<%}else{ %>
									
									<img alt="read" src="../images/icon/read.png" title="Read">
								<%} %>
						</td>
					
						<td width="400" class="pointer" onclick="javascript: window.location='msg_view.jsp?msg_id=<%=msg.getMsg_id()%>';">
						
							<%if (msg.getPriority().equalsIgnoreCase(Msg.URGENT)) { %>		
									
									<img alt="Urgent" src="../images/icon/flag.png" title="Urgent"> &nbsp;  <%=msg.getTitle() %>
							<%}else {  %>
									<%=msg.getTitle() %>
							<%} %>
						</td>
						
					
							
						<td class="pointer" onclick="javascript: window.location='msg_view.jsp?msg_id=<%=msg.getMsg_id()%>';">
							<%=msg.getUIPer_Personal().getName()%> &nbsp; <%=msg.getUIPer_Personal().getSurname() %>
						</td>
						
						<td align="center" class="pointer" onclick="javascript: window.location='msg_view.jsp?msg_id=<%=msg.getMsg_id()%>';">
							<%=WebUtils.getDateTimeValue(msg.getRequest_date()) %>
						</td>
						
						
						
						<td>
							<button type="button" id="btn_view_msg" class="btn_box" onclick="javascript: window.location='msg_view.jsp?msg_id=<%=msg.getMsg_id()%>';">View</button> 
						</td>
					</tr>
					<%
						}
					%>
				</tbody> 
				
				<!-- <tbody>
					<tr>
						<td width="400">
						</td>
						<td>
						</td>
						<td align="center">
						</td>
						<td align="center">
						</td>
						<td>
						</td>
					</tr>
				</tbody> -->
				
				
			</table>
		</div>
		</div>
	</div>
</div>
</body>
</html>