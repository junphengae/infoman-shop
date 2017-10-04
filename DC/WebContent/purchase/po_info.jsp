<%@page import="com.bmp.purchase.transaction.VendorTS"%>
<%@page import="com.bmp.purchase.bean.VendorBean"%>
<%@page import="com.bitmap.utils.report.Mobile"%>
<%@page import="com.bmp.purchase.bean.PurchaseRequestBean"%>
<%@page import="com.bmp.purchase.transaction.PurchaseStatus"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bmp.purchase.transaction.PurchaseOrderTS"%>
<%@page import="com.bmp.purchase.bean.PurchaseOrderBean"%>
<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.purchase.PurchaseOrder"%>
<%@page import="Component.Accounting.Money.MoneyAccounting"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css">
<link href="../css/unit.css" rel="stylesheet" type="text/css">
<link href="../css/table.css" rel="stylesheet" type="text/css">
<link href="../css/loading.css" rel="stylesheet" type="text/css">

<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/jquery.metadata.js" type="text/javascript"></script>
<script src="../js/jquery.validate.js" type="text/javascript"></script>
<script src="../js/thickbox.js" type="text/javascript"></script>
<script src="../js/loading.js" type="text/javascript"></script>
<script src="../js/number.js" type="text/javascript"></script>
<script src="../js/ZeroValueFormat.js" type="text/javascript"></script>

<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.datepicker.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
String po = WebUtils.getReqString(request, "po");
String pono = po.toString();

PurchaseOrderBean PO = PurchaseOrderTS.select(po);
VendorBean vendor = VendorTS.select(PO.getVendor_id().trim());
Iterator ite = PO.getUIOrderList().iterator();

