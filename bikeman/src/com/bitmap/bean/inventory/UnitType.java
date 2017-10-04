package com.bitmap.bean.inventory;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;

public class UnitType {
	public static String tableName = "inv_unit_type";
	public static String[] keys = {"id"};
	public static String[] fieldName = {"type_name","update_by","update_date"};
	
	String id = "";
	String type_name = "";
	String create_by = "";
	String update_by = "";
	Timestamp create_date = null;
	Timestamp update_date = null;
	
	
	public static List<String[]> ddl_th() throws SQLException{
		Connection conn = DBPool.getConnection();
		List<String[]> list = DBUtility.getDropDownListData(conn, tableName, "id", "type_name", "id");
		conn.close();
		return list;
	}
	
	
	
	public static void insert(UnitType entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setId(DBUtility.genNumber(conn, tableName, "id"));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static UnitType select(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		UnitType entity = new UnitType();
		entity.setId(id);
		return select(entity);
	}
	
	public static UnitType select(UnitType entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}

	
	public static String selectName(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
			Connection conn = null;
			UnitType entity = new UnitType();
			
		try {
			
			conn = DBPool.getConnection();
			entity.setId(id);
			DBUtility.getEntityFromDB(conn, tableName, entity, keys);
			conn.close();
			
		} catch (Exception e) {
			if (conn != null) {
				conn.close();
			}
		}
		
		return entity.getType_name();
	}
	
	public static void update(UnitType entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setId(entity.getId());
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldName, keys);
		conn.close();
	}
	
	public static List<String[]> selectList(String id_) throws NamingException, SQLException{
		List<String[]> l = new ArrayList<String[]>();
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 ";
		
		if (!id_.equalsIgnoreCase("")) {
			sql+=" AND id = '" + id_ + "'";
		}
		Connection conn = DBPool.getConnection();
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		while(rs.next()){
			String id = DBUtility.getString("id",rs);
			String name = DBUtility.getString("type_name",rs);
			String[] vals = {id,name};
			l.add(vals);
		}
		rs.close();
		st.close();
		conn.close();
		return l;
	}
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getType_name() {
		return type_name;
	}
	public void setType_name(String type_name) {
		this.type_name = type_name;
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
	
	

}
