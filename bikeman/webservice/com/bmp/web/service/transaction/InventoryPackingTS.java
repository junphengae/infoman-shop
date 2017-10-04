package com.bmp.web.service.transaction;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bmp.web.service.bean.setInventoryPackingBean;

public class InventoryPackingTS {
	
	public static String tableName = "inv_packing";
	public static String[] keys = {"mat_code","run_id"};
	public static String[] fieldName = {"description","unit","update_by","update_date"};
	public static String[] fieldNameWS = {"run_id","mat_code","description","unit","create_by","create_date","update_by","update_date"};
	
	
	public  static boolean check(String run_id ,String mat_code) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		setInventoryPackingBean entity = new setInventoryPackingBean();
		entity.setRun_id(run_id);
		entity.setMat_code(mat_code);
		return check(entity);
	}
	public  static boolean check(setInventoryPackingBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}
}
