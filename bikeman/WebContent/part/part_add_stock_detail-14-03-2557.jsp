<%@page import="com.bitmap.bean.inventory.UnitType"%>

<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.inventory.InventoryPacking"%>
<%@page import="com.bitmap.bean.inventory.WeightType"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="com.bitmap.bean.parts.PartGroups"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src="../js/number.js"></script>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<%
String mat_code = WebUtils.getReqString(request, "pn");
PartMaster invMaster = PartMaster.select(mat_code);


String recive_qty = "0";
String po_no =   WebUtils.getReqString(request, "po");
PartMaster entity = new PartMaster();
WebUtils.bindReqToEntity(entity, request);
PartMaster.select(entity);

PurchaseRequest entityPR = new PurchaseRequest();
WebUtils.bindReqToEntity(entityPR, request);
PurchaseRequest.select(entityPR);
InventoryPacking Packing = InventoryPacking.selectmat_code(mat_code);
//ทำ replace เนื่องจากถึงหลักพันแล้ว error ต้องเอา "," ออกเนื่องจากคำนวนเป็น int
String recive_qty_rep = Money.moneyInteger(entityPR.getUIrecive_qty()).replace(",", "");

if(entityPR.getUIrecive_qty().length()>0){
	recive_qty = recive_qty_rep;
}

//Packing
	int i = 0;
