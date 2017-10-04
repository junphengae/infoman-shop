<%@page import="com.bitmap.bean.hr.LeaveType"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.hr.Leave"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
String per_id = WebUtils.getReqString(request,"per_id");
String leave_type_id = WebUtils.getReqString(request, "leave_type_id");
String leave_type_id1 = WebUtils.getReqString(request, "leave_type_id1");
String year = WebUtils.getReqString(request, "year");
String month = WebUtils.getReqString(request, "month");
String page_ = WebUtils.getReqString(request, "page");

List params = new ArrayList();
params.add(new String[]{"month",month});
params.add(new String[]{"year",year});
//params.add(new String[]{"leave_type_id",leave_type_id});
//params.add(new String[]{"leave_type_id",leave_type_id1});

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);

//List list = Leave.selectWithCTRL(ctrl, params, per_id);
List list = Leave.selectByType(ctrl, params, per_id, leave_type_id, leave_type_id1);



%>
</head>
<body>

		<table class="bg-image s_auto">
			<thead>
				<tr>
					<th valign="top" align="center" width="20%">วันที่</th>
					<th valign="top" align="center" width="15%">ประเภท</th>
					<th valign="top" align="center" width="35%">สาเหตุ</th>
					<th valign="top" align="center" width="15%">สถานะ</th>
				</tr>
			</thead>
			<tbody>
				<%
				boolean has=true;
				Iterator ite = list.iterator();
				while (ite.hasNext()) {
					Leave entity = (Leave)ite.next();
					LeaveType type = entity.getUILeaveType();
					has=false;
				%>
				<tr>
					<td> <%=WebUtils.getDateValue(entity.getLeave_date()) %> </td>
					<td> <%=type.getLeave_detail() %></td>
					<td> <%=entity.getLeave_remark() %></td>
					<td> <%=Leave.StatusMap(entity.getStatus()) %></td>
				</tr>
				<%
				}
				%>
			</tbody>
		</table>

</body>
</html>