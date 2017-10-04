<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.ServicePartDetail"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%
ServicePartDetail entity = new ServicePartDetail();
WebUtils.bindReqToEntity(entity, request);
ServicePartDetail.select(entity);

PartMaster pm = PartMaster.select(entity.getPn());
%>
<form id="update_discount_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%" class="center" id="tb_material_add" border="0" cellpadding="4" cellspacing="4">
		<tbody>
			<tr>
				<td width="25%" align="left">PN</td>
				<td width="75%" align="left">: <%=pm.getPn()%></td>
			</tr>
			<tr>
				<td align="left">Description</td>
				<td align="left">: <%=entity.getUIDescription()%></td>
			</tr>
			<tr>
				<td align="left">Stock Qty</td>
				<td align="left">: <span id="stock_qty"><%=pm.getQty() %></span></td>
			</tr>
			<tr>
				<td colspan="2"><div class="dot_line"></div></td>
			</tr>
			<tr>
				<td align="left">Qty</td>
				<td align="left">: <%=entity.getQty()%><input type="hidden" name="qty" id="qty" value="<%=entity.getQty()%>" autocomplete="off"></td>
			</tr>
			<tr>
				<td align="left">Price</td>
				<td align="left">: <input type="text" name="price" id="price" class="txt_box required" title="*" value="<%=entity.getPrice()%>" autocomplete="off"></td>
			</tr>
			<tr>
				<td align="left">Discount</td>
				<td align="left">: <input type="text" name="discount" id="discount" class="txt_box s50" value="<%=entity.getDiscount()%>" autocomplete="off"> %</td>
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
	
	$(function(){
		
		var form = $('#update_discount_form');	
		
		var v = form.validate({
			submitHandler: function(){
				if (isNumber($('#price').val())) {
					if (isNumber($('#discount').val())) {
						
						ajax_load();
						$.post('../PartSaleManage',form.serialize(),function(resData){			
							ajax_remove();
							if (resData.status == 'success') {
								window.location.reload();
							} else {
								alert(resData.status);
							}
						},'json');
						
					} else {alert('โปรดตรวจสอบส่วนลด!');
						$('#discount').focus();
					}
				} else {
					alert('โปรดตรวจสอบราคา!');
					$('#price').focus();
				}
			}
		});
		
		form.submit(function(){
			v;
			return false;
		});	
	});
	</script>
	
	<div class="txt_center m_top20">
		<input type="hidden" name="id" value="<%=entity.getId()%>">
		<input type="hidden" name="number" value="<%=entity.getNumber()%>">
		<input type="submit" name="add" class="btn_box btn_confirm" value="Submit">				
		<input type="button" class="btn_box btn_warn" value="Close Display" onclick="tb_remove();">				
		<input type="hidden" name="action" value="sale_part_update_detail">
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>