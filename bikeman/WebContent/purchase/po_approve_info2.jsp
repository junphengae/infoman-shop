<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.purchase.PurchaseOrder"%>
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
////System.out.println("1. "+pono);
PurchaseOrder PO = PurchaseOrder.select(po);
Iterator ite = PO.getUIOrderList().iterator();
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
	var f_gross_amount = $('#gross_amount');
	var span_gross_amount = $('#span_gross_amount');
	var f_discount = $('#discount');
	var span_discount =$('#span_discount');
	var f_net_amount = $('#net_amount');
	var span_net_amount =$('#span_net_amount');
	var f_vat = $('#vat');
	var vat_amount = $('#vat_amount');
	var span_vat = $('#span_vat');
	var span_grand_total = $('#span_grand_total');
	var grand_total = $('#grand_total');
	var pono = "<%=po%>";	
		

	function vat(){
		var v = f_vat.val();
		var net_amount = parseFloat(f_net_amount.val());
		var vat = "0";
		
		if (v == '0' || v == '') {
			span_vat.text('0.00');
			vat_amount.val('0');
			span_grand_total.text(money(f_net_amount.val()));
			grand_total.val(f_net_amount.val());
		} else {
			if (isNumber(v)) {
				vat = net_amount * (v / 100);
				span_vat.text(money(vat));
				vat_amount.val(money(vat));
				span_grand_total.text(money(net_amount + vat));
				grand_total.val(money(net_amount + vat));
			} else {
				alert('กรุณาระบุ VAT ให้ถูกต้อง');
				f_vat.val('').focus();
			}
		}
	}

	
	function dc(){
		var net_amount = "0";
		var v = f_discount.val();
		
		if (v == '0' || v == '') {
			span_discount.text('0.00');
			span_net_amount.text(span_gross_amount.text());
			f_net_amount.val(f_gross_amount.val());
			
			vat();
		} else {
			if (isNumber(v)) {
				net_amount = discount(parseFloat(f_gross_amount.val()), v);
				span_discount.text(discount_value(parseFloat(f_gross_amount.val()), v));
				span_net_amount.text(net_amount);
				f_net_amount.val(removeCommas(net_amount));	
				
				vat();
			} else {
				alert('กรุณาระบุ Discount ให้ถูกต้อง');
				f_discount.val('').focus();
			}
		}
	}

	
	$('#btn_approve').click(function(){
				ajax_load();
				$.post('/PurchaseManage',{'action':'approve_po','po':pono},function(resData){
					ajax_remove();
					if (resData.status == 'success') {
						alert("อนุมัติใบสั่งซื้อเลขที่ : "+pono+" เรียบร้อย");
						tb_remove();
						window.location.reload(true);
					} else {
						alert(resData.message);
					}
				},'json');
		
	});
	
	$('#btn_reject').click(function(){
		if (confirm('ยืนยันการยกเลิกใบสั่ง')) {
				ajax_load();
				$.post('../PurchaseManage',{'action':'reject_po','po':pono},function(resData){
					ajax_remove();
					if (resData.status == 'success') {
						alert("ยกเลิกใบสั่งซื้อเลขที่ : "+pono+" เรียบร้อย");
						tb_remove();
						window.location.reload(true);
					} else {
						alert(resData.message);
					}
				},'json');
			}
	});
	
});
function update_data_gross_amount(gross){
	document.getElementById("gross_amount_show").value = gross;
	document.getElementById("gross_amount").value = gross;
	dc();
}




/*
	function  update_data_amt(amt){
		document.getElementById("gross_amount").value = gross;
	}
	update_data_amount(amoount);
*/
</script>