%>
<script type="text/javascript">
$(function(){
var div_sn = $('#div_show_sn');
var div_no_sn = $('#div_non_sn');
var Sn_flag = $('#flag');
var Description = $('#Description');

var pn = $('#pn');
var po = $('#po');
var pn_sn = $('#pn_sn');/* input */
var non_sn = $('#non_sn_qty');/* input */
var non_re_qt = $('#non_sn_recive_qty');
var non_or_qt = $('#non_sn_order_qty');
var form = $('#add_stock_detail');/* form */

var btn_pn_sn = $('#btn_save_pn_sn');
var btn_non_sn = $('#btn_save_non_sn');
var packing = "<%=Packing.getUnit()%>";

 if(Description.val() != 0){  /*** start Description > 0 ******/
	if ( Sn_flag.val() == 1){ /*** start Sn_flag = 1 ******/	
		
		div_sn.show();
		div_no_sn.hide();
	}else /*** end Sn_flag = 1 ******/
	if (Sn_flag.val() == 0) { /*** start Sn_flag = 0 ******/	
		
		div_sn.hide();
		div_no_sn.show();
	}/*** end Sn_flag = 0 ******/
	 else{
		alert("ไม่พบรายการสินค้า");
		window.location='part_add_stock.jsp';
	}
 } /*** end Description > 0 ******/

 $('#pn_sn').focus();
 $('#pn_sn').keypress(function(e){			
	 if (e.keyCode == 13) {
		submitSN();
	} 
	});	
 	btn_pn_sn.click(function(){	 		
 		submitSN();	
 		
	});
 
 	non_sn.focus();
 	btn_non_sn.click(function(){
 		submitNonSN();	
 		
	});
 	$(' input[type=text]').keypress(function(e){
			if (e.which == 13 ) {
				submitNonSN();
		}
	});		
 	non_sn.keypress(function(e){
		if (e.keyCode == 13) {
		return false;
		}
	});
 	
 	function submitSN(){

 		$("#btn_save_pn_sn").attr("disabled", "disabled");
 		var msg = $('#sn_msg_error');
		//alert("btn_pn_sn pn_sn_qty :"+pn_sn.val()+"part number :"+pn.val());
			if (pn_sn.val() == "") {
				pn_sn.focus();
				msg.text('Insert P/N & S/N!').slideDown('medium').delay(2500).slideUp('slow');
			}else{
				var pn_snfiln = pn_sn.val().split("==");
				ajax_load();				
				$.post('../PartInventory',form.serialize()+'&pn_sn='+pn_sn.val().trim()+'&qty=1&pn='+pn.val().trim()+'&po='+po.val()+'&action=stock_in_sn',function(resData){
				ajax_remove();				
					if (resData.status == 'success') {
						$('#pn_sn').val('').focus();					
						$('#sn_qty_stock').val(resData.qty);
						$('#non_sn_qty_stock').val(resData.qty);
						$('#total_qty_sn').text(resData.qty);				
						$('#recive_qty_sn').text(parseInt(resData.recive_qty));
						window.location.reload();
					}else{
						if (resData.message.indexOf('Duplicate entry') > 0) {
							msg.text('Duplicate SN!').slideDown('medium').delay(2500).slideUp('slow');
						} else {
							msg.text(resData.message).slideDown('medium').delay(2500).slideUp('slow');
						}
						$('#pn_sn').val('').focus();
					}
				},'json');
				
			}	
	}
 	
 	function submitNonSN(){
 		$("#btn_save_non_sn input[type=submit]").attr("disabled", "disabled");
 		 
 		var msg = $('#non_sn_msg_error');
		//alert("btn_non_sn non_sn_qty :"+non_sn.val()+"part number :"+pn.val());
		if (non_sn.val() == "" || non_sn.val() == "0" || !(/^\d+$/.test(non_sn.val()))) {
			non_sn.val('').focus();
			msg.text('Insert QTY!').slideDown('medium').delay(2500).slideUp('slow');
		}else{
			var add_qty = (parseInt(non_sn.val())+ parseInt(non_re_qt.val()));
			var qty_hand = parseInt(non_or_qt.val());
			if(add_qty>qty_hand){
				if (confirm('ท่านกำลังนำเข้าอะไหล่เกินกว่าจำนวนที่จัดส่ง ต้องการทำต่อไปหรือไม่')) {
					ajax_load();				
					$.post('../PartInventory',form.serialize()+'&qty='+non_sn.val().trim()+'&pn='+pn.val().trim()+'&po='+po.val()+'&action=stock_in_non_sn',function(resData){
					ajax_remove();				
						if (resData.status == 'success') {
							window.location.reload();
							
						}else{
							alert(resData.message);							
						}
					},'json');
				}else{
					non_sn.focus();	
				}/*******END  if confirm ***********/
			}else{
				if (confirm('Confirm Adding Stock')) {
					//alert(non_sn.val());
					ajax_load();				
					$.post('../PartInventory',form.serialize()+'&qty='+non_sn.val().trim()+'&pn='+pn.val().trim()+'&po='+po.val()+'&action=stock_in_non_sn',function(resData){
					ajax_remove();				
						if (resData.status == 'success') {
							window.location.reload();
							
						}else{
							alert(resData.message);							
						}
					},'json');
				
			}/********END if qt > h***********/
		}/****END else *****/	
	}/***** END function submitNonSN ********/
 }
 
pn_sn.focus(function(){ var value = $(this).val(); if (!(/^\d+$/.test(value)) || value == '0') { $(this).val(''); }});
non_sn.focus(function(){ var value = $(this).val(); if (!(/^\d+$/.test(value)) || value == '0') { $(this).val(''); }});

var packing = "<%=Packing.getUnit()%>";
	if(packing == ""){
	
	$("#show").fadeIn(800);
}



});
</script>

