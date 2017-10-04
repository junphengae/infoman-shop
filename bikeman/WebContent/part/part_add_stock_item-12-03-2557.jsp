<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.parts.PartGroups"%>
<%@page import="com.bitmap.bean.parts.PartCategories"%>
<%@page import="com.bitmap.bean.parts.PartCategoriesSub"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="com.bitmap.webutils.customtag.ComboBoxTag"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css">
<link href="../css/unit.css" rel="stylesheet" type="text/css">
<link href="../css/table.css" rel="stylesheet" type="text/css">
<link href="../css/loading.css" rel="stylesheet" type="text/css">
<link href="../css/barcode.css" rel="stylesheet" type="text/css" media="all">

<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/thickbox.js" type="text/javascript"></script>
<script src="../js/loading.js" type="text/javascript"></script>
<script src="../js/clear_form.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Purchase Request</title>
<%
String po_no = WebUtils.getReqString(request, "po");
String status = "30";

String page_ = WebUtils.getReqString(request, "page");
List paramList = new ArrayList();

paramList.add(new String[]{"po",po_no});
//paramList.add(new String[]{"status",status});

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(25);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}
session.setAttribute("PR_SEARCH", paramList);

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("PR_SEARCH_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("PR_SEARCH_PAGE")));
}

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("PR_SEARCH_PAGE", page_);
}

Iterator ite = PurchaseRequest.selectPRlist(ctrl, paramList).iterator();
String recive_qty = null;
%>


