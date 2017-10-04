package com.bmp.web.service.bean;

import java.sql.Timestamp;

public class setBranchStockBean {
	
	private String  pn			= "";
	private String  branch_id	= "";
	private String  stock		= "";
	private Timestamp  	update_date	= null;
	private String 	update_by	= "";
	private String	 create_by 	= "";
	private Timestamp 	create_date = null;
	
	public String getPn() {
		return pn;
	}
	public void setPn(String pn) {
		this.pn = pn;
	}
	public String getBranch_id() {
		return branch_id;
	}
	public void setBranch_id(String branch_id) {
		this.branch_id = branch_id;
	}
	public String getStock() {
		return stock;
	}
	public void setStock(String stock) {
		this.stock = stock;
	}

	public String getUpdate_by() {
		return update_by;
	}
	public void setUpdate_by(String update_by) {
		this.update_by = update_by;
	}
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}
	public Timestamp getUpdate_date() {
		return update_date;
	}
	public void setUpdate_date(Timestamp update_date) {
		this.update_date = update_date;
	}
	public Timestamp getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}

	
	
	
}
