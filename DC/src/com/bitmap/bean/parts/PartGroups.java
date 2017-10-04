package com.bitmap.bean.parts;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.bitmap.bean.hr.Department;
import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;

public class PartGroups {
	public static String tableName = "pa_groups";
	public static String[] keys = {"group_id"};
	public static String[] fieldNames = {"group_id", "group_name_en", "group_name_th", "create_by", "create_date"};
	
	 String group_id = "";
	 String group_name_en = "";
	 String group_name_th = "";
	 String create_by = "";
	 Timestamp create_date = null;
	 String update_by = "";
	 Timestamp update_date = null;

	public String getGroup_id() {
		return group_id;
	}

	public void setGroup_id(String group_id) {
		this.group_id = group_id;
	}

	public String getGroup_name_en() {
		return group_name_en;
	}

	public void setGroup_name_en(String group_name_en) {
		this.group_name_en = group_name_en;
	}

	public String getGroup_name_th() {
		return group_name_th;
	}

	public void setGroup_name_th(String group_name_th) {
		this.group_name_th = group_name_th;
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

	public  static boolean check(PartGroups entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}
	public  static boolean check(String group_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PartGroups entity = new PartGroups();
		entity.setGroup_id(group_id);
		return check(entity);
	}
	
	public  static boolean checkName(String name_th ,String name_en) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PartGroups entity = new PartGroups();
		entity.setGroup_name_en(name_en);
		entity.setGroup_name_th(name_th);
		return checkName(entity);
	}
	public  static boolean checkName(PartGroups entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"group_name_th" ,"group_name_en"});
		conn.close();
		return check;
	}
	
	public  static boolean checkName_th(String name_th ) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PartGroups entity = new PartGroups();
		entity.setGroup_name_th(name_th);
		return checkName_th(entity);
	}
	public  static boolean checkName_th(PartGroups entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"group_name_th"});
		conn.close();
		return check;
	}
	
	public  static boolean checkName_en(String name_en) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PartGroups entity = new PartGroups();
		entity.setGroup_name_en(name_en);
		return checkName_en(entity);
	}
	public  static boolean checkName_en(PartGroups entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"group_name_en"});
		conn.close();
		return check;
	}
	
	public static PartGroups  selectcheckName(String group_id ,String name_th ,String name_en) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PartGroups entity = new PartGroups();
		entity.setGroup_id(group_id);
		entity.setGroup_name_th(name_th);
		entity.setGroup_name_en(name_en);
		return selectcheckName(entity);
	}
	public static PartGroups selectcheckName(PartGroups entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"group_id","group_name_th","group_name_en"});
		conn.close();
		return entity;
		
	}
	public static PartGroups  selectcheckName_th(String group_id ,String name_th ) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PartGroups entity = new PartGroups();
		entity.setGroup_id(group_id);
		entity.setGroup_name_th(name_th);
		return selectcheckName_th(entity);
	}
	public static PartGroups selectcheckName_th(PartGroups entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"group_id","group_name_th"});
		conn.close();
		return entity;
		
	}	
	
	public static PartGroups  selectcheckName_en(String group_id ,String name_en) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PartGroups entity = new PartGroups();
		entity.setGroup_id(group_id);
		entity.setGroup_name_en(name_en);
		return selectcheckName_en(entity);
	}
	public static PartGroups selectcheckName_en(PartGroups entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"group_id","group_name_en"});
		conn.close();
		return entity;
		
	}
	
	public static List<PartGroups> selectList() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		List<PartGroups> list = new ArrayList<PartGroups>();
		String sql = "SELECT * FROM " + tableName;
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			PartGroups entity = new PartGroups();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static void insert(PartGroups entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setUpdate_by(entity.getCreate_by());
		entity.setGroup_id(DBUtility.genNumber(conn, tableName, "group_id"));
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static PartGroups select(String group_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PartGroups entity = new PartGroups();
		entity.setGroup_id(group_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static void select(PartGroups entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public static PartGroups select(String group_id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PartGroups entity = new PartGroups();
		entity.setGroup_id(group_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		return entity;
	}
	
	public static List<String[]> ddl_th() throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		List<String[]> list = DBUtility.getDropDownListData(conn,tableName,"group_id","group_name_th","group_id");
		conn.close();
		return list;
	}
	
	public static List<String[]> ddl_th_notFG() throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		String sql = "SELECT * FROM " + tableName + " WHERE group_id <> '1' ORDER BY (group_id*1) ASC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<String[]> list = new ArrayList<String[]>();
		while (rs.next()){
			String[] data = {rs.getString("group_id"),rs.getString("group_name_th")};
			list.add(data);
		}
		
		conn.close();
		return list;
	}
	/**
	 * get group for use in material search
	 * @return
	 * @throws SQLException
	 */
	public static List<String[]> ddl_matPartGroups() throws SQLException{
		Connection conn = DBPool.getConnection();
		List<String[]> list = new ArrayList<String[]>();
		String sql = "SELECT group_id as value,group_name_th as text FROM "+tableName+" WHERE GROUP_ID != 'FG' ORDER BY group_id";		
		PreparedStatement ps = conn.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			HashMap<String,Object> entity = DBUtility.getEntity(rs);
			String value = (String) entity.get("value");
			String text = entity.get("text").toString();
			String[] data = {value,text};
			list.add(data);
		}
		rs.close();
		ps.close();
		conn.close();
		return list;
	}
	
	
	
	/**
	 * get group for use in formular search
	 * @return
	 * @throws SQLException
	 */
	public static List<String[]> ddl_formularPartGroups() throws SQLException{
		Connection conn = DBPool.getConnection();
		List<String[]> list = new ArrayList<String[]>();
		String sql = "SELECT group_id as value,group_name_th as text FROM "+tableName+" WHERE GROUP_ID != 'MT' AND GROUP_ID!='PK' ORDER BY group_id";		
		PreparedStatement ps = conn.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			HashMap<String,Object> entity = DBUtility.getEntity(rs);
			String value = (String) entity.get("value");
			String text = entity.get("text").toString();
			String[] data = {value,text};
			list.add(data);
		}
		rs.close();
		ps.close();
		conn.close();
		return list;
	}
	
	
	public static List<String[]> ddl_en() throws SQLException{
		Connection conn = DBPool.getConnection();
		List<String[]> list = DBUtility.getDropDownListData(conn, tableName, "group_id", "group_name_en", "group_id");
		conn.close();
		return list;
	}
	
   
	public static List<String[]> ddl_en_th() throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<String[]> list = new ArrayList<String[]>();
		while (rs.next()){
			String[] data = {rs.getString("group_id"),rs.getString("group_name_th")+" "+rs.getString("group_name_en")};
			list.add(data);
		}
		
		conn.close();
		return list;
	}
	
	public static void update(PartGroups entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_by(entity.getCreate_by());
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"group_name_en","group_name_th","update_by","update_date"}, keys);
		conn.close();
	}
	
	
	

}
