package com.bitmap.checkstock;

import java.sql.Timestamp;

public class checkStockBean {
	int check_id 		 = 0;
	int seq				 = 0;
	String pn 			 = "";
	int qty_old		 	 = 0;
	int qty_new		 	 = 0;
	int qty_diff		 = 0;
	String status		 = "";
	Timestamp check_date = null;
	String check_by		 = "";
	Timestamp close_date = null;
	String close_by		 = "";
	Timestamp update_date= null;
	String update_by 	 = "";
	
	public int getCheck_id() {
		return check_id;
	}
	public void setCheck_id(int check_id) {
		this.check_id = check_id;
	}
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getPn() {
		return pn;
	}
	public void setPn(String pn) {
		this.pn = pn;
	}
	public int getQty_old() {
		return qty_old;
	}
	public void setQty_old(int qty_old) {
		this.qty_old = qty_old;
	}
	public int getQty_new() {
		return qty_new;
	}
	public void setQty_new(int qty_new) {
		this.qty_new = qty_new;
	}
	public int getQty_diff() {
		return qty_diff;
	}
	public void setQty_diff(int qty_diff) {
		this.qty_diff = qty_diff;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Timestamp getCheck_date() {
		return check_date;
	}
	public void setCheck_date(Timestamp check_date) {
		this.check_date = check_date;
	}
	public String getCheck_by() {
		return check_by;
	}
	public void setCheck_by(String check_by) {
		this.check_by = check_by;
	}
	public Timestamp getClose_date() {
		return close_date;
	}
	public void setClose_date(Timestamp close_date) {
		this.close_date = close_date;
	}
	public String getClose_by() {
		return close_by;
	}
	public void setClose_by(String close_by) {
		this.close_by = close_by;
	}
	public Timestamp getUpdate_date() {
		return update_date;
	}
	public void setUpdate_date(Timestamp update_date) {
		this.update_date = update_date;
	}
	public String getUpdate_by() {
		return update_by;
	}
	public void setUpdate_by(String update_by) {
		this.update_by = update_by;
	}
	
	
}
