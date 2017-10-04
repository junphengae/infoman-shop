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
				msg.text('Please input Qty to be stocked!').slideDown('medium').delay(2500).slideUp('slow');
			} else {
				if (/^\d+$/.test(value)) {
					var url = 'print_barcode.jsp?' + $(this).attr('lang') + '&qty=' + sn_qty.val();
					var w = window.open(url,'barcode','location=0,toolbar=0,menubar=0,width=500,height=500');
					w.focus();
				} else {
					sn_qty.val('').focus();
					msg.text('Only Numeric is required !').slideDown('medium').delay(2500).slideUp('slow');
				}
			}
		});
	});
</script>

	<form id="infoForm" style="margin: 0;padding: 0;" onsubmit="return false;">
	<table cellpadding="3" cellspacing="3" border="0" class="s600 center">
		<tbody>
			<tr>
				<td width="23%"><label>Balance Qty</label></td>
				<td>: <%=entity.getQty()%></td>
			</tr>
			<tr>
				<td>Stored Qty</td>
				<td>: <input type="text" name="sn_qty" id="sn_qty" class="txt_box s100" value="0"></td>
			</tr>
		</tbody>
	</table>
	<div id="div_show_sn" class="s500 center m_top10">
		<div>
			<div class="s150 left">Balance Qty </div><div class="s10 left"> : </div>
			<div class="s200 left txt_16 txt_bold"><span id="total_qty_sn"><%=entity.getQty()%></span> หน่วย</div><div class="clear"></div>
		</div>
		<div>
			<div class="s150 left">Stored Qty </div><div class="s10 left"> : </div>
			<div class="s250 left">
				<div class="left"><input type="text" name="sn_qty" id="sn_qty" class="txt_box s100" value="0"></div> 
				<div class="left"><input type="button" id="print_sn" lang="<%="pn=" + entity.getPn() + "&sn=" + sn%>" class="btn_box " value="Print Barcode"></div>
				<div class="clear"></div>
			</div><div class="clear"></div>
		</div>
		
		<div class="dot_line" style="margin: 5px 0;"></div>
			
		<div class="btn_box center" id="btn_show_insert_sn">Store this Parts into Inventory</div>
		<div id="div_insert_sn" class="hide" style="margin-top: 5px;">
			<div>
				<div class="s150 left">Store this S/N Parts into Inventory </div><div class="s10 left"> : </div>
				<div class="s250 left"><input type="text" class="txt_box s150" id="pn_sn"> <input type="button" id="btn_save_pn_sn" class="btn_box" value="Save"></div><div class="clear"></div>
			</div>
		</div>
		
		<div class="msg_error" id="sn_msg_error"></div>
	</div>
	
	<div class="msg_error"></div>
	</form>
				
</html>