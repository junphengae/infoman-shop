<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.bitmap.bean.util.ImagePathUtils"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.branch.Branch" %>
<%@page import="com.bitmap.bean.sale.Models"%>
<%@page import="com.bitmap.bean.sale.Brands"%>
<%@page import="com.bitmap.bean.parts.ServiceOutsourceDetail"%>
<%@page import="com.bitmap.bean.parts.ServiceOtherDetail"%>
<%@page import="com.bitmap.bean.parts.ServiceRepair"%>
<%@page import="com.bitmap.bean.parts.ServiceRepairDetail"%>
<%@page import="com.bitmap.bean.sale.Vehicle"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.ServicePartDetail"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="com.bitmap.bean.parts.ServiceSale"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.security.SecurityUser"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%

 	Branch branchInfo = Branch.select();
	String job_id = WebUtils.getReqString(request, "id");
	
	ServiceSale entity = new ServiceSale();
	WebUtils.bindReqToEntity(entity, request);
	ServiceSale.select(entity);

	List listRepair = ServiceRepairDetail.list(entity.getId());
	List listOther = ServiceOtherDetail.list(entity.getId());
	List listPart = entity.getUIListDetail();

	ServiceRepair repair = ServiceRepair.select(entity.getId());

 %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script>
<script src="../js/number.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css">
<link href="../css/theme_print_rp.css" rel="stylesheet" type="text/css">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%//=Branch.getUIName(securProfile.getPersonal().getBranch_id())%></title>

<script type="text/javascript">
	$(function(){
		//	setTimeout('window.print()',500); 
			//setTimeout('window.close()',1000);
	});
</script>

 <style type="text/css"  media="print">
        
	        #header, #footer
	        {
	            display:none
	        }  
        
    </style>
    
    
</head>
<body style="font-size: 24px;">

<div class="wrap_print txt_28 txt_bold" style="width: 350px; border:1px ;">
	
	
<!-- ======================================= Block Code P'whan by pang=================================================== -->	
<%-- 	<div class="txt_center center">
	<img width="250" height="40" src="<%=ImagePathUtils.img_path%>/picshop/<%=entity.getBranch_id()%>.jpg?state=<%=Math.random()%>">
	</div> 
--%>
<!-- ======================================= End Block Code P'whan by pang=================================================== -->	
	


<!-- ==================================== Bagel Bill Edit by pang ============================================ -->	
	<div class="txt_center center" >
	<img width="180px" height="50px" src='../images/bikeman logo.jpg'>
	</div>
	<div style="height: 10px;" ></div>
<!-- ==================================== End Bagel Bill Edit by pang ============================================ -->
<%-- 



	
	<div class="txt_center txt_28">
		<%//=dShop.getShop_name()%>
	</div> --%>
	
<!-- ==================================== Bagel Bill Edit by pang ============================================ -->
	<div>
		<div class="txt_center txt_20 txt_bold"><h4>TAX INVOICE</h4></div>
		<div class="txt_center txt_18">Tax ID:0-1055-55158-64-4</div>
		<div class="txt_center txt_18"> <P> บริษัท ไบค์แมน จำกัด </P></div>
		<div class="txt_center txt_16">
			สำนักงานใหญ่  เลขที่ 697 ซอย ทับสุวรรณ 
			<br/>													
			ถนน อโศก-ดินแดง แขวง ดินแดง เขต ดินแดง 
			<br/>			
			จังหวัด กรุงเทพมหานคร รหัสไปรษณีย์ 10400
			<br/>
			โทรศัพท์ 02-641-7998 , 085-991-5688
			</div>
		<div class="txt_center txt_18">
			<br/>สาขา : <%=branchInfo.getName()%> <%//=branchInfo.getAddressnumber()%>
		</div>
		<div class="txt_center txt_18">โทรศัพท์ : <%=branchInfo.getPhonenumber() %></div>
		<br/>
		<div class="txt_center txt_18">ลูกค้า        : <%=entity.getCus_name()+" "+entity.getCus_surname()%></div>	
	</div>
<!-- ==================================== Bagel Bill Edit by pang ============================================ -->
	
	
<!-- ==================================== Bagel Bill Edit by pang ============================================ -->
   	<div>
	   	<div >
			<div class="left  txt_18">เลขที่บิล : <%=entity.getId()%></div>
			<div class="right txt_right s200 txt_18">ชื่อผู้ออก : <%=securProfile.getPersonal().getName()%></div>
			<div class="clear"></div>
		</div>   
	    <%
		SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd hh:mm",Locale.ENGLISH);	
		String chkDate = sdfDate.format(entity.getUpdate_date());
		%>
	    <div class="left txt_left txt_18"><%=chkDate+" น."%></div>
	    <div style="height: 15px;"><br/></div> 
	    
    </div>
