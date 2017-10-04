
<%@page import="com.bitmap.bean.hr.Msg"%>
<%@page import="com.bitmap.webutils.WebUtils"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Create New Message</title>
<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/popup.js" type="text/javascript"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/thickbox.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>


<script type="text/javascript">


$(function(){	
	
	$('#btn_open_search').click(function(){
		popup('user_search.jsp');
	});
	
 	$("#msg_send_form").submit(function() {
		ajax_load();
		$.post('../EmpManageServlet',$(this).serialize(),function(resData){
			ajax_remove();
			if(resData.status == "success"){
				window.location='msg_list.jsp';
			}else{
				alert(resData.message);
			}
		},'json');
	});  
});
</script>

</head>
<body>
<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<b>Create New Message</b> 
				<button class="btn_box right m_right15" onclick="javascript: history.back();">back</button> 
			</div>
			<div class="content_body">
				<fieldset class="fset center s700">
				<form id="msg_send_form" onsubmit="return false;">
					<input type="hidden" name="request_by" id="request_by" value="<%=securProfile.getPersonal().getPer_id()%>" >
					<table>
						<tr>
							<td width="100">From</td>
							<td><%=securProfile.getPersonal().getName() %> &nbsp; <%=securProfile.getPersonal().getSurname() %></td>
						</tr>
						<tr>
							<td>To</td>
							<td><input type="text" name="receiver_name" id="receiver_name" readonly="readonly" class="txt_box s300 required" autocomplete="off">
								<input type="hidden" name="receiver" id="receiver">
								<button type="button" id="btn_open_search" class="btn_box">Search</button>
							</td>
						</tr>
						<tr>
							<td>Title</td>
							<td><input type="text" name="title" id="title" class="txt_box s300" autocomplete="off"></td>
						</tr>
						<tr>
							<td>Priority</td>
							<td>
								<bmp:ComboBox name="priority" listData="<%=Msg.PriorList()%>" styleClass="txt_box s100">
									
								</bmp:ComboBox>
							</td>
						</tr>
						<tr>
							<td colspan="2"><hr></td>
						</tr>
						<tr valign="top">
							<td valign="top">Message</td>
							<td><textarea name="message" id="message" class="txt_box s550 h300"></textarea></td>
						</tr>
						<tr>
							<td colspan="2" align="center">
							
								<button class="btn_box btn_confirm">Send</button>
								<input type="hidden" name="action" value="msg_send">
								<button class="btn_box" onclick="javascript:history.back();">Cancel</button>
							</td>
						</tr>
					</table>
				</form>
				</fieldset>
			</div>
		</div>
	</div>
</div>
</body>
</html>