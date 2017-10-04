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
import com.bmp.web.service.bean.setPartCategoriesBean;
import com.bmp.web.service.client.bean.getPartCategoriesBean;

public class PartCategoriesTS {
		
	public static String tableName = "pa_categories";
	public static String[] keys = {"cat_id"};
	public static String[] fieldNames = {"cat_id", "group_id", "cat_name_short", "cat_name_th", "create_by", "create_date"};

	public static void main(String[] arg) throws Exception{
		
		PartCategoriesTS.getPartCategoriesUpdate(new Date());
	}
	public static List<getPartCategoriesBean> getPartCategoriesUpdate(Date dd) throws Exception {
		
		List<getPartCategoriesBean> list = new ArrayList<getPartCategoriesBean>();
		
		Connection conn = null;
		
		try{
			
			String sql = "SELECT * FROM "+tableName+" WHERE update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			
			conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				getPartCategoriesBean entity = new getPartCategoriesBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			
			rs.close();
			st.close();
			
		}catch (Exception e) {
			throw new Exception("PartCategoriesTSException: " + e.getMessage());
		}finally {
			
			if (conn != null) {
				conn.close();
			}
		}
		
		return list;	
	}
	
	public  static boolean check(setPartCategoriesBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}
	public  static boolean check(String cat_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		setPartCategoriesBean entity = new setPartCategoriesBean();
		entity.setCat_id(cat_id);
		return check(entity);
	}

}
