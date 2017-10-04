
<%@page import="com.bmp.imgges.PartMasterBarcodeTS"%>
<%@page import="javax.swing.text.html.ImageView"%>
<%@page import="javax.swing.ImageIcon"%>
<%@page import="java.awt.Image"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.utils.SNCUtils"%>
<%@page import="com.bitmap.barcode.Barcode128"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<html>
<head>
<%	
	String pn = request.getParameter("pn"); 	
	PartMaster entity = new PartMaster(); 
	entity.setPn(pn);
	entity = PartMaster.select(entity);
	
	String fileName = pn;
	if (pn.indexOf("/") > -1){
		fileName = pn.replaceAll("/", "_");
	}
%>

<link type="text/css" rel="stylesheet" href="../css/barcode.css">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>PN: <%=pn%></title>
<script type="text/javascript">
function load(){
	setTimeout('window.print()',1000); 
	setTimeout('window.close()',2500);
}
</script>
</head>
<body onload="load();">
	<%
		Barcode128.genBarcode(WebUtils.getInitParameter(session, SNCUtils.IMG_PATH_BARCODE), entity.getPn(), fileName, 4);
	%>
	<div class="barcode">
		<div class="discription"><%=(entity.getDescription().length() < 25)?entity.getDescription():entity.getDescription().substring(0, 25)%></div>	
		<div class="barcode_img"> 		
		<img src="../DisplayImageBarcode?pn=<%=pn%>" >
		</div>		
		<div class="info">BikeMan Genuine Spare Part</div>
	</div>
	

</body>
</html>