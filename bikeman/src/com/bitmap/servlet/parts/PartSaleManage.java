package com.bitmap.servlet.parts;

import javax.servlet.ServletException;

import Component.Accounting.Money.MoneyAccounting;

import com.bitmap.bean.parts.PartMaster;
import com.bitmap.bean.sale.Models;
import com.bitmap.bean.sale.MoneyDiscountRound;
import com.bitmap.bean.util.SaleJobCusName;
import com.bitmap.bean.parts.PartLotControl;
import com.bitmap.bean.parts.ServiceOtherDetail;
import com.bitmap.bean.parts.ServiceOutsourceDetail;
import com.bitmap.bean.parts.ServiceRepair;
import com.bitmap.bean.parts.ServiceRepairCondition;
import com.bitmap.bean.parts.ServiceRepairDetail;
import com.bitmap.bean.parts.ServiceSale;
import com.bitmap.bean.parts.ServicePartDetail;
import com.bitmap.bean.parts.PartSerial;
import com.bitmap.utils.Money;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;
import com.bmp.customer.service.bean.ServicePartDetailBean;
import com.bmp.customer.service.transaction.ServicePartDetailTS;
import com.bmp.special.fn.BMMoney;
import com.bmp.utils.reference.bean.BmpAmphurBean;
import com.bmp.utils.reference.bean.BmpProvinceBean;
import com.bmp.utils.reference.bean.BmpTumbolBean;
import com.bmp.utits.reference.transaction.BmpAmphurTS;
import com.bmp.utits.reference.transaction.BmpProvinceTS;
import com.bmp.utits.reference.transaction.BmpTumbolTS;

/**
 * Servlet implementation class PartSale
 */
