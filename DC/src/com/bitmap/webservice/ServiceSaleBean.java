package com.bitmap.webservice;

import java.util.Date;

/**
 * @author nutjung
 *
 */
public class ServiceSaleBean {
	
	private String id = "";
	private String service_type = "";
	private String cus_id = "";
	private String cus_name = "";
	private String cus_surname = "";
	
	private String addressnumber ="";
	private String villege ="";
	private String district  ="";
	private String prefecture  ="";
	private String province  ="";
	private String postalcode  ="";
	private String phonenumber  ="";
	private String moo ="";
	private String road  ="";
	private String soi  ="";
	
	private String v_id = "";//Vehicle ID
	private String v_plate = "";//Vehicle License Plate
	private String v_plate_province = "";//Vehicle License Plate
	private String total = "0";
	private String vat = "0";
	private String discount = "0";
	private String total_amount = "0";
	
	private String received ="0";
	private String total_change  ="0";
	
	private String flage ="";
	private String tax_id="";
	private String bill_id="";
	
	private String pay = "0";
	private String status = "";
	private String flag_pay = "";
	private Date duedate = null;
	private String create_by = "";
	private Date create_date = null;
	private String update_by = "";
	private Date update_date = null;
	private String brand_id = "";
	private String model_id = "";
	private Date job_close_date = null;
	private String branch_code = "";
	
	private String forewordname ="";
	
	
	public String getFlage() {
		return flage;
	}
	public void setFlage(String flage) {
		this.flage = flage;
	}
	public String getTax_id() {
		return tax_id;
	}
	public void setTax_id(String tax_id) {
		this.tax_id = tax_id;
	}
	public String getBill_id() {
		return bill_id;
	}
	public void setBill_id(String bill_id) {
		this.bill_id = bill_id;
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
	
	public String getAddressnumber() {
		return addressnumber;
	}
	public void setAddressnumber(String addressnumber) {
		this.addressnumber = addressnumber;
	}
	public String getVillege() {
		return villege;
	}
	public void setVillege(String villege) {
		this.villege = villege;
	}
	public String getDistrict() {
		return district;
	}
	public void setDistrict(String district) {
		this.district = district;
	}
	public String getPrefecture() {
		return prefecture;
	}
	public void setPrefecture(String prefecture) {
		this.prefecture = prefecture;
	}
	public String getProvince() {
		return province;
	}
	public void setProvince(String province) {
		this.province = province;
	}
	public String getPostalcode() {
		return postalcode;
	}
	public void setPostalcode(String postalcode) {
		this.postalcode = postalcode;
	}
	public String getPhonenumber() {
		return phonenumber;
	}
	public void setPhonenumber(String phonenumber) {
		this.phonenumber = phonenumber;
	}
	public String getMoo() {
		return moo;
	}
	public void setMoo(String moo) {
		this.moo = moo;
	}
	public String getRoad() {
		return road;
	}
	public void setRoad(String road) {
		this.road = road;
	}
	public String getSoi() {
		return soi;
	}
	public void setSoi(String soi) {
		this.soi = soi;
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
	public String getTotal() {
		return total;
	}
	public void setTotal(String total) {
		this.total = total;
	}
	public String getVat() {
		return vat;
	}
	public void setVat(String vat) {
		this.vat = vat;
	}
	public String getDiscount() {
		return discount;
	}
	public void setDiscount(String discount) {
		this.discount = discount;
	}
	public String getTotal_amount() {
		return total_amount;
	}
	public void setTotal_amount(String total_amount) {
		this.total_amount = total_amount;
	}
		
	public String getReceived() {
		return received;
	}
	public void setReceived(String received) {
		this.received = received;
	}
	public String getTotal_change() {
		return total_change;
	}
	public void setTotal_change(String total_change) {
		this.total_change = total_change;
	}
	public String getPay() {
		return pay;
	}
	public void setPay(String pay) {
		this.pay = pay;
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
	public Date getDuedate() {
		return duedate;
	}
	public void setDuedate(Date duedate) {
		this.duedate = duedate;
	}
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}
	public Date getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Date create_date) {
		this.create_date = create_date;
	}
	public String getUpdate_by() {
		return update_by;
	}
	public void setUpdate_by(String update_by) {
		this.update_by = update_by;
	}
	public Date getUpdate_date() {
		return update_date;
	}
	public void setUpdate_date(Date update_date) {
		this.update_date = update_date;
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
	public Date getJob_close_date() {
		return job_close_date;
	}
	public void setJob_close_date(Date job_close_date) {
		this.job_close_date = job_close_date;
	}
	public String getBranch_code() {
		return branch_code;
	}
	public void setBranch_code(String branch_code) {
		this.branch_code = branch_code;
	}
	public String getForewordname() {
		return forewordname;
	}
	public void setForewordname(String forewordname) {
		this.forewordname = forewordname;
	}
	
	

}