String span_net_amount ;
%>
<title>รายละเอียดใบสั่งซื้อ</title>
<style type="text/css">
.po_head table{border-collapse: collapse; width: 100%;}
.po_head table tr{border: 1px solid #111;}
.po_head table td{padding: 4px 3px;}
a.txt_red:hover{color: #cc0000;}
</style>

<script type="text/javascript">
$(function(){
			
	   $('#btn_print_again1').click(function(){
			
			//alert("print1");
			return true;
		});
		
		$('#btn_print_again').click(function(){
			return true;
			//alert("print");
			
		});  
		 
		$('#btn_print').click(function(){
			
				var pono = "<%=po%>";
				if (confirm('เมื่อยื่นอนุมัติแล้วจะไม่สามารถยกเลิกได้')) {
						
						ajax_load();
						$.post('../PurchaseManage',{'action':'confirm_po','po':pono},function(resData){
							ajax_remove();
							if (resData.status == 'success') {
								window.location.reload();
							} else {
								alert(resData.message);
							}
						},'json');
					}else{
						return false;
					}
			
			
				return true;
			
		});
	
	
	
	
	
});

</script>

</head>
<body ><!-- onLoad="onload()" -->

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายการใบสั่งซื้อ [PO] | รายละเอียดใบสั่งซื้อ </div>
				<div class="right m_right10">
					<%if(PO.getStatus().equalsIgnoreCase(PurchaseStatus.STATUS_PO_OPENING) || PO.getStatus().equalsIgnoreCase(PurchaseStatus.STATUS_PO_OPEN)){%>
					<button class="btn_box btn_confirm" onclick="javasript: window.location='po_issue_review.jsp?po=<%=PO.getPo()%>';">แก้ไขใบสั่งซื้อ</button>
					<%}%>
					<button class="btn_box" onclick="window.location='po_list.jsp'">ย้อนกลับ</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<form id="issue_po_form" action="../ReportUtilsServlet" target="_blank" method="post" onsubmit="return true;">
					
					
						<div class="po_head s350 right">
							<table>
								<tr>
									<td>เลขที่ (P/O. NO.) </td><td>: <%=PO.getPo()%></td>
								</tr>
								<%if (PO.getReference_po().length() > 0) { %>
								<tr>
									<td>ออกแทน P/O. NO. </td><td>: <%=PO.getReference_po()%></td>
								</tr>
								<%}%>
								<tr>
									<td>วันที่ (Date) </td><td>: <%=WebUtils.getDateValue(PO.getCreate_date())%></td>
								</tr>
								<tr>
									<td>กำหนดส่ง (Delivery Date) </td><td>: <%=(PO.getDelivery_date()== null)?"":WebUtils.getDateValue(PO.getDelivery_date())%></td>
								</tr>
								<tr>
									<td>เครดิต (Credit) </td><td>: <span id="view_vendor_credit"><%=vendor.getVendor_credit()%></span></td>
								</tr>
								<tr>
								</tr>
							</table>
						</div>
						<div class="clear"></div>
						<div class="vendor_info b_1 m_top5 pd_5">
							<table width="98%" class="center">
								<tr height="24" valign="top">
									<td width="120">บริษัท (Order To)</td>
									<td>: 
										<span id="view_vendor_name"><%=vendor.getVendor_name() %></span>
										<% if(vendor.getVendor_name().length()> 0){ %>
										<%-- <div class="btn_box btn_confirm thickbox right" title="แก้ไขข้อมูลตัวแทนจำหน่าย" lang="vendor_edit_po.jsp?vendor_id=<%=vendor.getVendor_id()%>">แก้ไข</div><div class="clear"></div> --%>
										<%-- <div class="btn_box btn_confirm thickbox right" title="แก้ไขข้อมูลตัวแทนจำหน่าย" lang="vendor_edit_po.jsp?vendor_id=<%=vendor.getVendor_id()%>&po=<%=PO.getPo()%>">แก้ไข</div><div class="clear"></div> --%>
										<%} %>
									</td>
								</tr>
								<tr height="24" valign="top">
									<td>ถึง (ATTN)</td>
									<td>: <span id="view_vendor_attn"><%=vendor.getVendor_contact()%></span></td>
								</tr>
								<tr height="24" valign="top">
									<td>โทร (TEL)</td>
									<td> 
										<div class="left s350">: <span id="view_vendor_phone"><%=Mobile.mobile(vendor.getVendor_phone()) %></span></div>
										<div class="left">แฟกซ์ (FAX) : <span id="view_vendor_fax"><%=Mobile.mobile(vendor.getVendor_fax()) %></span></div>
										<div class="clear"></div>
									</td>
								</tr>
							</table>
						</div>
						
						<div class="dot_line m_top10"></div>
						
						<div class="m_top5 center">
							
							<table class="bg-image s930">
								<thead>
									<tr>
										<th valign="top" align="center" width="6%">ที่<br>(No.)</th>
										<th valign="top" align="center" width="15%">รหัสสินค้า<br>(Part Number)</th>
										<th valign="top" align="center" width="29%">รายการสินค้า<br>(Description)</th>
										<th valign="top" align="center" width="9%">สถานะ<br>(Status)</th>
										<th valign="top" align="center" width="5%">หน่วยนับ<br>(Units)</th>									
										<th valign="top" align="center" width="8%">จำนวน<br>(Quantity)</th>
										<th valign="top" align="center" width="14%">ราคาต่อหน่วย<br>(Unit Price)</th>
										<th valign="top" align="center" width="14%">จำนวนเงิน<br>(Amount)</th>
									</tr>
								</thead>
								<tbody>
								<%
									int i = 1;
									Boolean hasCheck =false;
									
								 	String amount = "0";
									Double gross_amount = 0.00;
									String discount_pc = "0";
									String discount = "0";
									String net_amount = "0";
									String vat_amount = "0";
									String grand_total = "0";
																	
									while(ite.hasNext()) {
										hasCheck = true;
										PurchaseRequestBean entity = (PurchaseRequestBean) ite.next();
									//	InventoryMaster master = entity.getUIInvMaster();
										PartMaster master = PartMaster.select(entity.getMat_code());

										int qty = Integer.parseInt(entity.getOrder_qty()) ;
										Double price = Double.valueOf(entity.getOrder_price()) ;
										amount = Money.money(qty * price);  //(Amount)จำนวนเงิน
										gross_amount += Double.parseDouble(Money.removeCommas( amount ));
										
										
								%>
									<tr id="tr_<%=entity.getId()%>" valign="middle">
										<td align="center"><%=i++%></td>
										<td align="left"><%=master.getPn()%></td>
										<td align="left"><%=master.getDescription()%></td>
										<td align="center">
											<%=PurchaseStatus.status(entity.getStatus())%>
											<%--
												<button class="thickbox pointer btn_box" lang="po_info_detail.jsp?po=<%=PO.getPo()%>&mat_code=<%=entity.getMat_code()%>" title="รายงานการนำเข้าสินค้า : <%=entity.getMat_code()%> - <%=master.getDescription()%>">รายงาน</button>
		 									--%>
										</td>
										<td align="left"> <%=UnitType.selectName( master.getDes_unit() )%></td>
										<td align="right"><%=Money.moneyInteger(entity.getOrder_qty())%> </td>
										<td align="right"><%=Money.money( entity.getOrder_price() )  %></td>
										<td align="right"><%=Money.money( amount )%></td>
									</tr>
								<%
									}
								%>
								<script type="text/javascript">
								$(function(){
									var discount_pc = $('#discount_pc');
									var span_discount = $('#span_discount');
									
									var discount = $('#discount');
									
									var vat = $('#vat');
									var span_vat = $('#span_vat');
									var vat_amount = $('#vat_amount');
									
									DiscountChang();
									discount_pc.keyup(function() {
										  //alert( ".keyup() " +discount_pc.val());
										  DiscountChang();
									});
									discount.keyup(function() {
										  //alert( ".keyup() " +discount.val());
										  DiscountChang();
									});
									vat.keyup(function() {
										  //alert( ".keyup() " +discount.val());
										  DiscountChang();
									});
									
									
									function DiscountChang() {
										
										var gross_amount = '<%=gross_amount%>';
										var v_discount_pc ='0.00';
										var v_discount    ='0.00';
										
										v_discount_pc = (( parseFloat(removeCommas(gross_amount)) *   parseFloat(removeCommas(discount_pc.val())) ) /100).toFixed(2) ;
										v_discount    =  parseFloat(removeCommas(discount.val())).toFixed(2);
										
										var v_grand_total = (gross_amount - (v_discount_pc - v_discount)).toFixed(2) ;
										var v_vat_amount  = (( v_grand_total * parseFloat(removeCommas(vat.val()))  )/107).toFixed(2) ;
										var v_net_amount  = (v_grand_total - v_vat_amount).toFixed(2) ;
										
										span_discount.text(money(v_discount_pc));
										span_vat.text(money(v_vat_amount));
										vat_amount.val(v_vat_amount);
										
										$('#span_grand_total').text(money(v_grand_total));
										$('#span_net_amount').text(money(v_net_amount));
										$('#grand_total').val(v_grand_total);
										$('#net_amount').val(v_net_amount);

									<%-- 	
										<%
										discount_pc = Money.money(( gross_amount * Double.parseDouble(Money.removeCommas( PO.getDiscount_pc() )) )/100)  ;
										discount    = Money.money(PO.getDiscount());
										grand_total = Money.money(gross_amount - Double.parseDouble(Money.removeCommas(discount_pc))- Double.parseDouble(Money.removeCommas(discount)));
										vat_amount  = Money.money((Double.parseDouble(Money.removeCommas(grand_total))*7)/107) ;
										net_amount  = Money.money(Double.parseDouble(Money.removeCommas(grand_total)) - Double.parseDouble(Money.removeCommas(vat_amount))) ;
										
										%> --%>
									
									
									}
									
									
								
								});
								
								</script>
								
									<tr>
										<td colspan="7" align="right">รวมราคา (Gross Amount)</td>
										<td align="right"><span id="span_gross_amount"><%=Money.money(gross_amount) %></span><input type="hidden" name="gross_amount" id="gross_amount" value="<%=gross_amount%>"></td>
									</tr>
									<tr>
										<td colspan="7" align="right">ส่วนลด (Discount) <%=Money.money(PO.getDiscount_pc())%>
											<input type="hidden" class="txt_box s30 txt_center" name="discount_pc" id="discount_pc" maxlength="3" value="<%=PO.getDiscount_pc()%>"> %</td>
										<td align="right"><span id="span_discount" ></span> 	
										</td>
									</tr>
									<tr>
										<td colspan="7" align="right">หรือ ส่วนลด (Discount) เป็นบาท</td>
										<td align="right"><%=Money.money(PO.getDiscount())%>																					
											<input type="hidden" class="txt_box s_auto txt_right" name="discount" id="discount" value="<%=PO.getDiscount()%>"></td>
									</tr>
									<tr>
										<td colspan="7" align="right">รวมราคาหลังหักส่วนลด (Net Amount)</td>
										<td align="right">										
										<span id="span_net_amount"></span>
										<input type="hidden" name="net_amount" id="net_amount" value="0.00"></td>
									</tr>
									<tr>
										<td colspan="7" align="right">ภาษีมูลค่าเพิ่ม (VAT)<%=PO.getVat()%> <input type="hidden" class="txt_box s30 txt_center" name="vat" id="vat" value="<%=PO.getVat()%>"> %</td>
										<td align="right"><span id="span_vat"></span>
										<input type="hidden" name="vat_amount" id="vat_amount" value="0.00"></td>
									</tr>
									<tr class="txt_bold">
										<td colspan="7" align="right">รวมเป็นเงิน (Grand Total)</td>
										<td align="right">
										<span id="span_grand_total"></span>
										<input type="hidden" name="grand_total" id="grand_total" value="0.00"></td>
									</tr>
								</tbody>
							</table>
						</div>
						
						<div class="center right m_top5 pd_5">
							<div class="left">หมายเหตุ : </div> 
							<div class="left m_left5"><%=PO.getNote().replaceAll("\n", "<br>").replaceAll(" ", "&nbsp;")%></div>
							<div class="clear"></div>
						</div>
						<div class="clear"></div>
						 
						<input type="hidden" name="po" value="<%=po%>">
						<input type="hidden" name="action" value="save_po">
						<input type="hidden" name="type" value="PO">
						<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
						<div class="center txt_center m_top5">
							
									<%if((PO.getStatus().equalsIgnoreCase(PurchaseStatus.STATUS_PO_OPENING) || PO.getStatus().equalsIgnoreCase(PurchaseStatus.STATUS_PO_OPEN)) && !(PO.getDelivery_date()== null) && ( hasCheck == true)){%>
											<!-- <button class="btn_box btn_confirm" id="btn_print">ยื่นขออนุมัติ</button> -->
											<button type="submit"  class="btn_box  btn_confirm"  id="btn_print" >ยื่นขออนุมัติ</button>
											<button class="btn_box btn_warn thickbox" lang="po_cancel_popup.jsp?width=450&height=200&po=<%=PO.getPo()%>" title="ยกเลิกใบสั่งซื้อ">ยกเลิกใบสั่งซื้อ</button>
										
									<%} else if(PO.getStatus().equalsIgnoreCase(PurchaseStatus.STATUS_PO_CLOSE)) { Personal p_up = Personal.select(PO.getUpdate_by());%>
										ปิดใบสั่งซื้อแล้ว 
									<%} else if(PO.getStatus().equalsIgnoreCase(PurchaseStatus.STATUS_ORDER)) { %>
										ใบสั่งซื้อนี้อยู่ในระหว่างการรออนุมัติ 
										
										<br/><br/>
										<button  type="submit" class="btn_box  btn_confirm" id="btn_print_again1">พิมพ์ใบสั่งซื้อ</button>
										
									<%} else if(PO.getStatus().equalsIgnoreCase(PurchaseStatus.STATUS_MD_APPROVED)) { %>
										ใบสั่งซื้อนี้ได้รับการอนุมัติแล้ว 
										
										<br/><br/>
										<button type="submit" class="btn_box  btn_confirm" id="btn_print_again">พิมพ์ใบสั่งซื้อ</button>
										
											
									<%} else if(PO.getStatus().equalsIgnoreCase(PurchaseStatus.STATUS_MD_REJECT)) { %>
									
											<br/>
											ใบสั่งซื้อนี้ไม่ได้รับการอนุมัติ กรุณาแก้ไขใบสั่งซื้อ 
											<br/><br/> 
											<%-- <button class="btn_box btn_confirm" onclick="javasript: window.location='po_issue_review.jsp?po=<%=PO.getPo()%>';">แก้ไขใบสั่งซื้อ</button> --%>
											
									<%} else if(PO.getStatus().equalsIgnoreCase(PurchaseStatus.STATUS_CANCEL)) { 
											Personal p_up = Personal.select(PO.getUpdate_by());%>
									
										ยกเลิกใบสั่งซื้อโดย <%=p_up.getName() + " " + p_up.getSurname()%></div>
									<%}%>
					</form>
					
				</div>
			
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
</body>
</html>