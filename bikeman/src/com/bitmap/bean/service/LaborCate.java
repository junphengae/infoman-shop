package com.bitmap.bean.service;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;

public class LaborCate {
	public static final String tableName = "sv_labor_time_cate";
	private static String[] keys = {"cate_id"};
	private static String[] fieldNames = {"cate_th","cate_en","update_by","update_date"};
	
	String cate_id = "";
	String cate_th = "";
	String cate_en = "";
	String create_by = "";
	String update_by = "";
	Timestamp create_date = null;
	Timestamp update_date = null;
	
	public static List<LaborCate> list() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " ORDER BY cate_id";
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<LaborCate> list = new ArrayList<LaborCate>();
		while (rs.next()) {
			LaborCate entity = new LaborCate();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		conn.close();
		return list;
	}
	
	public static List<String[]> listDropDownEN() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " ORDER BY cate_id";
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<String[]> list = new ArrayList<String[]>();
		while (rs.next()) {
			LaborCate entity = new LaborCate();
			DBUtility.bindResultSet(entity, rs);
			list.add(new String[]{entity.getCate_id(),entity.getCate_en() + " / " + entity.getCate_th()});
		}
		conn.close();
		return list;
	}
	
	private static boolean check(LaborCate entity, Connection conn) throws SQLException{
		boolean has = false;
		String sql = "SELECT cate_id FROM " + tableName + " WHERE cate_id ='" + entity.getCate_id() + "'";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		if (rs.next()) {
			has = true;
		}
		rs.close();
		return has;
	}
	
	public static LaborCate insert(LaborCate entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		if (check(entity, conn)) {
			update(entity, conn);
		} else {
			if (entity.getCate_en().length() == 0) {
				entity.setCate_en(entity.getCate_th());
			}
			
			entity.setCate_id(DBUtility.genNumber(conn, tableName, "cate_id"));
			entity.setCreate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.insertToDB(conn, tableName, entity);
		}
		conn.close();
		return entity;
	}
	
	public static LaborCate update(LaborCate entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setUpdate_by(entity.getCreate_by());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		return entity;
	}
	
	public static LaborCate update(LaborCate entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setUpdate_by(entity.getCreate_by());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
		return entity;
	}
	
	public static LaborCate select(String cate_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		LaborCate entity = new LaborCate();
		entity.setCate_id(cate_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public String getCate_id() {
		return cate_id;
	}
	public void setCate_id(String cate_id) {
		this.cate_id = cate_id;
	}
	public String getCate_th() {
		return cate_th;
	}
	public void setCate_th(String cate_th) {
		this.cate_th = cate_th;
	}
	public String getCate_en() {
		return cate_en;
	}
	public void setCate_en(String cate_en) {
		this.cate_en = cate_en;
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