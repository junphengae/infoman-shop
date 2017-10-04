package com.bitmap.report.job.bean;

import java.sql.Timestamp;

public class serviceMiscellaneousBean {
	String job_id = "";
	String name = "";
	String qty = "";
	String price = "";
	String discount = "";
	String cash_discount = "";
	String total_vat ="";
	String sod_dis_total = "";
	String sod_net_price = "";
	String net_price = "";
	Timestamp create_date = null;
	String status = "";
	Timestamp job_close_date=null;
	
	
	public String getSod_dis_total() {
		return sod_dis_total;
	}
	public void setSod_dis_total(String sod_dis_total) {
		this.sod_dis_total = sod_dis_total;
	}
	public String getSod_net_price() {
		return sod_net_price;
	}
	public void setSod_net_price(String sod_net_price) {
		this.sod_net_price = sod_net_price;
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
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getQty() {
		return qty;
	}
	public void setQty(String qty) {
		this.qty = qty;
	}
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
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
