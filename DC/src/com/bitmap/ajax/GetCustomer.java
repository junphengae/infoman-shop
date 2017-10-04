package com.bitmap.ajax;

import javax.servlet.ServletException;

import com.bitmap.bean.sale.Customer;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;


/**
 * Servlet implementation class GetCustomer
 */
public class GetCustomer extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    
    public GetCustomer() {
        super();
    }


	public void doPost(ReqRes rr) throws ServletException {
		try {
			String str = getParam(rr, "term");
			rr.outTH(gson.toJson(Customer.listByAutocomplete(str)));
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}

}
