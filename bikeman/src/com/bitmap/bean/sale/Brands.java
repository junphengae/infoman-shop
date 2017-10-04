package com.bitmap.bean.sale;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;

public class Brands {
	public static String tableName = "mk_brands";
	
	String brand_id;
	String brand_name;
	
	public static Brands select(String id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Brands entity = new Brands();
		entity.setBrand_id(id);
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"brand_id"});
		return entity;
	}
	
	public static List<String[]> ddl() throws SQLException{
		String sql = "SELECT * FROM " + tableName;
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<String[]> list = new ArrayList<String[]>();
		while (rs.next()) {
			list.add(new String[]{rs.getString("brand_id"),rs.getString("brand_name")});
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}

	public static String getUIName(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		return UIName(id);
	}
	public static String UIName(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Brands entity = new Brands();
		entity.setBrand_id(id);		
		if (!entity.getBrand_id().equalsIgnoreCase("")) {			
			Connection conn = DBPool.getConnection();
			DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"brand_id"});
			conn.close();
		}
		
		return entity.getBrand_name();
	}
	
	public static String getUIName(String id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Brands entity = new Brands();
		entity.setBrand_id(id);
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"brand_id"});
		return entity.getBrand_name();
	}
	
	public String getBrand_id() {
		return brand_id;
	}
	public void setBrand_id(String brand_id) {
		this.brand_id = brand_id;
	}
	public String getBrand_name() {
		return brand_name;
	}
	public void setBrand_name(String brand_name) {
		this.brand_name = brand_name;
	}
}
