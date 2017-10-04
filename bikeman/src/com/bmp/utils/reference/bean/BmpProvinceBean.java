package com.bmp.utils.reference.bean;

import java.sql.Timestamp;

public class BmpProvinceBean {
	
	private int bmp_pt_id	= 0;
	private String bmp_pt_gov_cd	="";
	private String  bmp_pt_oic_cd	="";
	private String bmp_pt_name	="";
	private String bmp_pt_eng_name	="";
	private String bmp_pt_region	="";
	private int bmp_pt_order	= 0;
	private String bmp_pt_del_flag	="";
	private String cre_by	="";
	private Timestamp cre_date	= null;
	
	
	public int getBmp_pt_id() {
		return bmp_pt_id;
	}
	public void setBmp_pt_id(int bmp_pt_id) {
		this.bmp_pt_id = bmp_pt_id;
	}
	public String getBmp_pt_gov_cd() {
		return bmp_pt_gov_cd;
	}
	public void setBmp_pt_gov_cd(String bmp_pt_gov_cd) {
		this.bmp_pt_gov_cd = bmp_pt_gov_cd;
	}
	public String getBmp_pt_oic_cd() {
		return bmp_pt_oic_cd;
	}
	public void setBmp_pt_oic_cd(String bmp_pt_oic_cd) {
		this.bmp_pt_oic_cd = bmp_pt_oic_cd;
	}
	public String getBmp_pt_name() {
		return bmp_pt_name;
	}
	public void setBmp_pt_name(String bmp_pt_name) {
		this.bmp_pt_name = bmp_pt_name;
	}
	public String getBmp_pt_eng_name() {
		return bmp_pt_eng_name;
	}
	public void setBmp_pt_eng_name(String bmp_pt_eng_name) {
		this.bmp_pt_eng_name = bmp_pt_eng_name;
	}
	public String getBmp_pt_region() {
		return bmp_pt_region;
	}
	public void setBmp_pt_region(String bmp_pt_region) {
		this.bmp_pt_region = bmp_pt_region;
	}
	public int getBmp_pt_order() {
		return bmp_pt_order;
	}
	public void setBmp_pt_order(int bmp_pt_order) {
		this.bmp_pt_order = bmp_pt_order;
	}
	public String getBmp_pt_del_flag() {
		return bmp_pt_del_flag;
	}
	public void setBmp_pt_del_flag(String bmp_pt_del_flag) {
		this.bmp_pt_del_flag = bmp_pt_del_flag;
	}
	public String getCre_by() {
		return cre_by;
	}
	public void setCre_by(String cre_by) {
		this.cre_by = cre_by;
	}
	public Timestamp getCre_date() {
		return cre_date;
	}
	public void setCre_date(Timestamp cre_date) {
		this.cre_date = cre_date;
	}
	
	
	
	
			
	
}
