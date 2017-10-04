<%@page import="com.bitmap.security.SecurityUser"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script src="../js/jquery.validate.js" type="text/javascript"></script>
<%
String user_id = WebUtils.getReqString(request, "user_id");
SecurityUser user = SecurityUser.select(user_id);
%>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<script>
	$(function(){
		var $msg = $('.msg_error');
		var $form = $('#infoForm');
		
		var v = $form.validate({
			submitHandler: function(){
				add();
			}
		});
		
		$form.submit(function(){
			v;
			return false;
		});
		
		function add(){
			var addData = $form.serialize();
			$.post('../EmpManageServlet',addData,function(resData){
				if (resData.status == "success") {
					$msg.text('Update Success').show();
					tb_remove();
					window.location.reload();
				} else {
					alert('Error: ' + resData.message).show();
				}
			},'json');
		}
	});
</script>
<div>
	<form id="infoForm" style="margin: 0;padding: 0;">
	<input type="hidden" name="create_by" id="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="455px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>Employee Status</h3></td></tr>
			<tr>
				<td width="30%"><label>Status</label></td>
				<td align="left">: 
					<bmp:ComboBox name="active" styleClass="txt_box s200" value="<%=user.getActive()%>">
						<bmp:option value="true" text="Active"></bmp:option>
						<bmp:option value="false" text="Inactive"></bmp:option>
					</bmp:ComboBox>
				</td>
			</tr>
			
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="Update" class="btn_box btn_confirm">
					<input type="hidden" name="action" value="edit_status">
					<input type="hidden" name="user_id" value="<%=user.getUser_id()%>">
					<input type="reset" onclick="tb_remove();" value="Close" class="btn_box">
				</td>
			</tr>
		</tbody>
	</table>
	<div class="msg_error"></div>
	</form>

</div>