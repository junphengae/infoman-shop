package com.bitmap.security;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.ParseException;


import com.bitmap.dbutils.DBUtility;
import com.bitmap.webservice.WSLogUpdateBean;
import com.bitmap.webservice.WSLogUpdateTS;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * k_negative 2010-10-05
 */
public class LoginServlet extends ServletUtils {
	private static final long serialVersionUID = 1L;
        
    public LoginServlet() {
        super();
    }

	public void doPost(ReqRes rr) {
		try {
			SecurityUser entity = new SecurityUser();
			WebUtils.bindReqToEntity(entity, rr.req);
			
			SecurityProfile profile = SecurityProfile.login(entity);
			setSession(rr, "securProfile", profile);
			
			if (profile.isLogin()) {
				
				//======= นัฐยาทำการเช็ค login คนแรกที่เข้าระบบ เพื่อ update web service ======//
				WSLogUpdateBean log = WSLogUpdateTS.selectSession("login_session");
				String logDate =WebUtils.getDateValue(log.getUpdate_date());
				String date = WebUtils.getDateValue(DBUtility.getCurrentDate());
				
				if (date.equalsIgnoreCase(logDate)) {
					
					kson.setSuccess();
					kson.setData("log", "success");
					rr.out(kson.getJson());
				}else{
					
					//redirect(rr, rr.req.getRequestURL().toString().replaceAll(rr.req.getRequestURI(), "")+"/WSClient/CallWSSevrlet?action=updateShopToDc");
					kson.setSuccess();
					kson.setData("log", "updateWebService");
					rr.out(kson.getJson());
				}
				//===============================================================//
				
			} else {
				kson.setError("login error");
				rr.out(kson.getJson());
			}
		} catch (IllegalArgumentException e) {
			kson.setError(e);
			rr.out(kson.getJson());
		} catch (UnsupportedEncodingException e) {
			kson.setError(e);
			rr.out(kson.getJson());
		} catch (ParseException e) {
			kson.setError(e);
			rr.out(kson.getJson());
		} catch (IllegalAccessException e) {
			kson.setError(e);
			rr.out(kson.getJson());
		} catch (InvocationTargetException e) {
			kson.setError(e);
			rr.out(kson.getJson());
		} catch (SQLException e) {
			kson.setError(e);
			rr.out(kson.getJson());
		} catch (IOException e) {
			
			kson.setError(e);
			rr.out(kson.getJson());
			e.printStackTrace();
		}
	}
}