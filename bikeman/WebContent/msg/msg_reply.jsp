
<%@page import="com.bitmap.bean.hr.Msg"%>
<%@page import="com.bitmap.webutils.WebUtils"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Reply Message</title>

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<%
String msg_id = WebUtils.getReqString(request, "msg_id");

Msg entity = new Msg();
WebUtils.bindReqToEntity(entity, request);
Msg.selectMsg(entity);
%>
<script type="text/javascript">
$(function(){	
	
	var form = $("#msg_send_form");
	var v = form.validate({
		submitHandler: function(){
			
			ajax_load();
			$.post('../EmpManageServlet',form.serialize(),function(resData){
				ajax_remove();
				if(resData.status == "success"){
					window.location='msg_list.jsp';
				}else{
					alert(resData.message);
				}
			},'json');
		}	
	});

 	form.submit(function(){	
 		v;
 		return false;
 	});
 	
});
</script>

</head>
<body>
	<fieldset class="fset center s700">
	<form id="msg_send_form" onsubmit="return false;">
		<input type="hidden" name="request_by" id="request_by" value="<%=securProfile.getPersonal().getPer_id()%>" >
		<input type="hidden" name="reference" id="reference" value="<%=entity.getMsg_id()%>" >
		<input type="hidden" name="receiver" id="receiver" value="<%=entity.getRequest_by()%>" >
		<table>
			<tr>
				<td width="100">From</td>
				<td><%=securProfile.getPersonal().getName() %> &nbsp; <%=securProfile.getPersonal().getSurname() %></td>
			</tr>
			<tr>
				<td>To</td>
				<td><input type="text" readonly="readonly" value="<%=entity.getUIPer_Personal().getName() %> &nbsp; <%=entity.getUIPer_Personal().getSurname() %>" class="txt_box s300" autocomplete="off"></td>
			</tr>
			<tr>
				<td>Title</td>
				<td><input value="RE: <%=entity.getTitle() %>" type="text" name="title" id="title" class="txt_box s300" autocomplete="off"></td>
			</tr>
			<tr>
				<td>Priority</td>
				<td>
					<bmp:ComboBox name="priority" listData="<%=Msg.PriorList()%>"  styleClass="txt_box s100">
					
					</bmp:ComboBox>
				</td>
			</tr>
			<tr>
				<td colspan="2"><hr></td>
			</tr>
			<tr valign="top">
				<td valign="top">Message</td>
				<td>
					<textarea name="message" id="message" class="txt_box s550 h300 input_focus">
						<%="\n\n\n<hr><i>title : " + entity.getTitle() + "\ndate: " + WebUtils.getDateTimeValue(entity.getRequest_date()) + "\n\n" + entity.getMessage() + "</i>"%>
					</textarea>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<button type="submit" name="submit" class="btn_box btn_confirm">Reply</button>
					<input type="hidden" name="action" value="msg_send">
					<button type="button" class="btn_box" onclick="tb_remove();">Close</button>
				</td>
			</tr>
		</table>
	</form>
	</fieldset>
</body>
</html>