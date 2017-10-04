<%@page import="com.bitmap.supper.session.SupperSessionTS"%>
<%@page import="com.bmp.part.master.bean.PartMasterBean"%>
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

<!-- autoNumeric -->
	<script type="text/javascript" src="../js/autoNumeric/two_decimal_places.js" ></script>
	<script type="text/javascript" src="../js/autoNumeric/autoNumeric.js" ></script>
	<script type="text/javascript" src="../js/autoNumeric/jquery.autotab-1.1b.js" ></script>
	
	<script type="text/javascript" src="../js/autoNumeric/jquery-price_format-2-0-min.js" ></script>
	<script type="text/javascript" src="../js/autoNumeric/jquery-price_format-2-0.js" ></script>
	


<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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

//String base_qty =  ServicePartDetail.selectQty(id, pn);
%>
<style type="text/css">
<!--
		.d50{			
			width:50px !important;
			float: left;
		}
		.d50r{			
			margin-top: 30px !important;
			width:25px !important;
			float:left;
		}
		
		.d80{			
			width:80px !important;
			float: left;
		}
		.d100{
			/* height:50px !important; */
			width:100px  !important;
			float: left;
		}
		.d120{			
			width:120px !important;
			float: left;
		}
		.d150{			
			width:150px !important;
			float: left;
		}
		.d200{		
				
			width:200px !important;		
			float: left;	
		}
		.d250{			
			width:250px !important;
			float: left;
		}
		.d260{			
			width:260px !important;
			float: left;
		}
		.d270{			
			width:270px !important;
			float: left;
		}
		.d280{			
			width:280px !important;
			float: left;
		}
		.d290{			
			width:290px !important;
			float: left;
		}
		.d300{			
			width:300px !important;
			float: left;
		}
		.d400{
			width:400px !important;
			float: left;
		}
		.d480{			
			width:480px !important;
			float:left;
			
		}
		.d500{			
			width:500px !important;
			float:left;
		}
		.d560{			
			width:560px !important;
			float:left;
		}
		.d600{			
			width:600px !important;
			float:left;
		}
		.clear{
			clear:both;
		}
		.m_top5_bom5{
		 margin-top:5px !important;
		 margin-bottom:5px !important;
		 
		}
		 .detail_box1 {
	    border: 1px solid #666666 !important;
	    border-radius: 4px !important;
	    margin: 0 auto 10px !important;
	    padding: 10px !important;
		} 
