package com.bmp.web.service.client.sevrlet;

import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.SQLException;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

import com.bmp.web.service.bean.setSystemInfoBean;
import com.bmp.web.service.bean.WebServiceUpdateBean;
import com.bmp.web.service.transaction.BranchStockTS;
import com.bmp.web.service.transaction.BrandMasterTS;
import com.bmp.web.service.transaction.InvUnitTypeTS;
import com.bmp.web.service.transaction.InventoryPackingTS;
import com.bmp.web.service.transaction.ModelMasterTS;
import com.bmp.web.service.transaction.PartCategoriesSubTS;
import com.bmp.web.service.transaction.PartCategoriesTS;
import com.bmp.web.service.transaction.PartGroupsTS;
import com.bmp.web.service.transaction.PartMasterTS;
import com.bmp.web.service.transaction.PurchaseOrderTS;
import com.bmp.web.service.transaction.PurchaseRequestTS;
import com.bmp.web.service.transaction.ServiceOtherDetailTS;
import com.bmp.web.service.transaction.ServicePartDetailTS;
import com.bmp.web.service.transaction.ServiceRepairDetailTS;
import com.bmp.web.service.transaction.ServiceRepairTS;
import com.bmp.web.service.transaction.ServiceSaleTS;
import com.bmp.web.service.transaction.SystemInfoTS;
import com.bmp.web.service.transaction.WSLogUpdateTS;
import com.bmp.web.service.transaction.WebServiceUpdateTS;

import javax.servlet.ServletException;

/**
 * Servlet implementation class CallWSSevrlet
 */
public class CallWSSevrlet extends ServletUtils {
	private static final long serialVersionUID = 1L;

    public CallWSSevrlet() {
        super();
    }

