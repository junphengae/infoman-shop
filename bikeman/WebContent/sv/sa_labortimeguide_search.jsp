<%@page import="com.bitmap.bean.service.LaborTime"%>
<%@page import="com.bitmap.bean.service.RepairLaborTime"%>
<%@page import="com.bitmap.bean.service.LaborCate"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
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
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/clear_form.js"></script>
<script src="../js/popup.js"></script>
<script src="../js/number.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="../js/jquery.metadata.js"></script>
<script type="text/javascript" src="../js/jquery.validate.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Customer List</title>
<%
List paramList = new ArrayList();





String cate_id = WebUtils.getReqString(request,"cate_id");
String main_id = WebUtils.getReqString(request,"main_id");
String search = WebUtils.getReqString(request, "search");
LaborCate entity = LaborCate.select(cate_id);


paramList.add(new String[]{"cate_id",cate_id});
paramList.add(new String[]{"main_id",main_id});
paramList.add(new String[]{"search",search});

session.setAttribute("CS_ORDER_SEARCH", paramList);

String page_ = WebUtils.getReqString(request, "page");
PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("CS_ORDER_PAGE", page_);
}

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("CS_ORDER_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("CS_ORDER_PAGE")));
}

List list = LaborTime.selectWithCTRL(ctrl, paramList);
%>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="snc" %>
<script type="text/javascript">
	$(function(){
		$('#btn_vehicle_detail_toggle').click(function(){
			var txt = $(this).text();
			$('#vehicle_detail').slideToggle(600);
			if (txt == 'ซ่อน') {
				$(this).text('แสดง');
			} else {
				$(this).text('ซ่อน');
			}
		});
		
		var $cate_id = $('#cate_id');
		var $main_id = $('#main_id');
		var $DIV_laborTimeGuide = $('#laborTimeGuide');
		//var $labor_time_list = $('#labor_time_list');
		
		$cate_id.change(function(){
			ajax_load();
			$.getJSON('GetLaborTime',{action:'GetMain',cate_id: $(this).val()},
				function(m){
					ajax_remove();
					var options = '<option value="">--- เลือกหมวดย่อย ---</option>';
		            for (var i = 0; i < m.length; i++) {
		                options += '<option value="' + m[i].main_id + '">' + m[i].main_en + ' / ' + m[i].main_th + '</option>';
		            }
              		$main_id.html(options);
              		//$DIV_laborTimeGuide.fadeOut(700);
              		//$('#msg_labor').hide();              		
				}
			);
			

			
			
			
			
		});
		
	/* 	$main_id.change(function(){
			ajax_load();
			$.getJSON('GetLaborTime',{action:'Search',main_id:$(this).val(),cate_id:$('#cate_id').val()},
				function(data){
					ajax_remove();
					var li = '';
					for (var i = 0; i < data.length; i++) {
						li += '<tr id="' + data[i].labor_id + '">'
							+ '<td align="center">' + data[i].labor_id + '</td>'
							+ '<td>' + data[i].labor_en + ' / ' + data[i].labor_th + '</td>'
							+ '<td align="center">' + data[i].labor_hour + '</td>'
							+ '<td align="center">'
							+'<input class="pointer btn_accept'
								+ '" id="' + data[i].labor_id 
								+ '" title="' + data[i].labor_en + ' / ' + data[i].labor_th 
								+ '" lang="' + data[i].labor_hour
							   	+ '" onclick="setLaborTime(this);"/><input class="btn_update" lang="../info/labor_time_edit.jsp?width=550&amp;height=250&amp;labor_id='+data[i].labor_id +'&amp;main_id='+data[i].main_id+'" type="button" title="แก้ไขรายการซ่อม" onclick="thickbox_init(this);" >'
							+ '</td></tr>';
					}
					//$labor_time_list.html(li);
					//$DIV_laborTimeGuide.fadeIn(1000);
					//$('#msg_labor').hide();
				}
			);
		}); */
	});

	function setLaborTime(obj) {
		var $id = window.opener.$('#id').val();
		var $create_by = window.opener.$('#create_by').val();
		var $labor_id = $(obj).attr('id');
		var $labor_hour = $(obj).attr('lang');
		var $labor_name = $(obj).attr('title');
		var unit_price = prompt('ค่าแรงต่อหน่วย','<%=RepairLaborTime.standardPrice()%>');		
		if (unit_price != '' && isNumber(unit_price)) {
			ajax_load();
			$.post('ServiceAdvisor',{action:'qt_save_labor',id:$id,labor_id:$labor_id,labor_hour:$labor_hour,create_by:$create_by,'unit_price':unit_price},
				function(resData){
					ajax_remove();
					if (resData.status.indexOf('success') == -1) {
						window.opener.$('#msg_labor').text(resData.message).show();
					} else {
						var li = '<tr id="list_' + $labor_id + '_' + resData.number + '">'
						+ '<td align="center">' + $labor_id + '</td>'
						+ '<td>' + $labor_name + '</td>'
						+ '<td align="center">' + money(unit_price) + '</td>'
						+ '<td align="center">' + $labor_hour + '</td>'
						+ '<td align="center"><div class="pointer btn_del2" lang="' + $labor_id + '" number="' + resData.number + '" id="list_' + $labor_id + '_' + resData.number + '" title="ยืนยันการยกเลิก: [' + $labor_id + ']?" onclick="javascript: if(confirmRemove(this)){removeRepairList(this),deleteService('+$labor_id+','+resData.number+','+resData.number+')}"></div></td>'
						+ '</tr>';
						window.opener.$('#repair_list').append(li).show();
						window.opener.$('#msg_labor').hide();
						
					}
				},'json'
			);
			ajax_load();
			$.post('../PartSaleManage',{action:'sale_service_add',id:$id,labor_name:$labor_name,labor_qty:$labor_hour,labor_rate:unit_price,discount:'0'},
			function(resData){			
				ajax_remove();
				if (resData.status == 'success') {
					window.location.reload();
				} else {
					alert(resData.status);
				}
			},'json');
			
			window.opener.location.reload(); 
			window.close(); 
		} else {
			setLaborTime(obj);
		}
	}
	
	function confirmRemove(obj){
		return confirm($(obj).attr('title'));
	}
	
	function removeRepairList(obj){
		var $id = $('#id').val();
		var $number = $(obj).attr('number');
		var $labor_id = $(obj).attr('lang');
		var $create_by = $('#create_by').val();
		ajax_load();
		$.post('ServiceAdvisor',{action:'qt_remove_labor',id:$id,labor_id:$labor_id,number:$number,create_by:$create_by},
			function(resData){
				ajax_remove();
				if (resData.status.indexOf('success') == -1) {
					$('#msg_labor').text(resData.message).show();
				} else {
					$('tr#' + $(obj).attr('id')).fadeOut(400).remove();
				}
			},'json'
		);
	}
	
	</script>
