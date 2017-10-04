/**
 * 
 */
package com.bmp.cs.promotion;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

import org.apache.commons.io.FileUtils;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.SNCUtils;
import com.bitmap.webutils.WebUtils;
import com.bmp.customer.service.bean.ServicePartDetailBean;
import com.bmp.parts.master.bean.PartGroupsBean;

/**
 * @author JACK
 *
 */
public class PromotionTS {

	public static String tableName = "system_info";
	private static String[] keys = {"id"};
	
	public static PromationBean select() throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = null;
		
			conn = DBPool.getConnection();			
			PromationBean entity = new PromationBean();
			entity.setId("1");
			DBUtility.getEntityFromDB(conn, tableName, entity, keys);
					
		return entity;
	}

	public static PromationBean select(PromationBean en) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = null;
		
			conn = DBPool.getConnection();			
			PromationBean entity = new PromationBean();
			entity.setId(en.getId());
			DBUtility.getEntityFromDB(conn, tableName, entity, keys);
					
		return entity;
	}

	
	public static void updatePromation(PromationBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"remake","promotion1","promotion2","promotion3","promotion4","promotion5","update_by","update_date"}, keys);
			
			conn.commit();
			conn.close();
			
		} catch (Exception e) {
			if (conn != null) {
				conn.rollback();
				conn.close();
			}
			System.out.println(e.getMessage());
		}
	}
	
	public static String getImg(String branch_code){
			String Path = "/var/www/vhosts/infoman.asia/home/test/promation";
			String img ="";
			try {
				File folder = new File(Path);
				File[] listOfFiles = folder.listFiles();

			    for (int i = 0; i < listOfFiles.length; i++) {
			      if (listOfFiles[i].isFile()) {
			    	 
			    	 if(listOfFiles[i].getName().substring(0, 5).equalsIgnoreCase(branch_code)){
			    		 img += listOfFiles[i].getName()+",";
			    	 }
			    	 
			      } 
			    }
			} catch (Exception e) {
				e.getStackTrace();
			}
			
		   return  img;
	}
	


}
