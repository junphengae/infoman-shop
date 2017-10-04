package com.bmp.customer.service.bean;

import java.sql.Timestamp;

public class ServicePartDetailBean {
	private String id					= "";
	private String number				= "";
	private String pn					= "";
	private String qty					= "0";
	private String cutoff_qty			= "0";
	private String discount				= "";
	private String cash_discount		= "";
	private String discount_flag		= "";
	private String price				= "";
	private String vat					= "";
	private String total_vat			= "";
	private String total_price			= "";
	private String spd_dis_total_before	= "";
	private String spd_dis_total		= "";
	private String spd_net_price		= "";
	private String create_by			= "";
	private Timestamp create_date		= null;
	private String update_by			= "";
	private Timestamp update_date		= null;
	
	String UIDescription = "";
	String UILocation = "";
	String UICus_name = "";
	String UIStatus = "";
	String UIss_flag = "";
	
	String UIforewordname = "";
	String UIcus_surname = "";
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getNumber() {
		return number;
	}
	public void setNumber(String number) {
		this.number = number;
	}
	public String getPn() {
		return pn;
	}
	public void setPn(String pn) {
		this.pn = pn;
	}
	public String getQty() {
		return qty;
	}
	public void setQty(String qty) {
		this.qty = qty;
	}
	public String getCutoff_qty() {
		return cutoff_qty;
	}
	public void setCutoff_qty(String cutoff_qty) {
		this.cutoff_qty = cutoff_qty;
	}
	public String getDiscount() {
		return discount;
	}
	public void setDiscount(String discount) {
		this.discount = discount;
	}
	public String getDiscount_flag() {
		return discount_flag;
	}
	public void setDiscount_flag(String discount_flag) {
		this.discount_flag = discount_flag;
	}
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
	}
	public String getVat() {
		return vat;
	}
	public void setVat(String vat) {
		this.vat = vat;
	}
	public String getTotal_vat() {
		return total_vat;
	}
	public void setTotal_vat(String total_vat) {
		this.total_vat = total_vat;
	}
	public String getTotal_price() {
		return total_price;
	}
	public void setTotal_price(String total_price) {
		this.total_price = total_price;
	}
	public String getSpd_dis_total_before() {
		return spd_dis_total_before;
	}
	public void setSpd_dis_total_before(String spd_dis_total_before) {
		this.spd_dis_total_before = spd_dis_total_before;
	}
	public String getSpd_dis_total() {
		return spd_dis_total;
	}
	public void setSpd_dis_total(String spd_dis_total) {
		this.spd_dis_total = spd_dis_total;
	}
	public String getSpd_net_price() {
		return spd_net_price;
	}
	public void setSpd_net_price(String spd_net_price) {
		this.spd_net_price = spd_net_price;
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
	public String getCash_discount() {
		return cash_discount;
	}
	public void setCash_discount(String cash_discount) {
		this.cash_discount = cash_discount;
	}
	public String getUIDescription() {
		return UIDescription;
	}
	public void setUIDescription(String uIDescription) {
		UIDescription = uIDescription;
	}
	public String getUILocation() {
		return UILocation;
	}
	public void setUILocation(String uILocation) {
		UILocation = uILocation;
	}
	public String getUICus_name() {
		return UICus_name;
	}
	public void setUICus_name(String uICus_name) {
		UICus_name = uICus_name;
	}
	public String getUIStatus() {
		return UIStatus;
	}
	public void setUIStatus(String uIStatus) {
		UIStatus = uIStatus;
	}
	public String getUIss_flag() {
		return UIss_flag;
	}
	public void setUIss_flag(String uIss_flag) {
		UIss_flag = uIss_flag;
	}
	public String getUIforewordname() {
		return UIforewordname;
	}
	public void setUIforewordname(String uIforewordname) {
		UIforewordname = uIforewordname;
	}
	public String getUIcus_surname() {
		return UIcus_surname;
	}
	public void setUIcus_surname(String uIcus_surname) {
		UIcus_surname = uIcus_surname;
	}
	
	
	
}
