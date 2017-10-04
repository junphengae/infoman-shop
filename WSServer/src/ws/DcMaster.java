package ws;

import java.sql.Connection;
import java.sql.Timestamp;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bmp.web.service.bean.getBranchMasterBean;
import com.bmp.web.service.bean.getBrandMasterBean;
import com.bmp.web.service.bean.getInvUnitTypeBean;
import com.bmp.web.service.bean.getInventoryPackingBean;
import com.bmp.web.service.bean.getModelMasterBean;
import com.bmp.web.service.bean.getPartCategoriesBean;
import com.bmp.web.service.bean.getPartCategoriesSubBean;
import com.bmp.web.service.bean.getPartGroupsBean;
import com.bmp.web.service.bean.getPartMasterBean;
import com.bmp.web.service.bean.setBranchStockBean;
import com.bmp.web.service.bean.setSaleOrderServiceBean;
import com.bmp.web.service.bean.setSaleServicePartDetailBean;
import com.bmp.web.service.bean.setServiceOtherDetailBean;
import com.bmp.web.service.bean.setServicePartDetailBean;
import com.bmp.web.service.bean.setServiceRepairBean;
import com.bmp.web.service.bean.setServiceRepairDetailBean;
import com.bmp.web.service.bean.setServiceSaleBean;
import com.bmp.web.service.bean.setWebServiceReportBean;
import com.bmp.web.service.client.bean.getPaPartMasterBean;
import com.bmp.web.service.client.bean.getServiceOtherDetailBean;
import com.bmp.web.service.client.bean.getServiceRepairDetailBean;
import com.bmp.web.service.client.bean.getPurchaseOrderBean;
import com.bmp.web.service.client.bean.getPurchaseRequestBean;
import com.bmp.web.service.client.bean.getServicePartDetailBean;
import com.bmp.web.service.client.bean.getServiceRepairBean;
import com.bmp.web.service.client.bean.getServiceSaleBean;
import com.bmp.web.service.client.bean.getWebServiceUpDateBean;
import com.bmp.web.service.transaction.BranchMasterTS;
import com.bmp.web.service.transaction.BranchStockTS;
import com.bmp.web.service.transaction.BrandMasterTS;
import com.bmp.web.service.transaction.InvUnitTypeTS;
import com.bmp.web.service.transaction.InventoryPackingTS;
import com.bmp.web.service.transaction.ModelMasterTS;
import com.bmp.web.service.transaction.PartCategoriesSubTS;
import com.bmp.web.service.transaction.PartCategoriesTS;
import com.bmp.web.service.transaction.PartGroupsTS;
import com.bmp.web.service.transaction.PartMasterTS;
import com.bmp.web.service.transaction.SaleOrderServiceTS;
import com.bmp.web.service.transaction.SaleServicePartDetailTS;
import com.bmp.web.service.transaction.ServiceOtherDetailTS;
import com.bmp.web.service.transaction.ServicePartDetailTS;
import com.bmp.web.service.transaction.ServiceRepairDetailTS;
import com.bmp.web.service.transaction.ServiceRepairTS;
import com.bmp.web.service.transaction.ServiceSaleTS;
import com.bmp.web.service.transaction.WSLogUpdateTS;
import com.bmp.web.service.transaction.WebServiceReportTS;
import com.bmp.web.service.transaction.WebServiceUpdateTS;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;

public class DcMaster {

	public List<getPartMasterBean> getMasterUpdate(Date dd) throws Exception {	
		return PartMasterTS.getMasterUpdate(dd);
	}
		
	public List<getBranchMasterBean> getBranchMasterUpdate(Date dd) throws Exception {
		return BranchMasterTS.getBranchUpdate(dd);
	}

	public List<getBrandMasterBean> getBrandUpdate(Date dd) throws Exception {
		return BrandMasterTS.getBrandUpdate(dd);
	}

	public List<getModelMasterBean> getModelUpdate(Date dd) throws Exception {
		return ModelMasterTS.getModelUpdate(dd);
	}

	public List<getPartCategoriesBean> getPartCategoriesUpdate(Date dd) throws Exception {
		return PartCategoriesTS.getPartCategoriesUpdate(dd);
	}
	
	public List<getPartCategoriesSubBean> getPartCategoriesSubUpdate(Date dd) throws Exception {
		return PartCategoriesSubTS.getPartCategoriesSubUpdate(dd);
	}

	public List<getPartGroupsBean> getPartGroupsUpdate(Date dd) throws Exception {
		return PartGroupsTS.getPartGroupsUpdate(dd);
	}
	
	public List<getInventoryPackingBean> getInventoryPackings(Date dd) throws Exception {
		return InventoryPackingTS.getPackingUpdate(dd);
	}
	
	public List<getInvUnitTypeBean> getUnitTypes(Date dd) throws Exception{		
		return InvUnitTypeTS.getUnitUpdate(dd);
		
	}
	