</head>
<body>

	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">
						เลขที่ (P/O. NO.) : <%=PO.getPo()%>
						<%if (PO.getReference_po().length() > 0) { %>| ออกแทน P/O. NO. : <%=PO.getReference_po()%> <%}%>
					</div>
				<div class="right m_right10">
					<%if(PO.getStatus().equalsIgnoreCase(PurchaseRequest.STATUS_PO_OPENING)){%>
					<button class="btn_box btn_confirm" onclick="javasript: window.location='po_issue_review.jsp?po=<%=PO.getPo()%>';">แก้ไขใบสั่งซื้อ</button>
					<%}%>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body_95p">
					<form id="approve_po_form" method="post">
						
						<div class="s_auto right ">
							<table>
								
								<tr>
									<td width="22%"></td>
									<td width="30%"></td>
									<td width="33%"></td>
									<td width="15%"></td>
								</tr>
								
								<tr>
									<td><strong>วันที่ (Date) </strong></td>
									<td>: <%=WebUtils.getDateValue(PO.getApprove_date())%></td>
									<td colspan="2"></td>
								</tr>
								<tr>
									<td><strong>กำหนดส่ง (Delivery Date) </strong></td>
									<td>: <%=(PO.getDelivery_date()==null)?"":WebUtils.getDateValue(PO.getDelivery_date())%></td>
									<td colspan="2"></td>
								</tr>

									<tr>
										<td colspan="2"></td>
										<td align="right"><strong>รวมราคา (Gross Amount)</strong></td>
										<td align="right">
											<span id="span_gross_amount"><div id="gross_amount_show"></div>	<%//=Money.money(gross_amount) %></span>
											<input type="hidden" name="gross_amount" id="gross_amount" value="0">
										</td>
									</tr>
									<tr>
										<td colspan="2"></td>
										<td align="right">
											<strong>ส่วนลด (Discount)</strong>
											 <input type="hidden" name="discount" id="discount" value="<%=PO.getDiscount()%>"><%=PO.getDiscount()%> %
										</td>
										<td align="right"><span id="span_discount"></span></td>
									</tr>
									<tr>
										<td colspan="2"></td>
										<td align="right"><strong>รวมราคาหลังหักส่วนลด (Net Amount)</strong></td>
										<td align="right">
											<span id="span_net_amount"></span>
											<input type="hidden" name="net_amount" id="net_amount" value="0">
										</td>
									</tr>
									<tr>
										<td colspan="2"></td>
										<td align="right">
											<strong>ภาษีมูลค่าเพิ่ม (VAT) </strong>
											<input type="hidden" name="vat" id="vat" value="<%=PO.getVat()%>"><%=PO.getVat()%> %</td>
										<td align="right"><span id="span_vat"></span><input type="hidden" name="vat_amount" id="vat_amount" value="0"></td>
									</tr>
									<tr class="txt_bold">
										<td colspan="2"></td>
										<td align="right"><strong>รวมเป็นเงิน (Grand Total)</strong></td>
										<td align="right"><span id=span_grand_total></span><input type="hidden" name="grand_total" id="grand_total" value="0"></td>
									</tr>
									
							</table>
						</div>
						<div class="clear"></div>
						
						
						<div class="dot_line m_top10"></div>
						
						<div class="m_top5 center">
							
							<table class="bg-image s_auto">
								<thead>
									<tr>
										<th align="center" width="10%">ที่<br>(No.)</th>
										<th valign="top" align="center" width="45%">รายการสินค้า<br>(Description)</th>
										<th valign="top" align="center" width="15%">จำนวน<br>(Quantity)</th>
										<th valign="top" align="center" width="15%">ราคาต่อหน่วย<br>(Unit Price)</th>
										<th valign="top" align="center" width="15%">จำนวนเงิน<br>(Amount)</th>
									</tr>
								</thead>
								<tbody>
								<%
									int i = 1;
									String gross_amount = "0";
									while(ite.hasNext()) {
										PurchaseRequest entity = (PurchaseRequest) ite.next();
									//	InventoryMaster master = entity.getUIInvMaster();
										PartMaster master = PartMaster.select(entity.getMat_code());
										
										String amt = Money.multiple(entity.getOrder_qty(), entity.getOrder_price());
										gross_amount = Money.add(gross_amount, amt);
										String amount =  Money.money(amt);
								%>
									<tr id="tr_<%=entity.getId()%>" valign="middle">
										<td align="center"><%=i++%></td>
										<td>	 <%=master.getDescription()%>	</td>
										<td align="center"><%=entity.getOrder_qty()%> <%//=master.getStd_unit()%></td>
										<td align="center"><%=entity.getOrder_price()%></td>
										<td align="right"><%=amount%></td>
									</tr>
										<script type="text/javascript">	
											update_data_gross_amount(<%=gross_amount%>);	
										</script>
								<%
									}
								%>
								</tbody>
							</table>
						</div>
						
						<div class="center right m_top5 pd_5">
							<div class="left">หมายเหตุ : </div> 
							<div class="left m_left5"><%=PO.getNote().replaceAll("\n", "<br>").replaceAll(" ", "&nbsp;")%></div>
							<div class="clear"></div>
						</div>
						<div class="clear"></div>
						 <button class="btn_box btn_approve btn_confirm" id="btn_approve" >อนุมัติใบสั่งซื้อ</button>
						 &nbsp;&nbsp;
						 <button class="btn_box btn_reject" id="btn_reject" >ไม่อนุมัติใบสั่งซื้อ</button>
						  &nbsp;&nbsp;
						<input type="reset" name="reset" class="btn_box" title="ปิดหน้าจอ" value="Close" onclick="tb_remove();">
						 
						<input type="hidden" name="po" value="<%=po%>">
						<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
					
				</form>
					
				</div>
			
		</div>
	</div>
	
	
</body>
</html>