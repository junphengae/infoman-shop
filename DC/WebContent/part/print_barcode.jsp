
<%@page import="com.bitmap.utils.SNCUtils"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.barcode.Barcode128"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.parts.PartSerial"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<html>
<head>
<%	
	String pn = request.getParameter("pn");
	String serial = PartSerial.selectSN(pn);
	int sn = Integer.parseInt(serial); 
	int qty = Integer.parseInt(request.getParameter("qty")); 
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
		for (int i = 0; i < qty; i++) {
			System.out.println(entity.getPn() + "--" + (sn + i));
			Barcode128.genBarcode(WebUtils.getInitParameter(session, SNCUtils.IMG_PATH_BARCODE), entity.getPn() + "--" + (sn + i), fileName+ "--" + (sn + i), 4);
	%>
	<div class="barcode">
		<div class="discription"><%=(entity.getDescription().length() < 25)?entity.getDescription():entity.getDescription().substring(0, 25)%></div>
		<div class="barcode_img">
		<img src="../DisplayImageBarcode?pn=<%=entity.getPn() + "--" + (sn + i)%>" >
		</div>
		<div class="info">BikeMan Genuine Spare Part</div>
	</div>
	
	
	<%
		}
	%>

</body>
</html>