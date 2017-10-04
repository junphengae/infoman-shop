package com.bitmap.bean.inventory;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class InventoryRepairDetail {
	public static String tableName = "inv_repair_detail";
	private static String[] keys = {"auto_id"};

	String auto_id = "";
	String repair_id = "";
	String mat_code = "";
	String qty = "1";
	String status = "";
	String create_by = "";	
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	
	/**
	 * สถานะ
	 */
	public static String STATUS_WAIT = "10";
	public static String STATUS_OUTLET = "20";
	public static String STATUS_REFUND = "30";
	public static String STATUS_CHANGE	= "40";
	
	public static String status(String status){
		HashMap<String, String> map = new HashMap<String, String>();
		map.put(STATUS_WAIT,"รอการเบิก");
		map.put(STATUS_OUTLET,"เบิกเรียบร้อยแล้ว");
		map.put(STATUS_REFUND,"คืนเรียบร้อยแล้ว");
		map.put(STATUS_CHANGE,"เปลี่ยนอะไหล่");
		return map.get(status);
	}
	
	public static InventoryRepairDetail select(InventoryRepairDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static void insert(InventoryRepairDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setAuto_id(DBUtility.genNumber(conn, tableName,"auto_id"));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static void delete(InventoryRepairDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity,keys);
		conn.close();
	}
	
	public static void updateStatus(InventoryRepairDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,new String[]{"status","update_by","update_date"},keys);
		conn.close();
	}
	
	
	public static List<InventoryRepairDetail> selectList(String repair_id) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE repair_id = '" + repair_id + "' ORDER BY (repair_id*1)";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryRepairDetail> list = new ArrayList<InventoryRepairDetail>();
		
		while (rs.next()) {
			InventoryRepairDetail entity = new InventoryRepairDetail();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}

	public static List<InventoryRepairDetail> selectWithCTRL(PageControl ctrl, String where) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName;
		if (where.length() > 0) {
			sql += " WHERE " + where;
		}
		sql += " ORDER BY (mat_code*1)";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryRepairDetail> list = new ArrayList<InventoryRepairDetail>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					InventoryRepairDetail entity = new InventoryRepairDetail();
					DBUtility.bindResultSet(entity, rs);
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
	
	/**
	 * ken: inventory/inventory_list.jsp
	 * <br>
	 * �?�?้ไขให้�?สดง status ทั้งหมด
	 * @param ctrl
	 * @param param
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<InventoryRepairDetail> selectWithCTRL(PageControl ctrl, List<String[]> param) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 ";
		
		for (Iterator<String[]> iterator = param.iterator(); iterator.hasNext();) {
			String[] pm = (String[]) iterator.next();
			if (pm[1].length() > 0) {	
					sql += " AND " + pm[0] + " ='" + pm[1] + "'";
			}
		}
		
		sql += " ORDER BY (repair_id*1) ASC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryRepairDetail> list = new ArrayList<InventoryRepairDetail>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					InventoryRepairDetail entity = new InventoryRepairDetail();
					DBUtility.bindResultSet(entity, rs);
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

	public String getRepair_id() {
		return repair_id;
	}

	public void setRepair_id(String repair_id) {
		this.repair_id = repair_id;
	}
	public String getMat_code() {
		return mat_code;
	}
	public void setMat_code(String mat_code) {
		this.mat_code = mat_code;
	}
	public String getQty() {
		return qty;
	}
	public void setQty(String qty) {
		this.qty = qty;
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

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getAuto_id() {
		return auto_id;
	}

	public void setAuto_id(String auto_id) {
		this.auto_id = auto_id;
	}
	

}