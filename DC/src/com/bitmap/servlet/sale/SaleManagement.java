package com.bitmap.servlet.sale;

import javax.servlet.ServletException;

import com.bitmap.bean.dc.SaleServicePartDetail;
import com.bitmap.bean.purchase.PurchaseRequest;
import com.bitmap.bean.sale.Customer;
import com.bitmap.bean.sale.Vehicle;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class SaleManagement
 */
public class SaleManagement extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public SaleManagement() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (isAction(rr)) {
				
				if (checkAction(rr, "update_sale_order")) {
					SaleServicePartDetail entity = new SaleServicePartDetail();
					WebUtils.bindReqToEntity(entity, rr.getRequest());
					
					SaleServicePartDetail.updateItem(entity);
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "cancel_item")) {
					SaleServicePartDetail entity = new SaleServicePartDetail();
					WebUtils.bindReqToEntity(entity, rr.getRequest());
					
					SaleServicePartDetail.status_cancel(entity);
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "customer_add")) {
					Customer cus = new Customer();
					WebUtils.bindReqToEntity(cus, rr.req);
					Customer.insert(cus);
					
					kson.setData("cus_id", cus.getCus_id());
					kson.setSuccess();
					rr.out(kson.getJson());
				} 
				
				if (checkAction(rr, "customer_edit")) {
					Customer cus = new Customer();
					WebUtils.bindReqToEntity(cus, rr.req);
					Customer.update(cus);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "vehicle_add")) {
					Vehicle entity = new Vehicle();
					WebUtils.bindReqToEntity(entity, rr.req);
					Vehicle.insert(entity);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "vehicle_edit")) {
					Vehicle entity = new Vehicle();
					WebUtils.bindReqToEntity(entity, rr.req);
					Vehicle.update(entity);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}
}
