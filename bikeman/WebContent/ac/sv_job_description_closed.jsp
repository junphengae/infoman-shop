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
<title>Job ID: <%=entity.getId()%> - <%=entity.getV_plate()%></title>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Job ID: <%=entity.getId()%> [Status: <%=ServiceSale.status(entity.getStatus()) %>]</div>
				<div class="right">
					<button class="btn_box" onclick="history.back();">Back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<form id="sale_part_form" onsubmit="return false;">
				<fieldset class="fset">
					<legend>Customer Detail</legend>
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
											<%=entity.getCus_name()%> 
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
															<td width="70%">: <%=cus.getCus_phone()%> &nbsp; <%=cus.getCus_mobile()%></td>
														</tr>
														<tr>
															<td>Address</td>
															<td>: <%=cus.getCus_address()%></td>
														</tr>
													</tbody>
												</table>
											</fieldset>
										</td>
									</tr>
									<tr>
										<td>Vehicle Plate</td>
										<td>: 
											<%=entity.getV_plate()%> 
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
															<td width="70%">: <%=vehicle.getUIMaster().getUIBrand()%>&nbsp;<%=vehicle.getUIMaster().getUIModel()%>&nbsp;<%=vehicle.getUIMaster().getNameplate()%></td>
														</tr>
														<tr>
															<td>Year</td>
															<td>: <%=vehicle.getUIMaster().getYear()%></td>
														</tr>
														<tr>
															<td>Engine NO.</td>
															<td>: <%=vehicle.getEngine_no()%></td>
														</tr>
														<tr>
															<td>VIN.</td>
															<td>: <%=vehicle.getVin()%></td>
														</tr>
														<tr>
															<td>Color</td>
															<td>: <%=vehicle.getColor()%></td>
														</tr>
													</tbody>
												</table>
											</fieldset>
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
									<tr>
										<td><label title="พนักงานรับรถ">Received by</label></td>
										<td>: <%=recv.getName() + " " + recv.getSurname()%></td>
									</tr>
								</tbody>
							</table>
						</div>
					
						<div class="clear"></div>
						<%if(entity.getService_type().equals(ServiceSale.SERVICE_MA)){%>
						<div >
							<div class="dot_line"></div>
							<div>
								Service required / Problems :
							</div>
							<div>
								- <%=repair.getProblem().replaceAll(" ", "&nbsp;").replaceAll("\n", "<br>- ")%>
							</div>
						</div>
						<%}%>
				</fieldset>
				
				<%if(entity.getService_type().equals(ServiceSale.SERVICE_MA)){%>
				<fieldset class="fset">
					<legend>Outsource Service</legend>
					
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th valign="top" align="center" width="115">Name</th>
								<th valign="top" align="center" width="196">Contact</th>
								<th valign="top" align="center" width="99">Send By</th>
								<th valign="top" align="center" width="76">Send date</th>
								<th valign="top" align="center" width="76">Due date</th>
								<th valign="top" align="center" width="100">Recipient</th>
								<th valign="top" align="center" width="90">Receive date</th>
							</tr>
						</thead>
						<tbody>
						<%
						Iterator iteOut = listOutsource.iterator();
						while(iteOut.hasNext()) {
							ServiceOutsourceDetail detailOutsource = (ServiceOutsourceDetail) iteOut.next();
						%>
							<tr>
								<td align="left"><%=detailOutsource.getName()%></td>
								<td align="left"><%=detailOutsource.getContact()%></td>
								<td align="center"><%=detailOutsource.getUISend_by()%></td>
								<td align="center"><%=WebUtils.getDateValue(detailOutsource.getSend_date())%></td>
								<td align="center"><%=WebUtils.getDateValue(detailOutsource.getDue_date())%></td>
								<td align="center"><%=detailOutsource.getUIReceive_by()%></td>
								<td align="center">
									<%=WebUtils.getDateValue(detailOutsource.getReceive_date())%>
								</td>
							</tr>
						<%}%>
						</tbody>
					</table>
				</fieldset>
				<%}%>
				
				<fieldset class="fset">
					<legend>Service Description &amp; Parts List</legend>
					
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th valign="top" align="center" width="115">Code</th>
								<th valign="top" align="center" width="216">Description</th>
								<th valign="top" align="center" width="27">Qty</th>
								<th valign="top" align="center" width="111">Unit Price</th>
								<th valign="top" align="center" width="111">Net Price</th>
								<th valign="top" align="center" width="47">Disc(%)</th>
								<th valign="top" align="center" width="126">Total Price</th>
							</tr>
						</thead>
						<tbody>
						<%
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
								<td><%=detailPart.getPn() %></td>
								<td><%=detailPart.getUIDescription() %></td>
								<td align="right"><%=detailPart.getQty()%></td>
								<td align="right"><%=Money.money(detailPart.getPrice()) %></td>
								<td align="right"><%=Money.money(net_price) %></td>
								<td align="right"><%=detailPart.getDiscount()%></td>
								<td align="right"><%=Money.money(total_price) %></td>
							</tr>
						<%
							}
						%>
						</tbody>
					</table>
					
					<div class="dot_line"></div>
					
					<%if(entity.getService_type().equals(ServiceSale.SERVICE_MA)){%>
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th valign="top" align="center" width="349">Description</th>
								<th valign="top" align="center" width="27">Hr.</th>
								<th valign="top" align="center" width="111">Unit Price</th>
								<th valign="top" align="center" width="111">Net Price</th>
								<th valign="top" align="center" width="47">Disc(%)</th>
								<th valign="top" align="center" width="126">Total Price</th>
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
								
								net_price = Money.multiple(detailRepair.getLabor_qty(), detailRepair.getLabor_rate());
								total_price = Money.discount(net_price, detailRepair.getDiscount());
								disc = Money.subtract(net_price, total_price);
								
								total_net_price = Money.add(total_net_price, net_price);
								total_discount = Money.add(total_discount, disc);
								total = Money.add(total, total_price);
						%>
							<tr>
								<td><%=detailRepair.getLabor_name() %></td>
								<td align="right"><%=detailRepair.getLabor_qty()%></td>
								<td align="right"><%=Money.money(detailRepair.getLabor_rate()) %></td>
								<td align="right"><%=Money.money(net_price) %></td>
								<td align="right"><%=detailRepair.getDiscount()%></td>
								<td align="right"><%=Money.money(total_price) %></td>
							</tr>
						<%
							}
						%>
						</tbody>
					</table>
					
					<div class="dot_line"></div>
					
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th valign="top" align="center" width="349">Description</th>
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
					<%}%>
					
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
								<td align="right">V.A.T. <%=(entity.getVat().equalsIgnoreCase("7"))?"7":"-"%> %</td>
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
					<table class="s_auto">
						<tbody>
							<tr>
								<td colspan="2" height="10"><div class="dot_line"></div></td>
							</tr>
							<tr>
								<td colspan="2" height="10" align="center">
									<button type="button" class="btn_box btn_printer" onclick="window.open('../cs/sv_job_print.jsp?id=<%=entity.getId()%>','_blank');">Print Received Car</button>
									 | 
									<button type="button" class="btn_box btn_printer" onclick="window.open('../cs/sv_job_service_print.jsp?id=<%=entity.getId()%>','_blank');">Service Detail</button>
									 | 
									<button type="button" class="btn_box btn_printer" onclick="save_order('<%=entity.getId()%>');">Invoice</button>
									 | 
									<button type="button" class="btn_box btn_confirm" onclick="close_order('<%=entity.getId()%>');">Edit Job</button>
									<input type="hidden" name="id" value="<%=entity.getId()%>">
									<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
									<input type="hidden" name="service_type" value="<%=entity.getService_type()%>">
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
					
				});
				
				function close_order(id){
					if (confirm('Edit Job?')) {
						ajax_load();
						$.post('../PartSaleManage',$('#sale_part_form').serialize() + '&action=job_open',function(resData){
							ajax_remove();
							if (resData.status == 'success') {
								window.location='sv_job_description.jsp?id=<%=entity.getId()%>';
							} else {
								alert(resData.message);
							}
						},'json');
					}
				}
				
				function save_order(id){
					var url = '../cs/sv_job_inv_print.jsp?id=<%=entity.getId()%>';
					window.open(url,'_blank').focus();
				}
				</script>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>