<script type="text/javascript">
$(function(){
 var btn_close = $('#btn_close_po');
 
 btn_close.click(function(){	 		
	 close_po();
	});


 function close_po(){			
	 if(confirm('Confirm Close (PO No : <%=po_no%> )' )) {
			ajax_load();
			$.post('../PurchaseManage', {'action':'close_po','po':'<%=po_no%>'},function(json){
				ajax_remove();
				if (json.status == 'success') {
					window.location='part_add_stock.jsp';
				} else {
					alert(json.message);
				}
			},'json');
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
				<div class="left"> <%= "Purchase Order No : "+po_no %>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<button class="btn_box btn_warn "  id="btn_close_po"> <%= "Close &nbsp;&nbsp;&nbsp;PO No : "+po_no %></button>
				</div>
				
		
				<div class="right">
					<button class="btn_box" onclick="javascript: history.back();">Back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<div class="left">
					
				</div>
					<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"part_add_stock_item.jsp",paramList)%></div>
				<div class="clear"></div>
				
				<div class="dot_line"></div>
				<!-- 	<div class="scroll"> -->
						<table class="bg-image s_auto">
							<thead>
								<tr>
									<th valign="top" align="center" width="12%">P/N</th>
									<th valign="top" align="center" width="9%">กลุ่ม</th>
									<th valign="top" align="center" width="9%">ชนิด</th>
									<th valign="top" align="center" width="9%">ชนิดย่อย</th>
									<th valign="top" align="center" width="30%">Description</th>
									<th valign="top" align="center" width="7%">QTY</th> 
									<th valign="top" align="center" width="7">Order</th>
									<th valign="top" align="center" width="7%">Recieve</th> 
									<th align="center" width="0%" ></th>
								</tr>
							</thead>
						<tbody>
							<%
								boolean has = true;
							    
								int close_po = 0;
								while(ite.hasNext()) {
									PurchaseRequest entity = (PurchaseRequest) ite.next();
									PartMaster master = entity.getUIPartMaster();
								//	InventoryMasterVendor mVendor = entity.getUIInvVendor();
									has = false;
																		 
									recive_qty = "0";
									
									if(entity.getUIrecive_qty().length()>0){
										
										//ทำ replace เนื่องจากถึงหลักพันแล้ว error ต้องเอา "," ออกเนื่องจากคำนวนเป็น int
										String recive_qty_rep = Money.moneyInteger(entity.getUIrecive_qty()).replace(",", ""); 
										recive_qty = recive_qty_rep;
										//System.out.println("entity.getUIrecive_qty()::"+entity.getUIrecive_qty()+"recive_qty_rep:"+recive_qty_rep);
									}
							%>
								<tr valign="top">
									<td align="center" valign="top"><%=entity.getMat_code()%></td>
									<td align="center" valign="top">
										<%=PartGroups.select(master.getGroup_id()).getGroup_name_en().trim()%>
									</td>
									<td align="center" valign="top">
										<%=PartCategories.select(master.getCat_id(), master.getGroup_id()).getcat_name_short().trim()%>
									</td>
									<td align="center" valign="top">
										<%=PartCategoriesSub.select(master.getSub_cat_id(),master.getCat_id(), master.getGroup_id()).getSub_cat_name_short().trim()%>
									</td>
									<td align="left" valign="top">
										<!-- <div class="thickbox pointer" lang="../info/inv_master_info.jsp?width=800&height=380&mat_code=<% //=entity.getMat_code()%>" title="ข้อมูลสินค้า">
											
										</div> -->
										<%=master.getDescription()%>
									</td>
									<% 
									int Order_qty = 0 ;
									int recive =0 ;
									//ทำ replace เนื่องจากถึงหลักพันแล้ว error ต้องเอา "," ออกเนื่องจากคำนวนเป็น int
									String Order_qty_rep= entity.getOrder_qty().replace(",", ""); 
									// System.out.println("Order_qty_rep::"+Order_qty_rep+"entity.getOrder_qty()::"+entity.getOrder_qty()+"master.getQty()::"+master.getQty()+"recive_qty::"+recive_qty);
									 
									 if(!entity.getOrder_qty().equalsIgnoreCase("")){
										 Order_qty = Integer.parseInt(Order_qty_rep);
									 }
									 if(!recive_qty.equalsIgnoreCase("")){
										
										 recive = Integer.parseInt(String.valueOf(recive_qty));
									 }
									 
									 if(Order_qty > recive){ //ตรวจสอบเพื่อ close_po อัตโนมัติ
										close_po++;
									 }
									 
									if(Order_qty < recive ){ %>
									<td align="right" valign="top"><font color="red"><%=Money.moneyInteger(master.getQty())%> </font></td>
									<%}else{ %>
										<td align="right" valign="top"><%=Money.moneyInteger(master.getQty())%> </td>
									<%} %>
									<td align="right" valign="top" class="order_qty" val="<%=entity.getOrder_qty()%>" >  
										<%=Money.moneyInteger(Order_qty_rep)%>
									</td>
									<td align="right" valign="top" class="recive_qty" val="<%=recive_qty%>">
									
										<%=Money.moneyInteger(recive_qty)%>
									</td>
									<td align="center" valign="top">
										
										<a class="btn_view" href="part_info_view.jsp?pn=<%=entity.getMat_code()%>" title="View Parts Information"></a>
										&nbsp;&nbsp;
										 <a class="btn_download thickbox" title="Add Stock" lang="part_add_stock_detail.jsp?po=<%=po_no %>&pn=<%=entity.getMat_code()%>&id=<%=entity.getId()%>&width=890&height=390"></a>	
									</td>
								</tr>
							<%
								}
								if(has){
							%>
								<tr><td colspan="9" align="center">Parts Master cannot be found!</td></tr>
							<%
								}
							%>
							</tbody> 
						</table>
					 <!--  </div> -->
				</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
<!-- //////////////******************** รอแก้ไข  ***************/////////////////////// -->
 <%if( close_po == 0 ){ %>
<script type="text/javascript">
$(function(){
	if(confirm('Confirm Close (PO No : <%=po_no%> )' )) {
		ajax_load();
		$.post('../PurchaseManage', {'action':'close_po','po':'<%=po_no%>'},function(json){
			ajax_remove();
			if (json.status == 'success') {
				window.location='part_add_stock.jsp';
			} else {
				alert(json.message);
			}
		},'json');
}
	
});
</script>
<%} %> 

</body>
</html>