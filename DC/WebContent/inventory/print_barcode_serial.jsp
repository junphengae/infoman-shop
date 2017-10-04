<%@page import="com.bitmap.bean.inventory.InventoryMasterTempDetail"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterTemp"%>
<%@page import="com.bitmap.bean.util.ImagePathUtils"%>
<%@page import="com.bitmap.barcode.Barcode128"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%	
	String mat_code = WebUtils.getReqString(request, "mat_code");
	String serial = WebUtils.getReqString(request, "serial");
	InventoryMaster master = InventoryMaster.select(mat_code);
	
	String count = InventoryMasterTempDetail.countField(mat_code);
	int end = Integer.parseInt(count);
%>
<link type="text/css" rel="stylesheet" href="../css/barcode.css">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รหัสสินค้า <%=mat_code%> | Serial เลขที่ <%=serial%></title>
<script type="text/javascript">
function setPrint(){
	//setTimeout('window.print()',1500); setTimeout('window.close()',2000);
}
</script>
<style type="text/css">
body{
 	margin:0; 
	padding:0; 
}
</style>
</head>
<body onload="setPrint();" style="width: 1.5in;height: 0.6in;">
<%	
Barcode128.genBarcode(WebUtils.getInitParameter(session, "local_path_barcode"), master.getMat_code(), master.getMat_code(), 4);
Barcode128.genBarcode(WebUtils.getInitParameter(session, "local_path_barcode"), serial,serial,4);
 %>
	<div class="barcode">		
			<div class="center" style="font-size: 6px; margin: 0 auto;text-align: center;">	
				<div><img src="<%=ImagePathUtils.img_path%>/barcode/<%=master.getMat_code()%>.png" style="padding-top: 2px;"></div>
				<div style="clear: both;"></div>
				
			</div>
			<div style="clear: both;"></div>
	</div>
	
<%
		
		for(int i = 0;i<=end;i++ )
		{
	%>
	<div class="barcode">	
		<div class="center" style="font-size: 6px; margin: 0 auto;text-align: center;">
			<div><img src="<%=ImagePathUtils.img_path%>/barcode/<%=serial%>.png" style="padding-top: 2px;width: 120px;"></div>
			<div style="clear: both;"></div>
		</div>
		<div style="clear: both;"></div>
	</div>
<%} %>

</body>
</html>