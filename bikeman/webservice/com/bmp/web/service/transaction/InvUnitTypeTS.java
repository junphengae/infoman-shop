package com.bmp.web.service.transaction;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bmp.web.service.bean.setInvUnitTypeBean;

public class InvUnitTypeTS {
	public static String tableName = "inv_unit_type";
	public static String[] keys = {"id"};
	public static String[] fieldName = {"type_name","update_by","update_date"};
	public static String[] fieldNameWS = {"id","type_name","create_by","create_date","update_by","update_date"};
	
	public  static boolean check(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		setInvUnitTypeBean entity = new setInvUnitTypeBean();
		entity.setId(id);
		return check(entity);
	}
	
	public  static boolean check(setInvUnitTypeBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}
	
}
