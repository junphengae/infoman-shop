<%@page import="com.bmp.parts.check.stock.CheckStockTS"%>
<%@page import="com.bmp.parts.check.stock.CheckStockHDTS"%>
<%@page import="com.bmp.parts.check.stock.CheckStockReportBean"%>
<%@page import="com.bmp.lib.date.thai.DateFormatThai"%>
<%@page import="com.bitmap.bean.inventory.UnitType"%>
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
<%@page import="com.bitmap.bean.parts.StockCardReport"%>
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

String check_id = WebUtils.getReqString(request, "check_id");
String word = WebUtils.getReqString(request, "word");
word = "ประจำ"+word;

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
	HeaderDate = "ระหว่างวันที่"+date1.replaceAll("/", "-")+" ถึงวันที่ "+date2.replaceAll("/", "-");
}



List<String[]> paramsList = new ArrayList<String[]>();

	paramsList.add(new String[]{"pn",pn.trim()});
	if(report_type != ReportUtils.PART_STOCK || report_type != ReportUtils.PART_MOR ){
		if(rd_time.equals("1")){	paramsList.add(new String[]{"create_date",create_date});	}
		if(rd_time.equals("2")){	paramsList.add(new String[]{"year_month",year_month});	}
		if(rd_time.equals("3")){	paramsList.add(new String[]{"date_send2",date_send2,date_send3});	}
	}else if(report_type.equalsIgnoreCase(ReportUtils.STOCK_CARD)){
		
		paramsList.add(new String[]{"create_date",create_date});
	}
	session.setAttribute("report_search", paramsList);

	if (export.equalsIgnoreCase("true")) {

		response.setContentType("application/vnd.ms-excel");
		response.setHeader("Content-Disposition", "attachment; filename="+ report_type + WebUtils.getDateValue(WebUtils.getCurrentDate()) + ".xls");

	%>
	<style type="text/css">
	.tb{border-collapse: collapse;}
	.tb tr, .tb td, .tb th{border: .5pt solid #000;border-top: .5pt solid #000; border-bottom: .5pt solid #000;}
	.breakword tr  td {
		word-break:break-all;
	} 
	</style>

	<% }else{
	%>
	<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
	<link href="../css/theme_print.css" rel="stylesheet" type="text/css" media="all">

	<%
	}
	%>
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
<!-- -------####################################################### รายงานสินค้าคงคลัง  #################################################################------ -->	
	<div class="content_head"  >
			<Strong>รายงานสินค้าคงคลัง </Strong>
	</div>
	<table class="tb" >
		<tbody>
			<tr align="center" class="txt_bold">
				<th valign="top" align="center" width="16%">รหัสอะไหล่</th>
				<th valign="top" align="center" width="9%">กลุ่ม</th>
				<th valign="top" align="center" width="9%">ชนิด</th>
				<th valign="top" align="center" width="9%">ชนิดย่อย</th>
				<th valign="top" align="center" width="28%">Description</th>
				<th valign="top" align="center" width="10%">Fit to</th>
				<th valign="top" align="center" width="5%">	Units</th>
				<th valign="top" align="center" width="5%">Qty</th>
	<!-- 		<th valign="top" align="center" width="80">Moq</th>
				<th valign="top" align="center" width="80">Mor</th> -->
				<!-- <th valign="top" align="center" width="7%">Cost</th> แก้ไขวันที่  28-11-2556 -->
				<th valign="top" align="center" width="7%">Price(฿)</th>
	
			</tr>
			
			<%
			Iterator iteMas = PartMaster.selectWith_reportPart(paramsList).iterator(); 
			String total = "0";
			String total_mor = "0";
			while(iteMas.hasNext()){
				has = true;
				PartMaster entity = (PartMaster) iteMas.next();
				total = Money.add(total, "1");
				if(DBUtility.getInteger(entity.getMor()) >= DBUtility.getInteger(entity.getQty())){
					total_mor = Money.add(total_mor, "1");
				}
				String des_unit = PartMaster.SelectUnitDesc(entity.getPn());//Units
			%>
			
			<tr valign="top">
				<td align="Left" style='mso-number-format:"\@"'><%=entity.getPn()%></td>
				<td align="Left" style='mso-number-format:"\@"'><%=PartGroups.select(entity.getGroup_id()).getGroup_name_th().trim()%></td>
				<td align="left" style='mso-number-format:"\@"'><%=PartCategories.select(entity.getCat_id(), entity.getGroup_id()).getcat_name_short().trim()%></td>
				<td align="left" style='mso-number-format:"\@"'><%=PartCategoriesSub.select(entity.getSub_cat_id(), entity.getCat_id(), entity.getGroup_id()).getSub_cat_name_th().trim()%></td>
				<td align="Left"  style='word-wrap:break-word;mso-number-format:"\@"'><%=entity.getDescription()%></td>
				<td align="Left"  style='mso-number-format:"\@"'><%=entity.getFit_to()%></td>
				<td align="left"style='mso-number-format:"\@"'>	<%=UnitType.selectName(des_unit)%></td>
				<td align="right" style='mso-number-format:"0"'><%=Money.moneyInteger(entity.getQty())%></td>
				
			<%-- 	<td align="right"><%=Money.moneyInteger(entity.getMoq())%></td>
				<td align="right"><%=Money.moneyInteger(entity.getMor())%></td> --%>
				<%-- <td align="right" ><%=(entity.getCost().length()>0)?Money.money(entity.getCost()):Money.money("0")%></td> แก้ไขวันที่  28-11-2556 --%>
				
				<td align="right" style='mso-number-format:"\#\,\#\#0\.00"' ><%=(entity.getPrice().length()>0)?Money.money(entity.getPrice()):Money.money("0.00")%></td>
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
		<table  align="right"  class="txt_18">
				<tr>
					<td colspan="9" align="right" >					
					<strong>รายการอะไหล่ทั้งหมด </strong> : <%=Money.moneyInteger(total)%> รายการ
					</td>
				</tr>
		</table>
<!-- -------########################################################################################################################------ -->		
	<%
	}else
		if (report_type.equalsIgnoreCase(ReportUtils.PART_STOCK_COST)) {
			%>
		<!-- -------####################################################### รายงานสินค้าคงคลัง  COST #################################################################------ -->	
			<div class="content_head"  >
					<Strong>รายงานสินค้าคงคลัง </Strong>
			</div>
			<table class="tb" >
				<tbody>
					<tr align="center" class="txt_bold">
						<th valign="top" align="center" width="16%">รหัสอะไหล่</th>
						<th valign="top" align="center" width="9%">กลุ่ม</th>
						<th valign="top" align="center" width="9%">ชนิด</th>
						<th valign="top" align="center" width="9%">ชนิดย่อย</th>
						<th valign="top" align="center" width="28%">Description</th>
						<th valign="top" align="center" width="10%">Fit to</th>
						<th valign="top" align="center" width="5%">Units</th>
						<th valign="top" align="center" width="5%">Qty</th>
			<!-- 			<th valign="top" align="center" width="80">Moq</th>
						<th valign="top" align="center" width="80">Mor</th> -->
						<th valign="top" align="center" width="7%">Cost(฿)</th><!-- แก้ไขวันที่  28-11-2556 -->
						<th valign="top" align="center" width="7%">Price(฿)</th>
			
					</tr>
					
					<%
					Iterator iteMas = PartMaster.selectWith_reportPart(paramsList).iterator(); 
					String total = "0";
					String total_mor = "0";
					while(iteMas.hasNext()){
						has = true;
						PartMaster entity = (PartMaster) iteMas.next();
						total = Money.add(total, "1");
						if(DBUtility.getInteger(entity.getMor()) >= DBUtility.getInteger(entity.getQty())){
							total_mor = Money.add(total_mor, "1");
						}
						String des_unit = PartMaster.SelectUnitDesc(entity.getPn());//Units
					%>
					
					<tr valign="top">
						<td align="Left" style='mso-number-format:"\@"'><%=entity.getPn()%></td>
						<td align="Left" style='mso-number-format:"\@"'><%=PartGroups.select(entity.getGroup_id()).getGroup_name_th().trim()%></td>
						<td align="left" style='mso-number-format:"\@"'><%=PartCategories.select(entity.getCat_id(), entity.getGroup_id()).getcat_name_short().trim()%></td>
						<td align="left" style='mso-number-format:"\@"'><%=PartCategoriesSub.select(entity.getSub_cat_id(), entity.getCat_id(), entity.getGroup_id()).getSub_cat_name_th().trim()%></td>
						<td align="Left"  style='word-wrap:break-word;mso-number-format:"\@"'><%=entity.getDescription()%></td>
						<td align="Left"  style='mso-number-format:"\@"'><%=entity.getFit_to()%></td>
						<td align="left"style='mso-number-format:"\@"'>	<%=UnitType.selectName(des_unit)%></td>
						<td align="right" style='mso-number-format:"0"'><%=Money.moneyInteger(entity.getQty())%></td>
						<%-- <td align="right"><%=Money.moneyInteger(entity.getMoq())%></td>
						<td align="right"><%=Money.moneyInteger(entity.getMor())%></td> --%>
						<td align="right" style='mso-number-format:"\#\,\#\#0\.00"' ><%=(entity.getCost().length()>0)?Money.money(entity.getCost()):Money.money("0")%></td><!-- แก้ไขวันที่  28-11-2556  -->
						<td align="right" style='mso-number-format:"\#\,\#\#0\.00"' ><%=(entity.getPrice().length()>0)?Money.money(entity.getPrice()):Money.money("0.00")%></td>
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
				<table  align="right"  class="txt_18">
						<tr>
							<td colspan="9" align="right" >					
							<strong>รายการอะไหล่ทั้งหมด </strong> : <%=Money.moneyInteger(total)%> รายการ
							</td>
						</tr>
				</table>
<!-- -------########################################################################################################################------ -->		
	
	<%
	} else
		if (report_type.equalsIgnoreCase(ReportUtils.PART_MOR)) {
	%>
	<center>
	
<!-- -------###################################################### รายงานสินค้าเหลือน้อย   ##################################################################------ -->
	<div class="content_head"  >
			<Strong>รายงานสินค้าเหลือน้อย</Strong>
	</div>
	<table class="tb" style="width: 100%;">
		<tbody>
				<tr align="center" class="txt_bold">
				<th valign="top" align="center" width="15%">รหัสอะไหล่</th>
				<th valign="top" align="center" width="9%">กลุ่ม</th>
				<th valign="top" align="center" width="9%">ชนิด</th>
				<th valign="top" align="center" width="9%">ชนิดย่อย</th>
				<th valign="top" align="center" width="25%">Description</th>
				<th valign="top" align="center" width="16%">Fit to</th>
				<th valign="top" align="center" width="5%">	Units</th>
				<th valign="top" align="center" width="7%">Qty</th>
				<th valign="top" align="center" width="9%">Mor</th> 
			</tr>
			<%
			Iterator iteMas = PartMaster.selectMOR(paramsList).iterator();
			String total = "0";
			while(iteMas.hasNext()){
				has = true;
				total = Money.add(total, "1");
				PartMaster entity = (PartMaster) iteMas.next();
				String des_unit = PartMaster.SelectUnitDesc(entity.getPn());//Units
			%>
			<tr valign="top">
				<td align="Left" style='mso-number-format:"\@"'><%=entity.getPn()%></td>
				<td align="Left" style='mso-number-format:"\@"'><%=PartGroups.select(entity.getGroup_id()).getGroup_name_th().trim()%></td>
				<td align="left" style='mso-number-format:"\@"'><%=PartCategories.select(entity.getCat_id(), entity.getGroup_id()).getcat_name_short().trim()%></td>
				<td align="left" style='mso-number-format:"\@"'><%=PartCategoriesSub.select(entity.getSub_cat_id(), entity.getCat_id(), entity.getGroup_id()).getSub_cat_name_th().trim()%></td>
				<td align="Left" style='word-wrap:break-word;mso-number-format:"\@"'><%=entity.getDescription()%></td>
				<td align="Left" style='mso-number-format:"\@"'><%=entity.getFit_to()%></td>
				<td align="left" style='mso-number-format:"\@"'><%=UnitType.selectName(des_unit)%></td>
				<td align="right" style='mso-number-format:"0"'><%=Money.moneyInteger(entity.getQty())%></td>
				<td align="right" style='mso-number-format:"0"'><%=Money.moneyInteger(entity.getMor())%></td>
		<%-- 	<td align="right" ><%=Money.money(entity.getPrice())%></td>
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
	<table  align="right"  class="txt_18">
				<tr>
					<td colspan="9" align="right" >
					<strong>รายการสินค้าเหลือน้อยทั้งหมด </strong> : <%=Money.moneyInteger(total)%> รายการ
					</td>
				</tr>
	</table>
<!-- -------########################################################################################################################------ -->	
	<%}
	if (report_type.equalsIgnoreCase(ReportUtils.PART_OUT)) {
	%>
<!-- -------############################################################ รายงานการเบิกสินค้า   ############################################################------ -->
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
				<th valign="top" align="center" width="5%">Job ID</th>
				<th valign="top" align="center" width="15%">Pn</th>
				<th valign="top" align="center" width="20%">Description</th>
				<th valign="top" align="center" width="10%">Sn</th>
				<th valign="top" align="center" width="5%">	Units</th>
				<th valign="top" align="center" width="5%">Draw Qty</th>
<!-- 			<th valign="top" align="center" width="10%">Draw Price</th>
				<th valign="top" align="center" width="10%">Draw Discount</th> -->
				<th valign="top" align="center" width="15%">Draw By</th>
				<th valign="top" align="center" width="15%">Draw Date</th>
			</tr>
			<%
			Iterator iteMas = PartLotControl.report(paramsList).iterator();
			String total = "0";
			while(iteMas.hasNext()){
				has = true;
				PartLotControl entity = (PartLotControl) iteMas.next();
				String des_unit = PartMaster.SelectUnitDesc(entity.getPn());//Units
				total = Money.add(total, "1");
			%>
			<tr >
				<td style='mso-number-format:"0"' align="center"><%=entity.getJob_id()%></td>
				<td style='mso-number-format:"\@"' align="left"><%=entity.getPn()%></td>
				<td style='mso-number-format:"\@"' align="left"><%=entity.getUIdescription() %></td>
				<td style='mso-number-format:"\@"' align="left"><%=entity.getSn()%></td>
				<td style='mso-number-format:"\@"' align="left"><%=UnitType.selectName(des_unit)%></td>
				<td style='mso-number-format:"0"'  align="right"><%=Money.moneyInteger(entity.getDraw_qty())%></td>
				
		   <%-- <td align="right"><%=Money.money(entity.getDraw_price())%></td>
				<td align="right"><%=Money.moneyInteger(entity.getDraw_discount())%></td> --%>
				<td style='mso-number-format:"\@"' align="left"><%=Personal.selectOnlyPerson(entity.getDraw_by()).getName().trim()%></td>
				<td style='mso-number-format:"Short Date"' align="center"><%=WebUtils.getDateValue(entity.getDraw_date()) %></td>
			</tr>
			<%
			}
			
			if(has == false){
			
			%>
			<tr>
				<td align="center"  colspan="8">-- ไม่พบข้อมูล ---</td>
			
			</tr>
			<% } %>
		</tbody>
	</table>
	<table  align="right"  class="txt_18">
				<tr>
					<td colspan="8" align="right" >					
					<strong>รายงานการเบิกสินค้าทั้งหมด </strong> : <%=Money.moneyInteger(total)%> รายการ
					</td>
				</tr>
	</table>
<!-- -------########################################################################################################################------ -->
	<%} 
	if (report_type.equalsIgnoreCase(ReportUtils.PART_BOR)) {
	%>
<!-- -------##################################################### รายงานการยืมสินค้า   ###################################################################------ -->
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
				<th valign="top" align="center" width="12%">Pn</th>
				<th valign="top" align="center" width="20%">Description</th>
				<th valign="top" align="center" width="10%">Sn</th>
				<th valign="top" align="center" width="5%">Units</th>
				<th valign="top" align="center" width="5%">Borrow Qty</th>
				<th valign="top" align="center" width="5%">Return Qty</th>
				<!-- <th valign="top" align="center" width="5%">Scrap Qty</th> -->
				<th valign="top" align="center" width="10%">Create Date</th>
				<th valign="top" align="center" width="10%">Return Date</th>	
				<th valign="top" align="center" width="5%">Status</th> 
				<th valign="top" align="center" width="10%">Borrow By</th>
				<th valign="top" align="center" width="13%">Note</th> 
				
			</tr>
			<%
			Iterator iteMas = PartBorrow.report_bor(paramsList).iterator();
			String total = "0";
			String status = "";
			while(iteMas.hasNext()){
				has = true;
				PartBorrow entity = (PartBorrow) iteMas.next();
				total = Money.add(total, "1");
				
				if(entity.getStatus().equalsIgnoreCase("0")){
					status = "คืนแล้ว";
				}else if(entity.getStatus().equalsIgnoreCase("1")){
					status = "ยืม";
				}
				String des_unit = PartMaster.SelectUnitDesc(entity.getPn());//Units
			%>
			<tr>
				<%-- <td align="center" ><%=entity.getRun()%></td> --%>
				<td align="Left" style='mso-number-format:"\@"'><%=entity.getPn()%></td>
				<td align="Left" style='mso-number-format:"\@"'><%=entity.getUIDescription()%></td>
				<td align="Left" style='mso-number-format:"\@"'><%=entity.getSn()%></td>
				<td align="left" style='mso-number-format:"\@"'><%=UnitType.selectName(des_unit)%></td>
				<td align="right" style='mso-number-format:"0"'><%=entity.getQty()%></td>
				<td align="right" style='mso-number-format:"0"'><%=entity.getReturn_qty()%></td>
				<%-- <td align="right"><%=entity.getScrap_qty()%></td> --%>
				<td align="center" style='mso-number-format:"Short Date"'><%=WebUtils.getDateValue(entity.getCreate_date())%></td>
				<td align="center" style='mso-number-format:"Short Date"'><%=WebUtils.getDateValue(entity.getReturn_date())%></td> 
				<td align="center" style='mso-number-format:"\@"'><%=status%></td>
				<td align="left" style='mso-number-format:"\@"'><%=Personal.selectOnlyPerson(entity.getBorrow_by()).getName().trim()%></td>
				<td align="left" style='mso-number-format:"\@"'><%=entity.getNote()%></td>
			
			</tr>
			<%
			}
			if(has == false){
				
			%>
				<tr>
					<td align="center"  colspan="11">-- ไม่พบข้อมูล --</td>
				
				</tr>
				<% } %>
			
		</tbody>
	</table>
	<table  align="right"  class="txt_18">
				<tr>
					<td colspan="11" align="right" >					
					<strong>รายงานการยืมสินค้าทั้งหมด </strong> : <%=Money.moneyInteger(total)%> รายการ
					</td>
				</tr>
	</table>
<!-- -------########################################################################################################################------ -->
	
	<%}%>
</center>
	<%
	if (report_type.equalsIgnoreCase(ReportUtils.PART_ADD)) {
	%>
	<center>
	
<!-- -------########################################################################################################################------ -->
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
			
				<th valign="top" align="center" width="10%">Create Date</th>	
				<th valign="top" align="center" width="10%">po</th>
				<th valign="top" align="center" width="10%">pn</th>
				<th valign="top" align="center" width="20%">Description</th> <!-- เพิ่ม -->
				<th valign="top" align="center" width="12%">sn</th>
				<th valign="top" align="center" width="5%">Units</th>							
				<th valign="top" align="center" width="5%">Lot Qty</th>		
				<th valign="top" align="center" width="8%">Lot Price(฿)</th>		
				<th valign="top" align="center" width="15%">Note</th>
				<th valign="top" align="center" width="10%">Receive By</th>
				
			</tr>
			<%
			Iterator iteMas = PartLot.report_add(paramsList).iterator();
			String total = "0";
			while(iteMas.hasNext()){
				has = true;
				PartLot entity = (PartLot) iteMas.next();
				total = Money.add(total,"1");
				String des_unit = PartMaster.SelectUnitDesc(entity.getPn());//Units
			%>
			<tr align="center">							
				<td align="center" style='mso-number-format:"Short Date"'><%=WebUtils.getDateValue(entity.getCreate_date()) %></td>	
				<td align="center" style='mso-number-format:"\@"' ><%=entity.getPo() %></td>
				<td align="left" style='mso-number-format:"\@"' ><%=entity.getPn() %></td>
				<td align="left" style='mso-number-format:"\@"' ><%=entity.getUIdescription() %></td>
				<td align="left" style='mso-number-format:"\@"' ><%=entity.getSn() %></td>
				<td align="left" style='mso-number-format:"\@"'>	<%=UnitType.selectName(des_unit)%></td>
				<td align="right" style='mso-number-format:"0"'><%=Money.moneyInteger(entity.getLot_qty())%></td>
				
				<td align="right" style='mso-number-format:"\#\,\#\#0\.00"' ><%=(entity.getLot_price().length()>0 && !(entity.getLot_price().equalsIgnoreCase("0")|| entity.getLot_price().equalsIgnoreCase("0.00")))?Money.money(entity.getLot_price())+"":"0.00"%></td>
				
				<td align="left" style='mso-number-format:"\@"'><%=entity.getNote()%></td>
				<td align="left" style='mso-number-format:"\@"'><%=entity.getUIreceive()%></td>
			</tr>
			<%
			}
			if(has == false){
				
				%>
					<tr>
						<td align="center"  colspan="10">-- ไม่พบข้อมูล--</td>
					
					</tr>
			<% } %>
			
		</tbody>
	</table>
	<table  align="right"  class="txt_18">
				<tr>
					<td colspan="10" align="right" >					
					<strong>รายงานการนำเข้าสินค้าทั้งหมด </strong> : <%=Money.moneyInteger(total)%> รายการ
					</td>
				</tr>
	</table>
<!-- -------########################################################################################################################------ -->
	<%}	if (report_type.equalsIgnoreCase(ReportUtils.STOCK_CARD)) {
	%>
<!-- -------########################################################################################################################------ -->
	     <center>
	<div class="content_head"  >
			<Strong>รายงาน Stock Card</Strong>
			<br/>
			<Strong>
				<%=word %>
			</Strong>
	</div>
	<table class="tb" style="width: 100%;">
		<tbody>
			<tr align="center" >
				<th valign="top" align="center" width="15%" rowspan="2">PN	</th>
				<th valign="top" align="center" width="35%" rowspan="2">Description</th>
				<th valign="top" align="center" width="35%" colspan="5">จำนวน  </th>
				<th valign="top" align="center" width="15%" rowspan="2">Status</th>
			</tr>
			<tr>
				<th valign="top" align="center" width="7%">ยอดปิดเดิม</th>
				<th valign="top" align="center" width="7%">รับ</th>
				<th valign="top" align="center" width="7%">ขาย</th>
				<th valign="top" align="center" width="7%">คงเหลือ</th>
				<th valign="top" align="center" width="7%">ยอดปิดใหม่ </th>
			</tr>
<%
			List<CheckStockReportBean> list = CheckStockHDTS.ReportStockCard(Integer.parseInt(check_id));
			Iterator<CheckStockReportBean> itr = list.iterator();
			if(!list.isEmpty()){
				while(itr.hasNext()){
					CheckStockReportBean entity = (CheckStockReportBean) itr.next();
					int result = 0;
					if(entity.getIn_stock().length()>0 && entity.getOut_stock().length()>0 ){
						result = Integer.parseInt(entity.getIn_stock()) - Integer.parseInt(entity.getOut_stock());
					}else if( entity.getIn_stock().length()>0 ){
						result = Integer.parseInt(entity.getIn_stock());
					}
%>	
			<tr>
				<td style='mso-number-format:"\@"' align="left" ><%=entity.getPn() %></td>
				<td style='mso-number-format:"\@"' align="left" ><%=entity.getDescription() %></td>
<%
					if( entity.getStatus_stock().equalsIgnoreCase("20") ){
%>				
				<td style='mso-number-format:"\@"' align="center" ><%=( entity.getQty_stock_new().length()>0 && ! entity.getQty_stock_new().equalsIgnoreCase("0") )?entity.getQty_stock_new()+"":"-" %></td>
<%
					}else{
%>		
				<td style='mso-number-format:"\@"' align="center" >-</td>
				<td style='mso-number-format:"\@"' align="center" ><%=( entity.getQty_stock_old().length()>0 && ! entity.getQty_stock_old().equalsIgnoreCase("0") )?entity.getQty_stock_old()+"":"-" %></td>
<%
					}
%>
				<td style='mso-number-format:"\@"' align="center" ><%=(entity.getIn_stock().length()>0 && ! entity.getIn_stock().equalsIgnoreCase("0"))?entity.getIn_stock()+"":"-" %></td>
				<td style='mso-number-format:"\@"' align="center" ><%=(entity.getOut_stock().length()>0 && ! entity.getIn_stock().equalsIgnoreCase("0"))?entity.getOut_stock()+"":"-" %></td>
				<td style='mso-number-format:"\@"' align="center" ><%=(result>0)?result+"":"-"%></td>
<%
					if( entity.getStatus().equalsIgnoreCase("20") ){
%>				
				<td style='mso-number-format:"\@"' align="center" ><%=( entity.getQty_new().length()>0 && ! entity.getQty_new().equalsIgnoreCase("0") )?entity.getQty_new()+"":"-" %></td>
<%
					}else{
%>		
				<td style='mso-number-format:"\@"' align="center" ><%=( entity.getQty_old().length()>0 && ! entity.getQty_old().equalsIgnoreCase("0"))?entity.getQty_old()+"":"-" %></td>
<%
					}
					if( entity.getCarry_flag().equalsIgnoreCase("1") ){
%>
				<td style='mso-number-format:"\@"' align="center" ><%=CheckStockTS.status("30") %></td>
<%
					}else{
%>				
				<td style='mso-number-format:"\@"' align="center" ><%=CheckStockTS.status(entity.getStatus()) %></td>
<%
					}
%>
			</tr>
<%
				}
			}else{
%>		
<%
			}
%>
		</tbody>
	</table>
</center>	
<!-- -------########################################################################################################################------ -->	
	<%}
	 no = null;
	%>
</center>		
</body>
</html>