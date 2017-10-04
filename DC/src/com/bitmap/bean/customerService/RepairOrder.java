package com.bitmap.bean.customerService;

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
import com.bitmap.webutils.PageControl;
import com.bitmap.bean.hr.Personal;
import com.bitmap.bean.service.RepairLaborMechanic;
import com.bitmap.bean.service.RepairLaborTime;

public class RepairOrder {
	public static final String tableName = "cs_repair_order";
	private static String[] keys = {"id"};
	private static String[] edit_fields = {"cus_id","vehicle_id","brought_in",
									  "fuel_level","km","due_date","initial_symptoms","note","car_remark",
									  "update_by","update_date"};
	
	private static String[] field_status = {"status","update_by","update_date"};
	
	String id = "";
	String cus_id = "";
	String vehicle_id = "";
	String brought_in = "";
	String received_by = "";
	Timestamp received_date = null;
	String fuel_level = "e";
	String km = "";
	Date due_date = null;
	String initial_symptoms = "";
	String note = "";
	String update_by = "";
	String status = "";
	String car_remark = "";
	Timestamp create_date = null;
	Timestamp update_date = null;
	RepairOrderRemark repairOrderRemark;
	
	public static String getUIStatusTH(RepairOrder entity) throws IllegalArgumentException, UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String status = entity.getStatus();
		String jobStatus = "-";
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_QT)) {
			jobStatus = "รอออกใบเสนอราคาให้ลูกค้า";
		} else
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_SA)) {
			jobStatus = "กำลังเลือกช่าง";
		} else
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_OPENED_JOB)) {
			jobStatus = "กำลังรอช่างเปิดงานซ่อม";
		} else 
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_ACTIVATE)) {
			jobStatus = RepairLaborTime.selectClosedStatus(entity.getId()) + " (งานที่เสร็จ / งานทั้งหมด)";
		} else 
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_QC)) {
			jobStatus = "กำลังตรวจสอบคุณภาพ";
		} else 
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_SUBMIT)) {
			jobStatus = "ตรวจสอบคุณภาพผ่าน เตรียมส่งรถ";
		} else 
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_REJECT)) {
			jobStatus = "ตรวจสอบคุณภาพไม่ผ่าน กำลังกลับไปแก้ไข";
		} else 
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_HOLDPART)) {
			jobStatus = "กำลังรออะไหล่";
		} else 
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_HOLD_OUTSOURCE)) {
			jobStatus = "ส่งซ่อมอู่นอก";
		}  else 
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_CS)) {
			jobStatus = "รอเปิดการซ่อม";
		}  else 
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_FINISH)) {
			jobStatus = "รอออกใบแจ้งหนี้";
		}  else 
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_ACCOUNT)) {
			jobStatus = "กำลังตรวจสอบจากฝ่ายการเงิน";
		}  else 
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_SUCCESS)) {
			jobStatus = "จบงาน";
		}
		return jobStatus;
	}
	
	private static String genId(Connection conn) throws SQLException{
		String id = "rp0000001";
		String sql = "SELECT id FROM " + tableName + " ORDER BY (id) DESC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		if (rs.next()) {
			String temp = rs.getString(1);
			id = (Integer.parseInt(temp.substring(2, temp.length())) + 10000001) + "";
			id = "rp" + id.substring(1,id.length());
		}
		rs.close();
		st.close();
		return id;
	}
	
	private static boolean check(String id, Connection conn) throws SQLException{
		String sql = "SELECT id FROM " + tableName + " WHERE id='" + id + "'";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		boolean has = false;
		while (rs.next()) {
			has = true;
		}
		rs.close();
		return has;
	}
	
	public static RepairOrder select(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		RepairOrder entity = new RepairOrder();
		entity.setId(id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static RepairOrder insert(RepairOrder entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		if (entity.getId()!="") {
			if (check(entity.getId(),conn)) { // check in database
				update(entity);
			} else {
				entity.setId(genId(conn));
				entity.setCreate_date(DBUtility.getDBCurrentDateTime());
				entity.setReceived_date(DBUtility.getDBCurrentDateTime());
				entity.setStatus(RepairLaborTime.STATUS_QT);
				DBUtility.insertToDB(conn, tableName, entity);
			}
		} else { // insert new Repair order
			entity.setId(genId(conn));
			entity.setCreate_date(DBUtility.getDBCurrentDateTime());
			entity.setReceived_date(DBUtility.getDBCurrentDateTime());
			entity.setStatus(RepairLaborTime.STATUS_QT);
			DBUtility.insertToDB(conn, tableName, entity);
		}
		
		conn.close();
		return entity;
	}
	
	public static void update(RepairOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_by(entity.getReceived_by());
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, edit_fields, keys);
		conn.close();
	}
	
	public static void approveQT(RepairOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(RepairLaborTime.STATUS_CS);
		DBUtility.updateToDB(conn, tableName, entity, field_status, keys);
		conn.close();
	}
	
	public static void active(RepairOrder entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(RepairLaborTime.STATUS_ACTIVATE);
		DBUtility.updateToDB(conn, tableName, entity, field_status, keys);
	}
	
	public static void cs(RepairOrder entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(RepairLaborTime.STATUS_CS);
		DBUtility.updateToDB(conn, tableName, entity, field_status, keys);
	}
	
	public static void hold(RepairOrder entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(RepairLaborTime.STATUS_HOLDPART);
		DBUtility.updateToDB(conn, tableName, entity, field_status, keys);
	}
	
	public static void outsource(RepairOrder entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(RepairLaborTime.STATUS_HOLD_OUTSOURCE);
		DBUtility.updateToDB(conn, tableName, entity, field_status, keys);
	}
	
	public static void unhold(RepairOrder entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		active(entity, conn);
	}
	
	public static void close(RepairOrder entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(RepairLaborTime.STATUS_QC);
		DBUtility.updateToDB(conn, tableName, entity, field_status, keys);
	}
	
	public static void submit(RepairOrder entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(RepairLaborTime.STATUS_SUBMIT);
		DBUtility.updateToDB(conn, tableName, entity, field_status, keys);
	}
	
	public static void finish(RepairOrder entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(RepairLaborTime.STATUS_FINISH);
		DBUtility.updateToDB(conn, tableName, entity, field_status, keys);
	}
	
	public static void account(RepairOrder entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(RepairLaborTime.STATUS_ACCOUNT);
		DBUtility.updateToDB(conn, tableName, entity, field_status, keys);
	}
	
	public static void success(RepairOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(RepairLaborTime.STATUS_SUCCESS);
		DBUtility.updateToDB(conn, tableName, entity, field_status, keys);
		conn.close();
	}
	
	public static void reject(RepairOrder entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(RepairLaborTime.STATUS_REJECT);
		DBUtility.updateToDB(conn, tableName, entity, field_status, keys);
	}
	
	public static List<RepairOrder> list4Invoice(PageControl ctrl) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException {
		String sql = "SELECT * FROM " + tableName + " WHERE status ='" + RepairLaborTime.STATUS_FINISH + "' OR status ='" + RepairLaborTime.STATUS_ACCOUNT + "' ORDER BY CAST(received_date AS DATETIME) ASC";
		
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<RepairOrder> list = new ArrayList<RepairOrder>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					RepairOrder entity = new RepairOrder();
					DBUtility.bindResultSet(entity, rs);
					list.add(entity);
				}
				cnt++;
			}
		}
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		rs.close();
		conn.close();
		return list;
	}
	
	public static List<RepairOrder> list4QT(PageControl ctrl) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException {
		String sql = "SELECT * FROM " + tableName + " WHERE status ='" + RepairLaborTime.STATUS_QT + "' ORDER BY CAST(received_date AS DATETIME) ASC";
		
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<RepairOrder> list = new ArrayList<RepairOrder>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					RepairOrder entity = new RepairOrder();
					DBUtility.bindResultSet(entity, rs);
					list.add(entity);
				}
				cnt++;
			}
		}
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		rs.close();
		conn.close();
		return list;
	}
	
	public static List<RepairOrder> list4CSViewJob(PageControl ctrl) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException {
		String sql = "SELECT * FROM " + tableName + " WHERE status !='" + RepairLaborTime.STATUS_FINISH + "' AND status !='" + RepairLaborTime.STATUS_ACCOUNT + "' AND status !='" + RepairLaborTime.STATUS_SUCCESS + "' ORDER BY CAST(received_date AS DATETIME) ASC";
		
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<RepairOrder> list = new ArrayList<RepairOrder>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					RepairOrder entity = new RepairOrder();
					DBUtility.bindResultSet(entity, rs);
					list.add(entity);
				}
				cnt++;
			}
		}
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		rs.close();
		conn.close();
		return list;
	}
	
	public static List<RepairOrder> list4InboxService(PageControl ctrl) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException {
		String sql = "SELECT * FROM " + tableName + " WHERE status ='" + RepairLaborTime.STATUS_CS + "' OR status='" + RepairLaborTime.STATUS_QT + "' ORDER BY CAST(received_date AS DATETIME) ASC";
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		//System.out.println(sql);
		List<RepairOrder> list = new ArrayList<RepairOrder>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					RepairOrder entity = new RepairOrder();
					DBUtility.bindResultSet(entity, rs);
					list.add(entity);
				}
				cnt++;
			}
		}
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		rs.close();
		conn.close();
		return list;
	}
	
	public static List<RepairOrder> list4ViewJob(PageControl ctrl) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException {
		String sql = "SELECT * FROM " + tableName + " WHERE status !='" + RepairLaborTime.STATUS_CS + "' AND status !='" + RepairLaborTime.STATUS_FINISH + "' AND status !='" + RepairLaborTime.STATUS_QT + "' AND status !='" + RepairLaborTime.STATUS_ACCOUNT + "' AND status !='" + RepairLaborTime.STATUS_SUCCESS + "' ORDER BY CAST(received_date AS DATETIME) ASC";
		////System.out.println(sql);
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<RepairOrder> list = new ArrayList<RepairOrder>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					RepairOrder entity = new RepairOrder();
					DBUtility.bindResultSet(entity, rs);
					list.add(entity);
				}
				cnt++;
			}
		}
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		rs.close();
		conn.close();
		return list;
	}
	
	public static List<RepairOrder> list4PartRepair(PageControl ctrl) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException {
		String sql = "SELECT * FROM " + tableName + " WHERE status !='" + RepairLaborTime.STATUS_CS + "' AND status !='" + RepairLaborTime.STATUS_QC +  "' AND status !='" + RepairLaborTime.STATUS_SUBMIT +  "' AND status !='" + RepairLaborTime.STATUS_FINISH + "' AND status !='" + RepairLaborTime.STATUS_ACCOUNT + "' AND status !='" + RepairLaborTime.STATUS_SUCCESS + "' ORDER BY CAST(received_date AS DATETIME) ASC";
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<RepairOrder> list = new ArrayList<RepairOrder>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					RepairOrder entity = new RepairOrder();
					DBUtility.bindResultSet(entity, rs);
					list.add(entity);
				}
				cnt++;
			}
		}
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		rs.close();
		conn.close();
		return list;
	}
	
	public static List<RepairOrder> list4QC(PageControl ctrl) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException {
		String sql = "SELECT * FROM " + tableName + " WHERE status ='" + RepairLaborTime.STATUS_QC + "' ORDER BY CAST(received_date AS DATETIME) ASC";
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<RepairOrder> list = new ArrayList<RepairOrder>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					RepairOrder entity = new RepairOrder();
					DBUtility.bindResultSet(entity, rs);
					list.add(entity);
				}
				cnt++;
			}
		}
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		rs.close();
		conn.close();
		return list;
	}
	
	private static boolean checkActive(String id,Connection conn) throws SQLException{
		String sql = "SELECT status FROM " + tableName + " WHERE id='" + id + "'";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		boolean active = true;
		while (rs.next()) {
			String status = rs.getString(1);
			if (status.equalsIgnoreCase(RepairLaborTime.STATUS_ACTIVATE)) {
				active = false;
				break;
			}
		}
		rs.close();
		return active;
	}
	
	/**
	 * Method: Update status in Select Labor Step
	 * @param id
	 * @param per_id
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 */
	public static void updateStatus_SA(String id,String per_id) throws IllegalAccessException, InvocationTargetException, SQLException{
		RepairOrder entity = new RepairOrder();
		entity.setId(id);
		entity.setStatus(RepairLaborTime.STATUS_SA);
		entity.setUpdate_by(per_id);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		String[] saUpdate = {"status","update_by","update_date"};
		
		Connection conn = DBPool.getConnection();
		if (checkActive(id, conn)) {
			DBUtility.updateToDB(conn, tableName, entity, saUpdate, keys);
		}
		conn.close();
	}
	
	/**
	 * Method: Update status in Assign Mechanic Step
	 * @param id
	 * @param per_id
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static void updateStatus_OpenedJob(String id, String per_id) throws SQLException, IllegalAccessException, InvocationTargetException{
		RepairOrder entity = new RepairOrder();
		entity.setId(id);
		entity.setStatus(RepairLaborTime.STATUS_OPENED_JOB);
		entity.setUpdate_by(per_id);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		String[] update = {"status","update_by","update_date"};
		
		Connection conn = DBPool.getConnection();
		if (checkActive(id, conn)) {
			DBUtility.updateToDB(conn, tableName, entity, update, keys);
		}
		conn.close();
	}
	
	public static void updateStatus_QC(String id) throws SQLException, IllegalAccessException, InvocationTargetException{
		RepairOrder entity = new RepairOrder();
		entity.setId(id);
		entity.setStatus(RepairLaborTime.STATUS_QC);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		String[] update = {"status","update_date"};
		Connection conn = DBPool.getConnection();
		DBUtility.updateToDB(conn, tableName, entity, update, keys);
		conn.close();
	}
	
	public static List<Personal> selectMechanicInRepairOrder(String id) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT mech.mechanic_id FROM " + tableName + " rp " +
				"INNER JOIN " + RepairLaborMechanic.tableName + " mech " +
				"ON rp.id = mech.id " +
				"WHERE rp.id ='" + id + "' " +
				"GROUP BY mech.mechanic_id";
		
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<Personal> list = new ArrayList<Personal>();
		while (rs.next()) {
			Personal per = new Personal();
			String per_id = DBUtility.getString("mech.mechanic_id", rs);
			per = Personal.select(per_id);
			list.add(per);
		}
		
		rs.close();
		conn.close();
		return list;
	}
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getCus_id() {
		return cus_id;
	}
	public void setCus_id(String cus_id) {
		this.cus_id = cus_id;
	}
	public String getVehicle_id() {
		return vehicle_id;
	}
	public void setVehicle_id(String vehicle_id) {
		this.vehicle_id = vehicle_id;
	}
	public String getBrought_in() {
		return brought_in;
	}
	public void setBrought_in(String brought_in) {
		this.brought_in = brought_in;
	}
	public String getReceived_by() {
		return received_by;
	}
	public void setReceived_by(String received_by) {
		this.received_by = received_by;
	}
	public Timestamp getReceived_date() {
		return received_date;
	}
	public void setReceived_date(Timestamp received_date) {
		this.received_date = received_date;
	}
	public String getFuel_level() {
		return fuel_level;
	}
	public void setFuel_level(String fuel_level) {
		this.fuel_level = fuel_level;
	}
	public String getKm() {
		return km;
	}
	public void setKm(String km) {
		this.km = km;
	}
	public Date getDue_date() {
		return due_date;
	}
	public void setDue_date(Date due_date) {
		this.due_date = due_date;
	}
	public String getInitial_symptoms() {
		return initial_symptoms;
	}
	public void setInitial_symptoms(String initial_symptoms) {
		this.initial_symptoms = initial_symptoms;
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getCar_remark() {
		return car_remark;
	}
	public void setCar_remark(String car_remark) {
		this.car_remark = car_remark;
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
	public RepairOrderRemark getUIRepairOrderRemark() {
		return repairOrderRemark;
	}
	public void setUIRepairOrderRemark(RepairOrderRemark repairOrderRemark) {
		this.repairOrderRemark = repairOrderRemark;
	}
}