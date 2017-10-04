<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/clear_form.js"></script>

<script src="../js/jquery.validate.min.js"></script>
<script src="../js/jquery.metadata.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Branch: </title>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="snc" %>
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
		var $msg = $('#msg_error');
		var $form = $('#infoForm');
		///alert("branch_postalcode"+$('#branch_postalcode').val());
		
		
		
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
									//alert(json.check);
									if (json.status == 'success') {
										
										if (json.check == "CodeName") {
											alert("ชื่อสาขาและรหัสสาขา ซ้ำ !");
										}
										if (json.check == "Name") {
											alert("ชื่อสาขา ซ้ำ !");
										}
										if (json.check == "Code") {
											alert("รหัสสาขา ซ้ำ !");
										}
										if (json.check == "success") {
											
											window.location="branch_manage.jsp";
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
</head>
<body>
 <div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Create Branch: </div>
				<div class="right">
					<button class="btn_box" type="button" onclick="history.back();">back</button>
				</div>
				<div class="clear"></div>
			</div> 
			
			
			<div class="content_body">
				<form id="infoForm" name="infoForm" action="" method="post" style="margin: 0;padding: 0;">
					<table cellpadding="3" cellspacing="3" border="0" class="center s480">
						<tbody>
						
						<tr height="20px">
							<td width="20%"><Strong>รหัสสาขา</Strong></td>
							<td align="left">: 
							<input type="text"  maxlength="5" autocomplete="off" name="branch_code" id="branch_code"  class="txt_box s100 required" title="Please insert Branch Code."> 
							</td>
						</tr>
						<!-- <tr  height="20px">
							<td><label><Strong>ลำดับสาขา</Strong></label></td>
							<td>: <input type="text" autocomplete="off" name="branch_order" id="branch_order" class="txt_box s200 required"  title="Please insert Branch Name."> </td>
						</tr> -->
						<tr height="20px">
							<td><Strong>ชื่อสาขา</Strong></td>
							<td align="left">: 
							<input type="text" autocomplete="off" name="branch_name" id="branch_name"  class="txt_box s200 required" title="Please insert Branch Name."> 
							</td>
						 </tr>
						 <tr height="20px">
							<td><Strong>ชื่อย่อ</Strong></td>
							<td align="left">: 
							<input type="text" autocomplete="off" name="branch_name_en" id="branch_name_en"  class="txt_box s200 required" title="Please insert Branch Name."> 
							</td>
						 </tr>
						 <tr height="20px">
							<td colspan="2" height="10px" >
								<fieldset class="fset" >
								<legend>ที่อยู่</legend>
								<table >
								<tr height="20px">
									<td><Strong>ถนน</Strong></td>
									<td align="left">: 
									<input type="text" autocomplete="off" name="branch_road" id="branch_road"  class="txt_box s100 " title="Please insert Road.">
									</td>
								</tr>
						 		<tr height="20px">
									<td><Strong>ซอย</Strong></td>
									<td align="left">: 
									<input type="text" autocomplete="off" name="branch_lane" id="branch_lane"  class="txt_box s100 " title="Please insert Soi."> 
									</td>
								</tr>
								 <tr height="20px">
									<td><Strong>เลขที่</Strong></td>
									<td align="left">: 
									<input type="text" autocomplete="off" name="branch_addressnumber" id="branch_addressnumber"  class="txt_box s100 required" title="Please insert Address No."> 
									</td>
								</tr>
						 		<tr height="20px">
									<td><Strong>หมูที่</Strong></td>
									<td align="left">: 
									<input type="text" autocomplete="off" name="branch_moo" id="branch_moo"  class="txt_box s100 " title="Please insert villege No."> 
									</td>
								</tr>
								<!--  <tr height="20px">
								<td><Strong>หมู่บ้าน</Strong></td>
								<td align="left">: 
								<input type="text" autocomplete="off" name="branch_villege" id="branch_villege"  class="txt_box s200 required" title="**** branch_villege"> 
								</td>
								</tr> --> 
								<tr height="20px">
									<td><Strong>ตำบล/แขวง</Strong></td>
									<td align="left">: 
									<input type="text" autocomplete="off" name="branch_district" id="branch_district"  class="txt_box s200 required" title="Please insert District."> 
									</td>
								 </tr>
						 		<tr height="20px">
									<td><Strong>อำเภอ/เขต</Strong></td>
									<td align="left">: 
									<input type="text" autocomplete="off" name="branch_prefecture" id="branch_prefecture"  class="txt_box s200 required" title="Please insert Prefecture."> 
									</td>
							 	</tr>
							 	<tr height="20px">
									<td><Strong>จังหวัด</Strong></td>
									<td align="left">: 
									<input type="text" autocomplete="off" name="branch_province" id="branch_province"  class="txt_box s200 required" title="Please insert Province."> 
									</td>
						 		</tr>
						 		<tr height="20px">
									<td><Strong>รหัสไปรษณีย์</Strong></td>
									<td align="left">: 
									<input type="text" maxlength="5" autocomplete="off" onkeyup='checkNumber_postalcode(this)' name="branch_postalcode" id="branch_postalcode"  class="txt_box s100 required" title="Please insert Postalcode."> 
									</td>
							 	</tr>
						  		<tr height="20px">
									<td><Strong>โทรศัพท์</Strong></td> 
									<td align="left">: 
									<input type="text" maxlength="10" autocomplete="off" onkeyup='checkNumber_phonenumber(this)' name="branch_phonenumber" id="branch_phonenumber"  class="txt_box s120 " title="Please insert Phonenumber."> 
									</td>
						 		</tr>
						  		<tr height="20px">
									<td><Strong>แฟกซ์</Strong></td>
									<td align="left">: 
									<input type="text" maxlength="10" autocomplete="off" onkeyup='checkNumber_fax(this)' name="branch_fax" id="branch_fax"  class="txt_box s120 " title="Please insert Fax."> 
								</td>
							 	</tr>
								</table>
								</fieldset>
							</td>
						 </tr>
						 <tr> 
						 	<td colspan="2" height="10px">  </td> 
						 </tr>
						 <tr align="center" valign="bottom" height="20">	
								<td colspan="2">
									<input type="submit" id="btnAdd" value="Create" class="s70 btn_box ">
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
									<input type="reset" value="Reset" class="s70 btn_box " onclick="$('#edit_vendor').hide();">
								</td>
						</tr>
						</tbody>
					</table>
					<input type="hidden" name="action" value="add_branch">
					<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
					</form>
			</div>
			
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>