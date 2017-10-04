<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterTempDetail"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterTemp"%>
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
<script src="../js/loading.js"></script>
<script src="../js/clear_form.js"></script>
<script src="../js/number.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/popup.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Inventory</title>
<%
String mat_code = WebUtils.getReqString(request,"mat_code");
%>
<script type="text/javascript">
$(function(){
	$(".btn_del").click(function(){ 
		if(confirm("ต้องการลบข้อมูล ใช่หรือไม่?")){
			ajax_load();
			var data = {"id_detail":$(this).attr("id_detail"),"action":"del_matcode_detail"};
			$.post('../MaterialManage',data,function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					alert('ลบข้อมูลอะไหล่เรียบร้อยแล้ว');
					window.location.reload();
				} else {
					alert(resData.message);
				}
			},'json');
		}
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
				<div class="left">Detail Component [<%=InventoryMaster.selectOnlyDescrip(mat_code)%>]</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="right"><button type="button" class="btn_box btn_confirm" onclick="popup('inv_material_search.jsp?master_matcode=<%=mat_code%>');">เพิ่มอะไหล่</button></div>
				<div class="clear"></div>
				<fieldset class="fset">
					<legend>Detail Material</legend>
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th valign="top" align="center" width="10%">รหัสอะไหล่</th>
								<th valign="top" align="center" width="10%">ชื่ออะไหล่</th>
								<th align="center" width="10%"></th>
							</tr>
						</thead>
						<tbody>
							<%
							Iterator ite = InventoryMasterTempDetail.selectList(mat_code).iterator();
							while (ite.hasNext()){
								InventoryMasterTempDetail entity = (InventoryMasterTempDetail) ite.next();
							%>
								<tr>
									<td><%=entity.getMat_code()%></td>
									<td><%=entity.getUIdes()%></td>
									<td align="center"><button title="ลบ" class="btn_del" id_detail="<%=entity.getId_detail()%>"></button></td>
								</tr>
							<%} %>
						</tbody>
					</table>
				</fieldset>
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>