package com.bitmap.bean.service;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;

public class MechanicHold {
	public static final String tableName = "sv_repair_labor_mechanic_hold";
	private static String[] keys = {"num","id","number","labor_id","mechanic_id"};
	String num = "1";
	String id = "";
	String number = "";
	String labor_id = "";
	String mechanic_id = "";
	Timestamp hold_start = null;
	Timestamp hold_stop = null;
	String hold_start_by = "";
	String hold_stop_by = "";
	String hold_type = "";
	
	public static void hold(MechanicHold entity) throws NumberFormatException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		//genNum(entity,conn);
		entity.setNum(DBUtility.genNumberFromDB(conn, tableName, entity, new String[]{"id","number","labor_id","mechanic_id"}, "num"));
		entity.setHold_start(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static void unhold(MechanicHold entity) throws SQLException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		entity.setHold_stop(DBUtility.getDBCurrentDateTime());
		entity.setNum(checkNum(entity.getId(), entity.getLabor_id(), entity.getMechanic_id(), entity.getNumber(), conn));
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"hold_stop_by","hold_stop"}, keys);
		conn.close();
	}
	
	private static void genNum(MechanicHold entity, Connection conn) throws NumberFormatException, SQLException{
		String sql = "SELECT num FROM " + tableName + " WHERE id='" + entity.getId() + "' AND labor_id='" + entity.getLabor_id() + " AND number='" + entity.getNumber() + "' ORDER BY (num*1) DESC";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		if (rs.next()) {
			entity.setNum((Integer.parseInt(rs.getString(1)) + 1) + "");
		}
		rs.close();
	}
	
	private static String checkNum(String id, String labor_id, String mechanic_id, String number, Connection conn) throws SQLException{
		String num = "-";
		String sql = "SELECT num FROM " + tableName + " WHERE id='" + id + "' AND labor_id='" + labor_id + "' AND mechanic_id='" + mechanic_id + "' AND number='" + number + "' AND hold_stop IS NULL";
		
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		if (rs.next()) {
			num = rs.getString(1);
		}
		rs.close();
		return num;
	}
	
	public static void delete(String id, String labor_id, String number) throws SQLException, IllegalAccessException, InvocationTargetException{
		MechanicHold entity = new MechanicHold();
		entity.setId(id);
		entity.setLabor_id(labor_id);
		entity.setNumber(number);
		
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, new String[]{"id","labor_id","number"});
		conn.close();
	}
	
	public String getNum() {
		return num;
	}
	public void setNum(String num) {
		this.num = num;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getNumber() {
		return number;
	}
	public void setNumber(String number) {
		this.number = number;
	}
	public String getLabor_id() {
		return labor_id;
	}
	public void setLabor_id(String labor_id) {
		this.labor_id = labor_id;
	}
	public String getMechanic_id() {
		return mechanic_id;
	}
	public void setMechanic_id(String mechanic_id) {
		this.mechanic_id = mechanic_id;
	}
	public Timestamp getHold_start() {
		return hold_start;
	}
	public void setHold_start(Timestamp hold_start) {
		this.hold_start = hold_start;
	}
	public Timestamp getHold_stop() {
		return hold_stop;
	}
	public void setHold_stop(Timestamp hold_stop) {
		this.hold_stop = hold_stop;
	}
	public String getHold_start_by() {
		return hold_start_by;
	}
	public void setHold_start_by(String hold_start_by) {
		this.hold_start_by = hold_start_by;
	}
	public String getHold_stop_by() {
		return hold_stop_by;
	}
	public void setHold_stop_by(String hold_stop_by) {
		this.hold_stop_by = hold_stop_by;
	}
	public String getHold_type() {
		return hold_type;
	}
	public void setHold_type(String hold_type) {
		this.hold_type = hold_type;
	}
}