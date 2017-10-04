package com.bmp.sale.bean;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.bitmap.bean.dc.SaleServicePartDetail;

public class SaleOderServiceBean {
	
	private String id				= "";
	private String service_type		= "";
	private String cus_id			= "";
	private String cus_name			= "";
	private String cus_surname		= "";
	private String v_id				= "";
	private String v_plate			= "";
	private String v_plate_province	= "";
	private String status			= "";
	private String flag_pay			= "";
	private Timestamp duedate		= null;
	private String create_by		= "";
	private Timestamp create_date	= null;
	private String update_by		= "";
	private Timestamp update_date	= null;
	private Timestamp job_close_date= null;
	private String vehicle_plate	= "";
	private String brand_id			= "";
	private String model_id			= "";
	private String time_complete	= "";
	private String note				= "";
	private String discount			= "";
	private String discount_pc		= "";
	private String gross_amount		= "";
	private String net_amount		= "";
	private String vat				= "";
	private String vat_amount		= "";
	private String grand_total 		= "";
	private Map UImap = null;
	private List<SaleOderServicePartDetailBean> UIOrderList = new ArrayList<SaleOderServicePartDetailBean>();
	public List<SaleOderServicePartDetailBean> getUIOrderList() {return UIOrderList;}
	public void setUIOrderList(List<SaleOderServicePartDetailBean> uIOrderList) {UIOrderList = uIOrderList;}
	
	
	public Map getUImap() {
		return UImap;
	}
	public void setUImap(Map uImap) {
		UImap = uImap;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getService_type() {
		return service_type;
	}
	public void setService_type(String service_type) {
		this.service_type = service_type;
	}
	public String getCus_id() {
		return cus_id;
	}
	public void setCus_id(String cus_id) {
		this.cus_id = cus_id;
	}
	public String getCus_name() {
		return cus_name;
	}
	public void setCus_name(String cus_name) {
		this.cus_name = cus_name;
	}
	public String getCus_surname() {
		return cus_surname;
	}
	public void setCus_surname(String cus_surname) {
		this.cus_surname = cus_surname;
	}
	public String getV_id() {
		return v_id;
	}
	public void setV_id(String v_id) {
		this.v_id = v_id;
	}
	public String getV_plate() {
		return v_plate;
	}
	public void setV_plate(String v_plate) {
		this.v_plate = v_plate;
	}
	public String getV_plate_province() {
		return v_plate_province;
	}
	public void setV_plate_province(String v_plate_province) {
		this.v_plate_province = v_plate_province;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getFlag_pay() {
		return flag_pay;
	}
	public void setFlag_pay(String flag_pay) {
		this.flag_pay = flag_pay;
	}
	public Timestamp getDuedate() {
		return duedate;
	}
	public void setDuedate(Timestamp duedate) {
		this.duedate = duedate;
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
	public Timestamp getJob_close_date() {
		return job_close_date;
	}
	public void setJob_close_date(Timestamp job_close_date) {
		this.job_close_date = job_close_date;
	}
	public String getVehicle_plate() {
		return vehicle_plate;
	}
	public void setVehicle_plate(String vehicle_plate) {
		this.vehicle_plate = vehicle_plate;
	}
	public String getBrand_id() {
		return brand_id;
	}
	public void setBrand_id(String brand_id) {
		this.brand_id = brand_id;
	}
	public String getModel_id() {
		return model_id;
	}
	public void setModel_id(String model_id) {
		this.model_id = model_id;
	}
	public String getTime_complete() {
		return time_complete;
	}
	public void setTime_complete(String time_complete) {
		this.time_complete = time_complete;
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
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
	public String getGross_amount() {
		return gross_amount;
	}
	public void setGross_amount(String gross_amount) {
		this.gross_amount = gross_amount;
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
	
	

}
