package com.bitmap.bean.hr;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;

public class SalaryHistory {
	public static String tableName = "per_salary_history";
	public static String[] keys = {"id","per_id"};
	public static String[] fieldName = {"salary_old","salary_new"};
	
	String id = "";
	String per_id = "";
	String salary_old = "";
	String salary_new = "";
	String create_by = "";
	Timestamp create_date = null;
	
	/** emp_salary_edit.jsp, EmpManageServlet
	 * <br>
	 * เพิ่มข้อมูล ประวัติเงินเดือน
	 * @param entity
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 */
	public static void insert(SalaryHistory entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setId(DBUtility.genNumber(conn, tableName, "id"));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	/**
	 * emp_summary.jsp
	 * <br>
	 * แสดงประวัติฐานเงินเดือนของพนักงาน
	 * @param per_id
	 * @return
	 * @throws IllegalArgumentException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws UnsupportedEncodingException
	 */
	public static List<SalaryHistory> selectList(String per_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE per_id = '" + per_id + "'" ;
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SalaryHistory> list = new ArrayList<SalaryHistory>();
		while(rs.next()) {
			SalaryHistory entity = new SalaryHistory();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPer_id() {
		return per_id;
	}
	public void setPer_id(String per_id) {
		this.per_id = per_id;
	}
	public String getSalary_old() {
		return salary_old;
	}
	public void setSalary_old(String salary_old) {
		this.salary_old = salary_old;
	}
	public String getSalary_new() {
		return salary_new;
	}
	public void setSalary_new(String salary_new) {
		this.salary_new = salary_new;
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
