<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%
Customer entity = new Customer();
WebUtils.bindReqToEntity(entity, request);
Customer.select(entity);
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

					<table class="s_auto" cellspacing="5" cellpadding="5">
						<tbody>
							<tr>
								<td width="40%"><label>ID CARD</label></td>
								<td width="60%">: <%=entity.getCus_id_card()%></td>
							</tr>
							<tr>
								<td><label>Name</label></td>
								<td>: <%=entity.getCus_name_th()%> <%=entity.getCus_surname_th()%></td>
							</tr>
							<tr>
								<td><label>Sex</label></td>
								<td>: <%=(entity.getCus_sex().equalsIgnoreCase("m"))?"Male":"Female"%></td>
							</tr>
							<tr>
								<td><label>Address</label></td>
								<td>: <%=entity.getCus_address()%></td>
							</tr>
							<tr>
								<td><label>Mobile</label></td>
								<td>: <%=entity.getCus_mobile()%></td>
							</tr>
							<tr>
								<td><label>Phone</label></td>
								<td>: <%=entity.getCus_phone()%></td>
							</tr>
							<tr>
								<td><label>Email</label></td>
								<td>: <%=entity.getCus_email()%></td>
							</tr>
							<tr>
								<td><label>Birthdate</label></td>
								<td>: <%=WebUtils.getDateValue(entity.getCus_birthdate())%></td>
							</tr>
							<tr>
								<td colspan="2" height="30" align="center" valign="bottom">
									<button type="button" class="btn_box" title="Close" onclick="tb_remove();">Close</button>
								</td>
							</tr>
						</tbody>
					</table>
					
				