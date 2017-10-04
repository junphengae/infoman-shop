package com.bitmap.report.job.bean;

import java.sql.Timestamp;


public class serviceInfoBean {
	String job_id = "";
	String perfix = "";
	String name = "";
	String surname = "";
	String plate = "";
	String plate_province = "";
	String status = "";
	String create_by = "";
	Timestamp create_date = null;
	Timestamp job_close = null;
	Timestamp job_close_datetime =null;
	Timestamp create_date_time = null;
	String time_complete = "";
	String brand = "";
	String model = "";
	String bill_id ="";
	//table service_repair
	String driven_by = "";
	String driven_contact="";
	String repair_type ="";
	String mile = "";
	Timestamp due_date = null;
	String problem = "";
	String note = "";
	String  total = ""; 
	String  vat   = "";
	String  discount  = "";
	String  total_amount = "";
	String  total_change = "";
	String  received = "";
	String  pay = "";
	
	
	public String getVat() {
		return vat;
	}
	public void setVat(String vat) {
		this.vat = vat;
	}
	public String getTotal_change() {
		return total_change;
	}
	public void setTotal_change(String total_change) {
		this.total_change = total_change;
	}
	public String getReceived() {
		return received;
	}
	public void setReceived(String received) {
		this.received = received;
	}
	public String getBill_id() {
		return bill_id;
	}
	public void setBill_id(String bill_id) {
		this.bill_id = bill_id;
	}
	public String getPerfix() {
		return perfix;
	}
	public void setPerfix(String perfix) {
		this.perfix = perfix;
	}
	public Timestamp getCreate_date_time() {
		return create_date_time;
	}
	public void setCreate_date_time(Timestamp create_date_time) {
		this.create_date_time = create_date_time;
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
	public String getRepair_type() {
		return repair_type;
	}
	public void setRepair_type(String repair_type) {
		this.repair_type = repair_type;
	}
	public String getMile() {
		return mile;
	}
	public void setMile(String mile) {
		this.mile = mile;
	}
	public Timestamp getDue_date() {
		return due_date;
	}
	public void setDue_date(Timestamp due_date) {
		this.due_date = due_date;
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
	public Timestamp getJob_close_datetime() {
		return job_close_datetime;
	}
	public void setJob_close_datetime(Timestamp job_close_datetime) {
		this.job_close_datetime = job_close_datetime;
	}
	public String getJob_id() {
		return job_id;
	}
	public void setJob_id(String job_id) {
		this.job_id = job_id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getSurname() {
		return surname;
	}
	public void setSurname(String surname) {
		this.surname = surname;
	}
	public String getPlate() {
		return plate;
	}
	public void setPlate(String plate) {
		this.plate = plate;
	}
	public String getPlate_province() {
		return plate_province;
	}
	public void setPlate_province(String plate_province) {
		this.plate_province = plate_province;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
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
	public Timestamp getJob_close() {
		return job_close;
	}
	public void setJob_close(Timestamp job_close) {
		this.job_close = job_close;
	}
	public String getTime_complete() {
		return time_complete;
	}
	public void setTime_complete(String time_complete) {
		this.time_complete = time_complete;
	}
	public String getTotal_amount() {
		return total_amount;
	}
	public void setTotal_amount(String total_amount) {
		this.total_amount = total_amount;
	}
	public String getTotal() {
		return total;
	}
	public void setTotal(String total) {
		this.total = total;
	}
	
	public String getDiscount() {
		return discount;
	}
	public void setDiscount(String discount) {
		this.discount = discount;
	}
	public String getPay() {
		return pay;
	}
	public void setPay(String pay) {
		this.pay = pay;
	}
	public String getBrand() {
		return brand;
	}
	public void setBrand(String brand) {
		this.brand = brand;
	}
	public String getModel() {
		return model;
	}
	public void setModel(String model) {
		this.model = model;
	}

}
