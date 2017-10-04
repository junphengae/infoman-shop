<%@page import="com.bitmap.bean.parts.ServicePartDetail"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.security.SecurityUser"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>



<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Part List</title>
<%
ServicePartDetail entity = new ServicePartDetail();
WebUtils.bindReqToEntity(entity, request);
ServicePartDetail.select(entity);
String countnumber =ServicePartDetail.selectcount(entity.getId(),entity.getPn());
//System.out.println("countnumcer"+countnumber);
PartMaster pn = PartMaster.select(entity.getPn());

%>
	
	<div class="txt_center m_top20">
	<form action="">
	<center><Strong>  หมายเลขสินค้านี้มีอยู่แล้ว  <br /> เพิ่มสินค้าใหม่เพราะส่วนลดไม่เท่ากัน กด "เพิ่มสินค้าใหม่" <br /> ต้องการแก้ไขจำนวนเพิ่มเติม กด  "แก้ไขจำนวน" </Strong></center>
	<br />
	<a class="btn_box btn_add thickbox" title="เพิ่มสินค้า" lang="sale_part_select.jsp?pn=<%=entity.getPn()%>&id=<%=entity.getId()%>&width=580&height=300"  onclick="windows.open" value="เพิ่มสินค้าใหม่">เพิ่มสินค้าใหม่</a> 
	<%
	  if(countnumber.equalsIgnoreCase("0")){
	%>
	<a class="btn_box  thickbox" title="แก้ไขจำนวน" lang="sale_part_update_detail.jsp?id=<%=entity.getId()%>&number=<%=entity.getNumber()%>&width=420&height=230" >แก้ไขจำนวน</a>
	<%}else{ 
	////System.out.println("count numcer"+countnumber);
	%>	
	<a class="btn_box thickbox" title="แก้ไขจำนวน" lang="sale_part_update_detail_multi.jsp?id=<%=entity.getId()%>&number=<%=entity.getNumber()%>&width=900&height=300" >แก้ไขจำนวน</a>
	
		
	<%} %>
	
	</form>
	</div>
	<br />
	<%-- <div width="300">
	<fieldset>
	<legend>ข้อมูลหมายเลขสินค้า:<%=entity.getPn() %></legend>
	<form action="">
	<table width="100%">
	<tr>
	<th width="30%">ชื่อ</th><td><strong>:</strong> <%=pn.getDescription() %></td>
	</tr>
	<tr>
	<th width="30%">ราคา</th><td><strong>:</strong> <%=pn.getPrice() %></td>
	</tr>
	<tr>
	<th width="30%">สินค้าคงเหลือ</th><td><strong>:</strong> <%=pn.getQty() %></td>
	</tr>
	<tr>
	<th width="30%">จำนวน</th><td><strong>:</strong><%=entity.getQty() %></td>
	</tr>
	<tr>
	<th width="30%">สินค้าเบิกแล้ว</th><td><strong>:</strong><%=entity.getCutoff_qty() %></td>
	</tr>
	</table>
	</form>
	</fieldset>
	</div> --%>