	public String setPurchaseOrder(String json, String branch_code)	throws Exception {
		Connection conn = null;
		String status = "error";

		try {
			//System.out.println("SaleOrderService::");	
			JsonElement jsonList = new JsonParser().parse(json);
			JsonArray jsonarr = jsonList.getAsJsonArray();

			Iterator<JsonElement> itejson = jsonarr.iterator();
			
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			
			while (itejson.hasNext()) {
				JsonElement jsonElement = (JsonElement) itejson.next();
				Gson g = new Gson();
				
				getPurchaseOrderBean po = g.fromJson(jsonElement,getPurchaseOrderBean.class);
				
				if (po != null) {				
					if (SaleOrderServiceTS.check(po.getPo()+"-"+branch_code)) {
							
						setSaleOrderServiceBean saleOrder = new setSaleOrderServiceBean();

						if (po.getStatus().equalsIgnoreCase("30")) {
							//System.out.println("WS_SaleOrderService::"+po.getPo());	
							saleOrder.setId(po.getPo()+"-"+branch_code);
							saleOrder.setCus_id(branch_code);
							saleOrder.setService_type("");
							saleOrder.setCus_name("");
							saleOrder.setCus_surname("");
							saleOrder.setV_id("");
							saleOrder.setV_plate("");
							saleOrder.setV_plate_province("");
							
							saleOrder.setGross_amount(po.getGross_amount());
							saleOrder.setDiscount_pc(po.getDiscount_pc());
							saleOrder.setDiscount(po.getDiscount());
							saleOrder.setVat(po.getVat());
							saleOrder.setVat_amount(po.getVat_amount());
							saleOrder.setGrand_total(po.getGrand_total());
							saleOrder.setNet_amount(po.getNet_amount());

							if (po.getStatus().equalsIgnoreCase("30")) {
								saleOrder.setStatus("10");
							}
							saleOrder.setFlag_pay("");
							if (po.getDelivery_date() != null && !po.getDelivery_date().trim().equalsIgnoreCase("")) {
								saleOrder.setDuedate(Timestamp.valueOf(po.getDelivery_date()));
							}
							saleOrder.setCreate_by(po.getCreate_by());
							if (po.getCreate_date() != null && !po.getCreate_date().trim().equalsIgnoreCase("")) {
								saleOrder.setCreate_date(Timestamp.valueOf(po.getCreate_date()));
							}
							saleOrder.setUpdate_by(po.getUpdate_by());
							if (po.getUpdate_date() != null && !po.getUpdate_date().trim().equalsIgnoreCase("")) {
								saleOrder.setUpdate_date(Timestamp.valueOf(po.getUpdate_date()));
							}
							saleOrder.setBrand_id("");
							saleOrder.setModel_id("");
							saleOrder.setNote(po.getNote());
							// ต้องส่งไป insert ที่ SaleOrderServiceTS ไปทำการ
							// insert หรือ update
							DBUtility.updateToDB(conn,SaleOrderServiceTS.tableName, saleOrder,SaleOrderServiceTS.fieldNames,SaleOrderServiceTS.keys);
						}
						
					} else {

						setSaleOrderServiceBean saleOrder = new setSaleOrderServiceBean();

						if (po.getStatus().equalsIgnoreCase("30")) {
							//System.out.println("WS_SaleOrderService::"+po.getPo());
							saleOrder.setId(po.getPo()+"-"+branch_code);
							saleOrder.setCus_id(branch_code);
							saleOrder.setService_type("");
							saleOrder.setCus_name("");
							saleOrder.setCus_surname("");
							saleOrder.setV_id("");
							saleOrder.setV_plate("");
							saleOrder.setV_plate_province("");
							
							saleOrder.setGross_amount(po.getGross_amount());
							saleOrder.setDiscount_pc(po.getDiscount_pc());
							saleOrder.setDiscount(po.getDiscount());
							saleOrder.setVat(po.getVat());
							saleOrder.setVat_amount(po.getVat_amount());
							saleOrder.setGrand_total(po.getGrand_total());
							saleOrder.setNet_amount(po.getNet_amount());

							if (po.getStatus().equalsIgnoreCase("30")) {
								saleOrder.setStatus("10");
							}
							saleOrder.setFlag_pay("");
							if (po.getDelivery_date() != null && !po.getDelivery_date().trim().equalsIgnoreCase("") ) {
								saleOrder.setDuedate(Timestamp.valueOf(po.getDelivery_date()));
							}
							saleOrder.setCreate_by(po.getCreate_by());
							if (po.getCreate_date() != null && !po.getCreate_date().trim().equalsIgnoreCase("") ) {
								saleOrder.setCreate_date(Timestamp.valueOf(po.getCreate_date()));
							}
							saleOrder.setUpdate_by(po.getUpdate_by());
							if (po.getUpdate_date() != null && !po.getUpdate_date().trim().equalsIgnoreCase("") ) {
								saleOrder.setUpdate_date(Timestamp.valueOf(po.getUpdate_date()));
							}
							saleOrder.setBrand_id("");
							saleOrder.setModel_id("");
							saleOrder.setNote(po.getNote());
							DBUtility.insertToDB(conn,SaleOrderServiceTS.tableName, saleOrder);
							//System.out.println("SaleOrderServiceTS.tableName Insert");
						}
					}
					/***************/
					
					/***************/
				}
			}
			WebServiceUpdateTS.insertServiceUpdate(conn, SaleOrderServiceTS.tableName);
			WSLogUpdateTS.insertWSLogUpdate(conn, SaleOrderServiceTS.tableName, "success",branch_code);
			
			conn.commit();
			conn.close();
			status = "success";
			
		} catch (Exception e) {

			if (conn != null) {
				conn.rollback();
				conn.close();
			}
			status = e.getMessage();
			WSLogUpdateTS.insertWSLogUpdate(SaleOrderServiceTS.tableName,status,branch_code);
		}
		return status;
	}

