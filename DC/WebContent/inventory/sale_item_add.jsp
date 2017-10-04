<%@page import="com.bitmap.bean.sale.OrderItem"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>


<%
//InventoryMaster mat = new InventoryMaster();
//InventoryMaster.select()
%>
<form id="material_add_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%"  class="center" id="tb_material_add" border="0" >
		<tbody>
			<tr>
				<td width="30%" align="right">เลือกอะไหล่ :</td>
				<td width="70%" align="left">
					<input type="text" class="txt_box required" readonly="readonly" name="mat_code" id="request_by_autocomplete" title="ระบุอะไหล่่่่่่่!">											
					<button id="btn_item_search" class="btn_box">ค้นหาอะไหล่</button>
				</td>
			</tr>
			<tr>
				<td align="right">ชื่ออะไหล่:</td>
				<td align="left"><span id="mat_name"></span></td>
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
	$('#btn_item_search').click(function(){
		popup('fg_item_search.jsp');
	});
	
	$(function(){
			var form = $('#material_add_form');		
			var v = form.validate({
	 			submitHandler: function(){	
					ajax_load();
					$.post('../SaleManage',form.serialize(),function(resData){			
						ajax_remove();
						if (resData.status == 'success') {
							window.location.reload();
						} else {
							if (resData.message.indexOf('Duplicate entry') > 0) {
								alert('คุณเลือกรายการสินค้าซ้ำ กรุณาเลือกใหม่อีกครั้ง!');
								$('#request_by_autocomplete').val('');
							} else {
								alert(resData.status);
							}
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
		<input type="hidden" name="order_id" value="<%=WebUtils.getReqString(request, "order_id")%>">
		<input type="hidden" name="status" value="10">
		<input type="hidden" name="repair_id" value="<%=WebUtils.getReqString(request, "repair_id")%>">
		<input type="hidden" name="qty" value="1">		
		<input type="submit" name="add" class="btn_box btn_confirm" value="บันทึก">				
		<input type="button" class="btn_box btn_warn" value="ปิดหน้าจอ" onclick="tb_remove();">				
		<input type="hidden" name="action" value="borrow_add">	
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>