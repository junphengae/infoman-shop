package com.bmp.web.service.bean;

import java.sql.Timestamp;

public class setWebServiceReportBean {
	private String branch_id 	= "";
	private String table_sh		= "";
	private String table_dc		= "";
	private String count_sh		= "";
	private String count_dc		= "";
	private Timestamp sync_date	= null;
	
	public String getBranch_id() {
		return branch_id;
	}
	public void setBranch_id(String branch_id) {
		this.branch_id = branch_id;
	}
	public String getTable_sh() {
		return table_sh;
	}
	public void setTable_sh(String table_sh) {
		this.table_sh = table_sh;
	}
	public String getTable_dc() {
		return table_dc;
	}
	public void setTable_dc(String table_dc) {
		this.table_dc = table_dc;
	}
	public String getCount_sh() {
		return count_sh;
	}
	public void setCount_sh(String count_sh) {
		this.count_sh = count_sh;
	}
	public String getCount_dc() {
		return count_dc;
	}
	public void setCount_dc(String count_dc) {
		this.count_dc = count_dc;
	}
	public Timestamp getSync_date() {
		return sync_date;
	}
	public void setSync_date(Timestamp sync_date) {
		this.sync_date = sync_date;
	}
	
	

}
