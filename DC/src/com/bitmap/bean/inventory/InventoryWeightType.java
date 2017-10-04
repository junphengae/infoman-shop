package com.bitmap.bean.inventory;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;

public class InventoryWeightType {

	public static String tableName = "inv_weight_type";
	private static String[] keys = {"run"};
	
	String run = "";
	String group_id = "";
	String name = "";
	String flag = "";
	
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getRun() {
		return run;
	}
	public void setRun(String run) {
		this.run = run;
	}
	public String getGroup_id() {
		return group_id;
	}
	public void setGroup_id(String group_id) {
		this.group_id = group_id;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
	
	/**
	 * whan 
	 * select all weight type
	 * @return
	 * @throws NamingException
	 * @throws SQLException
	 */
	public static List<String[]> selectList() throws NamingException, SQLException{
		List<String[]> l = new ArrayList<String[]>();
		String sql = "SELECT * FROM " + tableName;
		Connection conn = DBPool.getConnection();
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		while(rs.next()){
			String id = DBUtility.getString("weight_id",rs);
			String name = DBUtility.getString("name",rs);
			String[] vals = {id,name};
			l.add(vals);
		}
		rs.close();
		st.close();
		conn.close();
		return l;
	}
	
	/**
	 * whan
	 * select only in group_id = des_unit ของ invmaster อยู่ group ไหน
	 * @param group_id
	 * @return
	 * @throws NamingException
	 * @throws SQLException
	 */
	public static List<String[]> selectList(String group_id) throws NamingException, SQLException{
		List<String[]> l = new ArrayList<String[]>();
		//String sql = "SELECT * FROM " + tableName + " WHERE group_id = '" + group_id + "'";
		
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 ";
		
		if (!group_id.equalsIgnoreCase("")) {
			sql+=" AND group_id = '" + group_id + "'";
		}
		
		//System.out.println("sql_unit::"+sql);
		
		Connection conn = DBPool.getConnection();
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		while(rs.next()){
			String id = DBUtility.getString("run",rs);
			String name = DBUtility.getString("name",rs);
			String[] vals = {id,name};
			l.add(vals);
		}
		rs.close();
		st.close();
		conn.close();
		return l;
	}
	public static String selectOnlyName(String des_unit) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		InventoryWeightType entity = new InventoryWeightType();
		entity.setRun(des_unit);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity.getName();
	}
	
	public static String selectGroup(String des_unit) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		InventoryWeightType entity = new InventoryWeightType();
		entity.setRun(des_unit);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity.getGroup_id();
	}

	public static String selectFlag(String run) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		InventoryWeightType entity = new InventoryWeightType();
		entity.setRun(run);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity.getFlag();
	}
	
	public static InventoryWeightType select(InventoryWeightType entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}

	
	
}
