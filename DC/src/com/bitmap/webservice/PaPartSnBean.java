package com.bitmap.webservice;

import java.util.Date;

public class PaPartSnBean {
	
	private String sn = "";
	private String pn = "";
	private String flag = "";
	private String sale_order = "";
	private String create_by = "";
	private Date create_date = null;
	private String update_by = "";
	private Date update_date = null;
	
	
	public String getSn() {
		return sn;
	}
	public void setSn(String sn) {
		this.sn = sn;
	}
	public String getPn() {
		return pn;
	}
	public void setPn(String pn) {
		this.pn = pn;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
	public String getSale_order() {
		return sale_order;
	}
	public void setSale_order(String sale_order) {
		this.sale_order = sale_order;
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
