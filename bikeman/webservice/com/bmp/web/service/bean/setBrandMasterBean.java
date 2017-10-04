package com.bmp.web.service.bean;

import java.sql.Timestamp;


public class setBrandMasterBean {
	
	private String order_by_id = "";//primary keys 
	private String brand_id = "";
	private String brand_name = "";
	private String create_by = "";
	private String update_by = "";
	private Timestamp create_date = null;
	private Timestamp update_date = null;
	
	public String getOrder_by_id() {
		return order_by_id;
	}
	public void setOrder_by_id(String order_by_id) {
		this.order_by_id = order_by_id;
	}
	public String getBrand_id() {
		return brand_id;
	}
	public void setBrand_id(String brand_id) {
		this.brand_id = brand_id;
	}
	public String getBrand_name() {
		return brand_name;
	}
	public void setBrand_name(String brand_name) {
		this.brand_name = brand_name;
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
