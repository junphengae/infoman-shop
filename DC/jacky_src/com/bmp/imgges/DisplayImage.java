package com.bmp.imgges;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;

public class DisplayImage extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public DisplayImage() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn=null;
		try {
			conn = DBPool.getConnection();
			
			String pn = request.getParameter("pn");
			if (!pn.equalsIgnoreCase("")) {
				String sql ="SELECT barcode FROM pa_part_master WHERE pn='"+pn+"'";
				System.out.println("IMAGE : "+sql);
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery(sql);
				
				String imgLen="";
				if(rs.next()){
					imgLen = rs.getString(1);
					System.out.println(imgLen.length());
				}
				rs = st.executeQuery(sql);
				if(rs.next()){
					int len = imgLen.length();
					byte [] rb = new byte[len];
					InputStream readImg = rs.getBinaryStream(1);
					int index=readImg.read(rb,0, len);	
					System.out.println("index"+index);
					rs.close();
					response.reset();
					response.setContentType("image/png");
					response.getOutputStream().write(rb,0,len);
								
					}
					response.getOutputStream().flush();
					response.getOutputStream().close();
			}
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
	}

}
