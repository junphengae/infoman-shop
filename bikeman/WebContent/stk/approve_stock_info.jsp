<%@page import="com.bmp.parts.check.stock.CheckStockHDBean"%>
<%@page import="com.bmp.parts.check.stock.CheckStockHDTS"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.PartGroups"%>
<%@page import="com.bitmap.bean.parts.PartCategories"%>
<%@page import="com.bitmap.bean.parts.PartCategoriesSub"%>
<%@page import="com.bitmap.bean.hr.Division"%>
<%@page import="com.bitmap.bean.hr.Position"%>
<%@page import="com.bitmap.bean.hr.Department"%>
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
<link href="../css/barcode.css" rel="stylesheet" type="text/css" media="all"> 
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
	$(function(){
		$('#close_stock').click(function(){
			ajax_load();
			$.post('../checkStockServlet',{action:'close_stock',close_by:$('#close_by').val()}, function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location.reload();
				} else {
					alert(resData.message);
				}
	        },'json');
		});
		$('.btn_print').click(function(){
			$('#check_id').val($(this).attr('check_id'));
			$('#form_report').submit();
		});
		
	});
</script>

<title>Confirm Stock</title>
<%

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

List list = CheckStockHDTS.selectListApprove(ctrl);
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	<form id="form_report" action="../ReportUtilsServlet" target="_blank" method="post" onsubmit="return true;">
	<input type="hidden" name="type" value="check_stock_all">
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Confirm Stock</div>
					<div class="right">
					</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					
				</div>
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"approve_stock_info.jsp")%></div>
				<div class="clear"></div>
				
				<div class="dot_line"></div>
				<!-- <div class="scroll"> -->
				<table class="bg-image  s_auto breakword"><!-- เพิมbreakword มาเพื่อตัดคำ -->
					<thead>
						<tr>
							
							<th valign="top" align="center" width="14%" >Check ID</th>
							<th valign="top" align="center" width="14%">Status</th>
							<th valign="top" align="center" width="14%">Create Date</th>
							<th valign="top" align="center" width="14%">Check By</th>
							<th valign="top" align="center" width="14%">Approve Date</th>
							<th valign="top" align="center" width="14%">Approve By</th>
							<th valign="top" align="center" width="16%" ></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td colspan="10" style="padding: 0px 0px 0px 0px;" width="100%">
								<div class="scroll">
								<table class="bg-image"  style="border-collapse: collapse;" width="100%">
									<%
										boolean has = false;
										Iterator ite = list.iterator();
										while(ite.hasNext()) {
											CheckStockHDBean entity = (CheckStockHDBean) ite.next();
											has = true;
											Personal checkname = new Personal();
											checkname = Personal.selectOnlyPerson(entity.getCheck_by());
											Personal approvename = new Personal();
											approvename = Personal.selectOnlyPerson(entity.getApprove_by());
											
											
											
									%>
										<tr>
										
											<td align="center" valign="top" width="14%">
												<%=entity.getCheck_id()%>
											</td>
											<td align="center" valign="top" width="14%">
												<%=CheckStockHDTS.status(entity.getStatus())%>
											</td>
											<td align="center" valign="top" width="14%">
												<%=WebUtils.getDateValue(entity.getCheck_date())%>
											</td>
											<td align="center" valign="top" width="14%">
												<%=checkname.getPrefix() +" "+ checkname.getName() +" "+ checkname.getSurname()%>
											</td>
											<td align="center" valign="top" width="14%">
												<%=WebUtils.getDateValue(entity.getApprove_date())%>
											</td>
											<td align="center" valign="top" width="14%">
												<%=approvename.getPrefix() +" "+ approvename.getName() +" "+ approvename.getSurname()%>
											</td>
											<td align="center" valign="top" width="25%">
											<%if(entity.getStatus().equalsIgnoreCase("00")){ %>
												<input type="button" class="btn_box" title="Approve Stock" onclick="javascript: window.location='approve_stock.jsp?check_id=<%=entity.getCheck_id()%>';" value="ดู">
											<%}else if(!entity.getStatus().equalsIgnoreCase("00")){
											%>
												<button  type="button" class="btn_box  btn_confirm btn_print"  check_id="<%=entity.getCheck_id()%>">พิมพ์</button>
											<%} %>
											</td>								
										</tr>
									<%
										}
										if(has == false){
									%>	
										<tr>
											<td align="center" colspan="7"> --- ไม่พบรายการ ---</td>
										</tr>
									<%
										}
									%>
								</table>
								</div>	
							</td>		
						</tr>			
					</tbody>
				</table>
				<input type="hidden" name="check_id" id="check_id">
				</form>
				<!-- </div> -->
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>