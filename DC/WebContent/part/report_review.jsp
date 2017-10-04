<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.branch.BranchMaster"%>
<%@page import="com.bitmap.stock.BranchStockBean"%>
<%@page import="com.bitmap.bean.parts.PartBorrow"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.parts.ServicePartDetail"%>
<%@page import="com.bitmap.bean.parts.PartLot"%>
<%@page import="com.bitmap.bean.parts.PartLotControl"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.parts.PartGroups"%>
<%@page import="com.bitmap.bean.parts.PartCategories"%>
<%@page import="com.bitmap.bean.parts.PartCategoriesSub"%>
<%@page import="com.bitmap.utils.ReportUtils"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.security.SecurityUnit"%>
<%@page import="com.bitmap.security.SecuritySystem"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Date"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%

String report_type = WebUtils.getReqString(request, "report_type");
String export = WebUtils.getReqString(request, "export");
String rd_time = WebUtils.getReqString(request, "rd_time");


String year_month = WebUtils.getReqString(request, "year_month");
String pn = WebUtils.getReqString(request, "pn");
String create_date = WebUtils.getReqString(request, "create_date");

String date_send2 = WebUtils.getReqString(request,"date_send2");
String date_send3 = WebUtils.getReqString(request, "date_send3");
String[] month_name = {
		 "",
		 "มกราคม ",  
		 "กุมภาพันธ์ ",  
		 "มีนาคม " , 
		 "เมษายน  ", 
		 "พฤษภาคม  ",
		 "มิถุนายน  ",
		 "กรกฎาคม   " , 
		 "สิงหาคม  ", 
		 "กันยายน  ",  
		 "ตุลาคม   " , 
		 "พฤศจิกายน  ", 
		 "ธันวาคม   " };
String HeaderDate = "";
if(rd_time.equalsIgnoreCase("0")){
	HeaderDate ="";
}else
if(rd_time.equalsIgnoreCase("1")){
	String create_date1 = WebUtils.getReqString(request, "create_date1");
	HeaderDate = "วันที่   "+create_date1.replaceAll("/", "-");
}else 
if(rd_time.equalsIgnoreCase("2")){
	String Mdate = WebUtils.getReqString(request, "month");
	String Ydate = WebUtils.getReqString(request, "year");
	HeaderDate = "ประจำเดือน  "+month_name[WebUtils.getInteger(Mdate)]+" ปี "+Ydate;
	
 }else 
if(rd_time.equalsIgnoreCase("3")){
	String date1 = WebUtils.getReqString(request, "date1");
	String date2 = WebUtils.getReqString(request, "date2");
	HeaderDate = "ระหว่างวันที่  "+date1.replaceAll("/", "-")+" ถึงวันที่ "+date2.replaceAll("/", "-");
}

List paramsList = new ArrayList();

	paramsList.add(new String[]{"pn",pn});
	if(report_type != ReportUtils.PART_STOCK || report_type != ReportUtils.PART_MOR ){
		if(rd_time.equals("1")){	paramsList.add(new String[]{"create_date",create_date});	}
		if(rd_time.equals("2")){	paramsList.add(new String[]{"year_month",year_month});	}
		if(rd_time.equals("3")){	paramsList.add(new String[]{"date_send2",date_send2,date_send3});	}
	}
	session.setAttribute("report_search", paramsList);

