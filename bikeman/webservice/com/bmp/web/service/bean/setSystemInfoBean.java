package com.bmp.web.service.bean;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bmp.web.service.transaction.SystemInfoTS;

public class setSystemInfoBean {
	private String id				= "";
	private String branch_code		= "";
	private String branch_order		= "";
	private String branch_name_en	= "";
	private String name				= "";
	private String address			= "";
	private String create_by		= "";
	private Timestamp create_date	= null;
	private String update_by		= "";
	private Timestamp update_date	= null;
	private String addressnumber	= "";
	private String villege			= "";
	private String district			= "";
	private String prefecture		= "";
	private String province			= "";
	private String postalcode		= "";
	private String phonenumber		= "";
	private Timestamp keyin_code	= null;
	private String moo				= "";
	private String road				= "";
	private String soi				= "";
	private String tax_id			= "";
	private String fax				= "";
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getBranch_code() {
		return branch_code;
	}
	public void setBranch_code(String branch_code) {
		this.branch_code = branch_code;
	}
	public String getBranch_order() {
		return branch_order;
	}
	public void setBranch_order(String branch_order) {
		this.branch_order = branch_order;
	}
	public String getBranch_name_en() {
		return branch_name_en;
	}
	public void setBranch_name_en(String branch_name_en) {
		this.branch_name_en = branch_name_en;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
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
	public Timestamp getKeyin_code() {
		return keyin_code;
	}
	public void setKeyin_code(Timestamp keyin_code) {
		this.keyin_code = keyin_code;
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
	public String getTax_id() {
		return tax_id;
	}
	public void setTax_id(String tax_id) {
		this.tax_id = tax_id;
	}
	public String getFax() {
		return fax;
	}
	public void setFax(String fax) {
		this.fax = fax;
	}
	
	public void load(setSystemInfoBean entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, SystemInfoTS.tableName, entity, SystemInfoTS.keys);
		conn.close();
	} 
	public void select(Connection conn,setSystemInfoBean entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{	
		try {
			
			DBUtility.getEntityFromDB(conn, SystemInfoTS.tableName, entity,SystemInfoTS.keys);
			
		} catch (Exception e) {
			if (conn != null) {
				conn.close();
			}	
		}
	}

}
