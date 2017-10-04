<%@page import="com.bitmap.utils.report.Mobile"%>
<%@page import="com.bitmap.bean.parts.Vendor"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="java.util.Iterator"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="../js/jquery.min.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/clear_form.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>


<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายชื่อตัวแทนจำหน่าย</title>

<%
List params = new ArrayList();
String keyword = WebUtils.getReqString(request, "keyword");
String vendor_type = WebUtils.getReqString(request, "vendor_type");
String page_ = WebUtils.getReqString(request, "page");

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);

params.add(new String[]{"keyword",keyword});
params.add(new String[]{"vendor_type",vendor_type});

session.setAttribute("VD_SEARCH", params);

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("VD_SEARCH_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("VD_SEARCH_PAGE")));
}

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("VD_SEARCH_PAGE", page_);
}

List list = Vendor.selectWithCTRL(ctrl, params);
%>
</head>
<body>
<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายชื่อตัวแทนจำหน่าย</div>
				<div class="right">
					<button type="button" class="btn_box btn_confirm thickbox" lang="vendor_new.jsp?1=1" title="เพิ่มตัวแทนจำหน่าย">เพิ่มตัวแทนจำหน่าย</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="vendor_manage.jsp" id="search" method="get">
						ค้นหา: <input type="text" class="s150 txt_box" name="keyword" value="<%=keyword%>" autocomplete="off"> &nbsp;
						
						<input type="submit" name="submit" value="ค้นหา" class="btn_box s50 btn_confirm m_left5">
						<input type="button" name="reset" value="ล้าง" class="btn_box s50 m_left5" onclick="clear_form(this.form)">
						<input type="hidden" name="action" value="search">
					</form>
				</div>
				<div class="clear"></div>
				<div class="right txt_center">
					<%=PageControl.navigator_en(ctrl,"vendor_manage.jsp",params)%>
				</div>
				<div class="clear"></div>
				<div class="dot_line"></div>
				
				<table class="bg-image s_auto">
					<thead>
						<tr>
							<th valign="top" align="center" width="20%">ชื่อตัวแทน</th>
							<th valign="top" align="center" width="20%">ผู้ประสานงาน</th>
							<!-- <th valign="top" align="center" width="10%">ประเภท</th> -->
							<th valign="top" align="center" width="15%">โทรศัพท์</th>
							<th valign="top" align="center" width="15%">แฟกซ์</th>
							<th width="10%"></th>
						</tr>
					</thead>
					<tbody>
						<%
						boolean has = true;
						Iterator ite = list.iterator();
						while(ite.hasNext()) {
							Vendor entity = (Vendor) ite.next();
							has = false;
						%>
							<tr>
								<td><div class="thickbox" title="ตัวแทนจำหน่าย: <%=entity.getVendor_name()%>" lang="vendor_info.jsp?vendor_id=<%=entity.getVendor_id()%>"><%=entity.getVendor_name()%></div></td>
								<td><%=entity.getVendor_contact()%></td>
								<%-- <td align="center"><%=Vendor.type(entity.getVendor_type())%></td> --%>
								<td><%=entity.getVendor_phone()%></td>
								<td><%=entity.getVendor_fax()%></td>
								<td align="center">
									<button type="button" class="btn_box thickbox" title="แก้ไขตัวแทนจำหน่าย: <%=entity.getVendor_name()%>" lang="vendor_edit.jsp?vendor_id=<%=entity.getVendor_id()%>">แก้ไข</button>
								</td>
							</tr>
						<%}
						if(has){%>
							<tr><td colspan="7" align="center">-- ไม่พบข้อมูล --</td></tr>
						<%}%>
					</tbody>
				</table>
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>