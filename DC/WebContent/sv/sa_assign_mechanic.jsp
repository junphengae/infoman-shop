<%@page import="com.bitmap.bean.service.MechanicTimeLine"%>
<%@page import="com.bitmap.bean.service.Mechanic"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.service.LaborTime"%>
<%@page import="com.bitmap.bean.customerService.RepairOrder"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Assign Mechanic</title>
<%
	String id = WebUtils.getReqString(request,"id");
	String labor_id = WebUtils.getReqString(request,"labor_id");
	String number = WebUtils.getReqString(request,"number");
	String divideCheck = "false";
	
	RepairOrder repair_order = RepairOrder.select(id);
	LaborTime laborTime = LaborTime.select(labor_id);
%>
<script type="text/javascript">
function onSelect(){
	var $mechanic = $('#tbody input:checkbox:checked');
	var $div_divide = $('#div_divide');
	
	if ($mechanic.size() > 1) {
		$div_divide.children('#divide').removeAttr('disabled');
	} else {
		$div_divide.children('#divide').attr({'disabled':'disabled'}).removeAttr('checked');
	}
}
</script>
</head>
<body>
	<table class="bg-image txt_13" width="100%" style="color: #fff;">
		<thead>
			<tr>
				<th width="15%" align="left" style="font: 14px bold; padding: 3px;">ชื่อช่าง</th>
				<th width="85%" align="center" style="font: 14px bold; padding: 3px;">ตารางงาน</th>
			</tr>
		</thead>
		<tbody id="tbody">
			<%
				int i = 0;
				Iterator iteMec = Personal.listMechanic().iterator();
				while(iteMec.hasNext()){
					Mechanic mec = (Mechanic)iteMec.next();
					
					String check = "";
					String show_hour = "";
					
					Iterator iteLabor = mec.getUITimeLine().iterator();
					while(iteLabor.hasNext()){
						MechanicTimeLine laborMec = (MechanicTimeLine)iteLabor.next();
						double hour = Double.parseDouble(laborMec.getLabor_hour());
						int width = 130;
						if (hour >= 0.00) {width = 30;}
						if (hour >= 0.5) {width = 45;}
						if (hour >= 1) {width = 60;}
						if (hour >= 2) {width = 75;}
						if (hour >= 3) {width = 90;}
						if (hour >= 4) {width = 110;}
						if (hour >= 5) {width = 130;}
						
						if(laborMec.getId().equalsIgnoreCase(id) && laborMec.getNumber().equalsIgnoreCase(number) && laborMec.getLabor_id().equalsIgnoreCase(labor_id)){
							check = " checked='checked'";
							i++;
							if(!laborMec.getLabor_hour().equalsIgnoreCase(laborTime.getLabor_hour())){
								divideCheck = "true";
							}
						}
						
						show_hour += "<div class='left txt_center' style='width:" + width + "px; background-color:#aa3333; margin: 3px; border: 1px solid #888;' title='" + laborMec.getId() + " - " + laborMec.getLabor_id() + "[" + laborMec.getLabor_hour() + "]'>" + laborMec.getLabor_hour() + "</div>";
					}
			%>
			<tr>
				<td align="left">
					<input type="checkbox" name="mec" value="<%=mec.getPer_id()%>_<%=mec.getName()%>" <%=check%> onclick="javascript: onSelect();"> <%=mec.getName()%>
					</td>
				<td>
					<%=show_hour%>
					<div class="clear"></div>
				</td>
			</tr>
			<%
				}
			%>
		</tbody>
	</table>
	<div class="center s200 txt_center" style="margin-top: 5px;">
		<div id="div_divide" style="margin: 10px;"><input type="checkbox" name="divide" id="divide" value="divide" <%=(divideCheck.equalsIgnoreCase("true"))?"checked='checked":"" %> <%=(i>=2)?"":"disabled"%>> หารชั่วโมง</div>
		<input  type="button" class="btn_box btn_confirm" value="ตกลง" onclick="assign();">
		<input type="button" class="btn_box btn_warn" value="ยกเลิก" onclick="tb_remove();">
		<input type="hidden" id="assign_id" value="<%=id%>">
		<input type="hidden" id="assign_labor" value="<%=labor_id%>">
		<input type="hidden" id="assign_number" value="<%=number%>">
	</div>
	<div class="center s200 txt_center" style="margin-top: 10px;">
		<input type="button" class="btn_box btn_confirm" value="ส่งซ่อมศูนย์นอก" onclick="outsource();">
	</div>
	<script type="text/javascript">
	function outsource(){
		if (confirm('ยืนยันการขอส่งซ่อมศูนย์นอก!')) {
			var $id = $('#assign_id').val();
			var $labor_id = $('#assign_labor').val();
			var $number = $('#assign_number').val();
			
			var sendData = {action:'outsource_status',id:$id,number:$number,labor_id:$labor_id,update_by:$('#create_by').val()};
			
			ajax_load();
			$.post('ServiceAdvisor',sendData,function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location.reload();
				} else {
					alert(resData.message);
				}
			},'json');
		}
	}
	</script>
</body>
</html>