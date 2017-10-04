<%@page import="com.bitmap.bean.parts.PartGroups"%>
<%@page import="com.bitmap.bean.parts.PartCategories"%>
<%@page import="com.bitmap.bean.parts.PartCategoriesSub"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Parts: </title>
<%
	PartMaster entity = new PartMaster(); 
	WebUtils.bindReqToEntity(entity, request);
	if(entity.getPn().equalsIgnoreCase("N-TAF-SPARK")){
	entity = PartMaster.selectLocation(entity.getPn());		
	}else{
	entity = PartMaster.select(entity.getPn());	
	}
%>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<script type="text/javascript">
	$(function(){
		
		var $form = $('#infoForm');
		
		$.metadata.setType("attr", "validate");
		var v = $form.validate({
			submitHandler: function(){
				
				var addData = $form.serialize() + '&action=edit_location';
				ajax_load();
				$.post('../PartManagement',addData,function(data){
					ajax_remove();
					if (data.status == 'success') {
						alert("อัพเดทข้อมูลตำแหน่งสินค้าเรียบร้อยแล้ว");						
						var urlredirect = 'part_info.jsp?pn='+$('#pn').val();						
						window.location =  urlredirect;
					} else {
						alert(data.message);
						$('#' + data.focus).focus();
					}
				},'json');
			}
		});
		
		$form.submit(function(){
			v;
			return false;
		});
				
	}); 
</script>
</head>
<body>

	<form id="infoForm" style="margin: 0;padding: 0;" onsubmit="return false;">
	<table cellpadding="3" cellspacing="3" border="0" class="s_auto center">
		<tbody>
			<tr>
				<td><Strong>Location</Strong></td>
				<td align="left">: <input type="text"  name="location" id="location" class="txt_box s200" value="<%=entity.getLocation()%>"></td>
			</tr>
							
			<tr align="center" valign="bottom" height="20">
				<td colspan="2" align="center">
				<br />
					<input type="hidden" name="pn" id="pn" value="<%=entity.getPn().trim()%>">
					<input type="submit" id="btnUpdate" value="Update" class="btn_box ">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">				
				</td>
			</tr>
			<tr><td colspan="2" align="center">	<div class="msg_error"></div></td></tr>	
		</tbody>
	</table>
	</form>
	
</body>
</html>