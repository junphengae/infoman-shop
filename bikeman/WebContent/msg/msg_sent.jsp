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
String request_by = WebUtils.getReqString(request, "request_by");

List paramList = new ArrayList();
if (year.length() == 0) {
	paramList.add(new String[]{"year",DBUtility.getCurrentYear() + ""});
} else {
	paramList.add(new String[]{"year",year});
}
paramList.add(new String[]{"month",month});
paramList.add(new String[]{"priority",priority});
paramList.add(new String[]{"request_by",request_by});
session.setAttribute("SO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(10);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

Iterator IteMsg = Msg.selectSentWithCTRL(ctrl, paramList, securProfile.getPersonal().getPer_id()).iterator();
%>
</head>
<body>
<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
			<b>Sent Message</b>
			<button class="btn_box right m_right15" onclick="javascript:history.back();">Back</button> 			
		</div>
		<div class="content_body">
			<div class="txt_center">
				<form style="margin: 0; padding: 0;" action="msg_list.jsp" id="searchForm" method="get">
				
					Sender: <input type="text" name="request_by" id="request_by" class="txt_box s200"  autocomplete="off"> 
					Priority: 
						<bmp:ComboBox name="status" styleClass="txt_box s100" value="<%=priority%>" listData="<%=Msg.PriorList()%>">
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
						<th align="center">Title</th>
						<th align="center">Receiver</th>
						<th align="center">Date</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<%
						while(IteMsg.hasNext()) {
							Msg msg = (Msg) IteMsg.next();
						
					%>
					<tr>
					<%-- 	<td><%=Ft_Msg.Priority(msg.getPriority()) %></td> --%>
						<td width="400"><%=msg.getTitle() %></td>
						<%-- <td><%=msg.getUIPer().getName()%> &nbsp; <%=msg.getUIPer().getSurname() %></td> --%>
						<td><%=msg.getUIReceiver() %></td>
						<td align="center"><%=WebUtils.getDateTimeValue(msg.getRequest_date()) %></td>
						<td align="center">
							<button class="btn_box" onclick="javascript: window.location='msg_view.jsp?msg_id=<%=msg.getMsg_id()%>';">View</button>
						</td>
					</tr>
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