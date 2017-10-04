package com.bmp.purchase.bean;

import java.sql.Timestamp;

import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.bean.inventory.InventoryMasterVendor;
import com.bitmap.bean.parts.PartMaster;

public class PurchaseRequestBean {
	private String po				="";
	private String id				="";
	private Timestamp add_pr_date	=null;
	private String pr_type			="";
	private String mat_code			="";
	private String order_qty		="";
	private String order_price		="";
	private String vendor_id		="";
	private String status			="";
	private String note				="";
	private String create_by		="";
	private Timestamp create_date	=null;
	private String update_by		="";
	private Timestamp update_date	=null;
	private String approve_by		="";
	private Timestamp approve_date	=null;
	
	private String  UIrecive_qty	="";
	
	private InventoryMasterVendor UIInvVendor = new InventoryMasterVendor();
	public InventoryMasterVendor getUIInvVendor() {return UIInvVendor;}
	public void setUIInvVendor(InventoryMasterVendor uIInvVendor) {UIInvVendor = uIInvVendor;}

	private InventoryMaster UIInvMaster = new InventoryMaster();
	public InventoryMaster getUIInvMaster() {return UIInvMaster;}
	public void setUIInvMaster(InventoryMaster uIInvMaster) {UIInvMaster = uIInvMaster;}
	
	private PartMaster UIPartMaster = new PartMaster();
	public PartMaster getUIPartMaster() {return UIPartMaster;}
	public void setUIPartMaster(PartMaster uIPartMaster) {UIPartMaster = uIPartMaster;}
	
	private Double UIInletSum = 0.0;
	public  Double getUIInletSum() {return UIInletSum;}
	public void setUIInletSum(Double uIInletSum) {UIInletSum = uIInletSum;}
	
	public String getPo() {
		return po;
	}
	public void setPo(String po) {
		this.po = po;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public Timestamp getAdd_pr_date() {
		return add_pr_date;
	}
	public void setAdd_pr_date(Timestamp add_pr_date) {
		this.add_pr_date = add_pr_date;
	}
	public String getPr_type() {
		return pr_type;
	}
	public void setPr_type(String pr_type) {
		this.pr_type = pr_type;
	}
	public String getMat_code() {
		return mat_code;
	}
	public void setMat_code(String mat_code) {
		this.mat_code = mat_code;
	}
	public String getOrder_qty() {
		return order_qty;
	}
	public void setOrder_qty(String order_qty) {
		this.order_qty = order_qty;
	}
	public String getOrder_price() {
		return order_price;
	}
	public void setOrder_price(String order_price) {
		this.order_price = order_price;
	}
	public String getVendor_id() {
		return vendor_id;
	}
	public void setVendor_id(String vendor_id) {
		this.vendor_id = vendor_id;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
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
	public String getApprove_by() {
		return approve_by;
	}
	public void setApprove_by(String approve_by) {
		this.approve_by = approve_by;
	}
	public Timestamp getApprove_date() {
		return approve_date;
	}
	public void setApprove_date(Timestamp approve_date) {
		this.approve_date = approve_date;
	}
	public String getUIrecive_qty() {
		return UIrecive_qty;
	}
	public void setUIrecive_qty(String uIrecive_qty) {
		UIrecive_qty = uIrecive_qty;
	}
	
	
	

}
