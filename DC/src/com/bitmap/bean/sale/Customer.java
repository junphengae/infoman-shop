package com.bitmap.bean.sale;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import com.bitmap.ajax.AutoComplete;
import com.bitmap.bean.hr.Personal;
import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class Customer {
	public static final String tableName = "mk_customer";
	private static String[] keys = {"cus_id"};
	private static String[] fieldNames = {"cus_id_card","cus_name_en","cus_surname_en","cus_name_th","cus_surname_th",
										  "cus_birthdate","cus_sex","cus_email","cus_phone","cus_mobile","cus_address",
										  "cus_gmap","create_by","date_update"};
	
	String cus_id = "";
	String cus_id_card = "";
	String cus_tag_id = "";
	String cus_name_en = "";
	String cus_surname_en = "";
	String cus_name_th = "";
	String cus_surname_th = "";
	Date cus_birthdate = null;
	String cus_sex = "m";
	String cus_email = "";
	String cus_address = "";
	String cus_gmap = "";
	String cus_phone = "";
	String cus_mobile = "";
	String create_by = "";
	Timestamp date_create = null;
	Timestamp date_update = null;
	
	public static Customer select(String cus_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		Customer entity = new Customer();
		entity.setCus_id(cus_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static String select(String cus_id,Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Customer entity = new Customer();
		entity.setCus_id(cus_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		return entity.getCus_name_th() + " " + entity.getCus_surname_th();
	}
	
	public static String selectName(String cus_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		Customer entity = new Customer();
		entity.setCus_id(cus_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity.getCus_name_th() + " " + entity.getCus_surname_th();
	}
	
	public static Customer selectByIdCard(String cus_id_card) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		Customer entity = new Customer();
		entity.setCus_id_card(cus_id_card);
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"cus_id_card"});
		conn.close();
		return entity;
	}
	
	public static Customer select(Customer entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static List<Customer> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("keyword")){
					sql += " AND (cus_name_th like'%" + str[1] + "%' " +
						   " OR cus_surname_th like'%" + str[1] + "%' " +
						   " OR cus_email like'%" + str[1] + "%' " +
						   " OR cus_phone like'%" + str[1] + "%' " +
						   " OR cus_mobile like'%" + str[1] + "%' " +
						   " OR cus_id_card like'%" + str[1] + "%')";
				} else {
					sql += " AND " + str[0] + "='" + str[1] + "'";
				}
			}
		}
		
		sql += " ORDER BY cus_name_en ASC";
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Customer> list = new ArrayList<Customer>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Customer entity = new Customer();
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
	
	public static List<AutoComplete> listByAutocomplete(String str) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT cus_id,cus_name_th,cus_surname_th FROM " + tableName + " WHERE cus_name_th LIKE '%" + str + "%' OR cus_surname_th LIKE '%" + str + "%' ORDER BY cus_name_th";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<AutoComplete> list = new ArrayList<AutoComplete>();
		while (rs.next()) {
			Customer entity = new Customer();
			AutoComplete ac = new AutoComplete();
			DBUtility.bindResultSet(entity, rs);
			ac.setId(entity.getCus_id());
			ac.setValue(entity.getCus_name_th() + " " + entity.getCus_surname_th());
			list.add(ac);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<Customer> search(String search) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE " +
					 "cus_name_en LIKE '%" + search + "%' OR " +
					 "cus_surname_en LIKE '%" + search + "%' OR " +
					 "cus_name_th LIKE '%" + search + "%' OR " +
					 "cus_surname_th LIKE '%" + search + "%' OR " +
					 "cus_email LIKE '%" + search + "%' OR " +
					 "cus_phone LIKE '%" + search + "%' OR " +
					 "cus_mobile LIKE '%" + search + "%' OR " +
					 "cus_id_card LIKE '%" + search + "%'";
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Customer> list = new ArrayList<Customer>();
		while (rs.next()) {
			Customer entity = new Customer();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		
		conn.close();
		return list;
	}
	
	public static List<Customer> pageList(PageControl ctrl,String search) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " cus";
		if (search.length() > 0) {
			sql += " LEFT JOIN " + Vehicle.tableName + " vhc ON cus.cus_id = vhc.cus_id WHERE " +
				   "cus.cus_name_en LIKE '%" + search + "%' OR " +
				   "cus.cus_surname_en LIKE '%" + search + "%' OR " +
				   "cus.cus_name_th LIKE '%" + search + "%' OR " +
				   "cus.cus_surname_th LIKE '%" + search + "%' OR " +
				   "cus.cus_email LIKE '%" + search + "%' OR " +
				   "cus.cus_phone LIKE '%" + search + "%' OR " +
				   "cus.cus_mobile LIKE '%" + search + "%' OR " +
				   "cus.cus_id_card LIKE '%" + search + "%' OR " +
				   "vhc.license_plate LIKE '%" + search + "%' GROUP BY cus.cus_id";
		}
		////System.out.println("sql: " + sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Customer> list = new ArrayList<Customer>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Customer entity = new Customer();
					//DBUtility.bindResultSet(entity, rs);
					bindRS(entity, rs);
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
	
	private static void bindRS(Customer entity, ResultSet rs) throws SQLException{
		entity.setCus_id(rs.getString("cus.cus_id"));
		entity.setCus_id_card(rs.getString("cus.cus_id_card"));
		entity.setCus_name_en(rs.getString("cus.cus_name_en"));
		entity.setCus_name_th(rs.getString("cus.cus_name_th"));
		entity.setCus_surname_en(rs.getString("cus.cus_surname_en"));
		entity.setCus_surname_th(rs.getString("cus.cus_surname_th"));
		entity.setCus_mobile(rs.getString("cus.cus_mobile"));
	}
	
	public static String genCustomerId() throws SQLException{
		String id = "c00001";
		Connection conn = DBPool.getConnection();
		String sql = "SELECT cus_id FROM " + tableName + " ORDER BY cus_id DESC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		if (rs.next()) {
			String data = rs.getString(1);
			String temp = (Integer.parseInt(data.substring(1, data.length())) + 100001) + "";
			id = "c" + temp.substring(1, temp.length());
		}
		rs.close();
		st.close();
		conn.close();
		return id;
	}
	
	public static Customer insert(Customer entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCus_id(genCustomerId());
		entity.setDate_create(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
		return entity;
	}
	
	public static void update(Customer entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setDate_update(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public String getCus_id() {
		return cus_id;
	}
	public void setCus_id(String cus_id) {
		this.cus_id = cus_id;
	}
	public String getCus_id_card() {
		return cus_id_card;
	}
	public void setCus_id_card(String cus_id_card) {
		this.cus_id_card = cus_id_card;
	}
	public String getCus_tag_id() {
		return cus_tag_id;
	}
	public void setCus_tag_id(String cus_tag_id) {
		this.cus_tag_id = cus_tag_id;
	}
	public String getCus_name_en() {
		return cus_name_en;
	}
	public void setCus_name_en(String cus_name_en) {
		this.cus_name_en = cus_name_en;
	}
	public String getCus_surname_en() {
		return cus_surname_en;
	}
	public void setCus_surname_en(String cus_surname_en) {
		this.cus_surname_en = cus_surname_en;
	}
	public String getCus_name_th() {
		return cus_name_th;
	}
	public void setCus_name_th(String cus_name_th) {
		this.cus_name_th = cus_name_th;
	}
	public String getCus_surname_th() {
		return cus_surname_th;
	}
	public void setCus_surname_th(String cus_surname_th) {
		this.cus_surname_th = cus_surname_th;
	}
	public Date getCus_birthdate() {
		return cus_birthdate;
	}
	public void setCus_birthdate(Date cus_birthdate) {
		this.cus_birthdate = cus_birthdate;
	}
	public String getCus_sex() {
		return cus_sex;
	}
	public void setCus_sex(String cus_sex) {
		this.cus_sex = cus_sex;
	}
	public String getCus_email() {
		return cus_email;
	}
	public void setCus_email(String cus_email) {
		this.cus_email = cus_email;
	}
	public String getCus_address() {
		return cus_address;
	}
	public void setCus_address(String cus_address) {
		this.cus_address = cus_address;
	}
	public String getCus_gmap() {
		return cus_gmap;
	}
	public void setCus_gmap(String cus_gmap) {
		this.cus_gmap = cus_gmap;
	}
	public String getCus_phone() {
		return cus_phone;
	}
	public void setCus_phone(String cus_phone) {
		this.cus_phone = cus_phone;
	}
	public String getCus_mobile() {
		return cus_mobile;
	}
	public void setCus_mobile(String cus_mobile) {
		this.cus_mobile = cus_mobile;
	}
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}
	public Timestamp getDate_create() {
		return date_create;
	}
	public void setDate_create(Timestamp date_create) {
		this.date_create = date_create;
	}
	public Timestamp getDate_update() {
		return date_update;
	}
	public void setDate_update(Timestamp date_update) {
		this.date_update = date_update;
	}
}