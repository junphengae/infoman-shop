package com.bitmap.bean.inventory;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class InventoryPacking {
	
	public static String tableName = "inv_packing";
	public static String[] keys = {"mat_code","run_id"};
	public static String[] fieldName = {"description","unit","update_by","update_date"};
	
	String run_id = "";
	String mat_code = "";
	String description = "";
	String unit = "";
	String create_by = "";
	String update_by = "";
	Timestamp create_date = null;
	Timestamp update_date = null;
	
	public static void insert(InventoryPacking entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		entity.setRun_id(DBUtility.genNumber(conn, tableName, "run_id"));
		
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static List<InventoryPacking> selectWithCTRL(PageControl ctrl, List<String[]> param) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 ";
		
		for (Iterator<String[]> iterator = param.iterator(); iterator.hasNext();) {
			String[] pm = (String[]) iterator.next();
			if (pm[1].length() > 0) {
				if(pm[0].equalsIgnoreCase("keyword")) {
					sql += " AND (description like '%" + pm[1] + "%'" +
						   " OR mat_code like '%" + pm[1] + "%')";
				} else {
					sql += " AND " + pm[0] + " ='" + pm[1] + "'";
				}
			}
		}
		
		sql += " ORDER BY run_id";
		// System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryPacking> list = new ArrayList<InventoryPacking>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					InventoryPacking entity = new InventoryPacking();
					DBUtility.bindResultSet(entity, rs);
					/*entity.setUIGroup_name(DBUtility.getString("group_name", rs));
					entity.setUICat_name(DBUtility.getString("cat_name", rs));
					entity.setUISub_cat_name(DBUtility.getString("sub_cat_name", rs));*/
					list.add(entity);
				}
				cnt++;
			}
		}
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static InventoryPacking select(String run_id,String mat_code) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		InventoryPacking entity = new InventoryPacking();
		entity.setRun_id(run_id);
		entity.setMat_code(mat_code);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	public static InventoryPacking selectmat_code(String mat_code) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		InventoryPacking entity = new InventoryPacking();
		entity.setMat_code(mat_code);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"mat_code"});
		conn.close();
		return entity;
	}
	public static InventoryPacking select(String run_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		InventoryPacking entity = new InventoryPacking();
		entity.setRun_id(run_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity,new String[]{"run_id"});
		conn.close();
		return entity;
	}
	
	public static String selectOnlyunit(String run_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		InventoryPacking entity = new InventoryPacking();
		entity.setRun_id(run_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity,new String[]{"run_id"});
		conn.close();
		return entity.getUnit();
	}
	
	public static List<String[]> selectList(String mat_code) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE mat_code = '" + mat_code + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		ArrayList<String[]> list = new ArrayList<String[]>();
		while (rs.next()){
			InventoryPacking entity = new InventoryPacking();
			DBUtility.bindResultSet(entity, rs);
			list.add(new String[]{entity.getRun_id(),entity.getDescription()});
		}

		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<String[]> selectListWithValue(String mat_code) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE mat_code = '" + mat_code + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		ArrayList<String[]> list = new ArrayList<String[]>();
		while (rs.next()){
			InventoryPacking entity = new InventoryPacking();
			DBUtility.bindResultSet(entity, rs);
			list.add(new String[]{entity.getRun_id() + "_" + entity.getUnit(),entity.getDescription()});
		}

		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<InventoryPacking> list(String mat_code) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
	
		String sql = "SELECT * FROM " + tableName + " WHERE mat_code = '" + mat_code + "'";
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<InventoryPacking> list = new ArrayList<InventoryPacking>();
		while (rs.next()) {
			InventoryPacking entity = new InventoryPacking();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		conn.close();
		return list;
	}
	
	public static void select(InventoryPacking entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, ParseException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public static String selectOnlyDescription(String run_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, ParseException{
		Connection conn = DBPool.getConnection();
		InventoryPacking entity = new InventoryPacking();
		entity.setRun_id(run_id);
		DBUtility.getEntityFromDB(conn, tableName, entity,new String[] {"run_id"});
		conn.close();
		return entity.getDescription();
	}
	
	public static void update(InventoryPacking entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldName, keys);
		conn.close();
	}
	
	public String getRun_id() {
		return run_id;
	}
	public void setRun_id(String run_id) {
		this.run_id = run_id;
	}
	public String getMat_code() {
		return mat_code;
	}
	public void setMat_code(String mat_code) {
		this.mat_code = mat_code;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getUnit() {
		return unit;
	}
	public void setUnit(String unit) {
		this.unit = unit;
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
