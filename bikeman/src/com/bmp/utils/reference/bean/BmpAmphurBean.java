package com.bmp.utils.reference.bean;

import java.sql.Timestamp;

public class BmpAmphurBean {

	private int bmp_ampr_id = 0;
	private String bmp_ampr_provnc_gov_cd	="";
	private String bmp_ampr_provnc_oic_cd 	="";
	private String bmp_ampr_cd		="";
	private String bmp_ampr_name		="";
	private String bmp_ampr_sname		="";
	private String bmp_ampr_pc	="";
	private String bmp_ampr_del_flag		="";
	private String cre_by		="";
	private Timestamp cre_date	= null;
	
	
	public int getBmp_ampr_id() {
		return bmp_ampr_id;
	}
	public void setBmp_ampr_id(int bmp_ampr_id) {
		this.bmp_ampr_id = bmp_ampr_id;
	}
	public String getBmp_ampr_provnc_gov_cd() {
		return bmp_ampr_provnc_gov_cd;
	}
	public void setBmp_ampr_provnc_gov_cd(String bmp_ampr_provnc_gov_cd) {
		this.bmp_ampr_provnc_gov_cd = bmp_ampr_provnc_gov_cd;
	}
	public String getBmp_ampr_provnc_oic_cd() {
		return bmp_ampr_provnc_oic_cd;
	}
	public void setBmp_ampr_provnc_oic_cd(String bmp_ampr_provnc_oic_cd) {
		this.bmp_ampr_provnc_oic_cd = bmp_ampr_provnc_oic_cd;
	}
	public String getBmp_ampr_cd() {
		return bmp_ampr_cd;
	}
	public void setBmp_ampr_cd(String bmp_ampr_cd) {
		this.bmp_ampr_cd = bmp_ampr_cd;
	}
	public String getBmp_ampr_name() {
		return bmp_ampr_name;
	}
	public void setBmp_ampr_name(String bmp_ampr_name) {
		this.bmp_ampr_name = bmp_ampr_name;
	}
	public String getBmp_ampr_sname() {
		return bmp_ampr_sname;
	}
	public void setBmp_ampr_sname(String bmp_ampr_sname) {
		this.bmp_ampr_sname = bmp_ampr_sname;
	}
	public String getBmp_ampr_pc() {
		return bmp_ampr_pc;
	}
	public void setBmp_ampr_pc(String bmp_ampr_pc) {
		this.bmp_ampr_pc = bmp_ampr_pc;
	}
	public String getBmp_ampr_del_flag() {
		return bmp_ampr_del_flag;
	}
	public void setBmp_ampr_del_flag(String bmp_ampr_del_flag) {
		this.bmp_ampr_del_flag = bmp_ampr_del_flag;
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
