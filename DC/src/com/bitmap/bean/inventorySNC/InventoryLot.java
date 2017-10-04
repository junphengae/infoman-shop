package com.bitmap.bean.inventorySNC;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;

public class InventoryLot {
	public static String tableName = "inv_lot";
	private static String[] keys = {"lot_no"};
	
	String mat_code = "";
	String lot_no = "";
	String po = "";
	String invoice = "";
	String lot_qty = "";
	String lot_price = "";
	String lot_status = "";
	Date lot_expire = null;
	String vendor_id = "";
	String vendor_mat_code = "";
	String vendor_lot_no = "";
	String icp_data = "";
	String note = "";
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	private InventoryLotControl lot_control;
	
	public static boolean select(InventoryLot entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		boolean check = false;
		Connection conn = DBPool.getConnection();
		check = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"mat_code","lot_no"});
		entity.setUILot_control(InventoryLotControl.selectActive(entity.getLot_no(), conn));
		conn.close();
		return check;
	}
	
	public static List<InventoryLot> selectList(String mat_code) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE mat_code='" + mat_code + "' ORDER BY (lot_no*1) ASC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryLot> list = new ArrayList<InventoryLot>();
		while (rs.next()) {
			InventoryLot entity = new InventoryLot();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<InventoryLot> selectActiveList(String mat_code) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE mat_code='" + mat_code + "' AND lot_status='A' ORDER BY (lot_no*1) ASC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryLot> list = new ArrayList<InventoryLot>();
		while (rs.next()) {
			InventoryLot entity = new InventoryLot();
			DBUtility.bindResultSet(entity, rs);
			entity.setUILot_control(InventoryLotControl.selectActive(entity.getLot_no(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static InventoryLot checkFifo(InventoryLot entity) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE mat_code='" + entity.getMat_code() + "' AND lot_status='A' ORDER BY (lot_no*1) ASC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		InventoryLot lot = new InventoryLot();
		
		String lot_no = "";
		if (rs.next()) {
			lot_no = DBUtility.getString("lot_no", rs);
			if (lot_no.equalsIgnoreCase(entity.getLot_no())) {
				DBUtility.bindResultSet(lot, rs);
				lot.setUILot_control(InventoryLotControl.selectActive(lot_no, conn));
			}
		}
		
		rs.close();
		st.close();
		conn.close();
		return lot;
	}
	
	public static void insert(InventoryLot entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		entity.setLot_no(genLotNo(entity, conn));
		entity.setLot_status("A");
		DBUtility.insertToDB(conn, tableName, entity);
		InventoryLotControl.initLot(entity, conn);
		conn.close();
	}
	
	private static String genLotNo(InventoryLot entity, Connection conn) throws SQLException{
		String sql = "SELECT lot_no FROM " + tableName + " ORDER BY (lot_no*1) DESC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String lot_no = "1";
		if (rs.next()) {
			String temp = DBUtility.getString("lot_no", rs);
			lot_no = (Integer.parseInt(temp) + 1) + "";
		}
		
		rs.close();
		st.close();
		return lot_no;
	}
	
	public static void updateIStatus(Connection conn,InventoryLotControl lotControl) throws IllegalAccessException, InvocationTargetException, SQLException{
		InventoryLot entity = new InventoryLot();
		entity.setLot_no(lotControl.getLot_no());	
		entity.setLot_status("I");
		entity.setUpdate_by(lotControl.getUpdate_by());
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"lot_status","update_by","update_date"}, new String[]{"lot_no"});
	}

	
	public static Double totalInlet(String po,String mat_code) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		String sql = "SELECT sum(lot_qty) as qty FROM " + tableName + " WHERE po = '" + po  + "' AND mat_code = '" + mat_code + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		Double val = 0.0;
		while (rs.next()){
			val = DBUtility.getDecimal("qty", rs);
		}
		rs.close();
		st.close();
		conn.close();
		return val;
	}
	public String getMat_code() {
		return mat_code;
	}

	public void setMat_code(String mat_code) {
		this.mat_code = mat_code;
	}

	public String getLot_no() {
		return lot_no;
	}

	public void setLot_no(String lot_no) {
		this.lot_no = lot_no;
	}

	public String getPo() {
		return po;
	}

	public void setPo(String po) {
		this.po = po;
	}

	public String getInvoice() {
		return invoice;
	}

	public void setInvoice(String invoice) {
		this.invoice = invoice;
	}

	public String getLot_qty() {
		return lot_qty;
	}

	public void setLot_qty(String lot_qty) {
		this.lot_qty = lot_qty;
	}

	public String getLot_price() {
		return lot_price;
	}

	public void setLot_price(String lot_price) {
		this.lot_price = lot_price;
	}

	public String getLot_status() {
		return lot_status;
	}

	public void setLot_status(String lot_status) {
		this.lot_status = lot_status;
	}

	public Date getLot_expire() {
		return lot_expire;
	}

	public void setLot_expire(Date lot_expire) {
		this.lot_expire = lot_expire;
	}

	public String getVendor_id() {
		return vendor_id;
	}

	public void setVendor_id(String vendor_id) {
		this.vendor_id = vendor_id;
	}

	public String getVendor_mat_code() {
		return vendor_mat_code;
	}

	public void setVendor_mat_code(String vendor_mat_code) {
		this.vendor_mat_code = vendor_mat_code;
	}

	public String getVendor_lot_no() {
		return vendor_lot_no;
	}

	public void setVendor_lot_no(String vendor_lot_no) {
		this.vendor_lot_no = vendor_lot_no;
	}

	public String getIcp_data() {
		return icp_data;
	}

	public void setIcp_data(String icp_data) {
		this.icp_data = icp_data;
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

	public InventoryLotControl getUILot_control() {
		return lot_control;
	}

	public void setUILot_control(InventoryLotControl lot_control) {
		this.lot_control = lot_control;
	}
}