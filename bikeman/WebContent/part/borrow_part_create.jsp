<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.parts.PartGroups"%>
<%@page import="com.bitmap.bean.parts.PartCategories"%>
<%@page import="com.bitmap.bean.parts.PartCategoriesSub"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script src="../js/validator.js"></script>

<%
	String pn = request.getParameter("pn"); 
	PartMaster entity = new PartMaster(); 
	entity.setPn(pn);
	entity = PartMaster.select(entity);
	String UnitDesc = UnitType.selectName(PartMaster.SelectUnitDesc(pn.trim()));
	
%>
<script type="text/javascript">
function validCurrencyOnKeyUp(thisObj, thisEvent) {
	  var temp = thisObj.value;
	  temp = currencyToNumber(temp); // convert to number
	  thisObj.value = formatCurrency(temp);// convert to currency forma
}

function validNumberOnKeyUp(thisObj, thisEvent) {
	  var temp = thisObj.value;
	  temp = currencyToNumber(temp); // convert to number
	  thisObj.value = formatIntegerWithComma(temp);// convert to currency format
}
</script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>


	<table cellpadding="3" cellspacing="3" border="0" class="s_auto">
		<tbody>
			<tr>
				<td width="30%"><label>Part Number</label></td>
				<td>: <%=entity.getPn()%></td>
			</tr>
			<tr valign="top">
				<td><label>รายละเอียด</label></td>
				<td align="left">: <%=entity.getDescription()%></td>
			</tr>
			<tr>
								<td><label>กลุ่ม</label></td>
								<td align="left">: <%=PartGroups.select(entity.getGroup_id()).getGroup_name_th()%></td>
							</tr>
							<tr>
								<td><label>ชนิด</label></td>
								<td align="left">:	<%=PartCategories.select(entity.getCat_id(), entity.getGroup_id()).getCat_name_th()%></td>
							</tr>
							<tr>
								<td><label>ชนิดย่อย</label></td>
								<td align="left">: <%=PartCategoriesSub.select(entity.getSub_cat_id(), entity.getCat_id(),  entity.getGroup_id()).getSub_cat_name_th()%></td>
							</tr>
			
			<tr valign="top">
				<td><label>ใช้กับ</label></td>
				<td align="left">: <%=entity.getFit_to()%></td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td><label title="Serial Number">รูปแบบการจัดเก็บ</label></td>
				<td align="left">: <%=entity.getSn_flag().equalsIgnoreCase("1")?"จัดเก็บแบบมี Serial Number":entity.getSn_flag().equalsIgnoreCase("0")?"ไม่ใช้ Serial Number":""%></td>
			</tr>
			<tr>
				<td><label>สถานที่เก็บ</label></td>
				<td align="left">: <%=entity.getLocation()%></td>
			</tr>
			<tr>
				<td><label>น้ำหนัก</label></td>
				<td align="left">: <%=entity.getWeight()%></td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td><label>ราคาขาย</label></td>
				<td align="left">: <%=entity.getPrice()%> <%=PartMaster.unit(entity.getPrice_unit())%></td>
			</tr>
			<tr>
				<td><label>ต้นทุน</label></td>
				<td align="left">: <%=entity.getCost()%> <%=PartMaster.unit(entity.getCost_unit())%></td>
			</tr>
				<tr>
				<td><label>สินค้าคงเหลือในคงคลัง</label></td> 
				<td align="left">: <%=entity.getQty() +" "+ UnitDesc%></td>
			</tr>
		</tbody>
	</table>
	
	<div class="dot_line"></div>
	
	<div class="center">
		
	<%
		if(entity.getSn_flag().equalsIgnoreCase(PartMaster.FLAG_SN)){
	%>
	<form id="borrow_pn_sn_form" onsubmit="return false;">
		<table cellpadding="3" cellspacing="3"  border="0" class="s_auto">
			<tbody>
				<tr>
					<td width="30%" align="left"><label>pn &amp; sn</label></td>
					<td width="70%" align="left">: <input type="text" name="pn" id="pn" autocomplete="off" class="txt_box s150 required input_focus" title="*"></td>
				</tr>
				<tr>
					<td align="left"><label>ผู้ยืม (พิมพ์ชื่อเพื่อค้นหา)</label></td>
					<td align="left">: <input type="text" class="txt_box s150 required" id="borrow_by_autocomplete" value="" title="*"><input type="hidden" name="borrow_by" id="borrow_by" value=""></td>
				</tr>
				<tr>
					<td align="left"><label>หมายเหตุ</label></td>
					<td align="left">: <input type="text" class="txt_box s200" autocomplete="off" name="note"></td>
				</tr>
				<tr><td colspan="2" align="center"><button class="btn_box btn_confirm" title="ยืม อะไหล่/เครื่องมือ">ทำการยืม</button></td></tr>
			</tbody>
		</table>
		<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	</form>
	
	<script type="text/javascript">
	$(function(){
		$("#borrow_by_autocomplete").autocomplete({
	        source: "../GetEmployee",
	        minLength: 2,
	        select: function(event, ui) {
	           $('#borrow_by').val(ui.item.id);
	        }
	    });
		
		var form = $('#borrow_pn_sn_form');
		var v = form.validate({
			submitHandler: function(){
				
				if ($('#pn').val().indexOf('<%=pn%>--') > -1) {
					if($('#borrow_by').val() != ''){
						ajax_load();
						$.post('../BorrowPartManagement',form.serialize() + '&action=borrow',function(data){
							ajax_remove();
							if (data.status == 'success') {
								alert('บันทึกข้อมูลการยืมเรียบร้อย');  
								window.location.reload();
							} else {
								alert(data.message);
								$('#' + data.focus).focus();
							}
						},'json');
					} else {
						alert('ระบุชื่อผู้ยืมไม่ถูกต้อง');
						$('#borrow_by_autocomplete').focus();
					}
				} else {
					alert('ระบุ หมายเลขรห้สสินค้าไม่ถูกต้อง');
					$('#pn').focus();
				}
				
			}
		});
		
		form.submit(function(){
			v;
			return false;
		});
	});
	
	

	</script>
	<%
		} else { // -------------------------- borrow non sn ---------------------------------------------
	%>
	<form id="borrow_non_sn_form" onsubmit="return false;">
		<table cellpadding="3" cellspacing="3" border="0" class="s_auto">
			<tbody>
				<tr>
					<td width="30%" align="left"><label>Part Number</label></td>
					<td width="70%" align="left">: <input type="text" name="pn" id="pn" autocomplete="off" class="txt_box s150 required input_focus" title="*"></td>
				</tr>
				<tr>
					<td align="left"><label>จำนวนที่ยืม</label></td>
					<td align="left">: <input type="text" class="txt_box s150 required" autocomplete="off" name="qty" id="qty" title="*" onchange="return validNumberOnKeyUp(this, event)"></td>
				</tr>
				<tr>
					<td align="left"><label>ผู้ยืม (พิมพ์ชื่อเพื่อค้นหา)</label></td>
					<td align="left">: <input type="text" class="txt_box s150 required" id="borrow_by_autocomplete" value="" title="*"><input type="hidden" name="borrow_by" id="borrow_by" value=""></td>
				</tr>
				<tr>
					<td align="left"><label>หมายเหตุ</label></td>
					<td align="left">: <input type="text" class="txt_box s200" autocomplete="off" name="note"></td>
				</tr>
				<tr>
					<td colspan="2" align="center">
					<button class="btn_box btn_confirm" title="ยืม อะไหล่/เครื่องมือ">ทำการยืม</button>
					<button class="btn_box btn"  title="ยกเลิก" onclick="tb_remove();">ยกเลิก</button>
					</td>
				</tr>
			</tbody>
		</table>
		<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	</form>
	
	<script type="text/javascript">
	$(function(){
		$("#borrow_by_autocomplete").autocomplete({
	        source: "../GetEmployee",
	        minLength: 2,
	        select: function(event, ui) {
	           $('#borrow_by').val(ui.item.id);
	        }
	    });
		
		$('#qty').blur(function(){
			if ($('#qty').val() != '') {
				if (isNumber($('#qty').val())) {
					if ($('#qty').val()*1 > <%=entity.getQty()%>) {
						alert('ระบุจำนวนที่ต้องการยืม มากกว่าจำนวนคงเหลือในคลัง');
						$('#qty').val('').focus();
					}
				} else {
					alert('โปรดระบุจำนวนที่ต้องการยืมเป็นตัวเลข');
					$('#qty').val('').focus();
				}
			}
		});
		
		var form = $('#borrow_non_sn_form');
		var v = form.validate({
			submitHandler: function(){
				
				if ($('#pn').val() == '<%=pn%>') {
					if($('#borrow_by').val() != ''){
						ajax_load();
						$.post('../BorrowPartManagement',form.serialize() + '&action=borrow',function(data){
							ajax_remove();
							if (data.status == 'success') {
								alert('บันทึกข้อมูลการยืมเรียบร้อย');  
								window.location.reload();
							} else {
								alert(data.message);
								$('#' + data.focus).focus();
							}
						},'json');
					} else {
						alert('ระบุชื่อผู้ยืมไม่ถูกต้อง');
						$('#borrow_by_autocomplete').focus();
					}
				} else {
					alert('ระบุ หมายเลขรห้สสินค้าไม่ถูกต้อง');
					$('#pn').focus();
				}
				
			}
		});
		
		form.submit(function(){
			v;
			return false;
		});
	});
	</script>
	<%
		}
	%>
	</div>

