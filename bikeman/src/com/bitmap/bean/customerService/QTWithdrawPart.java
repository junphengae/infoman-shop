package com.bitmap.bean.customerService;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.bean.parts.PartMaster;
import com.bitmap.bean.parts.PartSerial;

public class QTWithdrawPart {
	public static String tableName = "cs_withdraw_part";
	private static String[] keys = {"id"};
	
	String id = "";
	String labor_id = "";
	String labor_id_number = "";
	String number = "1";
	String pn = "";
	String sn = "";
	String qty = "1";
	String unit_price = "";
	String return_status = "0";
	String withdraw_by = "";
	String note = "";
	String create_by = "";
	String update_by = "";
	Timestamp create_date = null;
	Timestamp update_date = null;
	
	PartMaster pMaster = new PartMaster();
	
	public static List<QTWithdrawPart> selectList(String id, String labor_id, String labor_id_number) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE id='" + id + "' AND labor_id='" + labor_id + "' AND labor_id_number='" + labor_id_number + "' AND return_status ='0'";
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<QTWithdrawPart> list = new ArrayList<QTWithdrawPart>();
		while (rs.next()) {
			QTWithdrawPart entity = new QTWithdrawPart();
			DBUtility.bindResultSet(entity, rs);
			PartMaster pm = new PartMaster();
			pm.setPn(entity.getPn());
			entity.setUIpMaster(PartMaster.select(pm));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static void insert(QTWithdrawPart entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		genNumber(entity, conn);
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		
		PartMaster pMaster = new PartMaster();
		pMaster.setPn(entity.getPn());
		pMaster = PartMaster.select(pMaster);
		entity.setUIpMaster(pMaster);
		conn.close();
	}
	
	public static void withdraw_part(QTWithdrawPart entity) throws NumberFormatException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		//genNumber(entity, conn);
		
		PartMaster pMaster = new PartMaster();
		PartSerial pSerial = new PartSerial();
		
		String[] pn_sn = entity.getPn().split("--");
		if (pn_sn.length > 1) {
			entity.setPn(pn_sn[0]);
			entity.setSn(pn_sn[1]);
			entity.setQty("1");
			
			pSerial.setPn(entity.getPn());
			pSerial.setSn(entity.getSn());
			pSerial.setUpdate_by(entity.getCreate_by());
			PartSerial.withdraw(pSerial, conn);
		} else {
			pMaster.setPn(entity.getPn());
			pMaster = PartMaster.select(pMaster);
			
			int qty = Integer.parseInt(pMaster.getQty()) - Integer.parseInt(entity.getQty());
			pMaster.setQty(qty + "");
			pMaster.setUpdate_by(entity.getCreate_by());
			PartMaster.updateQty(pMaster);
		}
		
		//insert(entity, conn);
		pMaster.setPn(entity.getPn());
		pMaster = PartMaster.select(pMaster);
		entity.setUIpMaster(pMaster);
		conn.close();
	}
	
	private static void genNumber(QTWithdrawPart entity, Connection conn) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		entity.setNumber(DBUtility.genNumberFromDB(conn, tableName, entity, new String[]{"id","labor_id","labor_id_number"}, "number"));
	}
	
	public static void delete(QTWithdrawPart entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, new String[]{"id","labor_id","labor_id_number","pn","number"});
		conn.close();
	}
	
	public static void deleteAll(QTWithdrawPart entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, new String[]{"id","labor_id","labor_id_number"});
		conn.close();
	}
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getLabor_id() {
		return labor_id;
	}
	public void setLabor_id(String labor_id) {
		this.labor_id = labor_id;
	}
	public String getLabor_id_number() {
		return labor_id_number;
	}
	public void setLabor_id_number(String labor_id_number) {
		this.labor_id_number = labor_id_number;
	}
	public String getNumber() {
		return number;
	}
	public void setNumber(String number) {
		this.number = number;
	}
	public String getPn() {
		return pn;
	}
	public void setPn(String pn) {
		this.pn = pn;
	}
	public String getSn() {
		return sn;
	}
	public void setSn(String sn) {
		this.sn = sn;
	}
	public String getQty() {
		return qty;
	}
	public void setQty(String qty) {
		this.qty = qty;
	}
	public String getUnit_price() {
		return unit_price;
	}
	public void setUnit_price(String unit_price) {
		this.unit_price = unit_price;
	}
	public String getReturn_status() {
		return return_status;
	}
	public void setReturn_status(String return_status) {
		this.return_status = return_status;
	}
	public String getWithdraw_by() {
		return withdraw_by;
	}
	public void setWithdraw_by(String withdraw_by) {
		this.withdraw_by = withdraw_by;
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
	public PartMaster getUIpMaster() {
		return pMaster;
	}
	public void setUIpMaster(PartMaster pMaster) {
		this.pMaster = pMaster;
	}
}