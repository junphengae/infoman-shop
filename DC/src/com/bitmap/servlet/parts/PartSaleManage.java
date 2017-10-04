package com.bitmap.servlet.parts;

import javax.servlet.ServletException;

import sun.security.krb5.internal.PAData;

import com.bitmap.bean.dc.SaleServicePartDetail;
import com.bitmap.bean.parts.PartCategories;
import com.bitmap.bean.parts.PartMaster;
import com.bitmap.bean.sale.Models;
import com.bitmap.bean.parts.PartLotControl;
import com.bitmap.bean.parts.PartVendor;
import com.bitmap.bean.parts.ServiceOtherDetail;
import com.bitmap.bean.parts.ServiceOutsourceDetail;
import com.bitmap.bean.parts.ServiceRepair;
import com.bitmap.bean.parts.ServiceRepairCondition;
import com.bitmap.bean.parts.ServiceRepairDetail;
import com.bitmap.bean.parts.ServiceSale;
import com.bitmap.bean.parts.ServicePartDetail;
import com.bitmap.bean.parts.PartSerial;
import com.bitmap.utils.Kson;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

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
					ServicePartDetail entity = new ServicePartDetail();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					ServicePartDetail.insert(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "sale_order_part_add")){
					SaleServicePartDetail entity = new SaleServicePartDetail();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					SaleServicePartDetail.insert(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "sale_part_update_detail")){
					ServicePartDetail entity = new ServicePartDetail();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					ServicePartDetail.update_detail(entity);
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
				if (checkAction(rr, "sale_order_part_delete")) {
					SaleServicePartDetail entity = new SaleServicePartDetail();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					SaleServicePartDetail.delete(entity);
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
					
					if (pn_with_sn.length > 1) {
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
							kson.setError("!Find not found PN: " + pMaster.getPn() + "");
						}
					} else {
						if(PartMaster.check(pMaster)){
							
							if(!pMaster.getQty().equalsIgnoreCase("0")){	
								if (pMaster.getSn_flag().equalsIgnoreCase(PartMaster.FLAG_NON_SN)) {
									pMaster.setUpdate_by(psd.getUpdate_by());
									ServicePartDetail.update_cutoff(psd, pMaster);
									
									// Bank
									if(PartLotControl.checkPnInJob( psd.getId(), psd.getPn() ) ) {
										pLotControl.setJob_id(psd.getId());
										pLotControl.setDraw_discount(psd.getDiscount());
										pLotControl.setDraw_price(psd.getPrice());
										//pLotControl.set
										
										PartLotControl.insert(pLotControl); // Bank insert to lotcontron
										
									}else{
										pLotControl.setJob_id(psd.getId());
										pLotControl.setDraw_discount(psd.getDiscount());
										pLotControl.setDraw_price(psd.getPrice());
										
										PartLotControl.update(pLotControl);
										//PartLotControl.insert(pLotControl); // Bank insert to lotcontron
									}
									
									
									kson.setSuccess();
								} else {
									kson.setError("!! PN: " + pMaster.getPn() + " require Serial number !!");
								}
							} else{								
								kson.setError("!! PN: " + pMaster.getPn() + " สินค้าหมด โปรดสั่งซื้อเพิ่ม");
							}
						} else {
							kson.setError("!Find not found PN: " + pMaster.getPn() + "");
						}
					}
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "withdraw_parts_sale")) {
					
					SaleServicePartDetail psd = new SaleServicePartDetail();
					PartMaster pMaster = new PartMaster();
					PartSerial pSerial = new PartSerial();
					PartLotControl pLotControl = new PartLotControl();
					WebUtils.bindReqToEntity(psd, rr.req);
					WebUtils.bindReqToEntity(pMaster, rr.req);
					WebUtils.bindReqToEntity(pLotControl, rr.req);
					
					
					SaleServicePartDetail entity = SaleServicePartDetail.select(psd.getId(), psd.getNumber());
					PartMaster part = PartMaster.select(pMaster.getPn());
					
					int cutoff_qty = 0;
					int qty = 0;
					int qty_base = 0;
					
					
						if (entity.getCutoff_qty().equalsIgnoreCase("")) {
							cutoff_qty=0;
						}else{
							cutoff_qty = Integer.parseInt(entity.getCutoff_qty());
						}
						qty = Integer.parseInt(psd.getQty())+cutoff_qty;
						qty_base = Integer.parseInt(entity.getQty());
						
						if (qty_base < qty) {
							
							kson.setError("!คุณเบิกมากกว่าจำนวนที่ให้เบิก ");
						
							}else {
								//System.out.println("เบิกได้");
								
								String[] pn_with_sn = pMaster.getPn().split("--");
								
								
								
								
								if (pn_with_sn.length > 1) {
									
									//System.out.println("Sereail Number");
									psd.setPn(pn_with_sn[0]);
									pMaster.setPn(pn_with_sn[0]);
									pSerial.setPn(pn_with_sn[0]);
									pSerial.setSn(pn_with_sn[1]);
									if(PartMaster.check(pMaster)){
										
										if(PartSerial.check(pSerial)){
											
											pMaster.setUpdate_by(psd.getUpdate_by());
											pLotControl.setJob_id(psd.getId());
											pLotControl.setPn(pn_with_sn[0]);
											pLotControl.setSn(pn_with_sn[1]);
											pLotControl.setDraw_discount(psd.getDiscount());
											pLotControl.setDraw_price(psd.getPrice());
											pLotControl.setDraw_qty(psd.getQty());
											
											PartLotControl.insert(pLotControl); // Bank insert to lotcontron
											
											SaleServicePartDetail.update_cutoff_sn(psd, pSerial, pMaster);
											
											
											kson.setSuccess();
										} else {
											kson.setError("PN: " + pSerial.getPn() + " not found SN: " + pSerial.getSn() + "");
										}
									} else {
										kson.setError("!Find not found PN: " + pMaster.getPn() + "");
									}
								} else {
									
									///System.out.println("ไม่มี Sereail Number");
										
									if(PartMaster.check(pMaster)){
										
										//System.out.println("มี Part Number");
										
										if(!pMaster.getQty().equalsIgnoreCase("0")){
											
											int spd_qty = Integer.parseInt(psd.getQty());
											int part_qty = Integer.parseInt(part.getQty());
											//System.out.println("spd_qty::"+spd_qty);
											//System.out.println("part_qty::"+part_qty);
											
											if(part_qty < spd_qty){
												
												kson.setError("!สินค้าคงคลังน้อยกว่าจำนวนที่เบิก");
												
											}else{
													//System.out.println("Part Number ไม่เท่ากับ 0");
													if (pMaster.getSn_flag().equalsIgnoreCase(PartMaster.FLAG_NON_SN)) {
														pMaster.setUpdate_by(psd.getUpdate_by());
														SaleServicePartDetail.update_cutoff(psd, pMaster);
														
														// Bank
														if(!PartLotControl.check(psd.getId(), psd.getPn()) ) {
															
															
															pLotControl.setJob_id(psd.getId());
															pLotControl.setDraw_discount(psd.getDiscount());
															pLotControl.setDraw_price(psd.getPrice());
															pLotControl.setDraw_qty(psd.getQty());
															PartLotControl.insert(pLotControl); // Bank insert to lotcontron
															
														}else{
														
															pLotControl.setJob_id(psd.getId());
															pLotControl.setDraw_discount(psd.getDiscount());
															pLotControl.setDraw_price(psd.getPrice());
															pLotControl.setDraw_qty(psd.getQty());
															
															PartLotControl.update(pLotControl);
															//PartLotControl.insert(pLotControl); // Bank insert to lotcontron
														}
														
														
														kson.setSuccess();
													} else {
														kson.setError("!! PN: " + pMaster.getPn() + " require Serial number !!");
													}
											}
										} else{								
											kson.setError("!! PN: " + pMaster.getPn() + " สินค้าหมด โปรดสั่งซื้อเพิ่ม");
										}
									} else {
										kson.setError("!Find not found PN: " + pMaster.getPn() + "");
									}
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
							kson.setError("!Find not found PN: " + pMaster.getPn() + "");
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
							kson.setError("!Find not found PN: " + pMaster.getPn() + "");
						}
					}
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "return_parts_sale")) {
					
					
					SaleServicePartDetail psd = new SaleServicePartDetail();
					PartMaster pMaster = new PartMaster();
					PartSerial pSerial = new PartSerial();
					
					WebUtils.bindReqToEntity(psd, rr.req);
					WebUtils.bindReqToEntity(pMaster, rr.req);
					
					String[] pn_with_sn = pMaster.getPn().split("--");
					
					//System.out.println("return_qty :"+psd.getQty());
					
					if (pn_with_sn.length > 1) {
						//System.out.println("return_มีsn :"+psd.getQty());
						psd.setPn(pn_with_sn[0]);
						pMaster.setPn(pn_with_sn[0]);
						pSerial.setPn(pn_with_sn[0]);
						pSerial.setSn(pn_with_sn[1]);
						
						if(PartMaster.check(pMaster)){
							if(PartSerial.check(pSerial)){
								pMaster.setUpdate_by(psd.getUpdate_by());
								SaleServicePartDetail.update_cutoff_sn(psd, pSerial, pMaster);
								kson.setSuccess();
							} else {
								kson.setError("PN: " + pSerial.getPn() + " not found SN: " + pSerial.getSn() + "");
							}
						} else {
							kson.setError("!Find not found PN: " + pMaster.getPn() + "");
						}
						
					} else {
						//System.out.println("return_ไม่มีsn :"+psd.getQty());
						if(PartMaster.check(pMaster)){
							//System.out.println("return_pn :"+psd.getQty());
							if (pMaster.getSn_flag().equalsIgnoreCase(PartMaster.FLAG_NON_SN)) {
								
								pMaster.setUpdate_by(psd.getUpdate_by());
								SaleServicePartDetail.update_backoff(psd, pMaster);
								kson.setSuccess();
							} else {
								
								kson.setError("!! PN: " + pMaster.getPn() + " require Serial number !!");
							}
							
						} else {
							kson.setError("!Find not found PN: " + pMaster.getPn() + "");
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
							kson.setError("!Find not found PN: " + pMaster.getPn() + "");
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
							kson.setError("!Find not found PN: " + pMaster.getPn() + "");
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
					
					ServiceRepairDetail.insert(entity);
			
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "sale_service_update")){
					ServiceRepairDetail entity = new ServiceRepairDetail();
					WebUtils.bindReqToEntity(entity, rr.req);
					
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
					
					ServiceOtherDetail.insert(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "sale_other_update")){
					ServiceOtherDetail entity = new ServiceOtherDetail();
					WebUtils.bindReqToEntity(entity, rr.req);
					
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
					ServiceSale.closeJob(entity);
					
					kson.setSuccess();
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