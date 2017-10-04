<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.ServicePartDetail"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="com.bitmap.bean.parts.ServiceSale"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.security.SecurityUser"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/clear_form.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/popup.js"></script>
<script src="../js/number.js"></script>
<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.position.js"></script>
<script src="../js/ui/jquery.ui.autocomplete.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Sale Parts</title>
<%
ServiceSale entity = new ServiceSale();
WebUtils.bindReqToEntity(entity, request);
ServiceSale.select(entity);

List list = entity.getUIListDetail();
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Order ID: <%=entity.getId()%></div>
				<div class="right">
					<button class="btn_box" onclick="window.location='<%=LinkControl.link("sale_part.jsp", (List)session.getAttribute("SALE_SEARCH"))%>';">Back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<form id="sale_part_form" onsubmit="return false;">
				<fieldset class="fset">
					<legend>Parts Sale Order</legend>
						<div class="left s400">
							<table class="s_auto">
								<tbody>
									<tr>
										<td width="30%">Order ID</td>
										<td width="70%">: <%=entity.getId()%></td>
									</tr>
									<tr>
										<td>Customer Name</td>
										<td>: 
											<input type="text" class="txt_box s200" readonly="readonly" disabled="disabled" value="<%=entity.getCus_name()%>"> <a class="btn_update thickbox" lang="sale_part_update_customer.jsp?id=<%=entity.getId()%>&height=400&width=800" title="Update Customer"></a>
										</td>
									</tr>
									<tr>
										<td>Vehicle Plate</td>
										<td>: 
											<input type="text" class="txt_box s200" readonly="readonly" disabled="disabled" value="<%=entity.getV_plate()%>">
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						
						<div class="right s400">
							<table class="s_auto">
								<tbody>
									<tr>
										<td width="30%">Order Date</td>
										<td width="70%">: <%=WebUtils.getDateTimeValue(entity.getCreate_date())%></td>
									</tr>
									<tr>
										<td><label title="ประเภทการเข้ารับบริการ">Service Type</label></td>
										<td>: <%=ServiceSale.service(entity.getService_type()) %></td>
									</tr>
								</tbody>
							</table>
						</div>
					
						<div class="clear"></div>
				</fieldset>
				
				<fieldset class="fset">
					<legend>Parts List</legend>
					<div class="right">
						<button class="btn_box btn_add thickbox" title="Select parts" lang="sale_part_select.jsp?id=<%=entity.getId()%>&width=420&height=230">Select Parts</button>
					</div>
					<div class="clear"></div>
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th valign="top" align="left" width="3%"></th>
								<th valign="top" align="left" width="3%"></th>
								<th valign="top" align="center" width="12%">Code</th>
								<th valign="top" align="center" width="25%">Description</th>
								<th valign="top" align="center" width="5%">Qty</th>
								<th valign="top" align="center" width="15%">Unit Price</th>
								<th valign="top" align="center" width="15%">Net Price</th>
								<th valign="top" align="center" width="3%">Disc(%)</th>
								<th valign="top" align="center" width="17%">Total Price</th>
							</tr>
						</thead>
						<tbody>
						<%
							String total = "0";
							String total_net_price = "0";
							String total_discount = "0";
							
							Iterator ite = list.iterator();
							while(ite.hasNext()) {
								ServicePartDetail detail = (ServicePartDetail) ite.next();
								String net_price = "0";
								String total_price = "0";
								String disc = "0";
								
								net_price = Money.multiple(detail.getQty(), detail.getPrice());
								total_price = Money.discount(net_price, detail.getDiscount());
								disc = Money.subtract(net_price, total_price);
								
								total_net_price = Money.add(total_net_price, net_price);
								total_discount = Money.add(total_discount, disc);
								total = Money.add(total, total_price);
						%>
							<tr>
								<td align="center">
									<a class="btn_del" onclick="deletePart('<%=detail.getId()%>','<%=detail.getNumber()%>','<%=detail.getUIDescription()%>','<%=detail.getPn()%>');"></a>
								</td>
								<td>
									<a title="Update Discount PN: <%=detail.getPn()%>" class="btn_update thickbox" lang="sale_part_update_detail.jsp?id=<%=detail.getId()%>&number=<%=detail.getNumber()%>&width=420&height=230"></a>
								</td>
								<td><%=detail.getPn() %></td>
								<td><%=detail.getUIDescription() %></td>
								<td align="right"><%=detail.getQty()%></td>
								<td align="right"><%=Money.money(detail.getPrice()) %></td>
								<td align="right"><%=Money.money(net_price) %></td>
								<td align="right"><%=detail.getDiscount()%></td>
								<td align="right"><%=Money.money(total_price) %></td>
							</tr>
						<%
							}
						%>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="9" height="20"></td>
							</tr>
							<tr>
								<td colspan="6"></td>
								<td colspan="1" align="left">Before Disct.</td>
								<td align="right" colspan="2">
									<%=Money.money(total_net_price)%>
									<input type="hidden" name="total" id="total" value="<%=total_net_price%>">
								</td>
							</tr>
							<tr>
								<td colspan="6"></td>
								<td colspan="1" align="left">Discount</td>
								<td align="right" colspan="2"><%=Money.money(total_discount)%></td>
							</tr>
							<tr>
								<td colspan="6"></td>
								<td colspan="1" align="left">Net</td>
								<td align="right" colspan="2"><%=Money.money(total)%></td>
							</tr>
							<tr>
								<td colspan="6"></td>
								<td colspan="1" align="left">V.A.T. <input type="checkbox" <%=(entity.getVat().equalsIgnoreCase("7"))?"checked":""%> class="pointer" name="vat" id="vat" value="7"> <label class="pointer" for="vat">7 %</label></td>
								<td align="right" colspan="2"><span id="show_vat"><%=(entity.getVat().equalsIgnoreCase("7"))?Money.money(Money.vat(total)):"0.00"%></span></td>
							</tr>
							<tr class="txt_bold">
								<td colspan="6"></td>
								<td colspan="2" align="left">Total Amount</td>
								<td align="right" colspan="1">
									<span id="total_amount_text"><%=(entity.getVat().equalsIgnoreCase("7"))?Money.money(Money.add(total, Money.vat(total))): Money.money(total)%></span>
									<input type="hidden" name="total_amount" id="total_amount" value="<%=(entity.getVat().equalsIgnoreCase("7"))?Money.money(Money.add(total, Money.vat(total))): Money.money(total)%>">
								</td>
							</tr>
						</tfoot>
					</table>
					<table class="s_auto">
						<tbody>
							<tr>
								<td colspan="2" height="10"><div class="dot_line"></div></td>
							</tr>
							<tr>
								<td colspan="2" height="10" align="center">
									<button type="button" class="btn_box btn_confirm" onclick="close_order('<%=entity.getId()%>');">Request Parts</button>
									<input type="hidden" name="id" value="<%=entity.getId()%>">
									<input type="hidden" name="action" value="sale_part_confirm">
									<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
								</td>
							</tr>
						</tbody>
					</table>
				</fieldset>
				</form>
				<div class="clear"></div>
					
				<script type="text/javascript">
				$(function(){
					var net = parseFloat('<%=total%>');
					var total = money(net + (net * (7 / 100)));
					
					$('#vat').click(function(){
						if ($(this).is(':checked')) {
							$('#total_amount_text').text(total);
							$('#total_amount').val(total);
							$('#show_vat').text('<%=Money.money(Money.vat(total))%>');
						} else {
							$('#total_amount_text').text('<%= Money.money(total)%>');
							$('#total_amount').val('<%= Money.money(total)%>');
							$('#show_vat').text('0.00');
						}
					});
					
					if ($('#vat').is(':checked')) {
						$('#total_amount_text').text(total);
						$('#total_amount').val(total);
						$('#show_vat').text('<%=Money.money(Money.vat(total))%>');
					} else {
						$('#total_amount_text').text('<%= Money.money(total)%>');
						$('#total_amount').val('<%= Money.money(total)%>');
						$('#show_vat').text('0.00');
					}
				});
				
				function close_order(id){
					if (confirm('Request Parts?')) {
						ajax_load();
						$.post('../PartSaleManage',$('#sale_part_form').serialize(),function(resData){
							ajax_remove();
							if (resData.status == 'success') {
								var url = 'sale_part_print.jsp?id=<%=entity.getId()%>';
								window.open(url,'part','location=0,toolbar=0,menubar=0,width=800,height=500').focus();
								window.location='sale_part.jsp?action=search';
							} else {
								alert(resData.message);
							}
						},'json');
					}
				}
				
				function deletePart(id,number,desc,pn){
					if (confirm('Remove Part PN: ' + pn + ' [' + desc + ']?')) {
						ajax_load();
						$.post('../PartSaleManage',{'id':id,'number':number,'action':'sale_part_delete'},function(resData){
							ajax_remove();
							if (resData.status == 'success') {
								window.location.reload();
							} else {
								alert(resData.message);
							}
						},'json');
					}
				}
				</script>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>