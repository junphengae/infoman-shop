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
import com.bitmap.utils.Kson;

public class WSLogUpdateTS {
	
	public static String tableName = "ws_log_update";
	private static String[] keys = {"id"};
	private static String[] keyfield = {"table_name","update_date"};
	private static String[] fieldNames = {"id","table_name","update_date","status", "note"};
    
	
	public static void insertWSLogUpdate(String table_name ,String status) throws IllegalAccessException, InvocationTargetException, SQLException{
		
		Connection conn = DBPool.getConnection();
		WSLogUpdateBean entity = new WSLogUpdateBean();
		entity.setId(DBUtility.genNumber(conn, tableName, "id"));
		entity.setTable_name(table_name);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		
		if(status.equalsIgnoreCase("success")){ 
			entity.setStatus(status);
			
		}else if(status.equalsIgnoreCase("login")){
			entity.setStatus("login");
		}
		else{
			entity.setStatus("error");
			
		}
		
		DBUtility.insertToDB(conn, tableName, entity);
		
		
		conn.close();
	}
	public static WSLogUpdateBean selectSession(String table_name) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		
		String sql ="SELECT MAX(update_date) AS update_date FROM " + tableName + " WHERE table_name = '"+ table_name +"'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		WSLogUpdateBean entity = new WSLogUpdateBean();
		if (rs.next()) {
			DBUtility.bindResultSet(entity, rs);
		}
		/*if (entity.getSync_date() == null) {
			entity.setSync_date(DBUtility.getDBCurrentDateTime());
		}*/
		rs.close();
		st.close();
		conn.close();
		return entity;

		
	}
	
}
