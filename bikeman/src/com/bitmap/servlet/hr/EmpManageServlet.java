package com.bitmap.servlet.hr;

import java.util.Calendar;

import javax.servlet.ServletException;


import com.bitmap.bean.hr.Division;
import com.bitmap.bean.hr.Leave;
import com.bitmap.bean.hr.Msg;
import com.bitmap.bean.hr.PersonalDetail;
import com.bitmap.bean.hr.Position;
import com.bitmap.bean.hr.Salary;
import com.bitmap.bean.hr.SalaryHistory;
import com.bitmap.bean.hr.SumSalary;
import com.bitmap.security.SecurityUser;
import com.bitmap.security.SecurityUserRole;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;
import com.bitmap.bean.hr.Personal;
import com.bitmap.dbutils.DBUtility;
import com.bmp.special.fn.DateFunctional;

/**
 * Servlet implementation class EmpManageServlet
 */

public class EmpManageServlet extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public EmpManageServlet() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (isAction(rr)) {
				if (checkAction(rr, "getDivision")){
					String dep_id = WebUtils.getReqString(rr.req, "dep_id");
					rr.outTH(gson.toJson(Division.getUIObjectDivision()));
				}
				
				if (checkAction(rr, "getPosition")){
					rr.outTH(gson.toJson(Position.getUIObjectPosition()));
				}
				
				if (checkAction(rr, "add")) {
					//System.out.println("Hi");
					Personal personal = new Personal();
					
					String start_date = WebUtils.getReqString(rr.req, "date_start_");	
					//System.out.println(start_date);
					if (!start_date.equalsIgnoreCase("")) {
						personal.setDate_start(DateFunctional.Formatter(start_date));
					}
					
					WebUtils.bindReqToEntity(personal, rr.req);
					//System.out.println("Start : "+personal.getDate_start());
					
					
					Personal.insert(personal);
					kson.setSuccess();
					kson.setData("per_id", personal.getPer_id());
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "edit")) {
					Personal personal = new Personal();
					
					String start_date = WebUtils.getReqString(rr.req, "date_start_");
					//System.out.println(start_date);
					if (!start_date.equalsIgnoreCase("")) {
						personal.setDate_start(DateFunctional.Formatter(start_date));
					}
					
					WebUtils.bindReqToEntity(personal, rr.req);
					Personal.update(personal);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "addRole")) {
					SecurityUserRole entity = new SecurityUserRole();
					WebUtils.bindReqToEntity(entity, rr.req);
					SecurityUserRole.addRole(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "delRole")) {
					SecurityUserRole entity = new SecurityUserRole();
					WebUtils.bindReqToEntity(entity, rr.req);
					SecurityUserRole.delRole(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "savePass")) {
					SecurityUser entity = new SecurityUser();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					SecurityUser enDB = new SecurityUser();
					enDB.setUser_id(entity.getUser_id());
					SecurityUser.select(enDB);
									
					boolean isAlready = true;
					if (! enDB.getUser_name().equalsIgnoreCase(entity.getUser_name())) {
						
						if (SecurityUser.CheckUserName(entity)) {
							kson.setError("ไม่สามารถบันทึกได้ เนื่องจากมีผู้ใช้  User Name นี้แล้ว");
							rr.outTH(kson.getJson());
							isAlready = false;
						}
						
					}
					System.out.println(isAlready);	
					if (isAlready) {						
						SecurityUser.updateUserPassword(entity);								
						kson.setSuccess();
						rr.out(kson.getJson());
					}
					
				}
				if (checkAction(rr, "editSalary")) {
					Salary entity = new Salary();
					WebUtils.bindReqToEntity(entity, rr.req);
					Salary.insertSalary(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr,"add_leave")) {
					Leave entity = new Leave();
					WebUtils.bindReqToEntity(entity, rr.req);
					String chk1 = getParam(rr, "chk1");
					
					if (chk1.length()>0){
						Calendar sd = DBUtility.calendar();
						sd.setTime(entity.getLeave_date());
						
						Calendar ed = DBUtility.calendar();
						ed.setTime(entity.getLeave_date_end());
						
						boolean run = true;
						while(run){
							if (sd.compareTo(ed) == 0) {
								entity.setLeave_date(sd.getTime());
								Leave.insert(entity);
								run = false;
								break;
							} else {
								entity.setLeave_date(sd.getTime());
								Leave.insert(entity);
								sd.add(Calendar.DATE, +1);
							}
						}
					}else{
						Leave.insert(entity);
					}
					
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr,"edit_leave")) {
					Leave entity = new Leave();
					WebUtils.bindReqToEntity(entity, rr.req);
					Leave.update(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr,"add_emp_sum")) {
					SumSalary entity = new SumSalary();
					WebUtils.bindReqToEntity(entity, rr.req);
					SumSalary.insert(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr,"edit_emp_sum")) {
					SumSalary entity = new SumSalary();
					WebUtils.bindReqToEntity(entity, rr.req);
					SumSalary.update(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr,"add_salary_history")) {
					SalaryHistory entity = new SalaryHistory();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					String flag_tax = getParam(rr, "flag_tax");
					SalaryHistory.insert(entity);
					Salary.updateSalaryNew(entity.getPer_id(), entity.getSalary_new(),flag_tax);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "edit_detail")) {
					PersonalDetail entity = new PersonalDetail();
					WebUtils.bindReqToEntity(entity, rr.req);
					PersonalDetail.insertDetail(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				
				
				if (checkAction(rr, "confirm_leave")) {
					Leave entity = new Leave();
					WebUtils.bindReqToEntity(entity, rr.req);
					Leave.updateStatusApv(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if(checkAction(rr,"msg_send")){
					Msg entity = new Msg();
					WebUtils.bindReqToEntity(entity, rr.getRequest());
					Msg.insertMsg(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "add_tag_id")) {
					Personal entity = new Personal();
					WebUtils.bindReqToEntity(entity, rr.req);
					boolean tag = Personal.updateTagID(entity.getPer_id(), entity.getTag_id());
					if(tag){
						kson.setError("รหัสพนักงานซ้ำ กรุณาตรวจสอบ !");
					}else {
						kson.setSuccess();
					}
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "edit_status")) {
					SecurityUser entity = new SecurityUser();
					WebUtils.bindReqToEntity(entity, rr.req);
					SecurityUser.updateActive(entity);
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				
			} else {

			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}

}
