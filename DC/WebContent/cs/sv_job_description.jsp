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
<title>Job ID: <%=entity.getId()%></title>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left"><strong>Job ID: <%=entity.getId()%></strong> [ <font style="color: yellow;"> Status: <%=ServiceSale.status(entity.getStatus()) %> </font>]</div>
				<div class="right">
					<!-- 
					<button class="btn_box" onclick="window.history.back();">Back</button>
					 -->
					
						<button class="btn_box" onclick="window.location='<%=LinkControl.link("sv_job_manage.jsp", (List)session.getAttribute("CS_ORDER_SEARCH"))%>';">Back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<form id="sale_part_form" onsubmit="return false;">
				<fieldset class="fset">
					<legend><Strong>Customer Detail</Strong></legend>
						<div class="left s400">
							<table class="s_auto">
								<tbody>
									<tr>
										<td width="40%"><Strong>Order ID</Strong></td>
										<td width="60%">: <%=entity.getId()%></td>
									</tr>
									
									<!-- 
									<tr>
										<td>Customer Name</td>
										<td>: 
											<%//=entity.getCus_name()%> 
											<a class="btn_view" onclick="$('#tr_customer').toggle();"></a> 
										</td>
									</tr>
									<tr id="tr_customer" class="hide">
										<td colspan="2">
											<fieldset class="fset">
												<legend>Customer Profile</legend>
												<table class="s_auto" cellspacing="5">
													<tbody>
														<tr>
															<td width="30%">Contact</td>
															<td width="70%">: <%//=cus.getCus_phone()%> &nbsp; <%//=cus.getCus_mobile()%></td>
														</tr>
														<tr>
															<td>Address</td>
															<td>: <%//=cus.getCus_address()%></td>
														</tr>
													</tbody>
												</table>
											</fieldset>
										</td>
									</tr>
									<tr>
										<td>Vehicle Plate</td>
										<td>: 
											<%//=entity.getV_plate()%> 
											<a class="btn_view" onclick="$('#tr_vehicle').toggle();"></a>
										</td>
									</tr>
									<tr id="tr_vehicle" class="hide">
										<td colspan="2">
											<fieldset class="fset">
												<legend>Vehicle Detail</legend>
												<table class="s_auto" cellspacing="5">
													<tbody>
														<tr>
															<td width="30%">Brand</td>
															<td width="70%">: <%//=vehicle.getUIMaster().getUIBrand()%>&nbsp;<%//=vehicle.getUIMaster().getUIModel()%>&nbsp;<%=vehicle.getUIMaster().getNameplate()%></td>
														</tr>
														<tr>
															<td>Year</td>
															<td>: <%//=vehicle.getUIMaster().getYear()%></td>
														</tr>
														<tr>
															<td>Engine NO.</td>
															<td>: <%//=vehicle.getEngine_no()%></td>
														</tr>
														<tr>
															<td>VIN.</td>
															<td>: <%//=vehicle.getVin()%></td>
														</tr>
														<tr>
															<td>Color</td>
															<td>: <%//=vehicle.getColor()%></td>
														</tr>
													</tbody>
												</table>
											</fieldset>
										</td>
									</tr>
									-->
									
									
									<tr>
										<td><Strong>Vehicle Plate</Strong></td>
										<td>:  <%=entity.getV_plate()%> </td>
									</tr>
									<tr>
										<td><Strong>Vehicle Plate Province</Strong></td>
										<td>:  <%=entity.getV_plate_province()%> </td>
									</tr>
									<tr>
										<td><Strong>Brand</Strong></td>
										<td>: <%=Brands.getUIName(entity.getBrand_id()) %> </td>
									</tr>	
									<tr>
										<td><Strong>Model</Strong></td>
										<td>:  <%=Models.getUIName(entity.getModel_id()) %> </td>
									</tr>
									
									<tr>
										<td valign="top"><Strong>Customer Name</Strong></td>
										<td valign="top">:  <%=entity.getCus_name()%> </td>
									</tr>
									<tr>
										<td valign="top"><Strong>Customer Surame</Strong></td>
										<td valign="top">:  <%=entity.getCus_surname()%> </td>
									</tr>
								</tbody>
							</table>
						</div>
						
						<div class="right s400">
							<table class="s_auto">
								<tbody>
									<tr>
										<td width="30%"><Strong>Order Date</Strong></td>
										<td width="70%">: <%=WebUtils.getDateTimeValue(entity.getCreate_date())%></td>
									</tr>
									<tr>
										<td><label title="ประเภทการเข้ารับบริการ"><Strong>Service Type</Strong></label></td>
										<td>: <%=ServiceRepair.repairType(entity.getStatus()) %></td>
									</tr>
									<tr>
										<td><label title="พนักงานรับรถ"><Strong>Received by</Strong></label></td>
										<td>: <%=recv.getName() + " " + recv.getSurname()%></td>
									</tr>
								</tbody>
							</table>
						</div>
					
						<div class="clear"></div>
						
						<div >
							<div class="dot_line"></div>
							<div>
								<Strong>Service required / Problems </Strong> :
							</div>
							<div style="width: 100%;word-break:break-all" >
								- <%=repair.getProblem().replaceAll(" ", "&nbsp;").replaceAll("\n", "<br>- ")%>
							</div>
						</div>
						
				</fieldset>
				
				<fieldset class="fset">
					<legend><Strong>Service Description &amp; Parts List</Strong></legend>
					
					<div class="right">
						
						<!-- 
						<button class="btn_box btn_add thickbox s120" title="Select parts" lang="../part/sale_part_select.jsp?id=<%=entity.getId()%>&width=420&height=230">Parts</button>
					
						 -->
						<button class="btn_box btn_add s120" title="Select parts" 
								onclick="popupSetWH('../part/sale_part_search.jsp?id=<%=entity.getId()%>','800','700');"> Parts</button>
					
					</div>
					<div class="clear"></div>
					
					<table class="bg-image s_auto breakword">
						<thead>
							<tr>
								<th valign="top" align="left" width="3%"></th>
								<th valign="top" align="left" width="3%"></th>
								<th valign="top" align="center" width="10%">Code</th>
								<th valign="top" align="center" width="34%">Description</th>
								<th valign="top" align="center" width="5%">Qty</th>
								<th valign="top" align="center" width="5%">Draw</th>
								<th valign="top" align="center" width="11%">Unit Price</th>
								<th valign="top" align="center" width="11%">Net Price</th>
								<th valign="top" align="center" width="7%">Disc(%)</th>
								<th valign="top" align="center" width="11%">Total Price</th>
							</tr>
						</thead>
						<tbody>
						<%
							boolean check_close = true;
							String total = "0";
							String total_net_price = "0";
							String total_discount = "0";
							
							String part_total_net_price = "0";
							String part_total_discount = "0";
							
							Iterator ite = listPart.iterator();
							while(ite.hasNext()) {
								ServicePartDetail detailPart = (ServicePartDetail) ite.next();
								String net_price = "0";
								String total_price = "0";
								String disc = "0";
								
								net_price = Money.multiple(detailPart.getQty(), detailPart.getPrice());
								total_price = Money.discount(net_price, detailPart.getDiscount());
								disc = Money.subtract(net_price, total_price);
								
								total_net_price = Money.add(total_net_price, net_price);
								total_discount = Money.add(total_discount, disc);
								total = Money.add(total, total_price);
						%>
							<tr>
								<%if(!detailPart.getCutoff_qty().equalsIgnoreCase("0")){//Case มีการเบิกอะไหล่แล้ว จะไม่สามารถลบหรือแก้ไขจำนวนได้%>
								<td align="center">
									<a class="btn_accept" title="Draw Parts Complete"></a>
								</td>
								<td align="center">
									<a title="Update Parts Detail PN: <%=detailPart.getPn()%>" class="btn_update thickbox" lang="../part/sale_part_update_discount.jsp?id=<%=detailPart.getId()%>&number=<%=detailPart.getNumber()%>&width=420&height=230"></a>
								</td>
								<%}else{ //Case ยังไม่ได้เบิกอะไหล่ จะสามารถลบหรือแก้ไขจำนวนได้%>
								<td align="center">
									<a class="btn_del" onclick="deletePart('<%=detailPart.getId()%>','<%=detailPart.getNumber()%>','<%=detailPart.getUIDescription()%>','<%=detailPart.getPn()%>');"></a>
								</td>
								<td align="center">
									<a title="Update Parts Detail PN: <%=detailPart.getPn()%>" class="btn_update thickbox" lang="../part/sale_part_update_detail.jsp?id=<%=detailPart.getId()%>&number=<%=detailPart.getNumber()%>&width=420&height=230"></a>
								</td>
								<%}%>
								<td><%=detailPart.getPn() %></td>
								<td><%=detailPart.getUIDescription() %></td>
								<td align="right"><%=detailPart.getQty()%></td>
								<td align="right"><%=detailPart.getCutoff_qty()%></td>
								<td align="right"><%=Money.money(detailPart.getPrice()) %></td>
								<td align="right"><%=Money.money(net_price) %></td>
								<td align="right"><%=detailPart.getDiscount()%></td>
								<td align="right"><%=Money.money(total_price) %></td>
							</tr>
						<%
								if ( !detailPart.getCutoff_qty().equalsIgnoreCase(detailPart.getQty()) ){//check เผื่อปิดจ๊อบ
									check_close = false;
								}
							}
						%>
						</tbody>
					</table>
					
					<div class="dot_line"></div>
					
					<div class="right m_top10">
						<button class="btn_box btn_add thickbox s120" title="Add Service Detail" lang="../cs/sv_job_service_add.jsp?id=<%=entity.getId()%>&width=420&height=230">Service</button>
					</div>
					<div class="clear"></div>
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th valign="top" align="left" width="3%"></th>
								<th valign="top" align="left" width="3%"></th>
								<th valign="top" align="center" width="10%">Code</th>
								<th valign="top" align="center" width="34%">Description</th>
								<th valign="top" align="center" width="11%">Price</th>
								<th valign="top" align="center" width="7%">Disc(%)</th>
								<th valign="top" align="center" width="11%">Total Price</th>
							</tr>
						</thead>
						<tbody>
						<%
							//String sv_total_net_price = "0";
							//String sv_total_discount = "0";
							
							Iterator iteSV = listRepair.iterator();
							while(iteSV.hasNext()) {
								ServiceRepairDetail detailRepair = (ServiceRepairDetail) iteSV.next();
								String net_price = "0";
								String total_price = "0";
								String disc = "0";
								total_price = Money.multiple(detailRepair.getLabor_rate(), detailRepair.getDiscount());
								total_price = Money.divide(total_price ,"100");
								total_price = Money.subtract(detailRepair.getLabor_rate(), total_price);
								total_net_price = Money.add(total_net_price, total_price);
								
							//	total_discount = Money.add(total_discount, disc);
								total = Money.add(total, total_price);
						%>
							<tr>
								<td align="center">
									<a class="btn_del" onclick="deleteService('<%=detailRepair.getId()%>','<%=detailRepair.getNumber()%>','<%=detailRepair.getLabor_name()%>');"></a>
								</td>
								<td align="center">
									<a title="Update Service Detail: <%=detailRepair.getLabor_name()%>" class="btn_update thickbox" lang="../cs/sv_job_service_update.jsp?id=<%=detailRepair.getId()%>&number=<%=detailRepair.getNumber()%>&width=420&height=230"></a>
								</td>
								<td align="center"><%=detailRepair.getLabor_id()%></td>
								<td><%=detailRepair.getLabor_name() %></td>
								<td align="right"><%=Money.money(detailRepair.getLabor_rate()) %></td>
								<td align="right"><%=detailRepair.getDiscount()%></td>
								<td align="right"><%=total_price%></td>
							</tr>
						<%
							}
						%>
						
						
						</tbody>
					</table>					
					
					
					
					<div class="dot_line"></div>
					
					<div class="right m_top10">
						<button class="btn_box btn_add thickbox s120" title="Add Miscellaneous" lang="../cs/sv_job_other_add.jsp?id=<%=entity.getId()%>&width=420&height=230">Miscellaneous</button>
					</div>
					<div class="clear"></div>
					
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th valign="top" align="left" width="27"></th>
								<th valign="top" align="left" width="22"></th>
								<th valign="top" align="center" width="300">Description</th>
								<th valign="top" align="center" width="27">Qty</th>
								<th valign="top" align="center" width="111">Unit Price</th>
								<th valign="top" align="center" width="111">Net Price</th>
								<th valign="top" align="center" width="47">Disc(%)</th>
								<th valign="top" align="center" width="126">Total Price</th>
							</tr>
						</thead>
						<tbody>
						<%
							//String other_total_net_price = "0";
							//String other_total_discount = "0";							
							Iterator iteOther = listOther.iterator();
							while(iteOther.hasNext()) {
								ServiceOtherDetail detailOther = (ServiceOtherDetail) iteOther.next();
								String net_price = "0";
								String total_price = "0";
								String disc = "0";
								
								net_price = Money.multiple(detailOther.getOther_qty(), detailOther.getOther_price());
								total_price = Money.discount(net_price, detailOther.getDiscount());
								disc = Money.subtract(net_price, total_price);
								
								total_net_price = Money.add(total_net_price, net_price);
								total_discount = Money.add(total_discount, disc);
								total = Money.add(total, total_price);
						%>
							<tr>
								<td align="center">
									<a class="btn_del" onclick="deleteOther('<%=detailOther.getId()%>','<%=detailOther.getNumber()%>','<%=detailOther.getOther_name()%>');"></a>
								</td>
								<td align="center">
									<a title="Update Miscellaneous Detail: <%=detailOther.getOther_name()%>" class="btn_update thickbox" lang="../cs/sv_job_other_update.jsp?id=<%=detailOther.getId()%>&number=<%=detailOther.getNumber()%>&width=420&height=230"></a>
								</td>
								<td><%=detailOther.getOther_name() %></td>
								<td align="right"><%=detailOther.getOther_qty()%></td>
								<td align="right"><%=Money.money(detailOther.getOther_price()) %></td>
								<td align="right"><%=Money.money(net_price) %></td>
								<td align="right"><%=detailOther.getDiscount()%></td>
								<td align="right"><%=Money.money(total_price) %></td>
							</tr>
						<%
							}
						%>
						</tbody>
					</table>
					
					<div class="dot_line"></div>
					
					<table class="bg-image s_auto">
						<tfoot>
							<tr>
								<td colspan="2" height="20"></td>
							</tr>
							<tr>
								<td width="700" align="right">Before Disct.</td>
								<td width="250" align="right">
									<%=Money.money(total_net_price)%>
									<input type="hidden" name="total" id="total" value="<%=total_net_price%>">
								</td>
							</tr>
							<tr>
								<td align="right">Discount</td>
								<td align="right"><%=Money.money(total_discount)%></td>
							</tr>
							<tr>
								<td align="right">Net</td>
								<td align="right"><%=Money.money(total)%></td>
							</tr>
							<tr>
								<td align="right">V.A.T. <input type="checkbox" <%=(entity.getVat().equalsIgnoreCase("7"))?"checked":""%> class="pointer" name="vat" id="vat" value="7"> <label class="pointer" for="vat">7 %</label></td>
								<td align="right"><span id="show_vat"><%=(entity.getVat().equalsIgnoreCase("7"))?Money.money(Money.vat(total)):"0.00"%></span></td>
							</tr>
							<tr class="txt_bold">
								<td align="right">Total Amount</td>
								<td align="right">
									<span id="total_amount_text"><%=(entity.getVat().equalsIgnoreCase("7"))?Money.money(Money.add(total, Money.vat(total))): Money.money(total)%></span>
									<input type="hidden" name="total_amount" id="total_amount" value="<%=(entity.getVat().equalsIgnoreCase("7"))?Money.money(Money.add(total, Money.vat(total))): Money.money(total)%>">
								</td>
							</tr>
						</tfoot>
					</table>
					<% 
					String aa = "0";
					if(entity.getVat().equalsIgnoreCase("7")){
						aa = Money.money(Money.add(total, Money.vat(total)));
					
					}else{
						aa = Money.money(total);
					}
	
						if ( !entity.getTotal_amount().equalsIgnoreCase(aa)){//check เผื่อปิดจ๊อบ
									//check_close = false;
							}
					 %>
					<table class="s_auto">
						<tbody>
							<tr>
								<td colspan="2" height="10"><div class="dot_line"></div></td>
							</tr>
							<tr>
								<td colspan="2" height="10" align="center">
								<%-- 	<button type="button" class="btn_box btn_printer" onclick="window.open('../cs/sv_job_service_print.jsp?id=<%=entity.getId()%>','_blank');">Service Detail</button>
									
									<% if(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_MA_REQUEST) && check_close){  %>
									 <!-- | -->
									<button type="button" class="btn_box btn_warn" id="close_sv" onclick="close_order(<%=entity.getId()%>)">Close Job</button>
									<% } 
									else { %>
									 <!-- |		 -->						
									<button type="button" class="btn_box btn_confirm" onclick="save_order('<%=entity.getId()%>');">Save Order</button>
									<label style="font-size: xx-small;color: red;">Please save job before close job</label>
									<% } %> --%>
									
									<% 
									if(entity.getStatus().equalsIgnoreCase(ServiceSale.STATUS_MA_REQUEST)  && check_close){
										%>
									<button type="button" class="btn_box btn_warn" id="close_sv" onclick="close_order(<%=entity.getId()%>)">Close Job</button>
									
									<%} %>
									<input type="hidden" name="id" value="<%=entity.getId()%>">
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
				
				function save_order(id){
					ajax_load();
					$.post('../PartSaleManage',$('#sale_part_form').serialize() + '&action=job_save',function(resData){
						ajax_remove();
						if (resData.status == 'success') {
 							window.location.reload();
						} else {
							alert(resData.message);
						}
					},'json');
				}
				
				function close_order(id){
					if (confirm('Close Job?')) {
						ajax_load();
						$.post('../PartSaleManage',$('#sale_part_form').serialize() + '&action=job_close',function(resData){
							ajax_remove();
							if (resData.status == 'success') {
								window.open('../cs/shop_print.jsp?id=<%=entity.getId()%>','_blank');
	 							window.location="sv_job_description_closed.jsp?id="+id;
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
				
				function deleteService(id,number,labor_name){
					if (confirm('Remove Service: ' + labor_name + '?')) {
						ajax_load();
						$.post('../PartSaleManage',{'id':id,'number':number,'action':'sale_service_delete'},function(resData){
							ajax_remove();
							if (resData.status == 'success') {
								window.location.reload();
							} else {
								alert(resData.message);
							}
						},'json');
					}
				}
				
				function deleteOther(id,number,other_name){
					if (confirm('Remove Miscellaneous: ' + other_name + '?')) {
						ajax_load();
						$.post('../PartSaleManage',{'id':id,'number':number,'action':'sale_other_delete'},function(resData){
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