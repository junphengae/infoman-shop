<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.inventory.InventoryWeightType"%>
<%@page import="com.bitmap.bean.inventory.InventoryPacking"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/number.js"></script>

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>


<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Add Packing</title>

<%
String mat_code = WebUtils.getReqString(request, "mat_code");
String des_unit = WebUtils.getReqString(request, "des_unit");

/* InventoryWeightType inv_w = new InventoryWeightType();
inv_w.setRun(des_unit);
InventoryWeightType.select(inv_w); */

UnitType inv_w = new UnitType();
inv_w.setId(des_unit);
UnitType.select(inv_w);

//System.out.println("inv_w_Name::"+inv_w.getType_name());
PartMaster part =PartMaster.select(mat_code);
%>

<script type="text/javascript">
	$(function() {
		var $form = $('#packing_form');
		
		var v = $form.validate({
			submitHandler: function(){
				if(isNumber($('#unit').val())){
						
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
							
				
				}else{
					  alert("กรอกจำนวนเป็นตัวเลขเท่านั้น");
					  $('#unit').focus();
				}
				
			}
		});
		
		$form.submit(function(){
			v;
			return false;
		});
		
/* 	aon comment 19-02-2014
	$('#unit').blur(function(){
			cal();
		});
		
		$('#type').change(function(){
			cal();
		}); */
		
		var description = $('#description');
		 $('#description_unit').change(function(){
			
			 sumMoney($(this).val());
			
		}); 
		 
		 
		 function sumMoney(a){
			 description.val(a);
		}		 
		 
		 
		
	});
	
	
	
</script>
</head>

<body>
<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				สร้างข้อมูลบรรจุภัณฑ์ :[PN = <%=mat_code %>, <%=part.getDescription()%>] 
			</div>
			
			<div class="content_body">
				<form id="packing_form" onsubmit="return false">
					<table width="100%">
						<tbody>
							<tr>
								<td width="25%" >เลือกจากบรรจุภัณฑ์เดิม</td>
								<td width="75%">:
								
									 <bmp:ComboBox name="description_unit"   styleClass="txt_box s150"  listData="<%=InventoryPacking.ddl_th1()%>" validate="true" validateTxt="*">
										<bmp:option value="" text="--- เลือกบรรจุภัณฑ์  ---"></bmp:option>
									</bmp:ComboBox>
									
										
								</td>
							</tr>
							<tr>
								<td><label>บรรจุภัณฑ์ที่จะแสดง</label></td>
								<td align="left">: 
									 
									<input type="text" autocomplete="off" name="description" id="description" class="txt_box required" size="30" value="" title="โปรดระบุบรรจุภัณฑ์">
								    <font style="color: red">*อธิบายเพิ่มเติมได้/สร้างใหม่<font>
								</td>
							</tr>
							<tr>
								 <td></td>
								<td>
								</td>
							</tr>
							<tr>
								 <td></td>
								<td>
								</td>
							</tr>
							<tr>
								<td>บรรจุจำนวน</td>
								<td>:
									<input type="text"  name="unit" id="unit" class="txt_box required" title="โปรดระบุจำนวน">   <%=inv_w.getType_name()%>
								</td>
							</tr>
						<%--<tr>
								<td>หน่วยกลาง</td>
								<td>:
									<bmp:ComboBox name="type" styleClass="txt_box s150" listData="<%=UnitType.selectList(des_unit)%>">
										
									</bmp:ComboBox>
								</td>
							</tr>
						 <tr>
								<td>Unit</td>
								<td>:
									<span id="td_unit">0</span> <%=inv_w.getType_name()%>
									<input type="hidden" name="unit" id="unit" value="0">
								</td>
							</tr> --%>
							<tr>
								<td colspan="2" align="center" height="30">
									<input type="submit" class="btn_box btn_confirm" value="บันทึก">
									<input type="reset" name="reset" class="btn_box" value="ยกเลิก" onclick="history.back();">
									<input type="hidden" name="action" value="add_packing">
									<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
									<input type="hidden" name="mat_code" value="<%=mat_code%>">
								</td>
							</tr>
						</tbody>
						
					</table>
				</form>
			</div>
		</div>
	</div>
</div>
</body>
</html>