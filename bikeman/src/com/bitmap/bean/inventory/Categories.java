package com.bitmap.bean.inventory;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;

public class Categories {
	public static String tableName = "inv_categories";

	String cat_id = "";
	String group_id = "";
	String cat_name_short = "";
	String cat_name_th = "";
	String create_by = "";
	Timestamp create_date = null;
	
	private Group UIGroup = new Group();
	public Group getUIGroup() {return UIGroup;}
	public void setUIGroup(Group uIGroup) {UIGroup = uIGroup;}

	public static void insert(Categories entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCat_id(genID(entity.getGroup_id(), conn));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	private static String genID(String group_id, Connection conn) throws NumberFormatException, SQLException{
		String sql = "SELECT cat_id FROM " + tableName + " WHERE group_id='" + group_id + "' ORDER BY (cat_id*1) DESC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		String id = "1";
		if (rs.next()) {
			id = (Integer.parseInt(rs.getString("cat_id")) + 1) + "";
		}
		rs.close();
		st.close();
		return id;
	}
	
	public static Categories select(String cat_id,String group_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Categories entity = new Categories();
		entity.setCat_id(cat_id);
		entity.setGroup_id(group_id);
		select(entity);
		return entity;
	}
	
	public static Categories select(String cat_id,String group_id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Categories entity = new Categories();
		entity.setCat_id(cat_id);
		entity.setGroup_id(group_id);
		select(entity, conn);
		return entity;
	}
	
	public static Categories select(Categories entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"cat_id","group_id"});
		conn.close();
		return entity;
	}
	
	public static Categories select(Categories entity, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"cat_id","group_id"});
		entity.setUIGroup(Group.select(entity.getGroup_id(),conn));
		return entity;
	}
	
	public static List<Categories> selectList(String group_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE group_id ='" + group_id + "' ORDER BY (cat_id*1)";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Categories> list = new ArrayList<Categories>();
		////System.out.println(sql);
		while (rs.next()) {
			Categories entity = new Categories();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
   	/**
	 * whan : shop
	 * <br>
	 * get group that have at branch
	 * @param group_id
	 * @param branch_id
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<Categories> selectList(String group_id,String branch_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "select distinct(inv_menu.cat_id),inv_categories.cat_name_th " +
					" from inv_menu,inv_menu_branch,inv_categories where " +
					" inv_menu.mat_code = inv_menu_branch.mat_code " +
					" AND inv_menu_branch.branch_id = '" + branch_id + "' " +
					" AND inv_categories.group_id = '" + group_id + "' AND inv_menu.cat_id = inv_categories.cat_id  ORDER BY (inv_categories.cat_id*1) ASC";
		
		////System.out.println(sql);
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Categories> list = new ArrayList<Categories>();
		while (rs.next()) {
			Categories entity = new Categories();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<String[]> ddl_th(String group_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE group_id ='" + group_id + "' ORDER BY (cat_id*1)";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<String[]> list = new ArrayList<String[]>();
		while (rs.next()) {
			Categories entity = new Categories();
			DBUtility.bindResultSet(entity, rs);
			list.add(new String[]{entity.getCat_id(),entity.getCat_name_th()});
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static void update(Categories entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"cat_name_short","cat_name_th","create_by","create_date"}, new String[]{"cat_id","group_id"});
		conn.close();
	}
	
	public static boolean checkShortName(Categories entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		boolean pass = false;
		Connection conn = DBPool.getConnection();
		pass = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"cat_name_short","group_id"});
		conn.close();
		return pass;
	}
	
	public static boolean checkShortNameForEdit(Categories entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		boolean pass = false;
		String sql = "SELECT * FROM " + tableName + " WHERE cat_id!='" + entity.getCat_id() + "' AND cat_name_short='" + entity.cat_name_short + "' AND group_id='"+entity.getGroup_id()+"'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);			
		pass = rs.next();
		rs.close();
		st.close();
		conn.close();
		return pass;
	}
	
	public String getCat_id() {
		return cat_id;
	}
	public void setCat_id(String cat_id) {
		this.cat_id = cat_id;
	}
	public String getGroup_id() {
		return group_id;
	}
	public void setGroup_id(String group_id) {
		this.group_id = group_id;
	}
	public String getCat_name_short() {
		return cat_name_short;
	}
	public void setCat_name_short(String cat_name_short) {
		this.cat_name_short = cat_name_short;
	}
	public String getCat_name_th() {
		return cat_name_th;
	}
	public void setCat_name_th(String cat_name_th) {
		this.cat_name_th = cat_name_th;
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
}