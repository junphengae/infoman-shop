package com.bitmap.webservice;

import java.sql.Timestamp;
import java.util.Date;

public class WebServiceUpdateBean {
	
	private Timestamp sync_date = null;
	private String table_name = "";
	private String status ="";
	
	public Timestamp getSync_date() {
		return sync_date;
	}
	public void setSync_date(Timestamp sync_date) {
		this.sync_date = sync_date;
	}
	public String getTable_name() {
		return table_name;
	}
	public void setTable_name(String table_name) {
		this.table_name = table_name;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
	
	
}
