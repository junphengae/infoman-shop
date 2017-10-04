package com.bitmap.report.job.bean;

import java.sql.Timestamp;

public class servicePartBean {
	String job_id = "";
	String pn = "";
	String part_name = "";
	String draw = "";
	String discount = "";
	String price = "" ;
	String total_vat ="";
	String dis_total ="";
	String cash_discount ="";

	String net_price = "";
	String status = "";
	String qty_sum ="";
	String cutoff_sum="";
	String count="";
	String spd_dis_total = "";
	Timestamp job_close_date=null;
	
	public String getCash_discount() {
		return cash_discount;
	}
	public void setCash_discount(String cash_discount) {
		this.cash_discount = cash_discount;
	}
	public String getSpd_dis_total() {
		return spd_dis_total;
	}
	public void setSpd_dis_total(String spd_dis_total) {
		this.spd_dis_total = spd_dis_total;
	}
	public String getDis_total() {
		return dis_total;
	}
	public void setDis_total(String dis_total) {
		this.dis_total = dis_total;
	}
	public Timestamp getJob_close_date() {
		return job_close_date;
	}
	public void setJob_close_date(Timestamp job_close_date) {
		this.job_close_date = job_close_date;
	}
	public String getCount() {
		return count;
	}
	public void setCount(String count) {
		this.count = count;
	}
	public String getCutoff_sum() {
		return cutoff_sum;
	}
	public void setCutoff_sum(String cutoff_sum) {
		this.cutoff_sum = cutoff_sum;
	}
	public String getQty_sum() {
		return qty_sum;
	}
	public void setQty_sum(String qty_sum) {
		this.qty_sum = qty_sum;
	}
	Timestamp create_date = null;
	
	
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
	public String getPn() {
		return pn;
	}
	public void setPn(String pn) {
		this.pn = pn;
	}
	public String getPart_name() {
		return part_name;
	}
	public void setPart_name(String part_name) {
		this.part_name = part_name;
	}
	public String getDraw() {
		return draw;
	}
	public void setDraw(String draw) {
		this.draw = draw;
	}
	public String getDiscount() {
		return discount;
	}
	public void setDiscount(String discount) {
		this.discount = discount;
	}
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
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

}
