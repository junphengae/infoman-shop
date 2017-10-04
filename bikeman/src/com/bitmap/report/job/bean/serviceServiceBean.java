package com.bitmap.report.job.bean;

import java.sql.Timestamp;

public class serviceServiceBean {

	String job_id = "";
	String labor = "";
	String labor_name = "";
	String rate = "";
	String discount = "";
	String cash_discount = "";
	String total_vat ="";
	String srd_dis_total ="";
	String srd_net_price ="";
	String net_price = "";
	String status = "";
	Timestamp create_date = null;
	Timestamp job_close_date = null;
	
	
	
	
	public String getSrd_dis_total() {
		return srd_dis_total;
	}
	public void setSrd_dis_total(String srd_dis_total) {
		this.srd_dis_total = srd_dis_total;
	}
	public String getSrd_net_price() {
		return srd_net_price;
	}
	public void setSrd_net_price(String srd_net_price) {
		this.srd_net_price = srd_net_price;
	}
	public Timestamp getJob_close_date() {
		return job_close_date;
	}
	public void setJob_close_date(Timestamp job_close_date) {
		this.job_close_date = job_close_date;
	}
	public Timestamp getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}
	public String getJob_id() {
		return job_id;
	}
	public void setJob_id(String job_id) {
		this.job_id = job_id;
	}
	public String getLabor() {
		return labor;
	}
	public void setLabor(String labor) {
		this.labor = labor;
	}
	public String getLabor_name() {
		return labor_name;
	}
	public void setLabor_name(String labor_name) {
		this.labor_name = labor_name;
	}
	public String getRate() {
		return rate;
	}
	public void setRate(String rate) {
		this.rate = rate;
	}
	public String getDiscount() {
		return discount;
	}
	public void setDiscount(String discount) {
		this.discount = discount;
	}
	public String getTotal_vat() {
		return total_vat;
	}
	public void setTotal_vat(String total_vat) {
		this.total_vat = total_vat;
	}
	public String getNet_price() {
		return net_price;
	}
	public void setNet_price(String net_price) {
		this.net_price = net_price;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getCash_discount() {
		return cash_discount;
	}
	public void setCash_discount(String cash_discount) {
		this.cash_discount = cash_discount;
	}
	
	
}
