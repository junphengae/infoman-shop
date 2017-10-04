package com.bitmap.bean.service;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.bean.customerService.RepairOrder;

public class RepairLaborMechanic {
	public static String tableName = "sv_repair_labor_mechanic";
	private static String[] keys = {"id","labor_id","number"};
	private static String[] key_status = {"id","labor_id","mechanic_id","number"};
	private static String[] field_status = {"status","time_start","update_by","update_date"};
	
	String id = "";
	String number = "";
	String labor_id = "";
	String labor_hour = "";
	String mechanic_id = "";
	String status = "";
	Timestamp time_start = null;
	Timestamp time_stop = null;
	String create_by = "";
	String update_by = "";
	Timestamp create_date = null;
	Timestamp update_date = null;
	
	public static List<RepairLaborMechanic> selectById(String id, String labor_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		String sql = "SELECT * FROM " + tableName + " WHERE id='" + id + "' AND labor_id='" + labor_id + "'";
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<RepairLaborMechanic> list = new ArrayList<RepairLaborMechanic>();
		while (rs.next()) {
			RepairLaborMechanic entity = new RepairLaborMechanic();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		conn.close();
		return list;
	}
	
	public static List<RepairLaborMechanic> selectById(String id, String labor_id, String number) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		String sql = "SELECT * FROM " + tableName + " WHERE id='" + id + "' AND labor_id='" + labor_id + "' AND number='" + number + "'";
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<RepairLaborMechanic> list = new ArrayList<RepairLaborMechanic>();
		while (rs.next()) {
			RepairLaborMechanic entity = new RepairLaborMechanic();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		conn.close();
		return list;
	}
	
	public static RepairLaborMechanic selectByMecId_LaborId(String id, String labor_id, String mec_id, String number) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		String sql = "SELECT * FROM " + tableName + " WHERE id='" + id + "' AND labor_id ='" + labor_id + "' AND mechanic_id ='" + mec_id + "' AND number='" + number + "'";
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		//System.out.println(sql);
		RepairLaborMechanic entity = new RepairLaborMechanic();
		if (rs.next()) {
			DBUtility.bindResultSet(entity, rs);
		}
		rs.close();
		conn.close();
		return entity;
	}
	
	private static boolean check(RepairLaborMechanic entity, Connection conn) throws SQLException{
		boolean has = false;
		String sql = "SELECT id FROM " + tableName + " WHERE id='" + entity.getId() + "' AND labor_id ='" + entity.getLabor_id() + "'";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		while (rs.next()) {
			has = true;
		}
		
		return has;
	}
	
	public static void insert(RepairLaborMechanic entity, String[] mec_id) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		if (check(entity,conn)) {
			delete(entity,conn);
		}
		
		entity.setStatus(RepairLaborTime.STATUS_OPENED_JOB);
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		
		for (int i = 0; i < mec_id.length; i++) {
			entity.setMechanic_id(mec_id[i]);
			DBUtility.insertToDB(conn, tableName, entity);
		}
		
