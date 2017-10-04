package com.bitmap.bean.inventory;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class InventoryService {
	public static String tableName = "inv_service";
	private static String[] keys = {"auto_id"};

	String auto_id = "";
	String repair_id = "";
	String description = "";
	String price = "";
	String create_by = "";	
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	
	public static void insert(InventoryService entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setAuto_id(DBUtility.genNumber(conn, tableName,"auto_id"));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static void delete(InventoryService entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity,keys);
		conn.close();
	}
	
	
	public static List<InventoryService> selectList(String repair_id) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE repair_id = '" + repair_id + "' ORDER BY (repair_id*1)";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryService> list = new ArrayList<InventoryService>();
		
		while (rs.next()) {
			InventoryService entity = new InventoryService();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}

	public static List<InventoryService> selectWithCTRL(PageControl ctrl, String where) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName;
		if (where.length() > 0) {
			sql += " WHERE " + where;
		}
		sql += " ORDER BY (mat_code*1)";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryService> list = new ArrayList<InventoryService>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					InventoryService entity = new InventoryService();
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
	public static List<InventoryService> selectWithCTRL(PageControl ctrl, List<String[]> param) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT " +
						"a.*," +
						"(SELECT g.group_name_en FROM inv_group g WHERE g.group_id = a.group_id) AS group_name," +
						"(SELECT c.cat_name_short FROM inv_categories c WHERE c.cat_id = a.cat_id AND c.group_id = a.group_id) AS cat_name," +
						"(SELECT s.sub_cat_name_short FROM inv_sub_categories s WHERE s.sub_cat_id = a.sub_cat_id AND s.cat_id = a.cat_id AND s.group_id = a.group_id) AS sub_cat_name " +
					 "FROM " + tableName + " a " +
					 "WHERE 1=1 ";
		
		for (Iterator<String[]> iterator = param.iterator(); iterator.hasNext();) {
			String[] pm = (String[]) iterator.next();
			if (pm[1].length() > 0) {
				if(pm[0].equalsIgnoreCase("keyword")) {
					sql += " AND (a.description like '%" + pm[1] + "%'" +
						   " OR a.mat_code like '%" + pm[1] + "%')";
				} else if(pm[0].equalsIgnoreCase("master_matcode")){
					
				} else {
					sql += " AND a." + pm[0] + " ='" + pm[1] + "'";
				}
			}
		}
		
		sql += " ORDER BY (a.mat_code*1)";
		////System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryService> list = new ArrayList<InventoryService>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					InventoryService entity = new InventoryService();
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
	public String getAuto_id() {
		return auto_id;
	}

	public void setAuto_id(String auto_id) {
		this.auto_id = auto_id;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getPrice() {
		return price;
	}

	public void setPrice(String price) {
		this.price = price;
	}
	

}