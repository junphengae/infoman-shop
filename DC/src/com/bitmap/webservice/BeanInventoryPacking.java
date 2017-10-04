package com.bitmap.webservice;


import java.util.Date;

public class BeanInventoryPacking {
	
	
	private String run_id = "";
	private String mat_code = "";
	private String description = "";
	private String unit = "";
	private String create_by = "";
	private String update_by = "";
	private Date create_date = null;
	private Date update_date = null;
	
	
	public String getRun_id() {
		return run_id;
	}
	public void setRun_id(String run_id) {
		this.run_id = run_id;
	}
	public String getMat_code() {
		return mat_code;
	}
	public void setMat_code(String mat_code) {
		this.mat_code = mat_code;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getUnit() {
		return unit;
	}
	public void setUnit(String unit) {
		this.unit = unit;
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
	public Date getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Date create_date) {
		this.create_date = create_date;
	}
	public Date getUpdate_date() {
		return update_date;
	}
	public void setUpdate_date(Date update_date) {
		this.update_date = update_date;
	}
	
	

	
	
	
}
