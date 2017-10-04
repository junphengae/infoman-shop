package com.bmp.imgges;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileInputStream;
import java.io.IOException;


import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.bitmap.utils.SNCUtils;
import com.bitmap.webutils.WebUtils;

public class DisplayImagePn extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public DisplayImagePn() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		try {
			
			
			String pn = request.getParameter("pn");
			if (!pn.equalsIgnoreCase("")) {
						
				String Path = WebUtils.getInitParameter(request.getSession(), SNCUtils.IMG_PATH_PART);
				String FullPath = Path+"/"+pn+".jpg";
								
				response.setContentType("image/jpeg");
				ServletOutputStream out;
				out = response.getOutputStream();
				FileInputStream fin = new FileInputStream(FullPath);
				
				BufferedInputStream bin = new BufferedInputStream(fin);
				BufferedOutputStream bout = new BufferedOutputStream(out);
				int ch =0; ;
				while((ch=bin.read())!=-1)
				{
				bout.write(ch);
				}
				
				bin.close();
				fin.close();
				bout.close();
				out.close();
				
			}
				
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
	}

	}

