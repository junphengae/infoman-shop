package com.bitmap.servlet.service;

import javax.servlet.ServletException;

import com.bitmap.bean.service.LaborCate;
import com.bitmap.bean.service.LaborMain;
import com.bitmap.bean.service.LaborTime;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class LaborManagement
 */
public class LaborManagement extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public LaborManagement() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (getAction(rr).length() > 0) {
				if (checkAction(rr, "GetMain")) {
					String cate_id = getParam(rr, "cate_id");
					kson.setSuccess();
					kson.setGson("laborMain", gson.toJson(LaborMain.list(cate_id)));
					rr.out(WebUtils.getResponseString(kson.getJson()));
				}
				
				if (checkAction(rr, "GetLabor")){
					String main_id = getParam(rr, "main_id");
					kson.setSuccess();
					kson.setGson("laborTime",gson.toJson(LaborTime.list(main_id)));
					rr.out(WebUtils.getResponseString(kson.getJson()));
				}
				
				if (checkAction(rr, "add_labor_cate")) {
					LaborCate cate = new LaborCate();
					WebUtils.bindReqToEntity(cate, rr.req);
					LaborCate.insert(cate);
					kson.setSuccess();
					kson.setGson(gson.toJson(cate));
					rr.out(WebUtils.getResponseString(kson.getJson()));
				}
				
				if (checkAction(rr, "edit_labor_cate")) {
					LaborCate cate = new LaborCate();
					WebUtils.bindReqToEntity(cate, rr.req);
					LaborCate.update(cate);
					kson.setSuccess();
					rr.out(WebUtils.getResponseString(kson.getJson()));
				}
				
				if (checkAction(rr, "add_labor_main")) {
					LaborMain main = new LaborMain();
					WebUtils.bindReqToEntity(main, rr.req);
					LaborMain.insert(main);
					kson.setSuccess();
					kson.setGson(gson.toJson(main));
					rr.out(WebUtils.getResponseString(kson.getJson()));
				}
				
				if (checkAction(rr, "edit_labor_main")) {
					LaborMain main = new LaborMain();
					WebUtils.bindReqToEntity(main, rr.req);
					LaborMain.update(main);
					kson.setSuccess();
					rr.out(WebUtils.getResponseString(kson.getJson()));
				}
				
				if (checkAction(rr, "add_labor_time")) {
					LaborTime time = new LaborTime();
					WebUtils.bindReqToEntity(time, rr.req);
					LaborTime.insert(time);
					kson.setSuccess();
					kson.setGson(gson.toJson(time));
					rr.out(WebUtils.getResponseString(kson.getJson()));
				}
				
				if (checkAction(rr, "edit_labor_time")) {
					LaborTime time = new LaborTime();
					WebUtils.bindReqToEntity(time, rr.req);
					LaborTime.update(time);
					kson.setSuccess();
					rr.out(WebUtils.getResponseString(kson.getJson()));
				}
			} else {
				redirect(rr, "labor_time.jsp");
			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
			//e.printStackTrace();
		}
	}
}