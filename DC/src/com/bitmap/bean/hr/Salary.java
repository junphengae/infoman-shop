package com.bitmap.bean.hr;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class Salary {
	
	public static String tableName = "per_salary";
	public static String[] keys = {"per_id"};
	public static String[] fieldSalary_update = {"salary","salary_type","flag_tax","ot_rate","limit_vacation","limit_sick","limit_business","update_date","update_by"};
	public static String[] fieldSalary_insert = {"per_id","salary","salary_type","flag_tax","ot_rate","limit_vacation","limit_sick","limit_business","create_date","create_by"};
	
	public static String TYPE_MONTH = "1";
	public static String TYPE_DAY = "2";
	
	public static String NO_TAX = "1";
	public static String PAY_TAX = "2";
	
	String per_id = "";
	String salary = "";
	String salary_type = "";
	String flag_tax = "";
	String ot_rate = "";
	String limit_vacation = "";
	String limit_sick = "";
	String limit_business = "";
	Timestamp create_date = null;
	String create_by = "";
	Timestamp update_date = null;
	String update_by = "";
	
	public static String flagTax(String flag_tax){
		HashMap<String, String> map = new HashMap<String, String>();
		map.put(NO_TAX, "ไม่เสียภาษี");
		map.put(PAY_TAX, "เสียภาษี");
		return map.get(flag_tax);
	}
	
	public static List<String[]> flagTaxList(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{"1","ไม่เสียภาษี"});
		list.add(new String[]{"2","เสียภาษี"});
		return list;
	}
	
	public static String salaryType(String type){
		HashMap<String, String> map = new HashMap<String, String>();
		map.put(TYPE_MONTH, "รายเดือน");
		map.put(TYPE_DAY, "รายวัน");
		return map.get(type);
	}
	
	public static List<String[]> salaryTypeList(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{"1","รายเดือน"});
		list.add(new String[]{"2","รายวัน"});
		return list;
	}
	
	public static List<String[]> selectDropdownList(String salary_type) throws SQLException{
		Connection conn =DBPool.getConnection();
		List<String[]> list = DBUtility.getDropDownList(conn, tableName, "per_id", "salary", "per_id","salary_type='" + salary_type + "'");
		conn.close();
		return list;
	}
	
	public static List<Salary> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		String m = "";
		String y = "";
		
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
		
		// sql += " ORDER BY ot_date";
		////System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Salary> list = new ArrayList<Salary>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Salary entity = new Salary();
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
	
	/**
	 * Used EmpManageServlet
	 * <br>
	 * อัพเดทข้อมูลเงินเดือนใน Salary
	 * @param per_id
	 * @param salary
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 */
	public static void updateSalaryNew(String per_id,String salary,String flag_tax) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		Salary entity = new  Salary();
		entity.setPer_id(per_id);
		entity.setSalary(salary);
		entity.setFlag_tax(flag_tax);
		DBUtility.updateToDB(conn, tableName, entity, new String[] {"salary","flag_tax"}, keys);
		conn.close();
	}
	
	
	
	// check insert or update

	/**
	 * Used emp_salary.jsp, EmpManageServlet
	 * <br>
	 * check ว่า insert หรือ update ถ้ามี per_id ที่ส่งมาแล้วให้ไป update ถ้ายังให้ insert
	 * @param conn
	 * @param per_id
	 * @return
	 * @throws IllegalArgumentException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static boolean check(Connection conn, String per_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Salary entity = new Salary();
		entity.setPer_id(per_id);
		return DBUtility.getEntityFromDB(conn, tableName, entity, keys);
	}
	
	public static void insertSalary(Salary entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		if (check(conn, entity.getPer_id())) {
			updateSalary(entity);
		} else {
			entity.setCreate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.insertToDB(conn, tableName, fieldSalary_insert, entity);
		}
		conn.close();
	}
	
	public static void updateSalary (Salary entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldSalary_update, keys);
		conn.close();
	}
	// -------------------------
	public static Salary select(String per_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Salary entity = new Salary();
		entity.setPer_id(per_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		//entity.setUIPerDetail(PersonalDetail.select(conn, per_id));
		conn.close();
		return entity;
	}
	
	public String getPer_id() {
		return per_id;
	}
	public void setPer_id(String per_id) {
		this.per_id = per_id;
	}
	public String getSalary() {
		return salary;
	}
	public void setSalary(String salary) {
		this.salary = salary;
	}
	public String getSalary_type() {
		return salary_type;
	}
	public void setSalary_type(String salary_type) {
		this.salary_type = salary_type;
	}
	public String getOt_rate() {
		return ot_rate;
	}
	public void setOt_rate(String ot_rate) {
		this.ot_rate = ot_rate;
	}
	public String getLimit_vacation() {
		return limit_vacation;
	}
	public void setLimit_vacation(String limit_vacation) {
		this.limit_vacation = limit_vacation;
	}
	public String getLimit_sick() {
		return limit_sick;
	}
	public void setLimit_sick(String limit_sick) {
		this.limit_sick = limit_sick;
	}
	public String getLimit_business() {
		return limit_business;
	}
	public void setLimit_business(String limit_business) {
		this.limit_business = limit_business;
	}
	public Timestamp getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
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

	public String getFlag_tax() {
		return flag_tax;
	}

	public void setFlag_tax(String flag_tax) {
		this.flag_tax = flag_tax;
	}
	
	
}
