<%@page import="org.eclipse.jdt.internal.compiler.ast.IfStatement"%>
<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.parts.ServicePartDetail"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.bean.parts.PartGroups"%>
<%@page import="com.bitmap.bean.parts.PartCategories"%>
<%@page import="com.bitmap.bean.parts.PartCategoriesSub"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
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
<%@page import="com.bitmap.utils.Money"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/clear_form.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/popup.js"></script>
<script src="../js/number.js"></script>

<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>


<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/barcode.css" rel="stylesheet" type="text/css" media="all"> 
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Parts</title>
<%
List paramList = new ArrayList();

String keyword = WebUtils.getReqString(request, "keyword");
String id = WebUtils.getReqString(request, "id");

paramList.add(new String[]{"keyword",keyword});
paramList.add(new String[]{"id",id});

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


List list = PartMaster.selectWithCTRL(ctrl, paramList);

String sumPO  = "";
String NewsumPO  = "";
%>
</head>
<body> 

<div class="wrap_auto">
								
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Parts Search</div>
				<div class="right">
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="sale_part_search.jsp" id="search" method="get">
						Keyword: 
						<input type="text" class="s150 txt_box" name="keyword" value="<%=keyword%>" autocomplete="off" id="check_keyword">  
						<input type="hidden" name="id" value="<%=id%>">
						<input type="submit" name="submit" value="Search" class="btn_box btn_confirm">
						<input type="button" name="reset" value="Reset" class="btn_box s50 m_left5" onclick="clear_form('#search');">
						<input type="hidden" name="action" value="search">
						
					</form>
				</div>
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"sale_part_search.jsp",paramList)%></div>
				<div class="clear"></div>
				
				
				<div class="dot_line"></div>
				
				<table class="columntop bg-image breakword "  width="100%">
					<thead>
						<tr>
							<th valign="top" align="center" width="11%">P/N</th>
							<th valign="top" align="center" width="27%">Description</th>
							<th valign="top" align="center" width="10%">Fit To</th>
							<th valign="top" align="center" width="8%">Units</th>
							<th valign="top" align="center" width="10%">On Hand Qty</th>
							<th valign="top" align="center" width="10%">PO Qty</th>							
							<th valign="top" align="center" width="10%">Price(฿)</th>							
							<th valign="top" align="center" width="3%">SS</th>
							<th align="center" width="11%"></th>
						</tr>
					</thead>
					<tbody>
						<tr> 
						 <td colspan="9" style="padding: 0px 0px 0px 0px;" width="100%">
							 <div class="scroll">
							  <table class="bg-image breakword"  style="border-collapse: collapse;" width="100%">							
													<%
														boolean has = false;
														Iterator ite = list.iterator(); 
														while(ite.hasNext()) {
															
															PartMaster entity = (PartMaster) ite.next();
															String UnitDesc = UnitType.selectName(entity.getDes_unit());

															
															has = true;
															
															NewsumPO = PurchaseRequest.sumPO(entity.getPn());
															//System.out.println(NewsumPO);
															if( NewsumPO.length()>0 ){
																sumPO = NewsumPO;
															}
															
															//เช็คจำนวน qty 
															String base_qty =  ServicePartDetail.selectQty(id, entity.getPn());
															
													if( ! entity.getStatus().equalsIgnoreCase("I") ){
														//System.out.println( " Status :" +entity.getStatus());
															
													
												/* -------------------------------------------------------------------------------------------------------- */		
													if(Integer.parseInt(entity.getMoq()) >= (Integer.parseInt(entity.getQty()) - Integer.parseInt(base_qty))){												
													
													%>
													<!-- // ในกรณีที่  Qty หมดแล้ว   // -->
														<tr>
															<td align="left" width="12%"><font color="red"><%=entity.getPn() %></font></td>
															<td align="left" width="28%"><font color="red"><%=entity.getDescription() %></font></td>
															<td align="left" width="10%"><font color="red"><%=entity.getFit_to() %></font></td>
															<td align="left" width="8%"><font color="red"><%=UnitDesc%></font></td>
															<td align="right" width="10%"><font color="red"><%=Money.moneyInteger(entity.getQty())%></font></td>	
															<td align="right" width="10%"><font color="red"><%=Money.moneyInteger(sumPO)%></font></td>													
															<td align="right" width="10%"><font color="red"><%=Money.money(entity.getPrice())%></font></td>
															
															
															<td align="center" width="3%">
															<%if(entity.getSs_no().length() > 0){%><img src="../images/icon/flag.png" title="SS Flag"><%}%></td>
															
															<%-- <%if(entity.getSs_no().length() > 0){%>
															<a class="thickbox" title="Select Parts S/S <%=entity.getPn()%>" href="sale_part_select_ss.jsp?pn=<%=entity.getPn()%>&id=<%=id%>&width=650&height=500"><img src="../images/icon/flag.png" title="SS Flag"></a>
															<%}%></td> --%>
															
															<td align="center" width="10%">
															<button class="btn_view " title="Select parts" 
																onclick="popupSetWH('../part/part_info_view_search.jsp?pn=<%=entity.getPn()%>','1000','700');"> </button>
																<%-- <%if(!entity.getSs_no().equalsIgnoreCase("")){ %>
																<a class="btn_accept thickbox" title="Select Parts S/S <%=entity.getPn()%>" href="sale_part_select_ss.jsp?pn=<%=entity.getPn()%>&id=<%=id%>&width=650&height=500"></a>
																 <% }%> --%>
																<%-- <a class="btn_view thickbox" title="View" href="part_info_view_search.jsp?pn=<%=entity.getPn()%>&width=800&height=700" ></a> --%>
																
																<%if(entity.getQty().length() > 0 && !entity.getQty().equals("0")){ %>
																
																 <a class="btn_accept thickbox" title="Select Parts" href="sale_part_select.jsp?pn=<%=entity.getPn()%>&id=<%=id%>&width=580&height=300"></a>
																
																<%}%>																
															</td>
														</tr>
														<!-- /* -------------------------------------------------------------------------------------------------------- */ -->
														<% }else{ %>
														
														<!-- // ในกรณีที่ Qty ยังไม่หมด   // -->
														<tr>
															<td align="left" width="12%"><%=entity.getPn() %></td>
															<td align="left" width="28%"><%=entity.getDescription() %></td>
															<td align="left" width="10%"><%=entity.getFit_to() %></td>
															<td align="left" width="8%"><%=UnitDesc%></td>
															<td align="right" width="10%"><%=Money.moneyInteger(entity.getQty())%></td>
															<td align="right"  width="10%"><%=Money.moneyInteger(sumPO)%></td>
															<td align="right"  width="10%"><%=Money.money(entity.getPrice())%></td>
														
															<td align="center"  width="3%">
															<%if(entity.getSs_no().length() > 0){%><img src="../images/icon/flag.png" title="SS Flag"><%}%></td>
															<td align="center"  width="10%">
																	<button class="btn_view " title="Select parts" 
																onclick="popupSetWH('../part/part_info_view_search.jsp?pn=<%=entity.getPn()%>','1000','700');"> </button>
																<%-- <a class="btn_view thickbox" title="View" href="part_info_view_search.jsp?pn=<%=entity.getPn()%>&width=800&height=700" ></a> --%>
																<%if(entity.getQty().length() > 0 && !entity.getQty().equals("0")){
																	
																%>
																 
																   <a class="btn_accept thickbox" title="Select Parts" href="sale_part_select.jsp?pn=<%=entity.getPn()%>&id=<%=id%>&width=600&height=350"></a> 
																
																
																<%}%>
																
															</td>
														</tr>
														
														
													<%		}
													/* -------------------------------------------------------------------------------------------------------- */		
															
														}else /*** if status != I ***/	
														 if(entity.getStatus().equalsIgnoreCase("I") && !entity.getQty().equalsIgnoreCase("0")){
															/***** ในกรณี ที่เป็น I แต่ ขายยังไม่หมด*****/
														
															/* -------------------------------------------------------------------------------------------------------- */		
															if(Integer.parseInt(entity.getMoq()) >= (Integer.parseInt(entity.getQty()) - Integer.parseInt(base_qty))){												
															
															%>
															<!-- // ในกรณีที่  Qty หมดแล้ว   // -->
																<tr>
																	<td align="left" width="12%"><font color="red"><%=entity.getPn() %></font></td>
																	<td align="left" width="28%"><font color="red"><%=entity.getDescription() %></font></td>
																	<td align="left" width="10%"><font color="red"><%=entity.getFit_to() %></font></td>
																	<td align="left" width="8%"><font color="red"><%=UnitDesc%></font></td>
																	<td align="right" width="10%"><font color="red"><%=Money.moneyInteger(entity.getQty())%></font></td>	
																	<td align="right" width="10%"><font color="red"><%=Money.moneyInteger(sumPO)%></font></td>													
																	<td align="right" width="10%"><font color="red"><%=Money.money(entity.getPrice())%></font></td>
																	
																	<td align="center" width="3%">
																	<%-- <%if(entity.getSs_no().length() > 0){%>
																	<a class="thickbox" title="Select Parts S/S <%=entity.getPn()%>" href="sale_part_select_ss.jsp?pn=<%=entity.getPn()%>&id=<%=id%>&width=650&height=500"><img src="../images/icon/flag.png" title="SS Flag"></a>
																	<%}%> --%>
																	</td>
																	<td align="center" width="10%">
																	<button class="btn_view " title="Select parts" 
																		onclick="popupSetWH('../part/part_info_view_search.jsp?pn=<%=entity.getPn()%>','1000','700');"> </button>
																		<%-- <%if(!entity.getSs_no().equalsIgnoreCase("")){ %>
																		<a class="btn_accept thickbox" title="Select Parts S/S <%=entity.getPn()%>" href="sale_part_select_ss.jsp?pn=<%=entity.getPn()%>&id=<%=id%>&width=650&height=500"></a>
																		 <% }%>
																		  --%>
																		<%-- <a class="btn_view thickbox" title="View" href="part_info_view_search.jsp?pn=<%=entity.getPn()%>&width=800&height=700" ></a> --%>
																		
																		<%if(entity.getQty().length() > 0 && !entity.getQty().equals("0")){ %>
																		
																		 <a class="btn_accept thickbox" title="Select Parts" href="sale_part_select.jsp?pn=<%=entity.getPn()%>&id=<%=id%>&width=580&height=300"></a>
																		
																		<%}%>																
																	</td>
																</tr>
																<!-- /* -------------------------------------------------------------------------------------------------------- */ -->
																<% }else{ %>
																
																<!-- // ในกรณีที่ Qty ยังไม่หมด   // -->
																<tr>
																	<td align="left" width="12%"><%=entity.getPn() %></td>
																	<td align="left" width="28%"><%=entity.getDescription() %></td>
																	<td align="left" width="10%"><%=entity.getFit_to() %></td>
																	<td align="left" width="8%"><%=UnitDesc%></td>
																	<td align="right" width="10%"><%=Money.moneyInteger(entity.getQty())%></td>
																	<td align="right"  width="10%"><%=Money.moneyInteger(sumPO)%></td>
																	<td align="right"  width="10%"><%=Money.money(entity.getPrice())%></td>
																	
																	<td align="center"  width="3%">
																	<%if(entity.getSs_no().length() > 0){%><img src="../images/icon/flag.png" title="SS Flag"><%}%>
																	</td>
																	<td align="center"  width="10%">
																			<button class="btn_view " title="Select parts" 
																		onclick="popupSetWH('../part/part_info_view_search.jsp?pn=<%=entity.getPn()%>','1000','700');"> </button>
																		<%-- <a class="btn_view thickbox" title="View" href="part_info_view_search.jsp?pn=<%=entity.getPn()%>&width=800&height=700" ></a> --%>
																		<%if(entity.getQty().length() > 0 && !entity.getQty().equals("0")){
																			
																		%>
																		 
																		   <a class="btn_accept thickbox" title="Select Parts" href="sale_part_select.jsp?pn=<%=entity.getPn()%>&id=<%=id%>&width=600&height=350"></a> 
																		
																		
																		<%}%>
																		
																	</td>
																</tr>
																
																
															<%		}
															/* -------------------------------------------------------------------------------------------------------- */		
																														
															
														 }
														}/** END while**/
													
														if(has == false){
															
													%>
														<tr><td colspan="7" align="center">Parts Master cannot be found</td></tr>
													<%
														}
													%>
													
													</table>
								</div>
							</td> 
						</tr>
					</tbody>
					<tfoot>
					<tr>
						<td colspan="8" align="center" height="35px" valign="bottom">
							<input type="button" id="close_form" class="btn_box btn_warn" value="Close Display" >	
						</td>
					</tr>
					</tfoot>
				</table>
				<script type="text/javascript">
				$(function(){
					$('#check_keyword').focus();
					
					$("#close_form").click(function(){ 					
				       	window.close(); 
					}); 
				});
				</script>
			</div>
		</div>
	</div>
	
</div>
</body>
</html>