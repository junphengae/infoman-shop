package com.bitmap.bean.hr;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.WebUtils;

public class Late {
	public static String tableName = "per_late";
	public static String[] keys = {"per_id","late_date"};
	public static String[] fieldNames = {"late_status","late_remark","update_by","update_date"};
	public static String[] fieldUpdate = {"late_remark","update_by","update_date"};
	
	String per_id = "";
	Date late_date = null;
	String late_status = "";
	String late_remark = "";
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	
	/**
	 * Used emp_summary.jsp
	 * <br>
	 * ใช้คำนวณจำนวนวันที่มาสายในแต่ละเดือน
	 * @param per_id
	 * @param late_date
	 * @return
	 * @throws SQLException
	 */
	public static String count_late_month(String per_id,Date late_date) throws SQLException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT count(late_date) as cnt FROM " + tableName + " WHERE 1=1 AND per_id = '"+per_id+"'" ;
		
		Calendar sd = DBUtility.calendar();
		sd.setTime(late_date);
		sd.set(Calendar.DATE, 1);
		String start = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
		
		sd.add(Calendar.MONTH, +1);
		sd.add(Calendar.DATE, -1);
		String end = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
		
		sql += " AND (late_date between '" + start + " 00:00:00.00' AND '" + end + " 23:59:59.99')";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String cnt = "";
		while (rs.next()) {
			cnt = DBUtility.getString("cnt", rs);
		}
		
		rs.close();
		st.close();
		conn.close();
		return cnt;
	}
	
	public static boolean check(Connection conn, String per_id, Date late_date) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException {
		Late entity = new Late();
		entity.setPer_id(per_id);
		entity.setLate_date(late_date); 
		return DBUtility.getEntityFromDB(conn, tableName, entity, keys);
	}
	
	public static void insertOrUpdate(String per_id, Date late_date) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();
		if (check(conn, per_id, late_date)){
			updateLate(per_id,late_date);
		}else {
			insertLate(per_id, late_date);
		}
		conn.close();
	}
	
	public static void updateLate(String per_id, Date late_date) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();
		Late entity = new Late();
		entity.setPer_id(per_id);
		entity.setLate_date(late_date);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldUpdate, keys);
		conn.close();
	}
	
	public static void insertLate(String per_id, Date late_date) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		Late entity = new Late();
		entity.setPer_id(per_id);
		
		Calendar today = DBUtility.calendar();
		today.setTime(WebUtils.getCurrentDate());
		
		Calendar late_day = DBUtility.calendar();
		late_day.setTime(late_date);
		
		if(today.after(late_day)){
		 	entity.setLate_date(late_date);
			entity.setCreate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.insertToDB(conn, tableName, entity);
			conn.close();
		}else{
		}
	}
	
	public String getPer_id() {
		return per_id;
	}
	public void setPer_id(String per_id) {
		this.per_id = per_id;
	}
	public Date getLate_date() {
		return late_date;
	}
	public void setLate_date(Date late_date) {
		this.late_date = late_date;
	}
	public String getLate_status() {
		return late_status;
	}
	public void setLate_status(String late_status) {
		this.late_status = late_status;
	}
	public String getLate_remark() {
		return late_remark;
	}
	public void setLate_remark(String late_remark) {
		this.late_remark = late_remark;
	}
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}
	public Timestamp getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
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
	
	

}
