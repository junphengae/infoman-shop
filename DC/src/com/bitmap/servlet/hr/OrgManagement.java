package com.bitmap.servlet.hr;

import java.util.Calendar;
import java.util.Date;

import javax.servlet.ServletException;


import com.bitmap.bean.hr.AttendanceTime;
import com.bitmap.bean.hr.Department;
import com.bitmap.bean.hr.Division;
import com.bitmap.bean.hr.Leave;
import com.bitmap.bean.hr.Missing;
import com.bitmap.bean.hr.OTRequest;

import com.bitmap.bean.hr.Position;
import com.bitmap.bean.hr.SumSalary;
import com.bitmap.bean.hr.YearHolidays;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class OrgManagement
 */

public class OrgManagement extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public OrgManagement() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (checkAction(rr,"getDiv")) {
				String dep_id = getParam(rr, "dep_id");
				kson.setSuccess();
				kson.setGson("div", gson.toJson(Division.getUIObjectDivision(dep_id)));
				rr.outTH(kson.getJson());
			}
			
			if (checkAction(rr,"add_dep")) {
				

				
				Department entity = new Department();
				WebUtils.bindReqToEntity(entity, rr.req);
				
				
				if (Department.checkName(entity.getDep_name_th(), entity.getDep_name_en())) {
					
							kson.setSuccess();
							kson.setData("check", "Name");
							rr.out(kson.getJson());
							
							
				}else{
					
					
					  if (Department.checkName_th(entity.getDep_name_th())) {
						 
						  kson.setSuccess();
							kson.setData("check", "Name_th");
							rr.out(kson.getJson());
					 }
					  else if (Department.checkName_en(entity.getDep_name_en())) {
						 
						  	kson.setSuccess();
							kson.setData("check", "Name_en");
							rr.out(kson.getJson());
					 }else{
						 
						Department.insert(entity);
						kson.setSuccess();
						kson.setData("check", "success");
						rr.out(kson.getJson());
						
					 }
					
				}
			
				
		
			}
			
			if (checkAction(rr,"edit_dep")) {
						
		
						
						Department entity = new Department();
						WebUtils.bindReqToEntity(entity, rr.req);
						
						if (Department.checkName(entity.getDep_name_th(), entity.getDep_name_en())) {
							
							////System.out.println("if");
							Department name = Department.selectcheckName(entity.getDep_id(), entity.getDep_name_th(), entity.getDep_name_en());
							if (name.getDate_create() == null) {
								////System.out.println("Name");
								kson.setSuccess();
								kson.setData("check", "Name");
								rr.out(kson.getJson());
								
							}else{
								
								Department.update(entity);
							 	kson.setData("check", "success");
								kson.setSuccess();
								rr.out(kson.getJson());
								
							}
							
							
							
						}else {
							////System.out.println("else");
							
							if (Department.checkName_th(entity.getDep_name_th())) {
								////System.out.println("checkName_th");
								Department name_th = Department.selectcheckName_th(entity.getDep_id(), entity.getDep_name_th());
								  
								if (name_th.getDate_create() == null) {
									////System.out.println("else--Name_th");
									kson.setSuccess();
									kson.setData("check", "Name_th");
									rr.out(kson.getJson());
									
								}else {
									////System.out.println("else--checkName_th");
										   if (Department.checkName_en(entity.getDep_name_en())) {
											   ////System.out.println("checkName_en");
												  Department name_en = Department.selectcheckName_en(entity.getDep_id(), entity.getDep_name_en());
												 
												  if (name_en.getDate_create() == null) {
													 // ////System.out.println("else--Name_en");
													  	kson.setSuccess();
														kson.setData("check", "Name_en");
														rr.out(kson.getJson());
													
												  }else {
													  ////System.out.println("name_en.getDate_create()");
													  	 Department.update(entity);
													 	 kson.setData("check", "success");
														 kson.setSuccess();
														 rr.out(kson.getJson());
													
												  }
												  	
											 }
											else {
												////System.out.println("else--checkName_en");
												
											  	 Department.update(entity);
											 	 kson.setData("check", "success");
												 kson.setSuccess();
												 rr.out(kson.getJson());
											
										    }
									 
								}
								
									
							 
							} else if (Department.checkName_en(entity.getDep_name_en())) {
								   ////System.out.println("checkName_en");
									  Department name_en = Department.selectcheckName_en(entity.getDep_id(), entity.getDep_name_en());
									 
									  if (name_en.getDate_create() == null) {
										 // ////System.out.println("else--Name_en");
										  	kson.setSuccess();
											kson.setData("check", "Name_en");
											rr.out(kson.getJson());
										
									  }else {
										  
										  if (Department.checkName_th(entity.getDep_name_th())) {
												////System.out.println("checkName_th");
												Department name_th = Department.selectcheckName_th(entity.getDep_id(), entity.getDep_name_th());
												  
												if (name_th.getDate_create() == null) {
													////System.out.println("else--Name_th");
													kson.setSuccess();
													kson.setData("check", "Name_th");
													rr.out(kson.getJson());
													
												}else{
													 ////System.out.println("name_th.getDate_create()");
												  	 Department.update(entity);
												 	 kson.setData("check", "success");
													 kson.setSuccess();
													 rr.out(kson.getJson());
												}
										  
										
										
									       }else{
												 ////System.out.println("name_th.getDate_create()");
											  	 Department.update(entity);
											 	 kson.setData("check", "success");
												 kson.setSuccess();
												 rr.out(kson.getJson());
											}
									 }  	
							}
							else {
								
							  	 Department.update(entity);
							 	 kson.setData("check", "success");
								 kson.setSuccess();
								 rr.out(kson.getJson());
							
						    }
							
						}
						
					
			}
			
			if (checkAction(rr,"edit_div")) {
						
		
						Division entity = new Division();
						WebUtils.bindReqToEntity(entity, rr.req);
						
						if (Division.checkName(entity.getDiv_name_th(), entity.getDiv_name_en())) {
							
							////System.out.println("if");
							Division name = Division.selectcheckName(entity.getDiv_id(), entity.getDiv_name_th(), entity.getDiv_name_en());
							if (name.getDate_create() == null) {
								////System.out.println("Name");
								kson.setSuccess();
								kson.setData("check", "Name");
								rr.out(kson.getJson());
								
							}else{
								
								Division.update(entity);
							 	kson.setData("check", "success");
								kson.setSuccess();
								rr.out(kson.getJson());
								
							}
							
							
							
						}else {
							////System.out.println("else");
							
							if (Division.checkName_th(entity.getDiv_name_th())) {
								
								Division name_th = Division.selectcheckName_th(entity.getDiv_id(), entity.getDiv_name_th());
								  
								if (name_th.getDate_create() == null) {
									////System.out.println("else--Name_th");
									kson.setSuccess();
									kson.setData("check", "Name_th");
									rr.out(kson.getJson());
									
								}else {
									 
										   if (Division.checkName_en(entity.getDiv_name_en())) {
											   Division name_en = Division.selectcheckName_en(entity.getDiv_id(), entity.getDiv_name_en());
												 
												  if (name_en.getDate_create() == null) {
													  ////System.out.println("else--Name_en");
													  	kson.setSuccess();
														kson.setData("check", "Name_en");
														rr.out(kson.getJson());
													
												  }else {
													  	Division.update(entity);
													 	 kson.setData("check", "success");
														 kson.setSuccess();
														 rr.out(kson.getJson());
													
												  }
												  	
											 }
											else {
												
												Division.update(entity);
											 	 kson.setData("check", "success");
												 kson.setSuccess();
												 rr.out(kson.getJson());
											
										    }
									 
								}
								
							}else  if (Division.checkName_en(entity.getDiv_name_en())) {
								   Division name_en = Division.selectcheckName_en(entity.getDiv_id(), entity.getDiv_name_en());
									 
									  if (name_en.getDate_create() == null) {
										  ////System.out.println("else--Name_en");
										  	kson.setSuccess();
											kson.setData("check", "Name_en");
											rr.out(kson.getJson());
										
									  }else {
										  
										  if (Division.checkName_th(entity.getDiv_name_th())) {
												
												Division name_th = Division.selectcheckName_th(entity.getDiv_id(), entity.getDiv_name_th());
												  
												if (name_th.getDate_create() == null) {
													////System.out.println("else--Name_th");
													kson.setSuccess();
													kson.setData("check", "Name_th");
													rr.out(kson.getJson());
													
												}else {
										  
												  	Division.update(entity);
												 	 kson.setData("check", "success");
													 kson.setSuccess();
													 rr.out(kson.getJson());
												}
										  }
										  else {
											  
											  	Division.update(entity);
											 	 kson.setData("check", "success");
												 kson.setSuccess();
												 rr.out(kson.getJson());
										}
									  	
									  }
							}
							else {
									Division.update(entity);
								 	 kson.setData("check", "success");
									 kson.setSuccess();
									 rr.out(kson.getJson());
								
							 }
						}
					
			}
			
			if(checkAction(rr,"add_div")){
				

				Division entity = new Division();
				WebUtils.bindReqToEntity(entity, rr.req);
				
				if (Division.checkName(entity.getDiv_name_th(), entity.getDiv_name_en())) {
									
									kson.setSuccess();
									kson.setData("check", "Name");
									rr.out(kson.getJson());
									
									
				}else{
							  if (Division.checkName_th(entity.getDiv_name_th())) {
								  
								
								  	kson.setSuccess();
									kson.setData("check", "Name_th");
									rr.out(kson.getJson());
							 }
							  else if (Division.checkName_en(entity.getDiv_name_en())) {
								
								  	kson.setSuccess();
									kson.setData("check", "Name_en");
									rr.out(kson.getJson());
									
							 }else{
								
								 	Division.insert(entity);
									kson.setSuccess();
									kson.setData("check", "success");
									rr.out(kson.getJson());
								
							 }
							
				}
				
				
				
			}
			
			if(checkAction(rr,"delete_div")){
						
			}
			
			if (checkAction(rr,"add_pos")) {
				

				
				Position entity = new Position();
				WebUtils.bindReqToEntity(entity, rr.req);
				
				if (Position.checkName(entity.getPos_name_th(), entity.getPos_name_en())) {
						
							kson.setSuccess();
							kson.setData("check", "Name");
							rr.out(kson.getJson());
							
							
				}else{
					  if (Position.checkName_th(entity.getPos_name_th())) {
						  
						
						  	kson.setSuccess();
							kson.setData("check", "Name_th");
							rr.out(kson.getJson());
					 }
					  else if (Position.checkName_en(entity.getPos_name_en())) {
						
						  	kson.setSuccess();
							kson.setData("check", "Name_en");
							rr.out(kson.getJson());
							
					 }else{
						
							Position.insert(entity);
							kson.setSuccess();
							kson.setData("check", "success");
							rr.out(kson.getJson());
						
					 }
					
				}
			
			
				
			
			}
			
			if (checkAction(rr,"edit_pos")) {
				

				
				Position entity = new Position();
				WebUtils.bindReqToEntity(entity, rr.req);
				
				
				if (Position.checkName(entity.getPos_name_th(), entity.getPos_name_en())) {
					
						////System.out.println("if");
						Position name = Position.selectcheckName(entity.getPos_id(), entity.getPos_name_th(), entity.getPos_name_en());
						if (name.getDate_create() == null) {
							////System.out.println("Name");
							kson.setSuccess();
							kson.setData("check", "Name");
							rr.out(kson.getJson());
							
						}else{
							
							Position.update(entity);
						 	kson.setData("check", "success");
							kson.setSuccess();
							rr.out(kson.getJson());
							
						}
					
					
					
					}else {
						////System.out.println("else");
						if (Position.checkName_th(entity.getPos_name_th())) {
							 ////System.out.println("checkName_th");
							Position name_th = Position.selectcheckName_th(entity.getPos_id(), entity.getPos_name_th());
							  
							if (name_th.getDate_create() == null) {
								////System.out.println("else - Name_th");
								kson.setSuccess();
								kson.setData("check", "Name_th");
								rr.out(kson.getJson());
								
							}else {
								 
									   if (Position.checkName_en(entity.getPos_name_en())) {
										   Position name_en = Position.selectcheckName_en(entity.getPos_id(), entity.getPos_name_en());
											 
											  if (name_en.getDate_create() == null) {
												 ////System.out.println("else - Name_en");
												  	kson.setSuccess();
													kson.setData("check", "Name_en");
													rr.out(kson.getJson());
												
											  }else {
												  Position.update(entity);
												 	 kson.setData("check", "success");
													 kson.setSuccess();
													 rr.out(kson.getJson());
												
											  }
											  	
										 }else {
											  Position.update(entity);
											 	 kson.setData("check", "success");
												 kson.setSuccess();
												 rr.out(kson.getJson());
											
										  }
									
							}
						}else if (Position.checkName_en(entity.getPos_name_en())) {
							
							 ////System.out.println("checkName_en");
							   Position name_en = Position.selectcheckName_en(entity.getPos_id(), entity.getPos_name_en());
								 
								  if (name_en.getDate_create() == null) {
									 ////System.out.println("else - Name_en");
									  	kson.setSuccess();
										kson.setData("check", "Name_en");
										rr.out(kson.getJson());
									
								  }else {
									  
									  ////System.out.println("else--checkName_en");
									  if (Position.checkName_th(entity.getPos_name_th())) {
										  ////System.out.println("else--checkName_en--checkName_th");
											Position name_th = Position.selectcheckName_th(entity.getPos_id(), entity.getPos_name_th());
											  
											if (name_th.getDate_create() == null) {
												////System.out.println("else - Name_th");
												kson.setSuccess();
												kson.setData("check", "Name_th");
												rr.out(kson.getJson());
												
											}else {
											  Position.update(entity);
											 	 kson.setData("check", "success");
												 kson.setSuccess();
												 rr.out(kson.getJson());
											}	
											
									  }else {
										  ////System.out.println("else - Name_th--checkName_en");
										 
										  	Position.update(entity);
										 	 kson.setData("check", "success");
											 kson.setSuccess();
											 rr.out(kson.getJson());
									}	 
								 }  	
						}
						else {
							  Position.update(entity);
							 	 kson.setData("check", "success");
								 kson.setSuccess();
								 rr.out(kson.getJson());
							
						  }
					}
			
				
			}
			
			
			
			if (checkAction(rr,"add_ot")) {
				OTRequest entity = new OTRequest();
				WebUtils.bindReqToEntity(entity, rr.req);
				OTRequest.insert(entity);
				kson.setSuccess();
				rr.out(kson.getJson());
			}
			
			if (checkAction(rr,"edit_ot")) {
				OTRequest entity = new OTRequest();
				WebUtils.bindReqToEntity(entity, rr.req);
				OTRequest.update(entity);
				kson.setSuccess();
				rr.out(kson.getJson());
			}
			
			
			if (checkAction(rr,"edit_time")) {
				AttendanceTime entity = new AttendanceTime();
				WebUtils.bindReqToEntity(entity, rr.req);
				AttendanceTime.update(entity); 
				kson.setSuccess();
				rr.out(kson.getJson());
			}
			
			if (checkAction(rr,"leave_del_per")) {
				Leave entity = new Leave();
				WebUtils.bindReqToEntity(entity, rr.req);
				
				Leave leave = new Leave();
				WebUtils.bindReqToEntity(leave, rr.req);
				
				Leave.delete(entity);
				Calendar c  = Calendar.getInstance();
				c.setTime(leave.getLeave_date());
				String m = Integer.toString(c.get(Calendar.MONTH)+1);
				String y = Integer.toString(c.get(Calendar.YEAR));
				
				//////System.out.println(m);
				
				String cnt = Leave.count_leave(leave.getPer_id(),leave.getLeave_type_id(),m, y);
				SumSalary.updateCnt(leave.getPer_id(),m,y,leave.getLeave_type_id(),cnt);
				
				kson.setSuccess();
				rr.out(kson.getJson());
			}
			
			if (checkAction(rr,"leave_cancel_per")) {
				Leave entity = new Leave();
				WebUtils.bindReqToEntity(entity, rr.req);
				
				Leave leave = new Leave();
				WebUtils.bindReqToEntity(leave, rr.req);
				
				//Leave.delete(entity);
				Leave.updateStatusCancel(entity);
				Calendar c  = Calendar.getInstance();
				c.setTime(leave.getLeave_date());
				String m = Integer.toString(c.get(Calendar.MONTH)+1);
				String y = Integer.toString(c.get(Calendar.YEAR));
				
				//////System.out.println(m);
				
				String cnt = Leave.count_leave(leave.getPer_id(),leave.getLeave_type_id(),m, y);
				SumSalary.updateCnt(leave.getPer_id(),m,y,leave.getLeave_type_id(),cnt);
				
				kson.setSuccess();
				rr.out(kson.getJson());
			}
			
			if (checkAction(rr,"ot_del_per")) {
				OTRequest entity = new OTRequest();
				WebUtils.bindReqToEntity(entity, rr.req);
				OTRequest.delete(entity); 
				kson.setSuccess();
				rr.out(kson.getJson());
			}
			if (checkAction(rr,"add_holidays")) {
				YearHolidays entity = new YearHolidays();
				WebUtils.bindReqToEntity(entity, rr.req);
				YearHolidays.insert(entity); 
				kson.setSuccess();
				rr.out(kson.getJson());
			}
			if (checkAction(rr,"edit_holidays")) {
				YearHolidays entity = new YearHolidays();
				WebUtils.bindReqToEntity(entity, rr.req);
				YearHolidays.update(entity);
				kson.setSuccess();
				rr.out(kson.getJson());
			}
			if (checkAction(rr,"holidays_del")) {
				YearHolidays entity = new YearHolidays();
				WebUtils.bindReqToEntity(entity, rr.req);
				YearHolidays.delete(entity); 
				kson.setSuccess();
				rr.out(kson.getJson());
			}
			if (checkAction(rr,"insert_missing")) {
				Missing entity = new Missing();
				WebUtils.bindReqToEntity(entity, rr.req);
				Missing.insert(entity);
				kson.setSuccess();
				rr.out(kson.getJson());
			}
			
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}
}