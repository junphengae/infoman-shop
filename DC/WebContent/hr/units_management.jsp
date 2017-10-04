<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.inventory.WeightType"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.parts.PartGroups"%>
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
<title>Parts: </title>
<%String pn = WebUtils.getReqString(request, "pn");%>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="snc" %>
<script type="text/javascript">
$(function(){

	$('#des_unit').change(function(){
		if($(this).val() != "") {
			$('#edit_unit_type').fadeIn(500).attr('lang','unit_type_edit.jsp?height=300&width=520&id=' + $(this).val());
			
		} else {
			$('#edit_unit_type').hide();
		}
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
				<div class="left">เพิ่มหน่วยกลาง: </div>
				<div class="right">
					<button class="btn_box" type="button" onclick="history.back();">back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<br />
				<form id="infoForm" action="" method="post" style="margin: 0;padding: 0;">
				<center>
				<table>
				     <tr>
								<td><Strong>หน่วยกลาง<Strong></td>
								<td>: <!-- <input type="text" autocomplete="off" name="des_unit" class="txt_box" title="ลักษณะผลิตภัณฑ์ ตัวอย่างเช่น ขวด, ถัง, กระป๊อง, ถุง, กระสอบ เป็นต้น"> -->
									<bmp:ComboBox name="des_unit" styleClass="txt_box s150" listData="<%=UnitType.ddl_th()%>" validate="true" validateTxt="*">
										<bmp:option value="" text="--- เลือกหน่วยนับ ---"></bmp:option>
									</bmp:ComboBox>
									<input type="button" class="btn_box thickbox" id="new_unit_type" value="เพิ่ม" lang="unit_type_new.jsp?height=300&width=520" title="เพิ่ม">
									<input type="button" class="btn_box thickbox hide" id="edit_unit_type" value="แก้ไข" lang="" title="แก้ไข">
								   
								
								
								</td>
					</tr>
				</table>
				</center>
				<div class="msg_error"></div>
				</form>
				<br />
			</div>
		</div>
	</div> 
	<div> <p Style="color: black;"> <strong>หมายเหตุ  :</strong> ข้อมูลถูกเพิ่มเมื่อท่านทำการเพิ่มข้อมูลแล้วกดบันทึกข้อมูล  </p></div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>