if (export.equalsIgnoreCase("true")) {
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=" + report_type + "_" + WebUtils.getDateValue(WebUtils.getCurrentDate()) + ".xls");

%>
<style type="text/css">
.tb{border-collapse: collapse;}
.tb tr, .tb td, .tb th{border: .5pt solid #000;border-top: .5pt solid #000; border-bottom: .5pt solid #000;}
.breakword tr  td {
	word-break:break-all;
} 
</style>
<%
} else {
%>

 <link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/theme_print.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<%}%>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Report Viewer</title>

</head>
<body>
	<center>	
<%

	Integer no = 1;
	Boolean has = false;
	/** Balance **/
	if (report_type.equalsIgnoreCase(ReportUtils.PART_STOCK)) {
	%>
	
	<div class="content_head"  >
			<Strong>รายงานสินค้าคงคลัง </Strong>
	</div>
	<table class="tb" ><!-- class="bg-image  s_auto breakword" -->
		<tbody>
			<tr align="center" class="txt_bold">
				<th valign="top" align="center" width="16%">รหัสอะไหล่</th>
				<th valign="top" align="center" width="5%">กลุ่ม</th>
				<th valign="top" align="center" width="5%">ชนิด</th>
				<th valign="top" align="center" width="5%">ชนิดย่อย</th>
				<th valign="top" align="center" width="28%">Description</th>
				<th valign="top" align="center" width="24%">Fit to</th>
				<th valign="top" align="center" width="5%">Units</th>
				<th valign="top" align="center" width="5%">Qty</th>
	<!-- 			<th valign="top" align="center" width="80">Moq</th>
				<th valign="top" align="center" width="80">Mor</th> -->
				<th valign="top" align="center" width="7%">Cost</th>
				<th valign="top" align="center" width="7%">Price</th>
	
			</tr>
			
			<%
			Iterator iteMas = PartMaster.selectWithNOCTRL(paramsList).iterator();
			String total = "0";
			String total_mor = "0";
			while(iteMas.hasNext()){
				has = true;
				PartMaster entity = (PartMaster) iteMas.next();
				total = Money.add(total, "1");
				if(DBUtility.getInteger(entity.getMor()) >= DBUtility.getInteger(entity.getQty())){
					total_mor = Money.add(total_mor, "1");
				}
				String des_unit = PartMaster.SelectUnitDesc(entity.getPn());
				
			%>
			
			<tr valign="top">
				<td align="Left" style='mso-number-format:"\@"'><%=entity.getPn()%></td>
				<td style='mso-number-format:"\@"' align="Left" ><%=PartGroups.select(entity.getGroup_id()).getGroup_name_th().trim()%></td>
				<td style='mso-number-format:"\@"'><%=PartCategories.select(entity.getCat_id(), entity.getGroup_id()).getcat_name_short().trim()%></td>
				<td style='mso-number-format:"\@"'><%=PartCategoriesSub.select(entity.getSub_cat_id(), entity.getCat_id(), entity.getGroup_id()).getSub_cat_name_th().trim()%></td>
				<td align="Left" style='word-wrap:break-word;mso-number-format:"\@"'><%=entity.getDescription()%></td>
				<td style='mso-number-format:"\@"' align="Left" ><%=entity.getFit_to()%></td>
				<td style='mso-number-format:"\@"' align="left"><%=UnitType.selectName(des_unit)%></td>
				<td style='mso-number-format:"0"' align="right"><%=Money.moneyInteger(entity.getQty())%></td>
			<%-- 	<td align="right"><%=Money.moneyInteger(entity.getMoq())%></td>
				<td align="right"><%=Money.moneyInteger(entity.getMor())%></td> --%>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getCost().length()>0 && !(entity.getCost().equalsIgnoreCase("0")|| entity.getCost().equalsIgnoreCase("0.00")))?Money.money(entity.getCost())+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getPrice().length()>0 && !(entity.getPrice().equalsIgnoreCase("0")|| entity.getPrice().equalsIgnoreCase("0.00")))?Money.money(entity.getPrice())+"":"0.00"%></td>
				<%-- <td align="right" ><%=(entity.getCost().length()>0)?Money.money(entity.getCost()):Money.money("0")%></td>
				<td align="right" ><%=(entity.getPrice().length()>0)?Money.money(entity.getPrice()):Money.money("0")%></td> --%>
			</tr>
			<%
						
			}
			
			if(has == false){
			
			%>
			<tr>
				<td align="center"  colspan="10">-- ไม่พบข้อมูล --</td>
			
			</tr>
			<% } %>
		</tbody>
		</table>
		<table  align="right"  class="txt_18">
				<tr>
					<td colspan="11" align="right" >
					<br/>
					<strong>	รายการอะไหล่ทั้งหมด </strong> : <%=Money.moneyInteger(total)%> รายการ
					</td>
				</tr>
		</table>
		
	<%}else if(report_type.equalsIgnoreCase(ReportUtils.PART_STOCK_BRANCH)){ %>
	<center>
		<div class="content_head">
				<strong>รายงานสินค้าคงคลัง(สาขา)</strong>
		</div>
		<table class="tb" width="100%">
						<thead>
							<tr>
								<th valign="top" align="center" width="30%"><strong>Part Number</strong></th>
								<th valign="top" align="center" width="25%"><strong>Branch Name</strong></th>
								<th valign="top" align="center" width="25%"><strong>Stock</strong></th>
								<th valign="top" align="center" width="25%"><strong>Update Date</strong></th>
							</tr>
						</thead>
						<tbody>
						<%
						Iterator ite_ = BranchStockBean.SelectList().iterator();
						boolean has_ = false;
						while(ite_.hasNext()) {
							BranchStockBean branchStock = (BranchStockBean) ite_.next();
							 String  branch_name = BranchMaster.selectBranch_name(branchStock.getBranch_id());
							 has_ = true;
						%>
							<tr>
								<td style='mso-number-format:"\@"'><%=branchStock.getPn()%></td>
								<td style='mso-number-format:"\@"' align="left"><%=branch_name%></td>
								<td style='mso-number-format:"0"'align="center"><%=branchStock.getStock()%></td>
								<td style='mso-number-format:"Short Date"' align="center"><%=WebUtils.getDateValue(branchStock.getUpdate_date())%></td>
							</tr>
						<%
						} if (has_ == false) {
						%>
							<tr><td align="center" colspan="4">--- No Branch ---</td></tr>
						<%}%>
						</tbody>
					</table>
	</center>
	<%
	} else
		if (report_type.equalsIgnoreCase(ReportUtils.PART_MOR)) {
	%>
	<center>
	<div class="content_head"  >
			<Strong>รายงานสินค้าเหลือน้อย</Strong>
	</div>
	<table class="tb" style="width: 100%;">
		<tbody>
				<tr align="center" class="txt_bold">
				<th valign="top" align="center" width="15%">รหัสอะไหล่</th>
				<th valign="top" align="center" width="7%">กลุ่ม</th>
				<th valign="top" align="center" width="7%">ชนิด</th>
				<th valign="top" align="center" width="7%">ชนิดย่อย</th>
				<th valign="top" align="center" width="20%">Description</th>
				<th valign="top" align="center" width="15%">Fit to</th>
				<th valign="top" align="center" width="10%">Units</th>
				<th valign="top" align="center" width="10%">Qty</th>
				<th valign="top" align="center" width="10%">Mor</th> 
			<!-- 	<th valign="top" align="center" width="9%">Cost</th>
				<th valign="top" align="center" width="9%">Price</th> -->
				
	
			</tr>
			<%
			Iterator iteMas = PartMaster.selectMOR(paramsList).iterator();
			while(iteMas.hasNext()){
				has = true;
				PartMaster entity = (PartMaster) iteMas.next();
				String des_unit = PartMaster.SelectUnitDesc(entity.getPn());
			%>
			<tr valign="top">
				<td align="Left" style='mso-number-format:"\@"'><%=entity.getPn()%></td>
				<td align="Left" style='mso-number-format:"\@"'><%=PartGroups.select(entity.getGroup_id()).getGroup_name_th().trim()%></td>
				<td style='mso-number-format:"\@"'><%=PartCategories.select(entity.getCat_id(), entity.getGroup_id()).getcat_name_short().trim()%></td>
				<td style='mso-number-format:"\@"'><%=PartCategoriesSub.select(entity.getSub_cat_id(), entity.getCat_id(), entity.getGroup_id()).getSub_cat_name_th().trim()%></td>
				<td align="Left" style='word-wrap:break-word;mso-number-format:"\@"'><%=entity.getDescription()%></td>
				<td align="Left" style='mso-number-format:"\@"'><%=entity.getFit_to()%></td>
				<td align="left" style='mso-number-format:"\@"'><%=UnitType.selectName(des_unit)%></td>
				<td align="right" style='mso-number-format:"0"'><%=Money.moneyInteger(entity.getQty())%></td>
				<td align="right" style='mso-number-format:"0"'><%=Money.moneyInteger(entity.getMor())%></td>
		<%-- 		<td align="right" ><%=Money.money(entity.getPrice())%></td>
				<td align="right" ><%=(entity.getCost().length()>0)?Money.money(entity.getCost()):Money.money("0")%></td> --%>
				
			</tr>
			<%
			}
			
			if(has == false){
			
			%>
			<tr>
				<td align="center"  colspan="9">-- ไม่พบข้อมูล --</td>
			
			</tr>
			<% } %>
		</tbody>
	</table>
	<%}
	if (report_type.equalsIgnoreCase(ReportUtils.PART_OUT)) {
	%>
	<div class="content_head"  >
			<Strong>รายงานการเบิกสินค้า</Strong>
			<br/>
			<Strong>
			<%=HeaderDate %> 
			</Strong>
	</div>
	<table class="tb" style="width: 100%;">
		<tbody>
			<tr align="center">
				<th valign="top" align="center" width="10%">Job ID</th>
				<th valign="top" align="center" width="15%">Pn</th>
				<th valign="top" align="center" width="15%">Sn</th>
				<th valign="top" align="center" width="10%">Units</th>
				<th valign="top" align="center" width="10%">Draw Qty</th>
				<th valign="top" align="center" width="10%">Draw Price</th>
				<th valign="top" align="center" width="10%">Draw Discount</th>
				<th valign="top" align="center" width="15%">Draw By</th>
				<th valign="top" align="center" width="15%">Draw Date</th>
			</tr>
			<%
			Iterator iteMas = PartLotControl.report(paramsList).iterator();
			while(iteMas.hasNext()){
				has = true;
				PartLotControl entity = (PartLotControl) iteMas.next();
				String des_unit = PartMaster.SelectUnitDesc(entity.getPn());
			%>
			<tr >
				
				<td style='mso-number-format:"\@"' align="right"><%=entity.getJob_id()%></td>
				<td style='mso-number-format:"\@"' align="left"><%=entity.getPn()%></td>
				<td style='mso-number-format:"\@"' align="left"><%=entity.getSn()%></td>
				<td style='mso-number-format:"\@"' align="left"><%=UnitType.selectName(des_unit)%></td>
				<td style='mso-number-format:"0"' align="right"><%=Money.moneyInteger(entity.getDraw_qty())%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getDraw_price().length()>0 && !(entity.getDraw_price().equalsIgnoreCase("0")|| entity.getDraw_price().equalsIgnoreCase("0.00")))?Money.money(entity.getDraw_price())+"":"0.00"%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getDraw_discount().length()>0 && !(entity.getDraw_discount().equalsIgnoreCase("0")|| entity.getDraw_discount().equalsIgnoreCase("0.00")))?Money.money(entity.getDraw_discount())+"":"0.00"%></td>
				<td style='mso-number-format:"\@"' align="left"><%=Personal.selectOnlyPerson(entity.getDraw_by()).getName().trim()%></td>
				<td style='mso-number-format:"Short Date"' align="center"><%=WebUtils.getDateValue(entity.getDraw_date()) %></td>
			</tr>
			<%
			}
			
			if(has == false){
			
			%>
			<tr>
				<td align="center"  colspan="9">-- ไม่พบข้อมูล ---</td>
			
			</tr>
			<% } %>
		</tbody>
	</table>
	<%} 
	if (report_type.equalsIgnoreCase(ReportUtils.PART_BOR)) {
	%>
	<div class="content_head"  >
			<Strong>รายงานการยืมสินค้า</Strong>
			<br/>
			<Strong>
			<%=HeaderDate %> 
			</Strong>
	</div>
	<table class="tb" style="width: 100%;">
		<tbody>
			<tr align="center">
				<!-- <th valign="top" align="center"  width="5%">No</th> -->
				<th valign="top" align="center" width="15%">Pn</th>
				<th valign="top" align="center" width="10%">Sn</th>
				<th valign="top" align="center" width="25%">Description</th>
				<th valign="top" align="center" width="10%">Units</th>
				<th valign="top" align="center" width="10%">Borrow Qty</th>
				<th valign="top" align="center" width="10%">Return Qty</th>
				<!-- <th valign="top" align="center" width="5%">Scrap Qty</th> -->
				<th valign="top" align="center" width="10%">Create Date</th>
				<th valign="top" align="center" width="10%">Borrow By</th>
				<!-- <th valign="top" align="center" width="5%">Status</th> -->
				<th valign="top" align="center" width="10%">Note</th> 
				<!-- <th valign="top" align="center" width="10%">Return Date</th>	 -->
			</tr>
			<%
			Iterator iteMas = PartBorrow.report_bor(paramsList).iterator();
			while(iteMas.hasNext()){
				has = true;
				PartBorrow entity = (PartBorrow) iteMas.next();
				String des_unit = PartMaster.SelectUnitDesc(entity.getPn());
			%>
			<tr>
				<%-- <td align="center" ><%=entity.getRun()%></td> --%>
				<td align="Left" style='mso-number-format:"\@"'><%=entity.getPn()%></td>
				<td align="Left" style='mso-number-format:"\@"'><%=entity.getSn()%></td>
				<td align="Left" style='mso-number-format:"\@"'><%=entity.getUIDescription()%></td>
				<td align="left" style='mso-number-format:"\@"'><%=UnitType.selectName(des_unit)%></td>
				<td align="right" style='mso-number-format:"0"'><%=entity.getQty()%></td>
				<td align="right" style='mso-number-format:"0"'><%=entity.getReturn_qty()%></td>
				
				<%-- <td align="right"><%=entity.getScrap_qty()%></td> --%>
				<td align="center" style='mso-number-format:"Short Date"'><%=WebUtils.getDateValue(entity.getCreate_date())%></td>
				<td align="left" style='mso-number-format:"\@"'><%=Personal.selectOnlyPerson(entity.getBorrow_by()).getName().trim()%></td>
			<%-- 	<td align="center"><%=entity.getStatus()%></td> --%>
				<td align="left" style='mso-number-format:"\@"'><%=entity.getNote()%></td>
			<%-- 	<td align="left"><%=WebUtils.getDateValue(entity.getReturn_date())%></td> --%>
			</tr>
			<%
			}
			if(has == false){
				
			%>
				<tr>
					<td align="center"  colspan="9">-- ไม่พบข้อมูล --</td>
				
				</tr>
				<% } %>
			
		</tbody>
	</table>
	<%}%>
