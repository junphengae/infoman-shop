package com.bitmap.ajax;

import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Hashtable;

import javax.servlet.ServletException;

import javazoom.upload.UploadBean;
import javazoom.upload.UploadFile;

import com.bitmap.utils.ImageUtils;
import com.bitmap.utils.SNCUtils;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

public class PhotoBrands extends ServletUtils{
	

	private static final long serialVersionUID = 1L;
       
   
    public PhotoBrands() {
        super();
        
    }
    public void doPost(ReqRes rr) throws ServletException {

		try {
			if (isAction(rr)) {
				String name = getParam(rr, "name");
				String realPath = "";
				
				if (checkAction(rr, "webcam_part")) {
					realPath = rr.ses.getServletContext().getInitParameter(SNCUtils.IMG_PATH_LOGO);
				}
			
				InputStream inputStream = rr.req.getInputStream();
				OutputStream out = new FileOutputStream(realPath + "/" + name + ".jpg");
				byte[] buf = new byte [1024] ;
				int len;
				while((len=inputStream.read(buf))>0) {
					out.write(buf,0,len);
			
				}
				out.close();
				inputStream.close();
				
				
			} 
			
			
			else {
				
				if (rr.isMultipart) {
					String realPath = rr.ses.getServletContext().getInitParameter(SNCUtils.IMG_PATH_LOGO);
					String order_by_id = rr.mReq.getParameter("order_by_id");
					
					UploadBean upBean = new UploadBean();
					upBean.setOverwrite(true);
					upBean.setFolderstore(realPath);
					
					@SuppressWarnings("rawtypes")
					Hashtable files = rr.mReq.getFiles();
					UploadFile file = (UploadFile) files.get("fileToUpload");
					String fileName = WebUtils.encode(file.getFileName());
					String newName = order_by_id + ".jpg";					
					
					if (fileName != null) {
						if (file.getFileSize() > 0) {
							file.setFileName(newName);
							upBean.store(rr.mReq, "fileToUpload");
							
							ImageUtils.resize(realPath + "/", newName);
							rr.out(order_by_id);
							
						}
					}
				}
				
				
			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	
    }
	

	
}
