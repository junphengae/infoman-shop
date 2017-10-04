<%@page import="com.bitmap.bean.parts.PartCategories"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/clear_form.js"></script>

<script src="../js/jquery.validate.min.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.simplemodal.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/basic_part_ss.css" rel="stylesheet" type="text/css">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="snc" %>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Parts: </title>
<%
String pn = request.getParameter("pn"); 
PartMaster entity = new PartMaster(); 
entity.setPn(pn);
entity = PartMaster.select(entity);
%>

<script type="text/javascript">
	function modal_status(pn,obj) {
		var width = 250;
		var left = (document.body.clientWidth / 2) - (width / 2);
		$('#modal_status_' + pn).modal();
		$('#simplemodal-container').css({'width':width + 'px','height':'130px','left':left});
		$('#modal_status_' + pn + ' input:radio[id=' + $(obj).attr('lang') + ']').attr('checked', true);
	}
	
	function upStatus(pn) {
		var check = $('#modal_status_' + pn + ' input:radio:checked');
		if (check.attr('checked')) {
			if (confirm('Confirm to change "Status" or not?')) {
				$.post('../PartSupersession?action=update_status&pn=' + pn + '&status=' + check.val() + '&update_by=<%=securProfile.getPersonal().getPer_id()%>' ,function(resData){
					if (resData.status == 'success') {
						$('#status_' + pn).attr('lang',check.val()).text('Status: ' + check.val());
						$.modal.impl.close();
					} else {
						alert(resData.status + ': ' + resData.message);
						$.modal.impl.close();
					}
				},'json');
			}
		} else {
			alert('Please select status!');
		}
	}
	
	function modal_ss_flag(pn,obj){
		var width = 250;
		var left = (document.body.clientWidth / 2) - (width / 2);
		$('#modal_flag_' + pn).modal();
		$('#simplemodal-container').css({'width':width + 'px','height':'130px','left':left});
		$('#modal_flag_' + pn + ' input:radio[id=' + $(obj).attr('lang') + ']').attr('checked', true);
	}
	
	function upSSFlag(pn) {
		var check = $('#modal_flag_' + pn + ' input:radio:checked');
		if (check.attr('checked')) {
			if (confirm('Confirm to change "SS Flag" or not?')) {
				$.post('../PartSupersession?action=update_ss_flag&pn=' + pn + '&ss_flag=' + check.val() + '&update_by=<%=securProfile.getPersonal().getPer_id()%>',function(resData){
					if (resData.status == 'success') {
						$('#ss_flag_' + pn).attr('lang',check.val()).text('SS FLAG: '+ check.val());
						$.modal.impl.close();
					} else {
						alert(resData.status + ': ' + resData.message);
						$.modal.impl.close();
					}
				},'json');
			}
		} else {
			alert('Please select SS Flag!');
		}
	}
