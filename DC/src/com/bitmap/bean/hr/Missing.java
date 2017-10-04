package com.bitmap.bean.hr;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.WebUtils;

public class Missing {
	
	public static String tableName = "per_missing";
	public static String[] keys = {"per_id", "missing_date"};
	public static String[] fieldName = {"missing_status","missing_remark","update_by","update_date"};
	public static String[] fieldUpdate = {"missing_remark","update_by","update_date"};
	
	public static String STATUS_HOLD = "1";
	public static String STATUS_CHECKED = "0";
	
	String per_id = "";
	Date missing_date = null;
	String missing_status = "";
	String missing_remark = "";
	String update_by = "";
	Timestamp update_date = null;
	String create_by = "";
	Timestamp create_date = null;
	
	
	public static List<String[]> StatusList(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[] {"1","Hold"});
		list.add(new String[] {"0","Checked"});
		return list;
	}
	
	public static String Status(String missing_status){
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("1", "Hold");
		map.put("0", "Checked");
		return map.get(missing_status);
	}
	
	public static void insert(Missing entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	/**
	 * USED emp_summary.jsp
	 * <br>
	 * ใช้ insert วันที่ขาดงานลงใน table Missing
	 * @param per_id
	 * @param missing_date
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 */
	public static void insert(String per_id, Date missing_date) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		Missing entity = new Missing();
		entity.setPer_id(per_id);
		
		Calendar today = DBUtility.calendar();
		today.setTime(WebUtils.getCurrentDate());
		
		Calendar missing = DBUtility.calendar();
		missing.setTime(missing_date);
		
		////System.out.println(missing_date + " : " + today.after(missing));
		if(today.after(missing)){
			//วัน today อยู่ข้างหลัง วัน missing
			//วัน  missing น้อยกว่า today == บันทึกวัน missing นั้น
			////System.out.print("A");	
		 	entity.setMissing_date(missing_date);
			entity.setMissing_status(STATUS_HOLD);
			entity.setCreate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.insertToDB(conn, tableName, entity);
			conn.close();
		}else{
			//วัน today อยู่ก่อนหน้าวัน missing == ไม่บันทึกวัน missing นั้น
			////System.out.print("B");
		}
		
		
	}
	
	/**
	 * เช็คว่า record นี้มีหรือยัง
	 * @param conn
	 * @param per_id
	 * @param missing_date
	 * @return
	 * @throws IllegalArgumentException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static boolean check(Connection conn, String per_id, Date missing_date) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException {
		Missing entity = new Missing();
		entity.setPer_id(per_id);
		entity.setMissing_date(missing_date);
		return DBUtility.getEntityFromDB(conn, tableName, entity, keys);
	}
	
	/**
	 * USED emp_summary.jsp
	 * <br>
	 * ใช้เช็คว่า insert หรือ update
	 * @param per_id
	 * @param missing_date
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 */
	public static void insertOrUpdate(String per_id, Date missing_date) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();
		if (check(conn, per_id, missing_date)){
			updateMissing(per_id,missing_date);
		}else {
			insert(per_id, missing_date);
		}
		conn.close();
	}
	
	/**
	 * ใช้ update การขาดงาน
	 * @param per_id
	 * @param missing_date
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 */
	public static void updateMissing(String per_id, Date missing_date) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();
		Missing entity = new Missing();
		entity.setPer_id(per_id);
		entity.setMissing_date(missing_date);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldUpdate, keys);
		conn.close();
	}
	
	/**
	 * USED emp_summary.jsp
	 * <br>
	 * ใช้นับจำนวนวันที่ขาดงานในแต่ละเดือน
	 * @param per_id
	 * @param missing_date
	 * @return
	 * @throws SQLException
	 */
	public static String count_missing_month(String per_id, Date missing_date) throws SQLException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT count(missing_date) as cnt FROM " + tableName + " WHERE 1=1 AND per_id = '"+per_id+"'" ;
		
		Calendar sd = DBUtility.calendar();
		sd.setTime(missing_date);
		sd.set(Calendar.DATE, 1);
		String start = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
		
		sd.add(Calendar.MONTH, +1);
		sd.add(Calendar.DATE, -1);
		String end = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
		
		//String m = Integer.toString(sd.get(Calendar.MONTH));
		//String y = Integer.toString(sd.get(Calendar.YEAR));
		
		////System.out.println(m);
		sql += " AND (missing_date between '" + start + " 00:00:00.00' AND '" + end + " 23:59:59.99')";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		////System.out.println(sql);
		
		String cnt = "";
		while (rs.next()) {
			cnt = DBUtility.getString("cnt", rs);
		 }
		rs.close();
		st.close();
		conn.close();
		return cnt;
	}
	
	public String getPer_id() {
		return per_id;
	}
	public void setPer_id(String per_id) {
		this.per_id = per_id;
	}
	public Date getMissing_date() {
		return missing_date;
	}
	public void setMissing_date(Date missing_date) {
		this.missing_date = missing_date;
	}
	public String getMissing_status() {
		return missing_status;
	}
	public void setMissing_status(String missing_status) {
		this.missing_status = missing_status;
	}
	public String getMissing_remark() {
		return missing_remark;
	}
	public void setMissing_remark(String missing_remark) {
		this.missing_remark = missing_remark;
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
	
	

}