	public String setPurchaseRequest(String json, String branch_code) throws Exception {
		Connection conn = null;
		String status = "error";
		try {
			JsonElement jsonList = new JsonParser().parse(json);
			JsonArray jsonarr = jsonList.getAsJsonArray();

			Iterator<JsonElement> itejson = jsonarr.iterator();
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			
			while (itejson.hasNext()) {
				JsonElement jsonElement = (JsonElement) itejson.next();
				Gson g = new Gson();
				
				getPurchaseRequestBean pr = g.fromJson(jsonElement,getPurchaseRequestBean.class);

				if (pr != null) {									
					if (SaleServicePartDetailTS.check(pr.getId()+"-"+branch_code, pr.getPo()+"-"+branch_code)) {

						setSaleServicePartDetailBean SalePart = new setSaleServicePartDetailBean();

						if (pr.getStatus().equalsIgnoreCase("30")) {
							//System.out.println("SaleServicePartDetail::"+pr.getPo());
							SalePart.setId(pr.getId()+"-"+branch_code);
							SalePart.setNumber(pr.getPo()+"-"+branch_code);
							SalePart.setPn(pr.getMat_code());
							SalePart.setQty(pr.getOrder_qty());
							SalePart.setCutoff_qty("");
							SalePart.setDiscount("");
							SalePart.setDiscount_flag("");
							SalePart.setPrice(pr.getOrder_price());
							SalePart.setCreate_by(pr.getCreate_by());
							SalePart.setUpdate_by(pr.getUpdate_by());
							if (pr.getCreate_date() != null && !pr.getCreate_date().trim().equalsIgnoreCase("")) {
								SalePart.setCreate_date(Timestamp.valueOf(pr.getCreate_date()));
							}
							if (pr.getUpdate_date() != null && !pr.getUpdate_date().trim().equalsIgnoreCase("")) {
								SalePart.setUpdate_date(Timestamp.valueOf(pr.getUpdate_date()));
							}
							if (pr.getAdd_pr_date() != null && !pr.getAdd_pr_date().trim().equalsIgnoreCase("")) {
								SalePart.setAdd_pr_date(Timestamp.valueOf(pr.getAdd_pr_date()));
							}
							if (pr.getStatus().equalsIgnoreCase("30")) {
								SalePart.setStatus("10");
							}

							SalePart.setNote(pr.getNote());
							SalePart.setBranch_code(branch_code);

							DBUtility.updateToDB(conn,SaleServicePartDetailTS.tableName, SalePart,SaleServicePartDetailTS.fieldNames,SaleServicePartDetailTS.keys);
						}

					} else {

						setSaleServicePartDetailBean SalePart = new setSaleServicePartDetailBean();

						if (pr.getStatus().equalsIgnoreCase("30")) {
							//System.out.println("SaleServicePartDetail::"+pr.getPo());
							SalePart.setId(pr.getId()+"-"+branch_code);
							SalePart.setNumber(pr.getPo()+"-"+branch_code);
							SalePart.setPn(pr.getMat_code());
							SalePart.setQty(pr.getOrder_qty());
							SalePart.setCutoff_qty("");
							SalePart.setDiscount("");
							SalePart.setDiscount_flag("");
							SalePart.setPrice(pr.getOrder_price());
							SalePart.setCreate_by(pr.getCreate_by());
							SalePart.setUpdate_by(pr.getUpdate_by());
							if (pr.getCreate_date() != null && !pr.getCreate_date().trim().equalsIgnoreCase("")) {
								SalePart.setCreate_date(Timestamp.valueOf(pr.getCreate_date()));
							}
							if (pr.getUpdate_date() != null && !pr.getUpdate_date().trim().equalsIgnoreCase("")) {
								SalePart.setUpdate_date(Timestamp.valueOf(pr.getUpdate_date()));
							}
							if (pr.getStatus().equalsIgnoreCase("30")) {
								SalePart.setStatus("10");
							}
							if (pr.getAdd_pr_date() != null && !pr.getAdd_pr_date().trim().equalsIgnoreCase("")) {
								SalePart.setAdd_pr_date(Timestamp.valueOf(pr.getAdd_pr_date()));
							}
							SalePart.setNote(pr.getNote());
							SalePart.setBranch_code(branch_code);

							DBUtility.insertToDB(conn,SaleServicePartDetailTS.tableName, SalePart);

						}
					}
				}
			}
			
			WebServiceUpdateTS.insertServiceUpdate(conn, SaleServicePartDetailTS.tableName);
			WSLogUpdateTS.insertWSLogUpdate(conn, SaleServicePartDetailTS.tableName, "success",branch_code);
			
			conn.commit();
			conn.close();
			status = "success";
		} catch (Exception e) {
			status = e.getMessage();
			WSLogUpdateTS.insertWSLogUpdate(SaleServicePartDetailTS.tableName, status,branch_code);
		}
		return status;
	}

