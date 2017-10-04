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
import com.bitmap.webutils.PageControl;

public class InventoryMasterTemp {
	public static String tableName = "inv_master_template";
	private static String[] keys = {"id_template"};
	
	String id_template = "";
	String name = "";
	
	public static void insert(InventoryMasterTemp entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setId_template(DBUtility.genNumber(conn, tableName,"id_template"));
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}

	public static InventoryMasterTemp select(InventoryMasterTemp entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity,keys);
		conn.close();
		return entity;
	}
	
	public static String selectName(String id_template) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		InventoryMasterTemp entity = new InventoryMasterTemp();
		entity.setId_template(id_template);
		DBUtility.getEntityFromDB(conn, tableName, entity,keys);
		conn.close();
		return entity.getName();
	}
	public static List<InventoryMasterTemp> selectWithCtrl(PageControl ctrl) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " ORDER BY (id_template*1) ASC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryMasterTemp> list = new ArrayList<InventoryMasterTemp>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					InventoryMasterTemp entity = new InventoryMasterTemp();
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
	
	public static List<String[]> ddl() throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		List<String[]> list = DBUtility.getDropDownListData(conn,tableName,"id_template","name","id_template");
		conn.close();
		return list;
	}
	
	public static void update(InventoryMasterTemp entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"name"},keys);
		conn.close();
	}

	public String getId_template() {
		return id_template;
	}

	public void setId_template(String id_template) {
		this.id_template = id_template;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	
}