package com.bitmap.servlet.branch;

import com.bitmap.utils.ImageUtils;
import com.bitmap.utils.SNCUtils;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

import java.io.IOException;
import java.util.Hashtable;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javazoom.upload.UploadBean;
import javazoom.upload.UploadFile;

/**
 * Servlet implementation class PromotionImg
 */
public class PromotionImg extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see ServletUtils#ServletUtils()
     */
    public PromotionImg() {
        super();
    }


	@Override
	public void doPost(ReqRes rr) throws ServletException {
		// TODO PromotionImg 
		try {
			if(rr.isMultipart){
				
				String realPath = rr.ses.getServletContext().getInitParameter(SNCUtils.IMG_PATH_PROMOTION);
				String id = rr.mReq.getParameter("id");
				
				UploadBean upBean = new UploadBean();
				upBean.setOverwrite(true);
				upBean.setFolderstore(realPath);
				
				@SuppressWarnings("rawtypes")
				Hashtable files = rr.mReq.getFiles();
				UploadFile file = (UploadFile) files.get("fileToUpload");
				String fileName = WebUtils.encode(file.getFileName());
				String newName = id + ".jpg";
				
				if (fileName != null) {
					if (file.getFileSize() > 0) {
						file.setFileName(newName);
						upBean.store(rr.mReq, "fileToUpload");
						
						ImageUtils.resize(realPath + "/", newName);
						rr.out(id);
					}
				}
				
			}
			
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
		
	}

}
