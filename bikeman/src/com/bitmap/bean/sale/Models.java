package com.bitmap.bean.sale;

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

public class Models {
	public static String tableName = "mk_models";
	
	String model_id;
	String model_name;
	String brand_id;
	
	public static Models select(String id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Models entity = new Models();
		entity.setModel_id(id);
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"model_id"});
		return entity;
	}
	
	public static boolean checkNameForEdit(Models entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		boolean pass = false;
		String sql = "SELECT * FROM " + tableName + " WHERE model_id!='" + entity.getModel_id() + "' AND model_name='" + entity.model_name + "' AND brand_id='"+entity.getBrand_id()+"'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);			
		pass = rs.next();
		rs.close();
		st.close();
		conn.close();
		return pass;
	}
	
	public static List<String[]> selectDDL(String brand_id) throws SQLException{
		String sql = "SELECT * FROM " + tableName + " WHERE brand_id ='" +brand_id+"'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		List<String[]> list = new ArrayList<String[]>();
		while (rs.next()) {
			list.add(new String[]{rs.getString("model_id"),rs.getString("model_name")});
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static Models select(Models entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"model_id","brand_id"});
		conn.close();
		return entity;
	}
	
	public static List<Models> selectList(String brand_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE brand_id ='" + brand_id + "' ORDER BY brand_id";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Models> list = new ArrayList<Models>();
		////System.out.println(sql);
		while (rs.next()) {
			Models entity = new Models();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<String[]> getUIModel(String brand) throws SQLException {
		String sql = "SELECT * FROM " + tableName + " WHERE brand_id ='" + brand + "'";
		Connection con = DBPool.getConnection();
		ResultSet rs = con.createStatement().executeQuery(sql);
		
		List<String[]> list = new ArrayList<String[]>();
		while (rs.next()) {
			list.add(new String[]{rs.getString("model_id"),rs.getString("model_name")});
		}
		rs.close();
		con.close();
		return list;
	}
	
	public static List<Models> getUIObjectModel(String brand) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE brand_id ='" + brand + "'";
		Connection con = DBPool.getConnection();
		ResultSet rs = con.createStatement().executeQuery(sql);
		
		List<Models> list = new ArrayList<Models>();
		while (rs.next()) {
			Models entity = new Models();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		con.close();
		return list;
	}
	
	public static String getUIName(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{		
		Models entity = new Models();
		entity.setModel_id(id);
		if (!entity.getModel_id().equalsIgnoreCase("")) {
			Connection conn = DBPool.getConnection();
			DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"model_id"});
			conn.close();
		}
				
		return entity.getModel_name();
	}
	
	public static String getUIName(String id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Models entity = new Models();
		entity.setModel_id(id);
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"model_id"});
		return entity.getModel_name();
	}
	
	public static void insert(Models entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setModel_id(genModelId(entity.getBrand_id()));
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	private static String genModelId(String brand_id) throws SQLException{
		String id = brand_id + "_10";
		Connection conn = DBPool.getConnection();
		String sql = "SELECT model_id FROM " + tableName + " WHERE brand_id='" + brand_id + "' ORDER BY model_id DESC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		if (rs.next()) {
			String data = rs.getString(1);
			String temp = (Integer.parseInt(data.split("_")[1])) + 110 + "";
			id = brand_id + "_" + temp.substring(1, temp.length());
		}
		rs.close();
		st.close();
		conn.close();
		return id;
	}
	
	public static void update(Models entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"model_name"}, new String[]{"model_id"});
		conn.close();
	}
	
	public String getModel_id() {
		return model_id;
	}
	public void setModel_id(String modelId) {
		model_id = modelId;
	}
	public String getModel_name() {
		return model_name;
	}
	public void setModel_name(String modelName) {
		model_name = modelName;
	}
	public String getBrand_id() {
		return brand_id;
	}
	public void setBrand_id(String brandId) {
		brand_id = brandId;
	}
}
