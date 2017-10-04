package com.bitmap.ajax;

import javax.servlet.ServletException;
import com.bitmap.bean.sale.Models;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class GetModel
 */
public class GetModel extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public GetModel() {
        super();
        
    }
    
    public void doPost(ReqRes rr) throws ServletException {
		try {
			if (isAction(rr)) {
				if (checkAction(rr, "get_model")) {
					String brand_id = WebUtils.getReqString(rr.req, "brand");
					kson.setSuccess();
					kson.setGson("model", gson.toJson(Models.selectList(brand_id)));
					rr.outTH(kson.getJson());
				}
			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}
}
