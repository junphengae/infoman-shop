<%@page import="com.bmp.purchase.bean.PurchaseRequestBean"%>
<%@page import="com.bmp.purchase.transaction.PurchaseRequestTS"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.webservice.UnitTypeTS"%>
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
String vendor_id = WebUtils.getReqString(request, "vendor_id");
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();

paramList.add(new String[]{"vendor_id",vendor_id});

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}
Iterator ite = PurchaseRequestTS.select4IssuePO(paramList).iterator();

%>
</head>
<body>
	
	<table class="bg-image s800">
		<thead>
			<tr>
				<th valign="top" align="center" width="20%">วันที่</th>
				<th valign="top" align="left" width="30%">ชื่อสินค้า</th>
				<th valign="top" align="left" width="10%">หน่วยนับ</th>
				<th valign="top" align="right" width="20%">ราคาต่อหน่วย</th>
				<th valign="top" align="right" width="20%">จำนวนที่สั่ง</th>
				<th align="center" width="10%"></th>
			</tr>
		</thead>
		<tbody>
		<%
			boolean has = true;
			while(ite.hasNext()) {
				PurchaseRequestBean entity = (PurchaseRequestBean) ite.next();
				PartMaster master = PartMaster.select(entity.getMat_code());
				has = false;
		%>
			<tr id="tr_<%=entity.getId()%>">
				<td align="center"><%=WebUtils.getDateValue(entity.getCreate_date())%></td>
				<td align="left"><%=master.getDescription()%> </td>
				<td align="left"><%=UnitType.selectName(master.getDes_unit())%> </td>
				<td align="right"><%=Money.money(entity.getOrder_price()) %></td>
				<td align="right"><%=Money.moneyInteger(entity.getOrder_qty())%></td>
				<td align="center">
					<button class="btn_box btn_select" data_id=<%=entity.getId()%> mat_code=<%=entity.getMat_code()%>>เลือก</button>
				</td>
			</tr>
		<%
			}
			if(has){
		%>
			<tr><td colspan="5" align="center">---- ไม่พบข้อมูลการขอจัดซื้อสินค้า ---- </td></tr>
		<%
			}
		%>
		</tbody>
	</table>
	
	<script type="text/javascript">
	$(function(){
		$('.btn_select').click(function(){
			ajax_load();
			$.post('../PurchaseManageServlet',{'action':'add_to_po','po':'<%=po%>','id':$(this).attr('data_id'),'mat_code':$(this).attr('mat_code'),'update_by':'<%=securProfile.getPersonal().getPer_id()%>'},function(resData){
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