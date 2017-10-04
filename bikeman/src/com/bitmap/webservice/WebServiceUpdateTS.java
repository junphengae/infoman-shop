package com.bitmap.webservice;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Date;


import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;

public class WebServiceUpdateTS {
	
	public static String tableName = "web_service_update";
	private static String[] keys = {"table_name","sync_date"};
	private static String[] fieldNames = {"sync_date","table_name","status"};
	
	public static void main() throws Exception {
		
	WebServiceUpdateTS.getWebServiceUpdateUpdate(new Date());
	}

	private static void getWebServiceUpdateUpdate(Date date) {
	// TODO Auto-generated method stub
	
	}
	private static boolean check(WebServiceUpdateBean entity, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		return DBUtility.getEntityFromDB(conn, tableName, entity, keys);
	}
	
	public  static boolean check(WebServiceUpdateBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}
	
	public static boolean insert(WebServiceUpdateBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		boolean has = false;
		Connection conn = DBPool.getConnection();
		if (check(entity, conn)) {
			has = true;
		} else {
			entity.setSync_date(DBUtility.getDBCurrentDateTime());
			entity.setStatus("N");
			DBUtility.insertToDB(conn, tableName, entity);
		}
		conn.close();
		return has;
	}
	
	public static void update(WebServiceUpdateBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setSync_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public static WebServiceUpdateBean select(WebServiceUpdateBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static WebServiceUpdateBean selectdate(String table_name) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		String sql ="SELECT MAX(sync_date) AS sync_date FROM  web_service_update WHERE table_name = '"+ table_name +"'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		WebServiceUpdateBean entity = new WebServiceUpdateBean();
		if (rs.next()) {
			DBUtility.bindResultSet(entity, rs);
		}
		
		if (entity.getSync_date() == null) {
			entity.setSync_date(DBUtility.getDBCurrentDateTime());
		}
		
		rs.close();
		st.close();
		conn.close();
		return entity;
		
	} 
	public static void insertServiceUpdate(String table_name) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		
		WebServiceUpdateBean entity = new WebServiceUpdateBean();
		entity.setTable_name(table_name);
		entity.setSync_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus("N");
		
		DBUtility.insertToDB(conn, tableName, entity);
		
		conn.close();
	}
 

}
