<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.service.LaborTime"%>
<%@page import="com.bitmap.bean.service.LaborCate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css">
<link href="../css/unit.css" rel="stylesheet" type="text/css">
<link href="../css/table.css" rel="stylesheet" type="text/css">
<link href="../css/loading.css" rel="stylesheet" type="text/css">

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.validate.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>หัวหน้าช่าง: จัดการข้อมูลพื้นฐานการซ่อม</title>
<%@ taglib uri="/WEB-INF/tld/customtag.tld" prefix="snc" %>

<style type="text/css">
	.bg-image th{
		border-bottom: 1px dotted #444;
		-webkit-border-top-left-radius: 0px; -moz-border-radius-topleft: 0px; border-top-left-radius: 0px;
		-webkit-border-top-right-radius: 0px; -moz-border-radius-topright: 0px; border-top-right-radius: 0px;
	}
	.bg-image th:hover{
		background-color: #1F1F1F;
	}
	
	.bg-image th.active{
		background-color: #3B669F;
	}
</style>

</head>
<body onload="$('div.wrap_all').fadeIn(800);init();">

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	<div class="wrap_navigate">
		<span onclick="javascript: window.location='../index.jsp';" class="pointer">หน้าหลัก</span> / 
		<span>จัดการข้อมูลพื้นฐานการซ่อม</span>
	</div>
	<!-- Start Wrap Content -->
	<div class="wrap_content">
	
		<div class="content">
			
			<div class="box_wrap s1000">
				<div class="box_head">
					<div class="left txt_bold">ข้อมูลพื้นฐานการซ่อม</div>
					<div class="btn_box right" title="Back" onclick="javascript: window.location='../index.jsp';">ย้อนกลับ</div>
					<div class="clear"></div>
				</div>
				
				<div class="box_body">
					<div id="div_main" style="width: 800px; position: relative; margin: 0 auto; overflow-x: hidden; overflow-y: hidden;">
						
						<table id="labor_cate" class="bg-image s800 center" style="position: absolute;">
							<thead>
								<tr>
									<th align="center" class="active">
										<div class="txt_left">หมวดหลัก
										<div class="right txt_right"><input type="button" class="btn_box thickbox" title="เพิ่มหมวดหลัก" value="เพิ่มหมวดหลัก" lang="../info/labor_cate.jsp?width=550&height=250"></div>
										</div><div class="clear"></div>
									</th>
								</tr>
							</thead>
							<tbody>
							<%
							Iterator iteCate = LaborCate.list().iterator(); 
							while (iteCate.hasNext()) {
								LaborCate cate = (LaborCate) iteCate.next();
							%>
								<tr>
									<td>
										<div class="lc left s700 pointer lc_<%=cate.getCate_id()%>" lang="<%=cate.getCate_id()%>" onclick="javascript: getMain(this);"><%=cate.getCate_th() + " / " + cate.getCate_en()%></div>
										<div class="right s60"><input type="button" class="btn_box" value="แก้ไข" onclick="thickbox_init(this);" lang="../info/labor_cate_edit.jsp?width=550&height=250&cate_id=<%=cate.getCate_id()%>" title="แก้ไขหมวดหลัก"></div><div class="clear"></div>
									</td>
								</tr>
							<%}%>
							</tbody>
						</table>
						
						<table id="labor_main" class="bg-image s800 center" style="position: absolute;">
							<thead>
								<tr>
									<th align="left" class="pointer">
										<div class="backLC">หมวดหลัก : <span class="LC"></span> <span class="txt_12">(คลิกเพื่อย้อนกลับ)</span></div>
									</th>
								</tr>
								<tr>
									<th align="center" class="active">
										<div class="txt_left">หมวดย่อย
										<div class="right txt_right"><input type="button" id="btn_add_main" class="btn_box thickbox" title="เพิ่มหมวดย่อย" value="เพิ่มหมวดย่อย" lang="../info/labor_main.jsp?width=550&height=250"></div>
										</div><div class="clear"></div>
									</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
						
						<table id="labor_time" class="bg-image s800 center" style="position: absolute;">
							<thead>
								<tr>
									<th align="left">
										<div class="backLM">หมวดหลัก : <span class="LC"></span></div>
										
									</th>
								</tr>
								<tr>
									<th align="left" class="pointer">
										<div class="backLM">หมวดย่อย : <span class="LM"></span> <span class="txt_12">(คลิกเพื่อย้อนกลับ)</span></div>
									</th>
								</tr>
								<tr>
									<th align="center" class="active">
										<div class="txt_left">รายการซ่อม
										<div class="right txt_right"><input type="button" id="btn_add_labor_time" class="btn_box thickbox" title="เพิ่มรายการซ่อม" value="เพิ่มรายการซ่อม" lang="../info/labor_time.jsp?width=550&height=250"></div>
										</div><div class="clear"></div>
									</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
						
					</div>
					
					<script type="text/javascript">
						var cate = $('#labor_cate');
						var main = $('#labor_main');
						var time = $('#labor_time');
						var main_body = $('#labor_main tbody');
						var time_body = $('#labor_time tbody');
						
						var lc = $('.lc');
						var div_blackLC = $('div.backLC');
						var backLC = $('.LC');
						var btn_main = $('#btn_add_main');
						var div_blackLM = $('div.backLM');
						var backLM = $('.LM');
						var btn_time = $('#btn_add_labor_time');
						
						function getMain(obj){
							var txt = $(obj).text();
							$.post('LaborManagement',{action:'GetMain',cate_id: $(obj).attr('lang')},function(lm){
								if (lm.status == 'success') {
									var data = "";
									var m = lm.laborMain;
						            for (var i = 0; i < m.length; i++) {
						            	data += '<tr><td>' +
						            			'<div class="lm left s700 pointer" lang="' + m[i].main_id + '" id="' + m[i].main_id + '" onclick="javascript: getLabor(this);">' + m[i].main_th + ' / ' + m[i].main_en + '</div>' + 
						            			'<div class="right s60"><input type="button" class="btn_box" value="แก้ไข" onclick="thickbox_init(this);" lang="../info/labor_main_edit.jsp?width=550&height=250&main_id=' + m[i].main_id + '&cate_id=' + m[i].cate_id + '" title="แก้ไขหมวดย่อย"></div><div class="clear"></div>' +
						            			'</td></tr>';
						            }
				              		main_body.html(data);
				              		backLC.text(txt);
				              		btn_main.attr('lang','../info/labor_main.jsp?width=550&height=250&cate_id=' +  $(obj).attr('lang'));
				              		cate.animate({top:'-' + cate.css('height')},1000);
									main.animate({top:'0px'},1000);
									resize_main();
								} else {
									alert(lm.message);
								}
							},'json');
						}
						
						function getLabor(obj){
							var txt = $(obj).text();
							$.post('LaborManagement',{action:'GetLabor',main_id: $(obj).attr('lang')},function(lt){
								if (lt.status == 'success') {
									var data = "";
									var m = lt.laborTime;
						            for (var i = 0; i < m.length; i++) {
						            	data += '<tr valigh="top"><td>' +
						            			'<div class="lt left s650 lt_' + m[i].labor_id + '" lang="' + m[i].labor_id + '">' + m[i].labor_id + ': ' + m[i].labor_th + ' / ' + m[i].labor_en + '</div>' + 
						            			'<div class="right s60"><input type="button" class="btn_box" value="แก้ไข" onclick="thickbox_init(this);" lang="../info/labor_time_edit.jsp?width=550&height=250&labor_id=' + m[i].labor_id + '&main_id=' + m[i].main_id + '" title="แก้ไขรายการซ่อม"></div><div class="s50 right txt_center">' + m[i].labor_hour + '</div><div class="clear"></div>' +
						            			'</td></tr>';
						            }
				              		time_body.html(data);
				              		backLM.text(txt);
				              		btn_time.attr('lang','../info/labor_time.jsp?width=550&height=250&main_id=' +  $(obj).attr('lang'));
				              		main.animate({top:'-' + main.css('height')},1000);
									time.animate({top:'0px'},1000);
									resize_time();
								} else {
									alert(lt.message);
								}
							},'json');
						}
						
						div_blackLC.click(function(){
							cate.animate({top:'0px'},1000);
							main.animate({top:cate.css('height')},1000);
							time.css({top:cate.css('height')});
							resize_cate();
						});
						
						div_blackLM.click(function(){
							main.animate({top:'0px'},1000);
							time.animate({top:main.css('height')},1000);
							resize_main();
						});
						
						function resize_cate(){
							$('#div_main').css('height',cate.css('height'));
							main.css('top',cate.css('height'));
						}
						
						function resize_main(){
							$('#div_main').css('height',main.css('height'));
							time.css({top:main.css('height')});
						}
						
						function resize_time(){
							$('#div_main').css('height',time.css('height'));
						}
						
						function init(){
							$('#div_main').animate({'height':cate.css('height')},1000);
							main.css('top',cate.css('height'));
							time.css('top',cate.css('height'));
						}
					</script>
					
				</div>
			</div>
		</div>
	</div>
	<!-- End Wrap Content -->
	
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
</body>
</html>