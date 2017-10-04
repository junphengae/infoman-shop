<%@page import="com.bitmap.bean.parts.PartSerial"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<%
	PartMaster entity = new PartMaster(); 
	WebUtils.bindReqToEntity(entity, request);
	PartMaster.select(entity);
	String sn = PartSerial.selectSN(entity.getPn());
%>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>

<script type="text/javascript">
	$(function(){
		var sn_qty = $('#sn_qty');
		$('#print_sn').click(function(){
			var value = sn_qty.val();
			var msg = $('#sn_msg_error');
			
			if (value == "" || value == "0") {
				sn_qty.focus();
				msg.text('Please input Qty of reprinted barcode!').slideDown('medium').delay(2500).slideUp('slow');
			} else {
				if (/^\d+$/.test(value)) {
					var url = 'print_barcode.jsp?' + $(this).attr('lang') + '&qty=' + sn_qty.val();
					var w = window.open(url,'barcode','location=0,toolbar=0,menubar=0,width=500,height=500');
					w.focus();
				} else {
					sn_qty.val('').focus();
					msg.text('Numeric is required!').slideDown('medium').delay(2500).slideUp('slow');
				}
			}
		});
	});
</script>

	<form id="infoForm" style="margin: 0;padding: 0;" onsubmit="return false;">
	<table cellpadding="3" cellspacing="3" border="0" class="s_auto center m_top10">
		<tbody>
			<tr>
				<td width="23%">Re-Printed Qty</td>
				<td>: <input type="text" name="sn_qty" id="sn_qty" class="txt_box s100 input_focus" value=""></td>
			</tr>
			<tr><td colspan="2" height="20"></td></tr>
			<tr>
				<td colspan="2" align="Center"> 
					<input type="button" id="print_sn" lang="<%="pn=" + entity.getPn() + "&sn=" + sn%>" class="btn_box" value="Print" >
				</td>
			</tr>
		</tbody>
	</table>
	
	<div class="msg_error"></div>
	</form>
				
</html>