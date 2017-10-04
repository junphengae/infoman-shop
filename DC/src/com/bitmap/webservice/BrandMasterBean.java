package com.bitmap.webservice;

import java.util.Date;

public class BrandMasterBean {
	
	private String order_by_id = "";//primary keys 
	private String brand_id = "";
	private String brand_name = "";
	private String create_by = "";
	private Date create_date = null;
	private String update_by = "";
	private Date update_date = null;
	
	
	
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
	
	

}
