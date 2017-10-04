package com.bitmap.servlet.sale;

import javax.servlet.ServletException;

import com.bitmap.bean.parts.PartCategories;
import com.bitmap.bean.sale.Brands;
import com.bitmap.bean.sale.Models;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class ModelsManagement
 */
public class ModelsManagement extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ModelsManagement() {
        super();
        // TODO Auto-generated constructor stub
    }
    public void doPost(ReqRes rr) throws ServletException {
    	
    	try{
    		if(checkAction(rr, "add_Models")){    			
    			Models entity = new Models();
    			WebUtils.bindReqToEntity(entity, rr.req);
    			if (Models.checkNameBrand(entity.getModel_name(), entity.getBrand_id())){
    				System.out.println("else_if:NameBrand:"+entity.getBrand_id());
    				kson.setSuccess();
					kson.setData("check", "NameBrand");
					rr.out(kson.getJson());
				}
    			else {
    				
    				System.out.println("New Models"+Models.checkName(entity.getModel_name()));
    				if (Models.checkName(entity.getModel_name())) {
    					System.out.println("else_if:Name:"+entity.getBrand_id());
        				kson.setSuccess();
    					kson.setData("check", "Name");
    					rr.out(kson.getJson());
    				}else {
    					System.out.println("insert:Model_name "+entity.getModel_name());
    					Models.insert(entity);
    					System.out.println("else_if:New:"+entity.getBrand_id());
    	    			kson.setSuccess();
    	    			kson.setData("check", "success");
    	    			rr.outTH(kson.getJson());
						
					}
					
				}
    		
    			
    		}
    		if(checkAction(rr, "add_Model_Brand")){
    			
    			Models entity = new Models();
    			WebUtils.bindReqToEntity(entity, rr.req);
    			
    			Models.insert(entity);
    			kson.setSuccess();
    			kson.setData("check", "success");
    			rr.outTH(kson.getJson());
    			
    		}
    		if(checkAction(rr, "edit_Models")){
    			
    			Models entity = new Models();
    			WebUtils.bindReqToEntity(entity, rr.req);
    			
    			if (Models.checkNameBrand(entity.getModel_name(), entity.getBrand_id())){
    				
    				Models model = Models.selectcheckNameBrand(entity.getId(), entity.getModel_name(), entity.getBrand_id());
    				
    				
    				if (!model.getModel_id().equalsIgnoreCase("")) {
    					
    					Models.update(entity);
    	    			kson.setSuccess();
    	    			kson.setData("check", "success");
    	    			rr.outTH(kson.getJson());
    					
						
					}else {
						kson.setSuccess();
    					kson.setData("check", "NameBrand");
    					rr.out(kson.getJson());
						
						
					}
    				
    			}
    			else {
    				
    				if (Models.checkName(entity.getModel_name())) {
        				
    					Models model = Models.selectcheckName(entity.getId(), entity.getModel_name());
    					////System.out.println("checkname::"+model.getModel_id());
    					if (!model.getModel_id().equalsIgnoreCase("")) {
    							
    							Models.update(entity);
    							kson.setSuccess();
    							kson.setData("check", "success");
    							rr.outTH(kson.getJson());
							
						}else {
							
							kson.setSuccess();
	    					kson.setData("check", "Name");
	    					rr.out(kson.getJson());
							
						}
        				
    					
    				}else {
    					Models.update(entity);
    	    			kson.setSuccess();
    	    			kson.setData("check", "success");
    	    			rr.outTH(kson.getJson());
    				}
        			
					
				}
    			
    		}
    		if(checkAction(rr,"edit_Model_Brand")){
    			
    			Models entity = new Models();
    			WebUtils.bindReqToEntity(entity, rr.req);
    			Models.update(entity);
    			kson.setSuccess();
    			rr.outTH(kson.getJson());
    			
    		}
    		if(checkAction(rr,"delete_model")){
    			
    			Models entity = new Models();
    			WebUtils.bindAjaxReqToEntity(entity, rr.req);
    			Models.delete(entity);
				kson.setSuccess();
				rr.outTH(kson.getJson());
				
    		
    		}if(checkAction(rr, "get_model_list")){
    			String brand1 = WebUtils.getReqString(rr.req, "brand1");
				kson.setSuccess();
				kson.setGson("model", gson.toJson(Models.selectList(brand1)));
				rr.outTH(kson.getJson());
    		}
    	
    		
    	}catch (Exception e) {
			// TODO: handle exception
		}
    	
    	
    }
}
