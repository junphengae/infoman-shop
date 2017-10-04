<%@page import="com.bmp.cs.promotion.PromotionTS"%>
<%@page import="com.bmp.cs.promotion.PromationBean"%>
<%@page import="com.bmp.special.fn.BMMoney"%>
<%@page import="Component.Accounting.Money.MoneyAccounting"%>
<%@page import="com.bmp.lib.base.Mformat"%>
<%@page import="com.bitmap.utils.report.Mobile"%>
<%@page import="java.util.Date"%>
<%@page import="com.bitmap.utils.report.getTimeTH"%>
<%@page import="com.bitmap.utils.report.getDateTH"%>
<%@page import="com.bitmap.bean.sale.MoneyDiscountRound"%>
<%@page import="java.text.DecimalFormat"%>
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

	PromationBean pro = PromotionTS.select();
	
 %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script>
<script src="../js/number.js"></script>
<script src="../js/two_decimal_places.js" type="text/javascript"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css">
<link href="../css/theme_print_rp.css" rel="stylesheet" type="text/css">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%//=Branch.getUIName(securProfile.getPersonal().getBranch_id())%></title>

<script type="text/javascript">
	$(function(){
		setTimeout('window.print()',500); 
		setTimeout('window.close()',1000);
	});
</script>

 <style type="text/css"  media="print">
        
	        #header, #footer
	        {
	            display:none
	        }  
        	
    </style>
    
    
</head>
<body style="font-size: 24px;  font:tahoma ;">

<div class="wrap_print txt_28 " style="width: 350px; border:1px ;">
	
	<div class="txt_center center" >
	<img width="180px" height="50px" src='../images/bikeman logo.jpg'>
	</div>
	<!-- <div style="height: 4px;" ></div> -->
	<div>
		<div class="txt_center txt_18 txt_bold" style="line-height: 16px;"><h4>ใบเสร็จรับเงิน</h4></div>
		<div class="txt_center txt_18" style="line-height: 16px;">Tax ID:0-1055-55158-64-4</div>
		<div class="txt_center txt_14" style="line-height: 12px;"> <P> บริษัท ไบค์แมน จำกัด </P></div>
		<div class="txt_center txt_14" style="line-height: 16px;">
			<div >
			สำนักงานใหญ่ (BM002-LPK) เลขที่  190  
			
			<%-- <% 	  
	 		   if(branchInfo.getName().equalsIgnoreCase("สำนักงานใหญ่")){
			%>
			 <%=branchInfo.getName()%>
			<%    
			 }else{
			
			%> 
			  สาขา<%=branchInfo.getName()%>
			<% } %>
			(<%=branchInfo.getBranch_code() %>) 
			เลขที่  <%=branchInfo.getAddressnumber() %> 
			ซอย<%=branchInfo.getSoi() %> 
			ถนน<%=branchInfo.getRoad() %> --%>
			</div>	
			<div >	
			ถนนลาดปลาเค้า แขวงจรเข้บัว เขตลาดพร้าว  จังหวัด กรุงเทพมหานคร  10230	
			<%-- 	 แขวง<%=branchInfo.getDistrict() %> 
			 เขต<%=branchInfo.getPrefecture() %> 
			 จังหวัด<%=branchInfo.getProvince() %>  
			 รหัสไปรษณีย์   <%=branchInfo.getPostalcode() %> --%>
			</div>		
			
		</div>
		<div style="line-height: 16px;">
			<div class="txt_center txt_14" ">
			โทรศัพท์ 091-747-5384    โทรสาร 02-570-0590
			<%-- โทรศัพท์ : <%=Mobile.mobile(branchInfo.getPhonenumber())%>  --%> 
			</div> 
			<div class="txt_center txt_14" ">
			<%if(branchInfo.getName().equalsIgnoreCase("สำนักงานใหญ่")){%>
			      ออกโดย<%}else{%> ออกโดยสาขา<%}%><%=branchInfo.getName()%> (<%=branchInfo.getBranch_code() %>-<%=branchInfo.getBranch_name_en()%>) 
			</div>
			<%-- <div class="txt_center txt_16">ลูกค้า        : <%=entity.getCus_name()+" "+entity.getCus_surname()%></div> --%>
	   </div>	
	</div>
   	<div style="line-height: 12px;">
	   	<div >
			<div class="left  txt_16">เลขที่บิล : <%=entity.getId()%></div>
			<div class="right txt_right s200 txt_16">ชื่อผู้ออก : <%=securProfile.getPersonal().getName()%></div>
			<div class="clear"></div>
		</div>   
		<%
		/* System.out.println("entity.getUpdate_date()::"+entity.getUpdate_date());
		
		 //String dd="10/07/2013 08:36";
		 String chkDate1  =WebUtils.getDateValue(entity.getUpdate_date());
		 String[] yy = chkDate1.split("/");
		 String Y = Money.subtract(Money.add(yy[2],"543"), "2500");
		 // //System.out.println("full : "+Y);
		 String DMY = yy[0]+"/"+yy[1]+"/"+Y;
	
			System.out.println("DMY::"+DMY); */
		
		%>
		<div >
			<div class="left  txt_16">เลขที่ใบงาน : <%=entity.getId()%></div>
			<div class="right txt_right s200 txt_16"><%=getDateTH.DateTH(entity.getJob_close_date())+" "+getTimeTH.TimeTH(entity.getJob_close_date())+" น."%></div>
			<div class="clear"></div>
		</div>   	
	   <%--  <div class="left txt_left txt_18">
	    <%=getDateTH.DateTH(entity.getUpdate_date())+" "+getTimeTH.TimeTH(entity.getUpdate_date())+" น."%>
	    </div> --%>
	    
    </div>