public class PartSaleManage extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public PartSaleManage() {
        super();
    }
	
	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (isAction(rr)) {
				if (checkAction(rr, "create_sale_order")) {

					
					ServiceSale entity = new ServiceSale();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					SaleJobCusName  cus = new SaleJobCusName();
					WebUtils.bindReqToEntity(cus, rr.req);
					
					if (cus.getForewordname().equalsIgnoreCase("4")) {						
						entity.setForewordname(cus.getTitle_name());
					}else{
						entity.setForewordname(cus.getForewordname());
					}

					String bmp_tum_cd = entity.getDistrict();
					String bmp_ampr_cd = entity.getPrefecture();
					String bmp_pt_gov_cd = entity.getProvince();
				
					/**************เพิ่ม****************/
					entity.setProvince_cd(entity.getProvince());
					entity.setPrefecture_cd(entity.getPrefecture());
					entity.setDistrict_cd(entity.getDistrict());
					entity.setV_plate_province_cd(entity.getV_plate_province());
					
					BmpProvinceBean Province_V = BmpProvinceTS.Select_name(entity.getV_plate_province());
					entity.setV_plate_province(Province_V.getBmp_pt_name());
					
					
					BmpProvinceBean Province = BmpProvinceTS.Select_name(entity.getProvince());
					entity.setProvince(Province.getBmp_pt_name());
					
					
					BmpAmphurBean Prefecture = BmpAmphurTS.Select_name(bmp_ampr_cd, bmp_pt_gov_cd);
					entity.setPrefecture(Prefecture.getBmp_ampr_name());
					
					BmpTumbolBean TumbolName = BmpTumbolTS.Select_name(bmp_tum_cd, bmp_ampr_cd, bmp_pt_gov_cd);
					entity.setDistrict(TumbolName.getBmp_tum_name());

					//******************************//*
					
					
					
					 
					ServiceSale.insert(entity);
					if (entity.getService_type().equalsIgnoreCase(ServiceSale.SERVICE_MA)) {
						ServiceRepair.insert(entity);
					}
					ServiceSale.confirm_order(entity);
					
					ServiceRepair repair = new ServiceRepair();
					WebUtils.bindReqToEntity(repair, rr.req);
					repair.setId(entity.getId());
					ServiceRepair.update(repair);
					
					kson.setSuccess();
					kson.setGson("id", entity.getId());
					rr.outTH(kson.getJson());
				
				}
				if (checkAction(rr, "restatus")) {
					
					ServiceSale entity = new ServiceSale();
					WebUtils.bindReqToEntity(entity, rr.req);
					ServiceSale.Restatus(entity);
					kson.setSuccess();
					rr.outTH(kson.getJson());
					
					
				}
				if (checkAction(rr, "create_sale_order_forward")) {

					ServiceSale entity = new ServiceSale();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					SaleJobCusName  cus = new SaleJobCusName();
					WebUtils.bindReqToEntity(cus, rr.req);
					
					if (cus.getForewordname().equalsIgnoreCase("4")) {						
						entity.setForewordname(cus.getTitle_name());
					}else{
						entity.setForewordname(cus.getForewordname());
					}
					
					String bmp_tum_cd = entity.getDistrict();
					String bmp_ampr_cd = entity.getPrefecture();
					String bmp_pt_gov_cd = entity.getProvince();
				
					/**************เพิ่ม****************/
					entity.setProvince_cd(entity.getProvince());
					entity.setPrefecture_cd(entity.getPrefecture());
					entity.setDistrict_cd(entity.getDistrict());
					entity.setV_plate_province_cd(entity.getV_plate_province());
					
					BmpProvinceBean Province_V = BmpProvinceTS.Select_name(entity.getV_plate_province());
					entity.setV_plate_province(Province_V.getBmp_pt_name());
					
					
					BmpProvinceBean Province = BmpProvinceTS.Select_name(entity.getProvince());
					entity.setProvince(Province.getBmp_pt_name());
					
					
					BmpAmphurBean Prefecture = BmpAmphurTS.Select_name(bmp_ampr_cd, bmp_pt_gov_cd);
					entity.setPrefecture(Prefecture.getBmp_ampr_name());
					
					BmpTumbolBean TumbolName = BmpTumbolTS.Select_name(bmp_tum_cd, bmp_ampr_cd, bmp_pt_gov_cd);
					entity.setDistrict(TumbolName.getBmp_tum_name());

					//******************************//*
					
					
					
					 
					ServiceSale.insert(entity);
					if (entity.getService_type().equalsIgnoreCase(ServiceSale.SERVICE_MA)) {
						ServiceRepair.insert(entity);
					}
					ServiceSale.confirm_order(entity);
					
					ServiceRepair repair = new ServiceRepair();
					WebUtils.bindReqToEntity(repair, rr.req);
					repair.setId(entity.getId());
					ServiceRepair.update(repair);
					
					kson.setSuccess();
					kson.setGson("id", entity.getId());
					rr.outTH(kson.getJson());
					
					
				}
				if (checkAction(rr, "update_customer")) {
					ServiceSale entity = new ServiceSale();
					WebUtils.bindReqToEntity(entity, rr.req);
										ServiceSale.update_customer(entity);
					kson.setSuccess();
					
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "sale_part_add")){
					
					ServicePartDetailBean entity = new ServicePartDetailBean();
					WebUtils.bindReqToEntity(entity, rr.req);
					System.out.println("###### sale_part_add ######");
					if(ServicePartDetail.checkDiscount(entity.getId(), entity.getPn(), Money.money(entity.getDiscount())) == true) {
						
						String qty_base = ServicePartDetail.selectQty(entity.getId(), entity.getPn(), Money.money(entity.getDiscount()));
						
						int sum_qty = (Integer.parseInt(qty_base) + Integer.parseInt(entity.getQty()));
					    String str_qty = String.valueOf(sum_qty);	
					    //System.out.println("###### sale_part_add update ######");   					   
						/************************* New 28-02-2557 **********************************/
					    String discount = BMMoney.removeCommas( Money.money(entity.getDiscount()) ); // DIS(%)						 	
					 	String total_price = BMMoney.MoneyMultiple(BMMoney.removeCommas( entity.getPrice() ),BMMoney.removeCommas( str_qty ));// PRICE * QTY
					 	String dis_bat_before = BMMoney.MoneyDiscount(total_price, discount);//(PRICE * DIS(%))/100
					 	String dis_bat_after = null;
						if(Double.parseDouble(discount) > 0.00 && Double.parseDouble(entity.getCash_discount()) > 0.00){ 		//<---DISCOUNT %  and CASH DISCOUNT
					 		dis_bat_after = MoneyAccounting.MoneyCeilSatangDiscount(entity.getSpd_dis_total());
					 	}else if (Double.parseDouble(discount) <= 0.00 && Double.parseDouble(entity.getCash_discount()) > 0.00){//<---CASH DISCOUNT only
					 		dis_bat_after = MoneyAccounting.MoneyCeilSatangDiscount(entity.getCash_discount());
					 	}else if (Double.parseDouble(discount) > 0.00 && Double.parseDouble(entity.getCash_discount()) <= 0.00){//<---DISCOUNT % only
					 		dis_bat_after = BMMoney.MoneyDiscountRound(total_price, discount);
					 	}else{
					 		dis_bat_after = "0";
					 	}
					 	
					 	String net_price = BMMoney.MoneySubtract(total_price, dis_bat_after);//PRICE - Round
					 	String total_vat = BMMoney.MoneyVat(net_price,entity.getVat()) ;// (net_price*7)/107
					 	
					 	entity.setUpdate_by(entity.getCreate_by());
					 	entity.setQty(BMMoney.removeCommas(Money.moneyInteger(str_qty)));// UP DATE QTY ( EDIT )
					 	entity.setDiscount(discount);
					 	entity.setTotal_vat(BMMoney.removeCommas( Money.money(total_vat) ));
					 	entity.setTotal_price(BMMoney.removeCommas( Money.money(total_price) ));
					 	entity.setSpd_dis_total_before(BMMoney.removeCommas( Money.money(dis_bat_before) ));
					 	entity.setSpd_dis_total(BMMoney.removeCommas( Money.money(dis_bat_after) ));
					 	
					 	entity.setSpd_net_price(BMMoney.removeCommas( Money.money(net_price) ));
					    				    
						ServicePartDetailTS.updatePartdetail(entity);
						
						kson.setSuccess();
						rr.out(kson.getJson());
					}else{
						
							
						/************************* New 28-02-2557 **********************************/
							String discount = BMMoney.removeCommas( Money.money(entity.getDiscount()) );				 	
						 	String total_price = BMMoney.MoneyMultiple(BMMoney.removeCommas( entity.getQty() ), BMMoney.removeCommas( entity.getPrice() ));
						 	String dis_bat_before = BMMoney.MoneyDiscount(total_price, discount);
						 	String dis_bat_after = null;
						 	if(Double.parseDouble(discount) > 0.00 && Double.parseDouble(entity.getCash_discount()) > 0.00){ 		//<---DISCOUNT %  and CASH DISCOUNT
						 		dis_bat_after = MoneyAccounting.MoneyCeilSatangDiscount(entity.getSpd_dis_total());
						 	}else if (Double.parseDouble(discount) <= 0.00 && Double.parseDouble(entity.getCash_discount()) > 0.00){//<---CASH DISCOUNT only
						 		dis_bat_after = MoneyAccounting.MoneyCeilSatangDiscount(entity.getCash_discount());
						 	}else if (Double.parseDouble(discount) > 0.00 && Double.parseDouble(entity.getCash_discount()) <= 0.00){//<---DISCOUNT % only
						 		dis_bat_after = BMMoney.MoneyDiscountRound(total_price, discount);
						 	}else{
						 		dis_bat_after = "0";
						 	}
						 	
						 	
						 	String net_price = BMMoney.MoneySubtract(total_price, dis_bat_after);
						 	String total_vat = BMMoney.MoneyVat(net_price,entity.getVat()) ;
						 	
						 	entity.setDiscount(discount);
						 	entity.setTotal_vat(BMMoney.removeCommas( Money.money(total_vat) ));
						 	entity.setTotal_price(BMMoney.removeCommas( Money.money(total_price) ));
						 	entity.setSpd_dis_total_before(BMMoney.removeCommas( Money.money(dis_bat_before) ));
						 	entity.setSpd_dis_total(BMMoney.removeCommas( Money.money(dis_bat_after) ));
						 	entity.setSpd_net_price(BMMoney.removeCommas( Money.money(net_price) ));
						 	 //System.out.println("###### sale_part_add insert ######");   						 					 							 	
							ServicePartDetailTS.insertPart(entity);
							
							kson.setSuccess();
							rr.out(kson.getJson());

					}
					
					
				}
				
				if (checkAction(rr, "closedraw")){
					//************** ปิดโดยที่ยังเบิกของไม่ครบ  ******************/
					ServicePartDetail entity = new ServicePartDetail();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					String cutoff_qty = entity.getCutoff_qty();
					String id = entity.getId();
					String number = entity.getNumber();
					String pn = entity.getPn();
													
					ServicePartDetail spd = ServicePartDetail.selectid_pn(id, pn);
					entity.setQty(cutoff_qty);
					entity.setId(id);
					entity.setPn(pn);
					entity.setNumber(number);
					
					/*//====== คำนวน  Net Price  =======//
					//total_price
					String total_price  = Money.multiple(cutoff_qty, spd.getPrice());
					
					//net_price 
					String net_price = MoneyDiscountRound.disRound(total_price, Money.money(spd.getDiscount()));
					//String net_price = Money.discount(total_price, spd.getDiscount());
					
					String netprice1 = Money.money(net_price);
					String netprice = netprice1.replace(",", "");
					String discount = Money.subtract(total_price, net_price);
					
					entity.setSpd_net_price(netprice.replaceAll(",","")); 
					entity.setSpd_dis_total(Money.money(discount).replaceAll(",",""));*/
					
					String discount = BMMoney.removeCommas( Money.money(spd.getDiscount()) );				 	
				 	String total_price = BMMoney.MoneyMultiple(BMMoney.removeCommas( cutoff_qty ), BMMoney.removeCommas( spd.getPrice() ));
				 	String dis_bat_before = BMMoney.MoneyDiscount(total_price, discount);
				 	String dis_bat_after = BMMoney.MoneyDiscountRound(total_price, discount);
				 	String net_price = BMMoney.MoneySubtract(total_price, dis_bat_after);
				 	String total_vat = BMMoney.MoneyVat(net_price,spd.getVat()) ;
					
				 	entity.setDiscount(discount);
				 	entity.setTotal_vat(BMMoney.removeCommas( Money.money(total_vat) ));
				 	entity.setTotal_price(BMMoney.removeCommas( Money.money(total_price) ));
				 	entity.setSpd_dis_total_before(BMMoney.removeCommas( Money.money(dis_bat_before) ));
				 	entity.setSpd_dis_total(BMMoney.removeCommas( Money.money(dis_bat_after) ));
				 	entity.setSpd_net_price(BMMoney.removeCommas( Money.money(net_price) ));
				    										
					ServicePartDetail.update_closewithdraw(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				
				if (checkAction(rr, "sale_part_update_detail")){
					ServicePartDetailBean entity = new ServicePartDetailBean();
					WebUtils.bindReqToEntity(entity, rr.req);
										
					/************************* New 28-02-2557 **********************************/
				    String discount = BMMoney.removeCommas( Money.money(entity.getDiscount()) );						 	
				 	String total_price = BMMoney.MoneyMultiple(BMMoney.removeCommas( entity.getQty() ), BMMoney.removeCommas( entity.getPrice() ));
				 	String dis_bat_before = BMMoney.MoneyDiscount(total_price, discount);
				 	String dis_bat_after = null;
					if(Double.parseDouble(discount) > 0.00 && Double.parseDouble(entity.getCash_discount()) > 0.00){ 		//<---DISCOUNT %  and CASH DISCOUNT
				 		dis_bat_after = MoneyAccounting.MoneyCeilSatangDiscount(entity.getSpd_dis_total());
				 	}else if (Double.parseDouble(discount) <= 0.00 && Double.parseDouble(entity.getCash_discount()) > 0.00){//<---CASH DISCOUNT only
				 		dis_bat_after = MoneyAccounting.MoneyCeilSatangDiscount(entity.getCash_discount());
				 	}else if (Double.parseDouble(discount) > 0.00 && Double.parseDouble(entity.getCash_discount()) <= 0.00){//<---DISCOUNT % only
				 		dis_bat_after = BMMoney.MoneyDiscountRound(total_price, discount);
				 	}else{
				 		dis_bat_after = "0";
				 	}
				 	String net_price = BMMoney.MoneySubtract(total_price, dis_bat_after);
				 	String total_vat = BMMoney.MoneyVat(net_price,entity.getVat()) ;
				 					 			 	
				 	entity.setDiscount(discount);
				 	entity.setTotal_vat(BMMoney.removeCommas( Money.money(total_vat) ));
				 	entity.setTotal_price(BMMoney.removeCommas( Money.money(total_price) ));
				 	entity.setSpd_dis_total_before(BMMoney.removeCommas( Money.money(dis_bat_before) ));
				 	entity.setSpd_dis_total(BMMoney.removeCommas( Money.money(dis_bat_after) ));
				 	entity.setSpd_net_price(BMMoney.removeCommas( Money.money(net_price) ));
				    
				 	ServicePartDetailTS.updatePartdetail(entity, true);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "sale_part_delete")) {
					ServicePartDetail entity = new ServicePartDetail();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					ServicePartDetail.delete(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "sale_part_confirm")) {
					ServiceSale entity = new ServiceSale();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					entity.setStatus(ServiceSale.STATUS_REQUEST);
					ServiceSale.confirm_order(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "cancel_condition")) {
					ServiceSale entity = new ServiceSale();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					entity.setStatus(ServiceSale.STATUS_CANCEL);
					ServiceSale.confirm_order(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "get_models")) {
					String brand_id = WebUtils.getReqString(rr.req, "brand_id");
					kson.setSuccess();
					kson.setGson("model", gson.toJson(Models.selectList(brand_id)));
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "withdraw_parts")) {
					ServicePartDetail psd = new ServicePartDetail();
					PartMaster pMaster = new PartMaster();
					PartSerial pSerial = new PartSerial();
					PartLotControl pLotControl = new PartLotControl();
					
					WebUtils.bindReqToEntity(psd, rr.req);
					WebUtils.bindReqToEntity(pMaster, rr.req);
					WebUtils.bindReqToEntity(pLotControl, rr.req);
			
					
					String[] pn_with_sn = pMaster.getPn().split("--");
					
					//pMaster = pMaster.checkqty(pMaster);	
					
					
					if (pn_with_sn.length > 1) {
						//System.out.println("Sn.Leg > 1");
						psd.setPn(pn_with_sn[0]);
						pMaster.setPn(pn_with_sn[0]);
						pSerial.setPn(pn_with_sn[0]);
						pSerial.setSn(pn_with_sn[1]);
						if(PartMaster.check(pMaster)){
							if(PartSerial.check(pSerial)){
								
								pMaster.setUpdate_by(psd.getUpdate_by());
								ServicePartDetail.update_cutoff_sn(psd, pSerial, pMaster);
								
								pLotControl.setJob_id(psd.getId());
								pLotControl.setPn(pn_with_sn[0]);
								pLotControl.setSn(pn_with_sn[1]);
								pLotControl.setDraw_discount(psd.getDiscount());
								pLotControl.setDraw_price(psd.getPrice());
								//pLotControl.set
								
								PartLotControl.insert(pLotControl); // Bank insert to lotcontron
								
								
								kson.setSuccess();
							} else {
								kson.setError("PN: " + pSerial.getPn() + " not found SN: " + pSerial.getSn() + "");
							}
						} else {
							kson.setError("หมายเลขอะไหล่ไม่ถูกต้อง: " + pMaster.getPn() + "");
						}
					} else {
						if(PartMaster.check(pMaster)){
					
							if(!pMaster.getQty().equalsIgnoreCase("0")){	

							
								if (pMaster.getSn_flag().equalsIgnoreCase(PartMaster.FLAG_NON_SN)) {

								
									pMaster.setUpdate_by(psd.getUpdate_by());
									ServicePartDetail.update_cutoff(psd, pMaster);
									
									
									// Bank
						
										pLotControl.setJob_id(psd.getId());
										pLotControl.setDraw_discount(psd.getDiscount());
										pLotControl.setDraw_price(psd.getPrice());
										

								
										PartLotControl.insert(pLotControl); // Bank insert to lotcontron
										
								
									kson.setSuccess();
								} else {
									kson.setError("!! PN: " + pMaster.getPn() + " require Serial number !!");
								}
							} else{								
								kson.setError("!! PN: " + pMaster.getPn() + " สินค้าหมด โปรดสั่งซื้อเพิ่ม");
							}
						} else {
							kson.setError("หมายเลขอะไหล่ไม่ถูกต้อง: " + pMaster.getPn() + "");
						}
					}
					rr.outTH(kson.getJson());
				}
				
				
				if (checkAction(rr, "return_parts")) {
					ServicePartDetail psd = new ServicePartDetail();
					PartMaster pMaster = new PartMaster();
					PartSerial pSerial = new PartSerial();
					
					WebUtils.bindReqToEntity(psd, rr.req);
					WebUtils.bindReqToEntity(pMaster, rr.req);
					
					String[] pn_with_sn = pMaster.getPn().split("--");
					
					if (pn_with_sn.length > 1) {
						psd.setPn(pn_with_sn[0]);
						pMaster.setPn(pn_with_sn[0]);
						pSerial.setPn(pn_with_sn[0]);
						pSerial.setSn(pn_with_sn[1]);
					
						if(PartMaster.check(pMaster)){
							if(PartSerial.check(pSerial)){
								pMaster.setUpdate_by(psd.getUpdate_by());
								ServicePartDetail.update_cutoff_sn(psd, pSerial, pMaster);
								kson.setSuccess();
							} else {
								kson.setError("PN: " + pSerial.getPn() + " not found SN: " + pSerial.getSn() + "");
							}
						} else {
							kson.setError("หมายเลขอะไหล่ไม่ถูกต้อง: " + pMaster.getPn() + "");
						}
					} else {
						if(PartMaster.check(pMaster)){
							if (pMaster.getSn_flag().equalsIgnoreCase(PartMaster.FLAG_NON_SN)) {
								pMaster.setUpdate_by(psd.getUpdate_by());
								ServicePartDetail.update_backoff(psd, pMaster);
								kson.setSuccess();
							} else {
								kson.setError("!! PN: " + pMaster.getPn() + " require Serial number !!");
							}
						} else {
							kson.setError("หมายเลขอะไหล่ไม่ถูกต้อง: " + pMaster.getPn() + "");
						}
					}
					rr.outTH(kson.getJson());
				}
				
				
				
				if (checkAction(rr, "claim_parts")) {
					ServicePartDetail psd = new ServicePartDetail();
					PartMaster pMaster = new PartMaster();
					PartSerial pSerial = new PartSerial();
					
					WebUtils.bindReqToEntity(psd, rr.req);
					WebUtils.bindReqToEntity(pMaster, rr.req);
					
					String[] pn_with_sn = pMaster.getPn().split("--");
					
					pMaster = pMaster.checkqty(pMaster);		
					
					if (pn_with_sn.length > 1) {
						psd.setPn(pn_with_sn[0]);
						pMaster.setPn(pn_with_sn[0]);
						pSerial.setPn(pn_with_sn[0]);
						pSerial.setSn(pn_with_sn[1]);
					
						if(PartMaster.check(pMaster)){
							if(PartSerial.check(pSerial)){								
								pMaster.setUpdate_by(psd.getUpdate_by());
								ServicePartDetail.update_cutoff_sn(psd, pSerial, pMaster);
								kson.setSuccess();
							} else {
								kson.setError("PN: " + pSerial.getPn() + " not found SN: " + pSerial.getSn() + "");
							}
						} else {
							kson.setError("หมายเลขอะไหล่ไม่ถูกต้อง: " + pMaster.getPn() + "");
						}
					} else {
						if(PartMaster.check(pMaster)){
							
							if(!pMaster.getQty().equalsIgnoreCase("0")){	
								if (pMaster.getSn_flag().equalsIgnoreCase(PartMaster.FLAG_NON_SN)) {
									pMaster.setUpdate_by(psd.getUpdate_by());
									ServicePartDetail.update_claim(psd, pMaster);
									kson.setSuccess();
								} else {
									kson.setError("!! PN: " + pMaster.getPn() + " require Serial number !!");
								}
							} else{								
								kson.setError("!! PN: " + pMaster.getPn() + " require Add Stock !!");
							}
						} else {
							kson.setError("หมายเลขอะไหล่ไม่ถูกต้อง: " + pMaster.getPn() + "");
						}
					}
					rr.outTH(kson.getJson());
				}
				
				
				if (checkAction(rr, "create_condition")) {
					ServiceRepairCondition entity = new ServiceRepairCondition();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					ServiceRepairCondition.insert(entity);
					
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "update_condition")) {
					ServiceRepairCondition entity = new ServiceRepairCondition();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					ServiceRepairCondition.update(entity);
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "delete_condition")) {
					ServiceRepairCondition entity = new ServiceRepairCondition();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					ServiceRepairCondition.delete(entity);
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "update_service_repair")) {
					
					
					ServiceSale entity = new ServiceSale();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					/************************************  เพิ่ม *****************************************************/					
					SaleJobCusName  cus = new SaleJobCusName();
					WebUtils.bindReqToEntity(cus, rr.req);
					
					if (cus.getForewordname().equalsIgnoreCase("4")) {						
						entity.setForewordname(cus.getTitle_name());
					}else{
						entity.setForewordname(cus.getForewordname());
					}
					
					
					String bmp_tum_cd = entity.getDistrict();
					String bmp_ampr_cd = entity.getPrefecture();
					String bmp_pt_gov_cd = entity.getProvince();
				
					/**************เพิ่ม****************/
					entity.setProvince_cd(entity.getProvince());
					entity.setPrefecture_cd(entity.getPrefecture());
					entity.setDistrict_cd(entity.getDistrict());
					entity.setV_plate_province_cd(entity.getV_plate_province());
					
					BmpProvinceBean Province_V = BmpProvinceTS.Select_name(entity.getV_plate_province());
					entity.setV_plate_province(Province_V.getBmp_pt_name());
					
					
					BmpProvinceBean Province = BmpProvinceTS.Select_name(entity.getProvince());
					entity.setProvince(Province.getBmp_pt_name());
					
					
					BmpAmphurBean Prefecture = BmpAmphurTS.Select_name(bmp_ampr_cd, bmp_pt_gov_cd);
					entity.setPrefecture(Prefecture.getBmp_ampr_name());
					
					BmpTumbolBean TumbolName = BmpTumbolTS.Select_name(bmp_tum_cd, bmp_ampr_cd, bmp_pt_gov_cd);
					entity.setDistrict(TumbolName.getBmp_tum_name());

					//******************************//*					
					
					ServiceSale.update_sale(entity);
					/************************************  เพิ่ม *****************************************************/	
					
					ServiceSale.confirm_order(entity);
					
					ServiceRepair repair = new ServiceRepair();
					WebUtils.bindReqToEntity(repair, rr.req);
					ServiceRepair.update(repair);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "sale_service_add")){
					
					ServiceRepairDetail entity = new ServiceRepairDetail();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					/*String default_vat = "100";				
					//====== คำนวน  Net Price  =======//
					String net_price = MoneyDiscountRound.disRound(entity.getLabor_rate(), Money.money(entity.getDiscount()));
					//String net_price = Money.discount(entity.getLabor_rate(), entity.getDiscount());
										   
					String netprice = Money.money(net_price.replace(",", ""));		
					String discount = Money.subtract(entity.getLabor_rate(), net_price);
					String vat_unit = Money.add(default_vat, entity.getVat());
					String total_vat = Money.divide(Money.multiple(netprice, entity.getVat()),vat_unit);
									       
					entity.setTotal_vat(String.format("%.2f",Double.parseDouble(total_vat.replaceAll(",",""))).replaceAll(",",""));
					entity.setSrd_dis_total(Money.money(discount).replaceAll(",",""));
					entity.setSrd_net_price(netprice.replaceAll(",","")); */
					
					/********************************** New 28-02-2557 *******************************************/
					String discount = BMMoney.removeCommas( Money.money(entity.getDiscount()) ); // DIS(%)						 	
					String labor_rate = BMMoney.removeCommas( Money.money(entity.getLabor_rate()) ); // PRICE(฿)	
					String dis_bat_before = BMMoney.MoneyDiscount(labor_rate, discount);//(PRICE * DIS(%))/100
					String dis_bat_after = BMMoney.MoneyDiscountRound(labor_rate, discount); //(PRICE * DIS(%))/100 ---> Round


					if(Double.parseDouble(discount) > 0.00 && Double.parseDouble(entity.getCash_discount()) > 0.00){ 		//<---DISCOUNT %  and CASH DISCOUNT
				 		dis_bat_after = MoneyAccounting.MoneyCeilSatangDiscount(entity.getSrd_dis_total());
				 	}else if (Double.parseDouble(discount) <= 0.00 && Double.parseDouble(entity.getCash_discount()) > 0.00){//<---CASH DISCOUNT only
				 		dis_bat_after = MoneyAccounting.MoneyCeilSatangDiscount(entity.getCash_discount());
				 	}else if (Double.parseDouble(discount) > 0.00 && Double.parseDouble(entity.getCash_discount()) <= 0.00){//<---DISCOUNT % only
				 		dis_bat_after = BMMoney.MoneyDiscountRound(labor_rate, discount);
				 	}else{
				 		dis_bat_after = "0";
				 	}
					String net_price = BMMoney.MoneySubtract(labor_rate, dis_bat_after);//PRICE - Round
					String total_vat = BMMoney.MoneyVat(net_price,entity.getVat()) ;// (net_price*7)/107
					entity.setDiscount(discount);
					entity.setLabor_rate( BMMoney.removeCommas( Money.money(labor_rate)) );
					entity.setSrd_dis_total_before( BMMoney.removeCommas( Money.money(dis_bat_before)) );
					entity.setSrd_dis_total( BMMoney.removeCommas( Money.money(dis_bat_after)) );
					entity.setSrd_net_price( BMMoney.removeCommas( Money.money(net_price)) );
					entity.setTotal_vat( BMMoney.removeCommas( Money.money(total_vat)) );
					
					
					ServiceRepairDetail.insert(entity);
										
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "sale_service_update")){
					ServiceRepairDetail entity = new ServiceRepairDetail();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					/*String default_vat = "100";
					
					//====== คำนวน  Net Price  =======//
					String net_price = MoneyDiscountRound.disRound(entity.getLabor_rate(), Money.money(entity.getDiscount()));
					//String net_price = Money.discount(entity.getLabor_rate(), entity.getDiscount());
					
					String netprice = Money.money(net_price.replace(",", ""));		
					String discount = Money.subtract(entity.getLabor_rate(), net_price);
					String vat_unit = Money.add(default_vat, entity.getVat());
					String total_vat = Money.divide(Money.multiple(netprice, entity.getVat()),vat_unit);
									       
					entity.setTotal_vat(String.format("%.2f",Double.parseDouble(total_vat)).replaceAll(",",""));
					entity.setSrd_dis_total(Money.money(discount).replaceAll(",",""));
					entity.setSrd_net_price(netprice.replaceAll(",","")); */
					
					/********************************** New 28-02-2557 *******************************************/
					String discount = BMMoney.removeCommas( Money.money(entity.getDiscount()) ); // DIS(%)						 	
					String labor_rate = BMMoney.removeCommas( Money.money(entity.getLabor_rate()) ); // PRICE(฿)	
					String dis_bat_before = BMMoney.MoneyDiscount(labor_rate, discount);//(PRICE * DIS(%))/100
					String dis_bat_after = BMMoney.MoneyDiscountRound(labor_rate, discount); //(PRICE * DIS(%))/100 ---> Round
					
					if(Double.parseDouble(discount) > 0.00 && Double.parseDouble(entity.getCash_discount()) > 0.00){ 		//<---DISCOUNT %  and CASH DISCOUNT
				 		dis_bat_after = MoneyAccounting.MoneyCeilSatangDiscount(entity.getSrd_dis_total());
				 	}else if (Double.parseDouble(discount) <= 0.00 && Double.parseDouble(entity.getCash_discount()) > 0.00){//<---CASH DISCOUNT only
				 		dis_bat_after = MoneyAccounting.MoneyCeilSatangDiscount(entity.getCash_discount());
				 	}else if (Double.parseDouble(discount) > 0.00 && Double.parseDouble(entity.getCash_discount()) <= 0.00){//<---DISCOUNT % only
				 		dis_bat_after = BMMoney.MoneyDiscountRound(labor_rate, discount);
				 	}else{
				 		dis_bat_after = "0";
				 	}
					String net_price = BMMoney.MoneySubtract(labor_rate, dis_bat_after);//PRICE - Round
					String total_vat = BMMoney.MoneyVat(net_price,entity.getVat()) ;// (net_price*7)/107
					
					entity.setDiscount(discount);
					entity.setLabor_rate( BMMoney.removeCommas( Money.money(labor_rate)) );
					entity.setSrd_dis_total_before( BMMoney.removeCommas( Money.money(dis_bat_before)) );
					entity.setSrd_dis_total( BMMoney.removeCommas( Money.money(dis_bat_after)) );
					entity.setSrd_net_price( BMMoney.removeCommas( Money.money(net_price)) );
					entity.setTotal_vat( BMMoney.removeCommas( Money.money(total_vat)) );
					
					
					ServiceRepairDetail.update_detail(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "sale_service_delete")) {
					ServiceRepairDetail entity = new ServiceRepairDetail();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					ServiceRepairDetail.delete(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "sale_other_add")){
					ServiceOtherDetail entity = new ServiceOtherDetail();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					/*String default_vat = "100";
					//====== คำนวน  Net Price  =======//
					// total_price
						String total_price = Money.multiple(entity.getOther_qty(), entity.getOther_price());
					
					//net price
						String net_price = MoneyDiscountRound.disRound(total_price, Money.money(entity.getDiscount()));
						//String net_price = Money.discount(entity.getLabor_rate(), entity.getDiscount());
						
						String netprice = Money.money(net_price.replace(",", ""));		
						String vat_unit = Money.add(default_vat, entity.getVat());
						String total_vat = Money.divide(Money.multiple(netprice, entity.getVat()),vat_unit);
						String discount = Money.subtract(total_price, net_price);
						
						entity.setSod_dis_total(Money.money(discount).replaceAll(",",""));
						entity.setSod_net_price(netprice.replaceAll(",",""));
						entity.setTotal_vat(String.format("%.2f",Double.parseDouble(total_vat)).replaceAll(",",""));*/
					
					/********************************** New 28-02-2557 *******************************************/
					String discount = BMMoney.removeCommas( Money.money(entity.getDiscount()) ); // DIS(%)						 	
					String total_price = BMMoney.MoneyMultiple(BMMoney.removeCommas(entity.getOther_price()),BMMoney.removeCommas(entity.getOther_qty()));// PRICE * QTY
					String dis_bat_before = BMMoney.MoneyDiscount(total_price, discount);//(PRICE * DIS(%))/100
					String dis_bat_after = BMMoney.MoneyDiscountRound(total_price, discount); //(PRICE * DIS(%))/100 ---> Round

					if(Double.parseDouble(discount) > 0.00 && Double.parseDouble(entity.getCash_discount()) > 0.00){ 		//<---DISCOUNT %  and CASH DISCOUNT
				 		dis_bat_after = MoneyAccounting.MoneyCeilSatangDiscount(entity.getSod_dis_total());
				 	}else if (Double.parseDouble(discount) <= 0.00 && Double.parseDouble(entity.getCash_discount()) > 0.00){//<---CASH DISCOUNT only
				 		dis_bat_after = MoneyAccounting.MoneyCeilSatangDiscount(entity.getCash_discount());
				 	}else if (Double.parseDouble(discount) > 0.00 && Double.parseDouble(entity.getCash_discount()) <= 0.00){//<---DISCOUNT % only
				 		dis_bat_after = BMMoney.MoneyDiscountRound(total_price, discount);
				 	}else{
				 		dis_bat_after = "0";
				 	}
					String net_price = BMMoney.MoneySubtract(total_price, dis_bat_after);//PRICE - Round
					String total_vat = BMMoney.MoneyVat(net_price,entity.getVat()) ;// (net_price*7)/107
					
					entity.setDiscount(discount);
					entity.setTotal_price( BMMoney.removeCommas( Money.money(total_price)) );
					entity.setSod_dis_total_before( BMMoney.removeCommas( Money.money(dis_bat_before)) );
					entity.setSod_dis_total( BMMoney.removeCommas( Money.money(dis_bat_after)) );
					entity.setSod_net_price( BMMoney.removeCommas( Money.money(net_price)) );
					entity.setTotal_vat( BMMoney.removeCommas( Money.money(total_vat)) );
					
					
					ServiceOtherDetail.insert(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "sale_other_update")){
					ServiceOtherDetail entity = new ServiceOtherDetail();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					/*
					String default_vat = "100";
					
					
					//====== คำนวน  Net Price  =======//
					// total_price
						String total_price = Money.multiple(entity.getOther_qty(), entity.getOther_price());
					
					//net price
						String net_price = MoneyDiscountRound.disRound(total_price, Money.money(entity.getDiscount()));
						//String net_price = Money.discount(entity.getLabor_rate(), entity.getDiscount());
						
						String netprice = Money.money(net_price.replace(",", ""));		
						String vat_unit = Money.add(default_vat, entity.getVat());
						String total_vat = Money.divide(Money.multiple(netprice, entity.getVat()),vat_unit);
						String discount = Money.subtract(total_price, net_price);
						
						entity.setSod_dis_total(Money.money(discount).replaceAll(",",""));
						entity.setSod_net_price(netprice.replaceAll(",",""));
						entity.setTotal_vat(String.format("%.2f",Double.parseDouble(total_vat)).replaceAll(",",""));
					*/
					
					/********************************** New 28-02-2557 *******************************************/
					String discount = BMMoney.removeCommas( Money.money(entity.getDiscount()) ); // DIS(%)						 	
					String total_price = BMMoney.MoneyMultiple(BMMoney.removeCommas(entity.getOther_price()),BMMoney.removeCommas(entity.getOther_qty()));// PRICE * QTY
					String dis_bat_before = BMMoney.MoneyDiscount(total_price, discount);//(PRICE * DIS(%))/100
					String dis_bat_after = BMMoney.MoneyDiscountRound(total_price, discount); //(PRICE * DIS(%))/100 ---> Round

					if(Double.parseDouble(discount) > 0.00 && Double.parseDouble(entity.getCash_discount()) > 0.00){ 		//<---DISCOUNT %  and CASH DISCOUNT
				 		dis_bat_after = MoneyAccounting.MoneyCeilSatangDiscount(entity.getSod_dis_total());
				 	}else if (Double.parseDouble(discount) <= 0.00 && Double.parseDouble(entity.getCash_discount()) > 0.00){//<---CASH DISCOUNT only
				 		dis_bat_after = MoneyAccounting.MoneyCeilSatangDiscount(entity.getCash_discount());
				 	}else if (Double.parseDouble(discount) > 0.00 && Double.parseDouble(entity.getCash_discount()) <= 0.00){//<---DISCOUNT % only
				 		dis_bat_after = BMMoney.MoneyDiscountRound(total_price, discount);
				 	}else{
				 		dis_bat_after = "0";
				 	}
					String net_price = BMMoney.MoneySubtract(total_price, dis_bat_after);//PRICE - Round
					String total_vat = BMMoney.MoneyVat(net_price,entity.getVat()) ;// (net_price*7)/107
					entity.setDiscount(discount);
					entity.setTotal_price( BMMoney.removeCommas( Money.money(total_price)) );
					entity.setSod_dis_total_before( BMMoney.removeCommas( Money.money(dis_bat_before)) );
					entity.setSod_dis_total( BMMoney.removeCommas( Money.money(dis_bat_after)) );
					entity.setSod_net_price( BMMoney.removeCommas( Money.money(net_price)) );
					entity.setTotal_vat( BMMoney.removeCommas( Money.money(total_vat)) );
					
					/*System.out.println(" Discount : "+entity.getDiscount());
					System.out.println(" Total_price : "+entity.getTotal_price());
					System.out.println(" Sod_dis_total_before : "+entity.getSod_dis_total_before());
					System.out.println(" Sod_dis_total : "+entity.getSod_dis_total());
					System.out.println(" Sod_net_price : "+entity.getSod_net_price());
					System.out.println(" Total_vat : "+entity.getDiscount());*/
					
					ServiceOtherDetail.update_detail(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "sale_other_delete")) {
					ServiceOtherDetail entity = new ServiceOtherDetail();
					WebUtils.bindReqToEntity(entity, rr.req);
				
					ServiceOtherDetail.delete(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "sale_outsource_add")){
					ServiceOutsourceDetail entity = new ServiceOutsourceDetail();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					ServiceOutsourceDetail.insert(entity);
					
					ServiceSale ss = new ServiceSale();
					WebUtils.bindReqToEntity(ss, rr.req);
					ss.setStatus(ServiceSale.STATUS_OUTSOURCE);
					ss.setUpdate_by(entity.getCreate_by());
					ServiceSale.update_status(ss);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "sale_outsource_receive")){
					ServiceOutsourceDetail entity = new ServiceOutsourceDetail();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					ServiceOutsourceDetail.update_receive(entity);
					ServiceSale ss = new ServiceSale();
					WebUtils.bindReqToEntity(ss, rr.req);
					ss.setStatus(ServiceSale.STATUS_MA_REQUEST);
					ServiceSale.update_status(ss);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "sale_outsource_update")){
					ServiceOutsourceDetail entity = new ServiceOutsourceDetail();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					ServiceOutsourceDetail.update_detail(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "sale_outsource_delete")) {
					ServiceOutsourceDetail entity = new ServiceOutsourceDetail();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					ServiceOutsourceDetail.delete(entity);
					
					ServiceOutsourceDetail.update_receive(entity);
					ServiceSale ss = new ServiceSale();
					WebUtils.bindReqToEntity(ss, rr.req);
					ss.setStatus(ServiceSale.STATUS_MA_REQUEST);
					ServiceSale.update_status(ss);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "job_save")) {
					
					ServiceSale entity = new ServiceSale();
					WebUtils.bindReqToEntity(entity, rr.req);
					ServiceSale.save_order(entity);
					
					kson.setSuccess();
					rr.out(kson.getJson());
					
				}

				if (checkAction(rr, "job_open")) {
					ServiceSale entity = new ServiceSale();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					if (entity.getService_type().equalsIgnoreCase(ServiceSale.SERVICE_MA)) {
						entity.setStatus(ServiceSale.STATUS_MA_REQUEST);
					} else {
						entity.setStatus(ServiceSale.STATUS_REQUEST);
					}
					
					ServiceSale.update_status(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "job_close")) {
					ServiceSale entity = new ServiceSale();
					WebUtils.bindReqToEntity(entity, rr.req);					
					entity.setStatus(ServiceSale.STATUS_CLOSED);

					entity.setReceived(BMMoney.removeCommas( Money.money(entity.getReceived()) ));
					entity.setTotal_amount(BMMoney.removeCommas( Money.money(entity.getTotal_amount()) ));
					entity.setTotal_change(BMMoney.removeCommas( Money.money(entity.getTotal_change()) ));
					
					Double NewTotalCH = Double.parseDouble(entity.getReceived()) - Double.parseDouble(entity.getTotal_amount());
					entity.setTotal_change( NewTotalCH.toString() );
					
					
					ServiceOtherDetail.UpdateDate(entity.getUpdate_by(),entity.getId());
					ServiceRepair.UpdateDate(entity.getUpdate_by(),entity.getId());
					ServiceRepairDetail.UpdateDate(entity.getUpdate_by(),entity.getId());
					
					ServiceSale.closeJob(entity);
					
								
					kson.setSuccess();
					rr.out(kson.getJson());
					
				}

				if (checkAction(rr, "print_bill")) {
					
					
						ServiceSale entity = new ServiceSale();
						WebUtils.bindReqToEntity(entity, rr.req);	
						
						ServiceSale sale = ServiceSale.select(entity.getId());
						
						if(sale.getFlage().equalsIgnoreCase("1")){
							
								kson.setError("!ใบเสร็จอย่างเต็มเคยพิมพ์ไปแล้ว");						
							
						}else{
							
							entity.setJob_close_date(sale.getJob_close_date());
							ServiceSale.print_bill(entity);
							kson.setSuccess();
							
						}
						
						rr.out(kson.getJson());
						
					
				}
				if(checkAction(rr, "update_discount")){
					try {
						String name_table = WebUtils.getReqString(rr.req, "name_table");
						String start = WebUtils.getReqString(rr.req, "start");
						String end = WebUtils.getReqString(rr.req, "end");
						if( name_table.equalsIgnoreCase("service_other_detail") ){
							ServiceOtherDetail.updateDiscount(start,end);
							kson.setSuccess();
						}else if( name_table.equalsIgnoreCase("service_part_detail") ){
							ServicePartDetail.updateDiscount(start,end);
							kson.setSuccess();
						}else if( name_table.equalsIgnoreCase("service_repair_detail") ){
							ServiceRepairDetail.updateDiscount(start,end);
							kson.setSuccess();
						}else{
							kson.setError("กรุณาทำรายการใหม่อีกครั้ง !");
						}
						
						rr.outTH(kson.getJson());
					} catch (Exception e) {
						kson.setError("ไม่สามารถอัพเดตข้อมูลได้ กรุณาทำรายการใหม่อีกครั้ง !");	
						rr.outTH(kson.getJson());
					}
				}
			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}
}
