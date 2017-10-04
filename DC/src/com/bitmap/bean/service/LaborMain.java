package com.bitmap.bean.service;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;

public class LaborMain {
	public static final String tableName = "sv_labor_time_main";
	private static String[] keys = {"main_id"};
	private static String[] fieldNames = {"main_th","main_en","update_by","update_date"};
	
	String main_id = "";
	String cate_id = "";
	String main_th = "";
	String main_en = "";
	String create_by = "";
	String update_by = "";
	Timestamp create_date = null;
	Timestamp update_date = null;
	
	public static List<LaborMain> list(String cate_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE cate_id='" + cate_id + "' ORDER BY main_id";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<LaborMain> list = new ArrayList<LaborMain>();
		while (rs.next()) {
			LaborMain entity = new LaborMain();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		conn.close();
		return list;
	}
	
	public static List<LaborMain> search(String cate_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "select * from  sv_labor_time_cate  Inner Join sv_labor_time_main  on sv_labor_time_cate.cate_id = sv_labor_time_main.cate_id  Inner Join sv_labor_time_guide on sv_labor_time_main.main_id = sv_labor_time_guide.main_id ";
		sql += "where sv_labor_time_cate.cate_id = '" + cate_id + "'";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<LaborMain> list = new ArrayList<LaborMain>();
		while (rs.next()) {
			LaborMain entity = new LaborMain();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		conn.close();
		return list;
	}
	
	
		
	private static String genId(LaborMain entity, Connection conn) throws SQLException{
		String id = entity.getCate_id() + "-0001";
		String sql = "SELECT main_id FROM " + tableName + " WHERE cate_id = '" + entity.getCate_id() + "' ORDER BY main_id DESC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		if (rs.next()) {
			String data = rs.getString(1);
			String temp = data.split("-")[1];
			temp = (Integer.parseInt(temp) + 10001) + "";
			id = entity.getCate_id() + "-" + temp.substring(1, temp.length());
		}
		rs.close();
		st.close();
		return id;
	}
	
	public static LaborMain insert(LaborMain entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		
		if (entity.getMain_en().length() == 0) {
			entity.setMain_en(entity.getMain_th());
		}
		
		entity.setMain_id(genId(entity, conn));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		
		conn.close();
		return entity;
	}
	
	public static LaborMain update(LaborMain entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setUpdate_by(entity.getCreate_by());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		return entity;
	}
	
	public static void update(LaborMain entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public static LaborMain select(String main_id) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		LaborMain entity = new LaborMain();
		entity.setMain_id(main_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public String getMain_id() {
		return main_id;
	}
	public void setMain_id(String main_id) {
		this.main_id = main_id;
	}
	public String getCate_id() {
		return cate_id;
	}
	public void setCate_id(String cate_id) {
		this.cate_id = cate_id;
	}
	public String getMain_th() {
		return main_th;
	}
	public void setMain_th(String main_th) {
		this.main_th = main_th;
	}
	public String getMain_en() {
		return main_en;
	}
	public void setMain_en(String main_en) {
		this.main_en = main_en;
	}
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}
	public String getUpdate_by() {
		return update_by;
	}
	public void setUpdate_by(String update_by) {
		this.update_by = update_by;
	}
	public Timestamp getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}
	public Timestamp getUpdate_date() {
		return update_date;
	}
	public void setUpdate_date(Timestamp update_date) {
		this.update_date = update_date;
	}
}