<div class="body_content" >
	<div class="content_head">
		<div class="left">Form PO : <%=po_no %></div>
		<div class="right">  </div>
		<div class="clear"></div>
	</div><!-- END content_head -->
	<form id="add_stock_detail" name="add_stock_detail" onsubmit="return false;">	
	<input type="hidden" id="Description" name="Description" value="<%=entity.getDescription()%>">
	<input type="hidden" id="flag" name="flag" value="<%=entity.getSn_flag()%>">

		<div class="content_body" style="height: 300px;" >
			<fieldset class="fset s300 left min_h240">
				<legend>Information</legend>
				<table cellpadding="3" cellspacing="3" border="0" class="s300 center m_left30">
					<tbody>
						<tr>
							<td width="30%"><label>Parts Number</label></td>
							<td>: <%=entity.getPn()%></td>
						</tr>
						<tr valign="top">
							<td><label>Description</label></td>
							<td align="left">: <%=entity.getDescription()%></td>
						</tr>
						<tr>
							<td><label>Group</label></td>
							<td align="left">: <%=PartGroups.select(entity.getGroup_id()).getGroup_name_en()%></td>
						</tr>
						
						<tr valign="top">
							<td><label>Fit-To</label></td>
							<td align="left">: <%=entity.getFit_to()%></td>
						</tr>
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr>
							<td><label title="Serial Number">Store Type</label></td>
							<td align="left">: <%=entity.getSn_flag().equalsIgnoreCase("1")?" Serial Number":entity.getSn_flag().equalsIgnoreCase("0")?" Non-Serial":""%></td>
						</tr>
						<tr>
							<td><label>Location</label></td>
							<td align="left">: <%=entity.getLocation()%></td>
						</tr>
						<tr>
							<td><label>Weight</label></td>
							<td align="left">: <%=entity.getWeight()%></td>
						</tr>
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr>
							<td><label>Price</label></td>
							<td align="left">: <%=entity.getPrice()%> <%=PartMaster.unit(entity.getPrice_unit())%></td>
						</tr>
						<tr>
							<td><label>Cost</label></td>
							<td align="left">: <%=entity.getCost()%> <%=PartMaster.unit(entity.getCost_unit())%></td>
						</tr>
					</tbody>
				</table>
			</fieldset>
<!--  ############################################### Start Add Stock  ###########################################################   -->
			<fieldset class="s280 fset center min_h180"  >
				<legend>Add Stock</legend>
							<div id="div_show_sn" class="center">
											<div>
												<div class="s80 left">Stock Qty </div><div class="s5 left"> : </div>
												<div class="s150 left txt_16 txt_bold">
												<%
												int Order_qty=0;
												int recive = 0;
												//ทำ replace เนื่องจากถึงหลักพันแล้ว error ต้องเอา "," ออกเนื่องจากคำนวนเป็น int
												String order_qty_rep = entityPR.getOrder_qty().replace(",", "");
												
												if(!entityPR.getOrder_qty().equalsIgnoreCase("")){
													Order_qty = Integer.parseInt(order_qty_rep);
												}
												if(!recive_qty.equalsIgnoreCase("")) {
													recive = Integer.parseInt(recive_qty);
												}
												
												if( Order_qty < recive){
												%>
												
													<font color="red"><span id="total_qty_sn"><%=entity.getQty()%></span>pcs.</font>
													
												<%}else{ %>	
												 	<span id="total_qty_sn"><%=entity.getQty()%> </span>pcs.
												<%} %>	
												
													</div><div class="clear"></div>
												</div>
												<div class="dot_line" style="margin: 5px 0;"></div>
												
												<!-- Order Qty  -->
											<div id="div_insert_sn" style="margin-top: 5px;">
												<div>
													<div class="s80 left"><font color="red">Order </font>Qty </div><div class="s10 left"> : </div>
													<div class="s180 left">
													
															<div class="s180 left txt_16 txt_bold">
																<%=entityPR.getOrder_qty()%> pcs.</div>
																
																<input type="hidden" name="sn_order_qty"  id="non_sn_order_qty"  value="<%=entityPR.getOrder_qty()%>">
																<div class="clear"></div>
													</div>
													<div class="clear"></div>
												</div>
											</div>
											
												<!-- RecieveQty  -->
												<div id="div_insert_sn" style="margin-top: 5px;">
												<div>
													<div class="s80 left"><font color="red">Recieve</font>Qty </div><div class="s10 left"> : </div>
													<div class="s180 left">
															<div class="s200 left txt_16 txt_bold">
															
																<input type="hidden" name="sn_recive_qty"  id="non_sn_recive_qty"  value="<%=recive_qty%>">
															<span id="recive_qty_sn"><%=recive_qty%></span> pcs.</div><div class="clear"></div>
													</div>
													<div class="clear"></div>
												</div>
											</div>
											<div class="dot_line" style="margin: 5px 0;"></div>
												
											<div id="div_insert_sn" style="margin-top: 5px;">
												<div>
													<div class="s80 left"><font color="red">Add serail Qty</font> </div><div class="s10 left"> : </div>
													<div class="s180 left">
														<input type="text" class="txt_box s150" name="pn_sn" id="pn_sn"> 
														<input type="button" id="btn_save_pn_sn" class="btn_box" value="Add stock">
														</div>
														<div class="clear"></div>
												</div>
											</div>
											
											<div class="msg_error" id="sn_msg_error"></div>
							</div>
