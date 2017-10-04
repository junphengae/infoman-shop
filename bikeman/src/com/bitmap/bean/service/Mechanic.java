package com.bitmap.bean.service;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.bitmap.dbutils.DBUtility;

public class Mechanic {
	private String per_id = "";
	private String prefix = "";
	private String name = "";
	private String surname = "";
	private List<MechanicTimeLine> timeLine = new ArrayList<MechanicTimeLine>();
	
	public static List<MechanicTimeLine> mechanicTimeLine(String mechanic_id, Connection conn) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + RepairLaborMechanic.tableName + " WHERE mechanic_id ='" + mechanic_id + 
					 "' AND (status ='" + RepairLaborTime.STATUS_OPENED_JOB + 
					 "' OR status ='" + RepairLaborTime.STATUS_ACTIVATE + 
					 "' OR status='" + RepairLaborTime.STATUS_REJECT + 
					 "' OR status='" + RepairLaborTime.STATUS_HOLDPART + "') ORDER BY id";
		
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<MechanicTimeLine> list = new ArrayList<MechanicTimeLine>();
		while(rs.next()){
			MechanicTimeLine entity = new MechanicTimeLine();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		return list;
	}
	
	public String getPer_id() {
		return per_id;
	}
	public void setPer_id(String per_id) {
		this.per_id = per_id;
	}
	public String getPrefix() {
		return prefix;
	}
	public void setPrefix(String prefix) {
		this.prefix = prefix;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getSurname() {
		return surname;
	}
	public void setSurname(String surname) {
		this.surname = surname;
	}
	public List<MechanicTimeLine> getUITimeLine() {
		return timeLine;
	}
	public void setUITimeLine(List<MechanicTimeLine> timeLine) {
		this.timeLine = timeLine;
	}

	
}
