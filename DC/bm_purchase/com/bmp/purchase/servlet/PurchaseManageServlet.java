package com.bmp.purchase.servlet;

import javax.servlet.ServletException;

import com.bitmap.bean.purchase.PurchaseOrder;
import com.bitmap.bean.purchase.PurchaseRequest;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;
import com.bmp.purchase.bean.PurchaseOrderBean;
import com.bmp.purchase.bean.PurchaseRequestBean;
import com.bmp.purchase.transaction.PurchaseOrderTS;
import com.bmp.purchase.transaction.PurchaseRequestTS;
import com.bmp.purchase.transaction.PurchaseStatus;



public class PurchaseManageServlet extends ServletUtils {
	private static final long serialVersionUID = 1L;
           
    public PurchaseManageServlet() {
        super();
    }

	@Override
	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (isAction(rr)) {
				if (checkAction(rr, "issue_po")) {
					PurchaseOrderBean po = new PurchaseOrderBean();
					WebUtils.bindReqToEntity(po, rr.req);
				
					String po_no = PurchaseOrderTS.createPO(po);
					kson.setSuccess();
					kson.setData("po", po_no);
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "issue_po_edit")) {
					PurchaseOrderBean po = new PurchaseOrderBean();
					WebUtils.bindReqToEntity(po, rr.req);
				
					String po_no = PurchaseOrderTS.updateVendor(po);
					kson.setSuccess();
					kson.setData("po", po_no);
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "add_to_po")) {
					PurchaseRequestBean pr = new PurchaseRequestBean();
					WebUtils.bindReqToEntity(pr, rr.req);
					pr.setStatus(PurchaseStatus.STATUS_PO_OPEN);
					PurchaseRequestTS.UpdateStatusAddPR(pr, new String[]{"po","add_pr_date","status","update_by","update_date"});
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "save_po")) {
					PurchaseOrderBean po = new PurchaseOrderBean();
					WebUtils.bindReqToEntity(po, rr.req);
					PurchaseOrderTS.update(po);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "remove_from_po")) {
					PurchaseRequestBean pr = new PurchaseRequestBean();
					WebUtils.bindReqToEntity(pr, rr.req);
					pr.setStatus(PurchaseStatus.STATUS_ORDER);
					pr.setPo("");
					PurchaseRequestTS.updateStatus(pr, new String[]{"po","status","update_by","update_date"});
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "approve_po")) {
					PurchaseOrderBean po = new PurchaseOrderBean();
					WebUtils.bindReqToEntity(po, rr.req);
					PurchaseOrderTS.approvedPo(po);  
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "reject_po")) {
					PurchaseOrderBean po = new PurchaseOrderBean();
					WebUtils.bindReqToEntity(po, rr.req);
					PurchaseOrderTS.rejectPo(po);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
		
	}

	

}
