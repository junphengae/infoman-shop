package com.bitmap.bean.parts;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import com.bitmap.bean.hr.Personal;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;

public class ServiceOutsourceDetail {
	public static String tableName = "service_outsource_detail";
	public static String[] keys = {"id","number"};
	public static String[] fieldNames = {};
	
	public static String STATUS_OPENED = "10";
	public static String STATUS_CLOSED = "11";
	public static String STATUS_CANCEL = "00";
	
	String id = "";
	String number = "";
	String name = "";
	String contact = "";
	String note = "";
	String send_by = "";
	Date send_date = null;
	Date due_date = null;
	String recipient = "";
	Date receive_date = null;
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	
	String UISend_by = "";
	String UIReceive_by = "";
	
	public static String status(String status){
		HashMap<String, String> map = new HashMap<String, String>();
		map.put(STATUS_OPENED, "Opened");
		map.put(STATUS_CLOSED, "Closed");
		map.put(STATUS_CANCEL, "Cancel");
		return map.get(status);
	}
	
	public static List<String[]> ddl_status_en(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{STATUS_OPENED,"Opened"});
		list.add(new String[]{STATUS_CLOSED,"Closed"});
		list.add(new String[]{STATUS_CANCEL,"Cancel"});
		return list;
	}
	
	public static void insert(ServiceOutsourceDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setNumber(DBUtility.genNumberFromDB(conn, tableName, entity, new String[]{"id"}, "number"));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static ServiceOutsourceDetail select(String id,String number) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		ServiceOutsourceDetail entity = new ServiceOutsourceDetail();
		entity.setId(id);
		entity.setNumber(number);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		Personal send = Personal.select(entity.getSend_by(), conn);
		entity.setUISend_by(send.getName() + " " + send.getSurname());
		Personal receive = Personal.select(entity.getRecipient(), conn);
		entity.setUIReceive_by(receive.getName() + " " + receive.getSurname());
		conn.close();
		return entity;
	}
	
	public static ServiceOutsourceDetail select(ServiceOutsourceDetail entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		Personal send = Personal.select(entity.getSend_by(), conn);
		entity.setUISend_by(send.getName() + " " + send.getSurname());
		Personal receive = Personal.select(entity.getRecipient(), conn);
		entity.setUIReceive_by(receive.getName() + " " + receive.getSurname());
		conn.close();
		return entity;
	}
	
	public static void update(ServiceOutsourceDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public static void update_detail(ServiceOutsourceDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"name","contact","note","send_by","send_date","due_date","update_by","update_date"}, keys);
		conn.close();
	}
	
	public static void update_receive(ServiceOutsourceDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"note","recipient","receive_date","update_by","update_date"}, keys);
		conn.close();
	}
	
	public static void delete(ServiceOutsourceDetail entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public static List<ServiceOutsourceDetail> list(String id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		List<ServiceOutsourceDetail> list = new ArrayList<ServiceOutsourceDetail>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE id='" + id + "' ORDER BY (number*1) ASC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			ServiceOutsourceDetail entity = new ServiceOutsourceDetail();
			DBUtility.bindResultSet(entity, rs);
			Personal send = Personal.select(entity.getSend_by(), conn);
			entity.setUISend_by(send.getName() + " " + send.getSurname());
			Personal receive = Personal.select(entity.getRecipient(), conn);
			entity.setUIReceive_by(receive.getName() + " " + receive.getSurname());
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}

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

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getContact() {
		return contact;
	}

	public void setContact(String contact) {
		this.contact = contact;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public String getSend_by() {
		return send_by;
	}

	public void setSend_by(String send_by) {
		this.send_by = send_by;
	}

	public Date getDue_date() {
		return due_date;
	}

	public void setDue_date(Date due_date) {
		this.due_date = due_date;
	}

	public String getRecipient() {
		return recipient;
	}

	public void setRecipient(String recipient) {
		this.recipient = recipient;
	}

	public Date getReceive_date() {
		return receive_date;
	}

	public void setReceive_date(Date receive_date) {
		this.receive_date = receive_date;
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

	public String getUISend_by() {
		return UISend_by;
	}

	public void setUISend_by(String uISend_by) {
		UISend_by = uISend_by;
	}

	public String getUIReceive_by() {
		return UIReceive_by;
	}

	public void setUIReceive_by(String uIReceive_by) {
		UIReceive_by = uIReceive_by;
	}

	public Date getSend_date() {
		return send_date;
	}

	public void setSend_date(Date send_date) {
		this.send_date = send_date;
	}

}