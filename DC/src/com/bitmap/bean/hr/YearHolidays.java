package com.bitmap.bean.hr;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;

public class YearHolidays {
	public static String tableName = "per_year_holidays";
	public static String[] keys = {"year","holidays_date"};
	public static String[] fieldNames = {"holidays_name","remark","update_by","update_date"};
		
	String year ="";
	Date holidays_date= null;
	String holidays_name = "";
	String remark = "";
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	
	public static void insert(YearHolidays entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	/**
	 * USED holidays_manage.jsp
	 * <br>
	 * แสดง List ของวันหยุดทั้งหมดในปีนั้น
	 * @param year
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<YearHolidays> selectList(String year) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM "+tableName+" WHERE year='"+year+"'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<YearHolidays> list = new ArrayList<YearHolidays>();
		while (rs.next()) {
			YearHolidays entity = new YearHolidays();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	/**
	 * USED emp_summary.jsp
	 * <br>
	 * ได้วันหยุดทั้งหมดในเดือนนั้น ที่ไม่ได้เป็นวันหยุดประจำปี
	 * @param year
	 * @param month
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static HashMap<String, YearHolidays> selectList(String year, String month) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException {
		Calendar cd = DBUtility.calendar();
		cd.set(Calendar.YEAR, Integer.parseInt(year));
		cd.set(Calendar.MONTH, Integer.parseInt(month)-1);
		cd.set(Calendar.DATE, 1);
		String s = DBUtility.DATE_DATABASE_FORMAT.format(cd.getTime());
		cd.add(Calendar.MONTH, +1);
		cd.add(Calendar.DATE, -1);
		String e = DBUtility.DATE_DATABASE_FORMAT.format(cd.getTime());
		
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM "+tableName+" WHERE year='"+year+"' AND (holidays_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99')";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		////System.out.println(sql);
		
		HashMap<String, YearHolidays> map = new HashMap<String, YearHolidays>();
		while (rs.next()) {
			YearHolidays entity = new YearHolidays();
			DBUtility.bindResultSet(entity, rs);
			map.put(DBUtility.DATE_DATABASE_FORMAT.format(entity.getHolidays_date()), entity);
		}
		rs.close();
		st.close();
		conn.close();
		return map;
	}
	

	
	public static void select(YearHolidays entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, ParseException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public static void update(YearHolidays entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public static void delete(YearHolidays entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, keys);
		conn.close();
	}

	
	public String getYear() {
		return year;
	}
	public void setYear(String year) {
		this.year = year;
	}
	public Date getHolidays_date() {
		return holidays_date;
	}
	public void setHolidays_date(Date holidays_date) {
		this.holidays_date = holidays_date;
	}
	public String getHolidays_name() {
		return holidays_name;
	}
	public void setHolidays_name(String holidays_name) {
		this.holidays_name = holidays_name;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
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
