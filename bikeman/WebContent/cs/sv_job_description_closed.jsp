<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bmp.special.fn.BMMoney"%>
<%@page import="com.bitmap.utils.ReportUtils"%>
<%@page import="com.bitmap.utils.report.Mobile"%>
<%@page import="com.bitmap.bean.sale.MoneyDiscountRound"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.bitmap.bean.sale.Models"%>
<%@page import="com.bitmap.bean.sale.Brands"%>
<%@page import="com.bitmap.bean.parts.ServiceOutsourceDetail"%>
<%@page import="com.bitmap.bean.parts.ServiceOtherDetail"%>
<%@page import="com.bitmap.bean.parts.ServiceRepair"%>
<%@page import="com.bitmap.bean.parts.ServiceRepairDetail"%>
<%@page import="com.bitmap.bean.sale.Vehicle"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
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
<script src="../js/ui/jquery.ui.datepicker.js"></script>
<script src="../js/ui/jquery.ui.button.js"></script>
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

<%
ServiceSale entity = new ServiceSale();
WebUtils.bindReqToEntity(entity, request);
ServiceSale.select(entity);

List listOutsource = ServiceOutsourceDetail.list(entity.getId());
List listRepair = ServiceRepairDetail.list(entity.getId());
List listOther = ServiceOtherDetail.list(entity.getId());
List listPart = entity.getUIListDetail();

ServiceRepair repair = ServiceRepair.select(entity.getId());
Personal recv = Personal.select(repair.getCreate_by());
/* System.out.println("Create_by : "+repair.getCreate_by());
System.out.println("Create_by : "+recv.getName());
 */
Customer cus = new Customer();
if (entity.getCus_id().length() > 0) {
	cus = Customer.select(entity.getCus_id());
} else {
	cus.setCus_name_th(entity.getCus_name());
}

Vehicle vehicle = new Vehicle();
if (entity.getV_id().length() > 0) {
	vehicle = Vehicle.select(entity.getV_id());
} else {
	vehicle.setLicense_plate(entity.getV_plate());
}
%>
<title>Job ID: <%=entity.getId()%> - <%=entity.getV_plate()%></title>

