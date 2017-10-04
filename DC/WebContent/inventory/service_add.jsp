<%@page import="com.bitmap.bean.sale.OrderItem"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<form id="service_add_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%"  class="center" border="0" >
		<tbody>
			<tr>
				<td align="right">รายการ:</td>
				<td align="left"><input type="text" class="txt_box required" autocomplete="off" id="description" name="description" title="ระบุรายการ!"></td>
			</tr>
			<tr>
				<td align="right">ราคา :</td>
				<td align="left">
					<input type="text" class="txt_box required" autocomplete="off" id="price" name="price" title="ระบุราคา!">
				</td>												
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
	$(function(){
		var form = $('#service_add_form');		
		var v = form.validate({
 			submitHandler: function(){	
				ajax_load();
				$.post('../SaleManage',form.serialize(),function(resData){			
					ajax_remove();
					if (resData.status == 'success') {
						window.location.reload();
					} else {
						alert(resData.status);
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
	
	<div class="txt_center m_top20">
		<input type="submit" name="add" class="btn_box btn_confirm" value="บันทึก">				
		<input type="button" class="btn_box btn_warn" value="ปิดหน้าจอ" onclick="tb_remove();">				
		<input type="hidden" name="action" value="service_add">	
		<input type="hidden" name="repair_id" value="<%=WebUtils.getReqString(request,"repair_id")%>">	
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>