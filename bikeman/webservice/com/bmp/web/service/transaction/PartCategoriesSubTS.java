package com.bmp.web.service.transaction;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bmp.web.service.bean.setPartCategoriesSubBean;
import com.bmp.web.service.client.bean.getPartCategoriesSubBean;

public class PartCategoriesSubTS {
	
	public static String tableName = "pa_categories_sub";
	public static String[] keys = {"sub_cat_id"};
	public static String[] fieldNames = { "sub_cat_id","cat_id", "group_id", "sub_cat_name_short", "sub_cat_name_th", "create_by", "create_date"};
		

	public static void main(String[] arg) throws Exception{
		
		PartCategoriesSubTS.getPartCategoriesSubUpdate(new Date());
	}
	public static List<getPartCategoriesSubBean> getPartCategoriesSubUpdate(Date dd) throws Exception {
	
		List<getPartCategoriesSubBean> list = new ArrayList<getPartCategoriesSubBean>();
		Connection conn = null;
		try{
			
			String sql = "SELECT * FROM "+tableName+" WHERE update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			
			conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				getPartCategoriesSubBean entity = new getPartCategoriesSubBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			
			rs.close();
			st.close();
			
		}catch (Exception e) {
			throw new Exception("PartCategoriesSubTSException: " + e.getMessage());
		}finally {
			
			if (conn != null) {
				conn.close();
			}
		}
		return list;
	}
	
	public  static boolean check(String sub_cat_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		setPartCategoriesSubBean entity = new setPartCategoriesSubBean();
		entity.setSub_cat_id(sub_cat_id);
		return check(entity);
	}
	public  static boolean check(setPartCategoriesSubBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}			

}
