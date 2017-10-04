<%@page import="java.util.Date"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="com.bitmap.webservice.WSLogUpdateTS"%>
<%@page import="com.bitmap.webservice.WSLogUpdateBean"%>
<%@page import="com.bitmap.security.SecurityUnit"%>
<%@page import="com.bitmap.security.SecuritySystem"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/index.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>BikeMan</title>
<script type="text/javascript">
	$(function(){
		$('.main_menu').click(function(){
			var position = $(this).position();
			var left = position.left + $(this).outerWidth() + 100;
			
			var $menuSelect = $('#menu_body_' + $(this).attr('lang'));
			$menuSelect.css({'left':left,'top':100});
			
			if ($menuSelect.css('display')=='none') {
				$menuSelect.slideDown();//fadeIn(500);
				$('.wrap_menu_body').not($menuSelect).css({'display':'none'});
			} else {
				$menuSelect.fadeOut(500);
			}
			$('.main_menu').removeClass('active');
		});
		
		$('*').mouseup(function(){
			$('.wrap_menu_body:visible').fadeOut(500);
		});
		
		
	});
	
	function setOnLoad(){
		setTimeout("window.location='index.jsp'",600000);
	}
</script>



</head>
<body <%if(!securProfile.isLogin()){%>onload="setOnLoad();"<%}%>>

<div class="wrap_all">
	<jsp:include page="index_header.jsp"></jsp:include>
	<%if(WebUtils.getReqString(request,"SYSTEM").length() > 0){session.setAttribute("SYSTEM",WebUtils.getReqString(request,"SYSTEM"));}%>
	<div class="wrap_body">
	<%
		if(securProfile.isLogin()){
			String stm = "";
			if(session.getAttribute("SYSTEM")!=null){
				stm = (String)session.getAttribute("SYSTEM");
			}
			Iterator sysIte = securProfile.getList().iterator();
			while (sysIte.hasNext()) {
				String active = "";
				SecuritySystem sys = (SecuritySystem) sysIte.next();
				if (stm.equalsIgnoreCase(sys.getSys_id())){
					active = " active";
				}
		%>
		<div class="main_menu <%=active%>" lang="<%=sys.getSys_id()%>"><%=sys.getSys_name()%>
			<div class="wrap_menu_body" id="menu_body_<%=sys.getSys_id()%>">
		<%
				Iterator unitIte = sys.getUIUnitList().iterator();
				while (unitIte.hasNext()) {
					SecurityUnit unit = (SecurityUnit) unitIte.next();
		%>
				<div class="menu" onclick="javascript: window.location='../<%=unit.getUnit_url()%>?SYSTEM=<%=sys.getSys_id()%>';"><a href="../<%=unit.getUnit_url()%>?SYSTEM=<%=sys.getSys_id()%>"><%=unit.getUnit_name()%></a></div>
		<%
				}
		%>
			</div>
		</div>
		<%	
			}
		}
	%>
		<div class="clear"></div>
		
	<% if(securProfile.getPersonal().getPer_id().equalsIgnoreCase("")){ %>
	
			<script type="text/javascript">

			$(function(){
				var $msg = $('.msg');
				var $user = $('#user_name');
				var $password = $('#password');
				$user.focus();
				$('#btnLogin').click(function(){
					login();
				});
				
				$password.keypress(function(e){
					if (e.keyCode == 13) {
						login();
					}
				});
				
				function login(){
					if ($user.val() == '') {
						$msg.text('Please insert User name!').show();
						$user.focus();
					} else if($password.val() == ''){
						$msg.text('Please insert Password!').show();
						$password.focus();
					} else {
						
						var sendData = $('#loginForm').serialize();
						ajax_load();
						$.post('../LoginServlet', sendData, function(data){
							ajax_remove();
							if (data.status == "success") {
								  //===== นัฐยาแก้เพื่ออัพเดทเว็บเซอร์วิส =========/
								 	 if (data.log == "updateWebService") {
										
										
										$msg.text('Login Success.').show().delay(300).queue(function(){window.location = 'index_ws_update.jsp'; $(this).dequeue();});
									}
									else{  
										
										$msg.text('Login Success.').show().delay(300).queue(function(){window.location = 'index.jsp'; $(this).dequeue();});
									}
								  //===================================//
							}
							else {
								$msg.text('User or Password invalid!').show();
								$password.val('').focus();
							}
						},'json');
					}
				}
			});
			</script>
		<div class="left" style="margin-top: 150px; margin-left: 35%;">
			<form id="loginForm" style="margin: 0;padding: 0;">
				<div class="s250 center txt_center" style="margin-bottom: 10px;"><h2 style="color:Black;">Login</h2></div>
				<div class="s250 center" style="margin-bottom: 5px;"><div class="s100 left" ><h3 style="color:Black;">Username</h3></div>
					<div class="s10 left"><h3 style="color:Black;">:</h3></div>
					<div class="s120 left"> 
						<input type="text" autocomplete="off" name="user_name" id="user_name" class="txt_box s120 input_focus" style="margin-top: 3px;text-align:left; " >
					</div>
						<div class="clear"></div>
				</div>
				<div class="s250 center" style="margin-bottom: 5px;">
					<div class="s100 left"><h3 style="color:Black;">Password</h3></div>
					<div class="s10 left"><h3 style="color:Black;">:</h3></div>
					<div class="s120 left">
						<input type="password" name="password" id="password" class="txt_box s120" style="margin-top: 3px;text-align:left; " >
					</div>
					<div class="clear" ></div>
				</div>
				<div class="s250 center" style="margin-bottom: 5px;"><div class="s70 left"></div><div class="s10 left"></div>
<%-- 					<div class="s120 left"><input type="hidden"  name="macid" id="macid" class="txt_box s120" value="<%=samesb%>"></div>
 --%>					<div class="clear"></div>
				</div>
				
				<div class="s250 center txt_center" style="margin-bottom: 10px; margin-top: 30px">
					<input type="button" id="btnLogin" value=" Login " class="btn_box btn_warn" style="font-size: 25px">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<!-- <input type="reset" onclick="tb_remove();" value="Cancel" class="btn_box" style="font-size: 25px"> -->
					<input type="hidden" name="action" value="chk_mac">
					<br/><br/>
					<div class="msg" style="color: #ff0000;"></div>
				</div>
				
			
			</form>
		</div>
	<%} %>
	</div>
	
	<jsp:include page="footer.jsp"></jsp:include>
	
</div>

</body>
</html>