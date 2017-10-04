<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.dc.DcpurchaseOrder"%>
<%@page import="com.bitmap.bean.dc.DcpurchaseRequest"%>
<%@page import="java.util.Map"%>
<%@page import="com.bitmap.bean.dc.SaleOrderService"%>
<%@page import="com.bitmap.bean.dc.SaleServicePartDetail"%>
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
<script src="../js/ZeroValueFormat.js" type="text/javascript"></script>

<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.datepicker.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
String branch_name = WebUtils.getReqString(request, "branch_name");
String status = WebUtils.getReqString(request, "status");
String id = WebUtils.getReqString(request, "po");
String idno = id.toString();

SaleOrderService ID = SaleOrderService.selectById(id); 

List paramsList = new ArrayList();

paramsList.add(new String[]{"number",id});

%>
<title>รายละเอียดการขายสิค้า</title>
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
	var f_discount = $('#discount_pc');
	var span_discount =$('#span_discount_pc');
	
	var f_discount_bath = $('#discount');
	var f_discount_bath_show = $('#discount');
	
	var f_net_amount = $('#net_amount');
	var span_net_amount =  $('#span_net_amount');
     

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
		
		if (v == '0' || v == '' || v == '0.00') {
			span_discount.text('0.00');
			span_net_amount.text( span_gross_amount.text() );
			f_net_amount.val(f_gross_amount.val());
			
		//	vat();
		} else {
			if (isNumber(v)) {
				net_amount = discount(parseFloat(f_gross_amount.val()), v);
				span_discount.text(discount_value(parseFloat(f_gross_amount.val()), v).toFixed(2));
				span_net_amount.text(net_amount);
				f_net_amount.val(removeCommas(net_amount));	
				
			//	vat();
			} else {
				alert('กรุณาระบุ Discount ให้ถูกต้อง');
				f_discount.val('').focus();
			}
		}

			dc_bath();
		}
		
		
		function dc_bath(){
			var net_amount = "0";
			var dis = removeCommas(f_discount_bath_show.val());
			
			if (dis == '0' || dis == '' || dis == '0.00') {
				f_discount_bath_show.val('0.00');
				f_discount_bath.val('0.00');
				//net_amount = parseFloat(f_gross_amount.val()) - parseFloat(dis);
				
				//span_net_amount.text(money(net_amount));
				
				//f_net_amount.val(net_amount);
			}else {
				if (isNumber(dis)) {
					f_discount_bath.val(dis);
					net_amount = parseFloat(removeCommas(span_net_amount.text())) - parseFloat(dis);
					span_net_amount.text(money(net_amount));
					f_net_amount.val(net_amount);	
				} else {
					alert('กรุณาระบุ Discount ให้ถูกต้อง');
					f_discount_bath_show.val('0.00').focus();
					f_discount_bath.val('0.00');
					net_amount = parseFloat(f_gross_amount.val()) - parseFloat(removeCommas(f_discount_bath_show.text()));
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
			span_vat.text('0');
			vat_amount.val('0');
			//ปัดเเศษ
			/* span_grand_total.text(money(RoundUpPointValue(removeCommas((1.00*f_net_amount.val())+"")))); */
			span_grand_total.text(money(f_net_amount.val()));
			
			grand_total.val(f_net_amount.val());
		} else {
			if (isNumber(v)) {
				
				
				vat = net_amount * (v / 107);
				span_vat.text(money(vat));
				vat_amount.val(money(vat));
				/* var net_amountRound = RoundUpPointValue(removeCommas((1.00*net_amount)+""));
				span_net_amount.text(money((1.00*net_amountRound+vat)+""));  *///ปัดเเศษ
				span_net_amount.text(money(net_amount+vat));
				
				/*span_grand_total.text(money(RoundUpPointValue(removeCommas((1.00*net_amount)+""))));*/ //ปัดเเศษ
				span_grand_total.text(money(net_amount));
				grand_total.val(net_amount );
				
			} else {
				alert('กรุณาระบุ VAT ให้ถูกต้อง');
				f_vat.val('').focus();
			}
		}
	}
	
	
});

</script>

