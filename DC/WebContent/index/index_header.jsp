
<%@page import="com.bitmap.bean.hr.Msg"%>
<%@page import="com.bitmap.security.SecurityProfile"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<link type="image/x-icon" href="../images/favicon.png" rel="shortcut icon">
<!-- <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;">
 -->
	<div class="wrap_header">
		<div class="wrap_logo"><a href="../home.jsp"><img src="../images/logo.jpg"></a></div>
		<div class="wrap_menu">
			<div class="head_info_left">BikeMan</div>
			<div class="head_info_right">
				<div class="right pointer head_profile" onclick="javascript: window.location='../hr/emp_profile.jsp?1=1';"> <%=(securProfile.isLogin())?securProfile.getPersonal().getName() + "&nbsp;&nbsp;" + securProfile.getPersonal().getSurname():""%></div>
				<%if(securProfile.isLogin()){
					if(SecurityProfile.check("lib", securProfile)){
						String cnt_req = Msg.count_msg("10");
				%>
				<div class="right pointer m_right10 head_req<%=cnt_req.equalsIgnoreCase("0")?"_blind":""%>" onclick="javascript: window.location='../content/ft_manage_request.jsp?SYSTEM=FT';">
					<%if(!cnt_req.equalsIgnoreCase("0")){ %>
					<div class="head_req_number"><%=cnt_req %></div>
					<%} %>
				</div>
				<%
					}
					String cnt_msg = Msg.count_generalMsg(securProfile.getPersonal().getPer_id());
					
				%>
				<div class="right pointer m_right5 head_msg<%=cnt_msg.equalsIgnoreCase("0")?"_blind":""%>" onclick="javascript: window.location='../msg/msg_list.jsp?SYSTEM=MSG';">
					<%if(!cnt_msg.equalsIgnoreCase("0")) { %>
					<div class="head_msg_number"><%=cnt_msg %></div>
					<%} %>
				</div>
				<%}%>
				<div class="clear"></div>
			</div>
			<div class="clear"></div>
			<div class="head_line"></div>
			<div class="clear"></div>
			<div class="head_menu_left"></div>
			<div class="head_menu_right">
			<%if(securProfile.isLogin()){%>
				<a title="logout" class="pointer" onclick="if(confirm('Logout?')){window.location='../index/out.jsp'}">Logout</a>
			<%} else { %>
				<!-- <a class="thickbox pointer" lang="login.jsp?width=350&height=240" title="Login">Login</a>	 -->
			<%} %>
			</div>
		</div>
		<div class="clear"></div>
	</div>
