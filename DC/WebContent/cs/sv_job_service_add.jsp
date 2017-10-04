<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<form id="service_add_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%" class="center" id="tb_material_add" border="0" cellpadding="4" cellspacing="4">
		<tbody>
			<tr>
				<td width="25%" align="left"><font color="red">*</font>Service Detail</td>
				<td width="75%" align="left">: 
				<select name="labor"  onchange="changeService(this.value);">
						<option value="0" >  เลือกการบริการ		</option>
						<option value="1" >  เปลี่ยนถ่ายน้ำมันเครื่องและใส้กรอง				</option>
						<option value="2" >  ถอดประกอบชิ้นส่วนอะไหล่ ประเภทที่ 1		</option>
						<option value="3" > ถอดประกอบชิ้นส่วนอะไหล่ ประเภทที่ 2  		</option>
						<option value="4" > ถอดประกอบชิ้นส่วนอะไหล่ ประเภทที่ 3		</option>
						<option value="5" > 	งานบริการยกเว้นค่าแรง     						</option>
				</select>
									
				<input type="hidden"  name="labor_id"  id="labor_id"  value=""/>
				<input type="hidden" name="labor_name" id="labor_name" value=""/>
				</td>
			</tr>
			<!-- <tr>
				<td align="left">Hour</td>
				<td align="left">: <input type="text" name="labor_qty" id="labor_qty" class="txt_box required" title="*" autocomplete="off"></td>
			</tr> -->
			<tr>
				<td align="left"><font color="red">*</font>Price</td>
				<td align="left">: <input type="text" name="labor_rate" id="labor_rate" class="txt_box" autocomplete="off" value="0"></td>
			</tr>
			<tr>
				<td align="left">Discount</td>
				<td align="left">: <input type="text" name="discount" id="discount" class="txt_box s50" value="0" autocomplete="off"> %</td>
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
	function changeService(value){
		if(value == '1'){
			document.getElementById('labor_id').value = "SV 01/001";
			document.getElementById('labor_name').value = "เปลี่ยนถ่ายน้ำมันเครื่องและใส้กรอง	";
			document.getElementById('labor_rate').value = "100.00";
		}else if(value == '2'){
			document.getElementById('labor_id').value = "SV 02/001";
			document.getElementById('labor_name').value = " ถอดประกอบชิ้นส่วนอะไหล่ ประเภทที่ 1	";
			document.getElementById('labor_rate').value = "80.00";
		}else if(value == '3'){
			document.getElementById('labor_id').value = "SV 02/002";
			document.getElementById('labor_name').value = " ถอดประกอบชิ้นส่วนอะไหล่ ประเภทที่ 2	";
			document.getElementById('labor_rate').value = "120.00";
		}else if(value == '4'){
			document.getElementById('labor_id').value = "SV 02/003";
			document.getElementById('labor_name').value = " ถอดประกอบชิ้นส่วนอะไหล่ ประเภทที่ 3	";
			document.getElementById('labor_rate').value = "200.00";
		}else if(value == '5'){
			document.getElementById('labor_id').value ="SV 10/001";
			document.getElementById('labor_name').value = "งานบริการยกเว้นค่าแรง";
			document.getElementById('labor_rate').value = "0.00";
		}

		
	}
	$(function(){
		
		var form = $('#service_add_form');	
		/*material Form*/
		var v = form.validate({
			submitHandler: function(){
				if ($('#labor').val() != '0') {
				if (isNumber($('#labor_rate').val())) {
					if (isNumber($('#discount').val())) {
						//if (isNumber($('#labor_qty').val())) {
							ajax_load();
							$.post('../PartSaleManage',form.serialize(),function(resData){			
								ajax_remove();
								if (resData.status == 'success') {
									window.location.reload();
								} else {
									alert(resData.status);
								}
							},'json');
					//	} else {
				//			alert('Please check Hour!');
				//			$('#labor_qty').focus();
				//		}
					} else {
						alert('โปรดตรวจสอบส่วนลด!');
						$('#discount').focus();
					}
				} else {
					alert('โปรดตรวจสอบราคา!');
					$('#labor_rate').focus();
				}
				} else {
					alert('โปรดเลือกประเภทงานบริการ');  
					$('#labor').focus();
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
		<input type="hidden" name="id" value="<%=WebUtils.getReqString(request, "id")%>">
		<input type="submit" name="add" class="btn_box btn_confirm" value="Submit">				
		<input type="button" class="btn_box btn_warn" value="Close Display" onclick="tb_remove();">				
		<input type="hidden" name="action" value="sale_service_add">
		<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>