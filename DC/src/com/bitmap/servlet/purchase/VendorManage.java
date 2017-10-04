package com.bitmap.servlet.purchase;

import javax.servlet.ServletException;

import com.bitmap.bean.parts.Vendor;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

public class VendorManage extends ServletUtils {
	private static final long serialVersionUID = 1L;
   
    public VendorManage() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (isAction(rr)) {
				if (checkAction(rr, "vendor_add")) {
					
					Vendor entity = new Vendor();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					if (Vendor.checkName(entity.getVendor_name())) {
						kson.setError("Name");
					}else{
						Vendor.insert(entity);
						kson.setSuccess();
					}
					
					
					rr.outTH(kson.getJson());
					
					
				}
				
				if (checkAction(rr, "vendor_edit")) {
					Vendor entity = new Vendor();
					WebUtils.bindReqToEntity(entity, rr.req);
								
					//System.out.println(" name:: "+entity.getVendor_name()+"   vendor_id:: "+entity.getVendor_id());
					
					if (Vendor.checkName(entity.getVendor_name())) {
							
						Vendor vendor = Vendor.selectcheckName(entity.getVendor_name(), entity.getVendor_id());
							//System.out.println("vendor::"+vendor.getCreate_date());
							
							if(vendor.getCreate_date() == null){
								kson.setError("Name");
							}else {
								Vendor.update(entity);
								kson.setSuccess();
							}
						
					}else {
						Vendor.update(entity);
						kson.setSuccess();
					}
					
					rr.outTH(kson.getJson());
				}
			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}

}

