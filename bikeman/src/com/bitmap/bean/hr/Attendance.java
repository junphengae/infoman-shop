package com.bitmap.bean.hr;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;

public class Attendance {
	public static String tableName = "per_attendance";
	public static String[] keys = {"attn_date", "per_id"};
	public static String[] fieldName = {"time1","time2","time3","time4","time5","time6","time7","time8"};
	
	Date attn_date = null;
	String per_id = "";
	String flag_day = "";
	String time1 = "";
	String time2 = "";
	String time3 = "";
	String time4 = "";
	String time5 = "";
	String time6 = "";
	String time7 = "";
	String time8 = "";
	String update_by = "";
	String update_date = null;
	
	public static Attendance select(Date attn_date, String per_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, ParseException {
		Attendance attend = new Attendance();
		attend.setPer_id(per_id);
		//attend.setAttn_date(DBUtility.getDate(attn_date));
		attend.setAttn_date(attn_date);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, attend, keys);
		conn.close();
		return attend;	
	}
	
		
	public Date getAttn_date() {
		return attn_date;
	}
	public void setAttn_date(Date attn_date) {
		this.attn_date = attn_date;
	}

	public String getPer_id() {
		return per_id;
	}
	public void setPer_id(String per_id) {
		this.per_id = per_id;
	}
	public String getFlag_day() {
		return flag_day;
	}
	public void setFlag_day(String flag_day) {
		this.flag_day = flag_day;
	}
	public String getTime1() {
		return time1;
	}
	public void setTime1(String time1) {
		this.time1 = time1;
	}
	public String getTime2() {
		return time2;
	}
	public void setTime2(String time2) {
		this.time2 = time2;
	}
	public String getTime3() {
		return time3;
	}
	public void setTime3(String time3) {
		this.time3 = time3;
	}
	public String getTime4() {
		return time4;
	}
	public void setTime4(String time4) {
		this.time4 = time4;
	}
	public String getTime5() {
		return time5;
	}
	public void setTime5(String time5) {
		this.time5 = time5;
	}
	public String getTime6() {
		return time6;
	}
	public void setTime6(String time6) {
		this.time6 = time6;
	}
	public String getTime7() {
		return time7;
	}
	public void setTime7(String time7) {
		this.time7 = time7;
	}
	public String getTime8() {
		return time8;
	}
	public void setTime8(String time8) {
		this.time8 = time8;
	}
	public String getUpdate_by() {
		return update_by;
	}
	public void setUpdate_by(String update_by) {
		this.update_by = update_by;
	}
	public String getUpdate_date() {
		return update_date;
	}
	public void setUpdate_date(String update_date) {
		this.update_date = update_date;
	}
	
	
}


