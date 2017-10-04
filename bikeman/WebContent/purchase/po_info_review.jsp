<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.purchase.PurchaseOrder"%>
<%@page import="Component.Accounting.Money.MoneyAccounting"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
String po = WebUtils.getReqString(request, "po");
String pono = po.toString();
PurchaseOrder PO = PurchaseOrder.select(po);
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

</head>
<body >

<div class="wrap_all">	
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายการใบสั่งซื้อ [PO] | รายละเอียดใบสั่งซื้อ </div>				
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<form id="issue_po_form" action="../ReportUtilsServlet" target="_blank" method="post" onsubmit="return true;"> <!-- onsubmit="return checkconfirm()" -->
					
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
								</tr>
							</table>
						</div>
						<div class="clear"></div>
						
						
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
										PurchaseRequest entity = (PurchaseRequest) ite.next();
									//	InventoryMaster master = entity.getUIInvMaster();
										PartMaster master = PartMaster.select(entity.getMat_code());

										int qty = Integer.parseInt(entity.getOrder_qty()) ;
										Double price = Double.valueOf(entity.getOrder_price()) ;
										amount = Money.money(qty * price);  //(Amount)จำนวนเงิน
										gross_amount += Double.parseDouble(Money.removeCommas( amount ));
										discount_pc = Money.money(( gross_amount * Double.parseDouble(Money.removeCommas(PO.getDiscount_pc())) )/100)  ;
										discount    = Money.money(PO.getDiscount());
										grand_total = Money.money(gross_amount - Double.parseDouble(Money.removeCommas(discount_pc))- Double.parseDouble(Money.removeCommas(discount)));
										vat_amount  = Money.money((Double.parseDouble(Money.removeCommas(grand_total))*7)/107) ;
										net_amount  = Money.money(Double.parseDouble(Money.removeCommas(grand_total)) - Double.parseDouble(Money.removeCommas(vat_amount))) ;
										
										
								%>
									<tr id="tr_<%=entity.getId()%>" valign="middle">
										<td align="center"><%=i++%></td>
										<td align="left"><%=master.getPn()%></td>
										<td align="left"><%=master.getDescription()%></td>
										<td align="center">
											<%=PurchaseRequest.status(entity.getStatus())%>
										</td>
										<td align="left"> <%=UnitType.selectName( master.getDes_unit() )%></td>
										<td align="right"><%=Money.moneyInteger(entity.getOrder_qty())%> </td>
										<td align="right"><%=Money.money( entity.getOrder_price() )  %></td>
										<td align="right"><%=Money.money( amount )%></td>
									</tr>
								<%
									}
								%>
									<tr>
										<td colspan="7" align="right">รวมราคา (Gross Amount)</td>
										<td align="right">
										<%=Money.money(gross_amount) %>
										<input type="hidden" name="gross_amount" id="gross_amount" value="<%=Money.money(gross_amount).replaceAll(",", "")%>"></td>
									</tr>
									<tr>
										<td colspan="7" align="right">ส่วนลด (Discount) 
											<input type="hidden" class="txt_box s30 txt_center" name="discount_pc" id="discount_pc" maxlength="3" value="<%=Money.money(PO.getDiscount_pc()).replaceAll(",", "").trim()%>">
											<%=Money.money(PO.getDiscount_pc()) %> %</td>
										<td align="right">
											<%=Money.money(PO.getDiscount_pc())%> 
										</td>
									</tr>
									<tr>
										<td colspan="7" align="right">หรือ ส่วนลด (Discount) เป็นบาท</td>
										<td align="right"> 
											<%=Money.money(PO.getDiscount())%>
											<input type="hidden" class="txt_box s_auto txt_right" name="discount" id="discount" value="<%=Money.money(PO.getDiscount()).replaceAll(",", "").trim()%>">
										</td>
									</tr>
									<tr>
										<td colspan="7" align="right">รวมราคาหลังหักส่วนลด (Net Amount)</td>
										<td align="right">
										<%= net_amount %>
										<input type="hidden" name="net_amount" id="net_amount" value="<%= net_amount.replaceAll(",", "") %>"></td>
									</tr>
									<tr>
										<td colspan="7" align="right">ภาษีมูลค่าเพิ่ม (VAT) 7%</td>
										<td align="right">
											<input type="hidden" name="vat" id="vat" value="7"> 
											<%= vat_amount %>
											<input type="hidden" name="vat_amount" id="vat_amount" value="<%= vat_amount.replaceAll(",", "") %>"></td>
									</tr>
									<tr class="txt_bold">
										<td colspan="7" align="right">รวมเป็นเงิน (Grand Total)</td>
										<td align="right">
										<%= grand_total %>
										<input type="hidden" name="grand_total" id="grand_total" value="<%= grand_total.replaceAll(",", "") %>"></td>
									</tr>
								</tbody>
								<tfoot>
								<tr>
									<td colspan="8" align="center" height="35px" valign="bottom">
										<input type="reset" id="close_form" onclick="tb_remove();" value="Close Display" class="btn_box btn_warn">	
									</td>
								</tr>
								</tfoot>
							</table>
						</div>
						
						<div class="center right m_top5 pd_5">
							<div class="left">หมายเหตุ : </div> 
							<div class="left m_left5"><%=PO.getNote().replaceAll("\n", "<br>").replaceAll(" ", "&nbsp;")%></div>
							<div class="clear"></div>
						</div>
						<div class="clear"></div>
						 
						<input type="hidden" name="po" value="<%=po%>">
						<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
				
					</form>
					
				</div>
			
		</div>
	</div>
	<script type="text/javascript">
				$(function(){
					$("#close_form").click(function(){ 					
				       	window.close(); 
					}); 
				});
				</script>
</div>
</body>
</html>