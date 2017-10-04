package com.bitmap.servlet.parts;

import javax.servlet.ServletException;

import com.bitmap.bean.parts.PartBorrow;
import com.bitmap.bean.parts.PartSerial;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class BorrowPartManagement
 */
public class BorrowPartManagement extends ServletUtils {
	private static final long serialVersionUID = 1L;
    
    public BorrowPartManagement() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (isAction(rr)) {
				if (checkAction(rr, "borrow")) {
				
					String[] pn_sn = WebUtils.getReqString(rr.req, "pn").split("--");
					PartBorrow entity = new PartBorrow();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					
					
					if (pn_sn.length > 1) {
						entity.setPn(pn_sn[0]);
						entity.setSn(pn_sn[1]);
						entity.setQty("1");
						
						// check sn in stock
						PartSerial pSerial = new PartSerial();
						pSerial.setPn(entity.getPn());
						pSerial.setSn(entity.getSn());
						pSerial.setFlag("1");
						if(PartSerial.check(pSerial)){
							PartBorrow.borrow(entity);
							kson.setSuccess();
							rr.out(kson.getJson());
						} else {
							kson.setError("ไม่พบ Part Number และ Serial Number นี้ ในระบบ กรุณตรวจสอบ!");
							kson.setData("focus", "pn");
							rr.outTH(kson.getJson());
						}
					} else {
						PartBorrow.borrowNonSN(entity);
						kson.setSuccess();
						rr.out(kson.getJson());
					}
				}
				
				/*if (checkAction(rr, "check_withdraw")) {
					String id = WebUtils.getReqString(rr.req, "id");
					String status = RepairLaborTime.check(id);
					
					if (status.equalsIgnoreCase("true") || status.equalsIgnoreCase("finish")) {
						kson.setSuccess();
					} else if (status.equalsIgnoreCase("false")) {
						kson.setError("ไม่พบรหัสใบแจ้งซ่อม : " + id + " ในระบบ กรุณาตรวจสอบใหม่อีกครั้ง!");
					} else if (status.equalsIgnoreCase("pre_open")) {
						kson.setError("รหัสใบแจ้งซ่อม : " + id + " ยังไม่เปิดให้เบิกและคืนอะไหล่");
					}  else if (status.equalsIgnoreCase("close")) {
						kson.setError("รหัสใบแจ้งซ่อม : " + id + " จบการซ่อมแล้ว ไม่สามารถคืนได้");
					}
					
					rr.outTH(kson.getJson());
				}*/
				
				if (checkAction(rr, "return_part")) {
					String[] pn_sn = WebUtils.getReqString(rr.req, "pn").split("--");
					PartBorrow entity = new PartBorrow();
					WebUtils.bindReqToEntity(entity, rr.req);
				
					
					
					if (pn_sn.length > 1) {
						
						entity.setPn(pn_sn[0]);
						entity.setSn(pn_sn[1]);
						entity.setQty("1");
						// check sn in stock
						PartSerial pSerial = new PartSerial();
						pSerial.setPn(entity.getPn());
						pSerial.setSn(entity.getSn());
						pSerial.setFlag("2");
						if(PartSerial.check(pSerial)){
							PartBorrow.return_part(entity);
							kson.setSuccess();
							rr.out(kson.getJson());
						} else {
							kson.setError("ไม่พบ Part Number และ Serial Number นี้ ในระบบ กรุณตรวจสอบ!");
							kson.setData("focus", "pn");
							rr.outTH(kson.getJson());
						}
					} else {
						
						PartBorrow.return_partNonSN(entity);
						kson.setSuccess();
						rr.out(kson.getJson());
					}
				}
				
				if (checkAction(rr, "scrap_part")) {
					String[] pn_sn = WebUtils.getReqString(rr.req, "pn").split("--");
					PartBorrow entity = new PartBorrow();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					if (pn_sn.length > 1) {
						entity.setPn(pn_sn[0]);
						entity.setSn(pn_sn[1]);
						entity.setQty("1");
						
						// check sn in stock
						PartSerial pSerial = new PartSerial();
						pSerial.setPn(entity.getPn());
						pSerial.setSn(entity.getSn());
						pSerial.setFlag("2");
						if(PartSerial.check(pSerial)){
							PartBorrow.scrap_part(entity);
							kson.setSuccess();
							rr.out(kson.getJson());
						} else {
							kson.setError("ไม่พบ Part Number และ Serial Number นี้ ในระบบ กรุณตรวจสอบ!");
							kson.setData("focus", "pn");
							rr.outTH(kson.getJson());
						}
					} else {
						PartBorrow.scrap_partNonSN(entity);
						kson.setSuccess();
						rr.out(kson.getJson());
					}
				}
			} else {

			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}
}