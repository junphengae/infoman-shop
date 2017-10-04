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

public class WithdrawPart {
	public static String tableName = "pa_withdraw_part";
	
	public static String STATUS_WITHDRAW = "0";
	public static String STATUS_RETURN = "1";
	public static String STATUS_SCRAP = "5";
	
	String id = "";
	String labor_id = "";
	String labor_id_number = "";
	String number = "1";
	String pn = "";
	String sn = "";
	String qty = "1";
	String return_status = "0";
	String withdraw_by = "";
	String return_qty = "0";
	String scrap_qty = "";
	String return_by = "";
	Timestamp return_date = null;
	String note = "";
	String create_by = "";
	String update_by = "";
	Timestamp create_date = null;
	Timestamp update_date = null;
	
	PartMaster pMaster = new PartMaster();
	
	public static List<WithdrawPart> selectList(String id, String labor_id, String labor_id_number) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE id='" + id + "' AND labor_id='" + labor_id + "' AND labor_id_number='" + labor_id_number + "' AND return_status ='0'";
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<WithdrawPart> list = new ArrayList<WithdrawPart>();
		while (rs.next()) {
			WithdrawPart entity = new WithdrawPart();
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
	
	public static void insert(WithdrawPart entity) throws IllegalAccessException, InvocationTargetException, SQLException{
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
	
	public static void withdraw_part(WithdrawPart entity) throws NumberFormatException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		genNumber(entity, conn);
		
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
		
		insert(entity);
		pMaster.setPn(entity.getPn());
		pMaster = PartMaster.select(pMaster);
		entity.setUIpMaster(pMaster);
		conn.close();
	}
	
	public static void return_part(WithdrawPart entity) throws NumberFormatException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		PartSerial pSerial = new PartSerial();
		pSerial.setPn(entity.getPn());
		pSerial.setSn(entity.getSn());
		pSerial.setUpdate_by(entity.getUpdate_by());
		PartSerial.returnPart(pSerial, conn);
		
		entity.setReturn_qty("1");
		entity.setReturn_status(STATUS_RETURN);
		entity.setReturn_date(DBUtility.getDBCurrentDateTime());
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"return_status","return_qty","return_date","return_by","update_by","update_date"}, new String[]{"id","labor_id","labor_id_number","number"});
		
		conn.close();
	}
	
	public static void scrap_part(WithdrawPart entity) throws NumberFormatException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		entity.setScrap_qty("1");
		entity.setReturn_status(STATUS_SCRAP);
		entity.setReturn_date(DBUtility.getDBCurrentDateTime());
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"return_status","scrap_qty","return_date","return_by","update_by","update_date"}, new String[]{"id","labor_id","labor_id_number","number"});
		
		conn.close();
	}
	
	public static void return_partNonSN(WithdrawPart entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		WithdrawPart wpart = new WithdrawPart();
		wpart.setId(entity.getId());
		wpart.setLabor_id(entity.getLabor_id());
		wpart.setLabor_id_number(entity.getLabor_id_number());
		wpart.setNumber(entity.getNumber());
		
		WithdrawPart.select4Return(wpart, conn);
		
		int borrow_qty = Integer.parseInt(wpart.getQty());
		int borrow_return_qty = Integer.parseInt(wpart.getReturn_qty());
		
		int return_qty = Integer.parseInt(entity.getReturn_qty());
		
		
		if (borrow_qty == return_qty) {
			entity.setQty((borrow_qty - return_qty) + "");
			entity.setReturn_qty((borrow_return_qty + return_qty) + "");
			entity.setReturn_status(STATUS_RETURN);
			entity.setReturn_date(DBUtility.getDBCurrentDateTime());
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"qty","return_status","return_qty","return_date","return_by","update_by","update_date"}, new String[]{"id","labor_id","labor_id_number","number"});
		} else if (borrow_qty > return_qty) {
			entity.setQty((borrow_qty - return_qty) + "");
			entity.setReturn_qty((borrow_return_qty + return_qty) + "");
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"qty","return_qty","return_by","update_by","update_date"}, new String[]{"id","labor_id","labor_id_number","number"});
		}
		
		PartMaster master = new PartMaster();
		master.setPn(entity.getPn());
		master.setQty(return_qty + "");
		master.setUpdate_by(entity.getUpdate_by());
		PartMaster.updateQtyNonSN(master);
		
		conn.close();
	}
	
	public static void scrap_partNonSN(WithdrawPart entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		WithdrawPart wpart = new WithdrawPart();
		wpart.setId(entity.getId());
		wpart.setLabor_id(entity.getLabor_id());
		wpart.setLabor_id_number(entity.getLabor_id_number());
		wpart.setNumber(entity.getNumber());
		
		WithdrawPart.select4Return(wpart, conn);
		
		int borrow_qty = Integer.parseInt(wpart.getQty());
		int borrow_return_qty = Integer.parseInt(wpart.getReturn_qty());
		
		entity.setScrap_qty((borrow_qty - borrow_return_qty) + "");
		entity.setReturn_status(STATUS_SCRAP);
		entity.setReturn_date(DBUtility.getDBCurrentDateTime());
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"return_status","scrap_qty","return_date","return_by","update_by","update_date"}, new String[]{"id","labor_id","labor_id_number","number"});
		
		conn.close();
	}
	
	private static void genNumber(WithdrawPart entity, Connection conn) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		entity.setNumber(DBUtility.genNumberFromDB(conn, tableName, entity, new String[]{"id","labor_id","labor_id_number"}, "number"));
	}
	
	public static void delete(WithdrawPart entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, new String[]{"id","labor_id","labor_id_number","pn","sn","number"});
		conn.close();
	}
	
	public static void deleteAll(WithdrawPart entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		entity.setReturn_status("0");
		DBUtility.deleteFromDB(conn, tableName, entity, new String[]{"id","labor_id","labor_id_number","return_status"});
		conn.close();
	}
	
	public static WithdrawPart select(WithdrawPart entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		WithdrawPart wp = new WithdrawPart();
		Connection conn = DBPool.getConnection();
		
		wp.setReturn_status("0");
		wp.setId(entity.getId());
		wp.setLabor_id(entity.getLabor_id());
		wp.setLabor_id_number(entity.getLabor_id_number());
		
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"id","labor_id","labor_id_number","return_status"});
		conn.close();
		return wp;
	}
	
	public static boolean checkPart(WithdrawPart entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		//String sql = "SELECT * FROM " + tableName + " WHERE id='" + entity.getId() + "' AND labor_id='" + entity.getLabor_id() + "' AND labor_id_number='" + entity.getLabor_id_number() + "' AND return_status ='0'";
		boolean has = false;
		
		Connection conn = DBPool.getConnection();
		entity.setReturn_status("0");
		has = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"id","labor_id","labor_id_number","return_status"});
		/*
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		if (rs.next()) {
			has = true;
		}
		rs.close();
		st.close();
		conn.close();*/
		conn.close();
		return has;
	}
	
	public static void select4Return(WithdrawPart entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		entity.setReturn_status(STATUS_WITHDRAW);
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"id","labor_id","labor_id_number","number","return_status"});
		conn.close();
	}
	
	public static void select4Return(WithdrawPart entity, Connection conn) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		entity.setReturn_status(STATUS_WITHDRAW);
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"id","labor_id","labor_id_number","number","return_status"});
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
	public String getScrap_qty() {
		return scrap_qty;
	}

	public void setScrap_qty(String scrap_qty) {
		this.scrap_qty = scrap_qty;
	}
	public String getReturn_qty() {
		return return_qty;
	}

	public void setReturn_qty(String return_qty) {
		this.return_qty = return_qty;
	}

	public String getReturn_by() {
		return return_by;
	}

	public void setReturn_by(String return_by) {
		this.return_by = return_by;
	}

	public Timestamp getReturn_date() {
		return return_date;
	}

	public void setReturn_date(Timestamp return_date) {
		this.return_date = return_date;
	}
	
}