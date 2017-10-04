package com.bitmap.bean.inventory;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;

public class InventoryMasterTempDetail {
	public static String tableName = "inv_master_detailtemplate";
	private static String[] keys = {"master_matcode","id_detail"};
	
	
	String id_detail = "";
	String mat_code = "";
	String master_matcode = "";
	
	String UIdes = "";
	
	public static void insert(InventoryMasterTempDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setId_detail(DBUtility.genNumber(conn, tableName,"id_detail"));
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}

	public static boolean selectHave(String master_matcode,String mat_code) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		InventoryMasterTempDetail entity = new InventoryMasterTempDetail();
		entity.setMaster_matcode(master_matcode);
		entity.setMat_code(mat_code);
		boolean check = DBUtility.getEntityFromDB(conn, tableName, entity,new String[]{"master_matcode","mat_code"});
		conn.close();
		return check;
	}
	
	public static String genId(String id_template,Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		String sql = "SELECT * FROM " + tableName + " WHERE id_template = '" + id_template + "' ORDER BY (id_detail*1) DESC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String id = "0";
		if(rs.next()){
			id = rs.getString("id_detail");
		}
		
		rs.close();
		st.close();
		return Money.add(id,"1");

	}
	public static InventoryMasterTempDetail select(InventoryMasterTempDetail entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity,keys);
		conn.close();
		return entity;
	}
	
	public static List<InventoryMasterTempDetail> selectList(String mat_code) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT d.*,m.description FROM " + tableName + " d,inv_master m WHERE d.master_matcode = '" + mat_code + "' AND d.mat_code = m.mat_code ORDER BY (d.id_detail*1) ASC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		////System.out.println(sql);
		List<InventoryMasterTempDetail> list = new ArrayList<InventoryMasterTempDetail>();
		while (rs.next()) {
				InventoryMasterTempDetail entity = new InventoryMasterTempDetail();
				DBUtility.bindResultSet(entity, rs);
				entity.setUIdes(rs.getString("description"));
				list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	/**
	 * count mat_code component ของ สินค้าทีมี serial
	 * @param mat_code
	 * @return
	 * @throws IllegalArgumentException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static String countField(String mat_code) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT  COALESCE(COUNT(mat_code),0) as count FROM " + tableName + " WHERE master_matcode = '" + mat_code + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		String count = "0";
		if(rs.next()) {
			count = rs.getString("count");
		}
		conn.close();
		return count;
	}
	
	
	public static void update(InventoryMasterTempDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"name"},keys);
		conn.close();
	}

	public static void delete(InventoryMasterTempDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity,new String[] {"id_detail"});
		conn.close();
	}
	
	
	public String getMaster_matcode() {
		return master_matcode;
	}

	public void setMaster_matcode(String master_matcode) {
		this.master_matcode = master_matcode;
	}

	public String getId_detail() {
		return id_detail;
	}
	public void setId_detail(String id_detail) {
		this.id_detail = id_detail;
	}

	public String getMat_code() {
		return mat_code;
	}

	public void setMat_code(String mat_code) {
		this.mat_code = mat_code;
	}

	public String getUIdes() {
		return UIdes;
	}

	public void setUIdes(String uIdes) {
		UIdes = uIdes;
	}

	
}