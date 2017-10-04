package com.bmp.web.service.transaction;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bmp.web.service.bean.setSystemInfoBean;

public class SystemInfoTS {
	public static String tableName = "system_info";
	public static String[] keys = {"id"};
	public static String[] fieldNames = {"id","branch_code", "branch_name_en", "branch_order", "name" , "addressnumber" ,"villege" ,"moo" ,"soi" ,"road","district","prefecture"
								,"province","postalcode","phonenumber","create_by","update_by","create_date","update_date","keyin_code","fax"};
	
	
	public void load(setSystemInfoBean entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public void select(Connection conn,setSystemInfoBean entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		
		try {
			
			DBUtility.getEntityFromDB(conn, tableName, entity, keys);
			
		} catch (Exception e) {
			conn.close();
		}
		
		
	}
	
	public static setSystemInfoBean select(String id) throws IllegalArgumentException, IllegalAccessException, InvocationTargetException, SQLException{
		
		setSystemInfoBean entity = new setSystemInfoBean();
		entity.setId(id);
		return select1(entity);
		
	}
	
	public static setSystemInfoBean select1(setSystemInfoBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	
	public static setSystemInfoBean selectbranch_code(String branch_code) throws IllegalArgumentException, IllegalAccessException, InvocationTargetException, SQLException{
		
		setSystemInfoBean entity = new setSystemInfoBean();
		entity.setBranch_code(branch_code);
		return selectbranch_code(entity);		
	}
	
	public static setSystemInfoBean selectbranch_code(setSystemInfoBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity,new String[]{"branch_code"});
		conn.close();
		return entity;
	}
	
	public static void select(setSystemInfoBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		
		conn.close();
	}
	public static setSystemInfoBean select()throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		setSystemInfoBean entity = new setSystemInfoBean();
		entity.setId("1");
		select(entity);
		return entity;
	}
	public static void insert(setSystemInfoBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		entity.setId("1");
		DBUtility.insertToDB(conn, tableName, entity);
		
		conn.close();
	}
	
	public static void update(setSystemInfoBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setKeyin_code(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"branch_code","keyin_code"}, keys);
		conn.close();
	}
	
	public  static boolean check(String branch_code) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		setSystemInfoBean entity = new setSystemInfoBean();
		entity.setBranch_code(branch_code);
		return check(entity);
	}
	public  static boolean check(setSystemInfoBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity,new  String[]{"branch_code"});
		conn.close();
		return check;
	}

}
