<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="com.bitmap.bean.parts.PartMaster" %>
<%@page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายการขอจัดซื้อ</title>
<%
String po = WebUtils.getReqString(request, "po");
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}
Iterator ite = PurchaseRequest.select4IssuePO(paramList).iterator();
%>
</head>
<body>
	
	<table class="bg-image s850">
		<thead>
			<tr align="center">
				<th valign="top"  width="12%">วันที่</th>
				<th valign="top"  width="15%">รหัสสินค้า</th>
				<th valign="top"  width="35%">ชื่อสินค้า</th>
				<th valign="top"  width="10%">หน่วยนับ</th>
				<th valign="top"  width="13%">จำนวนที่สั่ง</th>
				<th valign="top"  width="13%">ราคาต่อหน่วย</th>				
				<th width="12%"></th>
			</tr>
		</thead>
		<tbody>
		<%
			boolean has = true;
			while(ite.hasNext()) {
				PurchaseRequest entity = (PurchaseRequest) ite.next();
				PartMaster master = PartMaster.select(entity.getMat_code());
				has = false;
				
				String UnitDesc = UnitType.selectName(master.getDes_unit());
		%>
			<tr id="tr_<%=entity.getId()%>">
				<td align="center"><%=WebUtils.getDateValue(entity.getCreate_date())%></td>
				<td align="left"><%=master.getPn()%> </td>
				<td align="left"><%=master.getDescription()%> </td>
				<td align="left"><%=UnitDesc  %></td>
				<td align="right"><%=Money.moneyInteger(entity.getOrder_qty())%></td>
				<td align="right"><%=Money.money(entity.getOrder_price())  %></td>				
				<td align="center">
					<button class="btn_box btn_select" data_id=<%=entity.getId()%> mat_code=<%=entity.getMat_code()%>>เลือก</button>
				</td>
			</tr>
		<%
			}
			if(has){
		%>
			<tr><td colspan="7" align="center">---- ไม่พบข้อมูลการขอจัดซื้อสินค้า ---- </td></tr>
		<%
			}
		%>
		</tbody>
	</table>
	
	<script type="text/javascript">
	$(function(){
		$('.btn_select').click(function(){
			ajax_load();
			$.post('../PurchaseManage',{'action':'add_to_po','po':'<%=po%>','id':$(this).attr('data_id'),'mat_code':$(this).attr('mat_code'),'update_by':'<%=securProfile.getPersonal().getPer_id()%>'},function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location.reload();
				} else {
					alert(resData.message);
				}
			},'json');
		});
	});
	</script>
</body>
</html>