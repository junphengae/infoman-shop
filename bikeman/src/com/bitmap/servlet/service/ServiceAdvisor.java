package com.bitmap.servlet.service;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;

import com.bitmap.bean.customerService.RepairOrder;
import com.bitmap.bean.customerService.WithdrawPart;
import com.bitmap.bean.hr.Personal;
import com.bitmap.bean.parts.ServiceRepair;
import com.bitmap.bean.service.RepairLaborMechanic;
import com.bitmap.bean.service.RepairLaborTime;
import com.bitmap.webutils.PageControl;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;


/**
 * Servlet implementation class ServiceAdvisor
 */
public class ServiceAdvisor extends ServletUtils {
	private static final long serialVersionUID = 1L;
   
    public ServiceAdvisor() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (getAction(rr).length() > 0) {
				
				// -- Save Labor for Quotation --
				if (checkAction(rr, "qt_save_labor")) {
					RepairLaborTime entity = new RepairLaborTime();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					if (RepairLaborTime.insert4QT(entity)) {
						kson.setSuccess();
						kson.setData("number", entity.getNumber());
					} else {
						kson.setError("Duplicated data!");
					}
					rr.out(kson.getJson());
				} 
					
				if (checkAction(rr, "qt_remove_labor")){
					RepairLaborTime entity = new RepairLaborTime();
					WebUtils.bindReqToEntity(entity, rr.req);
					RepairLaborTime.delete4QT(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				} 
				// -- End --
				
				if (checkAction(rr, "outsource_status")) {
					RepairLaborTime entity = new RepairLaborTime();
					WebUtils.bindReqToEntity(entity, rr.req);
					RepairLaborTime.outsource(entity);
					
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "save_labor")) {
					RepairLaborTime entity = new RepairLaborTime();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					if (RepairLaborTime.insert(entity)) {
						kson.setSuccess();
					} else {
						kson.setError("Duplicated data!");
					}
					rr.out(kson.getJson());
				} 
					
				if (checkAction(rr, "remove_labor")){
					RepairLaborTime entity = new RepairLaborTime();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					WithdrawPart wPart = new WithdrawPart();
					wPart.setId(entity.getId());
					wPart.setLabor_id(entity.getLabor_id());
					wPart.setLabor_id_number(entity.getNumber());
					if (WithdrawPart.checkPart(wPart)) {
						kson.setError("ไม่สามารถลบรายการซ่อมนี้ได้ เนื่องจากอะไหล่ที่เบิกยังไม่ได้ส่งคืน Store!");
					} else {
						RepairLaborTime.delete(entity);
						kson.setSuccess();
					}
					rr.out(WebUtils.getResponseString(kson.getJson()));
				} 
				
				if (checkAction(rr, "terminate_labor")){
					RepairLaborTime entity = new RepairLaborTime();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					WithdrawPart wPart = new WithdrawPart();
					wPart.setId(entity.getId());
					wPart.setLabor_id(entity.getLabor_id());
					wPart.setLabor_id_number(entity.getNumber());
					if (WithdrawPart.checkPart(wPart)) {
						kson.setError("ไม่สามารถลบรายการซ่อมนี้ได้ เนื่องจากอะไหล่ที่เบิกยังไม่ได้ส่งคืน Store!");
					} else {
						RepairLaborTime.terminate(entity);
						kson.setSuccess();
					}
					
					rr.out(WebUtils.getResponseString(kson.getJson()));
				} 
				
				if (checkAction(rr, "reject_labor")){
					RepairLaborTime entity = new RepairLaborTime();
					WebUtils.bindReqToEntity(entity, rr.req);
					RepairLaborTime.terminateReject(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				} 
					
				if(checkAction(rr, "get_mechanic")){
					String mecData = WebUtils.getResponseString(gson.toJson(Personal.listMechanic()));
					rr.out(mecData);
				} 
					
				if (checkAction(rr, "save_mechanic")){
					RepairLaborMechanic entity = new RepairLaborMechanic();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					String mec_id = getParam(rr, "mec_id");
					String[] mec_id_array = mec_id.split("_");
					
					// check divide by half
					if (mec_id_array.length > 1) {
						if (getParam(rr, "divide").equalsIgnoreCase("true")) {
							Double hourD = Double.parseDouble(entity.getLabor_hour());
							entity.setLabor_hour((hourD / mec_id_array.length) + "");
						}
					}
					
					RepairLaborMechanic.insert(entity,mec_id_array);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
			} else {
				
//				String page = getParam(rr, "page");
//				PageControl ctrl = new PageControl();
//				List<RepairOrder> repairList = new ArrayList<RepairOrder>();
//				
//				if (page.length() > 0) {
//					ctrl = (PageControl) getSession(rr, "PAGE_CTRL");
//					ctrl.setPage_num(Integer.parseInt(page));
//					
//					repairList = RepairOrder.list4InboxService(ctrl);
//					setSession(rr, "PAGE_CTRL", ctrl);
//					setSession(rr, "INBOX_SERVICE_LIST", repairList);
//				} else {
//					repairList = RepairOrder.list4InboxService(ctrl);
//					setSession(rr, "PAGE_CTRL", ctrl);
//					setSession(rr, "INBOX_SERVICE_LIST", repairList);
//				}
//				redirect(rr, "sa_inbox_service_list.jsp");
				
				
				String page = getParam(rr, "page");
				PageControl ctrl = new PageControl();
				List<ServiceRepair> repairList = new ArrayList<ServiceRepair>();
				
				
				if (page.length() > 0) {
					ctrl = (PageControl) getSession(rr, "PAGE_CTRL");
					ctrl.setPage_num(Integer.parseInt(page));
					
					repairList = ServiceRepair.list4InboxService(ctrl);
					setSession(rr, "PAGE_CTRL", ctrl);
					setSession(rr, "INBOX_SERVICE_LIST", repairList);
				} else {
					repairList = ServiceRepair.list4InboxService(ctrl);
					setSession(rr, "PAGE_CTRL", ctrl);
					setSession(rr, "INBOX_SERVICE_LIST", repairList);
				}
				redirect(rr, "sa_inbox_service_list.jsp");
				
				
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