	public String setServiceSale(String json, String branch_code) throws Exception {
		Connection conn = null;
		String status = "error";
		
		try {
			JsonElement jsonList = new JsonParser().parse(json);
			JsonArray jsonarr = jsonList.getAsJsonArray();

			Iterator<JsonElement> itejson = jsonarr.iterator();
			
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			
			while (itejson.hasNext()) {
				JsonElement jsonElement = (JsonElement) itejson.next();
				Gson g = new Gson();
				getServiceSaleBean sale = g.fromJson(jsonElement,getServiceSaleBean.class);				
				if (sale != null) {
					
					if (ServiceSaleTS.check(sale.getId()+"-"+branch_code)) {
						
						if (sale.getStatus().equalsIgnoreCase("100")) {
							
							setServiceSaleBean sale1 = new setServiceSaleBean();																				
							
							sale1.setId(sale.getId()+"-"+branch_code);							
							sale1.setService_type(sale.getService_type());							
							sale1.setCus_id(sale.getCus_id());							
							sale1.setCus_name(sale.getCus_name());							
							sale1.setCus_surname(sale.getCus_surname());							
							sale1.setAddressnumber(sale.getAddressnumber());
							sale1.setVillege(sale.getVillege());
							sale1.setDistrict(sale.getDistrict());
							sale1.setPrefecture(sale.getPrefecture());
							sale1.setProvince(sale.getProvince());
							sale1.setPostalcode(sale.getPostalcode());
							sale1.setPhonenumber(sale.getPhonenumber());
							sale1.setMoo(sale.getMoo());
							sale1.setRoad(sale.getRoad());
							sale1.setSoi(sale.getSoi());
							sale1.setV_id(sale.getV_id());
							sale1.setV_plate(sale.getV_plate());
							sale1.setV_plate_province(sale.getV_plate_province());
							sale1.setTotal(sale.getTotal());
							sale1.setVat(sale.getVat());
							sale1.setDiscount(sale.getDiscount());
							sale1.setTotal_amount(sale.getTotal_amount());
							sale1.setReceived(sale.getReceived());
							sale1.setTotal_change(sale.getTotal_change());
							sale1.setPay(sale.getPay());
							sale1.setStatus(sale.getStatus());
							sale1.setFlag_pay(sale.getFlag_pay());
														
							if (sale.getDuedate().trim() != null && !sale.getDuedate().trim().equalsIgnoreCase("")) {								
								sale1.setDuedate(Timestamp.valueOf(sale.getDuedate()));
							}
							sale1.setCreate_by(sale.getCreate_by());							
							if (sale.getCreate_date() != null && !sale.getCreate_date().trim().equalsIgnoreCase("")) {
								sale1.setCreate_date(Timestamp.valueOf(sale.getCreate_date()));
							}
							sale1.setUpdate_by(sale.getUpdate_by());
							if (sale.getUpdate_date() != null && !sale.getUpdate_date().trim().equalsIgnoreCase("")) {
								sale1.setUpdate_date(Timestamp.valueOf(sale.getUpdate_date()));
							}
							if (sale.getJob_close_date() != null && !sale.getJob_close_date().trim().equalsIgnoreCase("")) {
								sale1.setJob_close_date(Timestamp.valueOf(sale.getJob_close_date()));
							}
							sale1.setBrand_id(sale.getBrand_id());
							sale1.setModel_id(sale.getModel_id());
							
							sale1.setBranch_code(branch_code);
							sale1.setForewordname(sale.getForewordname());
							sale1.setBill_id(sale.getBill_id());
							sale1.setFlage("1");
							sale1.setTax_id(sale.getTax_id());
														
							DBUtility.updateToDB(conn, ServiceSaleTS.tableName, sale1,ServiceSaleTS.fieldNames, ServiceSaleTS.keys);							
						}
					} else {
						
						if (sale.getStatus().equalsIgnoreCase("100")) {
							
							setServiceSaleBean sale1 = new setServiceSaleBean();
														
							sale1.setId(sale.getId()+"-"+branch_code);
							sale1.setService_type(sale.getService_type());
							sale1.setCus_id(sale.getCus_id());
							sale1.setCus_name(sale.getCus_name());
							sale1.setCus_surname(sale.getCus_surname());
							
							sale1.setAddressnumber(sale.getAddressnumber());
							sale1.setVillege(sale.getVillege());
							sale1.setDistrict(sale.getDistrict());
							sale1.setPrefecture(sale.getPrefecture());
							sale1.setProvince(sale.getProvince());
							sale1.setPostalcode(sale.getPostalcode());
							sale1.setPhonenumber(sale.getPhonenumber());
							sale1.setMoo(sale.getMoo());
							sale1.setRoad(sale.getRoad());
							sale1.setSoi(sale.getSoi());
							
							sale1.setV_id(sale.getV_id());
							sale1.setV_plate(sale.getV_plate());
							sale1.setV_plate_province(sale.getV_plate_province());
							sale1.setTotal(sale.getTotal());
							sale1.setVat(sale.getVat());
							sale1.setDiscount(sale.getDiscount());
							sale1.setTotal_amount(sale.getTotal_amount());
							sale1.setReceived(sale.getReceived());
							sale1.setTotal_change(sale.getTotal_change());
							sale1.setPay(sale.getPay());
							sale1.setStatus(sale.getStatus());
							sale1.setFlag_pay(sale.getFlag_pay());
							
							if (sale.getDuedate().trim() != null && !sale.getDuedate().trim().equalsIgnoreCase("")) {								
								sale1.setDuedate(Timestamp.valueOf(sale.getDuedate()));
							}
							sale1.setCreate_by(sale.getCreate_by());							
							if (sale.getCreate_date() != null && !sale.getCreate_date().trim().equalsIgnoreCase("")) {
								sale1.setCreate_date(Timestamp.valueOf(sale.getCreate_date()));
							}
							sale1.setUpdate_by(sale.getUpdate_by());
							if (sale.getUpdate_date() != null && !sale.getUpdate_date().trim().equalsIgnoreCase("")) {
								sale1.setUpdate_date(Timestamp.valueOf(sale.getUpdate_date()));
							}
							if (sale.getJob_close_date() != null && !sale.getJob_close_date().trim().equalsIgnoreCase("")) {
								sale1.setJob_close_date(Timestamp.valueOf(sale.getJob_close_date()));
							}

							sale1.setBrand_id(sale.getBrand_id());
							sale1.setModel_id(sale.getModel_id());							
							sale1.setBranch_code(branch_code);
							sale1.setForewordname(sale.getForewordname());
							sale1.setBill_id(sale.getBill_id());
							sale1.setFlage(sale.getFlage());
							sale1.setTax_id(sale.getTax_id());
							
											
							DBUtility.insertToDB(conn,ServiceSaleTS.tableName, sale1);
						}
					}
				}
			}
			WebServiceUpdateTS.insertServiceUpdate(conn, ServiceSaleTS.tableName);
			WSLogUpdateTS.insertWSLogUpdate(conn, ServiceSaleTS.tableName, "success",branch_code);
			
			conn.commit();
			conn.close();
			status = "success";
			
		} catch (Exception e) {
			
			status = e.getMessage();
			WSLogUpdateTS.insertWSLogUpdate(ServiceSaleTS.tableName, status,branch_code);
			
		}
		return status;
	}

