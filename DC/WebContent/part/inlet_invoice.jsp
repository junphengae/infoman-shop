<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.inventory.InventoryPacking"%>
<%@page import="com.bitmap.bean.inventory.InventoryLot"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterVendor"%>
<%@page import="com.bitmap.bean.util.ImagePathUtils"%>
<%@page import="com.bitmap.bean.inventory.WeightType"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.hr.Branch"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.util.StatusUtil"%>
<%@page import="com.bitmap.bean.inventory.SubCategories"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script>
<script src="../js/loading.js"></script>
<script src="../js/number.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.tabs.js"></script>
<script src="../js/ui/jquery.ui.mouse.js"></script>
<script src="../js/ui/jquery.ui.sortable.js"></script>
<script src="../js/ui/jquery.ui.position.js"></script>
<script src="../js/ui/jquery.ui.autocomplete.js"></script>
<script type="text/javascript" src="../js/popup.js"></script>

<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/jquery.simplemodal.js"></script>

<!-- Date -->
<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>


<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Inlet</title>
<%
String mat_code = WebUtils.getReqString(request, "mat_code");
PartMaster invMaster = PartMaster.select(mat_code);
%>

</head>

<body>
<div class="wrap_all">

			<div class="content_body">
					<div class="center txt_center">
				<form onsubmit="return false;" method="post" id="inlet_form">
				<fieldset class="s430 right fset">
					<legend>รับเข้า</legend>								
					<div id="div_img" class="left txt_center min_h240">
							<div class="m_top10 " style="padding-left: 10px;">
							<table  width="400px;" border="0">
							<tbody >
							<tr height="30px;">
								<td width="25%" align="left"><input type="radio" name="normal" id="normal0" value="0"  class="radioclick" > <input type="hidden" name="inv_type0" id="inv_type0" value="<%=WeightType.selectName(invMaster.getDes_unit())%>"  class="radioclick"> <label for="upImg">รับเข้าปกติ</label></td>
								<td align="left"><input type="text" id="text0" name="text0" size="7"  style="text-align: right; background-color: gray;" readonly="readonly" class="num" qty="1" geti="0"> <%=WeightType.selectName(invMaster.getDes_unit())%> </td>
							</tr>											
							<%
								List listunit = InventoryPacking.list(mat_code);
								Iterator iteunit = listunit.iterator();
								int i = 0;
								while (iteunit.hasNext()){
									InventoryPacking entity = (InventoryPacking) iteunit.next();
									i++;
							%>
							<tr height="30px;">
								<td width="20%" align="left"><input type="radio" name="normal" id="normal<%=i%>" value="<%=i%>"  class="radioclick"><input type="hidden" name="inv_type<%=i%>" id="inv_type<%=i%>" value="<%=entity.getDescription()%>" > <label for="upImg"><%=entity.getDescription()%></label></td>
								<td align="left"><input type="text" id="text<%=i%>" name="text<%=i%>" size="7" style="text-align: right; background-color: gray;" readonly="readonly" class="num" qty="<%=entity.getUnit()%>" geti="<%=i %>"> <%=entity.getDescription()%> (<%=entity.getDescription()%>ละ <%=entity.getUnit()%> <%=WeightType.selectName(invMaster.getDes_unit())%>) </td>
							</tr>
								<%}%>
							<tr height="30px;">
								<td width="20%" align="left"></td>
								<td align="left"><button type="button" class="btn_box btn_comfirm showform" id="showadd" style="display: none;">เลือก</button></td>
							</tr>
							</tbody>
							<tbody id="show" class="hide">
							<tr height="30px;" >
								<td width="20%" align="left"><label for="upImg">จำนวนที่รับเข้า</label></td>
								<td align="left"><input type="text" id="lot_qty" name="lot_qty" size="7" style="text-align: right;" readonly="readonly"> <%=WeightType.selectName(invMaster.getDes_unit())%> </td>
							</tr>							
							
							<tr height="30px;"  >
								<td width="20%" align="left"><label for="upImg">ราคาต่อหน่อย</label></td>
								<td align="left"><input type="text" id="lot_price" name="lot_price" size="7" style="text-align: right;"  > บาท/<%=WeightType.selectName(invMaster.getDes_unit())%></td>
							</tr>
							
							<tr height="30px;"  >
								<td width="20%" align="left"><label for="upImg">ตัวแทนจำหนาย</label></td>
								<td align="left">
									<%-- <bmp:ComboBox name="vendor_id" styleClass="txt_box s150" validate="true" validateTxt="เลือกตัวแทนจำหน่าย!" listData="<%=//Vendor.selectListvender(mat_code)%>">
											<bmp:option value="" text="--- select ---"></bmp:option>
									</bmp:ComboBox> --%>
<%-- 									<button type="button" class="btn_box btn_add" onclick="window.location='material_edit_vendor.jsp?mat_code=<%=mat_code%>'">New Vender</button>	 --%>
								</td>
							</tr>
							</tbody>
							</table>							
							</div>														
					</div>			
					<div class="s400 txt_center center" id ="show2"  style="display: none;">
						<button type="button" class="btn_box btn_comfirm submitform">ตกลง</button>
						<input type="hidden" name="action" value="add_stock">
						<input type="hidden" name="mat_code" id="mat_code" value="<%=mat_code%>">
						<input type="hidden" name="branch_id" id="branch_id" value="1">						
						<input type="hidden" name="lot_inv_qty" id="lot_inv_qty" >
						<input type="hidden" name="note" id="note" >
						<input type="hidden" name="geti" id="geti" >	
						<input type="hidden" name="create_by" id="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">					
					</div>
					<div class="clear"></div>		
					<script type="text/javascript">						
						$(function(){
							for(var i = 0;i<=<%=i%>;i++){
								$("#text"+i).val("");
								$("#text"+i).attr('readonly', true);
								$("#text"+i).css('background-color', "gray");
								$("#lot_qty").val("");
								$("#lot_price").val("");
							}
							
						 	$(".radioclick").click(function(){		
						 		for(var i = 0;i<=<%=i%>;i++){	 					 		
										$("#text"+i).val("");
										$("#text"+i).attr('readonly', true);
										$("#text"+i).css('background-color', "gray");
									}
									 $("#note").val($("#inv_type"+$(this).val()).val());
									 $("#text"+$(this).val()).focus();
									 $("#text"+$(this).val()).attr('readonly', false);
									 $("#text"+$(this).val()).css('background-color', "#FFF");
									 $("#show").hide();
							 		 $("#show2").hide();
							 		 $("#showadd").hide();
							 		 
								});		
						 	$(".num").keyup(function() {
						 		 $("#showadd").fadeIn(800);
						 	});
						 		$(".num").blur(function() {
						 			 $(this).val( $(this).val()*1);	
						 		     if($(this).val()!="NaN"){
						 		    	 $("#lot_qty").val($(this).val()*$(this).attr('qty'));						 		
								 		 $("#show").fadeIn(800);
								 		 $("#show2").fadeIn(700);	
								 		 $("#geti").val($(this).attr('geti'));
								 		 $("#lot_inv_qty").val($(this).val()); 						 		    	 
						 		     }else{
						 		    	 alert("กรุณากรอกเป็นตัวเลขเท่านั้น");
						 		    	 
						 		    	$(this).val("");
								 		$(this).focus();
						 		     }
							 });
						 		
						 		$(".submitform").click(function() {						 										
									$('#inlet_form').submit();
						 		});	
						 		
						 		 
						});							
					</script>
										
				</fieldset>	
				</form>					
					
				</div>
			</div>
	</div>

	


</body>
</html>