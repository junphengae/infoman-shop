package com.bmp.utils.reference.servlet;

import com.bitmap.security.SecurityProfile;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;
import com.bmp.utits.reference.transaction.BmpAmphurTS;
import com.bmp.utits.reference.transaction.BmpTumbolTS;

import javax.servlet.ServletException;

/**
 * Servlet implementation class ReferenceUtilsServlet
 */
public class ReferenceUtilsServlet extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see ServletUtils#ServletUtils()
     */
    public ReferenceUtilsServlet() {
        super();
    }


	@Override
	public void doPost(ReqRes rr) throws ServletException {
		try{
			SecurityProfile securProfile = (SecurityProfile)getSession(rr, "securProfile");
			if (securProfile.isLogin()) {
				
				
				if (checkAction(rr, "get_amphur")) {					
					String pv = WebUtils.getReqString(rr.req, "pv");					
					kson.setGson("bmp_amphur_list", gson.toJson( BmpAmphurTS.SelectListByProvince(pv) ) );					
					kson.setData("result", true);
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				if (checkAction(rr, "get_tumbol")) {
					String amp = WebUtils.getReqString(rr.req, "amp");	
					String pv = WebUtils.getReqString(rr.req, "pv");	
					kson.setGson("bmp_tumbol_list", gson.toJson( BmpTumbolTS.SelectListByAmphurAndProvince(pv,amp) ) );					
					kson.setData("result", true);
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				 
				
				
				
			}else{
				kson.setData("result", false);
				kson.setError("Login Session Timeout : กรุณา Login เข้าสู่ระบบใหม่");
				rr.outTH(kson.getJson());	
			}
			
		}catch(Exception e){
			kson.setError(e);
			rr.out(kson.getJson());
		}
		
		
		
	}

}