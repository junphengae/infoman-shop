package com.bmp.web.service.client.sevrlet;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;

import ws.DcMasterStub;
import ws.DcMasterStub.GetBranchMasterUpdate;
import ws.DcMasterStub.GetBranchMasterUpdateResponse;
import ws.DcMasterStub.GetBrandUpdate;
import ws.DcMasterStub.GetBrandUpdateResponse;
import ws.DcMasterStub.GetInventoryPackings;
import ws.DcMasterStub.GetInventoryPackingsResponse;
import ws.DcMasterStub.GetMasterUpdate;
import ws.DcMasterStub.GetMasterUpdateResponse;
import ws.DcMasterStub.GetModelUpdate;
import ws.DcMasterStub.GetModelUpdateResponse;
import ws.DcMasterStub.GetPartCategoriesSubUpdate;
import ws.DcMasterStub.GetPartCategoriesSubUpdateResponse;
import ws.DcMasterStub.GetPartCategoriesUpdate;
import ws.DcMasterStub.GetPartCategoriesUpdateResponse;
import ws.DcMasterStub.GetPartGroupsUpdate;
import ws.DcMasterStub.GetPartGroupsUpdateResponse;
import ws.DcMasterStub.GetUnitTypes;
import ws.DcMasterStub.GetUnitTypesResponse;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bmp.web.service.bean.setBrandMasterBean;
import com.bmp.web.service.bean.setInvUnitTypeBean;
import com.bmp.web.service.bean.setInventoryPackingBean;
import com.bmp.web.service.bean.setModelMasterBean;
import com.bmp.web.service.bean.setPartCategoriesBean;
import com.bmp.web.service.bean.setPartCategoriesSubBean;
import com.bmp.web.service.bean.setPartGroupsBean;
import com.bmp.web.service.bean.setPartMasterBean;
import com.bmp.web.service.bean.setSystemInfoBean;
import com.bmp.web.service.bean.WebServiceUpdateBean;
import com.bmp.web.service.transaction.BranchMasterTS;
import com.bmp.web.service.transaction.BrandMasterTS;
import com.bmp.web.service.transaction.InvUnitTypeTS;
import com.bmp.web.service.transaction.InventoryPackingTS;
import com.bmp.web.service.transaction.ModelMasterTS;
import com.bmp.web.service.transaction.PartCategoriesSubTS;
import com.bmp.web.service.transaction.PartCategoriesTS;
import com.bmp.web.service.transaction.PartGroupsTS;
import com.bmp.web.service.transaction.PartMasterTS;
import com.bmp.web.service.transaction.SystemInfoTS;
import com.bmp.web.service.transaction.WebServiceUpdateTS;

public class CallWebService {

