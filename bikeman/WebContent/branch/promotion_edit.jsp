<%@page import="com.bmp.cs.promotion.PromotionTS"%>
<%@page import="com.bmp.cs.promotion.PromationBean"%>
<%@page import="com.bitmap.bean.branch.*"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<%
PromationBean re = new PromationBean();
re.setId("1");
PromationBean entity = PromotionTS.select(re);
//System.out.println("Promotion:"+entity.getPromotion1());
%>

<script src="../js/jquery-1.4.2.min.js" type="text/javascript"></script>
<script src="../js/ajaxfileupload.js" type="text/javascript"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.webcam.js"></script>
<script src="../js/jquery.validate.min.js"></script>
<script src="../js/jquery.metadata.js"></script>

<script type="text/javascript">

	$(function(){
	
		var $form = $('#promotionForm');
		var v = $form.validate({		
			submitHandler: function(){

							ajax_load();
							$.post('../BranchManagement',$form.serialize(),function(json){
								
								ajax_remove();
								if (json.status == 'success') {
									//ajaxImgUpload();
										alert("แก้ไขเรียบร้อยแล้ว");
										window.location.reload();
																	
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
		
		
		
	});
	
	
	
</script>
<div>
		<fieldset class="fset s880 left min_h300">
				

				<form enctype="multipart/form-data" id="promotionForm" action="" method="post" style="margin: 0;padding: 0;" >
						
					<fieldset class="fset s850 left min_h300">
						<legend><Strong>Promotion  Configuration</Strong></legend>
						<table width="800px">
										<tr height="20px">
										<td><Strong>Set Thank</Strong></td>
										<td align="left">: 
										<input type="text" autocomplete="off" name="remake" id="remake" value="<%=entity.getRemake()%>" class="txt_box s400 " > 
											</td>
										</tr>
										<tr height="20px">
											<td><Strong>Promotion info : 1</Strong></td>
											<td align="left">: 
											<input type="text" autocomplete="off" name="promotion1" id="promotion1" value="<%=entity.getPromotion1()%>" class="txt_box s400 " > 
											</td>
										</tr>
										<tr height="20px">
											<td><Strong>Promotion info : 2</Strong></td>
											<td align="left">: 
											<input type="text" autocomplete="off" name="promotion2" id="promotion2" value="<%=entity.getPromotion2() %>" class="txt_box s400 " > 
											</td>
										</tr>
										<tr height="20px">
											<td><Strong>Promotion info : 3</Strong></td>
											<td align="left">: 
											<input type="text" autocomplete="off" name="promotion3" id="promotion3" value="<%=entity.getPromotion3() %>" class="txt_box s400 " > 
											</td>
										</tr>
										
											<tr height="20px">
											<td><Strong>Promotion info : 4</Strong></td>
											<td align="left">: 
											<input type="text" autocomplete="off" name="promotion4" id="promotion4" value="<%=entity.getPromotion4() %>"  class="txt_box s400 " > 
											</td>
										</tr>
										<tr height="20px">
										<td><Strong>Promotion info : 5</Strong></td>
											<td align="left">: 
											<input type="text" autocomplete="off" name="promotion5" id="promotion5" value="<%=entity.getPromotion5() %>" class="txt_box s400 " > 
											</td>
										</tr>
										 
										<!-- <tr height="20px">
											<td><Strong>Images</Strong></td>
											<td align="left">1: 											
											<input type="file" id="file_promotion1" name="file_promotion1" readonly="readonly" class="txt_box" >										
											</td>
										</tr>
										<tr height="20px">
											<td></td>
											<td align="left">2: 	
											<input type="file" id="file_promotion2" name="file_promotion2" readonly="readonly" class="txt_box" >
											</td>
										</tr>
										<tr height="20px">
											<td></td>
											<td align="left">3: 	
											<input type="file" id="file_promotion3" name="file_promotion3" readonly="readonly" class="txt_box" >
											</td>
										</tr>
										<tr height="20px">
											<td></td>
											<td align="left">4: 	
											<input type="file" id="file_promotion4" name="file_promotion4" readonly="readonly" class="txt_box" >
											</td>
										</tr>
										<tr height="20px">
											<td></td>
											<td align="left">5: 	
											<input type="file" id="file_promotion5" name="file_promotion5" readonly="readonly" class="txt_box" >
											</td>
										</tr> -->
										
										<tr align="center" height="10px"><td colspan="2"></td></tr>
										<tr align="center" valign="bottom" height="30">
											<td colspan="2">
												<input type="submit" id="btnAdd" value="บันทึก" class="btn_box btn_confirm">
												&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												<input type="hidden" name="action" value="edit_promotion">
												<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
												<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
												<input type="hidden" name="id" value="<%=entity.getId()%>">
												<input type="hidden" name="branch_code" value="<%=entity.getBranch_code()%>">
											</td>
										</tr>
										
										</table>
								
					</fieldset>
							
				
				<div class="msg_error" id="vendor_msg_error"></div>
				</form>

   </fieldset>
</div>