<!-- /************************************************************************************************************************/ -->
					<div id="div_non_sn" >
								   					
							<div id="div_img" class="left txt_center min_h340">
							<div class="m_top10 " style="padding-left: 10px;">
							<% if(!Packing.getUnit().equalsIgnoreCase("")){ %>
							<div class="left">		
									<input type="radio" name="normal" id="normal0" value="0"  class="radioclick" > <input type="hidden" name="inv_type0" id="inv_type0" value="<%=UnitType.selectName(invMaster.getDes_unit())%>"  class="radioclick"> <label for="upImg">รับเข้าปกติ</label></td>
									<input type="text" id="text0" name="text0" size="7"  style="text-align: right; background-color: gray;" readonly="readonly" class="num" qty="1" geti="0"> 
									<%=UnitType.selectName(invMaster.getDes_unit())%>
							
							</div>	
							<br />	
							<%} %>								
							<%
							
							List listunit = InventoryPacking.list(mat_code);
							Iterator iteunit = listunit.iterator();
								
								while (iteunit.hasNext()){
									InventoryPacking entityPacking = (InventoryPacking) iteunit.next();
									i++;									
							%>
							
							<div class="left">
								<input type="radio" name="normal" id="normal<%=i%>" value="<%=i%>"  class="radioclick"><input type="hidden" name="inv_type<%=i%>" id="inv_type<%=i%>" value="<%=entityPacking.getDescription()%>" > <label for="upImg"><%=entityPacking.getDescription()%></label>									
								<input type="text" id="text<%=i%>" name="text<%=i%>" size="7" style="text-align: right; background-color: gray;" readonly="readonly" class="num" qty="<%=entityPacking.getUnit()%>" geti="<%=i %>">  
								<%=entityPacking.getDescription()%> (<%=entityPacking.getDescription()%>ละ <%=entityPacking.getUnit()%> <%=UnitType.selectName(invMaster.getDes_unit())%>) 
							</div>
							
							
							<br />
							<script type="text/javascript">
								
								for(var i = 0;i<=<%=i%>;i++){
									$("#text"+i).val("");
									$("#text"+i).attr('readonly', true);
									$("#text"+i).css('background-color', "gray");
									$("#non_sn_qty").val("");
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
							 	
								
							 	
							 	$(".radioclick").click(function() {
									$(".num").keyup(function() {
										 /* $("#showadd").fadeIn(800); */
									
										 $(this).val( $(this).val()*1);	
									     if($(this).val()!="NaN"){
									    	 $("#non_sn_qty").val($(this).val()*$(this).attr('qty'));						 		
								 		 	
								 		 $("#geti").val($(this).attr('geti'));
								 		 $("#lot_inv_qty").val($(this).val()); 						 		    	 
									     }else{
									    	 alert("กรุณากรอกเป็นตัวเลขเท่านั้น");
									    	 
									    	$(this).val("");
								 		$(this).focus();
									     }
									});  
									$("#show").fadeIn(300);
									$("#show2").fadeIn(700);
							   });
							 	
							 		
							 		$(".submitform").click(function() {						 										
										$('#inlet_form').submit();
							 		});	
								
								
						</script>
							
							
							
							
								<%}%>
							
							
							<div class="s180 left">
												<div class="left">
													<button type="button" class="btn_box btn_comfirm showform" id="showadd" style="display: none;">เลือก</button>
												</div>
												<div class="clear"></div>
							</div><div class="clear"></div>
							
							<div id="show" class="hide">
								
											<div id="div_show_non_sn" class="center">											
												<div class="s80 left">Stock Qty </div><div class="s10 left"> : </div>
												<% 						
												//ทำ replace เนื่องจากถึงหลักพันแล้ว error ต้องเอา "," ออกเนื่องจากคำนวนเป็น int
												String order_qty_rep2 = entityPR.getOrder_qty().replace(",", "");
												
												if(!entityPR.getOrder_qty().equalsIgnoreCase("")){
													Order_qty = Integer.parseInt(order_qty_rep2);
												}
												if(!recive_qty.equalsIgnoreCase("")) {
													recive = Integer.parseInt(recive_qty);
												}		
												
												
												if( Order_qty < recive){
												%>
												<font color="red"><span id="total_qty_sn"><%=entity.getQty()%> pcs.</span></font>													
												<%}else{ %>	
												 	<span id="total_qty_sn"><%=entity.getQty()%>  pcs.</span>
												<%} %>																																				
												<div class="clear"></div>
											</div>
										
										<!-- Order Qty  -->
										<div id="div_insert_sn" style="margin-top: 5px;">
											<div>
												<div class="s80 left"><font color="red">Order </font>Qty </div><div class="s10 left"> : </div>
												<div class="s180 left">
														<div class="s150 left txt_16 txt_bold">
															<input type="hidden" name="non_sn_order_qty"  id="non_sn_order_qty"  value="<%=entityPR.getOrder_qty()%>">
															<%=entityPR.getOrder_qty()%>  pcs.
														</div><div class="clear"></div>
												</div>
												<div class="clear"></div>
											</div>
										</div>
										<div id="div_insert_sn" style="margin-top: 5px;">
											<div>
												<div class="s80 left"><font color="red">Recive </font>Qty </div><div class="s10 left"> : </div>
												<div class="s180 left">
														<div class="s150 left txt_16 txt_bold">
															<input type="hidden" name="non_sn_recive_qty"  id="non_sn_recive_qty"  value="<%=recive_qty%>">
															<%=recive_qty%>  pcs.
														
														</div><div class="clear"></div>
												</div>
												<div class="clear"></div>
											</div>
										</div>
										<div>
											<div class="s80 left">New Add Qty </div><div class="s10 left"> : </div>
											<div class="s180 left">
												<div class="left">
													<input type="text" name="non_sn_qty" id="non_sn_qty" class="txt_box s80" value=""> 
													&nbsp;
													<button type="submit" id="btn_save_non_sn" class="btn_box "> Add stock</button>
												</div>
												<div class="clear"></div>
											</div><div class="clear"></div>
										</div>
										<div class="msg_error" id="non_sn_msg_error"></div>
										
										
								</div>		
										
							</div>																														
						</fieldset>
<!--  ############################################### End Add Stock  ###########################################################   -->			
		</div><!-- END content_body -->
				<input type="hidden"  id="po"  name="po" value="<%=po_no %>">
				<input type="hidden"  id="pn" name="pn" value="<%=entity.getPn()%>">
				<input type="hidden"  id="id"  name="id" value="<%=entityPR.getId()%>">
				<input type="hidden"  id="lot_price"  name="lot_price" value="<%=entityPR.getOrder_price()%>">
				<input type="hidden"  id="lot_note" name="lot_note"  value="<%=entityPR.getNote()%>">
				<input type="hidden"  id="create_by" name="create_by"  value="<%=securProfile.getPersonal().getPer_id() %>">
				<input type="hidden"  name="recive_qty"  id="recive_qty" value="<%=recive_qty%>">
	
	</form><!--END add_stock_detail -->
</div><!--END body_content -->