</script>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Supersession Parts Relationship: </div>
				<div class="right">
					<button class="btn_box" type="button" onclick="window.location='part_info.jsp?pn=<%=entity.getPn()%>';">back</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<%
					List list = PartMaster.selectSSList(entity);
					Iterator ite = list.iterator();
					boolean isFirst = true;
					boolean last = false;
					while (ite.hasNext()) {
						PartMaster pm = (PartMaster) ite.next();
						
						String bg = "";
						String box = " _box status_box";
						last = false;
						if (pm.getUIPresent()) {
							bg = " style=\"background-color: #ccc;\"";
							box = " _box current_status_box";
							last = true;
						}
				%>
					<div id="wrap_part" lang="<%=pm.getPn()%>">
						<div class="detail_box s800 m_top5"<%=bg%>>
							<%-- <input type="button" class="btn_box" value="view" onclick="$('#modal_<%=pm.getPn()%>').modal();"> --%>
							<div class="left s150 <%=(isFirst)?"_box":box%>"><button class="btn_view thickbox"  title="Part Detail" lang="part_view_detail_ss.jsp?pn=<%=pm.getPn()%>&width=850&height=280"></button>P/N: <%=pm.getPn()%></div>
							<div class="left s300 m_left5">Description: <%=pm.getDescription()%></div>
							<div class="left s70 txt_left m_left5">MOR: <%=pm.getMor()%></div>
							<div class="left s70 txt_left m_left5">QTY: <%=pm.getQty()%></div>
							
							<div class="left <%=box%> s70 m_left5 pointer" title="Edit Status" id="status_<%=pm.getPn()%>" onclick="modal_status('<%=pm.getPn()%>',this);" lang="<%=pm.getStatus()%>">Status: <%=pm.getStatus()%></div>
							<!-- box for update status -->
							<div id="modal_status_<%=pm.getPn()%>" class="basic-modal-content">
								<div class="s120 center txt_center">
									<h4>Update Status</h4>
									<div class="m_top10 txt_left"><input type="radio" name="status" id="A" value="A"> <label for="A">A : Active</label></div>
									<div class="txt_left"><input type="radio" name="status" id="I" value="I"> <label for="I">I : Inactive</label></div>
									<!-- <div class="txt_left"><input type="radio" name="status" id="F" value="F"> <label for="F">F : Froze</label></div> -->
									<div class="btn_box m_top10" onclick="upStatus('<%=pm.getPn()%>')">Update Status</div> 
								</div>
							</div>
							
							<div class="flag_box s70 left m_left5 pointer "  onclick="modal_ss_flag('<%=pm.getPn()%>',this);" id="ss_flag_<%=pm.getPn()%>" lang="<%=pm.getSs_flag()%>">SS FLAG: <%=pm.getSs_flag()%></div>
							<!-- box for update ss_flag -->
							<div id="modal_flag_<%=pm.getPn()%>" class="basic-modal-content">
								<div class="s120 center txt_center">
									<h4>Update SS Flag</h4>
									<div class="m_top10 txt_left"><input type="radio" name="ss_flag" id="M" value="M"> <label for="M">M : Mixed</label></div>
									<!-- <div class="txt_left"><input type="radio" name="ss_flag" id="O" value="O"> <label for="O">O : One Way</label></div> -->
									<div class="txt_left"><input type="radio" name="ss_flag" id="R" value="R"> <label for="R">R : Rework</label></div>
									<div class="btn_box m_top10" onclick="upSSFlag('<%=pm.getPn()%>')">Update SS Flag</div> 
								</div>
							</div>
							<div class="clear"></div>
							
							<!-- box for show detail -->
							<%-- <div id="modal_<%=pm.getPn()%>" class="basic-modal-content">
								<table cellpadding="3" cellspacing="3" border="0" class="s400 center">
									<tbody>
										<tr>
											<td width="35%"><label>Parts Number</label></td>
											<td align="left">: <%=pm.getPn()%></td>
										</tr>
										<tr>
											<td><label>Description</label></td>
											<td align="left">: <%=pm.getDescription()%></td>
										</tr>
										<tr>
											<td><label>Fit to</label></td>
											<td align="left">: <%=pm.getFit_to()%></td>
										</tr>
										<tr>
											<td><label>Category</label></td>
											<td align="left">: <%=PartCategories.SelectCat_name(pm.getCat_id(),pm.getGroup_id())%></td>
										</tr>
										<tr>
											<td><label>Price</label></td>
											<td align="left">: <%=pm.getPrice()%> <%=PartMaster.unit(pm.getPrice_unit())%></td>
										</tr>
										<tr>
											<td><label>Cost</label></td>
											<td align="left">: <%=pm.getCost()%> <%=PartMaster.unit(pm.getCost_unit())%></td>
										</tr>
										<tr>
											<td><label>MOQ</label></td>
											<td align="left">: <%=pm.getMoq()%></td>
										</tr>
										<tr>
											<td><label>MOR</label></td>
											<td align="left">: <%=pm.getMor()%></td>
										</tr>
										<tr>
											<td><label>Weight</label></td>
											<td align="left">: <%=pm.getWeight()%></td>
										</tr>
										<tr>
											<td><label>Location</label></td>
											<td align="left">: <%=pm.getLocation()%></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div> --%>
						
						<div class="s120 center">
							<img class="m_left40" src="../images/arrow/arrow_blue_down.png" width="40" height="40"> 
						</div>
						
					</div>
				<%
						isFirst = false;
					}
				%>
					
					<div id="wrap_new">
						<div class="detail_box s800 m_top5">
							<div id="div_btn_add" class="s200 center txt_center">
								<input type="button" class="btn_box" value="Add Supersession" onclick="add_ss();">
							</div>
							
							<div id="div_form_add" class="s600 center txt_center hide">
								<div class="s400 center">
									<div class="s100 left txt_right">Parts Number</div><div class="s10 left">:</div>
									<div class="s250 left">
										<input type="text" class="s150 txt_box" id="search_pn"> 
										<input type="button" class="btn_box" id="btn_search" value="Search">
									</div>
									<div class="clear"></div>
								</div>
								<div class="msg_error" id="msg_search"></div>
							</div>
							
							<div class="hide s400 center" id="show_data_ss">
								<table cellpadding="3" cellspacing="3" border="0" class="s600 center">
									<tbody>
										<tr>
											<td width="23%"><label>P/N</label></td>
											<td>: <label id="ss_no"></label></td>
											<input type="hidden" id="ss_search">
											<input type="hidden" id="pn_search">
										</tr>
										<tr>
											<td><label>Description</label></td>
											<td>: <label id="ss_description"></label></td>
										</tr>
										<tr>
											<td><label>Fit to</label></td>
											<td>: <label id="ss_fit_to"></label></td>
										</tr>
											<tr>
											<td><label>SS Flag</label></td>
											<td>: <input type="radio" name="ss_flag" id="ss_flag_check" value="M" checked="checked"><label>M(Mixed)</label>
												  <input type="radio" name="ss_flag" id="ss_flag_check" value="R"><label>R(Rework)</label>
											</td>
										</tr>
									</tbody>
								</table>
								
								<div class="s350 center txt_center m_top5">
									<input type="button" class="btn_box" id="btn_add_ss" value="Make This Part Supersedes"> 
									<input type="button" class="btn_box hide" id="btn_add_ss_flag" value="Save Supersession Flag"> 
									<input type="button" class="btn_box" id="btn_search_again" value="Cancel" onclick="searchAgain();">
								</div>
								
								<div class="msg_error" id="msg_ss"></div>
							</div>
						</div>
						
					</div>
					<script type="text/javascript">
					var pn_first = $('.content_body').children('#wrap_part:first').attr('lang');
					var pn = $('.content_body').children('#wrap_part:last').attr('lang');
					
					var search_pn = $('#search_pn');
					var div_btn_add = $('#div_btn_add');
					var div_form_add = $('#div_form_add');
					var div_show_data_ss = $('#show_data_ss');
					
					function add_ss() {div_btn_add.slideUp('slow').delay(100);div_form_add.slideDown('slow');search_pn.val('').focus();}
					function searchAgain() {div_show_data_ss.slideUp('slow').delay(100);div_form_add.slideDown('slow');search_pn.val('').focus();}
					
					$('#btn_search').click(function(){
						searchSS();
					});
					
					$('#search_pn').keypress(function(e){
						if (e.keyCode == 13) {
							searchSS();
						}
					});
					
					function searchSS(){
						
						if (search_pn.val() == "") {
							search_pn.focus();
						} else {
							if (pn_first == search_pn.val() || pn == search_pn.val()) {
								$('#msg_search').text('Please Check, searching new Parts No. is already used as above!').fadeIn('slow');
								search_pn.val('').focus();
							} else {
								var pn_select = '<%=pn%>';
								$.post('../PartSupersession?action=search_ss&ss_no=' + search_pn.val() + '&pn=' + pn_select,function(resData){
									if (resData.SearchStatus == 'success') {
										$('#pn_search').val(pn_select);
										$('#ss_no').text(resData.pn);
										$('#ss_search').val(resData.pn);
										$('#ss_description').text(resData.description);
										$('#ss_fit_to').text(resData.fit_to);
										$('#msg_search').text('').hide();
										div_form_add.fadeOut('slow').queue(function(){div_show_data_ss.fadeIn('slow');$(this).dequeue();});
									} else {
										$('#msg_search').text(resData.message).fadeIn('slow');
										search_pn.val('').focus();
									}
								},'json');
							}
						}
					}
					
					$('#btn_add_ss').click(function(){
						var create_by  = '<%=securProfile.getPersonal().getPer_id()%>';
						var ss_no      = $('#ss_search').val();	
						var btn_add_ss = $('#btn_add_ss');
						var btn_add_ss_flag = $('#btn_add_ss_flag');
						var ss_flag    = $('#ss_flag_check').val();
						var pn_search  = $('#pn_search').val();	
						
						
						 var url = '../PartSupersession?action=add_ss&pn=' + pn_search +'&ss_flag='+ss_flag+ '&create_by=' + create_by + '&ss_no=' + ss_no;
						$.post(url,function(resData){
							if (resData.status == 'success') {
								$('#msg_ss').text('Add New Supersession Successfully.').show().delay(1000);
								window.location.reload();
							}
						},'json');
					});
					</script>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>