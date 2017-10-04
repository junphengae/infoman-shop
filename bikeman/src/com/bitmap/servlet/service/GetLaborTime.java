package com.bitmap.servlet.service;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;

import javax.servlet.ServletException;

import com.bitmap.bean.service.LaborMain;
import com.bitmap.bean.service.LaborTime;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class GetLaborTime
 */
public class GetLaborTime extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public GetLaborTime() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (getAction(rr).length() > 0) {
				if (checkAction(rr, "GetMain")) {
					String cate_id = getParam(rr, "cate_id");
					rr.out(WebUtils.getResponseString(gson.toJson(LaborMain.list(cate_id))));
				}
				
				if (checkAction(rr, "GetLabor")){
					String main_id = getParam(rr, "main_id");
					rr.out(WebUtils.getResponseString(gson.toJson(LaborTime.list(main_id))));
				}
				
				if (checkAction(rr, "Search")){
					String main_id = getParam(rr, "main_id");
					String cate_id = getParam(rr, "cate_id");
					rr.out(WebUtils.getResponseString(gson.toJson(LaborTime.listsearch(main_id,cate_id))));
				}
				
				if (checkAction(rr, "Searchcate")){
					String cate_id = getParam(rr, "cate_id");
					rr.out(WebUtils.getResponseString(gson.toJson(LaborTime.listsearchcate(cate_id))));
				}
				
			
			}
			
		} catch (UnsupportedEncodingException e) {
			kson.setError(e);
			rr.out(kson.getJson());
		} catch (SQLException e) {
			kson.setError(e);
			rr.out(kson.getJson());
		} catch (IllegalAccessException e) {
			kson.setError(e);
			rr.out(kson.getJson());
		} catch (InvocationTargetException e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}
}