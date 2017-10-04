<%@page import="com.bitmap.security.SecurityProfile"%>
<%@page import="com.bitmap.bean.inventory.UnitType"%>
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
List paramList = new ArrayList();

paramList.add(new String[]{"po",po_no});

session.setAttribute("PR_SEARCH", paramList);

Iterator ite = PurchaseRequest.selectPRlist(paramList).iterator();

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
			$.post('../PurchaseManage', {'action':'close_po','po':'<%=po_no%>','update_by':'<%=securProfile.getPersonal().getPer_id()%>'},function(json){
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
					<button class="btn_box btn_warn "  id="btn_close_po"><%= "Close &nbsp;&nbsp;&nbsp;PO No : "+po_no %></button>
				</div>
				
		
				<div class="right">
					<button class="btn_box" onclick="javascript: history.back();">Back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<div class="left">					
				</div>
				<div class="clear"></div>
				
				<div class="dot_line"></div>
				<!-- /***************************************************/ -->
				<table class="bg-image  breakword" width="100%"><!-- เพิมbreakword มาเพื่อตัดคำ -->
					<thead>
						<tr>
							<th valign="top" align="center" width="15%">P/N</th>							
							<th valign="top" align="center" width="30%">Description</th>
							<th valign="top" align="center" width="10%">Units</th> 
							<th valign="top" align="center" width="10%">QTY</th> 
							<th valign="top" align="center" width="10%">Order</th>							
							<th valign="top" align="center" width="10%">Recieve</th> 
							<th align="center" width="15%" ></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							
							<td colspan="7" style="padding: 0px 0px 0px 0px;" width="100%">
								<div class="scroll">
								<table class="bg-image"  style="border-collapse: collapse;" width="100%">
									<%
								boolean has = true;
							    
								int close_po = 0;
								while(ite.hasNext()) {
									PurchaseRequest entity = (PurchaseRequest) ite.next();
									PartMaster master = entity.getUIPartMaster();
									
									String UnitDesc = UnitType.selectName(PartMaster.SelectUnitDesc(entity.getMat_code()));
																	
									has = false;									 
									recive_qty = "0";
									
									if(entity.getUIrecive_qty().length()>0){
										
										//ทำ replace เนื่องจากถึงหลักพันแล้ว error ต้องเอา "," ออกเนื่องจากคำนวนเป็น int
										String recive_qty_rep = Money.moneyInteger(entity.getUIrecive_qty()).replace(",", ""); 
										recive_qty = recive_qty_rep;									
									}
							%>
										<tr>
											<td align="left" valign="top" width="15%"><%=entity.getMat_code()%></td>											
											<td align="left" valign="top" width="31%"><%=master.getDescription()%></td>
											<td align="left" valign="top" width="10%"><%=UnitDesc%></td>
											<% 
											int Order_qty = 0 ;
											int recive =0 ;
											//ทำ replace เนื่องจากถึงหลักพันแล้ว error ต้องเอา "," ออกเนื่องจากคำนวนเป็น int
											String Order_qty_rep= entity.getOrder_qty().replace(",", ""); 
											 
											 if(!entity.getOrder_qty().equalsIgnoreCase("")){
												 Order_qty = Integer.parseInt(Order_qty_rep);
											 }
											 if(!recive_qty.equalsIgnoreCase("")){
												
												 recive = Integer.parseInt(String.valueOf(recive_qty));
											 }
											 
											 if(Order_qty > recive){
												close_po++;
											 }
											 
											if(Order_qty < recive ){ %>
											<td align="right" valign="top" width="10%"><font color="red"><%=Money.moneyInteger(master.getQty())%> </font></td>
											<%}else{ %>
											<td align="right" valign="top" width="10%"><%=Money.moneyInteger(master.getQty())%> </td>
											<%} %>
											
											<td align="right" valign="top" width="10%" class="order_qty" val="<%=entity.getOrder_qty()  %>" >  
											<%=Money.moneyInteger(Order_qty_rep)%>
											</td>
											<td align="right" valign="top" width="10%" class="recive_qty" val="<%=recive_qty  %> ">					
											<%=Money.moneyInteger(recive_qty)%>
											</td>
											<td align="center" valign="top" width="15%">									
											<a class="btn_view" href="part_info_view.jsp?pn=<%=entity.getMat_code()%>" title="View Parts Information"></a>
											&nbsp;&nbsp;
											<a class="btn_download thickbox" title="Add Stock" lang="part_add_stock_detail.jsp?po=<%=po_no %>&pn=<%=entity.getMat_code()%>&id=<%=entity.getId()%>&width=890&height=390"></a>	
											<%-- &nbsp;&nbsp;
											<a class="btn_update thickbox" title="Edit Stock" lang="part_edit_stock_detail.jsp?po=<%=po_no %>&pn=<%=entity.getMat_code()%>&id=<%=entity.getId()%>&width=890&height=390"></a>
											 --%>
											</td>
										</tr>
									<%
									}
									if(has){
									%>
									<tr><td colspan="7" align="center">Parts Master cannot be found!</td></tr>
									<%
									}
									%>
								</table>
								</div>	
							</td>
							
							
									
						</tr>			
					</tbody>
				</table>
				<!-- /***************************************************/ -->
				</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
<%if( close_po == 0 ){ %>
<script type="text/javascript">
$(function(){
	
	if(confirm('Confirm Close (PO No : <%=po_no%> )' )) {
		ajax_load();
		$.post('../PurchaseManage', {'action':'close_po','po':'<%=po_no%>','update_by':'<%=securProfile.getPersonal().getPer_id()%>'},function(json){
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