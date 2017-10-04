<%@page import="com.bitmap.bean.branch.Branch"%>
<%@page import="com.bitmap.bean.sale.Brands"%>
<%@page import="java.util.Map"%>
<%@page import="com.bitmap.bean.sale.Models"%>
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
<title>Models</title>
<%
	List paramList = new ArrayList();

String model1 = WebUtils.getReqString(request, "model1"); 
String brand1 = WebUtils.getReqString(request, "brand1");

paramList.add(new String[]{"brand1",brand1} );
paramList.add(new String[]{"model1",model1}); 

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

List list = Models.selectWithCTRL(ctrl, paramList);

%>
<script type="text/javascript">
function delete_brand(obj){
	var id = $(obj).attr('id');
	
	if (confirm('ยืนยันการลบข้อมูลรุ่นหรือไม่ ?')) {
		ajax_load();
		$.post('../ModelsManagement',{'id': id , 'action': 'delete_model'},function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				window.location = "models_manage.jsp";
			} else {
				alert(resData.message);
			}
		},'json');
	}
}

$(function(){
$('#brand1').change(function(){
	ajax_load();
	$.post('../ModelsManagement',{brand1: $(this).val(),action:'get_model_list'}, function(resData){
		ajax_remove();
		if (resData.status == 'success') {
			var options = '<option value="">--- เลือกรุ่น ---</option>';
            var j = resData.model;
            $.each(j , function (index , object){
            	 options += '<option value="' + object.model_id + '">' + object.model_name + '</option>';
            	 

            });
         	$('#model1').html(options);
		} else {
			alert(resData.message);
		}
    },'json');
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
				<div class="left">Models Search</div>
					<div class="right">
						<button class="btn_box btn_add" onclick="window.location='models_add.jsp';">Create New Models</button>
					</div>
				<div class="clear"></div>
			</div> 
			
			<div class="content_body">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="models_manage.jsp" id="search" method="get">
						<%-- Keyword: 
						<input type="text" class="s150 txt_box" name="keyword" value="<%=keyword%>" autocomplete="off">   --%>
						
						
						Brand:
						<bmp:ComboBox name="brand1" styleClass="txt_box s100 " listData="<%=Brands.BrandDropdown() %>" value="<%=brand1 %>" >
							<bmp:option value="" text="--- all ---"></bmp:option>
						</bmp:ComboBox>
						
						Model:
						<bmp:ComboBox name="model1" styleClass="txt_box s100"  listData="<%=Models.selectDDL(brand1)%>"  value="<%=model1 %>" >
							<bmp:option value="" text="--- all ---"></bmp:option>
						</bmp:ComboBox>
						<input type="submit" name="submit" value="Search" class="btn_box btn_confirm">
						<input type="button" name="reset" value="Reset" class="btn_box s50 m_left5" onclick="clear_form('#search');">
						<input type="hidden" name="action" value="search">
					</form>
				</div>
				<div class="clear"></div>
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"models_manage.jsp",paramList)%></div>
				<div class="clear"></div>
				
				<div class="dot_line"></div>
				
				<table class="bg-image  s_auto breakword"><!-- เพิมbreakword มาเพื่อตัดคำ -->
					<thead>
						<tr align="center">
							<th valign="top"  width="35%"><Strong>Brand Name</Strong></th>
							<th valign="top"  width="35%"><Strong>Model Name</Strong></th>
						<!-- 	<th valign="top"  width="6%"><Strong>Model Code</Strong></th> -->
							<th valign="top"  width="30%"></th>
							
					   </tr>
					</thead>
					<tbody>
					<%
						boolean has = false;

						Iterator ite = list.iterator();
						while(ite.hasNext()) {
							Models entity = (Models) ite.next();
							Map map = entity.getUImap();
							Brands brand =(Brands)map.get(Brands.tableName);
							
							has = true;
					%>
						<tr>
							<td align="left" valign="top">
								<%=brand.getBrand_name()%>
							</td>
							<td align="left" valign="top">
								<%=entity.getModel_name()%>
							</td>
							<%-- <td align="left" valign="top">
								<%=entity.getModel_id() %>
							</td> --%>
						
							<td align="center">
							<input id="edit_Models" class="btn_box thickbox" type="button" lang="models_edit.jsp?model_id=<%=entity.getModel_id() %>&brand_id=<%=entity.getBrand_id()%>&height=200&width=440" title="Update Model" value="แก้ไข" >
							<%-- <button class="btn_box" onclick="delete_brand(this);" id="<%=entity.getId()%>">ลบ</button>  --%>
							</td>
							
						</tr>
					<%}if(has == false){ %>
						<tr>
							<td align="center"  colspan="9">-- ไม่พบข้อมูล --</td>
	
						</tr> 
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