	/**
	 * @param args
	 * @throws SQLException 
	 */
	public static void main(String[] args) throws SQLException {
		// TODO New Web Service 07-01-2557 CallWebService
		Connection conn = DBPool.getConnection();
		conn.setAutoCommit(false);
		try{
			WebServiceUpdateBean entity =  WebServiceUpdateTS.selectdate(conn,PartMasterTS.tableName);
			CallWebService.partMaster_WSUpdate(conn,entity.getSync_date());
			WebServiceUpdateTS.insertServiceUpdate(conn,PartMasterTS.tableName);
			
			WebServiceUpdateBean branch = WebServiceUpdateTS.selectdate(conn,BranchMasterTS.tableName);
			CallWebService.branchMaster_WSUpdate(branch.getSync_date(),SystemInfoTS.select());
			WebServiceUpdateTS.insertServiceUpdate(conn,BranchMasterTS.tableName); //branch System_info
			

			WebServiceUpdateBean brand = WebServiceUpdateTS.selectdate(conn,BrandMasterTS.tableName);
			CallWebService.brand_WSUpdate(conn,brand.getSync_date());
			WebServiceUpdateTS.insertServiceUpdate(conn,BrandMasterTS.tableName);
			
			WebServiceUpdateBean model = WebServiceUpdateTS.selectdate(conn,ModelMasterTS.tableName);
			CallWebService.model_WSUpdate(conn,model.getSync_date());
			WebServiceUpdateTS.insertServiceUpdate(conn,ModelMasterTS.tableName);
			
			WebServiceUpdateBean group = WebServiceUpdateTS.selectdate(conn,PartGroupsTS.tableName);
			CallWebService.partGroup_WSUpdate(conn,group.getSync_date());
			WebServiceUpdateTS.insertServiceUpdate(conn,PartGroupsTS.tableName);
			
			WebServiceUpdateBean cat = WebServiceUpdateTS.selectdate(conn,PartCategoriesTS.tableName);
			CallWebService.partCategories_WSUpdate(conn,cat.getSync_date());
			WebServiceUpdateTS.insertServiceUpdate(conn,PartCategoriesTS.tableName);
			
			conn.commit();
			conn.close();
		}catch(Exception e){
			conn.rollback();
			conn.close();
			e.printStackTrace();
		}
	}
	
	
	public static void partMaster_WSUpdate(Connection conn,Date dd) throws Exception{
		///* tableName = "pa_part_master"
		
		try {
			
			DcMasterStub stub = new DcMasterStub();       // ("http://localhost:8080/WSServer/services/DcMaster.DcMasterHttpSoap11Endpoint/" );
			GetMasterUpdate getMaster = GetMasterUpdate.class.newInstance();
			getMaster.setDd(dd);
			GetMasterUpdateResponse  res = stub.getMasterUpdate(getMaster);
			
			ws.DcMasterStub.GetPartMasterBean[] part = res.get_return();
			if(part != null){
				for(int i = 0; i <part.length; i++){
					
					ws.DcMasterStub.GetPartMasterBean entity = part[i];									
					if(PartMasterTS.check(entity.getPn())){
						
						setPartMasterBean part1 = new setPartMasterBean();
												
						part1.setPn(entity.getPn());
						part1.setCat_id(entity.getCat_id());
						part1.setCost(entity.getCost());
						part1.setCost_unit(entity.getCost_unit());
						part1.setCreate_by(entity.getCreate_by());
						if (entity.getCreate_date()!=null && !entity.getCreate_date().trim().equalsIgnoreCase("")) {					
							part1.setCreate_date( Timestamp.valueOf(entity.getCreate_date()) );
						}
						if (entity.getUpdate_date()!=null && !entity.getUpdate_date().trim().equalsIgnoreCase("")) {
							part1.setUpdate_date( Timestamp.valueOf(entity.getUpdate_date()));
						}
						part1.setDescription(entity.getDescription());
						part1.setFit_to(entity.getFit_to());
						part1.setGroup_id(entity.getGroup_id());
						part1.setMoq(entity.getMoq());
						part1.setPrice(entity.getPrice());
						part1.setPrice_unit(entity.getPrice_unit());
						part1.setSn_flag(entity.getSn_flag());
										
						part1.setSub_cat_id(entity.getSub_cat_id());
						part1.setWeight(entity.getWeight());
						part1.setDes_unit(entity.getDes_unit());
						part1.setReference(entity.getReference());
						
						//TODO  new 2557-01-14  By Jack
						part1.setSs_no(entity.getSs_no());
						part1.setSs_flag(entity.getSs_flag());
						part1.setStatus(entity.getStatus());
						/*System.out.println(part1.getSs_no());
						System.out.println(part1.getSs_flag());
						System.out.println(part1.getStatus());*/
						// aon create 16/12/56 add set value
								//part1.setQty(entity.getQty());
								//part1.setMor(entity.getMor());
								//part1.setLocation(entity.getLocation());				
								//part1.setUpdate_by(entity.getUpdate_by());
								//part1.setBarcode(entity.getBarcode());
						
						DBUtility.updateToDB(conn, PartMasterTS.tableName, part1,PartMasterTS.fieldNames, PartMasterTS.keys);
						
					}else{
						// Insert 
						setPartMasterBean part1 = new setPartMasterBean();
						
						part1.setPn(entity.getPn());
						part1.setCat_id(entity.getCat_id());
						part1.setCost(entity.getCost());
						part1.setCost_unit(entity.getCost_unit());
						part1.setCreate_by(entity.getCreate_by());
						if (entity.getCreate_date()!=null && !entity.getCreate_date().trim().equalsIgnoreCase("")) {					
							part1.setCreate_date( Timestamp.valueOf(entity.getCreate_date()) );
						}
						if (entity.getUpdate_date()!=null && !entity.getUpdate_date().trim().equalsIgnoreCase("")) {
							part1.setUpdate_date( Timestamp.valueOf(entity.getUpdate_date()));
						}
						part1.setDescription(entity.getDescription());
						part1.setFit_to(entity.getFit_to());
						part1.setGroup_id(entity.getGroup_id());
						part1.setMoq(entity.getMoq());
						part1.setPrice(entity.getPrice());
						part1.setPrice_unit(entity.getPrice_unit());
						part1.setSn_flag(entity.getSn_flag());
												
						part1.setSub_cat_id(entity.getSub_cat_id());
						part1.setWeight(entity.getWeight());
						part1.setDes_unit(entity.getDes_unit());
						part1.setReference(entity.getReference());
						
						//TODO  new 2557-01-14  By Jack
						//part1.setSs_no(entity.getSs_no());
						part1.setSs_flag(entity.getSs_flag());
						part1.setStatus(entity.getStatus());
						
						// aon create 16/12/56 add set value
								//part1.setQty(entity.getQty());
								//part1.setMor(entity.getMor());
								//part1.setLocation(entity.getLocation());							
								//part1.setUpdate_by(entity.getUpdate_by());
								//part1.setBarcode(entity.getBarcode());
						
						DBUtility.insertToDB(conn, PartMasterTS.tableName, part1);
					}
				}
			}
		} catch (Exception e) {
			if (conn != null) {
				conn.rollback();
				//conn.close();
			}
			throw new Exception("partMaster_WSUpdate :"+e);
		} 
	 }
	
