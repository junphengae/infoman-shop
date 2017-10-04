<%@page import="com.bitmap.bean.branch.*"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<%
BranchMaster entity = new BranchMaster();
WebUtils.bindReqToEntity(entity, request);
BranchMaster.select(entity);
%>
<script type="text/javascript">
	function  checkNumber_postalcode(data){
	  if(!data.value.match(/^\d*$/)){
				alert("กรอกรหัสไปรษณีย์ เป็นตัวเลขเท่านั้น");
				data.value='';
				$('#branch_postalcode').focus();
	  }
	}	  	
	function  checkNumber_phonenumber(data){
		  if(!data.value.match(/^\d*$/)){
					alert("กรอกหมายเลขโทรศัพท์ เป็นตัวเลขเท่านั้น");
					data.value='';
					 $('#branch_phonenumber').focus();
		  }
	}
	function  checkNumber_fax(data){
		  if(!data.value.match(/^\d*$/)){
					alert("กรอกหมายเลขแฟ็กซ์ เป็นตัวเลขเท่านั้น");
					data.value='';
				 	$('#branch_fax').focus();
		  }
	}	 
	
	$(function(){
		var $msg = $('#vendor_msg_error');
		var $form = $('#groupForm');
		;
		
		var v = $form.validate({
			submitHandler: function(){
				if (isNaN($('#branch_postalcode').val())) {
					alert("กรอกรหัสไปรษณีย์ เป็นตัวเลขเท่านั้น");
				}
				else if (isNaN($('#branch_phonenumber').val())) {
					alert("กรอกหมายเลขโทรศัพท์ เป็นตัวเลขเท่านั้น");
				}
				else if (isNaN($('#branch_fax').val())) {
					alert("กรอกหมายเลขแฟ็กซ์ เป็นตัวเลขเท่านั้น");
				}else{
				
							
							ajax_load();
							$.post('../BranchManagement',$form.serialize(),function(json){
								
								ajax_remove();
								if (json.status == 'success') {
									
									if(json.branch_id == "errorName"){
										alert("ชื่อสาขาซ้ำ !");
									}
									else if(json.branch_id == "errorCode"){
										alert("รหัสสาขาซ้ำ !");
									}
									else if(json.branch_id == "errorCodeName"){
										alert("รหัสสาขาและชื่อสาขาซ้ำ !");
									}else if (json.branch_id == "success") {
										
										alert("แก้ไขเรียบร้อยแล้ว");
										window.location.reload();
									}
									
									
									
								} else {
									alert(json.message);
								}
							},'json');
							
			}
			}
		});
		
		$form.submit(function(){
			v;
			return false;
		});
	});