<!-- ==================================== Bagel Bill Edit by pang ============================================ -->
<div>
		<hr />
		<table class="breakword">
			<thead class="txt_18 bold "  style="height: 10px;">
				<tr >
					<th width="150px" align="left" ><strong>ITEM</strong></th>
					<th width="35px" align="right"><strong>PRICE</strong></th>
					<th width="45px" align="right"><strong>QTY</strong></th>
					<th width="45px" align="right"><strong>DIS(%)</strong></th>
					<th width="75px" align="right"><strong>TOTAL</strong></th>
				</tr>
			</thead>
			<tbody >
				<tr  style="height: 2px;">
					<td  colspan="5"  >
					<hr style="height: 1px;">
					<!-- <div class="dot_line m_top5" style="font: bold;"></div> -->
					</td>
				</tr>
				<%
							boolean check_close = true;
							String total = "0";
							String total_net_price = "0";
							String total_discount = "0";
							
							String part_total_net_price = "0";
							String part_total_discount = "0";
							
							Iterator ite = listPart.iterator();
							while(ite.hasNext()) {
								ServicePartDetail detailPart = (ServicePartDetail) ite.next();
								String net_price = "0";
								String total_price = "0";
								String disc = "0";
								
								net_price = Money.multiple(detailPart.getQty(), detailPart.getPrice());
								total_price = Money.discount(net_price, detailPart.getDiscount());
								disc = Money.subtract(net_price, total_price);
								
								total_net_price = Money.add(total_net_price, net_price);
								total_discount = Money.add(total_discount, disc);
								total = Money.add(total, total_price);
						%>
						<tr  class="txt_17 h15">
								<td><%=detailPart.getUIDescription() %></td>
								<td align="right"><%=Money.money(detailPart.getPrice()) %></td>
								<td align="right"><%=detailPart.getQty()%></td>
								<td align="right"><%=detailPart.getDiscount().equalsIgnoreCase("0")?"-":detailPart.getDiscount()%></td>
								<td align="right"><%=Money.money(total_price) %></td>
						</tr>
				<%}%>
				<%
							Iterator iteSV = listRepair.iterator();
							while(iteSV.hasNext()) {

								ServiceRepairDetail detailRepair = (ServiceRepairDetail) iteSV.next();
								String net_price = "0";
								String total_price = "0";
								String disc = "0";
								total_price = Money.multiple(detailRepair.getLabor_rate(), detailRepair.getDiscount());
								total_price = Money.divide(total_price ,"100");
								total_price = Money.subtract(detailRepair.getLabor_rate(), total_price);
								total_net_price = Money.add(total_net_price, total_price);
								
							//	total_discount = Money.add(total_discount, disc);
								total = Money.add(total, total_price);
						%>
						<tr  class="txt_17 h15">
								<td><%=detailRepair.getLabor_name() %></td>
								<td align="right"><%=Money.money(detailRepair.getLabor_rate()) %></td>
								<td align="right"></td>
								<td align="right"><%=detailRepair.getDiscount().equalsIgnoreCase("0")?"-":detailRepair.getDiscount()%></td>
								<td align="right"><%=Money.money(total_price) %></td>
						</tr>
				<%}%>
				<%			
							Iterator iteOther = listOther.iterator();
							while(iteOther.hasNext()) {
								ServiceOtherDetail detailOther = (ServiceOtherDetail) iteOther.next();
								String net_price = "0";
								String total_price = "0";
								String disc = "0";
								
								net_price = Money.multiple(detailOther.getOther_qty(), detailOther.getOther_price());
								total_price = Money.discount(net_price, detailOther.getDiscount());
								disc = Money.subtract(net_price, total_price);
								
								total_net_price = Money.add(total_net_price, net_price);
								total_discount = Money.add(total_discount, disc);
								total = Money.add(total, total_price);
						%>
							<tr  class="txt_17 h15">
								<td><%=detailOther.getOther_name() %></td>
								<td align="right"><%=Money.money(detailOther.getOther_price()) %></td>
								<td align="right"><%=detailOther.getOther_qty()%></td>
								<td align="right"><%=detailOther.getDiscount().equalsIgnoreCase("0")?"-":detailOther.getDiscount()%></td>
								<td align="right"><%=Money.money(total_price) %></td>
							</tr>
						<%
							}
						%>
							<tr class="h5">
								<td  colspan="5">
									<hr/>
								</td>
							</tr>
							<tr  class="txt_17 h15">
								<td></td>
								<td align="right"></td>
								<td colspan="2">Before Disct.</td>
								<td align="right"><%=Money.money(total_net_price)%>฿</td>
							</tr>
							
							<tr  class="txt_17 h15">
								<td></td>
								<td align="right"></td>
								<td colspan="2">Discount.</td>
								<td align="right"><%=Money.money(total_discount)%>฿</td>
							</tr>
							<tr  class="txt_17 h15">
								<td></td>
								<td align="right"></td>
								<td colspan="2">Net</td>
								<td align="right"><%=Money.money(total)%>฿</td>
							</tr>
							<tr class="txt_17 h15">
								<td></td>
								<td align="right"></td>
								<td colspan="2">VAT</td>
								<td align="right"><%=(entity.getVat().equalsIgnoreCase("7"))?Money.money(Money.vat(total)):"0.00"%>฿</td>
							</tr>
							<tr  class="txt_17 h15"> 
								<td></td>
								<td align="right"></td>
								<td colspan="2" class="bold"><strong>Total Amount</strong></td>
								<td align="right">
									<strong>
										<%=(entity.getVat().equalsIgnoreCase("7"))?Money.money(Money.add(total, Money.vat(total))): Money.money(total)%>฿
									</strong>
								</td>
							</tr>
				
							<tr class="h5">
								<td  colspan="5">
									<!-- <div class="dot_line m_top5" style="font: bold;"></div>	 -->
								
								<hr>
								</td>
							</tr>
			</tbody>
		</table>
	</div>
	<div class="m_top5 center txt_center txt_18">** ขอบพระคุณลูกค้าทุกท่านที่ใช้บริการ Bikeman **</div> 
 		

</div>


</body>
</html>