<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.purchase.PurchaseOrder"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="Component.Accounting.Money.MoneyAccounting"%>
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
PurchaseOrder PO = PurchaseOrder.select(po);
Iterator ite = PO.getUIOrderList().iterator();
%>
<title>สร้างใบสั่งซื้อ</title>
<style type="text/css">
.po_head table{border-collapse: collapse; width: 100%;}
.po_head table tr{border: 1px solid #111;}
.po_head table td{padding: 4px 3px;}
a.txt_red:hover{color: #cc0000;}
</style>

<script type="text/javascript">
$(function(){
	$( "#delivery_date" ).datepicker({
		showOtherMonths: true,
		selectOtherMonths: true,
		changeMonth: true,
		minDate: new Date(),
		hideIfNoPrevNext : true
	});
	

	$('#btn_save').click(function(){
		if ($('#delivery_date').val() == '') {
			alert('โปรดระบุวันกำหนดส่งสินค้า');
			$('#delivery_date').focus();
		} else {
			//alert("discount_pc :"+$('#discount_pc').val() +"discount :"+$('#discount').val());
			if (confirm('ยืนยันการบันทึกใบสั่งซื้อ!!')) {
				ajax_load();
				$.post('../PurchaseManage',$('#issue_po_form').serialize(),function(resData){
					ajax_remove();
					if (resData.status == 'success') {
						<%-- //window.location='po_issue_print.jsp?po=<%=po%>'; --%>
						window.location='po_info.jsp?po=<%=po%>';
					} else {
						alert(resData.message);
					}
				},'json');
			}
		}
	});
	
	$('.btn_remove').click(function(){
		if(confirm('ยืนยันการลบรายการออกจากใบสั่งซื้อนี้ !')){
			ajax_load();
			$.post('../PurchaseManage',{'action':'remove_from_po','po':'<%=po%>','id':$(this).attr('data_id'),'mat_code':$(this).attr('mat_code'),'update_by':'<%=securProfile.getPersonal().getPer_id()%>'},function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location.reload();
				} else {
					alert(resData.message);
				}
			},'json');
		}
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
				<div class="left">รายการใบสั่งซื้อ [PO] | สร้างใบสั่งซื้อ</div>
				<div class="right m_right10">
					<button class="btn_box" onclick="javasript: window.location='po_list.jsp';">กลับไปหน้ารายการสั่งซื้อ</button>
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
								<%if (PO.getReference_po().length() > 0) { %>
								<tr>
									<td>ออกแทน P/O. NO. </td><td>: <%=PO.getReference_po()%></td>
								</tr>
								<%}%>
								<tr>
									<td>วันที่ (Date) </td><td>: <%=WebUtils.getDateValue(PO.getCreate_date())%></td>
								</tr>
								<tr>
									<td  >กำหนดส่ง (Delivery Date) <br/>
									<font color="red">***ต้องทำการเลือกรายการจัดซื้อก่อน</font>
									</td>
									<td valign="top">: <input type="text" name="delivery_date" id="delivery_date"  readonly="readonly" class="txt_box s100" value="<%=(PO.getDelivery_date()==null)?"":WebUtils.getDateValue(PO.getDelivery_date())%>"></td>
								</tr>
							</table>
						</div>
						<div class="clear"></div>
											
						 
						<div class="m_top5 center">
							
							<div class="right txt_right">
							<br/><br/>	
								<button class="btn_box btn_confirm thickbox" lang="po_issue_select_pr.jsp?width=850&height=400&po=<%=po%>" title="รายการที่ได้รับการอนุมัติแล้ว">เพิ่มรายการ</button>
								
							</div>
							<div class="clear"></div>
							
							<table class="bg-image s950">
								<thead>
									<tr>
										<th align="center" width="6%">ที่<br>(No.)</th>
										<th valign="top" align="center" width="19%">รหัสสินค้า<br>(Part Number)</th>
										<th valign="top" align="center" width="36%">รายการสินค้า<br>(Description)</th>
										<th valign="top" align="center" width="10%">หน่วยนับ<br>(Units)</th>		
										<th valign="top" align="center" width="12%">จำนวน<br>(Quantity)</th>
										<th valign="top" align="center" width="12%">ราคาต่อหน่วย<br>(Unit Price)</th>
										<th valign="top" align="center" width="15%">จำนวนเงิน<br>(Amount)</th>
									</tr>
								</thead>
								<tbody>
								<%
									int i = 1;
								    Boolean hasCheck = false;
								    String amount = "0.00";
									Double gross_amount = 0.00;
									String discount_pc = "0.00";
									String discount = "0.00";
									String net_amount = "0.00";
									String vat_amount = "0.00";
									String grand_total = "0.00";
									while(ite.hasNext()) {
										hasCheck = true;
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
										<td align="left"><%=master.getPn()%></td>
										<td align="left">						
										<div class="thickbox pointer left" lang="../info/inv_master_info.jsp?width=800&height=450&mat_code=<%=entity.getMat_code()%>" title="ข้อมูลสินค้า">
										<%=master.getDescription()%> 
										</div>
										<div class="right">
										<a class="txt_red btn_remove pointer" data_id="<%=entity.getId()%>" mat_code="<%=entity.getMat_code()%>"> ลบ</a>
										</div>
										<div class="clear"></div>
										</td>
										<td align="left"> <%=UnitType.selectName( master.getDes_unit() )%></td>
										<td align="right"><%=Money.moneyInteger(entity.getOrder_qty()) %></td>
										<td align="right"><%=Money.money(entity.getOrder_price()) %></td>
										<td align="right"><%=Money.money(amount)%></td>
									</tr>
								<%
									}
								%>
									<tr>
										<td colspan="6" align="right">รวมราคา (Gross Amount)</td>
										<td align="right">
										<%=Money.money(gross_amount) %>
										<input type="hidden" name="gross_amount" id="gross_amount" value="<%=Money.money(gross_amount).replaceAll(",","")%>"></td>
									</tr>
									<tr>
										<td colspan="6" align="right">ส่วนลด (Discount) 
											<input type="hidden" class="txt_box s30 txt_center" name="discount_pc" id="discount_pc" maxlength="3" value="<%=Money.money(PO.getDiscount_pc()).replaceAll(",", "").trim()%>">
											<%=Money.money(PO.getDiscount_pc()) %> %</td>
										<td align="right">
											<%=Money.money(PO.getDiscount_pc())%> 
										</td>
									</tr>
									<tr>
										<td colspan="6" align="right">หรือ ส่วนลด (Discount) เป็นบาท</td>
										<td align="right"> 
											<%=Money.money(PO.getDiscount())%>
											<input type="hidden" class="txt_box s_auto txt_right" name="discount" id="discount" value="<%=Money.money(PO.getDiscount()).replaceAll(",", "").trim()%>">
										</td>
									</tr>
									<tr>
										<td colspan="6" align="right">รวมราคาหลังหักส่วนลด (Net Amount)</td>
										<td align="right">
										<%= net_amount %>
										<input type="hidden" name="net_amount" id="net_amount" value="<%= net_amount.replaceAll(",", "") %>"></td>
									</tr>
									<tr>
										<td colspan="6" align="right">ภาษีมูลค่าเพิ่ม (VAT) 7%</td>
										<td align="right">
											<input type="hidden" name="vat" id="vat" value="7"> 
											<%= vat_amount %>
											<input type="hidden" name="vat_amount" id="vat_amount" value="<%= vat_amount.replaceAll(",", "") %>"></td>
									</tr>
									<tr class="txt_bold">
										<td colspan="6" align="right">รวมเป็นเงิน (Grand Total)</td>
										<td align="right">
										<%= grand_total %>
										<input type="hidden" name="grand_total" id="grand_total" value="<%= grand_total.replaceAll(",", "") %>"></td>
									</tr>
								</tbody>
							</table>
						</div>
						
						<div class="center right m_top5 pd_5">
							<div class="left">หมายเหตุ : </div> 
							<div class="left m_left5"><textarea name="note" class="txt_box s_600" rows="5" cols="55"><%=PO.getNote()%></textarea></div>
							<div class="clear"></div>
						</div>
						<div class="clear"></div>
						 
						<input type="hidden" name="po" value="<%=po%>">
						<input type="hidden" name="action" value="save_po">
						<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
					</form>
					
					<div class="center txt_center m_top5">
						<%if(hasCheck){ %>
							<button class="btn_box btn_confirm" id="btn_save">บันทึกใบสั่งซื้อ</button>
						<%} %>
					</div>
				</div>
			
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
</body>
</html>