	@Override
	public void doPost(ReqRes rr) throws ServletException {
		// TODO New Web Service 07-01-2557 CallWSSevrlet
		try {
			
			if (checkAction(rr, "updateDcToShop")) { /** Up Date ข้อมูลได้  **/
				UpDateDCToShop(rr);
			}else if (checkAction(rr,"updateShopToDc_popr")) { /** Up Date ข้อมูลได้  **/
				UpDateShopToDCpopr(rr);
			}else if (checkAction(rr,"updateShopToDc")) { /** Up Date ข้อมูลได้  **/
				UpDateShopToDC(rr);
			}else if (checkAction(rr,"updateShopToDc_bill")) { /** Up Date ข้อมูลได้  **/
				UpDateShopToDCbill(rr);
			}else if (checkAction(rr, "updateBranchMaster")) {/** Up Date ข้อมูลได้  **/
				/**database: bikeman	database: DC
				 * system_info 	<<< 	branch_master ข้อมูลสาขา
				 */
				UpDateBranchMaster(rr);
			}if (checkAction(rr, "updateShopToDc_poprWherePO")) {/** Up Date ข้อมูลได้  **/
				/**database: bikeman	database: DC
				 * 
				 * New 28-033-2557
				 */
				UpDatepoprWherePO(rr);
			}
			
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
		
 	}
	
	private void UpDatepoprWherePO(ReqRes rr) throws UnsupportedEncodingException, Exception {
		// TODO updateShopToDc_popr WherePO
		Connection conn = null;		
		try {
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			
			String PO = WebUtils.getReqString(rr.req, "po");
			//System.out.println("PO : "+PO);
			
			/*********************************** ws_report ************************************************/
			try {
				
				//WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,"login_session");
				/**database: bikeman			database: DC
				 * web_service_update 	 	>>> ws_report
				 */
				String status = CallWebServiceSet.WS_Report_UpDate(conn);		
				//System.out.println("ws_report :"+status); 
				conn.commit();
				} catch (Exception e) {	
				//System.out.println("Message :"+e.getMessage());
				conn.commit();
				}
			/*********************************** --+++-- ************************************************/

			/************************************* PurchaseOrder ************************************/
			try {
				
				WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,PurchaseOrderTS.tableName);
				/**database: bikeman		database: DC
				 * pur_purchase_order >>> sale_order_service
				 */
				String status = CallWebServiceSet.partPO_WSUpdate(conn,entity.getSync_date(),PO);
				
				if (status.equalsIgnoreCase("success")) {
					WebServiceUpdateTS.insertServiceUpdate(conn, PurchaseOrderTS.tableName);
					WSLogUpdateTS.insertWSLogUpdate(conn,PurchaseOrderTS.tableName,"success");
					conn.commit();
				}else {
					WSLogUpdateTS.insertWSLogUpdate(conn, PurchaseOrderTS.tableName, status);
					conn.commit();
				}
				
			} catch (Exception e) {
				
				WSLogUpdateTS.insertWSLogUpdate(conn, PurchaseOrderTS.tableName, e.getMessage());
				conn.commit();
			}			
			/*****************************************************************************************/
			/************************************* PurchaseRequest ************************************/
			try {
				
				WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,PurchaseRequestTS.tableName);
				/** database: bikeman				database: DC
				 * pur_purchase_request >>> sale_order_service_part_detail
				 */
				String status = CallWebServiceSet.partPR_WSUpdate(conn,entity.getSync_date(),PO);
				
				if (status.equalsIgnoreCase("success")) {
					WebServiceUpdateTS.insertServiceUpdate(conn, PurchaseRequestTS.tableName);
					WSLogUpdateTS.insertWSLogUpdate(conn,PurchaseRequestTS.tableName,"success");
					conn.commit();
				}else {
					
					WSLogUpdateTS.insertWSLogUpdate(conn, PurchaseRequestTS.tableName, status);
					conn.commit();
				}
				
			} catch (Exception e) {
				
				WSLogUpdateTS.insertWSLogUpdate(conn, PurchaseRequestTS.tableName, e.getMessage());
				conn.commit();
				
			}			
			/*****************************************************************************************/
						
			conn.commit();
			conn.close();
			kson.setSuccess();
			rr.outTH(kson.getJson());
		} catch (Exception e) {
			if (conn != null ) {
				conn.rollback();
				conn.close();
			}					
			kson.setError(e);
			rr.outTH(kson.getJson());
		}
		
	}

	private void UpDateBranchMaster(ReqRes rr) throws Exception {
		// TODO updateBranchMaster
				Connection  conn = null;
				try {
					conn = DBPool.getConnection();
					conn.setAutoCommit(false);
				
					/*********************************** ws_report ************************************************/
					try {
					
					try {
						setSystemInfoBean branch = new setSystemInfoBean();
						WebUtils.bindReqToEntity(branch, rr.req);					
						WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,SystemInfoTS.tableName);
						/**database: bikeman	database: DC
						 * system_info 	<<< 	branch_master
						 */
						CallWebService.branchMaster_WSUpdate(entity.getSync_date(),branch);
						
						WebServiceUpdateTS.insertServiceUpdate(conn,SystemInfoTS.tableName);
						WSLogUpdateTS.insertWSLogUpdate(conn,SystemInfoTS.tableName,"success");
						
						conn.commit();
						kson.setSuccess();
						rr.outTH(kson.getJson());											
					} catch (Exception e) {
						WSLogUpdateTS.insertWSLogUpdate(conn,SystemInfoTS.tableName,e.getMessage());
						conn.commit();		
						
					}
					
					//WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,"login_session");
					/**database: bikeman			database: DC
					 * web_service_update 	 	>>> ws_report
					 */
					String status = CallWebServiceSet.WS_Report_UpDate(conn);		
					//System.out.println("ws_report :"+status); 
					conn.commit();
					} catch (Exception e) {	
					//System.out.println("Message :"+e.getMessage());
					conn.commit();
					}
				/*********************************** --+++-- ************************************************/
					
					conn.close();						
					
					
				} catch (Exception e) {
					if( conn != null ){
						conn.rollback();
						conn.close();
					}
					throw new Exception(e.getMessage());
					
				}
				
	}

	private void UpDateShopToDCbill(ReqRes rr) throws Exception {
		// TODO updateShopToDc_bill
		Connection conn = null; 
		
		try {
			conn = DBPool.getConnection();			
			conn.setAutoCommit(false);
			
			/*********************************** ws_report ************************************************/
			try {
				
				//WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,"login_session");
				/**database: bikeman			database: DC
				 * web_service_update 	 	>>> ws_report
				 */
				String status = CallWebServiceSet.WS_Report_UpDate(conn);		
				//System.out.println("ws_report :"+status); 
				conn.commit();
				} catch (Exception e) {	
				//System.out.println("Message :"+e.getMessage());
				conn.commit();
				}
			/*********************************** --+++-- ************************************************/

			try {
				WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,ServiceSaleTS.tableName);
				/**database: bikeman		database: DC
				 * service_sale 	>>> 	service_sale
				 */
				String status = CallWebServiceSet.serviceSale_WSUpdate(conn,entity.getSync_date());
				
				if(status.equals("success")){
					//////System.out.println("Sale_success");
					WebServiceUpdateTS.insertServiceUpdate(conn,ServiceSaleTS.tableName);
					WSLogUpdateTS.insertWSLogUpdate(conn,ServiceSaleTS.tableName, "success");
					
					conn.commit();
				}else{ 
					//////System.out.println("Sale_error");
					WSLogUpdateTS.insertWSLogUpdate(conn,ServiceSaleTS.tableName, status);
					conn.commit();
				}
				
			} catch (Exception e) {
				
				WSLogUpdateTS.insertWSLogUpdate(conn,ServiceSaleTS.tableName,  e.getMessage());
				conn.commit();
			}
			conn.commit();		
			conn.close();	
			kson.setSuccess();
			rr.outTH(kson.getJson());
		}catch (Exception e) {
			if( conn != null ){
				conn.rollback();
				conn.close();
			}
			throw new Exception(e.getMessage());
		}
	}

	private void UpDateShopToDC(ReqRes rr) throws SQLException, UnsupportedEncodingException {
		// TODO updateShopToDc
		Connection conn = null; 		
		
		try {
			conn = DBPool.getConnection();			
			conn.setAutoCommit(false);
			/*********************************** ws_report ************************************************/
			try {
				
				//WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,"login_session");
				/**database: bikeman			database: DC
				 * web_service_update 	 	>>> ws_report
				 */
				String status = CallWebServiceSet.WS_Report_UpDate(conn);		
				//System.out.println("ws_report :"+status); 
				conn.commit();
				} catch (Exception e) {	
				//System.out.println("Message :"+e.getMessage());
				conn.commit();
				}
			/*********************************** --+++-- ************************************************/

			/*********************************** ServiceSale ************************************************/
			try {
				
				WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,ServiceSaleTS.tableName);
				/**database: bikeman			database: DC
				 * service_sale 	 	>>> 	service_sale
				 */
				String status = CallWebServiceSet.serviceSale_WSUpdate(conn,entity.getSync_date());
				
				if(status.equals("success")){					
					WebServiceUpdateTS.insertServiceUpdate(conn,ServiceSaleTS.tableName);
					WSLogUpdateTS.insertWSLogUpdate(conn,ServiceSaleTS.tableName, "success");
					
				conn.commit();
			}else{ 				
					WSLogUpdateTS.insertWSLogUpdate(conn,ServiceSaleTS.tableName, status);
					conn.commit();
				}
			} catch (Exception e) {					
					WSLogUpdateTS.insertWSLogUpdate(conn,ServiceSaleTS.tableName,  e.getMessage());
					conn.commit();
			}
			
			/*********************************** ServiceRepair ************************************************/
			try {
				
				WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,ServiceRepairTS.tableName);
				/**database: bikeman			database: DC
				 * service_repair	 	>>> 	service_repair
				 */
				String status = CallWebServiceSet.SR_WSUpdate(conn,entity.getSync_date());
				
				if(status.equals("success")){					
					WebServiceUpdateTS.insertServiceUpdate(conn,ServiceRepairTS.tableName);
					WSLogUpdateTS.insertWSLogUpdate(conn,ServiceRepairTS.tableName, "success");
					conn.commit();
				}else{ 					
					WSLogUpdateTS.insertWSLogUpdate(conn,ServiceRepairTS.tableName, status);
					conn.commit();
				}
			} catch (Exception e) {
		
					WSLogUpdateTS.insertWSLogUpdate(conn,ServiceRepairTS.tableName,  e.getMessage());
					conn.commit();
			}
			
			/*********************************** ServicePartDetail ************************************************/	
			
			try {
				
				WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,ServicePartDetailTS.tableName);
				/**database: bikeman			database: DC
				 * service_part_detail 	>>> 	service_part_detail
				 */
				String status = CallWebServiceSet.SPD_WSUpdate(conn,entity.getSync_date());
				
				if(status.equals("success")){
					
					WebServiceUpdateTS.insertServiceUpdate(conn,ServicePartDetailTS.tableName);
					WSLogUpdateTS.insertWSLogUpdate(conn,ServicePartDetailTS.tableName, "success");
					conn.commit();
				}else{
					
					WSLogUpdateTS.insertWSLogUpdate(conn,ServicePartDetailTS.tableName, status);
					conn.commit();
				}
			} catch (Exception e) {
			
					WSLogUpdateTS.insertWSLogUpdate(conn,ServicePartDetailTS.tableName,  e.getMessage());
					conn.commit();
			}
			
			/*********************************** ServiceRepairDetail ************************************************/
			try {
				
				WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,ServiceRepairDetailTS.tableName);
				/**database: bikeman				database: DC
				 * service_repair_detail 	>>> 	service_repair_detail
				 */
				String status = CallWebServiceSet.SRD_WSUpdate(conn,entity.getSync_date());
				
				if(status.equals("success")){					
					WebServiceUpdateTS.insertServiceUpdate(conn,ServiceRepairDetailTS.tableName);
					WSLogUpdateTS.insertWSLogUpdate(conn,ServiceRepairDetailTS.tableName, "success");
					conn.commit();
				}else{ 
					WSLogUpdateTS.insertWSLogUpdate(conn,ServiceRepairDetailTS.tableName, status);
					conn.commit();
				}
			} catch (Exception e) {
					WSLogUpdateTS.insertWSLogUpdate(conn,ServiceRepairDetailTS.tableName,  e.getMessage());
					conn.commit();
			} 
			/************************************* BranchStock ************************************/
			try {
				
				WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,BranchStockTS.tableName);
				/*database: bikeman			database: DC
				   pa_part_master 		>>> 	branch_stock
				   pn,qty,create_by,create_date,update_by,update_date
				*/
				String status = CallWebServiceSet.BS_WSUpdate(conn,entity.getSync_date());
				
				if (status.equalsIgnoreCase("success")) {
					WebServiceUpdateTS.insertServiceUpdate(conn,BranchStockTS.tableName);
					WSLogUpdateTS.insertWSLogUpdate(conn,BranchStockTS.tableName,"success");
					conn.commit();
				}else {					
					WSLogUpdateTS.insertWSLogUpdate(conn,BranchStockTS.tableName, status);
					conn.commit();
				}				
			} catch (Exception e) {				
				WSLogUpdateTS.insertWSLogUpdate(conn,BranchStockTS.tableName, e.getMessage());
				conn.commit();				
			}				
			/*********************************** ServiceOtherDetail ************************************************/	
			try {
				
				WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,ServiceOtherDetailTS.tableName);
				/**database: bikeman				database: DC
				 * service_other_detail 	>>> 	service_other_detail
				 */
				String status = CallWebServiceSet.SOD_WSUpdate(conn,entity.getSync_date());
				
				if(status.equals("success")){					
					WebServiceUpdateTS.insertServiceUpdate(conn,ServiceOtherDetailTS.tableName);
					WSLogUpdateTS.insertWSLogUpdate(conn,ServiceOtherDetailTS.tableName, "success");
					conn.commit();										
				}else{ 					
					WSLogUpdateTS.insertWSLogUpdate(conn,ServiceOtherDetailTS.tableName, status);
					conn.commit();					
				}
			} catch (Exception e) {				
					WSLogUpdateTS.insertWSLogUpdate(conn,ServiceOtherDetailTS.tableName, e.getMessage());	
					conn.commit();
					
			}			
			
			conn.commit();
			conn.close();	
			kson.setSuccess();
			rr.outTH(kson.getJson());
			
		} catch (Exception e) {
			if (conn != null ) {
				conn.rollback();
				conn.close();				
			}	
		System.out.println(e.getMessage());
		kson.setError(e);
		rr.outTH(kson.getJson());	
	}
}


	private void UpDateShopToDCpopr(ReqRes rr) throws Exception {
		// TODO updateShopToDc_popr
		Connection conn = null;		
		try {
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			/*********************************** ws_report ************************************************/
			try {
				
				//WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,"login_session");
				/**database: bikeman			database: DC
				 * web_service_update 	 	>>> ws_report
				 */
				String status = CallWebServiceSet.WS_Report_UpDate(conn);		
				//System.out.println("ws_report :"+status); 
				conn.commit();
				} catch (Exception e) {	
				//System.out.println("Message :"+e.getMessage());
				conn.commit();
				}
			/*********************************** --+++-- ************************************************/

			/************************************* PurchaseOrder ************************************/
			try {
				
				WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,PurchaseOrderTS.tableName);
				/**database: bikeman		database: DC
				 * pur_purchase_order >>> sale_order_service
				 */
				String status = CallWebServiceSet.partPO_WSUpdate(conn,entity.getSync_date());
				
				if (status.equalsIgnoreCase("success")) {
					WebServiceUpdateTS.insertServiceUpdate(conn, PurchaseOrderTS.tableName);
					WSLogUpdateTS.insertWSLogUpdate(conn,PurchaseOrderTS.tableName,"success");
					conn.commit();
				}else {
					WSLogUpdateTS.insertWSLogUpdate(conn, PurchaseOrderTS.tableName, status);
					conn.commit();
				}
				
			} catch (Exception e) {
				
				WSLogUpdateTS.insertWSLogUpdate(conn, PurchaseOrderTS.tableName, e.getMessage());
				conn.commit();
			}			
			/*****************************************************************************************/
			/************************************* PurchaseRequest ************************************/
			try {
				
				WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,PurchaseRequestTS.tableName);
				/** database: bikeman				database: DC
				 * pur_purchase_request >>> sale_order_service_part_detail
				 */
				String status = CallWebServiceSet.partPR_WSUpdate(conn,entity.getSync_date());
				
				if (status.equalsIgnoreCase("success")) {
					WebServiceUpdateTS.insertServiceUpdate(conn, PurchaseRequestTS.tableName);
					WSLogUpdateTS.insertWSLogUpdate(conn,PurchaseRequestTS.tableName,"success");
					conn.commit();
				}else {
					
					WSLogUpdateTS.insertWSLogUpdate(conn, PurchaseRequestTS.tableName, status);
					conn.commit();
				}
				
			} catch (Exception e) {
				
				WSLogUpdateTS.insertWSLogUpdate(conn, PurchaseRequestTS.tableName, e.getMessage());
				conn.commit();
				
			}			
			/*****************************************************************************************/
						
			conn.commit();
			conn.close();
			kson.setSuccess();
			rr.outTH(kson.getJson());
		} catch (Exception e) {
			if (conn != null ) {
				conn.rollback();
				conn.close();
			}					
			kson.setError(e);
			rr.outTH(kson.getJson());
		}
		
	}

	private void UpDateDCToShop(ReqRes rr) throws SQLException, UnsupportedEncodingException {
		// TODO updateDcToShop
		Connection conn = null; 

		try {
			conn = DBPool.getConnection();		
			conn.setAutoCommit(false);
			/*********************************** ws_report ************************************************/
			try {
				
				//WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,"login_session");
				/**database: bikeman			database: DC
				 * web_service_update 	 	>>> ws_report
				 */
				String status = CallWebServiceSet.WS_Report_UpDate(conn);		
				//System.out.println("ws_report :"+status); 
				conn.commit();
				} catch (Exception e) {	
				//System.out.println("Message :"+e.getMessage());
				conn.commit();
				}
			/*********************************** --+++-- ************************************************/

			/************************************* PartMaster ************************************/
			try {
				
				WebServiceUpdateBean entity =  WebServiceUpdateTS.selectdate(conn,PartMasterTS.tableName);
				/**database: bikeman		database: DC
				 * pa_part_master 	<<< 	pa_part_master
				 */				
				//System.out.println("entity sync date = "+entity.getSync_date());
				CallWebService.partMaster_WSUpdate(conn ,entity.getSync_date());
				
				WebServiceUpdateTS.insertServiceUpdate(conn ,PartMasterTS.tableName);		
				WSLogUpdateTS.insertWSLogUpdate(conn ,PartMasterTS.tableName, "success");
				conn.commit();
			} catch (Exception e) {
				WSLogUpdateTS.insertWSLogUpdate(conn,PartMasterTS.tableName,e.getMessage());
				conn.commit();
			}
			
			/************************************* Brands ************************************/
			try {	
				
				WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,BrandMasterTS.tableName);
				/**database: bikeman	database: DC
				 * mk_brands 	<<< 	mk_brands
				 */
				CallWebService.brand_WSUpdate(conn,entity.getSync_date());
				
				WebServiceUpdateTS.insertServiceUpdate(conn ,BrandMasterTS.tableName);
				WSLogUpdateTS.insertWSLogUpdate(conn,BrandMasterTS.tableName, "success");
				conn.commit();
			} catch (Exception e) {
				WSLogUpdateTS.insertWSLogUpdate(conn,BrandMasterTS.tableName,  e.getMessage());
				conn.commit();
			}
			
			/************************************* Models ************************************/
			
			try {		
					WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,ModelMasterTS.tableName);
					/**database: bikeman	database: DC
					 * mk_models 	<<< 	mk_models
					 */
					CallWebService.model_WSUpdate(conn,entity.getSync_date());
					
					WebServiceUpdateTS.insertServiceUpdate(conn,ModelMasterTS.tableName);
					WSLogUpdateTS.insertWSLogUpdate(conn,ModelMasterTS.tableName, "success");
					conn.commit();
					
			} catch (Exception e) {
					WSLogUpdateTS.insertWSLogUpdate(conn,ModelMasterTS.tableName,  e.getMessage());
					conn.commit();
			}
			
			/************************************* PartGroups ************************************/
			
			try {
				
					WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,PartGroupsTS.tableName);
					/**database: bikeman	database: DC
					 * pa_groups 	<<< 	pa_groups
					 */
					CallWebService.partGroup_WSUpdate(conn,entity.getSync_date());
					
					WebServiceUpdateTS.insertServiceUpdate(conn,PartGroupsTS.tableName);
					WSLogUpdateTS.insertWSLogUpdate(conn,PartGroupsTS.tableName, "success");
					conn.commit();
			} catch (Exception e) {
					WSLogUpdateTS.insertWSLogUpdate(conn,PartGroupsTS.tableName,  e.getMessage());
					conn.commit();
			}
			
			/************************************* PartCategories ************************************/
			
			try {
					WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,PartCategoriesTS.tableName);
					/**database: bikeman		database: DC
					 * pa_categories 	<<< 	pa_categories
					 */
					CallWebService.partCategories_WSUpdate(conn,entity.getSync_date());
					
					WebServiceUpdateTS.insertServiceUpdate(conn,PartCategoriesTS.tableName);
					WSLogUpdateTS.insertWSLogUpdate(conn,PartCategoriesTS.tableName, "success");
					conn.commit();
			} catch (Exception e) {	
					WSLogUpdateTS.insertWSLogUpdate(conn,PartCategoriesTS.tableName,  e.getMessage());
					conn.commit();
			}
			
			
			/************************************* InventoryPacking ************************************/
			
			try {
				WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,InventoryPackingTS.tableName);
				/**database: bikeman		database: DC
				 * inv_packing 	<<< 		inv_packing
				 */
				CallWebService.packing_WSUpdate(conn,entity.getSync_date());
				
				WebServiceUpdateTS.insertServiceUpdate(conn,InventoryPackingTS.tableName);
				WSLogUpdateTS.insertWSLogUpdate(conn,InventoryPackingTS.tableName, "success");
				
				conn.commit();
			} catch (Exception e) {
			
				WSLogUpdateTS.insertWSLogUpdate(conn,InventoryPackingTS.tableName,  e.getMessage());
				conn.commit();
			}
			
			/************************************* UnitType ************************************/
			
			try {

				WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,InvUnitTypeTS.tableName);
				/**database: bikeman		database: DC
				 * inv_unit_type 	<<< 	inv_unit_type
				 */
				CallWebService.unitsType_WSUpdate(conn,entity.getSync_date());
				
				WebServiceUpdateTS.insertServiceUpdate(conn,InvUnitTypeTS.tableName);
				WSLogUpdateTS.insertWSLogUpdate(conn,InvUnitTypeTS.tableName, "success");
				
				conn.commit();
			} catch (Exception e) {
				
				WSLogUpdateTS.insertWSLogUpdate(conn,InvUnitTypeTS.tableName,  e.getMessage());
				conn.commit();
			}
			
			/************************************* PartCategoriesSub ************************************/
			
			try {
				WebServiceUpdateBean entity = WebServiceUpdateTS.selectdate(conn,PartCategoriesSubTS.tableName);
				/**database: bikeman			database: DC
				 * pa_categories_sub 	<<< 	pa_categories_sub
				 */
				CallWebService.partCategoriesSub_WSUpdate(conn,entity.getSync_date());
				
				WebServiceUpdateTS.insertServiceUpdate(conn,PartCategoriesSubTS.tableName);
				WSLogUpdateTS.insertWSLogUpdate(conn,PartCategoriesSubTS.tableName, "success");
				
				conn.commit();
				kson.setSuccess();
				rr.outTH(kson.getJson());
			} catch (Exception e) {
					
					WSLogUpdateTS.insertWSLogUpdate(conn,PartCategoriesSubTS.tableName,e.getMessage());
					conn.commit();
					
			}
			
			/*******************************************************************************************/
			
			conn.commit();		
			conn.close();	
			
		} catch (Exception e) {
			if (conn != null ) {
				conn.rollback();
				conn.close();
			}	
								
			kson.setError(e);
			rr.outTH(kson.getJson());
		}
		
	}
}
