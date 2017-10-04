<%@page import="com.bitmap.bean.inventory.UnitType"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.PartGroups"%>
<%@page import="com.bitmap.bean.parts.PartCategories"%>
<%@page import="com.bitmap.bean.parts.PartCategoriesSub"%>
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
<script type="text/javascript">
	$(function(){
		var $msg = $('.msg_error');
		var $form = $('#infoForm');
		
		$.metadata.setType("attr", "validate");
		var v = $form.validate({
			submitHandler: function(){
				var addData = $form.serialize() + '&action=edit';
				ajax_load();
				$.post('../PartManagement',addData,function(data){
					ajax_remove();
					if (data.status == 'success') {
						//$msg.text('Update Success.').fadeIn(500);
						var urlredirect = 'part_info.jsp?pn='+$('#pn').val();
						//setTimeout("window.location.href('"+urlredirect+"')",1500);
						window.location =  urlredirect;
					} else {
						alert(data.message);
						$('#' + data.focus).focus();
					}
				},'json');
			}
		});
		
		$form.submit(function(){
			v;
			return false;
		});
		

		if($('#group_id').val() != "") {
			$('#edit_group').fadeIn(500).attr('lang','part_group_edit.jsp?height=180&width=440&group_id=' + $('#group_id').val());
			$('#new_cat').fadeIn(500).attr('lang','part_cat_new.jsp?height=180&width=440&group_id=' +$('#group_id').val());
		}
		else{
			$('#edit_group').hide();
			$('#new_cat').hide();
			$('#edit_cat').hide();
			$('#edit_sub_cat').hide();
			$('#new_sub_cat').hide();
		}
		if($('#cat_id').val() != ""){
			$('#new_sub_cat').fadeIn(500).attr('lang','part_sub_cat_new.jsp?height=180&width=440&cat_id=' +$('#cat_id').val() + '&group_id=' + $('#group_id').val());
			$('#edit_cat').fadeIn(500).attr('lang','part_cat_edit.jsp?height=180&width=440&cat_id=' +$('#cat_id').val() + '&group_id=' + $('#group_id').val());
			
		}else{
			$('#edit_cat').hide();
			$('#new_sub_cat').hide();
			$('#edit_sub_cat').hide();
		}
		if($('#sub_cat_id').val() != ""){
			$('#edit_sub_cat').fadeIn(500).attr('lang','part_sub_cat_edit.jsp?height=180&width=440&sub_cat_id=' + $('#sub_cat_id').val() + '&cat_id=' + $('#cat_id').val() + '&group_id=' + $('#group_id').val());
		}else{
			$('#edit_sub_cat').hide();
		}
		
		$('#group_id').change(function(){
			ajax_load();
			$.post('../PartManagement',{group_id: $('#group_id').val(),action:'get_cat_th'}, function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					var options = '<option value="">--- เลือกชนิด ---</option>';
	                var j = resData.cat;
	                $.each(j , function (index , object){
	                	 options += '<option value="' + object.cat_id + '">' + object.cat_name_th + ' ' + object.cat_name_short + '</option>';

	                });
	                	
	             	$('#cat_id').html(options);
	             	$('#sub_cat_id').html('<option value="">--- เลือกชนิดย่อย ---</option>');
				} else {
					alert(resData.message);
				}
	        },'json');
			
			if($('#group_id').val() != "") {
				$('#edit_group').fadeIn(500).attr('lang','part_group_edit.jsp?height=180&width=440&group_id=' + $('#group_id').val());
				$('#new_cat').fadeIn(500).attr('lang','part_cat_new.jsp?height=180&width=440&group_id=' +$('#group_id').val());
				$('#edit_cat').hide();
				$('#edit_sub_cat').hide();
				$('#new_sub_cat').hide();
			} else {
				$('#edit_group').hide();
				$('#new_cat').hide();
				$('#edit_cat').hide();
				$('#edit_sub_cat').hide();
				$('#new_sub_cat').hide();
			}
		});
		
		
		$('#cat_id').change(function(){
			ajax_load();
			$.post('../PartManagement',{group_id:$('#group_id').val(),cat_id: $(this).val(),action:'get_sub_cat_th'}, function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					var options = '<option value="">--- เลือกชนิดย่อย ---</option>';
	                var j = resData.sub_cat;
		            $.each(j , function (index , object){
	                	 options += '<option value="' + object.sub_cat_id + '">' + object.sub_cat_name_th + ' ' + object.sub_cat_name_short + '</option>';
	                });
	             	$('#sub_cat_id').html(options);
				} else {
					alert(resData.message);
				}
	        },'json');
			
			if($('#cat_id').val() != "") {
				$('#new_sub_cat').fadeIn(500).attr('lang','part_sub_cat_new.jsp?height=180&width=440&cat_id=' +$('#cat_id').val() + '&group_id=' + $('#group_id').val());
				$('#edit_cat').fadeIn(500).attr('lang','part_cat_edit.jsp?height=180&width=440&cat_id=' +$('#cat_id').val() + '&group_id=' + $('#group_id').val());
				$('#edit_sub_cat').hide();
			} else {
				$('#edit_cat').hide();
				$('#edit_sub_cat').hide();
				$('#new_sub_cat').hide();
			}
		});
		
		$('#sub_cat_id').change(function(){
			if($(this).val() != "") {
				$('#edit_sub_cat').fadeIn(500).attr('lang','part_sub_cat_edit.jsp?height=180&width=440&sub_cat_id=' + $('#sub_cat_id').val() + '&cat_id=' + $('#cat_id').val() + '&group_id=' + $('#group_id').val());
			} else {
				$('#edit_sub_cat').hide();
			}
		});
		
		
	});
