package com.bitmap.servlet.service;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.ServletException;

import com.bitmap.bean.service.RepairLaborMechanic;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class MechanicTaskManage
 */
public class MechanicTaskManage extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public MechanicTaskManage() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (getAction(rr).length() > 0) {
				if (checkAction(rr, "active")) {
					RepairLaborMechanic laborMec = new RepairLaborMechanic();
					WebUtils.bindReqToEntity(laborMec, rr.req);
					RepairLaborMechanic.active(laborMec);
				} 
					
				if (checkAction(rr, "hold")) {
					RepairLaborMechanic laborMec = new RepairLaborMechanic();
					WebUtils.bindReqToEntity(laborMec, rr.req);
					RepairLaborMechanic.hold(laborMec);
				} 
					
				if (checkAction(rr, "unhold")) {
					RepairLaborMechanic laborMec = new RepairLaborMechanic();
					WebUtils.bindReqToEntity(laborMec, rr.req);
					RepairLaborMechanic.unhold(laborMec);
				}
					
				if (checkAction(rr, "close")) {
					RepairLaborMechanic laborMec = new RepairLaborMechanic();
					WebUtils.bindReqToEntity(laborMec, rr.req);
					RepairLaborMechanic.closed(laborMec);
				}
				redirect(rr, "mechanic_task_list.jsp");
			}
		} catch (IOException e) {
			kson.setError(e);
			rr.out(kson.getJson());
		} catch (IllegalArgumentException e) {
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
		}
	}
}