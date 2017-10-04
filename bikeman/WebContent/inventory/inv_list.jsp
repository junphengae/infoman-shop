<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.security.SecurityUser"%>
<%@page import="java.util.Iterator"%> 
<%@page import="java.util.ArrayList"%>
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

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ค้นหาคลังสินค้า</title>
<%
List paramList = new ArrayList();

String keyword = WebUtils.getReqString(request, "keyword");
String group_id = WebUtils.getReqString(request, "group_id");
String cat_id = WebUtils.getReqString(request, "cat_id");

paramList.add(new String[]{"keyword",keyword});
paramList.add(new String[]{"group_id",group_id});
paramList.add(new String[]{"cat_id",cat_id});

session.setAttribute("INVT_SEARCH", paramList);

String page_ = WebUtils.getReqString(request, "page");
PageControl ctrl = new PageControl();
ctrl.setLine_per_page(20);

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("INVT_PAGE", page_);
}

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("INVT_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("INVT_PAGE")));
}

List list = InventoryMaster.selectWithCTRL(ctrl, paramList);
%>

<script type="text/javascript">
$(function(){
	if ($('#group_id').val() != '') {
		$.post('../GetCat',{'group_id': $('#group_id').val(),'action':'get_cat_th'}, function(resData){
			if (resData.status == 'success') {
				var options = '<option value="">--- เลือกชนิด ---</option>';
                var j = resData.cat;
                var value = '<%=cat_id%>';
	            for (var i = 0; i < j.length; i++) {
	            	var selected = '';
	            	if (j[i].cat_id == value) {
	            		selected = ' selected';
					}
	                options += '<option value="' + j[i].cat_id + '"' + selected + '>' + j[i].cat_name_th + '</option>';
	            }
             	$('#cat_id').html(options);
			} else {
				alert(resData.message);
			}
        },'json');
	}
	
	$('#group_id').change(function(){
		ajax_load();
		$.post('../GetCat',{'group_id': $(this).val(),'action':'get_cat_th'}, function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				var options = '<option value="">--- เลือกชนิด ---</option>';
                var j = resData.cat;
	            for (var i = 0; i < j.length; i++) {
	                options += '<option value="' + j[i].cat_id + '">' + j[i].cat_name_th + '</option>';
	            }
             	$('#cat_id').html(options);
			} else {
				alert(resData.message);
			}
        },'json');
		
		$('#search_page').submit();
	});
	
	
});
</script>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">ค้นหาคลังสินค้า</div>
				<div class="right">
					<button class="btn_box btn_add" onclick="window.location='material_add.jsp';">สร้างรายการสินค้า</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					<form action="inv_list.jsp" id="search_page" method="get">
						คำค้น: 
						<input type="text" class="s150 txt_box" name="keyword" value="<%=keyword%>" autocomplete="off">  
						กลุ่ม:
						<bmp:ComboBox name="group_id" styleClass="txt_box s120"  validateTxt="เลือกกลุ่ม!" listData="<%=Group.ddl_th()%>" value="<%=group_id%>">
							<bmp:option value="" text="--- เลือกกลุ่ม ---"></bmp:option>
						</bmp:ComboBox>
						ชนิด: 
						<bmp:ComboBox name="cat_id" styleClass="txt_box s120 aaa" validateTxt="เลือกชนิด!" value="<%=cat_id%>">
							<bmp:option value="" text="--- เลือกชนิด ---"></bmp:option>
						</bmp:ComboBox>	
						<input type="submit" name="submit" value="ค้นหา" class="btn_box btn_search">
						<input type="button" name="reset" value="ล้าง" class="btn_box s50 m_left5" onclick="clear_form(this.form);">
						<input type="hidden" name="action" value="search">
						
					</form>
				</div>
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"inv_list.jsp",paramList)%></div>
				<div class="clear"></div>
				
				<div class="dot_line"></div>

				<table class="bg-image s_auto">
					<thead>
						<tr>
							<th valign="top" align="center" width="15%">กลุ่ม</th>
							<th valign="top" align="center" width="15%">รหัสสินค้า</th>
							<th valign="top" align="center" width="30%">รายการสินค้่า</th>
							<th valign="top" align="center" width="10%">หน่วยกลาง</th>
							<th valign="top" align="center" width="10%">สถานที่</th>
							<th valign="top" align="center" width="10%">คงคลัง</th>
							<th align="center" width="10%"></th>
						</tr>
					</thead>
					<tbody>
					<%
						boolean has = true;
						Iterator ite = list.iterator();
						while(ite.hasNext()) {
							InventoryMaster entity = (InventoryMaster) ite.next();
							has = false;
					%>
						<tr>
							<td><%=entity.getUIGroup_name() + ((entity.getUICat_name().length() > 0)?"-" + entity.getUICat_name():"") + ((entity.getUISub_cat_name().length() > 0)?"-" + entity.getUISub_cat_name():"")%></td>
							<td><%=entity.getMat_code() %></td>
							<td><%=entity.getDescription() %></td>
							<td align="center"><%=entity.getDes_unit()%></td>
							<td align="center"><%=entity.getUILocation()%></td>
							<td align="right"><%=entity.getBalance()%></td>
							<td align="left">
								<a class="btn_view" href="material_view.jsp?mat_code=<%=entity.getMat_code()%>" title="ข้อมูลสินค้าและอะไหล่"></a>
								<button class="btn_download" title="รับเข้า" onclick="window.location='inv_inlet.jsp?mat_code=<%=entity.getMat_code()%>';"></button>
								<button class="btn_upload" title="เบิกออก" onclick="window.location='inv_outlet.jsp?mat_code=<%=entity.getMat_code()%>';"></button>
								
							</td>
						</tr>
					<%
						}
						if(has){
					%>
						<tr><td colspan="7" align="center">ไม่พบรายการสินค้า!</td></tr>
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