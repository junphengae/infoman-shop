package com.bitmap.security;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;

public class SecurityUserRole {
	public static String tableName = "security_user_role";
	private static String[] keys = {"user_id","role_id"};
	
	String user_id = "";
	String role_id = "";
	
    public static String admin(String id) throws SQLException{
		
		String sql = "SELECT COUNT( * ) AS count FROM "+tableName+" WHERE user_id='"+id+"'  AND   role_id='sp_admin'";
		//System.out.println("sql:"+sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		String sum = "0";
		if (rs.next()) {
			String count = DBUtility.getString("count", rs);
			sum = count;
		}
		rs.close();
		st.close();
		return sum;
		
	}
    
	public static void addRole(SecurityUserRole entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static void delRole(SecurityUserRole entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getRole_id() {
		return role_id;
	}
	public void setRole_id(String role_id) {
		this.role_id = role_id;
	}
}
