package com.bitmap.servlet.purchase;

import java.sql.Connection;

import javax.servlet.ServletException;

import Component.Accounting.Money.MoneyAccounting;

import com.bitmap.bean.purchase.PurchaseOrder;
import com.bitmap.bean.purchase.PurchaseRequest;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class PurchaseManage
 */
public class PurchaseManage extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public PurchaseManage() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (isAction(rr)) {
				if (checkAction(rr, "restatus_po")) {
					Connection conn = DBPool.getConnection();
					conn.setAutoCommit(false);
					
					PurchaseOrder po = new PurchaseOrder();
					WebUtils.bindReqToEntity(po, rr.req);
					System.out.println("PO :"+po.getPo());
					System.out.println("Status :"+po.getStatus());
					System.out.println("By :"+po.getUpdate_by());
					
					PurchaseOrder.update_statusPO(po,conn);
					
					PurchaseRequest pr = new PurchaseRequest();
					pr.setPo(po.getPo());
					pr.setStatus(po.getStatus());
					pr.setUpdate_by(po.getUpdate_by());
					
					PurchaseRequest.update_statusPO(pr,conn);
					
					conn.commit();
					conn.close();
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				//Bank 
				if (checkAction(rr, "issue_po")) {
					PurchaseOrder po = new PurchaseOrder();
					WebUtils.bindReqToEntity(po, rr.req);
				
					String po_no = PurchaseOrder.createPO(po);
					
					kson.setSuccess();
					kson.setData("po", po_no);
					rr.out(kson.getJson());
				}

				if (checkAction(rr, "add_to_po")) {
					PurchaseRequest pr = new PurchaseRequest();
					WebUtils.bindReqToEntity(pr, rr.req);
					pr.setStatus(PurchaseRequest.STATUS_PO_OPEN);
					PurchaseRequest.updateStatusAddPR(pr,new String[]{"po","status","add_pr_date","update_by","update_date"});
					kson.setSuccess();
					rr.out(kson.getJson());
				}

				if (checkAction(rr, "remove_from_po")) {
					PurchaseRequest pr = new PurchaseRequest();
					WebUtils.bindReqToEntity(pr, rr.req);
					pr.setStatus(PurchaseRequest.STATUS_ORDER);
					pr.setPo("");			
					PurchaseRequest.updateStatusRemove(pr, new String[]{"po","status","add_pr_date","update_by","update_date"});
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "save_po")) {
					PurchaseOrder po = new PurchaseOrder();
					WebUtils.bindReqToEntity(po, rr.req);					
					PurchaseOrder.update(po);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "restatusPO")) {
					PurchaseOrder po = new PurchaseOrder();
					WebUtils.bindReqToEntity(po, rr.req);
					
					PurchaseOrder.update_datePO(po);
					
					PurchaseRequest pr = new PurchaseRequest();
					pr.setPo(po.getPo());
					pr.setUpdate_by(po.getUpdate_by());
					PurchaseRequest.update_datePR(pr);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
								
				if (checkAction(rr, "confirm_po")) {
					PurchaseOrder po = new PurchaseOrder();
					
					WebUtils.bindReqToEntity(po, rr.req);
					PurchaseOrder.updateAPPROVED(po);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "MoneyAccounting")) {
					PurchaseOrder po = new PurchaseOrder();
					WebUtils.bindReqToEntity(po, rr.req);
					String discount_pc	= MoneyAccounting.MoneyCeilSatang(po.getDiscount_pc());
					String gross_amount = MoneyAccounting.MoneyCeilSatang(po.getGross_amount());
					String discount = MoneyAccounting.MoneyCeilSatang(po.getDiscount());
					
					
					kson.setData("discount_pc", discount_pc);
					kson.setData("gross_amount", discount_pc);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				
				if (checkAction(rr, "cancel_po")) {
					PurchaseOrder po = new PurchaseOrder();
					WebUtils.bindReqToEntity(po, rr.req);
					
					PurchaseOrder.cancelPO(po);
					PurchaseRequest.status_po_terminate(po);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				//////////////
				
				if (checkAction(rr, "create_pr")) {
					PurchaseRequest entity = new PurchaseRequest();
					WebUtils.bindReqToEntity(entity, rr.getRequest());
					
								
					PurchaseRequest.insert(entity);
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "update_pr")) {
					PurchaseRequest entity = new PurchaseRequest();
					WebUtils.bindReqToEntity(entity, rr.getRequest());
					
					PurchaseRequest.update(entity);
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "cancel_pr")) {
					PurchaseRequest entity = new PurchaseRequest();
					WebUtils.bindReqToEntity(entity, rr.getRequest());
					
					PurchaseRequest.status_cancel(entity);
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				

				if (checkAction(rr, "cancel_po_4_new")) {
					PurchaseOrder po = new PurchaseOrder();
					WebUtils.bindReqToEntity(po, rr.req);
					PurchaseOrder.select(po);
					PurchaseOrder poNew = PurchaseOrder.select(po.getPo());
					
					poNew.setReference_po(po.getPo());
					poNew.setApprove_by(po.getUpdate_by());
					String po_no = PurchaseOrder.createPO4cancelPO(poNew);
					
					po.setNote(po.getNote() + "\n** ยกเลิกเพื่อออกใบใหม่ ใบสั่งซื้อที่ออกใหม่เลขที่ : [" + po_no + "]");
					
				//	//System.out.println("PO : "+po.getPo());
					
					PurchaseOrder.cancelPO(po);
					
					kson.setSuccess();
					kson.setData("po", po_no);
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "checkPO")) {
					PurchaseOrder po = new PurchaseOrder();

					WebUtils.bindReqToEntity(po, rr.req);
					boolean has = PurchaseOrder.check(po);
					
					if (has) {
						kson.setSuccess();
					} else {
						kson.setError("!! ไม่พบใบสั่งซื้อตามที่ระบุ  กรุณาตรวจสอบ !!");
					}
					rr.outTH(kson.getJson());
				}
				

				if (checkAction(rr, "approve_po")) {
					PurchaseOrder po = new PurchaseOrder();
					WebUtils.bindReqToEntity(po, rr.req);
					String po_key = po.getPo();
					po.setPo(po_key);
					po.setApprove_by(po.getUpdate_by());
					PurchaseOrder.approvedPo(po);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "reject_po")) {
					PurchaseOrder po = new PurchaseOrder();
					WebUtils.bindReqToEntity(po, rr.req);										
					PurchaseOrder.rejectPo(po);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "close_po")) {
					
					PurchaseOrder entityPO = new PurchaseOrder();
					WebUtils.bindReqToEntity(entityPO, rr.req);
					PurchaseOrder.ClosePOAddStock(entityPO);
					
					PurchaseRequest entityPR = new PurchaseRequest();
					entityPR.setPo(entityPO.getPo());
					entityPR.setUpdate_by(entityPO.getUpdate_by());
					PurchaseRequest.ClosePRAddStock(entityPR);
					
					
					
					
					/*PurchaseOrder entityPO = new PurchaseOrder();
					WebUtils.bindReqToEntity(entityPO, rr.req);
					PurchaseOrder.closePO(entityPO);
					
					PurchaseRequest entityPR = new PurchaseRequest();
					entityPR.setPo(entityPO.getPo());
					PurchaseRequest.status_po_close(entityPR);*/

					 //PurchaseRequest.status_po_close()
					/*PurchaseRequest entityPR = new PurchaseRequest();
					PurchaseRequest.status_po_open(entityPR);
					
					ต้อง close pr ด้วย เดี่ยวกัลบมาทำนะ
					*/
					/*PurchaseOrder po = new PurchaseOrder();
					WebUtils.bindReqToEntity(po, rr.req);;*/
				
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