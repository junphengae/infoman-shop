package com.bmp.web.service.bean;


import java.sql.Timestamp;

public class setPartCategoriesBean {
		

	private String cat_id 			= "";
	private String group_id 		= "";
	private String cat_name_short 	= "";
	private String cat_name_th 		= "";
	private String create_by 		= "";
	private Timestamp create_date 	= null;
	private String update_by 		= "";
	private Timestamp update_date 	= null;
	
	public String getCat_id() {
		return cat_id;
	}
	public void setCat_id(String cat_id) {
		this.cat_id = cat_id;
	}
	public String getGroup_id() {
		return group_id;
	}
	public void setGroup_id(String group_id) {
		this.group_id = group_id;
	}
	public String getCat_name_short() {
		return cat_name_short;
	}
	public void setCat_name_short(String cat_name_short) {
		this.cat_name_short = cat_name_short;
	}
	public String getCat_name_th() {
		return cat_name_th;
	}
	public void setCat_name_th(String cat_name_th) {
		this.cat_name_th = cat_name_th;
	}
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}
	public Timestamp getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}
	public String getUpdate_by() {
		return update_by;
	}
	public void setUpdate_by(String update_by) {
		this.update_by = update_by;
	}
	public Timestamp getUpdate_date() {
		return update_date;
	}
	public void setUpdate_date(Timestamp update_date) {
		this.update_date = update_date;
	}
	
	
	
}