</script>
<div>
		<fieldset class="fset s430 left min_h200">
					<legend><Strong>Edit Branch Information</Strong></legend>

				<form id="groupForm" action="" method="post" style="margin: 0;padding: 0;">
				<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="420px">
					<tbody>
						
						<tr align="center" height="10px"><td colspan="2"></td></tr>
						<tr>
							<td align="left" width="20%"><label><Strong>Branch Code</Strong></label></td>
							
							<td align="left" width="80%">: <label><%=entity.getBranch_code()%></label>
							<input type="hidden" autocomplete="off" name="branch_code" id="branch_code" class="txt_box s40 required input_focus" title="Please insert Branch Code." value="<%=entity.getBranch_code()%>" maxlength="5"></td>
						</tr>
						<tr align="center" height="10px"><td colspan="2"></td></tr>
						<tr>
							<td><label><Strong>Branch Name</Strong></label></td>
							<td>: <input type="text" autocomplete="off" name="branch_name" id="branch_name" class="txt_box s200 required" value="<%=entity.getBranch_name()%>" title="Please insert Branch Name."> </td>
						</tr>
						</tbody>
					</table>
					<fieldset class="fset s380 left min_h200">
						<legend><Strong>Address</Strong></legend>
						<table width="380px">
							<tr height="20px">
										<td><Strong>Road</Strong></td>
										<td align="left">: 
										<input type="text" autocomplete="off" name="branch_road" id="branch_road" value="<%=entity.getBranch_road() %>" class="txt_box s200 " title="Please insert Road."> 
											</td>
										</tr>
										<tr height="20px">
											<td><Strong>Soi</Strong></td>
											<td align="left">: 
											<input type="text" autocomplete="off" name="branch_lane" id="branch_lane" value="<%=entity.getBranch_lane() %>" class="txt_box s100 " title="Please insert Soi."> 
											</td>
										</tr>
										<tr height="20px">
											<td><Strong>No.</Strong></td>
											<td align="left">: 
											<input type="text" autocomplete="off" name="branch_addressnumber" id="branch_addressnumber" value="<%=entity.getBranch_addressnumber() %>" class="txt_box s100 required" title="Please insert  No."> 
											</td>
										</tr>
										<tr height="20px">
											<td><Strong>Village No.</Strong></td>
											<td align="left">: 
											<input type="text" autocomplete="off" name="branch_moo" id="branch_moo" value="<%=entity.getBranch_moo() %>" class="txt_box s100 " title="Please insert village No."> 
											</td>
										</tr>
										 <tr height="20px">
											<td><Strong>Village</Strong></td>
											<td align="left">: 
											<input type="text" autocomplete="off" name="branch_villege" id="branch_villege" value="<%=entity.getBranch_villege() %>" class="txt_box s200 required" title="Please insert village."> 
											</td>
										</tr> 
											<tr height="20px">
											<td><Strong>Tambon</Strong></td>
											<td align="left">: 
											<input type="text" autocomplete="off" name="branch_district" id="branch_district" value="<%=entity.getBranch_district() %>"  class="txt_box s200 required" title="Please insert Tambon"> 
											</td>
										</tr>
										<tr height="20px">
										<td><Strong>District</Strong></td>
											<td align="left">: 
											<input type="text" autocomplete="off" name="branch_prefecture" id="branch_prefecture" value="<%=entity.getBranch_prefecture() %>" class="txt_box s200 required" title="Please insert District."> 
											</td>
										</tr>
										<tr height="20px">
											<td><Strong>Province</Strong></td>
											<td align="left">: 
											<input type="text" autocomplete="off" name="branch_province" id="branch_province" value="<%=entity.getBranch_province() %>" class="txt_box s200 required" title="Please insert Province."> 
											</td>
										</tr>
										<tr height="20px">
											<td><Strong>Postal Code</Strong></td>
											<td align="left">: 
											<input type="text" maxlength="5"  onkeyup='checkNumber_postalcode(this)'  autocomplete="off" name="branch_postalcode" id="branch_postalcode" value="<%=entity.getBranch_postalcode() %>" class="txt_box s100 required" title="Please insert Postalcode."> 
											</td>
										</tr>
										<tr height="20px">
											<td><Strong>Phone Number</Strong></td>
											<td align="left">: 
											<input type="text" maxlength="10"  onkeyup='checkNumber_phonenumber(this)' autocomplete="off" name="branch_phonenumber" id="branch_phonenumber" value="<%=entity.getBranch_phonenumber() %>" class="txt_box s120 " title="Please insert Phonenumber."> 
											</td>
										<tr>
										<td><Strong>Fax</Strong></td>
											<td align="left">: 
											 <input type="text" maxlength="10"  onkeyup='checkNumber_fax(this)' autocomplete="off" name="branch_fax" id="branch_fax" value="<%=entity.getBranch_fax()%>" class="txt_box s120 " title="Please insert Fax."> 
											
											</td>
										</tr>
										
										</tr>
										<tr align="center" height="10px"><td colspan="2"></td></tr>
										<tr align="center" valign="bottom" height="30">
											<td colspan="2">
												<input type="submit" id="btnAdd" value="บันทึก" class="btn_box btn_confirm">
												&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												<input type="hidden" name="action" value="edit_Branch">
												<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
												<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
												<input type="hidden" name="branch_id" value="<%=entity.getBranch_id()%>">
											</td>
										</tr>
										
										</table>
								
					</fieldset>
							
				
				<div class="msg_error" id="vendor_msg_error"></div>
				</form>
   </fieldset>
</div>