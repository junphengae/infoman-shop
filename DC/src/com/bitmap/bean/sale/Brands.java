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

import com.bitmap.bean.branch.BranchMaster;
import com.bitmap.bean.inventory.InventoryMasterVendor;
import com.bitmap.bean.parts.PartLotControl;
import com.bitmap.bean.parts.Vendor;
import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;
import com.sun.xml.internal.stream.Entity;

public class Brands {
	public static String tableName = "mk_brands";
	public static String[] keys = {"order_by_id"};//primary keys 
	public static String[] fieldNames = {"order_by_id", "brand_id", "brand_name", "create_by", "create_date", "update_by", "update_date"};
	
	private String order_by_id = "";//primary keys 
	private String brand_id = "";
	private String brand_name = "";
	private String create_by = "";
	private String update_by = "";
	private Timestamp create_date = null;
	private Timestamp update_date = null;
	
	
	public  static boolean check(String order_by_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Brands entity = new Brands();
		entity.setOrder_by_id(order_by_id);
		return check(entity);
	}
	public  static boolean check(String brand_name ,String brand_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Brands entity = new Brands();
		entity.setBrand_name(brand_name);
		entity.setBrand_id(brand_id);
		return checkIdName(entity);
	}
	public  static boolean checkOrderID(String order_by_id ,String brand_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Brands entity = new Brands();
		entity.setOrder_by_id(order_by_id);
		entity.setBrand_id(brand_id);
		return checkOrderID(entity);
	}
	public  static boolean checkName(String brand_name) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Brands entity = new Brands();
		entity.setBrand_name(brand_name);
		return checkName(entity);
	}
	public  static boolean checkID(String brand_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Brands entity = new Brands();
		entity.setBrand_id(brand_id);
		return checkId(entity);
	}
	public  static boolean checkName(Brands entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"brand_name"});
		conn.close();
		return check;
	}
	public  static boolean checkId(Brands entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"brand_id"});
		conn.close();
		return check;
	}
	public  static boolean checkIdName(Brands entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"brand_id","brand_name"});
		conn.close();
		return check;
	}
	public  static boolean checkOrderID(Brands entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"brand_id","order_by_id"});
		conn.close();
		return check;
	}
	
	public  static boolean check(Brands entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}
	
	public static Brands  selectcheckCode(String id ,String code) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Brands entity = new Brands();
		entity.setOrder_by_id(id);
		entity.setBrand_id(code);
		return selectcheckCode(entity);
	}
	public static Brands selectcheckCode(Brands entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"order_by_id","brand_id"});
		conn.close();
		return entity;
		
	}

	
	public static Brands  selectCode(String code) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Brands entity = new Brands();
		entity.setBrand_id(code);
		return selectCode(entity);
	}
	public static Brands selectCode(Brands entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"brand_id"});
		conn.close();
		return entity;
	}
	
	
	public static Brands  selectcheckName(String id ,String name) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Brands entity = new Brands();
		entity.setOrder_by_id(id);
		entity.setBrand_name(name);
		return selectcheckName(entity);
	}
	public static Brands selectcheckName(Brands entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"order_by_id","brand_name"});
		conn.close();
		return entity;
		
	}
	
	public static Brands  selectName(String name) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Brands entity = new Brands();
		entity.setBrand_name(name);
		return selectName(entity);
	}
	public static Brands selectName(Brands entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"brand_name"});
		conn.close();
		return entity;
		
	}
	
	
	public static Brands  selectcheckCodeName(String id ,String code,String name) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Brands entity = new Brands();
		entity.setOrder_by_id(id);
		entity.setBrand_id(code);
		entity.setBrand_name(name);
		return selectcheckCodeName(entity);
	}
	public static Brands  selectcheckCodeName(Brands entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"order_by_id","brand_id","brand_name"});
		conn.close();
		return entity;
		
	}
	public static List<String[]> ddl() throws SQLException{
		String sql = "SELECT * FROM  " + tableName;
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<String[]> list = new ArrayList<String[]>();
		while (rs.next()) {
			list.add(new String[]{rs.getString("brand_id"),rs.getString("brand_name")});
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	public static String getUIName(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		Brands entity = new Brands();
		entity.setBrand_id(id);
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"brand_id"});
		conn.close();
		return entity.getBrand_name();
	}
	
	public static Brands select(String id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Brands entity = new Brands();
		entity.setBrand_id(id);
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"brand_id"});
		return entity;
	}
	
	public static String getUIName(String id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Brands entity = new Brands();
		entity.setBrand_id(id);
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"brand_id"});
		return entity.getBrand_name();
	}
	public static List<String[]> BrandDropdown() throws SQLException{
		String sql = "SELECT DISTINCT(brand_id) AS value, brand_name AS text  FROM " + tableName + " WHERE 1=1 ";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<String[]> list = new ArrayList<String[]>();
		while(rs.next()){
			HashMap<String,Object> entity = DBUtility.getEntity(rs);
			String value = (String) entity.get("value");
			String text = (String) entity.get("text");
			String[] data = {value,text};
			list.add(data);
		}
		
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<Brands> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
		String sql = "SELECT * FROM  " + tableName + "  WHERE 1=1 ";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("brand1")){
					sql += " AND LOWER(brand_id) like'%" + str[1] + "%'   ";
				} else {
					sql += " AND " + str[0] + "='" + str[1] + "' ";
				}
			}
		}
		sql += " ORDER BY brand_name ASC ";
		
		System.out.println("sql::"+sql);
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Brands> list = new ArrayList<Brands>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Brands entity = new Brands();
					DBUtility.bindResultSet(entity, rs);
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
	public static void insert(Brands entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		entity.setBrand_id(genBrandsCode(conn,entity.getBrand_name()));
		entity.setOrder_by_id(DBUtility.genNumber(conn, tableName, "order_by_id"));
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	private static String genBrandsCode(Connection conn,String brand_name) throws SQLException{
		
		String Brands = brand_name.substring(0, 1);
		String order_by_id = DBUtility.genNumber(conn, tableName, "order_by_id");
		String B_code ;
		if (Integer.parseInt(order_by_id) < 10) {
			B_code = Brands+"00"+order_by_id;
		}else if (Integer.parseInt(order_by_id) < 100){
			B_code = Brands+"0"+order_by_id;
		}else{
			B_code = Brands+order_by_id;
		}
		return B_code;
		
	}
	
	public static Brands select(Brands entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static void update(Brands entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"brand_name","update_by","update_date"}, keys);
		conn.close();
	}
	public static void delete(Brands entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	
	
	public String getOrder_by_id() {
		return order_by_id;
	}
	public void setOrder_by_id(String order_by_id) {
		this.order_by_id = order_by_id;
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
	public String getBrand_id() {
		return brand_id;
	}
	public void setBrand_id(String brand_id) {
		this.brand_id = brand_id;
	}
	public String getBrand_name() {
		return brand_name;
	}
	public void setBrand_name(String brand_name) {
		this.brand_name = brand_name;
	}
}
