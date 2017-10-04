package com.bmp.sale.bean;

import java.sql.Timestamp;
import java.util.Map;

import com.bitmap.bean.parts.PartMaster;

public class SaleOderServicePartDetailBean {
	private String status			= "";
	private String branch_code		= "";
	private String number			= "";
	private String id				= "";
	private String pn				= "";
	private String price			= "";
	private String note				= "";
	private String update_by		= "";
	private String qty				= "";
	private String discount_flag	= "";
	private String discount			= "";
	private String cutoff_qty		= "";
	private String create_by		= "";
	private Timestamp update_date	= null;
	private Timestamp create_date	= null;
	private Timestamp add_pr_date	= null;
	
	private Map UImap = null;
	
	private PartMaster UIPartMaster = new PartMaster();
	public PartMaster getUIPartMaster() {return UIPartMaster;}
	public void setUIPartMaster(PartMaster uIPartMaster) {UIPartMaster = uIPartMaster;}
	
	
	
	public Map getUImap() {
		return UImap;
	}
	public void setUImap(Map uImap) {
		UImap = uImap;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getBranch_code() {
		return branch_code;
	}
	public void setBranch_code(String branch_code) {
		this.branch_code = branch_code;
	}
	public String getNumber() {
		return number;
	}
	public void setNumber(String number) {
		this.number = number;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPn() {
		return pn;
	}
	public void setPn(String pn) {
		this.pn = pn;
	}
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
	}
	public String getUpdate_by() {
		return update_by;
	}
	public void setUpdate_by(String update_by) {
		this.update_by = update_by;
	}
	public String getQty() {
		return qty;
	}
	public void setQty(String qty) {
		this.qty = qty;
	}
	public String getDiscount_flag() {
		return discount_flag;
	}
	public void setDiscount_flag(String discount_flag) {
		this.discount_flag = discount_flag;
	}
	public String getDiscount() {
		return discount;
	}
	public void setDiscount(String discount) {
		this.discount = discount;
	}
	public String getCutoff_qty() {
		return cutoff_qty;
	}
	public void setCutoff_qty(String cutoff_qty) {
		this.cutoff_qty = cutoff_qty;
	}
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}
	public Timestamp getUpdate_date() {
		return update_date;
	}
	public void setUpdate_date(Timestamp update_date) {
		this.update_date = update_date;
	}
	public Timestamp getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}
	public Timestamp getAdd_pr_date() {
		return add_pr_date;
	}
	public void setAdd_pr_date(Timestamp add_pr_date) {
		this.add_pr_date = add_pr_date;
	}
	
	
}