	public String setServiceRepair(String json, String branch_code) throws Exception {
		Connection conn = null;
		String status = "error";
		try {
			JsonElement jsonList = new JsonParser().parse(json);
			JsonArray jsonarr = jsonList.getAsJsonArray();

			Iterator<JsonElement> itejson = jsonarr.iterator();
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			
			while (itejson.hasNext()) {
				JsonElement jsonElement = (JsonElement) itejson.next();
				Gson g = new Gson();
				getServiceRepairBean SR1 = g.fromJson(jsonElement,getServiceRepairBean.class);
				if (SR1 != null) {								
					if (ServiceRepairTS.check(SR1.getId()+"-"+branch_code)) {

						setServiceRepairBean SR = new setServiceRepairBean();
						//System.out.println("note::"+SR1.getNote());
						SR.setId(SR1.getId()+"-"+branch_code);
						SR.setRepair_type(SR1.getRepair_type());
						SR.setDriven_by(SR1.getDriven_by());
						SR.setDriven_contact(SR1.getDriven_contact());
						SR.setFuel_level(SR1.getFuel_level());
						SR.setMile(SR1.getMile());
						SR.setProblem(SR1.getProblem());
						SR.setNote(SR1.getNote());
						
						if (SR1.getDue_date()  != null && !SR1.getDue_date().trim().equalsIgnoreCase("")) {
							SR.setDue_date(Timestamp.valueOf(SR1.getDue_date()));
						}
						SR.setCreate_by(SR1.getCreate_by());
						if (SR1.getCreate_date() != null && !SR1.getCreate_date().trim().equalsIgnoreCase("")) {
							SR.setCreate_date(Timestamp.valueOf(SR1.getCreate_date()));
						}
						SR.setUpdate_by(SR1.getUpdate_by());
						if (SR1.getUpdate_date() != null && !SR1.getUpdate_date().trim().equalsIgnoreCase("")) {
							SR.setUpdate_date(Timestamp.valueOf(SR1.getUpdate_date()));
						}
						
						SR.setFlag(SR1.getFlag());
						SR.setBranch_code(branch_code);

						DBUtility.updateToDB(conn,ServiceRepairTS.tableName,SR,ServiceRepairTS.fieldName,ServiceRepairTS.keys);

					} else {

						setServiceRepairBean SR = new setServiceRepairBean();
						//System.out.println("ServiceRepairCondition::"+SR1.getId());						
						SR.setId(SR1.getId()+"-"+branch_code);
						SR.setRepair_type(SR1.getRepair_type());
						SR.setDriven_by(SR1.getDriven_by());
						SR.setDriven_contact(SR1.getDriven_contact());
						SR.setFuel_level(SR1.getFuel_level());
						SR.setMile(SR1.getMile());
						SR.setProblem(SR1.getProblem());
						SR.setNote(SR1.getNote());
						
						if (SR1.getDue_date()  != null && !SR1.getDue_date().trim().equalsIgnoreCase("")) {
							SR.setDue_date(Timestamp.valueOf(SR1.getDue_date()));
						}
						SR.setCreate_by(SR1.getCreate_by());
						if (SR1.getCreate_date() != null && !SR1.getCreate_date().trim().equalsIgnoreCase("")) {
							SR.setCreate_date(Timestamp.valueOf(SR1.getCreate_date()));
						}
						SR.setUpdate_by(SR1.getUpdate_by());
						if (SR1.getUpdate_date() != null && !SR1.getUpdate_date().trim().equalsIgnoreCase("")) {
							SR.setUpdate_date(Timestamp.valueOf(SR1.getUpdate_date()));
						}
						
						SR.setFlag(SR1.getFlag());
						SR.setBranch_code(branch_code);

						DBUtility.insertToDB(conn,ServiceRepairTS.tableName, SR);
					}
				}
			}
			WebServiceUpdateTS.insertServiceUpdate(conn, ServiceRepairTS.tableName);
			WSLogUpdateTS.insertWSLogUpdate(conn, ServiceRepairTS.tableName, "success",branch_code);
			
			conn.commit();
			conn.close();
			status = "success";
		} catch (Exception e) {
			status = e.getMessage();
			WSLogUpdateTS.insertWSLogUpdate(ServiceRepairTS.tableName, status,branch_code);
		}
		return status;
	}
	public String setServicePartDetail(String json, String branch_code) throws Exception {
		Connection conn = null;
		String status = "error";
		try {
			JsonElement jsonList = new JsonParser().parse(json);
			JsonArray jsonarr = jsonList.getAsJsonArray();
			
			Iterator<JsonElement> itejson = jsonarr.iterator();
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			
			while (itejson.hasNext()) {
				JsonElement jsonElement = (JsonElement) itejson.next();
				Gson g = new Gson();
				getServicePartDetailBean SPD = g.fromJson(jsonElement,getServicePartDetailBean.class);
				
				if (SPD != null) {
					if (ServicePartDetailTS.check(SPD.getId()+"-"+branch_code, SPD.getNumber())) {

						setServicePartDetailBean SPD1 = new setServicePartDetailBean();
						//System.out.println("ServicePartDetail::"+SPD.getId());
						SPD1.setBranch_code(branch_code);
						SPD1.setId(SPD.getId()+"-"+branch_code);
						SPD1.setNumber(SPD.getNumber());
						SPD1.setPn(SPD.getPn());
						SPD1.setQty(SPD.getQty());
						SPD1.setCutoff_qty(SPD.getCutoff_qty());
						SPD1.setDiscount(SPD.getDiscount());
						SPD1.setDiscount_flag(SPD.getDiscount_flag());
						SPD1.setPrice(SPD.getPrice());
						SPD1.setCreate_by(SPD.getCreate_by());
						if (SPD.getCreate_date() != null && !SPD.getCreate_date().trim().equalsIgnoreCase("")) {
							SPD1.setCreate_date(Timestamp.valueOf(SPD.getCreate_date()));
						}
						SPD1.setUpdate_by(SPD.getUpdate_by());
						if (SPD.getUpdate_date() != null && !SPD.getUpdate_date().trim().equalsIgnoreCase("")) {
							SPD1.setUpdate_date(Timestamp.valueOf(SPD.getUpdate_date()));
						}
						
						SPD1.setVat(SPD.getVat());
						SPD1.setTotal_vat(SPD.getTotal_vat());
						SPD1.setTotal_price(SPD.getTotal_price());
						SPD1.setSpd_dis_total_before(SPD.getSpd_dis_total_before());
						
						SPD1.setSpd_net_price(SPD.getSpd_net_price());
						SPD1.setSpd_dis_total(SPD.getSpd_dis_total());
						
						DBUtility.updateToDB(conn, ServicePartDetailTS.tableName,SPD1, ServicePartDetailTS.fieldNames,ServicePartDetailTS.keys);

					} else {

						setServicePartDetailBean SPD1 = new setServicePartDetailBean();
						//System.out.println("ServicePartDetail::"+SPD.getId());
						SPD1.setBranch_code(branch_code);
						SPD1.setId(SPD.getId()+"-"+branch_code);
						SPD1.setNumber(SPD.getNumber());
						SPD1.setPn(SPD.getPn());
						SPD1.setQty(SPD.getQty());
						SPD1.setCutoff_qty(SPD.getCutoff_qty());
						SPD1.setDiscount(SPD.getDiscount());
						SPD1.setDiscount_flag(SPD.getDiscount_flag());
						SPD1.setPrice(SPD.getPrice());
						SPD1.setCreate_by(SPD.getCreate_by());
						if (SPD.getCreate_date() != null && !SPD.getCreate_date().trim().equalsIgnoreCase("")) {
							SPD1.setCreate_date(Timestamp.valueOf(SPD.getCreate_date()));
						}
						SPD1.setUpdate_by(SPD.getUpdate_by());
						if (SPD.getUpdate_date() != null && !SPD.getUpdate_date().trim().equalsIgnoreCase("")) {
							SPD1.setUpdate_date(Timestamp.valueOf(SPD.getUpdate_date()));
						}
						
						SPD1.setVat(SPD.getVat());
						SPD1.setTotal_vat(SPD.getTotal_vat());
						SPD1.setTotal_price(SPD.getTotal_price());
						SPD1.setSpd_dis_total_before(SPD.getSpd_dis_total_before());
						
						SPD1.setSpd_net_price(SPD.getSpd_net_price());
						SPD1.setSpd_dis_total(SPD.getSpd_dis_total());
						
						DBUtility.insertToDB(conn, ServicePartDetailTS.tableName,SPD1);
					}
				}
			}
			WebServiceUpdateTS.insertServiceUpdate(conn, ServicePartDetailTS.tableName);
			WSLogUpdateTS.insertWSLogUpdate(conn, ServicePartDetailTS.tableName, "success",branch_code);
			
			conn.commit();
			conn.close();
			status = "success";
		} catch (Exception e) {
			status = e.getMessage();
			WSLogUpdateTS.insertWSLogUpdate(ServicePartDetailTS.tableName,status,branch_code);
		}
		return status;
	}
	
