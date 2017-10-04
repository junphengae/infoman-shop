package com.bitmap.bean.inventory;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;

public class WithdrawType {
	public static String tableName = "inv_withdraw_type";
	public static String[] keys = {"des_unit"};
	
	String des_unit = "";
	String type_name = "";
	String create_by = "";
	Timestamp create_date = null;
	
	public static List<String[]> dropdown() throws SQLException{
		Connection conn = DBPool.getConnection();
		List<String[]> list = DBUtility.getDropDownList(conn, tableName, "des_unit", "type_name", "des_unit");
		conn.close();
		return list;
	}
	
	public static boolean checkName(WithdrawType entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		boolean pass = false;
		Connection conn = DBPool.getConnection();
		pass = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"type_name"});
		conn.close();
		return pass;
	}
	
	public static String getName(String des_unit) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		WithdrawType entity = new WithdrawType();
		entity.setDes_unit(des_unit);
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"des_unit"});
		conn.close();
		return entity.getType_name();
	}
	
	public static WithdrawType select(WithdrawType entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"des_unit"});
		conn.close();
		return entity;
	}
	
	public static WithdrawType insert(WithdrawType entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setDes_unit(DBUtility.genNumber(conn, tableName,"des_unit"));
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
		return entity;
	}
	
	public static WithdrawType update(WithdrawType entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.updateToDB(conn, tableName, entity,new String[]{"type_name"},new String[]{"des_unit"});
		conn.close();
		return entity;
	}
	
	public String getDes_unit() {
		return des_unit;
	}

	public void setDes_unit(String des_unit) {
		this.des_unit = des_unit;
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
	public Timestamp getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}
}