</script>

<title>Parts</title>
<%
	List paramList = new ArrayList();

String keyword = WebUtils.getReqString(request, "keyword");
String group_id = WebUtils.getReqString(request, "group_id");
String cat_id = WebUtils.getReqString(request, "cat_id");
String sub_cat_id = WebUtils.getReqString(request, "sub_cat_id");


paramList.add(new String[]{"keyword",keyword});
paramList.add(new String[]{"group_id",group_id});
paramList.add(new String[]{"cat_id",cat_id});
paramList.add(new String[]{"sub_cat_id",sub_cat_id});

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
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Inventory</div>
					<div class="right">
					 	<button class="btn_box btn_add" onclick="window.location='part_add.jsp';">Create New Parts</button> 
					</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="part_manage.jsp" id="search" method="get">
						<Strong>Keyword: </Strong>
						<input type="text" class="s120 txt_box" name="keyword" value="<%=keyword%>" autocomplete="off">  
						<%-- Group:
						<bmp:ComboBox name="group_id" styleClass="txt_box s200" listData="<%=PartGroups.ddl_th() %>" value="<%=group_id%>">
							<bmp:option value="" text="--- All ---"></bmp:option>
						</bmp:ComboBox>  --%>
						
						 <Strong>Group</Strong>: 
									<bmp:ComboBox name="group_id" styleClass="txt_box s120" width="120px" listData="<%=PartGroups.ddl_th()%>" validate="true" validateTxt="***** Required!"  value="<%=group_id%>">
										<bmp:option value="" text="--- All ---"></bmp:option>
									</bmp:ComboBox>
						 <Strong>Type</Strong>: 
								<bmp:ComboBox name="cat_id" styleClass="txt_box s120" width="120px" listData="<%=PartCategories.ddl_th(group_id)%>" validate="true" validateTxt=" *** Required!" value="<%=cat_id%>">
									<bmp:option value="" text="--- All ---"></bmp:option>
								</bmp:ComboBox>
						<Strong>SubType</Strong>: 
									<bmp:ComboBox name="sub_cat_id" styleClass="txt_box s120" width="120px" listData="<%=PartCategoriesSub.ddl_th(cat_id, group_id)%>" validate="true" validateTxt=" *** Required!" value="<%=sub_cat_id%>">
										<bmp:option value="" text="--- All ---"></bmp:option>
									</bmp:ComboBox>
									
									
						<input type="submit" name="submit" value="Search" class="btn_box btn_confirm">
						<input type="button" name="reset" value="Reset" class="btn_box s50 m_left5" onclick="clear_form('#search');">
						<input type="hidden" name="action" value="search">
						
					</form>
				</div>
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"part_manage.jsp",paramList)%></div>
				<div class="clear"></div>
				
				<div class="dot_line"></div>
				
				<table class="bg-image  s_auto breakword"><!-- เพิมbreakword มาเพื่อตัดคำ -->
					<thead>
						<tr>
							<th valign="top" align="left" width="10%" >P/N</th>
							<th valign="top" align="left" width="5%">กลุ่ม</th>
							<th valign="top" align="left" width="5%">ชนิด</th>
							<th valign="top" align="left" width="7%">ชนิดย่อย</th>
							<th valign="top" align="left" width="15%" >Description</th>
							<th valign="top" align="left" width="12%">Location</th>
							<th valign="top" align="left" width="11%">Fit-To</th>
							<th valign="top" align="center" width="10%">SS</th>
							<th valign="top" align="center" width="5%">Units</th>
							<th valign="top" align="right" width="5%">Qty</th>
							<th align="center" width="5%"></th>
						</tr>
					</thead>
					<tbody>
					<%
						boolean has = true;
						Iterator ite = list.iterator();
						while(ite.hasNext()) {
							PartMaster entity = (PartMaster) ite.next();
							has = false;
					%>
						<tr>
							<td align="left" valign="top">
								<%=entity.getPn().trim() %>
							</td>
							<td align="center" valign="top">
								<%=PartGroups.select(entity.getGroup_id()).getGroup_name_en().trim()%>
							</td>
							<td align="center" valign="top">
								<%=PartCategories.select(entity.getCat_id(), entity.getGroup_id()).getcat_name_short().trim()%>
							</td>
							<td align="center" valign="top">
								<%=PartCategoriesSub.select(entity.getSub_cat_id(),entity.getCat_id(), entity.getGroup_id()).getSub_cat_name_short().trim()%>
							</td>
							<td align="left" valign="top"><%=entity.getDescription().trim() %></td>
							<td align="left" valign="top"><%=entity.getLocation().trim() %></td>
							<td align="left" valign="top">
								<%=entity.getFit_to() %>
							</td>
							<td align="left" valign="top">
								<%=entity.getSs_no() %>
							</td> 
							<td align="left"><%=UnitType.selectName(entity.getDes_unit())   %></td>
							<td align="right" valign="top"><%=Money.moneyInteger(entity.getQty())%></td>
							
						<%-- 	<td align="right" valign="top"><%=entity.getMor()%></td> 
							<td align="right" valign="top"><%=entity.getMoq()%></td>  --%>
							<td align="left" valign="top">
								<a class="btn_view" href="part_info.jsp?pn=<%=entity.getPn()%>&id=1" title="View Parts Information"></a>
								
								<%-- <a class="btn_download thickbox" href="part_add_stock_detail.jsp?pn=<%=entity.getPn()%>&width=700&height=400" title="Add Stock"></a>  --%>
								<%-- <a class="btn_import thickbox" title="Purchase Parts" lang="../part/pr_parts.jsp?pn=<%=entity.getPn()%>&width=850&height=500"></a> --%>
								<%if(!entity.getQty().equalsIgnoreCase("0")){%>
								
								 	<a class="btn_export thickbox" title="Borrow Parts" lang="borrow_part_create.jsp?pn=<%=entity.getPn()%>"></a>
								 
								
								<%}%>
							</td>
						</tr>
					<%
						}
						if(has){
					%>
						<tr><td colspan="10" align="center">Parts Master cannot be found!</td></tr>
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