	public String setServiceRepairDetail(String json, String branch_code)throws Exception {
		Connection conn = null;
		String status = "error";
		
		try {
			
			JsonElement jsonList = new JsonParser().parse(json);
			JsonArray jsonarr = jsonList.getAsJsonArray();

			Iterator<JsonElement> itejson = jsonarr.iterator();
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			
			while (itejson.hasNext()) {
				JsonElement jsonElement = (JsonElement) itejson.next();
				Gson g = new Gson();
				getServiceRepairDetailBean SRD = g.fromJson(jsonElement,getServiceRepairDetailBean.class);				
				if (SRD != null) {
					
					if (ServiceRepairDetailTS.check(SRD.getId()+"-"+branch_code, SRD.getNumber())) {
						
						setServiceRepairDetailBean SRD1 = new setServiceRepairDetailBean();
						//System.out.println("ServiceRepairDetail::"+SRD.getId());
						SRD1.setId(SRD.getId()+"-"+branch_code);
						SRD1.setNumber(SRD.getNumber());
						SRD1.setLabor_id(SRD.getLabor_id());
						SRD1.setLabor_name(SRD.getLabor_name());
						SRD1.setLabor_qty(SRD.getLabor_qty());
						SRD1.setLabor_rate(SRD.getLabor_rate());
						SRD1.setDiscount(SRD.getDiscount());
						SRD1.setDiscount_flag(SRD.getDiscount_flag());
						SRD1.setStatus(SRD.getStatus());
						SRD1.setNote(SRD.getNote());
						if (SRD.getDue_date() != null && !SRD.getDue_date().trim().equalsIgnoreCase("")) {
						SRD1.setDue_date(Timestamp.valueOf(SRD.getDue_date()));
						}
						SRD1.setCreate_by(SRD.getCreate_by());
						if (SRD.getCreate_date() != null && !SRD.getCreate_date().trim().equalsIgnoreCase("")) {
							SRD1.setCreate_date(Timestamp.valueOf(SRD.getCreate_date()));
						}
						SRD1.setUpdate_by(SRD.getUpdate_by());
						if (SRD.getUpdate_date() != null && !SRD.getUpdate_date().trim().equalsIgnoreCase("")) {
							SRD1.setUpdate_date(Timestamp.valueOf(SRD.getUpdate_date()));
						}
						SRD1.setBranch_code(branch_code);
						SRD1.setVat(SRD.getVat());
						SRD1.setTotal_vat(SRD.getTotal_vat());
						SRD1.setSrd_dis_total_before(SRD.getSrd_dis_total_before());
						
						SRD1.setSrd_net_price(SRD.getSrd_net_price());
						SRD1.setSrd_dis_total(SRD.getSrd_dis_total());
												
						DBUtility.updateToDB(conn,ServiceRepairDetailTS.tableName, SRD1,ServiceRepairDetailTS.fieldNames,ServiceRepairDetailTS.keys);

					} else {
						
						setServiceRepairDetailBean SRD1 = new setServiceRepairDetailBean();
						//System.out.println("ServiceRepairDetail::"+SRD.getId());
						SRD1.setId(SRD.getId()+"-"+branch_code);
						SRD1.setNumber(SRD.getNumber());
						SRD1.setLabor_id(SRD.getLabor_id());
						SRD1.setLabor_name(SRD.getLabor_name());
						SRD1.setLabor_qty(SRD.getLabor_qty());
						SRD1.setLabor_rate(SRD.getLabor_rate());
						SRD1.setDiscount(SRD.getDiscount());
						SRD1.setDiscount_flag(SRD.getDiscount_flag());
						SRD1.setStatus(SRD.getStatus());
						SRD1.setNote(SRD.getNote());
						if (SRD.getDue_date() != null && !SRD.getDue_date().trim().equalsIgnoreCase("")) {
							SRD1.setDue_date(Timestamp.valueOf(SRD.getDue_date()));
						}
						SRD1.setCreate_by(SRD.getCreate_by());
						if (SRD.getCreate_date() != null && !SRD.getCreate_date().trim().equalsIgnoreCase("")) {
							SRD1.setCreate_date(Timestamp.valueOf(SRD.getCreate_date()));
						}
						SRD1.setUpdate_by(SRD.getUpdate_by());
						if (SRD.getUpdate_date() != null && !SRD.getUpdate_date().trim().equalsIgnoreCase("")) {
							SRD1.setUpdate_date(Timestamp.valueOf(SRD.getUpdate_date()));
						}
						SRD1.setBranch_code(branch_code);
						SRD1.setVat(SRD.getVat());
						SRD1.setTotal_vat(SRD.getTotal_vat());
						SRD1.setSrd_dis_total_before(SRD.getSrd_dis_total_before());
						
						SRD1.setSrd_net_price(SRD.getSrd_net_price());
						SRD1.setSrd_dis_total(SRD.getSrd_dis_total());
												
						DBUtility.insertToDB(conn,ServiceRepairDetailTS.tableName, SRD1);
					}
					
				}
			}
			
			WebServiceUpdateTS.insertServiceUpdate(conn, ServiceRepairDetailTS.tableName);
			WSLogUpdateTS.insertWSLogUpdate(conn, ServiceRepairDetailTS.tableName, "success",branch_code);
			
			conn.commit();
			conn.close();
			status = "success";			
		} catch (Exception e) {			
			status = e.getMessage();
			WSLogUpdateTS.insertWSLogUpdate(ServiceRepairDetailTS.tableName,status,branch_code);
			
		}
		return status;
		
	}

