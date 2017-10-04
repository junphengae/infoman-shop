<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<%
	String vendor_id = request.getParameter("vendor_id"); 
	
	Vendor entity = Vendor.selectVendor(vendor_id.trim());	
	
%>
<div>
	<form id="vendorEditForm" action="" method="post" style="margin: 0;padding: 0;">
	<input type="hidden" name="update_by" id="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	<input type="hidden" name="vendor_id" id="vendor_id" value="<%=entity.getVendor_id() %>">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="485px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>ข้อมูลตัวแทนจำหน่าย</h3></td></tr>
			<tr>
				<td align="left" width="25%"><label>ชื่อตัวแทนจำหน่าย</label></td>
				<td align="left" width="75%">: <%=entity.getVendor_name()%></td>
			</tr>
		
			<tr>
				<td><label>โทรศัพท์</label></td>
				<td>: <%=entity.getVendor_phone()%></td>
			</tr>
			<tr>
				<td><label>แฟกซ์</label></td>
				<td>: <%=entity.getVendor_fax()%></td>
			</tr>
			<tr>
				<td><label>ที่อยู่</label></td>
				<td>: <%=entity.getVendor_address()%></td>
			</tr>
			<tr>
				<td valign="top"><label>Email</label></td>
				<td valign="top">: <%=entity.getVendor_email()%></td>
			</tr>
			<tr>
				<td><label>ผู้ติดต่อ</label></td>
				<td>: <%=entity.getVendor_contact()%></td>
			</tr>
			<tr>
				<td><label>เงื่อนไขการจัดส่ง</label></td>
				<td>: <%=entity.getVendor_condition()%></td>
			</tr>
			<tr>
				<td><label>เครดิต</label></td>
				<td>: <%=entity.getVendor_credit()%></td>
			</tr>
			<tr>
				<td><label>ประเภทการขนส่ง</label></td>
				<td>: 
					<%=entity.getVendor_ship()%>
					
				</td>
			</tr>
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					
					<input type="reset" onclick="tb_remove();" value="ปิด" class="btn_box">
				</td>
			</tr>
		</tbody>
	</table>
	<div class="msg_error" id="vendor_msg_error"></div>
	</form>

</div>