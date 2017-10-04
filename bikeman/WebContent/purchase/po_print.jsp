<%@page import="com.bitmap.bean.hr.Position"%>
<%@page import="com.bitmap.utils.Money"%>
<%//@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.parts.PartMaster" %>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="com.bitmap.barcode.Barcode128"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.bean.purchase.PurchaseOrder"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css">
<link href="../css/unit.css" rel="stylesheet" type="text/css">
<link href="../css/theme_print.css" rel="stylesheet" type="text/css">

<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/jquery.metadata.js" type="text/javascript"></script>
<script src="../js/jquery.validate.js" type="text/javascript"></script>
<script src="../js/thickbox.js" type="text/javascript"></script>
<script src="../js/loading.js" type="text/javascript"></script>
<script src="../js/number.js" type="text/javascript"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
String po = WebUtils.getReqString(request, "po");
PurchaseOrder PO = PurchaseOrder.select(po);
//Vendor vendor = PO.getUIVendor();
Iterator ite = PO.getUIOrderList().iterator();
Barcode128.genBarcode(WebUtils.getInitParameter(session, "img_path_barcode"), po);
%>
<%//=WebUtils.getInitParameter(session, "img_path_barcode")%>
<title>จัดซื้อ : พิมพ์และจัดเก็บใบสั่งซื้อเลขที่ <%=po%></title>
<style type="text/css">
.po_head table{border-collapse: collapse; width: 100%;}
.po_head table tr{border: 1px solid #000;}
.po_head table td{padding: 3px 3px;}

.po_body{border-collapse: collapse;}
.po_body th{border-top: 1px solid #000; border-bottom: 1px solid #000;}
.po_body tr, .po_body td, .po_body th{border-left: 1px solid #000;border-right: 1px solid #000;}
.po_body td{padding: 1px 3px;}

.po_foot{border-collapse: collapse;}
.po_foot tr, .po_foot td, .po_foot th{border: 1px solid #000;}
.po_foot td{padding: 3px 3px;}

.bb{border: 1px solid #000;}
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
	
	dc();
	
	f_discount.blur(function(){
		dc();
	});
	
	f_vat.blur(function(){
		dc();
	});
	
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
	
	//setTimeout('window.print()',500); 
	//setTimeout('window.close()',1000);
});
</script>

</head>
<body style="font-family: 'Trebuchet MS','Helvetica','Arial','Verdana','sans-serif'; font-size: 90%;">

<div class="wrap_print">
	<div class="form_header">
		<div class="right po_head txt_center" style="margin-top: 50px;">
			<table>
				<tr>
					<td align="center">FORM: QF - PU - 003/05</td>
				</tr>
			</table>
		</div>
		
		<div class="form_info right txt_center" style="margin-top: 60px; margin-right: 20px;">
			<%  //String path_barcode = WebUtils.getInitParameter(session, "img_path_barcode")+"/"+po+".png"; 
			String path_barcode = "../../images/motoshop/barcode/"+po+".png";
			%>
			<div class="center txt_center"><img src="<%=path_barcode%>" ></div>
			<div class="clear"></div>
		</div>
		
		<div class="clear"></div>
		
	</div>
	
	<div class="txt_center txt_bold txt_28 left s400"><div class="m_top20"><br>ใบสั่งซื้อสินค้า<br>(PURCHASE ORDER)</div></div>
	
	<div class="po_head s300 right">
		<table>
			<tr>
				<td width="65%">เลขที่ (P/O. NO.) </td><td width="50%">: <%=PO.getPo()%></td>
			</tr>
			<tr>
				<td>วันที่ (Date) </td><td>: <%=WebUtils.getDateValue(PO.getApprove_date())%></td>
			</tr>
			<tr>
				<td>กำหนดส่ง (Delivery Date) </td><td>: <%=(PO.getDelivery_date()==null)?"":WebUtils.getDateValue(PO.getDelivery_date())%></td>
			</tr>
			<tr>
				<td>เครดิต (Credit) </td><td>: <span id="view_vendor_credit"><%//=vendor.getVendor_credit() %></span></td>
			</tr>
		</table>
	</div>
	<div class="clear"></div>
	
	<div class="vendor_info b_1 m_top5 bb">
		<table class="center s_auto">
			<tr height="24">
				<td width="120">บริษัท (Order To)</td>
				<td>: <span id="view_vendor_name"><%//=vendor.getVendor_name() %></span></td>
			</tr>
			<tr height="24">
				<td>ถึง (ATTN)</td>
				<td>: <span id="view_vendor_attn"><%//=vendor.getVendor_contact()%></span></td>
			</tr>
			<tr height="24">
				<td>โทร (TEL)</td>
				<td> 
					<div class="left s250">: <span id="view_vendor_phone"><%//=vendor.getVendor_phone() %></span></div>
					<div class="left">แฟกซ์ (FAX) : <span id="view_vendor_fax"><%//=vendor.getVendor_fax() %></span></div>
					<div class="clear"></div>
				</td>
			</tr>
		</table>
	</div>
	
	<div style="margin-top: 10px; position: relative; height: 350px;">
		<table class="po_body" width="100%">
			<thead>
				<tr>
					<th align="center" width="43">ที่<br>(No.)</th>
					<th valign="top" align="center" width="321">รายการสินค้า<br>(Description)</th>
					<th valign="top" align="center" width="110">จำนวน<br>(Quantity)</th>
					<th valign="top" align="center" width="145">ราคาต่อหน่วย<br>(Unit Price)</th>
					<th valign="top" align="center" width="110">จำนวนเงิน<br>(Amount)</th>
				</tr>
			</thead>
			<tbody>
			<%
				int i = 1;
				String gross_amount = "0";
				while(ite.hasNext()) {
					PurchaseRequest entity = (PurchaseRequest) ite.next();
					PartMaster master = PartMaster.select(entity.getMat_code());
					
					String amt = Money.multiple(entity.getOrder_qty(), entity.getOrder_price());
					gross_amount = Money.add(gross_amount, amt);
					String amount =  Money.money(amt);
			%>
				<tr id="tr_<%=entity.getId()%>" valign="middle">
					<td align="center"><%=i++%></td>
					<td>
						<%=master.getDescription()%>
					</td>
					<td align="center"><%=entity.getOrder_qty()%> <%//=master.getStd_unit()%></td>
					<td align="center"><%=entity.getOrder_price()%></td>
					<td align="right"><%=amount%></td>
				</tr>
			<%
				}
			%>	
			</tbody>
		</table>
		<div style="position: absolute; width: 100%; top: 0px;">
			<table class="po_body" width="100%">
				<thead>
					<tr height="350">
						<th align="center" width="43"></th>
						<th valign="top" align="center" width="321"></th>
						<th valign="top" align="center" width="110"></th>
						<th valign="top" align="center" width="145"></th>
						<th valign="top" align="center" width="110"></th>
					</tr>
				</thead>
			</table>
		</div>
	</div>
	
	<div class="s_auto" style="position: relative; min-height: 135px;">
		<div class="txt_12" style="position: absolute; width: 360px; left: 0px; top: 0px; margin-top: 5px;">
			<table class="po_foot" width="100%">
				<tbody>
					<tr>
						<td width="250">
							<u>หมายเหตุ</u> : 
							<%=PO.getNote().replaceAll("\n", "<br>").replaceAll(" ", "&nbsp;")%>
						</td>
					</tr>
					<tr>
						<td>
							** ได้รับแล้วกรุณาตอบกลับ Fax: 0-2705-3279<br>
							[&nbsp;&nbsp;] สามารถส่งสินค้าได้ตามกำหนด <%=WebUtils.getDateValue(PO.getDelivery_date()) %><br>
							[&nbsp;&nbsp;] ขอเลื่อนกำหนดส่งสินค้าเป็นวันที่ <u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</u><br><br>
							ลงชื่อ<u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</u> 
							วันที่ <u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</u>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div style="position: absolute; width: 369px; right: 0px; top: 0px;">
			<table class="po_foot" width="100%">
				<tbody>
					<tr>
						<td align="right" width="250">รวมราคา (Gross Amount)</td>
						<td align="right" width="104"><span id="span_gross_amount"><%=Money.money(gross_amount) %></span><input type="hidden" name="gross_amount" id="gross_amount" readonly="readonly" value="<%=gross_amount%>"></td>
					</tr>
					<tr>
						<td align="right">ส่วนลด (Discount) <input type="text" class="s30 txt_right" style="border: none; background: none;" name="discount" id="discount" value="<%=PO.getDiscount()%>"> %</td>
						<td align="right"><span id="span_discount"></span></td>
					</tr>
					<tr>
						<td align="right">รวมราคาหลังหักส่วนลด (Net Amount)</td>
						<td align="right"><span id="span_net_amount"></span><input type="hidden" name="net_amount" id="net_amount" value=""></td>
					</tr>
					<tr>
						<td align="right">ภาษีมูลค่าเพิ่ม (VAT) <input type="text" class="s20 txt_right" style="border: none; background: none;" name="vat" id="vat" readonly="readonly" value="<%=PO.getVat()%>"> %</td>
						<td align="right"><span id="span_vat"></span><input type="hidden" name="vat_amount" id="vat_amount" value="0"></td>
					</tr>
					<tr>
						<td class="txt_bold" align="right">รวมเป็นเงิน (Grand Total)</td>
						<td class="txt_bold" align="right"><span id=span_grand_total></span><input type="hidden" name="grand_total" id="grand_total" value="0"></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	
	<div class="s700 center txt_center">
		<table width="98%" align="center">
			<tr>
				<td width="50%" align="center" height="150" valign="bottom">
					.............................................................<br>
					<%=Position.getUINameTH(securProfile.getPersonal().getPos_id())%><br>
					(<%=securProfile.getPersonal().getName() + " " + securProfile.getPersonal().getSurname()%>)
				</td>
				<td width="50%" align="center" height="150" valign="bottom">
					.............................................................<br>
					ผู้อนุมัติสั่งซื้อ<br>
					(............................................................)
				</td>
			</tr>
		</table>
	</div>
	
</div>
</body>
</html>