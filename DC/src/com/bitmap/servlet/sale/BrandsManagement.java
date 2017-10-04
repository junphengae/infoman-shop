package com.bitmap.servlet.sale;

import javax.servlet.ServletException;

import com.bitmap.bean.sale.Brands;
import com.bitmap.bean.sale.Models;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class BrandsManagement
 */
	public class BrandsManagement extends ServletUtils {
	private static final long serialVersionUID = 1L;
   
    public BrandsManagement() {
        super();
       
    }
    public void doPost(ReqRes rr) throws ServletException {
    	
    	try{
    		
    		if(checkAction(rr,"add_brands")){
    			
    			Brands entity = new Brands();
    			WebUtils.bindReqToEntity(entity, rr.req);
    			if (Brands.check(entity.getBrand_name(), entity.getBrand_id())) {
    				//////System.out.println("IdName");
    				kson.setSuccess();
					kson.setData("check", "IdName");
					rr.out(kson.getJson());
				}
    			else {
	    				//////System.out.println("else-----");
	    				
	    				if (Brands.checkID(entity.getBrand_id())) {
	    					//////System.out.println("Id1");
	    					Brands BrandsID= Brands.selectCode(entity.getBrand_id());
	    					if (BrandsID.getCreate_date() != null ) {
	    						//////System.out.println("Id1");
	    						kson.setSuccess();
		    					kson.setData("check", "Id");
		    					rr.out(kson.getJson());
		    					
							}else{
									if (Brands.checkName(entity.getBrand_name())) {
										//////System.out.println("Name1");
										Brands BrandName  = Brands.selectName(entity.getBrand_name());
					        			if (BrandName.getCreate_date() != null) {
					        				//////System.out.println("Name1");
					        				kson.setSuccess();
					    					kson.setData("check", "Name");
					    					rr.out(kson.getJson());
					    					
					        			}else{
											Brands.insert(entity);
					    					kson.setSuccess();
					    					kson.setData("check", "success");
					    					rr.outTH(kson.getJson());
					        			}
					        		}else{
										Brands.insert(entity);
				    					kson.setSuccess();
				    					kson.setData("check", "success");
				    					rr.outTH(kson.getJson());
					        		}
							}
		        				
	    				}
	    				else if (Brands.checkName(entity.getBrand_name())) {
	    					
			        			Brands BrandName  = Brands.selectName(entity.getBrand_name());
			        			if (BrandName.getCreate_date() != null) {
			        				
			        				kson.setSuccess();
			    					kson.setData("check", "Name");
			    					rr.out(kson.getJson());
			    					
								}else{
								
									if (Brands.checkID(entity.getBrand_id())) {
				    					
				    					Brands BrandsID= Brands.selectCode(entity.getBrand_id());
				    					if (BrandsID.getCreate_date() != null ) {
				    						
				    						kson.setSuccess();
					    					kson.setData("check", "Id");
					    					rr.out(kson.getJson());
					    					
				    					}else{
												Brands.insert(entity);
						    					kson.setSuccess();
						    					kson.setData("check", "success");
						    					rr.outTH(kson.getJson());
				    					}
									}else{
										Brands.insert(entity);
				    					kson.setSuccess();
				    					kson.setData("check", "success");
				    					rr.outTH(kson.getJson());
									}	
								}
	    				}else {
	    					Brands.insert(entity);
	    					kson.setSuccess();
	    					kson.setData("check", "success");
	    					rr.outTH(kson.getJson());
						}
					
				}
    			
    			
    			
    		}
    		if(checkAction(rr,"edit_Brands")){
    			
    			Brands entity = new Brands();
    			WebUtils.bindAjaxReqToEntity(entity, rr.req);
    			
    			//System.out.println(entity.getOrder_by_id());
    			//System.out.println(entity.getOrder_by_id());
		        	if (Brands.checkName(entity.getBrand_name())) {
		        						
		        				Brands brand = Brands.selectcheckName(entity.getOrder_by_id(), entity.getBrand_name());
		    	        		
		        				if (brand.getCreate_date() != null) {
		    	        					
		    	        					Brands.update(entity);
		    		    					kson.setSuccess();
		    		    					kson.setData("check", "success");
		    		    					rr.outTH(kson.getJson());
		    					}else {
		    								kson.setSuccess();
		        	    					kson.setData("check", "Name");
		        	    					rr.out(kson.getJson());
		    					}	
		    	    					
		    	    }else {
		    	    					Brands.update(entity);
				    					kson.setSuccess();
				    					kson.setData("check", "success");
				    					rr.outTH(kson.getJson());
										
					}
			    					
								
	    	}
    		if(checkAction(rr,"delete_brand")){
    			
    			Brands entity = new Brands();
    			WebUtils.bindAjaxReqToEntity(entity, rr.req);
    			Brands brand = Brands.select(entity);
    			
    			if (Models.checkBrand_id(brand.getBrand_id())) {
    				
    				kson.setData("check", "error");
    				kson.setSuccess();
    				rr.outTH(kson.getJson());
    				
				}else{
					Brands.delete(entity);
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
    			
    			
				
    		
    	}
    	}catch (Exception e) {
			// TODO: handle exception
		}
		
    	
    }
	

}