-->
</style>
<div class="wrap_auto">	
	<div class="wrap_body">
		<div class="m_top15"></div>
		<div class="body_content">
			<div class="content_head">
				<div class="left">Part Search</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body_bank" >
			
				<form id="material_add_form" onsubmit="return false;">	
				<div class="content_body">
				
						<%		int i=1;
									boolean last = false;
									List lst = null;
									lst = SupperSessionTS.selectListSS(pn);
									Iterator itr = lst.iterator();
									while(itr.hasNext()){
										PartMasterBean entity = (PartMasterBean) itr.next() ;
										String base_qty =  ServicePartDetail.selectQty(id, entity.getPn());
								
										
										String bg = "";
										String box = " _box status_box";
										last = false;
										if(entity.getPn().equalsIgnoreCase(pn)){
											bg = " style=\"background-color: #ccc;\"";
											
											box = " _box current_status_box";
											last = true;
										}
															
								%>
									<!-- /***************************************************************************/ -->
						
						<div class="boxde" index="<%= i %>"></div>
						<div class="detail_box1  d560" <%=bg%> >
						<div class="d500">
							<div class="d300">	
							<div class="d80" >
								<Strong>PN</Strong> 
							</div>
							<div class="d170">
								: &nbsp;<span id="pn_sapn"><%= entity.getPn() %></span>
								<input type="hidden" name="pn" class="pn"  value="<%= entity.getPn() %>"  index="<%= i %>">																						
								<input type="hidden" name="base_qty" class="base_qty"  value="<%= base_qty %>"  index="<%= i %>" >	 
							</div >
							</div>
							
							<div class="d200">
							<div class="d80">	
								<Strong>Stock Qty</Strong>
							</div>
							<div class="d120">	
								: &nbsp;<span id="stock_qtys"><%= entity.getQty() %></span>	
								<input type="hidden"  name="qtyStock" class="qtyStock"  value="<%= entity.getQty() %>" index="<%= i %>">		
								<input type="hidden" name="moq" class="moq"  value="<%= entity.getMoq() %>" index="<%= i %>">																			
							</div>
							</div>
							
							<div class="clear"></div>
							
							<div class="d300">
							<div class="d80">	
							<Strong>Description</Strong> 
							</div>
							<div class="d170">
							: &nbsp;<span id="description"><%= entity.getDescription()  %></span>														
							</div>
							</div>
							
							<div class="d200">
							<div class="d80">
							<Strong>Qty</Strong>
							</div>
							<div class="d120">
							: &nbsp;<input type="text" name="qty" class="txt_box s50 qty"  onkeyup='checkNumber(this)' title="*" autocomplete="off" value="0" index="<%= i %>">	
							</div>
							</div>	
							<div class="clear"></div>
							<div class="d300">
							<div class="d80">
							<Strong>Fit-To</Strong>
							</div>
							<div class="d170">
							 : &nbsp;<span id="Fit_to"><%= entity.getFit_to() %></span>								 
							</div>
							</div>								
							
							<div class="d200">
							<div class="d80">
							<Strong>Discount</Strong>
							</div>
							<div class="d120">
							: &nbsp;<input type="text" name="discount"  class="txt_box s30 auto discount" onkeyup='CheckDisc(this)' autocomplete="off"  value="0"  class="txt_box  "  index="<%= i %>"> %												 
							</div>
							</div>																			
						<div class="clear"></div>							
						<div class="d300">
							<div class="d80">
							<Strong>Price</Strong>
							</div>
							<div class="d170">
							 : &nbsp;<span id="stock_qty"><%= entity.getPrice() %></span>	
							 <input type="hidden" name="price"  class="txt_box price" title="*" autocomplete="off" value="<%= entity.getPrice() %>" index="<%= i %>">
							</div>
							</div>	
						<div class="clear"></div>
						</div>	
						
						
						<div class="d50r">
						<%if(!entity.getQty().equalsIgnoreCase("0")) {%>
							<input type="radio" id="select_pn" name="select_pn" value="<%= i %>" class="select_pn" index="<%= i %>"  style="margin-top: 10px;" >
						<%}else{ %>
						 <div class="Dev_RA">
						  <input type="radio" id="select_pn" name="select_pn" value="<%= i %>" class="select_pn" index="<%= i %>" >						
						 </div>						 
						<%}%>
						</div>
						</div>
						
									<!-- /***************************************************************************/ -->									
						
						<%
						i++;
						
						} %>
				
				
				<script type="text/javascript">
				
				function  checkNumber(data){
				
					  if(!data.value.match(/^\d*$/)){
					     alert('จำนวนกรอกตัวเลขเท่านั้น');
					     data.value='';
					     var index = $("input:radio[name=select_pn]:checked").attr('index');	
					     $('.qty[index="'+index+'"]').focus();
					  }
				 }
				
				function CheckDisc(data){					
					var index = $("input:radio[name=select_pn]:checked").attr('index');
					
					$('.discount[index="'+index+'"]').autotab_magic().autotab_filter( {format: 'custom', pattern: '[^0-9\.]', maxlength: 15 });// จุดทศนิยม
					
				};
				
				$(function(){
					 var form = $('#material_add_form');	
					 var moq 		="";
					 var qtyStock 	="";
					 var qty 		="";
					 var base_qty 	="";
					
				 	 var qty_requir 	= "";
					 var qty_stock 	= "";					
					 var price		= "";					
					 var pn 			= "";					
					 var discount 	= "";
					
					 var vat			= '<%=ServicePartDetail.PART_VAT %>';
					 var total_vat 	= '0.00' ;
					 var id 			= '<%=id%>';		
					 var create_by 	= '<%=securProfile.getPersonal().getPer_id()%>';
					
					defaultIndexRadio();
					/*************************************************************************************/
				   				    
					function defaultIndexRadio() {
						$('.Dev_RA #select_pn').hide();
						var box = parseInt($('.boxde').attr('index'));							
						var name = "select_pn";
						
						var box_qty = parseInt($('.qtyStock[index="'+box+'"]').val());
						//alert("box_qty :"+box_qty);
						if(box_qty != '0'){							
							$('input[name="'+name+'"][value="'+box+'"]').attr('checked',true);							
						}else{
							box = box +1 ;
							$('input[name="'+name+'"][value="'+box+'"]').attr('checked',true);

							/* ************************************************************** */
							var index = $("input:radio[name=select_pn]:checked").attr('index');	 
							 if($("input:radio[name=select_pn]").is(':checked')){
								 qty_stock = parseInt($('.qtyStock[index="'+index+'"]').val());							 
								// alert("index : box"+box+" index :"+index +" qty_stock :"+qty_stock);
								 if ( qty_stock == '0' ) {								
									 box = parseInt(index) + 1;
									 //alert("index : box"+box+" index :"+index +" qty_stock :"+qty_stock);
									 $('input[name="'+name+'"][value="'+box+'"]').attr('checked',true);		
								 }else{								
									 $('input[name="'+name+'"][value="'+box+'"]').attr('checked',true);								
								 }						
							 }
							/* ************************************************************** */						
						}
					}
					 	
					/***********************************************************************************/
					form.submit(RegisFromAddPN);	
					 /**********************************************************************************/
					 
					function Validate() {
						 var index = $("input:radio[name=select_pn]:checked").attr('index');						
						 if($("input:radio[name=select_pn]").is(':checked')){
												
							// alert("PN : "+$('.pn[index="'+index+'"]').val());	
							 
							  moq 		= $('.moq[index="'+index+'"]').val();
							  qtyStock 	= $('.qtyStock[index="'+index+'"]').val();
							  qty 		= $('.qty[index="'+index+'"]').val();
							  base_qty 	= $('.base_qty[index="'+index+'"]').val();
							  
							  qty_requir = parseInt($('.qty[index="'+index+'"]').val());
							  qty_stock = parseInt($('.qtyStock[index="'+index+'"]').val());					
							  price		= $('.price[index="'+index+'"]').val();						
							  pn 		= $('.pn[index="'+index+'"]').val();					
							  discount 	= $('.discount[index="'+index+'"]').val();
							  						
							 // alert("moq:"+moq+" qtyStock :"+qtyStock + " qty: "+qty+" base_qty:"+base_qty+"(parseInt(qty)) + parseInt(base_qty))::"+(parseInt(qty) + parseInt(base_qty)));
							  
							  if( qty == '' || qty == '0'|| qty == '0.00'){
								  	alert('กรุณาตรวจสอบจำนวน!');
									$('.qty[index="'+index+'"]').val("");
									$('.qty[index="'+index+'"]').focus();
									return false;
							  }
							  if( price == '' || price == '0'|| price == '0.00'){
								  alert('กรุณาตรวจสอบราคา!');
								  $('.price[index="'+index+'"]').focus();
								  return false;
							  }
							  if( discount == ''){
								  alert('กรุณาตรวจสอบส่วนลด!');								  
								  $('.discount[index="'+index+'"]').focus();
								  return false;
							  }							  
							  if (parseInt(qtyStock) < (parseInt(qty) + parseInt(base_qty))) {
									alert("สินค้าหมด เบิกสินค้าเพิ่ม!");
									return false;
							  }
							  if (parseInt(moq) == (parseInt(qtyStock) - (parseInt(qty) + parseInt(base_qty)))) {
									alert("สินค้าใกล้หมด ควรเบิกสินค้าเพิ่ม!");
									 return true;
							  }								
							  if (parseInt(qtyStock) == (parseInt(qty) + parseInt(base_qty))) {
									alert("สินค้าชิ้นสุดท้ายแล้ว ควรเบิกสินค้าเพิ่ม!");
									 return true;
							  }
							  
							  
						 }else {
							 alert("กรุณาเลือกสินค้า!");
							 return false;
						 }	
						 return true;
					}
					
					/*****************************************************************************/
					function RegisFromAddPN() {
						if (Validate()) {
							if (qty_requir > qty_stock ) {
								//alert("qty_requir > qty_stock ");
								if (confirm('จำที่ใส่มากกว่าสินค้าคงคลัง   ** หากยืนยันจำนวนที่มากกว่าท่านอาจไม่สามารถปิด จ็อบได้ **')) {
									
									ajax_load();
									$.post('../PartSaleManage','action=sale_part_add&base_qty='+base_qty+'&create_by='+create_by+'&discount='+discount+'&id='+id+'&moq='+moq+'&pn='+pn+'&price='+price+'&qty='+qty+'&qtyStock='+qtyStock+'&total_vat='+total_vat+'&vat='+vat+'',function(resData){			
										ajax_remove();
										if (resData.status == 'success') {
											window.opener.location.reload(true);
											window.location.reload();
										} else {
											alert(resData.status);
										}
									},'json');
									
								}else{
									$('.qty[index="'+index+'"]').focus();
								}
								
							}else{
							//alert("else : base_qty="+base_qty+"&create_by="+create_by+"&discount="+discount+"&id="+id+"&moq="+moq+"&pn="+pn+"&price="+price+"&qty="+qty+"&qtyStock="+qtyStock+"&total_vat="+total_vat+"&vat="+vat);	
								
								ajax_load();									
								  $.post('../PartSaleManage','action=sale_part_add&base_qty='+base_qty+'&create_by='+create_by+'&discount='+discount+'&id='+id+'&moq='+moq+'&pn='+pn+'&price='+price+'&qty='+qty+'&qtyStock='+qtyStock+'&total_vat='+total_vat+'&vat='+vat+'',function(resData){	
									ajax_remove();
									
									if (resData.status == 'success') {
										window.opener.location.reload(true);
										window.location.reload();
									} else {
										alert(resData.status);
									}
								},'json'); 
								
							}					
						}
						return false;	
					}
					
					/*****************************************************************************/
					
					
				});
						
				</script>
				
				<div class="txt_center m_top20">
					<input type="submit" name="add" class="btn_box btn_confirm" value="Submit">				
					<input type="button" class="btn_box btn_warn" value="Close Display" onclick="tb_remove();">	
				</div>
			</div>
			</form>
			</div>
			
			
			</div>
		</div>
	</div>	
</div>  