		// check hold
		RepairLaborTime laborTime = new RepairLaborTime();
		laborTime.setId(entity.getId());
		laborTime.setLabor_id(entity.getLabor_id());
		laborTime.setNumber(entity.getNumber());
		if (!RepairLaborTime.checkHold(laborTime, conn)) {
			RepairLaborTime.opened_job(laborTime, conn);
			if (!RepairLaborTime.checkReject(laborTime, conn)) {
				RepairOrder.updateStatus_OpenedJob(entity.getId(), entity.getCreate_by());
			}
		}
		conn.close();
	}
	
	public static List<RepairLaborMechanic> selectMyLabor(String per_id) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE mechanic_id='" + per_id + "' AND status !='" + RepairLaborTime.STATUS_CLOSED + "' ORDER BY id, labor_id";
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		//System.out.println(sql);
		List<RepairLaborMechanic> list = new ArrayList<RepairLaborMechanic>();
		while (rs.next()) {
			RepairLaborMechanic entity = new RepairLaborMechanic();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		conn.close();
		return list;
	}
	
	public static void delete(RepairLaborMechanic entity, Connection conn) throws SQLException, IllegalAccessException, InvocationTargetException{
		DBUtility.deleteFromDB(conn, tableName, entity, keys);
	}
	
	public static String terminate(RepairLaborMechanic entity, Connection conn) throws SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE id='" + entity.getId() + "' AND labor_id ='" + entity.getLabor_id() + "' AND number='" + entity.getNumber() +"'";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		String mec_id = "";
		while (rs.next()) {
			mec_id += rs.getString("mechanic_id");
			if (rs.getString("status").equalsIgnoreCase(RepairLaborTime.STATUS_HOLDPART)) {
				mec_id += "_h";
			}
			mec_id += ",";
		}
		mec_id = mec_id.substring(0,mec_id.length() -1);
		rs.close();
		DBUtility.deleteFromDB(conn, tableName, entity, keys);
		return mec_id;
	}
	
	public static boolean checkActive(String mechanic_id) throws SQLException{
		boolean active = false;
		Connection conn = DBPool.getConnection();
		String sql = "SELECT id FROM " + tableName + " WHERE mechanic_id ='" + mechanic_id + "' AND status ='" + RepairLaborTime.STATUS_ACTIVATE + "'";
		//System.out.println(sql);
		ResultSet rs = conn.createStatement().executeQuery(sql);
		if (rs.next()) {
			active = true;
		}
		conn.close();
		return active;
	}
	
	public static void reject(RepairLaborMechanic laborMec, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException {
		laborMec.setStatus(RepairLaborTime.STATUS_REJECT);
		DBUtility.updateToDB(conn, tableName, laborMec, new String[]{"status"}, keys);
	}
	
	public static void active(RepairLaborMechanic laborMec) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();
		laborMec.setMechanic_id(laborMec.getUpdate_by());
		laborMec.setUpdate_date(DBUtility.getDBCurrentDateTime());
		laborMec.setTime_start(DBUtility.getDBCurrentDateTime());
		laborMec.setStatus(RepairLaborTime.STATUS_ACTIVATE);
		DBUtility.updateToDB(conn, tableName, laborMec, field_status, key_status);
		
		RepairLaborTime laborTime = new RepairLaborTime();
		laborTime.setId(laborMec.getId());
		laborTime.setNumber(laborMec.getNumber());
		laborTime.setLabor_id(laborMec.getLabor_id());
		laborTime.setUpdate_by(laborMec.getUpdate_by());
		RepairLaborTime.active(laborTime, conn);
		
		conn.close();
	}
	
	/**
	 * Hold 
	 * @param laborMec
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 */
	public static void hold(RepairLaborMechanic laborMec) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();
		laborMec.setMechanic_id(laborMec.getUpdate_by());
		laborMec.setUpdate_date(DBUtility.getDBCurrentDateTime());
		laborMec.setStatus(RepairLaborTime.STATUS_HOLDPART);
		DBUtility.updateToDB(conn, tableName, laborMec, new String[]{"status","update_by","update_date"}, key_status);
		
		// Insert status hold to table MechanicHold
		MechanicHold mecHold = new MechanicHold();
		mecHold.setId(laborMec.getId());
		mecHold.setNumber(laborMec.getNumber());
		mecHold.setLabor_id(laborMec.getLabor_id());
		mecHold.setMechanic_id(laborMec.getMechanic_id());
		mecHold.setHold_start_by(laborMec.getUpdate_by());
		MechanicHold.hold(mecHold);
		
		// Update status hold to table RepairLaborTime
		RepairLaborTime laborTime = new RepairLaborTime();
		laborTime.setId(laborMec.getId());
		laborTime.setNumber(laborMec.getNumber());
		laborTime.setLabor_id(laborMec.getLabor_id());
		laborTime.setUpdate_by(laborMec.getUpdate_by());
		RepairLaborTime.hold(laborTime, conn);
		
		conn.close();
	}
	
	public static void unhold(RepairLaborMechanic laborMec) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();
		laborMec.setMechanic_id(laborMec.getUpdate_by());
		laborMec.setUpdate_date(DBUtility.getDBCurrentDateTime());
		laborMec.setStatus(RepairLaborTime.STATUS_ACTIVATE);
		DBUtility.updateToDB(conn, tableName, laborMec, new String[]{"status","update_by","update_date"}, key_status);
		
		// Update status active to table MechanicHold
		MechanicHold mecHold = new MechanicHold();
		mecHold.setId(laborMec.getId());
		mecHold.setNumber(laborMec.getNumber());
		mecHold.setLabor_id(laborMec.getLabor_id());
		mecHold.setMechanic_id(laborMec.getMechanic_id());
		mecHold.setHold_stop_by(laborMec.getUpdate_by());
		MechanicHold.unhold(mecHold);
		
		// If laborMechanic active all
		if (checkHold(laborMec.getId(), laborMec.getLabor_id(),laborMec.getNumber(), conn)) {
			// Update status active to table RepairLaborTime
			RepairLaborTime laborTime = new RepairLaborTime();
			laborTime.setId(laborMec.getId());
			laborTime.setNumber(laborMec.getNumber());
			laborTime.setLabor_id(laborMec.getLabor_id());
			laborTime.setUpdate_by(laborMec.getUpdate_by());
			RepairLaborTime.unhold(laborTime, conn);
		}
		
		conn.close();
	}
	
	public static boolean checkHold(String id, String labor_id, String number, Connection conn) throws SQLException{
		boolean has = true;
		String sql = "SELECT status FROM " + tableName + " WHERE id ='" + id + "' AND labor_id='" + labor_id + "' AND number='" + number + "' AND status ='" + RepairLaborTime.STATUS_HOLDPART + "'";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		while (rs.next()) {
			if (rs.getString(1).equalsIgnoreCase(RepairLaborTime.STATUS_HOLDPART)) {
				has = false;
				break;
			}
		}
		rs.close();
		return has;
	}
	
	public static void closed(RepairLaborMechanic laborMec) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();
		laborMec.setMechanic_id(laborMec.getUpdate_by());
		laborMec.setUpdate_date(DBUtility.getDBCurrentDateTime());
		laborMec.setTime_stop(DBUtility.getDBCurrentDateTime());
		laborMec.setStatus(RepairLaborTime.STATUS_CLOSED);
		DBUtility.updateToDB(conn, tableName, laborMec, new String[]{"status","time_stop","update_by","update_date"}, key_status);
		
		if (check4Close(laborMec, conn)) {
			RepairLaborTime laborTime = new RepairLaborTime();
			laborTime.setId(laborMec.getId());
			laborTime.setNumber(laborMec.getNumber());
			laborTime.setLabor_id(laborMec.getLabor_id());
			laborTime.setUpdate_by(laborMec.getUpdate_by());
			RepairLaborTime.close(laborTime, conn);
		}
		conn.close();
	}
	
	private static boolean check4Close(RepairLaborMechanic entity, Connection conn) throws SQLException{
		boolean close = true;
		String sql = "SELECT id FROM " + tableName + " WHERE id='" + entity.getId() + "' AND labor_id='" + entity.getLabor_id() + "' AND number='" + entity.getNumber() + "' AND status !='" + RepairLaborTime.STATUS_CLOSED + "'";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		if (rs.next()) {
			close = false;
		}
		return close;
		
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

	public String getLabor_id() {
		return labor_id;
	}

	public void setLabor_id(String labor_id) {
		this.labor_id = labor_id;
	}

	public String getLabor_hour() {
		return labor_hour;
	}

	public void setLabor_hour(String labor_hour) {
		this.labor_hour = labor_hour;
	}

	public String getMechanic_id() {
		return mechanic_id;
	}

	public void setMechanic_id(String mechanic_id) {
		this.mechanic_id = mechanic_id;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Timestamp getTime_start() {
		return time_start;
	}

	public void setTime_start(Timestamp time_start) {
		this.time_start = time_start;
	}

	public Timestamp getTime_stop() {
		return time_stop;
	}

	public void setTime_stop(Timestamp time_stop) {
		this.time_stop = time_stop;
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
}