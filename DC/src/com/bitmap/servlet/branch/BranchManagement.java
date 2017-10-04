package com.bitmap.servlet.branch;

import javax.servlet.ServletException;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;
import com.bitmap.bean.branch.Branch;
import com.bitmap.bean.branch.BranchMaster;
public class BranchManagement extends ServletUtils{
	private static final long serialVersionUID = 1L;
	
	public BranchManagement() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (isAction(rr)) {
				if (checkAction(rr, "addCode")) {
					Branch entity = new Branch();
					WebUtils.bindReqToEntity(entity, rr.getRequest());
					Branch.update(entity);
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
			}
			if (checkAction(rr, "add_branch")) {
				BranchMaster entity = new BranchMaster();
				WebUtils.bindReqToEntity(entity, rr.req);
				
				
				if (BranchMaster.checkBCodeName(entity.getBranch_code(), entity.getBranch_name())) {
					
					kson.setSuccess();
					kson.setData("check", "CodeName");
					rr.outTH(kson.getJson());
				}
				else {
					
					if (BranchMaster.checkName(entity.getBranch_name())) {
							
							kson.setSuccess();
							kson.setData("check", "Name");
							rr.outTH(kson.getJson());
						
					}
				
					else if (BranchMaster.checkCode(entity.getBranch_code())) {
							
							kson.setSuccess();
							kson.setData("check", "Code");
							rr.outTH(kson.getJson());
					}
					else {
						
						BranchMaster.insert(entity);
						kson.setData("check", "success");
						kson.setSuccess();
						rr.outTH(kson.getJson());
						
					}
					
				}
			
				
			}
			if(checkAction(rr,"edit_Branch")){               
				
				BranchMaster entity = new BranchMaster();
				WebUtils.bindReqToEntity(entity, rr.req);
				
			if (BranchMaster.checkBCodeName(entity.getBranch_code(), entity.getBranch_name())) {
					
					BranchMaster branch = BranchMaster.selectcheckCodeName(entity.getBranch_id(), entity.getBranch_code(), entity.getBranch_name());	
					if (!branch.getBranch_province().equalsIgnoreCase("")) {
							BranchMaster.update(entity);
							kson.setSuccess();
							kson.setData("branch_id", "success");
							rr.outTH(kson.getJson());
						}
						else {
							kson.setSuccess();
							kson.setData("branch_id", "errorCodeName");
							rr.outTH(kson.getJson());
						}
			}
			else {
				
					if (BranchMaster.checkCode(entity.getBranch_code())) {
		
							
							BranchMaster branch = BranchMaster.selectcheckCode(entity.getBranch_id(), entity.getBranch_code());
								if (!branch.getBranch_province().equalsIgnoreCase("")) {
									
									if (BranchMaster.checkName(entity.getBranch_name())) {
										BranchMaster branch2 = BranchMaster.selectcheckName(entity.getBranch_id(),entity.getBranch_name());
										
											if (!branch2.getBranch_province().equalsIgnoreCase("")) {
												BranchMaster.update(entity);
												kson.setSuccess();
												kson.setData("branch_id", "success");
												rr.outTH(kson.getJson());
											}else{
												kson.setSuccess();
												kson.setData("branch_id", "errorName");
												rr.outTH(kson.getJson());
											}
									
									}else{
									BranchMaster.update(entity);
									kson.setSuccess();
									kson.setData("branch_id", "success");
									rr.outTH(kson.getJson());
									}
								
								
							}else {
								
								kson.setSuccess();
								kson.setData("branch_id", "errorCode");
								rr.outTH(kson.getJson());
								
							}
							
								
					}
					else {
							
								BranchMaster.update(entity);
								kson.setSuccess();
								kson.setData("branch_id", "success");
								rr.outTH(kson.getJson());
							
						}
				
						
			}
				
				
				
				
				
				
				/*if (BranchMaster.selectcheck(entity.getBranch_id(),entity.getBranch_name())) {
					kson.setSuccess();
					kson.setData("branch_id", "success");
				}else {
					kson.setSuccess();
					kson.setData("branch_id", entity.getBranch_id());
					rr.outTH(kson.getJson());
				}*/
				
				
				
				
				
			
			}
			if(checkAction(rr,"delete_branch")){               
				BranchMaster entity = new BranchMaster();
				WebUtils.bindReqToEntity(entity, rr.req);
				BranchMaster.delete(entity);
				kson.setSuccess();
				kson.setData("branch_id", entity.getBranch_id());
				rr.outTH(kson.getJson());
			}
			
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}
}