</center>
	<%
	if (report_type.equalsIgnoreCase(ReportUtils.PART_ADD)) {
	
	%>
	<center>
	<div class="content_head"  >
			<Strong>รายงานการนำเข้าสินค้า</Strong>
			<br/>
			<Strong>
			<%=HeaderDate %> 
			</Strong>
	</div>
	<table class="tb" style="width: 100%;">
		<tbody>
			<tr align="center">
			<!-- 	<th valign="top" align="center" width="5%">Lot No</th> -->
				<th valign="top" align="center" width="10%">Create Date</th>	
				<th valign="top" align="center" width="15%">po</th>
				<th valign="top" align="center" width="25%">pn</th>
				<th valign="top" align="center" width="15%">sn</th>
				<th valign="top" align="center" width="10%">Units</th>
				<th valign="top" align="center" width="10%">Lot Qty</th>
				<th valign="top" align="center" width="10%">Lot Price</th>
			<!-- 	<th valign="top" align="center" width="8%">Invoice</th> -->
			<!-- <th valign="top" align="center" width="5%">Lot Status</th> -->
			<!-- 	<th valign="top" align="center" width="10%">Lot Expire</th> -->
				<th valign="top" align="center" width="15%">Note</th>
			</tr>
			<%
			Iterator iteMas = PartLot.report_add(paramsList).iterator();
			while(iteMas.hasNext()){
				has = true;
				PartLot entity = (PartLot) iteMas.next();
				String des_unit = PartMaster.SelectUnitDesc(entity.getPn());
			%>
			<tr align="center">
				
				<%-- <td align="center"><%=entity.getLot_no() %></td> --%>
				<td align="center" style='mso-number-format:"Short Date"'><%=WebUtils.getDateValue(entity.getCreate_date()) %></td>	
				<td style='mso-number-format:"\@"' align="center"><%=entity.getPo() %></td>
				<td style='mso-number-format:"\@"' align="left"><%=entity.getPn() %></td>
				<td style='mso-number-format:"\@"' align="left"><%=entity.getSn() %></td>
				<td align="center" style='mso-number-format:"\@"'><%=UnitType.selectName(des_unit)%></td>
				<td align="right" style='mso-number-format:"0"'><%=Money.moneyInteger(entity.getLot_qty())%></td>
				<td style='mso-number-format:"\#\,\#\#0\.00"' align="right"><%=(entity.getLot_price().length()>0 && !(entity.getLot_price().equalsIgnoreCase("0")|| entity.getLot_price().equalsIgnoreCase("0.00")))?Money.money(entity.getLot_price())+"":"0.00"%></td>
<%-- 			<td align="right"><%=entity.getInvoice() %></td> --%>
<%-- 			<td align="right"><%=entity.getLot_status() %></td>
				<td align="left"><%=WebUtils.getDateValue(entity.getLot_expire()) %></td> --%>
				<td align="left" style='mso-number-format:"\@"'><%=entity.getNote()%></td>
			</tr>
			<%
			}
			if(has == false){
				
				%>
					<tr>
						<td align="center"  colspan="8">-- ไม่พบข้อมูล--</td>
					
					</tr>
			<% } %>
			
		</tbody>
	</table>
	<%}
	
	 no = null;
	%>
</center>		
</body>
</html>