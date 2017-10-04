package com.bitmap.bean.service;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import com.bitmap.dbutils.DBUtility;

public class RepairLaborTerminateReject {
	public static final String tableName = "sv_repair_labor_terminate_reject";
	
	String num = "1";
	String id = "";
	String number = "";
	String labor_id = "";
	String history = "";
	String terminate_by = "";
	Timestamp terminate_date = null;
	
	public static void insert(RepairLaborTerminateReject entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		//genNum(entity, conn);
		entity.setId(DBUtility.genNumberFromDB(conn, tableName, entity, new String[]{"id","number","labor_id"}, "num"));
		entity.setTerminate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
	}
	
	public static void genNum(RepairLaborTerminateReject entity, Connection conn) throws NumberFormatException, SQLException{
		String sql = "SELECT num FROM " + tableName + " WHERE id='" + entity.getId() + "' AND labor_id='" + entity.getLabor_id() + "' ORDER BY num DESC";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		if (rs.next()) {
			entity.setId((Integer.parseInt(rs.getString(1)) + 1 ) + "");
		}
		rs.close();
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
	public String getHistory() {
		return history;
	}
	public void setHistory(String history) {
		this.history = history;
	}
	public String getTerminate_by() {
		return terminate_by;
	}
	public void setTerminate_by(String terminate_by) {
		this.terminate_by = terminate_by;
	}
	public Timestamp getTerminate_date() {
		return terminate_date;
	}
	public void setTerminate_date(Timestamp terminate_date) {
		this.terminate_date = terminate_date;
	}
}