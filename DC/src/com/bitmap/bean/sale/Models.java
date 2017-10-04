package com.bitmap.bean.sale;

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
import java.util.Map;

import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class Models {
	public static String tableName = "mk_models";
	public static String[] keys = {"id"};//primary keys
	public static String[] fieldNames = {"id", "model_id", "model_name", "brand_id", "create_by", "create_date", "update_by", "update_date"};
	
	private String id ="";
    private	String model_id="";
	private String model_name="";
	private String brand_id ="";
	private String create_by;
	private String update_by;
	private Timestamp create_date;
	private Timestamp update_date;
	
	Map UImap = null;
	
	
	
	public Map getUImap() {
		return UImap;
	}
	public void setUImap(Map uImap) {
		UImap = uImap;
	}
	public  static boolean check(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Models entity = new Models();
		entity.setId(id);
		return check(entity);
	}
	public  static boolean check(Models entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}
	
	public  static boolean checkName(String name) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Models entity = new Models();
		entity.setModel_name(name);
		return checkName(entity);
	}
	public  static boolean checkName(Models entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"model_name"});
		conn.close();
		return check;
	}
	
	public  static boolean checkBrand_id(String brand_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Models entity = new Models();
		entity.setBrand_id(brand_id);
		return checkBrand_id(entity);
	}
	public  static boolean checkBrand_id(Models entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"brand_id"});
		conn.close();
		return check;
	}
	
	public  static boolean checkNameBrand(String name ,String brand) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Models entity = new Models();
		entity.setModel_name(name);
		entity.setBrand_id(brand);
		return checkNameBrand(entity);
	}
	public  static boolean checkNameBrand(Models entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"model_name" ,"brand_id"});
		System.out.println("brand_id="+entity.getBrand_id()+" ,model_name="+entity.getModel_name()+" ::"+check);
		conn.close();
		return check;
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
	public static Models  selectcheckNameBrand(String id ,String name ,String brand) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Models entity = new Models();
		entity.setId(id);
		entity.setModel_name(name);
		entity.setBrand_id(brand);
		return selectcheckNameBrand(entity);
	}
	public static Models selectcheckNameBrand(Models entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"id","model_name","brand_id"});
		conn.close();
		return entity;
		
	}
	public static Models  selectcheckName(String id ,String name) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Models entity = new Models();
		entity.setId(id);
		entity.setModel_name(name);
		return selectcheckName(entity);
	}
	public static Models selectcheckName(Models entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"id","model_name"});
		conn.close();
		return entity;
		
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
		Map map = new HashMap();
		map.put(Brands.tableName, Brands.select(entity.getBrand_id(), conn));
		entity.setUImap(map);
		conn.close();
		return entity;
	}
	
	public static List<Models> selectList(String brand_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE brand_id ='" + brand_id + "' ORDER BY brand_id";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Models> list = new ArrayList<Models>();
		//System.out.println(sql);
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
	
	
	public static List<Models> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		
		String sql = " SELECT * FROM " + tableName + " AS  MD " ;
		       sql +=" LEFT JOIN  mk_brands  AS BB ON MD.brand_id = BB.brand_id ";
			   sql +=" WHERE 1=1 ";
			   
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("brand1")){
					sql += " AND  BB.brand_id like'%" + str[1]+ "%' ";
				}else if(str[0].equalsIgnoreCase("model1")){
					sql += " AND  MD.model_id like'%" + str[1]+ "%' ";
				} else {
					sql += " AND " + str[0] + "='" + str[1] + "' ";
				}
			}
		}
	
		sql += " ORDER BY BB.brand_name ASC ,MD.model_name ASC";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Models> list = new ArrayList<Models>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Models entity = new Models();
					DBUtility.bindResultSet(entity, rs);
					
					Map map = new HashMap();
					map.put(Brands.tableName, Brands.select(entity.getBrand_id(), conn));
					entity.setUImap(map);
					
					
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		st.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
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
		Connection conn = DBPool.getConnection();
		Models entity = new Models();
		entity.setModel_id(id);
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"model_id"});
		conn.close();
		return entity.getModel_name();
	}
	
	public static Models select(String id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Models entity = new Models();
		entity.setModel_id(id);
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"model_id"});
		return entity;
	}
	
	public static String getUIName(String id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Models entity = new Models();
		entity.setModel_id(id);
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"model_id"});
		return entity.getModel_name();
	}
	
	public static void insert(Models entity) throws Exception{
		try {
			Connection conn = DBPool.getConnection();
			entity.setCreate_date(DBUtility.getDBCurrentDateTime());
			entity.setModel_id(genModel_Id(conn,entity.getBrand_id()));
			entity.setId(DBUtility.genNumber(conn, tableName, "id"));
			System.out.println("Model_id:"+entity.getModel_id()+"=id:"+entity.getId()+"= Model_name:"+entity.getModel_name());
			DBUtility.insertToDB(conn, tableName, entity);
			conn.close();
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		
	
	}
	private static String genModel_Id(Connection conn,String brand_id) throws SQLException{
		
		    String id ="0";
		    String data_model;
		    String number_str;
			String sql = "SELECT COUNT(*) AS number  FROM " + tableName + " WHERE  brand_id='" + brand_id +"'";
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			
			if (rs.next()) { 
				
				String data = DBUtility.getString("number", rs);
				int number = (Integer.parseInt(data) + 1);
				number_str = String.valueOf(number);
				if(number < 10){
					data_model = "0"+number_str;
				}else{
					data_model = number_str;
				}
				id = brand_id+"_"+data_model;
				
			}
			rs.close(); 
			st.close();
			return id;
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
		//DBUtility.updateToDB(conn, tableName, entity, new String[]{"model_name"}, new String[]{"model_id"});
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"model_name","model_id","brand_id","update_by","update_date"},keys);
		conn.close();
	}
	
	public static void delete(Models entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
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
