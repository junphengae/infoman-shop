<%@page import="com.bitmap.bean.dc.SaleServicePartDetail"%>
<%@page import="com.bitmap.bean.parts.ServicePartDetail"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%
SaleServicePartDetail entity = new SaleServicePartDetail();
WebUtils.bindReqToEntity(entity, request);
SaleServicePartDetail sspd = SaleServicePartDetail.select(entity.getId(), entity.getNumber());

%>


<form id="cutoff_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%" class="center" id="tb_material_add" border="0" cellpadding="4" cellspacing="4">
		<tbody>
			<tr>
				<td width="25%" align="left">PN</td>
				<td width="75%" align="left">: 
					<input type="text" class="txt_box required s180 input_focus" autocomplete="off" name="pn" id="pn" title="*">
				</td>
			</tr>
			<tr>
				<td width="25%" align="left">Qty had drawn</td>
				<td width="75%" align="left">: 
					<input type="text" class="txt_box required s100 input_focus" autocomplete="off" name="qty" id="qty" title="*">
				</td>
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
	$(function(){
		
		var form = $('#cutoff_form');	
		/*material Form*/
		
		
		var v = form.validate({
			submitHandler: function(){
				
				var qty = $('#qty').val();
				
				
				if (isNumber($('#qty').val())) {
					
				if (qty > <%=sspd.getCutoff_qty()%>) {
					alert("คุณคืนมากกว่าจำนวนที่ต้องคืน");
				}else {
					
					ajax_load();
					$.post('../PartSaleManage',form.serialize(),function(resData){			
						ajax_remove();
						if (resData.status == 'success') {
							window.location.reload();
						} else {
							alert(resData.message);
							$('#pn').val('').focus();
						}
					},'json');
				}
					
				}else{
					alert("กรุณากรอกเป็นตัวเลข");
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
		<input type="submit" name="add" class="btn_box btn_confirm" value="Return">				
		<input type="button" class="btn_box btn_warn" value="Close Display" onclick="tb_remove();">				
		<input type="hidden" name="action" value="return_parts_sale">
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
		
		
		<input type="hidden" name="job_id" value="<%=entity.getId()%>">
		<input type="hidden" name="draw_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>