package com.bitmap.bean.inventory;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;

public class WeightType {
	public static String tableName = "inv_weight_type";
	public static String[] keys = {"run"};
	public static String[] fieldName = {"type_name","update_by","update_date"};
	
	String run = "";
	String group_id = "";
	String name = "";
	String flag = "";
	
	public static List<String[]> ddl_th() throws SQLException{
		Connection conn = DBPool.getConnection();
		List<String[]> list = DBUtility.getDropDownListData(conn, tableName, "run", "name", "run");
		conn.close();
		return list;
	}
	
	public static List<String[]> ddl_th2() throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " ORDER BY (run*1) ASC";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		ArrayList<String[]> list = new ArrayList<String[]>();
		while (rs.next()){
			WeightType entity = new WeightType();
			DBUtility.bindResultSet(entity, rs);
			list.add(new String[]{entity.getRun() + "_" + entity.getGroup_id(),entity.getName()});
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<WeightType> ddl_th(String group_id) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE group_id = '" + group_id + "' ORDER BY (run*1) ASC";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		ArrayList<WeightType> list = new ArrayList<WeightType>();
		while (rs.next()){
			WeightType entity = new WeightType();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static String selectName(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		WeightType entity = new WeightType();
		entity.setRun(id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity.getName();
	}
	
	public static String selectGroup(String run) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		WeightType entity = new WeightType();
		entity.setRun(run);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity.getGroup_id();
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

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getFlag() {
		return flag;
	}

	public void setFlag(String flag) {
		this.flag = flag;
	}
	
	
	

}
