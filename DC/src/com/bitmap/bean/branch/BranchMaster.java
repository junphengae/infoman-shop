package com.bitmap.bean.branch;

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


public class BranchMaster {
	public static String tableName = "branch_master";
	public static String[] fieldNames = {"branch_id","branch_code","branch_name", "branch_order","branch_name_en","create_by","update_by","create_date","update_date","branch_lane","branch_road"
										,"branch_addressnumber","branch_moo","branch_villege","branch_district","branch_prefecture","branch_province"
										,"branch_postalcode","branch_phonenumber","branch_fax"};
							
	public static String[] keys = {"branch_id"};
	
	String branch_id="";
	String branch_code = "";
	String branch_name = "";
	String branch_name_en = "";
	String branch_order = "";
	String create_by = "";
	String update_by = "";
	Timestamp create_date = null;
	Timestamp update_date = null;
	String branch_lane = "";
	String branch_road = "";
	String branch_addressnumber = "";
	String branch_moo = "";
	String branch_villege = "";
	String branch_district = "";
	String branch_prefecture = "";
	String branch_province = "";
	String branch_postalcode = "";
	String branch_phonenumber = "";
	String branch_fax = "";
	
	
	public String getBranch_order() {
		return branch_order;
	}

	public void setBranch_order(String branch_order) {
		this.branch_order = branch_order;
	}

	public String getBranch_fax() {
		return branch_fax;
	}

	public void setBranch_fax(String branch_fax) {
		this.branch_fax = branch_fax;
	}

	public String getBranch_id() {
		return branch_id;
	}

	public void setBranch_id(String branch_id) {
		this.branch_id = branch_id;
	}

	public String getBranch_code() {
		return branch_code;
	}

	public void setBranch_code(String branch_code) {
		this.branch_code = branch_code;
	}

	public String getBranch_name() {
		return branch_name;
	}

	public void setBranch_name(String branch_name) {
		this.branch_name = branch_name;
	}
	
	public String getBranch_name_en() {
		return branch_name_en;
	}

	public void setBranch_name_en(String branch_name_en) {
		this.branch_name_en = branch_name_en;
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

	public String getBranch_addressnumber() {
		return branch_addressnumber;
	}

	public void setBranch_addressnumber(String branch_addressnumber) {
		this.branch_addressnumber = branch_addressnumber;
	}

	public String getBranch_villege() {
		return branch_villege;
	}

	public void setBranch_villege(String branch_villege) {
		this.branch_villege = branch_villege;
	}

	public String getBranch_district() {
		return branch_district;
	}

	public void setBranch_district(String branch_district) {
		this.branch_district = branch_district;
	}

	public String getBranch_prefecture() {
		return branch_prefecture;
	}

	public void setBranch_prefecture(String branch_prefecture) {
		this.branch_prefecture = branch_prefecture;
	}

	public String getBranch_province() {
		return branch_province;
	}

	public void setBranch_province(String branch_province) {
		this.branch_province = branch_province;
	}

	public String getBranch_postalcode() {
		return branch_postalcode;
	}

	public void setBranch_postalcode(String branch_postalcode) {
		this.branch_postalcode = branch_postalcode;
	}

	public String getBranch_phonenumber() {
		return branch_phonenumber;
	}

	public void setBranch_phonenumber(String branch_phonenumber) {
		this.branch_phonenumber = branch_phonenumber;
	}
	
	public String getBranch_lane() {
		return branch_lane;
	}

	public void setBranch_lane(String branch_lane) {
		this.branch_lane = branch_lane;
	}

	public String getBranch_road() {
		return branch_road;
	}

	public void setBranch_road(String branch_road) {
		this.branch_road = branch_road;
	}

	public String getBranch_moo() {
		return branch_moo;
	}

	public void setBranch_moo(String branch_moo) {
		this.branch_moo = branch_moo;
	}
	
	
	public static BranchMaster selectbranch_code(String branch_code) throws IllegalArgumentException, IllegalAccessException, InvocationTargetException, SQLException{
		
		BranchMaster entity = new BranchMaster();
		entity.setBranch_code(branch_code);
		return selectbranch_code(entity);		
	}
	
	public static BranchMaster selectbranch_code(BranchMaster entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity,new String[]{"branch_code"});
		conn.close();
		return entity;
	}
	
