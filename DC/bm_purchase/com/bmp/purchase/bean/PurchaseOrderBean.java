package com.bmp.purchase.bean;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class PurchaseOrderBean {
	private String po 				="0000001";
	private String reference_po		="";
	private String vendor_id		="";
	private String approve_by		="";
	private Timestamp approve_date	=null;
	private Date delivery_date	=null;
	private Timestamp receive_date	=null;
	private String status			="";
	private String note				="";
	private String gross_amount		="0.00";
	private String discount			="0.00";
	private String discount_pc		="0.00";
	private String net_amount		="0.00";
	private String vat				="0";
	private String vat_amount		="0.00";
	private String grand_total		="0.00";
	private String update_by		="";
	private Timestamp update_date	=null;
	private Timestamp create_date	=null;
	private String create_by		="";
	
	
	
	private VendorBean UIVendor = new VendorBean();
	public VendorBean getUIVendor() {return UIVendor;}
	public void setUIVendor(VendorBean UIVendor) {this.UIVendor = UIVendor;}
	
	private List<PurchaseRequestBean> UIOrderList = new ArrayList<PurchaseRequestBean>();
	public List<PurchaseRequestBean> getUIOrderList() {return UIOrderList;}
	public void setUIOrderList(List<PurchaseRequestBean> uIOrderList) {UIOrderList = uIOrderList;}
	
	
	
	
	
	
	public String getPo() {
		return po;
	}
	public void setPo(String po) {
		this.po = po;
	}
	public String getReference_po() {
		return reference_po;
	}
	public void setReference_po(String reference_po) {
		this.reference_po = reference_po;
	}
	public String getVendor_id() {
		return vendor_id;
	}
	public void setVendor_id(String vendor_id) {
		this.vendor_id = vendor_id;
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
	public Date getDelivery_date() {
		return delivery_date;
	}
	public void setDelivery_date(Date delivery_date) {
		this.delivery_date = delivery_date;
	}
	public Timestamp getReceive_date() {
		return receive_date;
	}
	public void setReceive_date(Timestamp receive_date) {
		this.receive_date = receive_date;
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
	public String getGross_amount() {
		return gross_amount;
	}
	public void setGross_amount(String gross_amount) {
		this.gross_amount = gross_amount;
	}
	public String getDiscount() {
		return discount;
	}
	public void setDiscount(String discount) {
		this.discount = discount;
	}
	public String getDiscount_pc() {
		return discount_pc;
	}
	public void setDiscount_pc(String discount_pc) {
		this.discount_pc = discount_pc;
	}
	public String getNet_amount() {
		return net_amount;
	}
	public void setNet_amount(String net_amount) {
		this.net_amount = net_amount;
	}
	public String getVat() {
		return vat;
	}
	public void setVat(String vat) {
		this.vat = vat;
	}
	public String getVat_amount() {
		return vat_amount;
	}
	public void setVat_amount(String vat_amount) {
		this.vat_amount = vat_amount;
	}
	public String getGrand_total() {
		return grand_total;
	}
	public void setGrand_total(String grand_total) {
		this.grand_total = grand_total;
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
	public Timestamp getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}
	
	
	

}
