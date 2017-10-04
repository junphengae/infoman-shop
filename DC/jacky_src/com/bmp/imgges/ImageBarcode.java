package com.bmp.imgges;

import com.bitmap.barcode.Barcode128;
import com.bitmap.utils.SNCUtils;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;


import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;


/**
 * Servlet implementation class ImageBarcode
 */
public class ImageBarcode extends ServletUtils {
	private static final long serialVersionUID = 1L;
	
    public ImageBarcode() {
        super();
    }

	@Override
	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (checkAction(rr, "printbarcode")) {
				String pn =  WebUtils.getReqString(rr.req, "pn");
				String update_by = WebUtils.getReqString(rr.req, "update_by");
				HttpSession session =  rr.req.getSession();
				String fileName=pn;
				//System.out.println(pn+"/"+WebUtils.getInitParameter(session,SNCUtils.IMG_PATH_BARCODE));				
				Barcode128.genBarcode(WebUtils.getInitParameter(session,SNCUtils.IMG_PATH_BARCODE),pn,fileName,4);

				String barcode = WebUtils.getInitParameter(session,SNCUtils.IMG_PATH_BARCODE)+"/"+fileName+".png";
				
				System.out.println("Barcode : "+barcode);
				PartMasterBean en = new PartMasterBean();
				en.setPn(pn);
				en.setSn_flag("0");	
				en.setUpdate_by(update_by);
				PartMasterBarcodeTS.UpDateBarCode(en,barcode);
				kson.setSuccess();				
				rr.outTH(kson.getJson());
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		
	}


}
