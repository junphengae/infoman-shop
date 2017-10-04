+<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.utils.ReportUtils"%>
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
<script src="../js/number.js" type="text/javascript"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>

<%
String po = WebUtils.getReqString(request, "po");
String pono = po.toString();
PurchaseOrder PO = PurchaseOrder.select(po);
Iterator ite = PO.getUIOrderList().iterator();

String amount = "0";
Double gross_amount = 0.00;
String discount_pc = "0";
String discount = "0";
String net_amount = "0";
String vat_amount = "0";
String grand_total = "0";

%>
<script type="text/javascript">
var pono = '<%=pono%>';
var msg = $('#msg');
$(function(){

	$('#btn_approve').click(function(){
		if (confirm('ยืนยันการอนุมัติใบสั่งซื้อเลขที่ : '+pono)) {
			var update_by = '<%=securProfile.getPersonal().getPer_id()%>';
			
				ajax_load();
				$.post('../PurchaseManage',{'action':'approve_po','po':pono,'update_by':update_by},function(resData){
					ajax_remove();
					if (resData.status == 'success') {
						
						//====== ********** นัฐยา ทำเพื่ออัพเดทข้อมูล Web Service   *******************=============//
						ajax_load();
						$.post('../CallWSSevrlet','action=updateShopToDc_popr',function(response){  
						ajax_remove();  
							if (response.status == 'success') {
								msg.text("อนุมัติใบสั่งซื้อเลขที่ : "+pono+" เรียบร้อย").css('color','green').slideDown('medium').delay(1000).slideUp('slow',function(){ window.location = 'po_manage.jsp'; });
								
							} 
							else {
								alert(response.message);
							}
						},'json'); 
					//=================================================================================//
						
					} else {
							alert(resData.message);
						}
				},'json');
				
				
				
		}
	});
	
	$('#btn_reject').click(function(){
		if (confirm('ยืนยันการยกเลิกใบสั่งซื้อเลขที่ : '+pono)) {
				var update_by = '<%=securProfile.getPersonal().getPer_id()%>';
				
				ajax_load();
				$.post('../PurchaseManage',{'action':'reject_po','po':pono ,'update_by':update_by},function(resData){
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

</script>
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left"> เลขที่ (P/O. NO.) : <%=PO.getPo()%><%if (PO.getReference_po().length() > 0) { %>| ออกแทน P/O. NO. : <%=PO.getReference_po()%> <%}%> </div>
			</div>
			<div class="content_body_95p">
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
							<td>: <%=WebUtils.getDateValue(PO.getCreate_date())%></td>
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
								<%=Money.money(PO.getGross_amount()) %>						
							</td>
						</tr>
						<tr>
							<td colspan="2"></td>
							<td align="right">
								<strong>ส่วนลด (Discount)</strong>
								 <input type="hidden" name="discount_pc" id="discount_pc" value="<%=PO.getDiscount_pc()%>">
								 <%=Money.money(PO.getDiscount_pc())%> %
							</td>
							<td align="right">
							<%=Money.money(PO.getDiscount_pc())%>
							</td>
						</tr>
						<tr>
							<td colspan="2"></td>
							<td align="right">
								<Strong>หรือ ส่วนลด (Discount) เป็นบาท</Strong>
							</td>
							<td align="right"><%=Money.money(PO.getDiscount())%></td>															
						</tr>
						<tr>
							<td colspan="2"></td>
							<td align="right"><strong>รวมราคาหลังหักส่วนลด (Net Amount)</strong></td>
							<td align="right">
								<%=Money.money(PO.getNet_amount())%>
							</td>
						</tr>
						<tr>
							<td colspan="2"></td>
							<td align="right">
								<strong>ภาษีมูลค่าเพิ่ม (VAT) </strong>
								<%=Money.money(PO.getVat())%> %</td>
							<td align="right">
							<span id="span_vat">
								<%=Money.money(PO.getVat_amount()) %>
							</span>
							
						</tr>
						<tr class="txt_bold">
							<td colspan="2"></td>
							<td align="right"><strong>รวมเป็นเงิน (Grand Total)</strong></td>
							<td align="right">
								<span id=span_grand_total>
								<%=Money.money(PO.getGrand_total())%>
								</span>
								
						</tr>
					</table>
				</div>
				<div class="clear"></div>
				<div class="dot_line m_top10"></div>
				<div class="m_top5 center">
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th align="center" width="5%">ที่<br>(No.)</th>
								<th valign="top" align="center" width="19%">รหัสสินค้า<br>(Part Number)</th>
								<th valign="top" align="center" width="35%">รายการสินค้า<br>(Description)</th>
								<th valign="top" align="center" width="10%">หน่วยนับ<br>(Units)</th>
								<th valign="top" align="center" width="10%">จำนวน<br>(Quantity)</th>
								<th valign="top" align="center" width="14%">ราคาต่อหน่วย<br>(Unit Price)</th>
								<th valign="top" align="center" width="14%">จำนวนเงิน<br>(Amount)</th>
							</tr>
						</thead>
						<tbody>
							<%
								int i = 1;
							 	
								while(ite.hasNext()) {
									PurchaseRequest entity = (PurchaseRequest) ite.next();
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
									<td align="left"><%=master.getPn()%>	</td>
									<td align="left"><%=master.getDescription()%>	</td>
									<td align="left"><%=UnitType.selectName(master.getDes_unit())%>	</td>
									<td align="right"><%=Money.moneyInteger(entity.getOrder_qty())%></td>
									<td align="right"><%=Money.money(entity.getOrder_price()) %></td>
									<td align="right"><%=Money.money(amount)%></td>
								</tr>
							<% } %>
							</tbody>
						</table>
					</div>
					<div class="center right m_top5 pd_5">
						<div class="left">หมายเหตุ : </div> 
							<div class="left m_left5"><%=PO.getNote().replaceAll("\n", "<br>").replaceAll(" ", "&nbsp;")%></div>
						</div>
						<div class="clear"></div>
						<div align="center">
						<br/>
						<%if(PO.getStatus().equalsIgnoreCase(PurchaseRequest.STATUS_ORDER)){%>
							<button class="btn_box btn_approve btn_confirm" id="btn_approve" >อนุมัติใบสั่งซื้อ</button>
							 &nbsp;&nbsp;
							 <button class="btn_box btn_reject" id="btn_reject" >ไม่อนุมัติใบสั่งซื้อ</button>
							 
							<%-- <button class="btn_box btn_warn thickbox" lang="po_cancel_popup.jsp?width=450&height=200&po=<%=PO.getPo()%>" title="ยกเลิกใบสั่งซื้อ">ยกเลิกใบสั่งซื้อ</button>
							  --%>
							 &nbsp;&nbsp;
						<% } %>
							<input type="reset" name="reset" class="btn_box" title="ปิดหน้าจอ" value="Close" onclick="tb_remove();">
						</div>
						<input type="hidden" name="po" value="<%=po%>">
						<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
					<div class="msg_error" id="msg"></div>
					</div>
				</div>
			</div>