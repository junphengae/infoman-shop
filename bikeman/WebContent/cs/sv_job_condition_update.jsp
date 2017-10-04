<%@page import="com.bitmap.bean.parts.ServiceRepairCondition"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%
ServiceRepairCondition entity = new ServiceRepairCondition();
WebUtils.bindReqToEntity(entity, request);

ServiceRepairCondition.select(entity);
%>
<script type="text/javascript">
$(function(){
	$('#submit').click(function(){
		if ($("#con_detail").val() != '') {
			ajax_load();
			$.post('../PartSaleManage',$('#cond_form').serialize(),function(json){
				ajax_remove();
				if (json.status == 'success') {
					window.location.reload();
				} else {
					alert(json.message);
				}
			},'json');
		} else {
			$("#con_detail").focus();
		}
	});
});
</script>

<form id="cond_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%"  class="center" id="tb_material_add" border="0" cellspacing="4">
		<tbody>
			<tr>
				<td width="15%"><label title="จุดที่เป็นรอย">Point</label></td>
				<td width="85%">: 
					<%=entity.getCon_name()%>
					<input type="hidden" name="con_name" id="con_name" value="<%=entity.getCon_name()%>">
				</td>
			</tr>
			<tr valign="top">
				<td><label title="รายละเอียด">Detail</label></td>
				<td valign="top">: <input type="text" class="txt_box s300 input_focus" autocomplete="off" name="con_detail" id="con_detail" value="<%=entity.getCon_detail()%>">
				</td>
			</tr>
		</tbody>
	</table>
	
	<div class="txt_center m_top20">
		<input type="hidden" name="id" value="<%=entity.getId()%>">
		<input type="hidden" name="con_number" value="<%=entity.getCon_number()%>">
		<button type="submit" id="submit" class="btn_box btn_confirm">Submit</button>			
		<input type="button" class="btn_box btn_warn" value="Close Display" onclick="tb_remove();">				
		<input type="hidden" name="action" value="update_condition">
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>
