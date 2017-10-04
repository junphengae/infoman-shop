package com.bitmap.servlet.branch;

import java.io.File;

import javax.servlet.ServletException;

import com.bitmap.utils.SNCUtils;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;
import com.bitmap.bean.branch.Branch;
import com.bmp.cs.promotion.PromationBean;
import com.bmp.cs.promotion.PromotionTS;
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
				if (checkAction(rr, "edit_promotion")) {
					PromationBean entity = new PromationBean();
					WebUtils.bindReqToEntity(entity, rr.getRequest());					
					PromotionTS.updatePromation(entity);
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				if (checkAction(rr, "delete_img")) {
					String id = rr.req.getParameter("id");					
					String Path = WebUtils.getInitParameter(rr.req.getSession(), SNCUtils.IMG_PATH_PROMOTION);
					String FullPath = Path+"/"+id+".jpg";
					System.out.println("ID DELETE :"+FullPath);
					if (!id.equalsIgnoreCase("")) {
						   new File(FullPath).delete();
				           new File(FullPath).delete();
					}
					
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}
}