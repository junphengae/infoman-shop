package com.bmp.web.service.bean;

import java.sql.Timestamp;

public class setPartCategoriesSubBean {
	
	private String sub_cat_id 	= "";
	private String cat_id 		= "";
	private String group_id 	= "";
	private String sub_cat_name_short 	= "";
	private String sub_cat_name_th 		= "";
	private String create_by 	= "";
	private Timestamp create_date 	= null;
	private String update_by 	= "";
	private Timestamp update_date 	= null;
	
	public String getSub_cat_id() {
		return sub_cat_id;
	}
	public void setSub_cat_id(String sub_cat_id) {
		this.sub_cat_id = sub_cat_id;
	}
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
	public String getSub_cat_name_short() {
		return sub_cat_name_short;
	}
	public void setSub_cat_name_short(String sub_cat_name_short) {
		this.sub_cat_name_short = sub_cat_name_short;
	}
	public String getSub_cat_name_th() {
		return sub_cat_name_th;
	}
	public void setSub_cat_name_th(String sub_cat_name_th) {
		this.sub_cat_name_th = sub_cat_name_th;
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
