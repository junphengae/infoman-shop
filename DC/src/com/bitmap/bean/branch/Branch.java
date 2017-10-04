package com.bitmap.bean.branch;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;

import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;

public class Branch {
	
	public static String tableName = "system_info";
	public static String[] keys = {"id"};
	public static String[] fieldNames = {"id","branch_code", "branch_name_en", "branch_order", "name" , "addressnumber" ,"villege" ,"moo" ,"soi" ,"road","district","prefecture"
								,"province","postalcode","phonenumber","create_by","update_by","create_date","update_date","keyin_code","fax"};
	
	String id = "";
	String branch_code = "";
	String branch_name_en = "";
	String branch_order = "";
	String name = "";
	String addressnumber = "";
	String villege = "";
	String moo = "";
	String soi = "";
	String road = "";

	String district = "";
	String prefecture = "";
	String province = "";
	String postalcode = "";
	String phonenumber = "";
	String create_by = "";
	String update_by = "";
	Timestamp create_date = null;
	Timestamp update_date = null;
	Timestamp keyin_code = null;
	String fax ="";
	

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
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
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
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}
	public String getUpdate_by() {
		return update_by;
	}
	public void setUpdate_by(String update_by) {
		this.update_by = update_by;
	}
	public Timestamp getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}
	public Timestamp getUpdate_date() {
		return update_date;
	}
	public void setUpdate_date(Timestamp update_date) {
		this.update_date = update_date;
	}

	public Timestamp getKeyin_code() {
		return keyin_code;
	}

	public void setKeyin_code(Timestamp keyin_code) {
		this.keyin_code = keyin_code;
	}

	public String getDistrict() {
		return district;
	}
	public void setDistrict(String district) {
		this.district = district;
	}

	public String getMoo() {
		return moo;
	}
	public void setMoo(String moo) {
		this.moo = moo;
	}
	public String getSoi() {
		return soi;
	}
	public void setSoi(String soi) {
		this.soi = soi;
	}
	public String getRoad() {
		return road;
	}
	public void setRoad(String road) {
		this.road = road;
	}
	
	public String getFax() {
		return fax;
	}

	public void setFax(String fax) {
		this.fax = fax;
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
	public void load(Branch entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public void select(Connection conn,Branch entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		
		try {
			
			DBUtility.getEntityFromDB(conn, tableName, entity, keys);
			
		} catch (Exception e) {
			conn.close();
		}
		
		
	}
	
	public static Branch select(String id) throws IllegalArgumentException, IllegalAccessException, InvocationTargetException, SQLException{
		
		Branch entity = new Branch();
		entity.setId(id);
		return select1(entity);
		
	}
	
	public static Branch select1(Branch entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	
	public static Branch selectbranch_code(String branch_code) throws IllegalArgumentException, IllegalAccessException, InvocationTargetException, SQLException{
		
		Branch entity = new Branch();
		entity.setBranch_code(branch_code);
		return selectbranch_code(entity);		
	}
	
	public static Branch selectbranch_code(Branch entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity,new String[]{"branch_code"});
		conn.close();
		return entity;
	}
	
	public static void select(Branch entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		
		conn.close();
	}
	public static Branch select()throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Branch entity = new Branch();
		entity.setId("1");
		select(entity);
		return entity;
	}
	public static void insert(Branch entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		entity.setId("1");
		DBUtility.insertToDB(conn, tableName, entity);
		
		conn.close();
	}
	
	public static void update(Branch entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setKeyin_code(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"branch_code","keyin_code"}, keys);
		conn.close();
	}
	
	public  static boolean check(String branch_code) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Branch entity = new Branch();
		entity.setBranch_code(branch_code);
		return check(entity);
	}
	public  static boolean check(Branch entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity,new  String[]{"branch_code"});
		conn.close();
		return check;
	}
	
	
	
}
