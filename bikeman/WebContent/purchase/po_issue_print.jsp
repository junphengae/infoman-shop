<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.purchase.PurchaseOrder"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
PurchaseOrder PO = PurchaseOrder.selectInfo(po);
Iterator ite = PO.getUIOrderList().iterator();
%>

<title>ใบสั่งซื้อเลขที่: <%=po%></title>
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
	var f_discount_pc = $('#discount_pc');
	var span_discount_pc =$('#span_discount_pc');
	var f_discount = $('#discount');
	var span_discount = $('#discount_show');
	var f_net_amount = $('#net_amount');
	var span_net_amount =$('#span_net_amount');
	var f_vat = $('#vat');
	var vat_amount = $('#vat_amount');
	var span_vat = $('#span_vat');
	var span_grand_total = $('#span_grand_total');
	var grand_total = $('#grand_total');
	
	dc_pc();
	
	f_discount_pc.blur(function(){
		dc_pc();
	});
	
	span_discount.blur(function(){
		var d = removeCommas($(this).text());
		$(this).text(money(d));
		dc_pc();
	});
	
	f_vat.blur(function(){
		dc_pc();
	});
	
	function dc_pc(){
		var net_amount = "0";
		var v = f_discount_pc.val();
		
		if (v == '0' || v == '') {
			span_discount_pc.text('0.00');
			span_net_amount.text(span_gross_amount.text());
			f_net_amount.val(f_gross_amount.val());
		} else {
			if (isNumber(v)) {
				net_amount = discount(parseFloat(f_gross_amount.val()), v);
				span_discount_pc.text(discount_value(parseFloat(f_gross_amount.val()), v));
				span_net_amount.text(net_amount);
				f_net_amount.val(removeCommas(net_amount));	
			} else {
				alert('กรุณาระบุ Discount ให้ถูกต้อง');
				f_discount_pc.val('0').focus();
				span_discount_pc.text('0.00');
				span_net_amount.text(span_gross_amount.text());
				f_net_amount.val(f_gross_amount.val());
				
				
			}
		}
		dc();
	}
	
	function dc(){
		var net_amount = "0";
		var dis = removeCommas(span_discount.text());
		
		if (dis == '0' || dis == '' || dis == '0.00') {
			span_discount.text('0.00');
			f_discount.val('0.00');
			net_amount = parseFloat(f_gross_amount.val()) - parseFloat(removeCommas(span_discount_pc.text()));
			span_net_amount.text(money(net_amount));
			f_net_amount.val(net_amount);
		} else {
			if (isNumber(dis)) {
				f_discount.val(dis);
				net_amount = parseFloat(f_gross_amount.val()) - parseFloat(removeCommas(span_discount_pc.text())) - parseFloat(dis);
				span_net_amount.text(money(net_amount));
				f_net_amount.val(net_amount);	
			} else {
				alert('กรุณาระบุ Discount ให้ถูกต้อง');
				span_discount.text('0.00').focus();
				f_discount.val('0.00');
				net_amount = parseFloat(f_gross_amount.val()) - parseFloat(removeCommas(span_discount_pc.text()));
				span_net_amount.text(money(net_amount));
				f_net_amount.val(net_amount);
			}
		}
		vat();
	}
	
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
	
	$('#btn_print').click(function(){
		var url = 'po_print.jsp?po=<%=po%>';
		window.open(url,'po','location=0,toolbar=0,menubar=0,width=800,height=500').focus();
		//window.location=url;
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
				<div class="left">รายการใบสั่งซื้อ [PO] | รายละเอียดใบสั่งซื้อเลขที่: <%=po%></div>
				<div class="right">
					<button class="btn_box" onclick="javascript: window.location='po_manage.jsp';">ไปหน้าแสดงรายการใบสั่งซื้อ</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<form id="issue_po_form" onsubmit="return false;">
					
						<div class="po_head s350 right">
							<table>
								<tr>
									<td>เลขที่ (P/O. NO.) </td><td>: <%=PO.getPo()%></td>
								</tr>
								<tr>
									<td>วันที่ (Date) </td><td>: <%=WebUtils.getDateValue(PO.getApprove_date())%></td>
								</tr>
								<tr>
									<td>กำหนดส่ง (Delivery Date) </td><td>: <%=(PO.getDelivery_date()==null)?"":WebUtils.getDateValue(PO.getDelivery_date())%></td>
								</tr>
								<tr>
								</tr>
							</table>
						</div>
						<div class="clear"></div>
						
						<div class="dot_line m_top10"></div>
						
						<div class="m_top5 center">
							
							<table class="bg-image s_auto">
								<thead>
									<tr>
										<th align="center" width="6%">ที่<br>(No.)</th>
										<th valign="top" align="center" width="44%">รายการสินค้า<br>(Description)</th>
										<th valign="top" align="center" width="15%">จำนวน<br>(Quantity)</th>
										<th valign="top" align="center" width="20%">ราคาต่อหน่วย<br>(Unit Price)</th>
										<th valign="top" align="center" width="15%">จำนวนเงิน<br>(Amount)</th>
									</tr>
								</thead>
								<tbody>
								<%
									int i = 1;
									String gross_amount = "0";
									while(ite.hasNext()) {
										PurchaseRequest entity = (PurchaseRequest) ite.next();
										//InventoryMaster master = entity.getUIInvMaster();
										PartMaster master = PartMaster.select(entity.getMat_code());
										
										String amt = Money.multiple(entity.getOrder_qty(), entity.getOrder_price());
										gross_amount = Money.add(gross_amount, amt);
										String amount =  Money.money(amt);
								%>
									<tr id="tr_<%=entity.getId()%>" valign="middle">
										<td align="center"><%=i++%></td>
										<td>
											<span class="thickbox pointer" title="ข้อมูลสินค้า">
											<%=master.getDescription()%></span>
										</td>
										<td align="center"><%=entity.getOrder_qty()%> <%//=master.getStd_unit()%></td>
										<td align="center"><%=entity.getOrder_price()%></td>
										<td align="right"><%=amount%></td>
									</tr>
								<%
									}
								%>
									<tr>
										<td colspan="4" align="right">รวมราคา (Gross Amount)</td>
										<td align="right"><span id="span_gross_amount"><%=Money.money(gross_amount) %></span><input type="hidden" name="gross_amount" id="gross_amount" value="<%=gross_amount%>"></td>
									</tr>
									<tr>
										<td colspan="4" align="right">ส่วนลด (Discount) <input type="hidden" name="discount_pc" id="discount_pc" value="<%=PO.getDiscount_pc()%>"><%=PO.getDiscount_pc()%> %</td>
										<td align="right"><span id="span_discount_pc"></span></td>
									</tr>
									<tr>
										<td colspan="4" align="right">หรือ ส่วนลด (Discount) เป็นบาท</td>
										<td align="right"><span id="discount_show"><%=Money.money(PO.getDiscount())%></span><input type="hidden" class="txt_box s_auto txt_right" name="discount" id="discount" value="<%=PO.getDiscount()%>"></td>
									</tr>
									<tr>
										<td colspan="4" align="right">รวมราคาหลังหักส่วนลด (Net Amount)</td>
										<td align="right"><span id="span_net_amount"></span><input type="hidden" name="net_amount" id="net_amount" value=""></td>
									</tr>
									<tr>
										<td colspan="4" align="right">ภาษีมูลค่าเพิ่ม (VAT) <input type="hidden" name="vat" id="vat" value="<%=PO.getVat()%>"><%=PO.getVat()%> %</td>
										<td align="right"><span id="span_vat"></span><input type="hidden" name="vat_amount" id="vat_amount" value="0"></td>
									</tr>
									<tr class="txt_bold">
										<td colspan="4" align="right">รวมเป็นเงิน (Grand Total)</td>
										<td align="right"><span id=span_grand_total></span><input type="hidden" name="grand_total" id="grand_total" value="0"></td>
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
						<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
					</form>
					
					<div class="center txt_center m_top5">
						<button class="btn_box btn_confirm" id="btn_print">พิมพ์ใบสั่งซื้อ</button>
					</div>
				</div>
			
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
</body>
</html>