	public String setServiceOtherDetail(String json, String branch_code)throws Exception {
		Connection conn = null;
		String status = "error";
		try {
			JsonElement jsonList = new JsonParser().parse(json);
			JsonArray jsonarr = jsonList.getAsJsonArray();

			Iterator<JsonElement> itejson = jsonarr.iterator();
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			
			while (itejson.hasNext()) {
				JsonElement jsonElement = (JsonElement) itejson.next();
				Gson g = new Gson();
				getServiceOtherDetailBean SOD = g.fromJson(jsonElement,getServiceOtherDetailBean.class);

				if (SOD != null) {
					if (ServiceOtherDetailTS.check(SOD.getId()+"-"+branch_code, SOD.getNumber())) {

						setServiceOtherDetailBean SOD1 = new setServiceOtherDetailBean();
						//System.out.println("ServiceOtherDetail::"+SOD.getId());
						SOD1.setId(SOD.getId()+"-"+branch_code);
						SOD1.setNumber(SOD.getNumber());
						SOD1.setOther_qty(SOD.getOther_qty());
						SOD1.setOther_name(SOD.getOther_name()); 
						SOD1.setOther_price(SOD.getOther_price());
						SOD1.setDiscount(SOD.getDiscount());
						SOD1.setDiscount_flag(SOD.getDiscount_flag());
						SOD1.setStatus(SOD.getStatus());
						SOD1.setNote(SOD.getNote());
						if (SOD.getDue_date() != null && !SOD.getDue_date().trim().equalsIgnoreCase("")) {
							SOD1.setDue_date( Timestamp.valueOf(SOD.getDue_date()));
						}
						SOD1.setCreate_by(SOD.getCreate_by());
						if (SOD.getCreate_date() != null && !SOD.getCreate_date().trim().equalsIgnoreCase("")) {
							SOD1.setCreate_date( Timestamp.valueOf(SOD.getCreate_date()));
						}
						SOD1.setUpdate_by(SOD.getUpdate_by());
						if (SOD.getUpdate_date() != null && !SOD.getUpdate_date().trim().equalsIgnoreCase("")) {
							SOD1.setUpdate_date( Timestamp.valueOf(SOD.getUpdate_date()));
						}
						SOD1.setBranch_code(branch_code);
						
						SOD1.setVat(SOD.getVat());
						SOD1.setTotal_vat(SOD.getTotal_vat());
						SOD1.setTotal_price(SOD.getTotal_price());
						SOD1.setSod_dis_total_before(SOD.getSod_dis_total_before());
						
						SOD1.setSod_net_price(SOD.getSod_net_price());
						SOD1.setSod_dis_total(SOD.getSod_dis_total());
						
						DBUtility.updateToDB(conn,ServiceOtherDetailTS.tableName, SOD1,ServiceOtherDetailTS.fieldNames,ServiceOtherDetailTS.keys);

					} else {

						setServiceOtherDetailBean SOD1 = new setServiceOtherDetailBean();						
						//System.out.println("ServiceOtherDetail::"+SOD.getId());
						SOD1.setId(SOD.getId()+"-"+branch_code);
						SOD1.setNumber(SOD.getNumber());
						SOD1.setOther_qty(SOD.getOther_qty());
						SOD1.setOther_name(SOD.getOther_name());
						SOD1.setOther_price(SOD.getOther_price());
						SOD1.setDiscount(SOD.getDiscount());
						SOD1.setDiscount_flag(SOD.getDiscount_flag());
						SOD1.setStatus(SOD.getStatus());
						SOD1.setNote(SOD.getNote());
						if (SOD.getDue_date() != null && !SOD.getDue_date().trim().equalsIgnoreCase("")) {
							SOD1.setDue_date( Timestamp.valueOf(SOD.getDue_date()));
						}
						SOD1.setCreate_by(SOD.getCreate_by());
						if (SOD.getCreate_date() != null && !SOD.getCreate_date().trim().equalsIgnoreCase("")) {
							SOD1.setCreate_date( Timestamp.valueOf(SOD.getCreate_date()));
						}
						SOD1.setUpdate_by(SOD.getUpdate_by());
						if (SOD.getUpdate_date() != null && !SOD.getUpdate_date().trim().equalsIgnoreCase("")) {
							SOD1.setUpdate_date( Timestamp.valueOf(SOD.getUpdate_date()));
						}
						SOD1.setBranch_code(branch_code);
						
						SOD1.setVat(SOD.getVat());
						SOD1.setTotal_vat(SOD.getTotal_vat());
						SOD1.setTotal_price(SOD.getTotal_price());
						SOD1.setSod_dis_total_before(SOD.getSod_dis_total_before());
						
						SOD1.setSod_net_price(SOD.getSod_net_price());
						SOD1.setSod_dis_total(SOD.getSod_dis_total());
						
						DBUtility.insertToDB(conn,ServiceOtherDetailTS.tableName, SOD1);
					}
				}
			}
			
			WebServiceUpdateTS.insertServiceUpdate(conn, ServiceOtherDetailTS.tableName);
			WSLogUpdateTS.insertWSLogUpdate(conn, ServiceOtherDetailTS.tableName, "success",branch_code);
			
			conn.commit();
			conn.close();
			status = "success";
		} catch (Exception e) {
			status = e.getMessage();
			WSLogUpdateTS.insertWSLogUpdate(ServiceOtherDetailTS.tableName,status,branch_code);
			
		}
		return status;
	}


