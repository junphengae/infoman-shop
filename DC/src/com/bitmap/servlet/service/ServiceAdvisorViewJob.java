package com.bitmap.servlet.service;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;

import com.bitmap.bean.customerService.RepairOrder;
import com.bitmap.bean.parts.ServiceRepair;
import com.bitmap.webutils.PageControl;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;

/**
 * Servlet implementation class ServiceAdvisorViewJob
 */
public class ServiceAdvisorViewJob extends ServletUtils {
	private static final long serialVersionUID = 1L;
    
    public ServiceAdvisorViewJob() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (getAction(rr).length() > 0) {
				
			} else {
//				String page = getParam(rr, "page");
//				PageControl ctrl = new PageControl();
//				List<RepairOrder> repairList = new ArrayList<RepairOrder>();
//				
//				if (page.length() > 0) {
//					ctrl = (PageControl) getSession(rr, "PAGE_CTRL");
//					ctrl.setPage_num(Integer.parseInt(page));
//					
//					repairList = RepairOrder.list4ViewJob(ctrl);
//					setSession(rr, "PAGE_CTRL", ctrl);
//					setSession(rr, "JOB_LIST", repairList);
//				} else {
//					repairList = RepairOrder.list4ViewJob(ctrl);
//					setSession(rr, "PAGE_CTRL", ctrl);
//					setSession(rr, "JOB_LIST", repairList);
//				}
//				redirect(rr, "sa_job_list.jsp");
				
				
				String page = getParam(rr, "page");
				PageControl ctrl = new PageControl();
				List<ServiceRepair> repairList = new ArrayList<ServiceRepair>();
				
				if (page.length() > 0) {
					ctrl = (PageControl) getSession(rr, "PAGE_CTRL");
					ctrl.setPage_num(Integer.parseInt(page));
					
					repairList = ServiceRepair.list4ViewJob(ctrl);
					setSession(rr, "PAGE_CTRL", ctrl);
					setSession(rr, "JOB_LIST", repairList);
				} else {
					repairList = ServiceRepair.list4ViewJob(ctrl);
					setSession(rr, "PAGE_CTRL", ctrl);
					setSession(rr, "JOB_LIST", repairList);
				}
				redirect(rr, "sa_job_list.jsp");
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
		}
	}
}