package com.bitmap.bean.parts;

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

public class ServiceRepairCondition {
	public static String tableName = "service_repair_condition";
	public static String[] keys = {"id","con_number"};
	public static String[] fieldNames = {"id","con_number","con_name","con_detail","create_by","create_date","update_by","update_date","branch_code"};
		
	
	String id = "";
	String con_number = "";
	String con_name = "";
	String con_detail = "";
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	String branch_code = "";
	
	
	public  static boolean check(String id ,String con_number) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		ServiceRepairCondition entity = new ServiceRepairCondition();
		entity.setId(id);
		entity.setCon_number(con_number);
		return check(entity);
	}
	public  static boolean check(ServiceRepairCondition entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}
	public static void insert(ServiceRepairCondition entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCon_number(DBUtility.genNumberFromDB(conn, tableName, entity, new String[]{"id"}, "con_number"));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static void update(ServiceRepairCondition entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"con_detail","update_date","update_by"}, keys);
		conn.close();
	}
	
	public static void delete(ServiceRepairCondition entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public static ServiceRepairCondition select(String id,String con_number) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		ServiceRepairCondition entity = new ServiceRepairCondition();
		entity.setId(id);
		entity.setCon_number(con_number);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static void select(ServiceRepairCondition entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public static List<ServiceRepairCondition> selectList(String id) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE id='" + id + "' ORDER BY con_number";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<ServiceRepairCondition> list = new ArrayList<ServiceRepairCondition>();
		while (rs.next()) {
			ServiceRepairCondition entity = new ServiceRepairCondition();
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

	public String getCon_number() {
		return con_number;
	}

	public void setCon_number(String con_number) {
		this.con_number = con_number;
	}

	public String getCon_name() {
		return con_name;
	}

	public void setCon_name(String con_name) {
		this.con_name = con_name;
	}

	public String getCon_detail() {
		return con_detail;
	}

	public void setCon_detail(String con_detail) {
		this.con_detail = con_detail;
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
	public String getBranch_code() {
		return branch_code;
	}
	public void setBranch_code(String branch_code) {
		this.branch_code = branch_code;
	}
	
	
}
