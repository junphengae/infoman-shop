package com.bitmap.webservice;

import java.util.Date;

public class ServiceRepairConditionBean {
	
	private String id = "";
	private String con_number = "";
	private String con_name = "";
	private String con_detail = "";
	private String create_by = "";
	private Date create_date = null;
	private String update_by = "";
	private Date update_date = null;
	private String branch_code = "";
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getCon_number() {
		return con_number;
	}
	public void setCon_number(String con_number) {
		this.con_number = con_number;
	}
	public String getCon_name() {
		return con_name;
	}
	public void setCon_name(String con_name) {
		this.con_name = con_name;
	}
	public String getCon_detail() {
		return con_detail;
	}
	public void setCon_detail(String con_detail) {
		this.con_detail = con_detail;
	}
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}
	public Date getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Date create_date) {
		this.create_date = create_date;
	}
	public String getUpdate_by() {
		return update_by;
	}
	public void setUpdate_by(String update_by) {
		this.update_by = update_by;
	}
	public Date getUpdate_date() {
		return update_date;
	}
	public void setUpdate_date(Date update_date) {
		this.update_date = update_date;
	}
	public String getBranch_code() {
		return branch_code;
	}
	public void setBranch_code(String branch_code) {
		this.branch_code = branch_code;
	}
	
	

}