<div style="width: 100%; word-break:break-all" >
		<hr style="border: 1px">
		 <div align="center" style="margin-top: -8px">
		 	
		<table class="columntop txt_12"  width="100%">
			 <thead style="line-height: 8px;"> 
			 <tr>
					<th width="48%" align="left" ><strong>ITEM</strong></th> 
					<th width="15%" align="right"><strong>PRICE@</strong></th> 
					<th width="8%" align="center"><strong>QTY</strong></th>
					<th width="11%" align="right"><strong>DISC(฿)</strong></th> 
					<th width="18%" align="right"><strong>TOTAL(฿)</strong></th>
			</tr>
			 </thead>
			<tbody style="line-height: 12px;"><!-- /**แก้ ระยะห่าง**/ -->
			 <tr   > <td  colspan="5"  ><hr style="border: 1px dashed"> </td> </tr> 
				<%
						
						boolean check_close = true;
						String total_all 	="0"; //Sub Total(total)
						String discount_all	   	="0"; //Discount (discount)
						String total_amount		="0"; //Total Amount(total_amount)
						String total_price_all	="0"; //Total Price 
						String total_vat_all	="0"; //VAT 7 %	(pay)
				
						Iterator ite = listPart.iterator();
							while(ite.hasNext()) {
								
								ServicePartDetail detailPart = (ServicePartDetail) ite.next();
								if(detailPart.getTotal_price().equalsIgnoreCase("")||detailPart.getTotal_price().equalsIgnoreCase(null)){
									 
									String total_price =	BMMoney.MoneyMultiple(BMMoney.removeCommas(detailPart.getQty()), BMMoney.removeCommas(detailPart.getPrice()));
									//System.out.println(total_price);
									detailPart.setTotal_price(total_price);
									
									}
									total_all 		= Money.add(total_all, detailPart.getTotal_price());
									total_amount	= Money.add(total_amount, detailPart.getSpd_net_price());
									discount_all	= Money.add(discount_all,detailPart.getSpd_dis_total());
																
						%>
						<tr style="line-height: 12px;">
								<td align="left"  valign="top" ><%=detailPart.getUIDescription() %></td>
								<td align="right" valign="top" ><%=Money.money(detailPart.getPrice()) %></td>
								<td align="right" valign="top" ><%=detailPart.getQty()%></td>
								<td align="right" valign="top" ><%=(detailPart.getSpd_dis_total().equalsIgnoreCase("0.00")||detailPart.getSpd_dis_total().equalsIgnoreCase("0"))?"-":Money.money(detailPart.getSpd_dis_total())%></td>
								<td align="right" valign="top" ><%=Money.money(detailPart.getSpd_net_price()) %></td>
						</tr >
				<%}%>
				<%
					Iterator iteSV = listRepair.iterator();
					while(iteSV.hasNext()) {
						ServiceRepairDetail detailRepair = (ServiceRepairDetail) iteSV.next();
						
						total_all 		= Money.add(total_all, detailRepair.getLabor_rate());
						total_amount	= Money.add(total_amount, detailRepair.getSrd_net_price());
						discount_all	= Money.add(discount_all,detailRepair.getSrd_dis_total());
					
					%>
						<tr >
								<td align="left"  valign="top" ><%=detailRepair.getLabor_name() %></td>
								<td align="right"  valign="top" ><%=Money.money(detailRepair.getLabor_rate()) %></td>
								<td align="right"  valign="top" >-</td>
								<td align="right"  valign="top" ><%=(detailRepair.getSrd_dis_total().equalsIgnoreCase("0.00")||detailRepair.getSrd_dis_total().equalsIgnoreCase("0"))?"-":Money.money(detailRepair.getSrd_dis_total())%></td>
								<td align="right"  valign="top" ><%=Money.money(detailRepair.getSrd_net_price()) %></td>
						</tr>
				<%}%>
				<%			
				Iterator iteOther = listOther.iterator(); 
				while(iteOther.hasNext()) {
					ServiceOtherDetail detailOther = (ServiceOtherDetail) iteOther.next();
					if(detailOther.getTotal_price().equalsIgnoreCase("")||detailOther.getTotal_price().equalsIgnoreCase(null)){
						 
						String total_price =	BMMoney.MoneyMultiple(BMMoney.removeCommas(detailOther.getOther_qty()), BMMoney.removeCommas(detailOther.getOther_price()));
						//System.out.println(total_price);
						detailOther.setTotal_price(total_price);
						
						}
					total_all		= Money.add(total_all, detailOther.getTotal_price());
					total_amount	= Money.add(total_amount, detailOther.getSod_net_price());
					discount_all	= Money.add(discount_all,detailOther.getSod_dis_total());
						%>
							<tr >
								<td  align="left"  valign="top" ><%=detailOther.getOther_name() %></td>
								<td align="right"  valign="top" ><%=Money.money(detailOther.getOther_price()) %></td>
								<td align="right"  valign="top" ><%=detailOther.getOther_qty()%></td>
								<td align="right"  valign="top" ><%=(detailOther.getSod_dis_total().equalsIgnoreCase("0.00")||detailOther.getSod_dis_total().equalsIgnoreCase("0"))?"-":Money.money(detailOther.getSod_dis_total())%></td>
								<td align="right"  valign="top" ><%=Money.money(detailOther.getSod_net_price()) %></td>
							</tr>
						<%
							}
						%>
							 <tr style="line-height: 2px;">
								<td  colspan="5">
								<hr style="border: 0.5px ">
								</td>
							</tr> 
							
							<% 
							total_vat_all 	= BMMoney.MoneyVat(total_amount,"7");
							total_price_all = BMMoney.MoneySubtract(total_amount, total_vat_all); 	
							%>
							<tr  >
								<td width="54%" ></td>
								<td width="20%" colspan="2" align="left">Sub Total</td>
								<td width="26%" colspan="2" align="right">								
								<%=(Money.money(entity.getTotal()).equals("0.00"))?"-":Money.money(entity.getTotal())%>
								</td>
							</tr>
							
							<tr >
								<td width="54%" ></td>
								<td width="20%" colspan="2" align="left">Discount</td>
								<td width="26%" colspan="2" align="right">								
								<%=(Money.money(entity.getDiscount()).equals("0.00"))?"-":"-"+Money.money(entity.getDiscount())%>
								</td>
							
							
							</tr>
							<tr class="txt_20"  style="font:IMPACT; font-weight:bold;  " style="line-height: 2px;"> 
								<td width="54%" ></td>
								<td width="20%" colspan="2" align="left">Total Amount</td>
								<td width="26%" colspan="2" align="right">								
								<%=(Money.money(entity.getTotal_amount()).equals("0.00"))?"-":Money.money(entity.getTotal_amount())%>
								</td>
							</tr>			
							<tr  style="line-height: 2px;">
								<td  colspan="5">
								
								<hr style="border: 1px dashed">
								</td>
							</tr>
							<tr>
								
								<td width="48%" ></td>
								<td width="26%" colspan="2" align="left">Total Price</td>
								<td width="26%" colspan="2" align="right"> 
								<%=(Money.money(total_price_all).equals("0.00"))?"-":Money.money(total_price_all)%>																
								</td>
							</tr>
							<tr >
						
								<td width="48%" ></td>
								<td width="26%" colspan="2" align="left">VAT<label class="pointer" for="vat">&nbsp;7 %</label></td>
								<td width="26%" colspan="2" align="right">	
								<%=(Money.money(entity.getPay()).equals("0.00"))?"-":Money.money(entity.getPay())%>									
								
								</td>
							</tr>
							<tr  >
								<td width="48%" ></td>
								<td width="26%" colspan="2" align="left">Received</td>
								<td width="26%" colspan="2" align="right">
								<%=(Money.money(entity.getReceived()).equals("0.00"))?"-":Money.money(entity.getReceived())%>																									
								</td>
							</tr>
							<tr >
								<td width="48%" ></td>
								<td width="26%" colspan="2" align="left">Change</td>
								<td width="26%" colspan="2" align="right">
								<%=(Money.money(entity.getTotal_change()).equals("0.00"))?"-":Money.money(entity.getTotal_change())%>																									
								</td>
							</tr>
			</tbody>
		</table>
		 </div>
	</div>
	
	<!--************************* New **************************-->
	<div class="m_top5 center txt_center txt_18"><%=pro.getRemake()%></div> 
 		
 			<% 
	String prom = pro.getPromotion1()+","+pro.getPromotion2()+","+pro.getPromotion3()+","+pro.getPromotion4()+","+pro.getPromotion5();
	String[] promo = prom.split(",");	
	for (int i = 0; i < promo.length; i++) {
		if( ! (promo[i].trim()).equalsIgnoreCase("") ){
		
			%>
			<div class="m_top5 center txt_center txt_18"><%=promo[i]%></div> 
			<%
		}
	}
	%>
	
	<% 
	String img = PromotionTS.getImg(pro.getBranch_code());	
	String[] imgs = img.split(",");
	for (int i = 0; i < imgs.length; i++) {
		if( ! (imgs[i].trim()).equalsIgnoreCase("") ){
			%>
			<div class="m_top5 center txt_center txt_18">
			<img style="width: 350px;"  src="../DisplayImagePromotion?id=<%=imgs[i].replace(".jpg", "")%>">			
			</div> 
			<div class="m_top5 center txt_center txt_18">
			<label>----------</label>
			</div> 
			<%
		}		
	}
	%>
	
</div>


</body>
</html>