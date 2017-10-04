<%@page import="com.bitmap.utils.SNCUtils"%>
<%@page import="com.bitmap.bean.branch.BranchMaster"%>
<%@page import="java.util.Map"%>
<%@page import="com.bitmap.stock.BranchStockBean"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.parts.Vendor"%>
<%@page import="com.bitmap.bean.parts.PartVendor"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.parts.PartGroups"%>
<%@page import="com.bitmap.bean.parts.PartCategories"%>
<%@page import="com.bitmap.bean.parts.PartCategoriesSub"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.utils.Money"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery-1.4.2.min.js" type="text/javascript"></script>
<script src="../js/ajaxfileupload.js" type="text/javascript"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.webcam.js"></script>
<script src="../js/jquery.validate.min.js"></script>
<script src="../js/jquery.metadata.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Parts: Information</title>
<%
String id =WebUtils.getAjaxReqString(request, "id");
PartMaster entity = new PartMaster();
WebUtils.bindReqToEntity(entity, request);
PartMaster.select(entity);

String UnitDesc = UnitType.selectName(entity.getDes_unit());
%>

<script type="text/javascript">
function ajaxImgUpload(){
	$up = $('#fileToUpload');
	var pn = '<%=entity.getPn()%>';
	 
	if ($up.val() == '') {
		alert('Please select image!');
		$up.focus();
	} else {
		$("#loadingImg")
		.ajaxStart(function(){
			$(this).show();
			$showImg.hide();
		})
		.ajaxComplete(function(){
			$(this).hide();
			$showImg.show();
		});
		
		$.ajaxFileUpload({
			url:'../PhotoSnap', 
			secureuri:false,
			fileElementId:'fileToUpload',
			param: 'pn:' + pn,
			dataType: 'json',
			success: function (data, status){
				window.location.reload();
			},
			error: function (){
				window.location.reload();
			}
		});
	}
	return false;
}
</script>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left" >Parts: <%=entity.getPn() + " - " +entity.getDescription()%></div>
				<div class="right">
				<button class="btn_box btn_confirm" onclick="javascript: window.location='part_edit.jsp?pn=<%=entity.getPn()%>&height=500';">Edit Part</button>
				<button class="btn_box" type="button" onclick="window.location='<%=LinkControl.link("part_manage.jsp", (List)session.getAttribute("PART_SEARCH"))%>';">back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<fieldset class="fset s450 left min_h300">
					<legend>Information</legend>
					
					<table cellpadding="3" cellspacing="3" border="0" class="s400 center m_left30 breakword" >
						<tbody>
							<tr>
								<td width="30%"><label>Parts Number</label></td>
								<td>: <%=entity.getPn()%></td>
							</tr>
							<tr>
								<td><label>กลุ่ม</label></td>
								<td align="left">: <%=PartGroups.select(entity.getGroup_id()).getGroup_name_th()%></td>
							</tr>
							<tr>
								<td><label>ชนิด</label></td>
								<td align="left" >:	<%=PartCategories.select(entity.getCat_id(), entity.getGroup_id()).getCat_name_th()%></td>
							</tr>
							<tr>
								<td><label>ชนิดย่อย</label></td>
								<td align="left">: <%=PartCategoriesSub.select(entity.getSub_cat_id(), entity.getCat_id(),  entity.getGroup_id()).getSub_cat_name_th()%></td>
							</tr>
							<tr><td>หน่วยกลาง</td>
								<td align="left">: <%=UnitType.selectName(entity.getDes_unit())%></td>
							</tr>
							<tr valign="top" valign="top">
								<td><label>Description</label></td>
								<td align="left">: <%=entity.getDescription()%></td>
							</tr>
							<tr valign="top">
								<td><label>Fit-To</label></td>
								<td align="left">: <%=entity.getFit_to()%></td>
							</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr>
								<td><label title="Serial Number">Store Type</label></td>
								<td align="left">: <%=entity.getSn_flag().equalsIgnoreCase("1")?" Serial Number":entity.getSn_flag().equalsIgnoreCase("0")?" Non-Serial":""%></td>
							</tr>
							<tr>
								<td><label>Weight</label></td>
								<td align="left">: <%=entity.getWeight()%> &nbsp;&nbsp;Kg.</td>
							</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr>
								<td><label>Price</label></td>
								<td align="left">: 
									<%	
									String priceValue = Money.money(entity.getPrice());
									
									if(priceValue.length() > 0){
										out.print(priceValue);
									}else{
										out.print("0.00");
									}
            	
            						%>	
            							<%=PartMaster.unit(entity.getPrice_unit())%></td>
							</tr>
							<tr>
								<% 
								//if(!id.equalsIgnoreCase("1")){
								%>
								<td><label>Cost</label></td>
								<td align="left">: 
									<%	
									String costValue = Money.money(entity.getCost()).trim();
									
									if(costValue.length() > 0){
										out.print(costValue);
									}else{
										out.print("0.00");
									} %>
									 <%=PartMaster.unit(entity.getCost_unit())%>
								</td>
								<%	
							//	}
								%>
							</tr>
						</tbody>
					</table>
					<br/>
 			   		<div class="s450 center txt_center m_top5">
 			   		<%-- 
						<button class="btn_box" title="Edit" onclick="javascript: window.location='part_edit.jsp?pn=<%=entity.getPn()%>'">Edit</button>
						 --%>
						<!-- 
						<button class="btn_box thickbox" title="Edit" lang="part_edit.jsp?pn=<%//=entity.getPn()%>&height=550">Edit</button>
						 -->
					</div>
				</fieldset>
				
				<fieldset class="s450 fset right min_h300">
					<legend>Parts Photo</legend>
					
					<div id="div_img" class="center txt_center min_h240">
						<div class="min_h240 center txt_center" style="width: 320px; box-shadow: 0 0px 3px rgba(0,0,0,0.3);">
							<%-- <img width="320" height="240" src="../../images/motoshop/part/<%=entity.getPn()%>.jpg?state=<%=Math.random()%>"> --%>
							 <img width="320" height="240" src="../DisplayImagePn?pn=<%=entity.getPn()%>">												
						</div>
						
						<div class="m_top10">
							<input type="radio" name="uploadType" id="upImg"> <label for="upImg">Upload Photo</label> &nbsp;&nbsp; 
							<input type="radio" name="uploadType" id="camImg"> <label for="camImg">Capture by Webcam</label>
							<script type="text/javascript">
							$(function(){
								$('#upImg').click(function(){
									if ($('#upImg').is(':checked')) {
										$('#uploadImg').fadeIn(500);
										$('#webcam').hide();
									}
								});
								
								$('#camImg').click(function(){
									if ($('#camImg').is(':checked')) {
										$('#uploadImg').hide();
										$('#webcam').fadeIn(500);
									}
								});
								
								if ($('#upImg').is(':checked')) {
									$('#uploadImg').show();
									$('#webcam').hide();
								}
								
								if ($('#camImg').is(':checked')) {
									$('#uploadImg').hide();
									$('#webcam').show();
								}
							});
							</script>
						</div> 
						<br/><br/>
					</div>
					<!-- /*********************************** uploadImg **************************************/ -->
					<div id="uploadImg" class="txt_center center hide">
						<form enctype="multipart/form-data" method="post" action="" name="imgForm" style="margin: 0px; padding: 0px;">
							<input type="file" id="fileToUpload" name="fileToUpload" readonly="readonly" class="txt_box" onchange="return ajaxImgUpload();">
						</form>
					</div>
					<!-- /************************************ webcam *************************************/ -->
					<div id="webcam" class="s400 txt_center center hide"></div>
					<!-- /*************************************************************************/ -->
					
					<div class="clear"></div>
				</fieldset>
				
				<div class="clear"></div>
				
				<fieldset class="s450 fset left min_h150">
					<legend>Inventory</legend>
					<table cellpadding="3" cellspacing="3" border="0" class="s400 center m_left30">
						<tbody>
							<tr>
								<td width="25%"><label>Balance Qty</label></td>
								<td align="left">: <%=Money.moneyInteger(entity.getQty())+" "+UnitDesc%></td>
							</tr>
							<tr>
								<td><label title="Minimum Order Qty">MOQ</label></td>
								<td align="left">: <%=Money.moneyInteger(entity.getMoq())%></td>
							</tr>
							<tr>
								<td><label title="Minimum Order Repetetion">MOR</label></td>
								<td align="left">: <%=Money.moneyInteger(entity.getMor())%></td>
							</tr>
							<tr>
								<td><label>Location</label></td>
								<td align="left">: <%=entity.getLocation()%></td>
							</tr>
						</tbody>
					</table>
					 <div class="s400 center txt_center m_top20">
						<%if(entity.getSn_flag().length() > 0){
							if(entity.getSn_flag().equalsIgnoreCase("1")){%>
						<button class="btn_box thickbox" title="Print Barcode: <%=entity.getPn() + " - " + entity.getDescription() %>" lang="part_barcode.jsp?pn=<%=entity.getPn()%>&width=450&height=150">Print Barcode</button>
						<%
							} else {
						%>
						<button class="btn_box " title="Print Barcode: <%=entity.getPn() + " - " + entity.getDescription() %>" onclick="window.open('print_barcode_pn.jsp?pn=<%=entity.getPn()%>','barcode','location=0,toolbar=0,menubar=0,width=500,height=500');">Print Barcode</button> 
						<!-- <button class="btn_box btn_print_barcode">Print Barcode</button> -->
						<%
							}
						}
						%>
					<!--******************************************** -->
					<script type="text/javascript">
					$(".btn_print_barcode").click(function(){
						
						var pn = '<%=entity.getPn()%>';
						var update_by = '<%=securProfile.getPersonal().getPer_id()%>';
						ajax_load();
						$.post('../ImageBarcode','action=printbarcode&pn='+pn+'&update_by='+update_by,function(json){
							ajax_remove();
							if (json.status = 'success') {
								
								window.open('print_barcode_pn.jsp?pn='+pn+'','barcode','location=0,toolbar=0,menubar=0,width=500,height=500');
							} else {
								alert(json.message);
							}
						},'json');
						
						
					});
					
					
					</script>
					<!--******************************************** -->
						
					</div> 
				</fieldset>
				
				<fieldset class="s450 fset right min_h150">
					<legend>Parts Supersession</legend>
					<table cellpadding="3" cellspacing="3" border="0" class="s350 center m_left30">
						<tbody>
							<tr>
								<td width="35%"><label>SS Parts Number</label></td>
								<td>: <%=entity.getSs_no()%></td>
							</tr>
							<tr>
								<td><label>SS Flag</label></td>
								<td>: <%=entity.getSs_flag()%></td>
							</tr>
						</tbody>
					</table>
 					<div class="s400 center txt_center m_top5">
						<button class="btn_box" title="View Supersession" onclick="javascript: window.location='part_supersession.jsp?pn=<%=entity.getPn()%>';">Manage</button>
					</div> 
					
				</fieldset>
				
				<div class="clear"></div>
				
 				<%-- <fieldset class="fset">
					<legend>Vendor Information</legend>
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th valign="top" align="center" width="30%">Vendor Name</th>
								<th valign="top" align="center" width="25%">Min-Delivered Qty</th>
								<th valign="top" align="center" width="25%">Lead-Time</th>
							</tr>
						</thead>
						<tbody id="vendor_list">
						<%
						Iterator ite = PartVendor.selectList(entity.getPn()).iterator();
						boolean has = true;
						while(ite.hasNext()) {
							PartVendor masterVendor = (PartVendor) ite.next();
							Vendor vendor = masterVendor.getUIVendor();
							has = false;
						%>
							<tr id="vendor_<%=vendor.getVendor_id()%>">
								<td><%=vendor.getVendor_name()%></td>
								<td align="center"><%=masterVendor.getVendor_moq()%></td>
								<td align="center"><%=masterVendor.getVendor_delivery_time()%></td>
							</tr>
						<%
						} if (has) {
						%>
							<tr><td align="center" colspan="3">--- No Vendor ---</td></tr>
						<%}%>
						</tbody>
					</table>
					
					<div class="center txt_center m_top5">
						<button class="btn_box" onclick="javascript: window.location='part_edit_vendor.jsp?pn=<%=entity.getPn()%>';">Edit vendor info</button>
					</div>
				</fieldset>  --%>
				<%
				String page_ = WebUtils.getReqString(request, "page");
				PageControl ctrl = new PageControl();
				ctrl.setLine_per_page(10);

				if(page_.length() > 0){
					ctrl.setPage_num(Integer.parseInt(page_));
					session.setAttribute("BRANCH_STOCK_PAGE", page_);
				}

				if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("BRANCH_STOCK_PAGE") != null){
					ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("BRANCH_STOCK_PAGE")));
				}
				%>
				<%-- <fieldset class="fset">
					<legend>Branch Stock</legend>
					<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"part_info.jsp")%></div>
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th valign="top" align="center" width="30%">Part Number</th>
								<th valign="top" align="center" width="25%">Branch Name</th>
								<th valign="top" align="center" width="25%">Stock</th>
								<th valign="top" align="center" width="25%">Update Date</th>
							</tr>
						</thead>
						<tbody id="vendor_list">
						<%
						String pn = WebUtils.getReqString(request, "pn");
						Iterator ite_ = BranchStockBean.SelectList(ctrl,pn).iterator();
						boolean has_ = false;
						while(ite_.hasNext()) {
							BranchStockBean branchStock = (BranchStockBean) ite_.next();
							 String  branch_name = BranchMaster.selectBranch_name(branchStock.getBranch_id());
							// System.out.println(branchStock.getBranch_id() +""+branch_name);
							 has_ = true;
						%>
							<tr>
								<td><%=branchStock.getPn()%></td>
								<td align="center"><%=branch_name%></td>
								<td align="center"><%=branchStock.getStock()%></td>
								<td align="center"><%=WebUtils.getDateValue(branchStock.getUpdate_date())%></td>
							</tr>  
						<%
						} if (has_ == false) {
						%>
							<tr><td align="center" colspan="4">--- No Data ---</td></tr>
						<%}%>
						</tbody>
					</table>
					
					<div class="center txt_center m_top5">
						<button class="btn_box" onclick="javascript: window.location='part_edit_vendor.jsp?pn=<%=entity.getPn()%>';">Edit vendor info</button>
					</div>
				</fieldset>  --%>
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
<script language="JavaScript">
$("#webcam").webcam({
	upload_url: '../PhotoSnap?name=<%=entity.getPn()%>&action=webcam_part',
	redirect_url: 'part_info.jsp?pn=<%=entity.getPn()%>'
});
</script>
</body>
</html>