	/**
	 * new 2557-01-14
	 * @param json
	 * @param branch_code
	 * @return
	 * @throws Exception 
	 */
	public String setBranchStock(String json, String branch_code)throws Exception {		
		Connection conn = null;
		String status = "error";
		try {
			JsonElement jsonList = new JsonParser().parse(json);
			JsonArray jsonarr = jsonList.getAsJsonArray();

			Iterator<JsonElement> itejson = jsonarr.iterator();
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			
			while (itejson.hasNext()) {
				JsonElement jsonElement = (JsonElement) itejson.next();
				Gson g = new Gson();
				getPaPartMasterBean BSB = g.fromJson(jsonElement,getPaPartMasterBean.class);
				
				if (BSB != null) {
					 
					if (BranchStockTS.check(BSB.getPn(),branch_code)) {					
						
						setBranchStockBean SOD1 = new setBranchStockBean();
												
						SOD1.setPn(BSB.getPn());
						SOD1.setBranch_id(branch_code);
						SOD1.setStock(BSB.getQty());
						if (BSB.getUpdate_date() != null && !BSB.getUpdate_date().trim().equalsIgnoreCase("")) {
							SOD1.setUpdate_date(Timestamp.valueOf(BSB.getUpdate_date()));
						}
						if (BSB.getCreate_date() != null && !BSB.getCreate_date().trim().equalsIgnoreCase("")) {
							SOD1.setCreate_date(Timestamp.valueOf(BSB.getCreate_date()));
						}
						SOD1.setCreate_by(BSB.getCreate_by());
						SOD1.setUpdate_by(BSB.getUpdate_by());
																		
						DBUtility.updateToDB(conn, BranchStockTS.tableName, SOD1, BranchStockTS.fieldName,BranchStockTS.keys);

					} else {	
						
						setBranchStockBean SOD1 = new setBranchStockBean();						
						SOD1.setPn(BSB.getPn());
						SOD1.setBranch_id(branch_code);
						SOD1.setStock(BSB.getQty());
						if (BSB.getUpdate_date() != null && !BSB.getUpdate_date().trim().equalsIgnoreCase("")) {
							SOD1.setUpdate_date(Timestamp.valueOf(BSB.getUpdate_date()));
						}
						if (BSB.getCreate_date() != null && !BSB.getCreate_date().trim().equalsIgnoreCase("")) {
							SOD1.setCreate_date(Timestamp.valueOf(BSB.getCreate_date()));
						}
						SOD1.setCreate_by(BSB.getCreate_by());
						SOD1.setUpdate_by(BSB.getUpdate_by());
						
						DBUtility.insertToDB(conn,BranchStockTS.tableName, SOD1);
					}					
				}
			}
			
			WebServiceUpdateTS.insertServiceUpdate(conn, BranchStockTS.tableName);
			WSLogUpdateTS.insertWSLogUpdate(conn, BranchStockTS.tableName, "success",branch_code);
			
			conn.commit();
			conn.close();
			status = "success";
			
		} catch (Exception e) {
			status = e.getMessage();
			WSLogUpdateTS.insertWSLogUpdate(BranchStockTS.tableName, status ,branch_code);
		}		
		return status;
	}
	/***********************************************************************************************/
	public String setWebServiceReport(String json, String branch_code)throws Exception {		
	Connection conn = null;
	String status = "error";
	try {
		JsonElement jsonList = new JsonParser().parse(json);
		JsonArray jsonarr = jsonList.getAsJsonArray();

		Iterator<JsonElement> itejson = jsonarr.iterator();
		conn = DBPool.getConnection();
		conn.setAutoCommit(false);
		
		while (itejson.hasNext()) {
			JsonElement jsonElement = (JsonElement) itejson.next();
			Gson g = new Gson();
			getWebServiceUpDateBean WS = g.fromJson(jsonElement,getWebServiceUpDateBean.class);
			
			if (WS != null) {
				 
				if ( WebServiceReportTS.check(branch_code,WS.getTable_name()) ) {					
											
					setWebServiceReportBean WSR = new setWebServiceReportBean();					
					
					WSR.setBranch_id(branch_code);
					WSR.setTable_sh(WS.getTable_name());
					WSR.setCount_sh(WS.getCount_sh());
					if(WS.getTable_name().equalsIgnoreCase("pur_purchase_order")){
					WSR.setTable_dc("sale_order_service");
					}else 
					if (WS.getTable_name().equalsIgnoreCase("pur_purchase_request")) {
					WSR.setTable_dc("sale_order_service_part_detail");	
					}else 
					if (WS.getTable_name().equalsIgnoreCase("branch_stock")) {
					WSR.setTable_sh("branch_stock from pa_part_master");
					WSR.setTable_dc("branch_stock");	
					}else 
					if (WS.getTable_name().equalsIgnoreCase("system_info")) {				
					WSR.setTable_dc("branch_master");	
					}else {
					WSR.setTable_dc(WS.getTable_name());	
					}
					WSR.setCount_dc(WebServiceReportTS.selectCount(conn, WSR.getTable_dc(),branch_code));
					if (WS.getSync_date() != null && !WS.getSync_date().trim().equalsIgnoreCase("")) {
						WSR.setSync_date(Timestamp.valueOf(WS.getSync_date()));
					}
					
					DBUtility.updateToDB(conn, WebServiceReportTS.tableName, WSR, WebServiceReportTS.fieldNames,WebServiceReportTS.keys);

				} else {	
					
					setWebServiceReportBean WSR = new setWebServiceReportBean();					
					
					WSR.setBranch_id(branch_code);
					WSR.setTable_sh(WS.getTable_name());
					WSR.setCount_sh(WS.getCount_sh());
					if(WS.getTable_name().equalsIgnoreCase("pur_purchase_order")){
					WSR.setTable_dc("sale_order_service");
					}else 
					if (WS.getTable_name().equalsIgnoreCase("pur_purchase_request")) {
					WSR.setTable_dc("sale_order_service_part_detail");	
					}else 
					if (WS.getTable_name().equalsIgnoreCase("branch_stock")) {
					WSR.setTable_sh("branch_stock from pa_part_master");
					WSR.setTable_dc("branch_stock");	
					}else 
					if (WS.getTable_name().equalsIgnoreCase("system_info")) {				
					WSR.setTable_dc("branch_master");	
					}else {
					WSR.setTable_dc(WS.getTable_name());	
					}
					WSR.setCount_dc(WebServiceReportTS.selectCount(conn, WSR.getTable_dc(),branch_code));
					if (WS.getSync_date() != null && !WS.getSync_date().trim().equalsIgnoreCase("")) {
						WSR.setSync_date(Timestamp.valueOf(WS.getSync_date()));
					}
															
					DBUtility.insertToDB(conn,WebServiceReportTS.tableName, WSR);
				}					
			}
		}
				
		conn.commit();
		conn.close();
		status = "success";
		
	} catch (Exception e) {
		status = e.getMessage();
	}		
	return status;
	}
	
}
