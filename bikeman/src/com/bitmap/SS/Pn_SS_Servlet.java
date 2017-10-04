package com.bitmap.SS;

import javax.servlet.ServletException;
import com.bitmap.bean.parts.PartMaster;
import com.bitmap.bean.parts.ServicePartDetail;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class TestPnServlet
 */
public class Pn_SS_Servlet extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public Pn_SS_Servlet() {
        super();
    }


	@Override
	public void doPost(ReqRes rr) throws ServletException {
		try {
			if(checkAction(rr, "getDetailSS")){
				String pn 		= WebUtils.getReqString(rr.req, "pn");
				String id 		= WebUtils.getReqString(rr.req, "id");
				String des		= PartMaster.select(pn).getDescription();
				String price	= PartMaster.select(pn).getPrice();
				String stockqty = PartMaster.select(pn).getQty();
				String moq		= PartMaster.select(pn).getMoq();
				String base_qty =  ServicePartDetail.selectQty(id, pn);
				
				kson.setGson("des", gson.toJson(des));
				kson.setGson("price", gson.toJson(price));
				kson.setGson("stockqty", gson.toJson(stockqty));
				kson.setGson("moq", gson.toJson(moq));
				kson.setGson("base_qty", gson.toJson(base_qty));
				kson.setSuccess("success");	
				rr.outTH(kson.getJson());
			}
		} catch (Exception e) {
			kson.setError("ERR"+e);
		}
		
	}

}
