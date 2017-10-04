<%@page import="com.bmp.sale.bean.SaleOderServicePartDetailBean"%>
<%@page import="com.bmp.sale.transaction.SaleOderServicePartDetailTS"%>
<%@page import="com.bmp.sale.bean.SaleOderServiceBean"%>
<%@page import="com.bmp.sale.transaction.SaleOderServiceTS"%>
<%@page import="com.bitmap.bean.inventory.UnitType"%>
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

SaleOderServiceBean ID = SaleOderServiceTS.selectById(id);

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
	
	
});
function close_po(){
var check_cutoff = $('#check_cutoff').val();
//alert("check_cutoff:"+check_cutoff);

if (!check_cutoff) {
	//alert("check_cutoff__:"+check_cutoff);

 if(confirm('Confirm Close (PO No : <%=id%> )' )) {
		ajax_load();
		$.post('../PurchaseManage', {'action':'close_po_sale','number':'<%=id%>'},function(json){
			ajax_remove();
			if (json.status == 'success') {
				//window.location='sv_job_create.jsp?id=' + json.id;
				window.location='so_info.jsp?po=<%=id%>&branch_name=<%=branch_name%>&status=100';  
				
			} else {
				alert(json.message);
			}
		},'json');
	}
 
}else{
	alert("กรุณาเบิกของให้ครบก่อนปิดการขาย");
}
 
}


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
				<% 
				if(!status.equalsIgnoreCase("100")){
				%>
		
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<button class="btn_box btn_warn"  onclick="close_po();"> <%= "Close &nbsp;&nbsp;&nbsp;Job ID : "+id %></button>				
				<%} %>
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
										<th valign="top" align="center" width="5%">ที่<br>(No.)</th>
										<th valign="top" align="center" width="15%">รหัสสินค้า<br>(Part Number)</th>
										<th valign="top" align="center" width="30%">รายการสินค้า<br>(Description)</th>
										<th valign="top" align="center" width="9%">สถานะ<br>(Status)</th> 
										<th valign="top" align="center" width="9%">หน่วยนับ<br>(Units)</th>
										<th valign="top" align="center" width="15%">จำนวน<br>(Quantity)</th>
										<th valign="top" align="center" width="15%">ราคาต่อหน่วย(฿)<br>(Unit Price)</th>
										<th valign="top" align="center" width="15%">จำนวนเงิน(฿)<br>(Amount)</th>
									</tr>
								</thead>
								<tbody>
								<%
									int i = 1;
									String gross_amount = "0";
									Iterator ite = SaleOderServicePartDetailTS.selectList(paramsList).iterator(); 
									int y = 1;
									int cutoff_qty =0;
									int qty= 0;
									while(ite.hasNext()) {
										SaleOderServicePartDetailBean entity = (SaleOderServicePartDetailBean) ite.next();
										PartMaster master = PartMaster.select(entity.getPn());
										
										
										
								%>
									<tr id="tr_<%=entity.getId()%>" valign="middle">
										<td align="center"><%=y++%></td>
										<td align="left"><%=master.getPn()%></td>
										<td align="left"><%=master.getDescription()%></td>										
										<td align="center">
											 <%=(entity.getQty().equalsIgnoreCase(entity.getCutoff_qty())?"Closed":"Request")%>
										
											<%
											
											if(!entity.getQty().equalsIgnoreCase(entity.getCutoff_qty())){ 
												
											 	qty =cutoff_qty + 1;
											 %>	
												<input type="hidden" name="check_cutoff" id="check_cutoff" value="<%=Money.moneyInteger(qty)%>"> 
											<% 	
											}
											%>
											
										</td>
										<td align="left"><%=UnitType.selectName(master.getDes_unit())%></td>
										<td align="center"><%=Money.moneyInteger(entity.getQty())%></td>
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
										<td colspan="7" align="right">รวมราคา (Gross Amount)</td>
										<td align="right"><span id="span_gross_amount"><%=Money.money(ID.getGross_amount())%></span><input type="hidden" name="gross_amount" id="gross_amount" value="<%=gross_amount%>"></td>
									</tr>
									 <tr>
										<td colspan="7" align="right">ส่วนลด (Discount) <input type="hidden" name="discount_pc" id="discount_pc" value="<%=ID.getDiscount_pc()%>"><%=ID.getDiscount_pc()%> %</td>
										<td align="right"><span id="span_discount_pc"><%= Money.money((  Double.parseDouble(Money.removeCommas(ID.getGross_amount())) * Double.parseDouble(Money.removeCommas(ID.getDiscount_pc())) )/100)  %></span></td>
									</tr>
									<tr>
										<td colspan="7" align="right">หรือ ส่วนลด (Discount) เป็นบาท</td>
										<td align="right"><span id="span_discount"><%=Money.money(ID.getDiscount())%></span></td>
											<input type="hidden" class="txt_box s_auto txt_right" name="discount" id="discount" value="<%=ID.getDiscount()%>"/>
										</td>
									</tr>
									<tr>
										<td colspan="7" align="right">รวมราคาหลังหักส่วนลด (Net Amount)</td>
										<td align="right"><span id="span_net_amount"><%=Money.money(ID.getNet_amount())%></span><input type="hidden" name="net_amount" id="net_amount" value="<%=ID.getNet_amount()%>"></td>
									</tr>
									<tr>
										<td colspan="7" align="right">ภาษีมูลค่าเพิ่ม (VAT) <input type="hidden" name="vat" id="vat" value="<%=ID.getVat()%>"><%=ID.getVat()%> %</td>
										<td align="right"><span id="span_vat"><%=Money.money(ID.getVat_amount())%></span><input type="hidden" name="vat_amount" id="vat_amount" value="<%=ID.getVat_amount()%>"></td>
									</tr>
									<tr class="txt_bold">
										<td colspan="7" align="right">รวมเป็นเงิน (Grand Total)</td>
										<td align="right"><span id=span_grand_total><%=Money.money(ID.getGrand_total())%></span><input type="hidden" name="grand_total" id="grand_total" value="<%=ID.getGrand_total()%>"></td>
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