	public static void brand_WSUpdate(Connection conn,Date dd) throws Exception{
		///** tableName = "mk_brands"		
	
		try {
			
			DcMasterStub stub = new DcMasterStub();
			
			GetBrandUpdate getBrand = GetBrandUpdate.class.newInstance();
			getBrand.setDd(dd);
			GetBrandUpdateResponse res =stub.getBrandUpdate(getBrand);
			ws.DcMasterStub.GetBrandMasterBean[] brand = res.get_return();
			
			if(brand != null){			
				for(int i = 0; i <brand.length; i++){
					ws.DcMasterStub.GetBrandMasterBean entity = brand[i];
					
					if(BrandMasterTS.check(entity.getOrder_by_id())){
						
						setBrandMasterBean brand1 = new setBrandMasterBean();
						
						brand1.setOrder_by_id(entity.getOrder_by_id());
						brand1.setBrand_id(entity.getBrand_id());
						brand1.setBrand_name(entity.getBrand_name());
						brand1.setCreate_by(entity.getCreate_by());
						brand1.setUpdate_by(entity.getUpdate_by());
						if (entity.getCreate_date() != null && !entity.getCreate_date().trim().equalsIgnoreCase("")) {
						brand1.setCreate_date( Timestamp.valueOf(entity.getCreate_date() ));
						}
						if (entity.getUpdate_date() != null && !entity.getUpdate_date().trim().equalsIgnoreCase("")) {
						brand1.setUpdate_date( Timestamp.valueOf(entity.getUpdate_date() ));	
						}
						
						DBUtility.updateToDB(conn, BrandMasterTS.tableName, brand1, BrandMasterTS.fieldNames, BrandMasterTS.keys);
						
					}else{
						
						setBrandMasterBean brand1 = new setBrandMasterBean();
						
						brand1.setOrder_by_id(entity.getOrder_by_id());
						brand1.setBrand_id(entity.getBrand_id());
						brand1.setBrand_name(entity.getBrand_name());
						brand1.setCreate_by(entity.getCreate_by());
						brand1.setUpdate_by(entity.getUpdate_by());
						if (entity.getCreate_date() != null && !entity.getCreate_date().trim().equalsIgnoreCase("")) {
							brand1.setCreate_date( Timestamp.valueOf(entity.getCreate_date() ));
						}
						if (entity.getUpdate_date() != null && !entity.getUpdate_date().trim().equalsIgnoreCase("")) {
							brand1.setUpdate_date( Timestamp.valueOf(entity.getUpdate_date() ));	
						}
						
						DBUtility.insertToDB(conn, BrandMasterTS.tableName, brand1);
					}
				}
				
			}
		} catch (Exception e) {
			if (conn != null) {
				conn.rollback();
				//conn.close();
			}
			throw new Exception(e);
		}
	 }
	
public static void model_WSUpdate(Connection conn,Date dd) throws Exception{
		///** tableName = "mk_models"
	
		try {
			
			DcMasterStub stub = new DcMasterStub();
			
			GetModelUpdate getModel = GetModelUpdate.class.newInstance();
			getModel.setDd(dd);
			
			GetModelUpdateResponse res =stub.getModelUpdate(getModel);
			
			ws.DcMasterStub.GetModelMasterBean[] model = res.get_return();
			
			if(model != null){
				
				for(int i = 0; i <model.length; i++){
					ws.DcMasterStub.GetModelMasterBean entity = model[i];
					
					if(ModelMasterTS.check(entity.getId())){
						
						setModelMasterBean model1 = new setModelMasterBean();
						
						model1.setId(entity.getId());
						model1.setModel_id(entity.getModel_id());
						model1.setModel_name(entity.getModel_name());
						model1.setBrand_id(entity.getBrand_id());
						model1.setCreate_by(entity.getCreate_by());
						model1.setUpdate_by(entity.getUpdate_by());
						if (entity.getCreate_date() != null && !entity.getCreate_date().trim().equalsIgnoreCase("")) {
							model1.setCreate_date( Timestamp.valueOf(entity.getCreate_date()));	
						}
						if (entity.getUpdate_date() != null && !entity.getUpdate_date().trim().equalsIgnoreCase("")) {
							model1.setUpdate_date( Timestamp.valueOf(entity.getUpdate_date()));
						}
						
						DBUtility.updateToDB(conn, ModelMasterTS.tableName, model1, ModelMasterTS.fieldNames, ModelMasterTS.keys);
						
					}else{
						
						setModelMasterBean model1 = new setModelMasterBean();
						
						model1.setId(entity.getId());
						model1.setModel_id(entity.getModel_id());
						model1.setModel_name(entity.getModel_name());
						model1.setBrand_id(entity.getBrand_id());
						model1.setCreate_by(entity.getCreate_by());
						model1.setUpdate_by(entity.getUpdate_by());
						if (entity.getCreate_date() != null && !entity.getCreate_date().trim().equalsIgnoreCase("")) {
							model1.setCreate_date( Timestamp.valueOf(entity.getCreate_date()));	
						}
						if (entity.getUpdate_date() != null && !entity.getUpdate_date().trim().equalsIgnoreCase("")) {
							model1.setUpdate_date( Timestamp.valueOf(entity.getUpdate_date()));
						}
						DBUtility.insertToDB(conn, ModelMasterTS.tableName, model1);
					}
				}
				
			}
		} catch (Exception e) {
			if (conn != null) {
				conn.rollback();
				//conn.close();
			}
			throw new Exception(e.getMessage());
		} 
	}


public static void partGroup_WSUpdate(Connection conn,Date dd) throws Exception{
	//*** tableName = "pa_groups"
	try {
		
		DcMasterStub stub = new DcMasterStub();
		
		GetPartGroupsUpdate getGroup = GetPartGroupsUpdate.class.newInstance();
		getGroup.setDd(dd);
	
		GetPartGroupsUpdateResponse res =stub.getPartGroupsUpdate(getGroup);
		ws.DcMasterStub.GetPartGroupsBean[] group =res.get_return();
		
		if(group != null){
			
			for(int i = 0; i <group.length; i++){
				ws.DcMasterStub.GetPartGroupsBean entity = group[i];
				
				if(PartGroupsTS.check(entity.getGroup_id())){
					
					setPartGroupsBean group1 = new setPartGroupsBean();
					
					group1.setGroup_id(entity.getGroup_id());
					group1.setGroup_name_en(entity.getGroup_name_en());
					group1.setGroup_name_th(entity.getGroup_name_th());
					group1.setCreate_by(entity.getCreate_by());
					if (entity.getCreate_date() != null && !entity.getCreate_date().trim().equalsIgnoreCase("")) {
					group1.setCreate_date( Timestamp.valueOf(entity.getCreate_date()));	
					}
					group1.setUpdate_by(entity.getUpdate_by());
					if (entity.getUpdate_date() != null && !entity.getUpdate_date().trim().equalsIgnoreCase("")) {
					group1.setUpdate_date( Timestamp.valueOf(entity.getUpdate_date()));			
					}
					
					DBUtility.updateToDB(conn,PartGroupsTS.tableName, group1, PartGroupsTS.fieldNames, PartGroupsTS.keys);
					
				}else{
					
					setPartGroupsBean group1 = new setPartGroupsBean();
					
					group1.setGroup_id(entity.getGroup_id());
					group1.setGroup_name_en(entity.getGroup_name_en());
					group1.setGroup_name_th(entity.getGroup_name_th());
					group1.setCreate_by(entity.getCreate_by());
					if (entity.getCreate_date() != null && !entity.getCreate_date().trim().equalsIgnoreCase("")) {
						group1.setCreate_date( Timestamp.valueOf(entity.getCreate_date()));	
					}
					group1.setUpdate_by(entity.getUpdate_by());
					if (entity.getUpdate_date() != null && !entity.getUpdate_date().trim().equalsIgnoreCase("")) {
						group1.setUpdate_date( Timestamp.valueOf(entity.getUpdate_date()));			
					}
					
					DBUtility.insertToDB(conn, PartGroupsTS.tableName, group1);
				}
			}
			
		  }
		}catch (Exception e) {
		if (conn != null) {
			conn.rollback();
			//conn.close();
		}
		throw new Exception(e);
	} 

}

public static void partCategories_WSUpdate(Connection conn,Date dd) throws Exception{
	//**** tableName = "pa_categories"
	

	try {
		////System.out.println("Get PartCategories - active date: " + DBUtility.getDateTimeValue(dd));
		DcMasterStub stub = new DcMasterStub();
		
		GetPartCategoriesUpdate getCategories = GetPartCategoriesUpdate.class.newInstance();
		getCategories.setDd(dd);
	
		GetPartCategoriesUpdateResponse res =stub.getPartCategoriesUpdate(getCategories);
		ws.DcMasterStub.GetPartCategoriesBean[] categories =res.get_return();
		
		if(categories != null){
			
			for(int i = 0; i <categories.length; i++){
				ws.DcMasterStub.GetPartCategoriesBean entity = categories[i];
				
				if(PartCategoriesTS.check(entity.getCat_id())){
					
					setPartCategoriesBean categories1 = new setPartCategoriesBean();
					
					categories1.setCat_id(entity.getCat_id());
					categories1.setGroup_id(entity.getGroup_id());
					categories1.setCat_name_th(entity.getCat_name_th());
					categories1.setCat_name_short(entity.getCat_name_short());
					categories1.setCreate_by(entity.getCreate_by());
					categories1.setUpdate_by(entity.getUpdate_by());
					if (entity.getUpdate_date() != null && !entity.getUpdate_date().trim().equalsIgnoreCase("")) {
					categories1.setUpdate_date( Timestamp.valueOf(entity.getUpdate_date()));			
					}
					if (entity.getCreate_date() != null && !entity.getCreate_date().trim().equalsIgnoreCase("")) {
					categories1.setCreate_date( Timestamp.valueOf(entity.getCreate_date()));	
					}
					
					DBUtility.updateToDB(conn,PartCategoriesTS.tableName, categories1, PartCategoriesTS.fieldNames, PartCategoriesTS.keys);
					
				}else{
					
					setPartCategoriesBean categories1 = new setPartCategoriesBean();
					
					categories1.setCat_id(entity.getCat_id());
					categories1.setGroup_id(entity.getGroup_id());
					categories1.setCat_name_th(entity.getCat_name_th());
					categories1.setCat_name_short(entity.getCat_name_short());
					categories1.setCreate_by(entity.getCreate_by());
					categories1.setUpdate_by(entity.getUpdate_by());
					if (entity.getUpdate_date() != null && !entity.getUpdate_date().trim().equalsIgnoreCase("")) {
						categories1.setUpdate_date( Timestamp.valueOf(entity.getUpdate_date()));			
					}
					if (entity.getCreate_date() != null && !entity.getCreate_date().trim().equalsIgnoreCase("")) {
						categories1.setCreate_date( Timestamp.valueOf(entity.getCreate_date()));	
					}
					
					DBUtility.insertToDB(conn, PartCategoriesTS.tableName, categories1);
				}
			}
			
		  }
		}catch (Exception e) {
		if (conn != null) {
			conn.rollback();
			//conn.close();
		}
		throw new Exception (e);
	} 
}

public static void packing_WSUpdate(Connection conn,Date dd) throws Exception{
	//**** tableName = "inv_packing"
	
	try {
		 
		  DcMasterStub stub = new DcMasterStub();
		
		  GetInventoryPackings getPacking = GetInventoryPackings.class.newInstance();
		  getPacking.setDd(dd);
		 
		  GetInventoryPackingsResponse res = stub.getInventoryPackings(getPacking);
		  ws.DcMasterStub.GetInventoryPackingBean[] packing = res.get_return();
		  
		if(packing != null){ 
			
			for(int i = 0; i <packing.length; i++){
				ws.DcMasterStub.GetInventoryPackingBean entity = packing[i];
				
				if (InventoryPackingTS.check(entity.getRun_id(), entity.getMat_code())) {
					
					setInventoryPackingBean  pac = new setInventoryPackingBean();
					
					pac.setRun_id(entity.getRun_id());
					pac.setMat_code(entity.getMat_code());
					pac.setDescription(entity.getDescription());
					pac.setUnit(entity.getUnit());
					pac.setCreate_by(entity.getCreate_by());
					pac.setUpdate_by(entity.getUpdate_by());
					if (entity.getCreate_date() != null && !entity.getCreate_date().trim().equalsIgnoreCase("")) {
						pac.setCreate_date( Timestamp.valueOf(entity.getCreate_date()));	
					}
					if (entity.getUpdate_date() != null && !entity.getUpdate_date().trim().equalsIgnoreCase("")) {
						pac.setUpdate_date( Timestamp.valueOf(entity.getUpdate_date()));
					}
										
					DBUtility.updateToDB(conn, InventoryPackingTS.tableName, pac, InventoryPackingTS.fieldNameWS, InventoryPackingTS.keys);
					
				}else{
					setInventoryPackingBean pac = new setInventoryPackingBean();
					
						pac.setRun_id(entity.getRun_id());
						pac.setMat_code(entity.getMat_code());
						pac.setDescription(entity.getDescription());
						pac.setUnit(entity.getUnit());
						pac.setCreate_by(entity.getCreate_by());
						pac.setUpdate_by(entity.getUpdate_by());
						if (entity.getCreate_date() != null && !entity.getCreate_date().trim().equalsIgnoreCase("")) {
							pac.setCreate_date( Timestamp.valueOf(entity.getCreate_date()));	
						}
						if (entity.getUpdate_date() != null && !entity.getUpdate_date().trim().equalsIgnoreCase("")) {
							pac.setUpdate_date( Timestamp.valueOf(entity.getUpdate_date()));
						}
						
						DBUtility.insertToDB(conn, InventoryPackingTS.tableName, pac);
						
				}
			}
		}
		}catch (Exception e) {
		if (conn != null) {
			conn.rollback();
			//conn.close();
		}
		throw new Exception (e);
	} 

}


public static void unitsType_WSUpdate(Connection conn,Date dd) throws Exception{
	//*** tableName = "inv_unit_type"
	
	try {
		 
		  	DcMasterStub stub = new DcMasterStub();
		  	
		  	GetUnitTypes getuUnit = GetUnitTypes.class.newInstance();
		  	getuUnit.setDd(dd);
		  			  
		  	GetUnitTypesResponse res = stub.getUnitTypes(getuUnit);
		  	ws.DcMasterStub.GetInvUnitTypeBean[] unit = res.get_return();
		  
		if(unit != null){ 
			
			for(int i = 0; i <unit.length; i++){
				ws.DcMasterStub.GetInvUnitTypeBean entity = unit[i];				
				if (InvUnitTypeTS.check(entity.getId())) {
					
					setInvUnitTypeBean units = new setInvUnitTypeBean();
					
					units.setId(entity.getId());
					units.setType_name(entity.getType_name());
					units.setCreate_by(entity.getCreate_by());
					units.setUpdate_by(entity.getUpdate_by());
					if (entity.getCreate_date() != null && !entity.getCreate_date().trim().equalsIgnoreCase("")) {
						units.setCreate_date( Timestamp.valueOf(entity.getCreate_date()));	
					}
					if (entity.getUpdate_date() != null && !entity.getUpdate_date().trim().equalsIgnoreCase("")) {
						units.setUpdate_date( Timestamp.valueOf(entity.getUpdate_date()));
					}
			
					DBUtility.updateToDB(conn, InvUnitTypeTS.tableName, units, InvUnitTypeTS.fieldNameWS, InvUnitTypeTS.keys);
					
				}else{
					
					setInvUnitTypeBean units = new setInvUnitTypeBean();
					
					units.setId(entity.getId());
					units.setType_name(entity.getType_name());
					units.setCreate_by(entity.getCreate_by());
					units.setUpdate_by(entity.getUpdate_by());
					if (entity.getCreate_date() != null && !entity.getCreate_date().trim().equalsIgnoreCase("")) {
						units.setCreate_date( Timestamp.valueOf(entity.getCreate_date()));	
					}
					if (entity.getUpdate_date() != null && !entity.getUpdate_date().trim().equalsIgnoreCase("")) {
						units.setUpdate_date( Timestamp.valueOf(entity.getUpdate_date()));
					}
					
				   DBUtility.insertToDB(conn, InvUnitTypeTS.tableName, units);
						
				}
					
			}
			
		}
		}catch (Exception e) {
		if (conn != null) {
			conn.rollback();
			//conn.close();
		}
		throw new Exception(e);
	} 

}

public static void partCategoriesSub_WSUpdate(Connection conn,Date dd) throws Exception{
	//**** tableName = "pa_categories_sub"
	
	try {
		
		DcMasterStub stub = new DcMasterStub();
		
		GetPartCategoriesSubUpdate getcCategoriesSub = GetPartCategoriesSubUpdate.class.newInstance();
		getcCategoriesSub.setDd(dd);
	
		GetPartCategoriesSubUpdateResponse res =stub.getPartCategoriesSubUpdate(getcCategoriesSub);
		ws.DcMasterStub.GetPartCategoriesSubBean[] sub_cat =res.get_return();
		
		if(sub_cat != null){
			
			for(int i = 0; i <sub_cat.length; i++){
				ws.DcMasterStub.GetPartCategoriesSubBean entity = sub_cat[i];
				
				if(PartCategoriesSubTS.check(entity.getSub_cat_id())){
					
					setPartCategoriesSubBean sub_cat1 = new setPartCategoriesSubBean();
					
					sub_cat1.setSub_cat_id(entity.getSub_cat_id());
					sub_cat1.setCat_id(entity.getCat_id());
					sub_cat1.setGroup_id(entity.getGroup_id());
					sub_cat1.setSub_cat_name_short(entity.getSub_cat_name_short());
					sub_cat1.setSub_cat_name_th(entity.getSub_cat_name_th());
					sub_cat1.setCreate_by(entity.getCreate_by());
					if (entity.getCreate_date() != null && !entity.getCreate_date().trim().equalsIgnoreCase("") ) {
						sub_cat1.setCreate_date( Timestamp.valueOf(entity.getCreate_date()));	
					}
					sub_cat1.setUpdate_by(entity.getUpdate_by());
					if (entity.getUpdate_date() != null && !entity.getUpdate_date().trim().equalsIgnoreCase("")) {
						sub_cat1.setUpdate_date( Timestamp.valueOf(entity.getUpdate_date()));			
					}
					
				
					DBUtility.updateToDB(conn, PartCategoriesSubTS.tableName, sub_cat1, PartCategoriesSubTS.fieldNames, PartCategoriesSubTS.keys);
					
				}else{
					
					setPartCategoriesSubBean sub_cat1 = new setPartCategoriesSubBean();
					
					sub_cat1.setSub_cat_id(entity.getSub_cat_id());
					sub_cat1.setCat_id(entity.getCat_id());
					sub_cat1.setGroup_id(entity.getGroup_id());
					sub_cat1.setSub_cat_name_short(entity.getSub_cat_name_short());
					sub_cat1.setSub_cat_name_th(entity.getSub_cat_name_th());
					sub_cat1.setCreate_by(entity.getCreate_by());
					if (entity.getCreate_date() != null && !entity.getCreate_date().trim().equalsIgnoreCase("") ) {
						sub_cat1.setCreate_date( Timestamp.valueOf(entity.getCreate_date()));	
					}
					sub_cat1.setUpdate_by(entity.getUpdate_by());
					if (entity.getUpdate_date() != null && !entity.getUpdate_date().trim().equalsIgnoreCase("")) {
						sub_cat1.setUpdate_date( Timestamp.valueOf(entity.getUpdate_date()));			
					}
					
					DBUtility.insertToDB(conn, PartCategoriesSubTS.tableName, sub_cat1);
				}
			}
			
		  }
		}catch (Exception e) {
			if (conn != null) {
			conn.rollback();
			//conn.close();
			}
			throw new Exception(e);
		} 


}

public static void branchMaster_WSUpdate(Date dd ,setSystemInfoBean branchs) throws Exception{ //branch System_info
	//***  tableName = "system_info"
	Connection conn = null;

	try {		
		DcMasterStub stub = new DcMasterStub();
		
		GetBranchMasterUpdate getBranch = GetBranchMasterUpdate.class.newInstance();
		getBranch.setDd(dd);
		
		GetBranchMasterUpdateResponse res = stub.getBranchMasterUpdate(getBranch);
		
		ws.DcMasterStub.GetBranchMasterBean[] branch = res.get_return();					
			
		branchs.setId("1");
		branchs.load(branchs);
						
		if(branch != null){
			
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			
			for(int i = 0; i <branch.length; i++){
				ws.DcMasterStub.GetBranchMasterBean entity = branch[i];
				
				if (entity.getBranch_code().equalsIgnoreCase(branchs.getBranch_code())) {
					
					if(SystemInfoTS.check(entity.getBranch_code())){
						
						setSystemInfoBean branch1 = new setSystemInfoBean();
						/*System.out.println(entity.getBranch_code());
						System.out.println(entity.getBranch_name());*/
						branch1.setId("1");
						branch1.setBranch_code(entity.getBranch_code());
						branch1.setName(entity.getBranch_name());
						branch1.setCreate_by(entity.getCreate_by());
						branch1.setUpdate_by(entity.getUpdate_by());
						if (entity.getCreate_date()!=null && !entity.getCreate_date().trim().equalsIgnoreCase("") ) {						
						branch1.setCreate_date( Timestamp.valueOf(entity.getCreate_date()));
						}
						if (entity.getUpdate_date()!=null && !entity.getUpdate_date().trim().equalsIgnoreCase("")) {
						branch1.setUpdate_date( Timestamp.valueOf(entity.getUpdate_date()));
						}
						branch1.setSoi(entity.getBranch_lane());
						branch1.setRoad(entity.getBranch_road());
						branch1.setAddressnumber(entity.getBranch_addressnumber());
						branch1.setMoo(entity.getBranch_moo());
						branch1.setVillege(entity.getBranch_villege());
						branch1.setDistrict(entity.getBranch_district());
						branch1.setPrefecture(entity.getBranch_prefecture());
						branch1.setProvince(entity.getBranch_province());
						branch1.setPostalcode(entity.getBranch_postalcode());
						branch1.setPhonenumber(entity.getBranch_phonenumber());
						branch1.setFax(entity.getBranch_fax());
						branch1.setBranch_name_en(entity.getBranch_name_en());
						branch1.setBranch_order(entity.getBranch_order());
											
						if (entity.getBranch_code().equalsIgnoreCase(branchs.getBranch_code())) {							
							DBUtility.updateToDB(conn, SystemInfoTS.tableName, branch1, SystemInfoTS.fieldNames, SystemInfoTS.keys);
						}
						
						
						
					}else{
						
						setSystemInfoBean branch1 = new setSystemInfoBean();
						
						branch1.setId("1");
						branch1.setBranch_code(entity.getBranch_code());
						branch1.setName(entity.getBranch_name());
						branch1.setCreate_by(entity.getCreate_by());
						branch1.setUpdate_by(entity.getUpdate_by());
						if (entity.getCreate_date()!=null && !entity.getCreate_date().trim().equalsIgnoreCase("") ) {						
							branch1.setCreate_date( Timestamp.valueOf(entity.getCreate_date()));
						}
						if (entity.getUpdate_date()!=null && !entity.getUpdate_date().trim().equalsIgnoreCase("")) {
							branch1.setUpdate_date( Timestamp.valueOf(entity.getUpdate_date()));
						}
						branch1.setSoi(entity.getBranch_lane());
						branch1.setRoad(entity.getBranch_road());
						branch1.setAddressnumber(entity.getBranch_addressnumber());
						branch1.setMoo(entity.getBranch_moo());
						branch1.setVillege(entity.getBranch_villege());
						branch1.setDistrict(entity.getBranch_district());
						branch1.setPrefecture(entity.getBranch_prefecture());
						branch1.setProvince(entity.getBranch_province());
						branch1.setPostalcode(entity.getBranch_postalcode());
						branch1.setPhonenumber(entity.getBranch_phonenumber());
						branch1.setFax(entity.getBranch_fax());
						branch1.setBranch_name_en(entity.getBranch_name_en());
						branch1.setBranch_order(entity.getBranch_order());
												
						DBUtility.insertToDB(conn, SystemInfoTS.tableName, branch1);
					}
				}
				
				conn.commit();
			}
			
		}
	} catch (Exception e) {
		if (conn != null) {
			conn.rollback();
			conn.close();
		}
		throw new Exception(e.getMessage());
	} 
 }

}
