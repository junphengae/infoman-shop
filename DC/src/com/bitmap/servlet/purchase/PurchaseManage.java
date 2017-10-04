package com.bitmap.servlet.purchase;

import javax.servlet.ServletException;

import com.bitmap.bean.dc.SaleOrderService;
import com.bitmap.bean.dc.SaleServicePartDetail;
import com.bitmap.bean.inventory.InventoryMasterVendor;
import com.bitmap.bean.parts.PartMaster;
import com.bitmap.bean.purchase.PurchaseOrder;
import com.bitmap.bean.purchase.PurchaseRequest;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;
import com.bmp.purchase.transaction.PurchaseOrderTS;

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
				
				//Bank 
				if (checkAction(rr, "issue_po")) {
					PurchaseOrder po = new PurchaseOrder();
					WebUtils.bindReqToEntity(po, rr.req);
				
					String po_no = PurchaseOrder.createPO(po);
					kson.setSuccess();
					kson.setData("po", po_no);
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "issue_po_edit")) {
					PurchaseOrder po = new PurchaseOrder();
					WebUtils.bindReqToEntity(po, rr.req);
				
					String po_no = PurchaseOrder.updateVendor(po);
					kson.setSuccess();
					kson.setData("po", po_no);
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "selectCheck")) {
					PartMaster entity = new PartMaster();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					if (InventoryMasterVendor.check(entity.getPn())) {
						
						String pn = entity.getPn();
						kson.setSuccess();
						kson.setData("po", "error");
						rr.out(kson.getJson());
						
					}else {
						String pn = entity.getPn();
						kson.setSuccess();
						kson.setData("po", pn);
						rr.out(kson.getJson());
					}
					
					
				}
				if (checkAction(rr, "add_to_po")) {
					PurchaseRequest pr = new PurchaseRequest();
					WebUtils.bindReqToEntity(pr, rr.req);
					pr.setStatus(PurchaseRequest.STATUS_PO_OPEN);
					PurchaseRequest.updateStatus(pr, new String[]{"po","status","update_by","update_date"});
					kson.setSuccess();
					rr.out(kson.getJson());
				}

				if (checkAction(rr, "remove_from_po")) {
					PurchaseRequest pr = new PurchaseRequest();
					WebUtils.bindReqToEntity(pr, rr.req);
					pr.setStatus(PurchaseRequest.STATUS_ORDER);
					pr.setPo("");
					PurchaseRequest.updateStatus(pr, new String[]{"po","status","update_by","update_date"});
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

				
				if (checkAction(rr, "confirm_po")) {
					PurchaseOrder po = new PurchaseOrder();
					
					WebUtils.bindReqToEntity(po, rr.req);
					PurchaseOrder.updateAPPROVED(po);
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
					int oderQTY = Integer.parseInt(entity.getOrder_qty());
					
					InventoryMasterVendor imv = InventoryMasterVendor.select(entity.getMat_code(), entity.getVendor_id());
					int mop = Integer.parseInt(imv.getVendor_moq());
					
					if(oderQTY >= mop){
						
						PurchaseRequest.insert(entity);
						kson.setSuccess();
						rr.outTH(kson.getJson());
						
					}else{
						kson.setSuccess();
						kson.setData("moq", mop);
						rr.outTH(kson.getJson());
					}
					
					
				}
				
				if (checkAction(rr, "update_pr")) {
					
					PurchaseRequest entity = new PurchaseRequest();
					WebUtils.bindReqToEntity(entity, rr.getRequest());
					int oderQTY = Integer.parseInt(entity.getOrder_qty());
					
					InventoryMasterVendor imv = InventoryMasterVendor.select(entity.getMat_code(), entity.getVendor_id());
					int mop = Integer.parseInt(imv.getVendor_moq());
					
					if(oderQTY >= mop){
						
						PurchaseRequest.update(entity);
						kson.setSuccess();
						rr.outTH(kson.getJson());
						
					}else{
						kson.setSuccess();
						kson.setData("moq",mop);
						rr.outTH(kson.getJson());
					}
					
				}
				
				if (checkAction(rr, "cancel_pr")) {
					
					PurchaseRequest entity = new PurchaseRequest();
					WebUtils.bindReqToEntity(entity, rr.getRequest());
					
					////System.out.println("pn:"+ entity.getMat_code());
					////System.out.println("order_qty::"+ entity.getOrder_qty());
					
					PurchaseRequest.status_cancel(entity);
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				

				if (checkAction(rr, "cancel_po_4_new")) {
					PurchaseOrder po = new PurchaseOrder();
					WebUtils.bindReqToEntity(po, rr.req);
					
					PurchaseOrder poNew = new PurchaseOrder();
					poNew.setReference_po(po.getPo());
					poNew.setVendor_id(po.getVendor_id());
					poNew.setApprove_by(po.getUpdate_by());
					
					String po_no = PurchaseOrder.createPO4cancelPO(poNew);
					
					po.setNote(po.getNote() + "\n** ยกเลิกเพื่อออกใบใหม่ ใบสั่งซื้อที่ออกใหม่เลขที่ : [" + po_no + "]");
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
					PurchaseOrder.closePO(entityPO);
					
					PurchaseRequest entityPR = new PurchaseRequest();
					   entityPR.setPo(entityPO.getPo());
		
					 PurchaseRequest.status_po_close(entityPR);
		
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "close_po_sale")) {
					SaleServicePartDetail entity = new SaleServicePartDetail();
					WebUtils.bindReqToEntity(entity, rr.req);
					SaleServicePartDetail.closeJob(entity);
					//System.out.println("number"+entity.getNumber());
					SaleOrderService entitySo = new SaleOrderService();
					entitySo.setId(entity.getNumber());
			  
					SaleOrderService.closeJob(entitySo);
			  
				
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