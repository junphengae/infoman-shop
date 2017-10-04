<%@page import="com.bitmap.utils.report.Mobile"%>
<%@page import="com.bitmap.bean.branch.BranchMaster"%>
<%@page import="com.bitmap.security.SecurityUser"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/clear_form.js"></script>
<script src="../js/number.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.position.js"></script>
<script src="../js/ui/jquery.ui.autocomplete.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Branch</title>
<%
	List paramList = new ArrayList();

String keyword = WebUtils.getReqString(request, "keyword");


paramList.add(new String[]{"keyword",keyword});

session.setAttribute("PART_SEARCH", paramList);

String page_ = WebUtils.getReqString(request, "page");
PageControl ctrl = new PageControl();
ctrl.setLine_per_page(20);

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("PART_PAGE", page_);
}

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("PART_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("PART_PAGE")));
}

List list = BranchMaster.selectWithCTRL(ctrl, paramList);

%>

<script type="text/javascript">
function delete_branch(obj){
	var branch_id = $(obj).attr('branch_id');
	
	if (confirm('confirm delete Brand ?')) {
		ajax_load();
		$.post('../BranchManagement',{'branch_id': branch_id , 'action': 'delete_branch'},function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				//$('tr#order_by_id' + order_by_id).fadeOut(500).queue(function(){$(this).remove();$(this).dequeue();});
				window.location = "branch_manage.jsp";
			} else {
				alert(resData.message);
			}
		},'json');
	}
}
</script>
</head>
<body>
<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Branch Search</div>
					<div class="right">
						<button class="btn_box btn_add" onclick="window.location='branch_add.jsp';">Create New Branch</button>
						<!-- <button class="btn_box btn_update_master">Update จากสำนักงานใหญ่</button>  -->
					</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="branch_manage.jsp" id="search" method="get">
						Keyword: 
						<input type="text" class="s150 txt_box" name="keyword" value="<%=keyword%>" autocomplete="off">  
						<input type="submit" name="submit" value="Search" class="btn_box btn_confirm">
						<input type="button" name="reset" value="Reset" class="btn_box s50 m_left5" onclick="clear_form('#search');">
						<input type="hidden" name="action" value="search">
						
					</form>
				</div>
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"branch_manage.jsp",paramList)%></div>
				<div class="clear"></div>
				<div class="dot_line"></div>
				<table class="bg-image  s_auto breakword"><!-- เพิมbreakword มาเพื่อตัดคำ -->
					<thead>
						<tr align="center">
							<th valign="top"  width="10%">Branch Code</th>
							<th valign="top"  width="20%">Branch Name</th>
							<th valign="top"  width="13%">District</th>
							<th valign="top"  width="13%">Province</th>
							<th valign="top"  width="12%">Phone Number</th>
							
							<th valign="top" align="left" width="12%"></th>
						</tr>
					</thead>
					<tbody>
					<%
						boolean has = true;

						Iterator ite = list.iterator();
						while(ite.hasNext()) {
							BranchMaster entity = (BranchMaster) ite.next();
							has = false;
					%>
						<tr>
							<!--<td align="left" valign="top"> 
								<%//=entity.getBranch_id() %>
							</td>  -->
							<td align="center" valign="top">
								<%=entity.getBranch_code()%>
							</td>
							<td align="center" valign="top">
								<%=entity.getBranch_name()%>
							</td>
							<td align="left" valign="top">
								 <%=entity.getBranch_prefecture()%> 
							</td>
							<td align="left" valign="top">
								 <%=entity.getBranch_province()%>
							</td>
							<td align="left" valign="top">
							 	 <%=Mobile.mobile(entity.getBranch_phonenumber())%>
							</td >
							
							<td>
							<a class="btn_view" href="branch_info.jsp?branch_id=<%=entity.getBranch_id()%>" title="View Branch Information"></a>
							
							&nbsp;
							<input id="edit_Branch" class="btn_box thickbox" type="button" lang="branch_edit.jsp?branch_id=<%=entity.getBranch_id() %>&height=490&width=455" value="แก้ไข" title="Edit Branch" >
							<%-- &nbsp;
							<button class="btn_box" onclick="delete_branch(this);" branch_id="<%=entity.getBranch_id()%>">ลบ</button> --%>
							</td>
							
						</tr>
					<%} if(has){ %>
							<tr><td colspan="7" align="center">---- ไม่พบข้อมูลสาขา---- </td></tr>
					 <%
					 }
					 %>
					</tbody>
				</table>
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>