	public static BranchMaster select(String branch_id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		BranchMaster entity = new BranchMaster();
		entity.setBranch_id(branch_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		return entity;
	}
	public static BranchMaster selectBranchCode(String branch_code, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		BranchMaster entity = new BranchMaster();
		entity.setBranch_code(branch_code);
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"branch_code"});
		return entity;
	}
	public  static boolean check(String branch_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		BranchMaster entity = new BranchMaster();
		entity.setBranch_id(branch_id);
		return check(entity);
	}
	
	public  static boolean check(BranchMaster entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}
	
	public  static boolean checkBCodeName(String branch_code,String name) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		BranchMaster entity = new BranchMaster();
		entity.setBranch_code(branch_code);
		entity.setBranch_name(name);
		return checkBCodeName(entity);
	}
	
	public  static boolean checkCode(String branch_code) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		BranchMaster entity = new BranchMaster();
		entity.setBranch_code(branch_code);
		return checkCode(entity);
	}
	
	public  static boolean checkName(String branch_name) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		BranchMaster entity = new BranchMaster();
		entity.setBranch_name(branch_name);
		return checkName(entity);
	}
	
	public  static boolean checkBCodeName(BranchMaster entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"branch_code","branch_name"});
		conn.close();
		return check;
	}
	public  static boolean checkCode(BranchMaster entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"branch_code"});
		conn.close();
		return check;
	}
	
	public  static boolean checkName(BranchMaster entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"branch_name"});
		conn.close();
		return check;
	}
	
	public static BranchMaster select(BranchMaster entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static BranchMaster  selectcheckName(String id ,String name) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
	BranchMaster entity = new BranchMaster();

	entity.setBranch_id(id);
	entity.setBranch_name(name);
	return selectcheckName(entity);
	}
	public static BranchMaster selectcheckName(BranchMaster entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
	Connection conn = DBPool.getConnection();
	DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"branch_name","branch_id"});
	conn.close();
	return entity;
	
	}
	
	public static BranchMaster  selectcheckCode(String id ,String code) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		BranchMaster entity = new BranchMaster();
	
		entity.setBranch_id(id);
		entity.setBranch_code(code);
		return selectcheckCode(entity);
	}
	public static BranchMaster selectcheckCode(BranchMaster entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"branch_code","branch_id"});
		conn.close();
		return entity;
		
	}
	
	public static BranchMaster  selectcheckCodeName(String id ,String code ,String name) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		BranchMaster entity = new BranchMaster();
	
		entity.setBranch_id(id);
		entity.setBranch_code(code);
		entity.setBranch_name(name);
		return selectcheckCodeName(entity);
	}
	public static BranchMaster selectcheckCodeName(BranchMaster entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"branch_name","branch_code","branch_id"});
		conn.close();
		return entity;
		
	}
	
	public static void insert(BranchMaster entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		
		entity.setBranch_id(DBUtility.genNumber(conn, tableName, "branch_id"));
		
		DBUtility.insertToDB(conn, tableName, entity);
		
		conn.close();
	}
	
	
	public static void update(BranchMaster entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		//DBUtility.updateToDB(conn, tableName, entity, new String[]{"branch_code","branch_name","update_by","update_date","branch_lane","branch_road","branch_addressnumber","branch_moo","branch_villege","branch_district","branch_prefecture","branch_province","branch_postalcode","branch_postalcode","branch_phonenumber",""}, keys);
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);

		conn.close();
		
		
	}
	
	public static List<BranchMaster> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("keyword")){
					sql += " AND (LOWER(branch_code) like'%" + str[1] + "%' " +  " OR LOWER(branch_name) like'%" + str[1] + "%')";
				} else {
					sql += " AND " + str[0] + "='" + str[1] + "' ";
				}
			}
		}
		sql += "  ORDER BY branch_code ASC ";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<BranchMaster> list = new ArrayList<BranchMaster>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					BranchMaster entity = new BranchMaster();
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
	public static List<String[]> branchDropdown() throws SQLException{
		String sql = "SELECT DISTINCT(branch_code) AS value, branch_name AS text  FROM " + tableName + " WHERE 1=1 ";
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
	public static void delete(BranchMaster entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	public static String selectBranch_name(String branch_id) throws SQLException{
		
		Connection conn = DBPool.getConnection();
		
		String sql = "SELECT branch_name AS cnt FROM " + tableName + " WHERE branch_code='"+branch_id+"' ";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		String cnt = "";
		while(rs.next()){
			cnt = DBUtility.getString("cnt", rs);
		}

		rs.close();
		st.close();
		conn.close();
		return cnt;
	}
	


}