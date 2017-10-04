package com.bitmap.servlet.service;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;

import com.bitmap.bean.customerService.RepairOrder;
import com.bitmap.bean.parts.ServiceRepair;
import com.bitmap.bean.service.RepairLaborTime;
import com.bitmap.webutils.PageControl;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;


/**
 * Servlet implementation class QualityControl
 */
public class QualityControl extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public QualityControl() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (getAction(rr).length() > 0) {
				if (checkAction(rr, "submit")) {
					RepairLaborTime entity = new RepairLaborTime();
					WebUtils.bindReqToEntity(entity, rr.req);
					RepairLaborTime.submit(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				} 
				
				//TODO เพิ่มเติมการเก็บรายการ Reject
				if (checkAction(rr, "reject")) {
					RepairLaborTime entity = new RepairLaborTime();
					WebUtils.bindReqToEntity(entity, rr.req);
					RepairLaborTime.reject(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
			} else {
				String page = getParam(rr, "page");
				PageControl ctrl = new PageControl();
				//List<RepairOrder> repairList = new ArrayList<RepairOrder>();
				List<ServiceRepair> serviceRepairs = new ArrayList<ServiceRepair>();
				
			/*	if (page.length() > 0) {
					ctrl = (PageControl) getSession(rr, "PAGE_CTRL");
					ctrl.setPage_num(Integer.parseInt(page));
					
					repairList = RepairOrder.list4QC(ctrl);
					setSession(rr, "PAGE_CTRL", ctrl);
					setSession(rr, "QC_LIST", repairList);
				} else {
					repairList = RepairOrder.list4QC(ctrl);
					setSession(rr, "PAGE_CTRL", ctrl);
					setSession(rr, "QC_LIST", repairList);
				}*/				
				
				if (page.length() > 0) {
					ctrl = (PageControl) getSession(rr, "PAGE_CTRL");
					ctrl.setPage_num(Integer.parseInt(page));
					
					serviceRepairs = ServiceRepair.list4QC(ctrl);
					setSession(rr, "PAGE_CTRL", ctrl);
					setSession(rr, "QC_LIST", serviceRepairs);
				} else {
					serviceRepairs = ServiceRepair.list4QC(ctrl);
					setSession(rr, "PAGE_CTRL", ctrl);
					setSession(rr, "QC_LIST", serviceRepairs);
				}
				redirect(rr, "qc_list.jsp");
			}
		} catch (IOException e) {
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
		} catch (IllegalArgumentException e) {
			kson.setError(e);
			rr.out(kson.getJson());
		} catch (ParseException e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}
}