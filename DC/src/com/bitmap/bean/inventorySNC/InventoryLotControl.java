package com.bitmap.bean.inventorySNC;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;

import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;

public class InventoryLotControl {
	public static String tableName = "inv_lot_control";
	
	String lot_no = "";
	String lot_id = "";
	String lot_balance = "";
	String request_no = "";
	String request_type = "";
	String request_qty = "";
	String control_status = "";
	String request_by = "";
	Timestamp request_date = null;
	Timestamp create_date = DBUtility.getDBCurrentDateTime();
	String update_by = "";
	Timestamp update_date = null;
	
	public static void initLot(InventoryLot lot, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		InventoryLotControl entity = new InventoryLotControl();
		entity.setLot_no(lot.getLot_no());
		entity.setLot_balance(lot.getLot_qty());
		entity.setLot_id("1");
		entity.setControl_status("A");
		DBUtility.insertToDB(conn, tableName, new String[]{"lot_no","lot_id","lot_balance","control_status","create_date"}, entity);
	}
	
	public static InventoryLotControl select(String lot_no, Connection conn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		InventoryLotControl entity = new InventoryLotControl();
		String sql = "SELECT * FROM " + tableName + " WHERE lot_no='" + lot_no + "' ORDER BY (lot_id*1) ASC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		if (rs.next()) {
			DBUtility.bindResultSet(entity, rs);
		}
		rs.close();
		st.close();
		
		return entity;
	}
	
	public static InventoryLotControl selectActive(String lot_no, Connection conn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		InventoryLotControl entity = new InventoryLotControl();
		String sql = "SELECT * FROM " + tableName + " WHERE lot_no='" + lot_no + "' AND control_status='A'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		if (rs.next()) {
			DBUtility.bindResultSet(entity, rs);
		}
		rs.close();
		st.close();
		
		return entity;
	}
	
	
	public static void withdraw(InventoryLotControl entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		Double lotBalance = Double.parseDouble(entity.getLot_balance());
		Double reqQty = Double.parseDouble(entity.getRequest_qty());		
		if(lotBalance.equals(reqQty)){
			//update status i		
			entity.setRequest_qty(Money.moneyNoCommas(reqQty));			
			entity.setControl_status("I");
			entity.setRequest_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"request_type","request_qty","control_status","request_by","request_date","update_by"}, new String[]{"lot_id","lot_no"});
			InventoryLot.updateIStatus(conn, entity);
		}else{
			//update status c			
			entity.setControl_status("C");
			entity.setRequest_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"request_type","request_qty","control_status","request_by","request_date","update_by"}, new String[]{"lot_id","lot_no"});
			entity.setLot_balance(Money.moneyNoCommas(lotBalance-reqQty));
			insertAfterWithdraw(conn, entity);
		}
		conn.close();
	}
	
	public static void insertAfterWithdraw(Connection conn,InventoryLotControl entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		int id = Integer.parseInt(entity.getLot_id())+1;										
		entity.setLot_id(""+id);
		entity.setControl_status("A");
		DBUtility.insertToDB(conn, tableName, new String[]{"lot_no","lot_id","lot_balance","control_status","create_date"}, entity);
	}
	
	public String getLot_no() {
		return lot_no;
	}
	public void setLot_no(String lot_no) {
		this.lot_no = lot_no;
	}
	public String getLot_id() {
		return lot_id;
	}
	public void setLot_id(String lot_id) {
		this.lot_id = lot_id;
	}
	public String getLot_balance() {
		return lot_balance;
	}
	public void setLot_balance(String lot_balance) {
		this.lot_balance = lot_balance;
	}
	public String getRequest_no() {
		return request_no;
	}
	public void setRequest_no(String request_no) {
		this.request_no = request_no;
	}
	public String getRequest_type() {
		return request_type;
	}
	public void setRequest_type(String request_type) {
		this.request_type = request_type;
	}
	public String getRequest_qty() {
		return request_qty;
	}
	public void setRequest_qty(String request_qty) {
		this.request_qty = request_qty;
	}
	public String getControl_status() {
		return control_status;
	}
	public void setControl_status(String control_status) {
		this.control_status = control_status;
	}
	public String getRequest_by() {
		return request_by;
	}
	public void setRequest_by(String request_by) {
		this.request_by = request_by;
	}
	public Timestamp getRequest_date() {
		return request_date;
	}
	public void setRequest_date(Timestamp request_date) {
		this.request_date = request_date;
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
}