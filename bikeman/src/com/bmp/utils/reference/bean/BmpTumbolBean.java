package com.bmp.utils.reference.bean;

import java.sql.Timestamp;

public class BmpTumbolBean {

	private int bmp_tum_id = 0;
	private String bmp_tum_provnc_gov_cd	="";
	private String bmp_tum_provnc_oic_cd	="";
	private String bmp_tum_ampr_cd	="";
	private String bmp_tum_cd	="";
	private String bmp_tum_sname	="";
	private String bmp_tum_name	="";
	private String bmp_tum_eng_name	="";
	private int bmp_tum_order	= 0;
	private String bmp_tum_del_flag	="";
	private String cre_by		="";
	private Timestamp cre_date	= null;
	
	
	
	public String getBmp_tum_sname() {
		return bmp_tum_sname;
	}
	public void setBmp_tum_sname(String bmp_tum_sname) {
		this.bmp_tum_sname = bmp_tum_sname;
	}
	public int getBmp_tum_id() {
		return bmp_tum_id;
	}
	public void setBmp_tum_id(int bmp_tum_id) {
		this.bmp_tum_id = bmp_tum_id;
	}
	public String getBmp_tum_provnc_gov_cd() {
		return bmp_tum_provnc_gov_cd;
	}
	public void setBmp_tum_provnc_gov_cd(String bmp_tum_provnc_gov_cd) {
		this.bmp_tum_provnc_gov_cd = bmp_tum_provnc_gov_cd;
	}
	public String getBmp_tum_provnc_oic_cd() {
		return bmp_tum_provnc_oic_cd;
	}
	public void setBmp_tum_provnc_oic_cd(String bmp_tum_provnc_oic_cd) {
		this.bmp_tum_provnc_oic_cd = bmp_tum_provnc_oic_cd;
	}
	public String getBmp_tum_ampr_cd() {
		return bmp_tum_ampr_cd;
	}
	public void setBmp_tum_ampr_cd(String bmp_tum_ampr_cd) {
		this.bmp_tum_ampr_cd = bmp_tum_ampr_cd;
	}
	public String getBmp_tum_cd() {
		return bmp_tum_cd;
	}
	public void setBmp_tum_cd(String bmp_tum_cd) {
		this.bmp_tum_cd = bmp_tum_cd;
	}
	public String getBmp_tum_name() {
		return bmp_tum_name;
	}
	public void setBmp_tum_name(String bmp_tum_name) {
		this.bmp_tum_name = bmp_tum_name;
	}
	public String getBmp_tum_eng_name() {
		return bmp_tum_eng_name;
	}
	public void setBmp_tum_eng_name(String bmp_tum_eng_name) {
		this.bmp_tum_eng_name = bmp_tum_eng_name;
	}
	public int getBmp_tum_order() {
		return bmp_tum_order;
	}
	public void setBmp_tum_order(int bmp_tum_order) {
		this.bmp_tum_order = bmp_tum_order;
	}
	public String getBmp_tum_del_flag() {
		return bmp_tum_del_flag;
	}
	public void setBmp_tum_del_flag(String bmp_tum_del_flag) {
		this.bmp_tum_del_flag = bmp_tum_del_flag;
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
