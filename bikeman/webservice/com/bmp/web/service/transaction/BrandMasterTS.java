package com.bmp.web.service.transaction;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bmp.web.service.bean.setBrandMasterBean;
import com.bmp.web.service.client.bean.getBrandMasterBean;
import com.mysql.jdbc.Statement;

public class BrandMasterTS {
	
	public static String tableName = "mk_brands";
	public static String[] keys = {"order_by_id"};//primary keys 
	public static String[] fieldNames = {"order_by_id", "brand_id", "brand_name", "create_by", "create_date", "update_by", "update_date"};
	
	
	public static void main(String arg) throws Exception{
		BrandMasterTS.getBrandUpdate(new Date());
	}
	public static List<getBrandMasterBean> getBrandUpdate(Date dd) throws Exception{
		
		List<getBrandMasterBean> list = new ArrayList<getBrandMasterBean>();
		
		Connection conn = null;
		
		try{
			
			String sql = "SELECT * FROM  "+tableName+"  WHERE update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd)+"'";
			
			conn = DBPool.getConnection();
			Statement st = (Statement) conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while(rs.next()){
				
				getBrandMasterBean entity = new getBrandMasterBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			rs.close();
			st.close();
			
			
		}catch (Exception e) {
			throw new Exception("BrandMasterTSException: " + e.getMessage());
		}finally{
			if (conn != null) {
				conn.close();
			}
		}
		
		return list;
		
	}
	
	public  static boolean check(String order_by_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		setBrandMasterBean entity = new setBrandMasterBean();
		entity.setOrder_by_id(order_by_id);
		return check(entity);
	}
	public  static boolean check(String brand_name ,String brand_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		setBrandMasterBean entity = new setBrandMasterBean();
		entity.setBrand_name(brand_name);
		entity.setBrand_id(brand_id);
		return checkIdName(entity);
	}
	public  static boolean check(setBrandMasterBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}
	public  static boolean checkIdName(setBrandMasterBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"brand_id","brand_name"});
		conn.close();
		return check;
	}

	
	
}
