<%@page import="com.bitmap.bean.hr.Msg"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.LinkControl"%>

<%@page import="com.bitmap.webutils.WebUtils"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>View Message</title>
<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script type="text/javascript" src="../js/jquery.metadata.js"></script>
<script type="text/javascript" src="../js/jquery.validate.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/thickbox.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<%
Msg entity = new Msg();
WebUtils.bindReqToEntity(entity, request);
Msg.selectMsg(entity);


if (Msg.checkFlagRead(entity, securProfile.getPersonal().getPer_id())){
 	Msg.updateFlagRead(entity, securProfile.getPersonal().getPer_id());
} 


%>
</head>
<body>
<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<b>View Message</b> 
				<button class="btn_box right m_right15" onclick="javascript: window.location='<%=LinkControl.link("msg_sent.jsp", (List)session.getAttribute("MSG_SEARCH"))%>';">back</button> 
			</div>
			<div class="content_body">
				<fieldset class="fset center s700">
					<input type="hidden" name="request_by" id="request_by" value="<%=securProfile.getPersonal().getPer_id()%>" >
					<table width="100%">
						<tr>
							<td width="100">From</td>
							<td><%=entity.getUIPer_Personal().getName()%> &nbsp; <%=entity.getUIPer_Personal().getSurname() %></td>
						</tr>
						<tr>
							<td>To</td>
							<td><%=entity.getUIReceiver()%></td>
						</tr>
						<tr>
							<td>Title</td>
							<td><%=entity.getTitle()%></td>
						</tr>
						<tr>
							<td>Priority</td>
							<td><%=Msg.Priority(entity.getPriority()) %></td>
						</tr>
						<tr>
							<td colspan="2"><hr></td>
						</tr>
						<tr valign="top">
							<td valign="top">Message</td>
							<td><%=entity.getMessage().replaceAll(" ", "&nbsp;").replaceAll("\n", "<br>")%></td>
						</tr>
						<tr>
							<td colspan="2" align="center">
								<button class="btn_box btn_confirm thickbox" title="Reply Message: '<%=entity.getTitle() %>'" lang="msg_reply.jsp?msg_id=<%=entity.getMsg_id()%>&width=750&height=500">Reply</button>
								
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
		</div>
	</div>
</div>
</body>
</html>