</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายการขายสินค้า [Sale Order Item] | รายละเอียดการขายสินค้า</div> 
				<div class="right m_right10">
					<%-- <%//if(PO.getStatus().equalsIgnoreCase(PurchaseRequest.STATUS_PO_OPENING) ){%>
					<button class="btn_box btn_confirm" onclick="javasript: window.location='po_issue_review.jsp?po=<%//=PO.getPo()%>';">แก้ไขใบสั่งซื้อ</button>
					<%//}%> --%>
					<button class="btn_box" onclick="javasript: history.back();">ย้อนกลับ</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<form id="issue_po_form" action="../ReportUtilsServlet" target="_blank" method="post">
					
						<div class="po_head s350 right">
							<table>
								<tr>
									<td>เลขที่การขาย(Job ID) </td><td>: <%=id%></td>
								</tr>
									<td>วันที่ (Date) </td><td>: <%=WebUtils.getDateValue(ID.getCreate_date())%></td>
								</tr>
								<tr>
									<td>กำหนดส่ง (Delivery Date) </td><td>: <%=(ID.getDuedate()==null)?"":WebUtils.getDateValue(ID.getDuedate())%></td>
								</tr>
								<tr>
									<td>สาขา (Branch) </td><td>: <%=branch_name%></td>
								</tr>
								<tr>
								</tr>
							</table>
						</div>
						<div class="clear"></div>
						
						
						<div class="dot_line m_top10"></div>
						
						<div class="m_top5 center">
							
							<table class="bg-image s930">
								<thead>
									<tr>
										<th align="center" width="5%">ที่<br>(No.)</th>
										<th valign="top" align="center" width="15%">รหัสสินค้า<br>(Part Number)</th>
										<th valign="top" align="center" width="30%">รายการสินค้า<br>(Description)</th>
										 <th valign="top" align="center" width="9%">สถานะ<br>(Status)</th> 
										<th valign="top" align="center" width="15%">จำนวน<br>(Quantity)</th>
										<th valign="top" align="center" width="15%">ราคาต่อหน่วย<br>(Unit Price)</th>
										<th valign="top" align="center" width="15%">จำนวนเงิน<br>(Amount)</th>
									</tr>
								</thead>
								<tbody>
								<%
									int i = 1;
									String gross_amount = "0";
									Iterator ite = SaleServicePartDetail.selectList(paramsList).iterator();
									int y = 1;
									while(ite.hasNext()) {
										SaleServicePartDetail entity = (SaleServicePartDetail) ite.next();
										PartMaster master = PartMaster.select(entity.getPn());
										
										
								%>
									<tr id="tr_<%=entity.getId()%>" valign="middle">
										<td align="center"><%=y++%></td>
										<td>
											
		 									 <%=master.getPn()%>
										</td>
										<td>
											
		 									 <%=master.getDescription()%>
										</td>
										<td align="center">
											<%=SaleOrderService.status(status)%>
											
										</td>
										<td align="center"><%=Money.moneyInteger(entity.getQty())%> <%//=master.getStd_unit()%></td>
										<td align="center"><%=Money.money(master.getCost()) %></td>
										<%
										
										 String cost = master.getCost();
										if (cost.equalsIgnoreCase("")){
											
											String priceU = "0";
											String amt = Money.multiple(entity.getQty(), priceU );
											gross_amount = Money.add(gross_amount, amt);
											String amount =  Money.money(amt);
											
										%>
											<td align="right"><%=amount%></td>
									  	<%	}else{
									  		String amt = Money.multiple(entity.getQty(), master.getCost());
									  		gross_amount = Money.add(gross_amount, amt);
											String amount1 =  Money.money(amt);
											
									  	
									  	%>	
										
											<td align="right"><%=amount1%></td>
											
										<% } %>
							
									</tr>
								<%
									}
								%>
									<tr>
										<td colspan="6" align="right">รวมราคา (Gross Amount)</td>
										<td align="right"><span id="span_gross_amount"><%=Money.money(gross_amount)%></span><input type="hidden" name="gross_amount" id="gross_amount" value="<%=gross_amount%>"></td>
									</tr>
									 <tr>
										<td colspan="6" align="right">ส่วนลด (Discount) <input type="hidden" name="discount_pc" id="discount_pc" value="<%=ID.getV_id()%>"><%=ID.getV_id()%> %</td>
										<td align="right"><span id="span_discount_pc"></span></td>
									</tr>
									<tr>
										<td colspan="6" align="right">หรือ ส่วนลด (Discount) เป็นบาท</td>
										<td align="right"><span id="span_discount"><%=Money.money(ID.getDiscount())%></span></td>
											<input type="hidden" class="txt_box s_auto txt_right" name="discount" id="discount" value="<%=ID.getDiscount()%>"/>
										</td>
									</tr>
									<tr>
										<td colspan="6" align="right">รวมราคาหลังหักส่วนลด (Net Amount)</td>
										<td align="right"><span id="span_net_amount"></span><input type="hidden" name="net_amount" id="net_amount" value="0"></td>
									</tr>
									<tr>
										<td colspan="6" align="right">ภาษีมูลค่าเพิ่ม (VAT) <input type="hidden" name="vat" id="vat" value="<%=ID.getVat()%>"><%=ID.getVat()%> %</td>
										<td align="right"><span id="span_vat"></span><input type="hidden" name="vat_amount" id="vat_amount" value="0"></td>
									</tr>
									<tr class="txt_bold">
										<td colspan="6" align="right">รวมเป็นเงิน (Grand Total)</td>
										<td align="right"><span id=span_grand_total></span><input type="hidden" name="grand_total" id="grand_total" value="0"></td>
									</tr> 
								</tbody>
							</table>
						</div>
						
					
					</form>
					
				</div>
			
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
</body>
</html>
</html>