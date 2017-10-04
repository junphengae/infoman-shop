package com.bmp.web.service.bean;

import java.sql.Timestamp;

public class setServiceRepairBean {
	private String id = "";
	private String repair_type = "";
	private String driven_by = "";
	private String driven_contact = "";
	private String fuel_level = "";
	private String mile = "";
	private String problem = "";
	private String note = "";
	private Timestamp due_date = null;
	private String create_by = "";
	private Timestamp create_date = null;
	private String update_by = "";
	private Timestamp update_date = null;
	private String flag = "";
	private String branch_code ="";
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getRepair_type() {
		return repair_type;
	}
	public void setRepair_type(String repair_type) {
		this.repair_type = repair_type;
	}
	public String getDriven_by() {
		return driven_by;
	}
	public void setDriven_by(String driven_by) {
		this.driven_by = driven_by;
	}
	public String getDriven_contact() {
		return driven_contact;
	}
	public void setDriven_contact(String driven_contact) {
		this.driven_contact = driven_contact;
	}
	public String getFuel_level() {
		return fuel_level;
	}
	public void setFuel_level(String fuel_level) {
		this.fuel_level = fuel_level;
	}
	public String getMile() {
		return mile;
	}
	public void setMile(String mile) {
		this.mile = mile;
	}
	public String getProblem() {
		return problem;
	}
	public void setProblem(String problem) {
		this.problem = problem;
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
	}
	public Timestamp getDue_date() {
		return due_date;
	}
	public void setDue_date(Timestamp due_date) {
		this.due_date = due_date;
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
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
	public String getBranch_code() {
		return branch_code;
	}
	public void setBranch_code(String branch_code) {
		this.branch_code = branch_code;
	}
	
	
	
	
	
}
