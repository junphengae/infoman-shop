package com.bitmap.bean.hr;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;

public class LeaveType {
	public static String tableName = "per_leave_type";
	public static String[] keys = {"leave_type"};
	public static String[] fieldName = {"leave_detail"};
	
	String leave_type = "";
	String leave_detail = "";
	
	public static List<String[]> dropdownLeaveType() throws SQLException {
		Connection conn = DBPool.getConnection();
		List<String[]> list = DBUtility.getDropDownList(conn, tableName, "leave_type", "leave_detail", "leave_detail");
		conn.close();
		return list;
	}
	
	public static LeaveType select(String leave_type, Connection conn) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException {
		
		LeaveType entity = new LeaveType();
		entity.setLeave_type(leave_type); 
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);	
		return entity;
	}

	public String getLeave_type() {
		return leave_type;
	}

	public void setLeave_type(String leave_type) {
		this.leave_type = leave_type;
	}

	public String getLeave_detail() {
		return leave_detail;
	}

	public void setLeave_detail(String leave_detail) {
		this.leave_detail = leave_detail;
	}

	

}
