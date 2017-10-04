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
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;
import com.bitmap.webutils.PageControl;

public class OTRequest {
	
	public static String tableName = "per_ot_request";
	public static String[] keys = {"per_id" ,"ot_date"};
	public static String[] fieldName = {"ot_hours","ot_rate","ot_total","remark","apv_by","apv_date","update_date","update_by"};
	

	String per_id = "";
	Date ot_date = null;
	String ot_hours = "";
	String ot_rate = "";
	String ot_total = "";
	String remark = "";
	String apv_by = "";
	Timestamp apv_date = null;
	Timestamp create_date = null;
	String create_by = "";
	Timestamp update_date = null;
	String update_by = "";
	
	public static void insert(OTRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static List<OTRequest> selectWithCTRL(PageControl ctrl, List<String[]> params, String per_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 AND per_id ='" + per_id + "'";
		String m = "";
		String y = "";		
		/*for (Iterator<String[]> iterator = params.iterator(); iterator.hasNext();) {
			String[] pm = (String[]) iterator.next();
			if (pm[1].length() > 0) {
				if (pm[0].equalsIgnoreCase("keyword")) {
					sql += " AND remark LIKE '%" + pm[1] + "%' OR remark LIKE '%" + pm[1] + "%' OR remark LIKE '%" + pm[1] + "%' OR remark LIKE '%" + pm[1] + "%'";
				} else {
					sql += " AND " + pm[0] + "='" + pm[1] + "'";
				}
			}
		}*/		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("year")){
					y = str[1];
				} else if (str[0].equalsIgnoreCase("month")) {
					m = str[1];
				} else {
					sql += " AND " + str[0] + " LIKE '%" + str[1] + "%'";
				}
			}
		}
		
		if (m.length() > 0) {
			Calendar sd = DBUtility.calendar();
			sd.clear();
			sd.set(Calendar.YEAR, Integer.parseInt(y));
			sd.set(Calendar.MONTH, Integer.parseInt(m) - 1);
			sd.set(Calendar.DATE, 1);
			
			String s = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
			
			sd.add(Calendar.MONTH, +1);
			sd.add(Calendar.DATE, -1);
			String e = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
			
			sql += " AND (ot_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99')";
		} else {
			if (y.length() > 0) {
				sql += " AND (ot_date between '" + y + "-01-01 00:00:00.00' AND '" + y + "-12-31 23:59:59.99')";
			}
		}
		
		sql += " ORDER BY ot_date";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<OTRequest> list = new ArrayList<OTRequest>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					OTRequest entity = new OTRequest();
					DBUtility.bindResultSet(entity, rs);
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		st.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
	
	public static OTRequest select(String per_id, String ot_date) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, ParseException{
		OTRequest ot = new OTRequest();
		ot.setPer_id(per_id);
		ot.setOt_date(DBUtility.getDate(ot_date));
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, ot, keys);
		conn.close();
		return ot;
	}
	
	/**
	 * Used ot_edit.jsp
	 * <br>
	 * ใช้select ข้อมูลรายการทำโอทีที่ต้องการแก้ไข เพื่อ edit ข้อมูลการทำโอที
	 * @param entity
	 * @throws IllegalArgumentException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws ParseException
	 */
	public static void select(OTRequest entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, ParseException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public static void update(OTRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldName, keys);
		conn.close();
	}
	
	/**
	 * Used emp_summary.jsp
	 * <br>
	 * ใช้คำนวน ชัวโมงโอที และ ค่าโอทีที่ได้รับ ต่อเดือน ของพนักงานรายเดือน
	 * @param per_id
	 * @param m
	 * @param y
	 * @param salary
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static String[] count_ot(String per_id,String m,String y,String salary) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE per_id ='" + per_id + "'";
		
		Calendar sd = DBUtility.calendar();
		sd.clear();
		sd.set(Calendar.YEAR, Integer.parseInt(y));
		sd.set(Calendar.MONTH, Integer.parseInt(m) - 1);
		sd.set(Calendar.DATE, 1);
		
		String s = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
		
		sd.add(Calendar.MONTH, +1);
		sd.add(Calendar.DATE, -1);
		String e = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
		
		sql += " AND (ot_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99')";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		String ot = Money.divide(salary, "240");
		String cnt_ot = "0";
		String money_ot = "0";
		while (rs.next()) {
			OTRequest entity = new OTRequest();
			DBUtility.bindResultSet(entity, rs);
			cnt_ot = Money.add(entity.getOt_hours(), cnt_ot);
			money_ot = Money.add(money_ot, Money.multiple(Money.multiple(entity.getOt_hours(), ot), entity.getOt_rate()));
		}
		rs.close();
		st.close();
		conn.close();
		return new String[]{cnt_ot, money_ot};
	}
	
	public static void delete(OTRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, keys);
		conn.close();
	}

	public String getOt_rate() {
		return ot_rate;
	}

	public void setOt_rate(String ot_rate) {
		this.ot_rate = ot_rate;
	}

	public String getOt_total() {
		return ot_total;
	}

	public void setOt_total(String ot_total) {
		this.ot_total = ot_total;
	}

	public String getPer_id() {
		return per_id;
	}
	public void setPer_id(String per_id) {
		this.per_id = per_id;
	}
	public String getOt_hours() {
		return ot_hours;
	}
	public void setOt_hours(String ot_hours) {
		this.ot_hours = ot_hours;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getApv_by() {
		return apv_by;
	}
	public void setApv_by(String apv_by) {
		this.apv_by = apv_by;
	}
	public Timestamp getApv_date() {
		return apv_date;
	}
	public void setApv_date(Timestamp apv_date) {
		this.apv_date = apv_date;
	}
	public Timestamp getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}
	
	public Date getOt_date() {
		return ot_date;
	}
	public void setOt_date(Date ot_date) {
		this.ot_date = ot_date;
	}

	public String getCreate_by() {
		return create_by;
	}

	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}

	public Timestamp getUpdate_date() {
		return update_date;
	}

	public void setUpdate_date(Timestamp update_date) {
		this.update_date = update_date;
	}

	public String getUpdate_by() {
		return update_by;
	}

	public void setUpdate_by(String update_by) {
		this.update_by = update_by;
	}
	
	
}
