<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.inventory.InventoryWeightType"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.inventory.InventoryPacking"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script src="../js/jquery.validate.js" type="text/javascript"></script>

<%
String mat_code = WebUtils.getReqString(request, "mat_code");
String run_id = WebUtils.getReqString(request, "run_id");

	InventoryPacking entity = new InventoryPacking();
	WebUtils.bindReqToEntity(entity, request);
	InventoryPacking.select(entity);
	
	String des_unit = WebUtils.getReqString(request, "des_unit");

	
	UnitType inv_w = new UnitType();
	inv_w.setId(des_unit);
	UnitType.select(inv_w);	
	PartMaster part =PartMaster.select(mat_code);
%>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>

<script type="text/javascript">

	 $(function() {
			var $form = $('#infoForm');
			
			var v = $form.validate({
				submitHandler: function(){
					ajax_load();
					$.post('../MaterialManage',$form.serialize(),function(data){
						ajax_remove();
						if (data.status == 'success') {
							if (data.check == "Name") {
								alert("ชื่อบรรจุภัณฑ์ซ้ำ !");
							}if (data.check == "success") {
								window.location = 'packing_view.jsp?mat_code=<%=mat_code%>';
								tb_remove();
							}							
						} else {
							alert(json.message);
						}
					},'json');
				}
			});
			
			$form.submit(function(){
				v;
				return false;
			});
			
/* 		aon comment 19-02-2014		
 * 
 		$('#unit').blur(function(){
				cal();
			});
			
			$('#type').change(function(){
				cal();
			});
			 */
			var description = $('#description');
			 $('#description_unit').change(function(){
			
				sumMoney($(this).val());
				
			}); 
			 
			 
			 function sumMoney(a){
				 description.val(a);
			}		 
			
			
			
			
		});
	 
	 
	 
</script>

<div>
	<form id="infoForm"   onsubmit="return false" style="margin: 0;padding: 0;">
	<input type="hidden" name="mat_code" id="mat_code" value="<%=entity.getMat_code()%>">
	<input type="hidden" name="run_id" id="run_id" value="<%=entity.getRun_id()%>">
	<input type="hidden" name="update_by" id="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="455px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>แก้ไขข้อมูล บรรจุภัณฑ์   </h3></td></tr>
			
			<tr>
				<td><label>Part Number</label></td>
				<td align="left">: 
					 <%=mat_code %>
					
				</td>
			</tr>
			<tr>
				<td><label>Description</label></td>
				<td align="left">: 
					<%=part.getDescription()%>
					
				</td>
			</tr>
			<tr>
				<td><label>เลือกจากบรรจุภัณฑ์เดิม</label></td>
				<td align="left">: 
					 <bmp:ComboBox name="description_unit"   styleClass="txt_box s150"  listData="<%=InventoryPacking.ddl_th1()%>" validate="true" validateTxt="*" value="<%=entity.getDescription()%>">
										<bmp:option value="" text="--- เลือกบรรจุภัณฑ์  ---"></bmp:option>
					</bmp:ComboBox>
					
				</td>
			</tr>
			<tr>
				<td><label>บรรจุภัณฑ์ที่จะแสดง</label></td>
				<td align="left">: 
					 
					<input type="text" autocomplete="off" name="description" id="description" class="txt_box required" size="30" value="<%=entity.getDescription()%>" title="โปรดระบุบรรจุภัณฑ์">
				    <font style="color: red">*อธิบายเพิ่มเติมได้/สร้างใหม่<font>
				</td>
			</tr>
			<tr>
				<td>จำนวน</td>
				<td>:
					<input type="text"  name="unit" id="unit" class="txt_box required" value="<%=entity.getUnit()%>" title="โปรดระบุจำนวน">  <%=inv_w.getType_name()%>
				</td>
			</tr>
			<%-- <tr>
				<td>Unit</td>
				<td>:
					<span id="td_unit"><%=entity.getUnit()%></span> <%=inv_w.getType_name()%>
				</td>
			</tr> --%>
			<tr>
				<td colspan="2" align="center" height="30">
					<input type="submit" class="btn_box btn_confirm" value="บันทึก">
					<input type="reset" name="reset" class="btn_box" value="ยกเลิก" onclick="javascript: window.location.reload();">
					<input type="hidden" name="action" value="edit_packing">
					<input type="hidden" name="unit" id="unit" value="<%=entity.getUnit()%>">
					<%-- <input type="hidden" name="mat_code" id="mat_code" value="<%=mat_code%>"> --%>
				</td>
			</tr>
		</tbody>
	</table>
	
	<div class="msg_error"></div>	
	
	</form>
</div>
	

