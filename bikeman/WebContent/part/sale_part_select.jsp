<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.parts.ServicePartDetail"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.security.SecurityUser"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="../js/common.js"></script>
<script src="../js/validator.js"></script>
<title>Part List</title>
<%

String pn = WebUtils.getReqString(request, "pn");
String id = WebUtils.getReqString(request, "id");

String page_ = WebUtils.getReqString(request, "page");
PageControl ctrl = new PageControl();
ctrl.setLine_per_page(20);

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("SV_CUS_PAGE", page_);
}

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("SV_CUS_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("SV_CUS_PAGE")));
}

String base_qty =  ServicePartDetail.selectQty(id, pn);


String UnitDesc = UnitType.selectName(PartMaster.SelectUnitDesc(pn));


%>
<div class="wrap_auto">	
	<div class="wrap_body">
		<div class="m_top15"></div>
		<div class="body_content">
			<div class="content_head">
				<div class="left">Part Search</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body_bank">
				<form id="material_add_form" onsubmit="return false;">
				<div class="m_top10"></div>
				<table width="100%" class="center" id="tb_material_add" border="0" cellpadding="4" cellspacing="4">
					<tbody>
						<tr>
							<td width="25%" align="left"><Strong>PN</Strong></td>
							<%
								String part_no = PartMaster.select(pn).getPn().trim();
							%>
							<td width="75%" align="left">: &nbsp;&nbsp;&nbsp;&nbsp;<%=part_no%>
								
								<input type="hidden" name="pn" id="pn"  value="<%=part_no%>">		
								&nbsp;&nbsp;				
								<!-- 
								<button type="button" class="btn_box btn_search thickbox" lang='sale_part_search.jsp?width=450&hieght=350'>Search</button>
									 -->
								<input type="hidden" name="base_qty" id="base_qty"  value="<%=base_qty%>">	 
							</td>
						</tr>
						<tr>
							<td align="left"><Strong>Description</Strong></td>
							<td align="left">: &nbsp;&nbsp;&nbsp;&nbsp;<span id="description"><%=PartMaster.select(pn).getDescription() %></span>
							</td>
						</tr>
						<tr>
							<td align="left"><Strong>Price</Strong></td>
							<td align="left">: &nbsp;&nbsp;&nbsp;&nbsp;
								<span id="stock_qty"><%=Money.money(PartMaster.select(pn).getPrice()) %></span>
								<input type="hidden" name="price" id="price" class="txt_box " title="*" autocomplete="off" value="<%=PartMaster.select(pn).getPrice() %>">
								</td>
						</tr>
						<tr>
							<td align="left"><Strong>Stock Qty</Strong></td>
							<td align="left">: &nbsp;&nbsp;&nbsp;&nbsp;<span id="stock_qty"><%=PartMaster.select(pn).getQty() +" "+ UnitDesc%></span>
							
								<input type="hidden"  name="qtyStock" id="qtyStock"  value="<%=PartMaster.select(pn).getQty()%>">		
								<input type="hidden" name="moq" id="moq"  value="<%=PartMaster.select(pn).getMoq()%>">
								
								
							
							</td>
						</tr>
						<tr>
							<td colspan="2"><div class="dot_line"></div></td>
						</tr>
						<tr>
							<td align="left"><Strong>Qty</Strong></td>
							<td align="left">: &nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="qty" id="qty" class="txt_box "  title="*" autocomplete="off" value="0" onblur="calculateNetPrice()" onchange="return validNumberOnKeyUp(this, event)" ></td>
						</tr>

						<tr>
							<td align="left"><Strong>Discount % </Strong></td>
							<td align="left">: &nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="discount" id="discount" class="txt_box s40"  autocomplete="off"  value="0.00"  class="txt_box" onchange="return validCurrencyOnKeyUp(this, event)" onblur="calculateDiscount()" > %
							&nbsp;&nbsp;&nbsp;
							 คิดเป็นเงิน : 
							 <span id="spd_dis2">0</span>
							 <input type="hidden" name="spd_dis" id="spd_dis" class="txt_box s40"  autocomplete="off"  value="0"  class="txt_box" > บาท
							</td>	
						</tr>
						<tr>
							<td align="left"><Strong>Discount เงินสด </Strong></td>
							<td align="left">: &nbsp;&nbsp;&nbsp;
							<input type="text" name="cash_discount" id="cash_discount" class="txt_box s40"  autocomplete="off"  value="0.00"  class="txt_box" onblur="calculateTotalDiscount()" onchange="return validCurrencyOnKeyUp(this, event)">
							  บาท
							</td>	
						</tr>
						<tr>
							<td align="left"><Strong>รวมเงินส่วนลด </Strong></td>
							<td align="left">: &nbsp;&nbsp;&nbsp;&nbsp;
								<span id="spd_dis_total_txt">0</span>  บาท
								<input type="hidden" name="spd_dis_total" id="spd_dis_total" class="txt_box s40"  autocomplete="off"  value="0"  class="txt_box" >
							 </td>
						
						</tr>
						<tr>
							<td align="left"><Strong>รวมยอดเงินชำระ </Strong></td>
							<td align="left">: &nbsp;&nbsp;&nbsp;&nbsp;
								<span id="spd_net_price_txt">0</span>  บาท
								<input type="hidden" name="spd_net_price" id="spd_net_price" class="txt_box s40"  autocomplete="off"  value="0"  class="txt_box" > </td>
						
						</tr>
					</tbody>
				</table>
				
				<script type="text/javascript">
				/*  onkeyUp  validate Number  */
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

				function calculateDiscount() {
					var percen_discount = $('#discount').val();
					var discount_amount = (($('#price').val()*$('#qty').val()) * percen_discount) / 100 ;
					$('#spd_dis').val(discount_amount);
					$('#spd_dis2').text(discount_amount);
					calculateTotalDiscount();
					
				}
				
				function calculateTotalDiscount() {
					var total_discount = parseFloat($('#spd_dis').val()) + parseFloat($('#cash_discount').val());
					$('#spd_dis_total').val(total_discount);
					$('#spd_dis_total_txt').text(total_discount);
					calculateNetPrice();
				}

				function calculateNetPrice() {
					var net_price = parseFloat($('#price').val()*$('#qty').val() ) - $('#spd_dis_total').val();
					if(net_price<0){
						alert('ส่วนลดมากกว่าราคารวม');
						return true;
					}else{
						$('#spd_net_price_txt').text(net_price);
						$('#spd_net_price').val(net_price);
					}
					
				}
				
				function  checkNumber(data, ele){
					  if(!data.value.match(/^\d*$/)){
					     alert('จำนวนกรอกตัวเลขเท่านั้น');
					     data.value='';
					     ele.focus();
					     return false;
					  }
					  return true;
				 }	
				
			
				/*  onkeyUp  validate Number  */
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
				
			 
					$(function() {

					$('#qty').keyup(function(e) {
							var data = $(this).val();
							if (e.keyCode == '13') {
								if (!data == '') {
									$('#material_add_form .btn_confirm').submit();
								}
							}
					});

					$('#discount').keyup(function(e) {
							var data = $(this).val();
							if (e.keyCode == '13') {
								if (!data == '') {
									$('#material_add_form .btn_confirm').submit();
								}
							}
					});

					$('#cash_discount').keyup(function(e) {
								var data = $(this).val();
								if (e.keyCode == '13') {
									if (!data == '') {
										$('#material_add_form .btn_confirm').submit();
									}
								}
					});
			
						
				
						
						 $('#material_add_form').submit(function( event ) {
							//  alert( "Handler for .submit() called." );
							  event.preventDefault();
							  submitMaterialAddForm();
							  $('#material_add_form').unbind('submit').submit();
							  
							});
						 
						 $( '.btn_confirm' ).click(function() {
							 $('#material_add_form').submit();
						});
						 
						 /* ************************************************************************************** */
						/*material Form*/						
						/* $('#material_add_form .btn_confirm').click(function(e) {
									
								if (calculateNetPrice()) {
									return false;
									}
										
								  calculateNetPrice();
											var moq = $('#moq').val();
											var qtyStock = $('#qtyStock').val();
											var qty = $('#qty').val();
											var base_qty = $('#base_qty').val();											
											if (parseInt(moq) == (parseInt(qtyStock) - (parseInt(qty) + parseInt(base_qty)))) {
												alert("สินค้าใกล้หมด ควรเบิกสินค้าเพิ่ม!");
											}
											if (parseInt(qtyStock) == (parseInt(qty) + parseInt(base_qty))) {
												alert("สินค้าชิ้นสุดท้ายแล้ว ควรเบิกสินค้าเพิ่ม!");
											}
											if (parseInt(qtyStock) < (parseInt(qty) + parseInt(base_qty))) {
												alert("สินค้าหมด เบิกสินค้าเพิ่ม!");
											} else {
												if (isNumber($('#qty').val())&& $('#qty').val() > 0) {
													if (isNumber($('#price').val())	&& $('#price').val() > 0) {
														if (isNumber($('#discount').val())) {
															var qty_requir = parseInt($('#qty').val());
															var qty_stock = parseInt($('#qtyStock').val());
															if (qty_requir > qty_stock) {
																if (confirm('จำที่ใส่มากกว่าสินค้าคงคลัง   ** หากยืนยันจำนวนที่มากกว่าท่านอาจไม่สามารถปิด จ็อบได้ **')) {
																	ajax_load();
																	$.post('../PartSaleManage',
																					$('#material_add_form').serialize(),function(resData) {													
																						ajax_remove();
																						if (resData.status == 'success') {
																							window.opener.location
																									.reload(true);
																							window.location
																									.reload();
																						} else {
																							alert(resData.status);
																						}
																					},
																					'json');
																} else {
																	$('#qty')
																			.focus();
																}
															} else {
															
																ajax_load();
																$.post('../PartSaleManage',$('#material_add_form').serialize(),function(resData) {
																					ajax_remove();
																					if (resData.status == 'success') {
																						window.opener.location.reload(true);
																						window.location.reload();
																					} else {
																						alert(resData.status);
																					}
																				},
																				'json');
															}
														} else {
															alert('กรุณาตรวจสอบส่วนลด!');
															$('#discount').focus();
														}
													} else {
														alert('กรุณาตรวจสอบราคา!');
														$('#price').focus();
													}
												} else {
													alert('กรุณาตรวจสอบจำนวน!');
													$('#qty').focus();
												}
											}
										}); */
						
						/* ************************************************************************************** */

					});
					
					function submitMaterialAddForm() {
								if (calculateNetPrice()) {
									return false;
									}
										
								  calculateNetPrice();
											var moq = $('#moq').val();
									var qtyStock = $('#qtyStock').val();
									var qty = $('#qty').val();
									var base_qty = $('#base_qty').val();											
									if (parseInt(moq) == (parseInt(qtyStock) - (parseInt(qty) + parseInt(base_qty)))) {
										alert("สินค้าใกล้หมด ควรเบิกสินค้าเพิ่ม!");
									}
									if (parseInt(qtyStock) == (parseInt(qty) + parseInt(base_qty))) {
										alert("สินค้าชิ้นสุดท้ายแล้ว ควรเบิกสินค้าเพิ่ม!");
									}
									if (parseInt(qtyStock) < (parseInt(qty) + parseInt(base_qty))) {
										alert("สินค้าหมด เบิกสินค้าเพิ่ม!");
									} else {
										if (isNumber($('#qty').val())&& $('#qty').val() > 0) {
											if (isNumber($('#price').val())	&& $('#price').val() > 0) {
												if (isNumber($('#discount').val())) {
													var qty_requir = parseInt($('#qty').val());
													var qty_stock = parseInt($('#qtyStock').val());
													if (qty_requir > qty_stock) {
														if (confirm('จำที่ใส่มากกว่าสินค้าคงคลัง   ** หากยืนยันจำนวนที่มากกว่าท่านอาจไม่สามารถปิด จ็อบได้ **')) {
															ajax_load();
															$.post('../PartSaleManage',
																			$('#material_add_form').serialize(),function(resData) {													
																				ajax_remove();
																				if (resData.status == 'success') {
																					window.opener.location
																							.reload(true);
																					window.location
																							.reload();
																				} else {
																					alert(resData.status);
																				}
																			},
																			'json');
														} else {
															$('#qty')
																	.focus();
														}
													} else {
													
														ajax_load();
														$.post('../PartSaleManage',$('#material_add_form').serialize(),function(resData) {
																			ajax_remove();
																			if (resData.status == 'success') {
																				window.opener.location.reload(true);
																				window.location.reload();
																			} else {
																				alert(resData.status);
																			}
																		},
																		'json');
													}
												} else {
													alert('กรุณาตรวจสอบส่วนลด!');
													$('#discount').focus();
												}
											} else {
												alert('กรุณาตรวจสอบราคา!');
												$('#price').focus();
											}
										} else {
											alert('กรุณาตรวจสอบจำนวน!');
											$('#qty').focus();
										}
									}
					}
				</script>
				
				<div class="txt_center m_top20">
				   
					<input type="hidden" name="vat" id="vat" value="<%=ServicePartDetail.PART_VAT %>" > 
					<input type="hidden" name="total_vat" id="total_vat" value="0" > 
					<input type="hidden" name="id" value="<%=WebUtils.getReqString(request, "id")%>">
					<input type="button" name="add" class="btn_box btn_confirm" value="Submit">				
					<input type="button" class="btn_box btn_warn" value="Close Display" onclick="tb_remove();">				
					<input type="hidden" name="action" value="sale_part_add">
					<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
				</div>
			</form>
			</div>
		</div>
	</div>	
</div>  