<script type="text/javascript">
$(function(){

		$('#btn_print_bill').click(function(){
					
					var job_id = "<%=entity.getId()%>";
					var bill = "<%=entity.getBill_id()%>";
					var flage = "<%=entity.getFlage()%>";
					var tax_id = "<%=entity.getTax_id()%>";
                   /*   if(tax_id != ""){ */
                    	 
				                   if (flage == "1") {
				   						  if (confirm('ใบเสร็จอย่างเต็มเลขที่ใบงาน:'+job_id+"/"+bill+'ถูกพิมพ์แล้ว'+'\n'+'ยืนยันการพิมพ์กดตกลง')) {
				   								
				   							
				   							}else{
				   								return false;
				   							}
				   						  
				   							 return true;
				   						
				   						
				   					}else{
				   						
				   						if (confirm('ยืนยันการพิมพ์ใบเสร็จอย่างเต็ม')) {
				   							
				   							ajax_load();
				   							$.post('../PartSaleManage',{'action':'print_bill','id':job_id},function(resData){
				   								ajax_remove();
				   								if (resData.status == 'success') {		
				   									ajax_load();
				   									//window.location.reload();
				   								} else {
				   									alert(resData.message);
				   									return false;
				   								}
				   							},'json');
				   							
				   							
				   							
				   						}else{
				   							return false;
				   						}
				   						
						   					  //====== ********** นัฐยา ทำเพื่ออัพเดทข้อมูล Web Service   *******************=============//
												ajax_load();
												$.post('../CallWSSevrlet','action=updateShopToDc_bill',function(response){		
												ajax_remove();  
													if (response.status == 'success') {
														window.location.reload();
													} else {
														alert(response.message);
													}
												},'json'); 
											//=================================================================================// 
				   						
											return true;
				   						 
				   							
				   					} 
                    /*  }else{
                    	 
                    	 alert("ข้อมูลลูกค้าไม่มีรหัสประจำตัวผู้เสียภาษี");
                    	 window.location="sv_job_info.jsp?id="+job_id+"&upadate=1";
                    	 $('#tax_id').focus();
                    	 return false;
                     }			 */	
					 
                  
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
				<div class="left">Job ID: <%=entity.getId()%> [Status: <%=ServiceSale.status(entity.getStatus()) %>]</div>
				<div class="right">
						<!-- <button class="btn_box" onclick="history.back();">Back</button> -->
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body" >
				 <!-- <form id="sale_part_form"  action="../ReportServletBM" target="_blank"  method="post" onsubmit="return true;"> -->
				<form id="sale_part_form"  action="../ReportUtilsServlet" target="_blank"  method="post" onsubmit="return true;"> 
				
				
				<fieldset class="fset ">
					<legend>Customer Detail</legend>
						<div class="left s400">
							<table class="s_auto "  >
								<tbody>
									<tr>
										<td width="40%" class="txt_bold">Job ID</td>
										<td width="60%">: <%=entity.getId()%></td>
									</tr>
									<tr>
										<td><Strong>เลขทะเบียนรถ</Strong></td>
										<td>:  <%=entity.getV_plate()%> </td>
									</tr>
									<tr>
										<td><Strong>จังหวัดทะเบียนรถ</Strong></td>
										<td>:  <%=entity.getV_plate_province()%> </td>
									</tr>
								<tr>
										<td><Strong>ยี่ห้อ</Strong></td>
										<td>: <%=(Brands.getUIName(entity.getBrand_id()) != null)?Brands.getUIName(entity.getBrand_id()):"-" %> </td>
									</tr>	
									<tr>
										<td><Strong>รุ่น</Strong></td>
										<td>:  <%=(Models.getUIName(entity.getModel_id()) != null)?Models.getUIName(entity.getModel_id()):"-" %> </td>
									</tr>
									<tr>
										<td><Strong>เลขไมล์</Strong></td>
										<td>:  <%=(repair.getMile() != null)?repair.getMile():"-" %> </td>
									</tr>
									<tr>
										<td valign="top"><Strong>ชื่อลูกค้า</Strong></td>
										<td valign="top">:  <%=entity.getForewordname()+"		"+entity.getCus_name()%> </td>
									</tr>
									<tr>
										<td valign="top"><Strong>นามสกุล</Strong></td>
										<td valign="top">:  <%=entity.getCus_surname()%> </td>
									</tr>
									<tr>
										<td valign="top"><Strong>เลขประจำตัวผู้เสียภาษี</Strong></td>
										<td valign="top">:  <%=entity.getTax_id()%> </td>
									</tr>
								</tbody>
							</table>
						</div>
						
						<div class="right s400">
							<table class="s_auto">
								<tbody>
									<tr>
										<td width="40%" class="txt_bold">วันที่เข้ารับบริการ</td>
										<td width="60%">: <%=WebUtils.getDateTimeValue(entity.getCreate_date())%></td>
									</tr>
									<tr>
										<td class="txt_bold"><label title="ประเภทการเข้ารับบริการ">ประเภทงานบริการ</label></td>
										<td>: <%=ServiceRepair.repairType_th(repair.getRepair_type()) %></td>
										<%-- 
										<td>: <%=ServiceSale.service(entity.getService_type()) %></td> --%>
									</tr>
									<tr>
										<td class="txt_bold"><label title="พนักงานรับรถ">รับรถโดย</label></td>
										<td>: <%=recv.getName() + " " + recv.getSurname()%></td>
									</tr>
									<tr>
										<td colspan="2" >&nbsp;</td>
									</tr>
									<tr>
										<td colspan="2" >&nbsp;</td>
									</tr>
									<tr>
										<td colspan="2" >&nbsp;</td>
									</tr>
									<tr>
										<td colspan="2" >&nbsp;</td>
									</tr>
									<tr>
										<td class="txt_bold"><label title="ผู้ที่นำรถมา">ชื่อผู้ติดต่อ</label></td>
										<td>: <%=repair.getDriven_by()%></td>
									</tr>
									<tr>
										<td class="txt_bold"><label title="เบอร์ติดต่อผู้นำรถมา">เบอร์โทรศัพท์</label></td>
										<td>:<%=Mobile.mobile(repair.getDriven_contact()) %></td>
									</tr>
								</tbody>
							</table>
						</div>
					
						<div class="clear"></div>
						
						<% 
						  // System.out.println("status::"+entity.getStatus()); 
						   if(entity.getService_type().equals(ServiceSale.SERVICE_MA)){
						%>
						<div >
							<div class="dot_line"></div>
							<div>
								<Strong>บริการที่ร้องขอ</Strong> :
							</div>
							<div style="width: 100%;word-break:break-all" >
								- <%=repair.getProblem().replaceAll(" ", "&nbsp;").replaceAll("\n", "<br>- ")%>
							</div>
						</div>
						<%}%>
						
				</fieldset>
				
			
						<%
						
						String pattern_decimal = new String ( "#.00" );
						DecimalFormat decimal_format = new DecimalFormat ( pattern_decimal );
						%>	
				
				<fieldset class="fset">
					<legend><Strong>Service Description &amp; Parts List</Strong></legend>
					
					<table class="bg-image s_auto breakword columntop">
						<thead>
							<tr>
								<th valign="top" align="center" width="14%">Code</th>
								<th valign="top" align="center" width="30%">Description</th>
								<th valign="top" align="center" width="5%">Units</th>
								<th valign="top" align="center" width="6%">Draw Qty</th>
								<th valign="top" align="center" width="6%">Issued Qty</th>
								<th valign="top" align="center" width="13%">Unit Price</th>
								<th valign="top" align="center" width="12%">Price</th>
								<th valign="top" align="center" width="5%">Discount</th>
								<th valign="top" align="center" width="12%">Net Price</th>
							</tr>
						</thead>
						<tbody>
						<%
						boolean check_close = true;
						String total_all 	="0"; //Sub Total(total)
						String discount_all	   	="0"; //Discount (discount)
						String total_amount		="0"; //Total Amount(total_amount)
						String total_price_all	="0"; //Total Price 
						String total_vat_all	="0"; //VAT 7 %	(pay)
						
						Iterator ite = listPart.iterator();
						while(ite.hasNext()) {
							ServicePartDetail detailPart = (ServicePartDetail) ite.next();
							if(detailPart.getTotal_price().equalsIgnoreCase("")||detailPart.getTotal_price().equalsIgnoreCase(null)){
								 
								String total_price =	BMMoney.MoneyMultiple(BMMoney.removeCommas(detailPart.getQty()), BMMoney.removeCommas(detailPart.getPrice()));
								//System.out.println(total_price);
								detailPart.setTotal_price(total_price);
								
								}
								total_all 		= Money.add(total_all, detailPart.getTotal_price());
								total_amount	= Money.add(total_amount, detailPart.getSpd_net_price());
								discount_all	= Money.add(discount_all,detailPart.getSpd_dis_total());
								
								String UnitDesc = UnitType.selectName(PartMaster.SelectUnitDesc(detailPart.getPn()));
									
						%>
							<tr>
								
								<td align="left"><%=detailPart.getPn() %></td>
								<td align="left"><%=detailPart.getUIDescription() %></td>
								<td align="left"><%=UnitDesc%></td>							
								<td align="right"><%=Money.moneyInteger(detailPart.getQty())%></td>
								<td align="right"><%=Money.moneyInteger(detailPart.getCutoff_qty())%></td>
								<td align="right"><%=Money.money(detailPart.getPrice()) %></td>			
								<td align="right"><%=Money.money(detailPart.getTotal_price()) %></td>
								<td align="right"><%=detailPart.getSpd_dis_total().equalsIgnoreCase("")?"0.00":Money.money(detailPart.getSpd_dis_total())%></td>
								<td align="right"><%=Money.money(detailPart.getSpd_net_price())%></td>
							</tr>
						<%

								if ( !detailPart.getCutoff_qty().equalsIgnoreCase(detailPart.getQty()) ){//check เผื่อปิดจ๊อบ
									check_close = false;
								}
							}
						%>
						</tbody>
						
						<% 
					
						%>
					
					</table>
					
					<div class="dot_line"></div>
					
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th valign="top" align="center" width="14%">Code</th>
								<th valign="top" align="center" width="34%">Description</th>
								<th valign="top" align="center" width="11%">Unit Price</th>
								<th valign="top" align="center" width="7%">Discount</th>
								<th valign="top" align="center" width="13%">Net Price</th>
							</tr>
						</thead>
						<tbody>
						<%
							
							
							Iterator iteSV = listRepair.iterator();
							while(iteSV.hasNext()) {
								ServiceRepairDetail detailRepair = (ServiceRepairDetail) iteSV.next();
								
								total_all 		= Money.add(total_all, detailRepair.getLabor_rate());
								total_amount	= Money.add(total_amount, detailRepair.getSrd_net_price());
								discount_all	= Money.add(discount_all,detailRepair.getSrd_dis_total());
									
						%>
							<tr>
								<td align="left"><%=detailRepair.getLabor_id()%></td>
								<td align="left"><%=detailRepair.getLabor_name() %></td>
								<td align="right"><%=Money.money(detailRepair.getLabor_rate()) %></td>
								<td align="right"><%=detailRepair.getSrd_dis_total().equalsIgnoreCase("")?"0.00":Money.money(detailRepair.getSrd_dis_total())%></td>
								<td align="right"><%=Money.money(detailRepair.getSrd_net_price())%></td>
							</tr>
						<%
							}
						%>
						
						</tbody>
						
					</table>					
					
					<div class="dot_line"></div>				
					<table class="bg-image s_auto breakword columntop">
						<thead>
							<tr>
								<th valign="top" align="center" width="47%">Description</th>
								<th valign="top" align="center" width="8%">Qty</th>
								<th valign="top" align="center" width="12%">Unit Price</th>
								<th valign="top" align="center" width="12%">Price</th>
								<th valign="top" align="center" width="8%">Discount</th>
								<th valign="top" align="center" width="13%">Net Price</th>
							</tr>							
						</thead>						
						<tbody>
						<%				
							Iterator iteOther = listOther.iterator();
							while(iteOther.hasNext()) {
								ServiceOtherDetail detailOther = (ServiceOtherDetail) iteOther.next();
								if(detailOther.getTotal_price().equalsIgnoreCase("")||detailOther.getTotal_price().equalsIgnoreCase(null)){
									 
									String total_price =	BMMoney.MoneyMultiple(BMMoney.removeCommas(detailOther.getOther_qty()), BMMoney.removeCommas(detailOther.getOther_price()));
									//System.out.println(total_price);
									detailOther.setTotal_price(total_price);
									
									}
								total_all		= Money.add(total_all, detailOther.getTotal_price());
								total_amount	= Money.add(total_amount, detailOther.getSod_net_price());
								discount_all	= Money.add(discount_all,detailOther.getSod_dis_total());
						%>
							<tr>
								<td align="left"><%=detailOther.getOther_name() %></td>
								<td align="right"><%=Money.moneyInteger(detailOther.getOther_qty())%></td>
								<td align="right"><%=Money.money(detailOther.getOther_price()) %></td>
								<td align="right"><%=Money.money(detailOther.getTotal_price()) %></td>
								<td align="right"><%=detailOther.getSod_dis_total().equalsIgnoreCase("")?"0.00":Money.money(detailOther.getSod_dis_total())%></td>
								<td align="right"><%=Money.money(detailOther.getSod_net_price()) %></td>
							</tr>
						<%
							}
						%>
						</tbody>
					</table>
					<div class="dot_line"></div>
						<% 
						total_vat_all 	= BMMoney.MoneyVat(total_amount,"7");
						total_price_all = BMMoney.MoneySubtract(total_amount, total_vat_all); 							
						%>
					<table class="bg-image s_auto">
						<tfoot>
							<tr>
								<td colspan="2" height="20"></td>
							</tr>
							<tr>
								<td width="700" align="right">Sub Total</td>
								<td width="250" align="right">									
									<%=Money.money(entity.getTotal() )%>								
								</td>
							</tr>
							<tr>
								<td align="right">Discount</td>
								<td align="right">								
								<%=((Money.money(entity.getDiscount()).equals("0.00"))?"":"-")+Money.money(entity.getDiscount())%>
								</td>
							</tr>
							
							<tr class="txt_bold">
								<td align="right">Total Amount</td>
								<td align="right">
									<span id="total_amount_text">																				
										<%=Money.money(entity.getTotal_amount())%>
										</span>
									
								</td>
							</tr>
							
							<tr>
								<td colspan="2">
						<div class="dot_line"></div></td>
							</tr>
							<tr>
								<td align="right">Total Price</td>
								<td align="right">
									<%=Money.money(total_price_all)%>									
								</td>
							</tr>
							<tr>
								<td align="right">
									VAT 
									<input type="hidden" class="pointer" name="vat" id="vat" value="7"> 
									<label class="pointer" for="vat">7 %</label>
								</td>								
								<td align="right">
									<%=Money.money(entity.getPay()) %>																	
								</td>
							</tr>
							<tr>
								<td align="right"> Received</td>
								<td align="right">
									<label><%=Money.money(entity.getReceived())%></label>
								</td>
							</tr>
							<tr>
								<td align="right">Change</td>
								<td align="right">
									<label><%=Money.money(entity.getTotal_change())%></label>
									
								</td>
							</tr>
						</tfoot>
					</table>

					<table class="s_auto">
						<table class="s_auto">
						<tbody>
							<tr>
								<td colspan="2" height="10"><div class="dot_line"></div></td>
							</tr>
							<tr>
								<td colspan="2" height="10" align="center">
							
									<button type="button" class="btn_box btn_printer" onclick="window.open('../cs/shop_print.jsp?id=<%=entity.getId()%>','_blank');">พิมพ์ใบเสร็จอย่างย่อ	</button>
									<button type="submit" class="btn_box btn_printer"   id="btn_print_bill" > พิมพ์ใบเสร็จฉบับเต็ม	</button>
									<%-- <button type="submit" class="btn_box btn_warn" id="close_sv" onclick="close_order(<%=entity.getId()%>)">Close Job</button> --%>
									<input type="hidden" name="id" value="<%=entity.getId()%>">
									<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
									<input type="hidden" name="type" value="OPENJOB">
									<input type="hidden" name="service_type" value="<%=entity.getService_type()%>">
								</td>
							</tr>
						</tbody>
					</table>
					</table>
				</fieldset>
				</form>
				<div class="clear"></div>
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>