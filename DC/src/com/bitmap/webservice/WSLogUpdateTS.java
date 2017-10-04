package com.bitmap.webservice;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Kson;

public class WSLogUpdateTS {
	
	public static String tableName = "ws_log_update";
	private static String[] keys = {"id"};
	private static String[] fieldNames = {"id","table_name","update_date","status", "note"};
    
	
	public static void insertWSLogUpdate(Connection conn,String table_name ,String status) throws Exception{
		
		try {
				WSLogUpdateBean entity = new WSLogUpdateBean();
				entity.setId(DBUtility.genNumber(conn, tableName, "id"));
				entity.setTable_name(table_name);
				entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
				if(status.equalsIgnoreCase("success")){ 
					entity.setStatus(status);
					
				}else{
					entity.setStatus("error");
					
				}
				
				DBUtility.insertToDB(conn, tableName, entity);
				
		} catch (Exception e) {
			conn.rollback();
			conn.close();
			throw new Exception(e.getMessage());
		}

	}
}
