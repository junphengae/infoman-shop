package com.bitmap.bean.hr;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;

public class AttendanceTime {
	public static String tableName = "per_attendance_time";
	public static String[] keys= {"id"};
	public static String[] fieldName = {"time_in","time_out","time_late","sun_flag","sat_flag","update_by","update_date"};
	
	String id = "";
	String time_in = "";
	String time_out = "";
	String time_late = "";
	String sun_flag = "";
	String sat_flag = "";
	String update_by = "";
	Timestamp update_date = null;
	
	
	public static AttendanceTime select(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		AttendanceTime time = new AttendanceTime();
		time.setId(id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, time, keys);
		conn.close();
		return time;
	}
	
	public static void update(AttendanceTime entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldName, keys);
		conn.close();
	}
	
	public static void select(AttendanceTime entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, ParseException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getTime_in() {
		return time_in;
	}
	public void setTime_in(String time_in) {
		this.time_in = time_in;
	}
	public String getTime_out() {
		return time_out;
	}
	public void setTime_out(String time_out) {
		this.time_out = time_out;
	}
	public String getTime_late() {
		return time_late;
	}
	public void setTime_late(String time_late) {
		this.time_late = time_late;
	}
	public String getUpdate_by() {
		return update_by;
	}
	public void setUpdate_by(String update_by) {
		this.update_by = update_by;
	}
	public Timestamp getUpdate_date() {
		return update_date;
	}
	public void setUpdate_date(Timestamp update_date) {
		this.update_date = update_date;
	}

	public String getSun_flag() {
		return sun_flag;
	}

	public void setSun_flag(String sun_flag) {
		this.sun_flag = sun_flag;
	}

	public String getSat_flag() {
		return sat_flag;
	}

	public void setSat_flag(String sat_flag) {
		this.sat_flag = sat_flag;
	} 
	
	

}