</head>
<body >
<div class="wrap_all">	
	<div class="wrap_body">
		<div class="m_top15"></div>
		<div class="body_content">
			<div class="content_head">
				<div class="left">LaborTimeGuide Search</div>
				<div class="right">								
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="sa_labortimeguide_search.jsp" id="search" method="get">
						Search: 
						<input type="text" class="s150 txt_box" name="search" id="search" value="<%=search%>" autocomplete="off">  
						<snc:ComboBox name="cate_id" styleClass="txt_box" width="220px" listData="<%=LaborCate.listDropDownEN()%>" value="<%=cate_id %>">
							<snc:option value="" text="--- หมวดหลักทั้งหมด ---"></snc:option>									
						</snc:ComboBox>
						<snc:ComboBox name="main_id" styleClass="txt_box" width="220px" value="<%=main_id %>">
							<snc:option value="" text="--- หมวดย่อยทั้งหมด ---"></snc:option>
						</snc:ComboBox>					
						<input type="submit" name="submit" value="Search" class="btn_box btn_confirm">
						<input type="button" name="reset" value="Reset" class="btn_box s50 m_left5" onclick="clear_form('#search');$('#keyword').focus();">
						<input type="hidden" name="action" value="search">
						<input type="hidden" class="s150 txt_box" name="main_id_search" id="main_id_search" value="<%=main_id%>" >						
					</form>
				</div>

				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"sa_labortimeguide_search.jsp",paramList)%></div>
				<div class="clear"></div>
				
				<div class="dot_line"></div>
				<br>
				<div id="laborTimeGuide" class="center s920 ">
							<table class="bg-image s920 center">
								<thead>
									<tr>
										<th width="80px" align="center">รหัส</th>
										<th width="655px" align="center">รายการ</th>
										<th width="70px" align="center">เวลา</th>
										<th width="60px" align="center">&nbsp;</th>
									</tr>
								</thead>
								<!-- <tbody id="labor_time_list">	 -->
								
					<%
						
						Iterator ite = list.iterator();
						while(ite.hasNext()) {
							LaborTime entity2 = (LaborTime) ite.next();
					%>
						<tbody>
						<tr>
							<td align="center"><%=entity2.getLabor_id()%></td>
							<td align="left"><%=entity2.getLabor_en()%>/<%=entity2.getLabor_th()%></td>
							<td valign="top" align="center" ><%=entity2.getLabor_hour()%></td>
							<td align="center" align="center"><input class="pointer btn_accept" id="<%=entity2.getLabor_id()%>" title="<%=entity2.getLabor_en()%>/<%=entity2.getLabor_th()%>" lang="<%=entity2.getLabor_hour()%>" onclick="setLaborTime(this);"/></td>
							
						</tr>
					<%}%>
								</tbody>
							</table>
							<div class="msg_error" id="msg_labor"></div>
				</div>
							
			
				<script type="text/javascript">
				$(function(){
					$(".btn_select").click(function(){ 
				        window.opener.$('#cus_id').val($(this).attr('data_id'));
				        window.opener.$('#cus_name').val($(this).attr('data_name'));
				        window.opener.$('#bt').attr('lang','sv_job_customer_info.jsp?width=1000&height=600&cus_id=' + $(this).attr('data_id'));
				        window.opener.$('#v_plate').val('');
				        window.opener.getVehicle($(this).attr('data_id'));
				       	window.close(); 
					}); 
				});
											
				if($('#cate_id').val()!=""){
									
					$.getJSON('GetLaborTime',{action:'GetMain',cate_id: $('#cate_id').val()},
							function(m){								
								var $main_id = $('#main_id');
								var $DIV_laborTimeGuide = $('#laborTimeGuide');								
					
								var options = '<option value="">--- เลือกหมวดย่อย ---</option>';
					            for (var i = 0; i < m.length; i++) {
					            	if($('#main_id_search').val()==m[i].main_id ){
					               	 	options += '<option value="' + m[i].main_id + '" selected >' + m[i].main_en + ' / ' + m[i].main_th + '</option>';
					            	}else{
					            		options += '<option value="' + m[i].main_id + '">' + m[i].main_en + ' / ' + m[i].main_th + '</option>';
					            	}
					            }					            
			              		$main_id.html(options);
			              		//$DIV_laborTimeGuide.fadeOut(700);
			              		//$('#msg_labor').hide();
							}
					);
					
				}
			</script>
			</div>
		</div>
	</div>	
</div>
</body>
</html>