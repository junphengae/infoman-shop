<%@page import="com.bitmap.bean.inventory.InventoryRepairDetail"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.inventory.InventoryLot"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/clear_form.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ยืมอะไหล่</title>

<script type="text/javascript">
$(function(){
	$('.create').click(function(){
		ajax_load();
		var data = {"action":"create_form_id","order_id":$(this).attr("order_id")};
		$.post('../SaleManage',data,function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				window.location="create_repair_form.jsp?repair_id=" + resData.repair_id + "&order_id=" + resData.order_id;
			} else {
				alert(resData.message);
			}
		
		},'json');	
	});
});


</script>
<%
String page_ = WebUtils.getReqString(request, "page");
String repair_id = WebUtils.getReqString(request, "repair_id");
String status = "10";

List paramList = new ArrayList();
paramList.add(new String[]{"repair_id",repair_id});
paramList.add(new String[]{"status",status});
session.setAttribute("SO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}
List list = InventoryRepairDetail.selectWithCTRL(ctrl, paramList);
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">
					ยืมอะไหล่
				</div>
				<div class="clear"></div>
			</div>			
			
			<div class="content_body">	
			
				<div class="left">
					<form style="margin: 0; padding: 0;" action="inv_borrow.jsp" id="search" method="get">
						เลขที่ใบซ่อม : <input type="text" class="s150 txt_box" name="repair_id" value="<%=repair_id%>" autocomplete="off">
						<input type="submit" name="submit" value="ค้นหา" class="btn_box s50 btn_confirm m_left5">
						<input type="button" name="reset" value="ล้าง" class="btn_box s50 m_left5" onclick="clear_form(this.form)">
						<input type="hidden" name="action" value="search">
					</form>
				</div>
				<div class="right txt_center">
					<%=PageControl.navigator_en(ctrl,"inv_borrow.jsp",paramList)%> 
				</div>
				<div class="clear"></div>
				<div class="dot_line"></div>
			
			<table class="bg-image s_auto">
					<thead>
						<tr>
							<th valign="top" align="center" width="10%">เลขที่ใบซ่อม</th>
							<th valign="top" align="center" width="10%">รหัสอะไหล่</th>
							<th valign="top" align="center" width="40%">รายการอะไหล่</th>
							<th valign="top" align="center" width="10%">จำนวน</th>
							<th valign="top" align="center" width="10%">สถานะ</th>
							<th width="10%"></th>
						</tr>
					</thead>
					<tbody>
						<%
						boolean has = true;
						Iterator ite = list.iterator();
						while(ite.hasNext()) {
							InventoryRepairDetail entity = (InventoryRepairDetail) ite.next();
							has = false;
						%>
							<tr>
								<td align="right"><%=entity.getRepair_id()%></td>
								<td align="center"><%=entity.getMat_code()%></td>
								<td><%=InventoryMaster.selectOnlyDescrip(entity.getMat_code())%></td>
								<td align="right"><%=entity.getQty()%></td>
								<td align="center"><%=InventoryRepairDetail.status(entity.getStatus())%></td>
								<td align="center">
									<% 
									String serial = InventoryMaster.checkSerial(entity.getMat_code());
									if(entity.getStatus().equalsIgnoreCase(InventoryRepairDetail.STATUS_WAIT)){
										if(serial.equalsIgnoreCase("y")){ %>
										<button type="button" class="btn_box btn_confirm" onclick="window.location='outlet_repair.jsp?auto_id=<%=entity.getAuto_id()%>&mat_code=<%=entity.getMat_code()%>';">เบิกอะไหล่</button>
										<%}else{ %>
										<button type="button" class="btn_box btn_confirm" onclick="window.location='outlet_repair_no_serial.jsp?auto_id=<%=entity.getAuto_id()%>&mat_code=<%=entity.getMat_code()%>';">เบิกอะไหล่</button>
										<%} 
									}%>
								</td>
							</tr>
						<%}
						if(has){%>
							<tr><td colspan="7" align="center">-- ไม่พบข้อมูล --</td></tr>
						<%}%>
					</tbody>
				</table>
				
			</div>
			<div class="wrap_desc">
			- หน้าจอนี้คือหลังจากที่มีการสร้างใบซ่อม แล้วมีการขอเบิกอะไหล่ 
			</div>
		</div>	
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
</body>
</html>