package com.bitmap.bean.service;

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
import com.bitmap.bean.customerService.RepairOrder;
import com.bitmap.bean.customerService.QTWithdrawPart;
import com.bitmap.bean.customerService.WithdrawPart;
import com.bitmap.bean.parts.ServiceRepair;

public class RepairLaborTime {
	public static String STATUS_QT = "00";//qt
	public static String STATUS_CS = "10";//cs
	public static String STATUS_SA = "20";//sa
	public static String STATUS_OPENED_JOB = "30";//opened_job
	public static String STATUS_ACTIVATE = "40";//active
	public static String STATUS_HOLDPART = "45";//holdpart
	public static String STATUS_HOLD_OUTSOURCE = "47";//
	public static String STATUS_CLOSED = "50";//closed
	public static String STATUS_QC = "60";//
	public static String STATUS_REJECT = "65";
	public static String STATUS_SUBMIT = "70";
	public static String STATUS_FINISH = "80";
	public static String STATUS_ACCOUNT = "90";
	public static String STATUS_SUCCESS = "100";
	
	public static String tableName = "sv_repair_labor_time";
	private static String[] keys = {"id","number","labor_id"};
	private static String[] field_status = {"status","update_by","update_date"};
	private static String[] field_submit = {"status","update_by","update_date","remark"};
	
	String id = "";
	String number = "1";
	String labor_id = "";
	String labor_hour = "";
	String unit_price = "";
	String status = "";
	String remark = "";
	String create_by = "";
	String update_by = "";
	Timestamp create_date = null;
	Timestamp update_date = null;
	
	List<RepairLaborMechanic> mechanicList = new ArrayList<RepairLaborMechanic>();
	
	public static String getthstatus(String status) throws SQLException{
		
		if(STATUS_REJECT.equalsIgnoreCase(status)){
			status = "Reject";
		}
		else if(STATUS_SUBMIT.equalsIgnoreCase(status)){
			status = "Submit";
		}
		
		
		return status;
		
	}
	
	public static String standardPrice() throws SQLException{
		Connection conn = DBPool.getConnection();
		//String sql = "SELECT * FROM sv_labor_time_std WHERE flag='1'";
		String sql = "SELECT * FROM sv_labor_time_std ";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String std = "1800";
		if (rs.next()) {
			std = DBUtility.getString("std_cost", rs);
		}
		
		rs.close();
		st.close();
		conn.close();
		return std;
	}
	
	public static String check(String id) throws SQLException{
		String rtn = "true";
		String sql = "SELECT id,status FROM " + tableName + " WHERE id='" + id + "'";
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		if (rs.next()) {
			String status = DBUtility.getString("status", rs);
			if (status.equals(STATUS_REJECT) || status.equals(STATUS_SUBMIT) || status.equals(STATUS_FINISH)) {
				rtn = "finish";
			} else if (status.equals(STATUS_CS) || status.equals(STATUS_QT)){
				rtn = "pre_open";
			} else if (status.equals(STATUS_ACCOUNT) || status.equals(STATUS_SUCCESS)){
				rtn = "close";
			}
		} else {
			rtn = "false";
		}
		
		rs.close();
		st.close();
		conn.close();
		return rtn;
	}
	
	public static List<RepairLaborTime> select(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		String sql = "SELECT * FROM " + tableName + " WHERE id='" + id + "'";
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<RepairLaborTime> list = new ArrayList<RepairLaborTime>();
		while (rs.next()) {
			RepairLaborTime entity = new RepairLaborTime();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		conn.close();
		return list;
	}
	
	public static RepairLaborTime selectById(String id, String labor_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		String sql = "SELECT * FROM " + tableName + " WHERE id='" + id + "' AND labor_id='" + labor_id + "'";
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		RepairLaborTime entity = new RepairLaborTime();
		while (rs.next()) {
			DBUtility.bindResultSet(entity, rs);
		}
		rs.close();
		conn.close();
		return entity;
	}
	
	public static RepairLaborTime selectById(String id, String labor_id, String number) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		String sql = "SELECT * FROM " + tableName + " WHERE id='" + id + "' AND labor_id='" + labor_id + "' AND number='" + number + "'";
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		RepairLaborTime entity = new RepairLaborTime();
		while (rs.next()) {
			DBUtility.bindResultSet(entity, rs);
		}
		rs.close();
		conn.close();
		return entity;
	}
	
	public static String selectClosedStatus(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		String sql = "SELECT id,status FROM " + tableName + " WHERE id='" + id + "'";
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		int total = 0;
		int closed = 0;
		while (rs.next()) {
			total++;
			String status = rs.getString("status");
			if (status.equalsIgnoreCase(STATUS_CLOSED) || status.equalsIgnoreCase(STATUS_SUBMIT)) {
				closed++;
			}
		}
		conn.close();
		return closed + " / " + total;
	}
	
	public static String selectTotalList(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		String sql = "SELECT id,status FROM " + tableName + " WHERE id='" + id + "'";
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		int total = 0;
		while (rs.next()) {
			total++;
		}
		rs.close();
		conn.close();
		return total + "";
	}
	
	public static List<RepairLaborTime> selectIncludeMechanic(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		String sql = "SELECT * FROM " + tableName + " WHERE id='" + id + "'";
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<RepairLaborTime> list = new ArrayList<RepairLaborTime>();
		while (rs.next()) {
			RepairLaborTime entity = new RepairLaborTime();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIMechanicList(RepairLaborMechanic.selectById(entity.getId(),entity.getLabor_id(),entity.getNumber()));
			list.add(entity);
		}
		rs.close();
		conn.close();
		return list;
	}
	
	private static boolean checkEmpty(RepairLaborTime entity, Connection conn) throws SQLException{
		boolean empty = true;
		String sql = "SELECT id FROM " + tableName + " WHERE id='" + entity.getId() + "'";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		if (rs.next()) {
			empty = false;
		}
		rs.close();
		return empty;
	}
	
	private static boolean check(RepairLaborTime entity, Connection conn) throws SQLException{
		boolean has = false;
		String sql = "SELECT id FROM " + tableName + " WHERE id='" + entity.getId() + "' AND labor_id ='" + entity.getLabor_id() + "'";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		if (rs.next()) {
			has = true;
		}
		rs.close();
		return has;
	}
	
	public static void checkAll(RepairLaborTime entity, Connection conn) throws SQLException, IllegalAccessException, InvocationTargetException{
		RepairOrder repairOrder = new RepairOrder();
		repairOrder.setId(entity.getId());
		repairOrder.setUpdate_by(entity.getCreate_by());
		if (checkEmpty(entity, conn)) {
			RepairOrder.cs(repairOrder, conn);
		} else {
			if (!checkHold(entity, conn)) {
				if (!checkReject(entity, conn)) {
					if (checkActive(entity, conn)) {
						RepairOrder.active(repairOrder, conn);
					} else if (check4Close(entity, conn)) {
						RepairOrder.close(repairOrder,conn);
					} else if (checkOpenedJob(entity, conn)) {
						RepairOrder.updateStatus_OpenedJob(repairOrder.getId(), repairOrder.getUpdate_by());
					}
				}
			} else {
				RepairOrder.hold(repairOrder,conn);
			}
		}
	}
	
	public static boolean insert4QT(RepairLaborTime entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		entity.setNumber(DBUtility.genNumberFromDB(conn, tableName, entity, new String[]{"id"}, "number"));
		entity.setStatus(RepairLaborTime.STATUS_QT);
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		
		conn.close();
		return true;
	}
	
	public static void delete4QT(RepairLaborTime entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		QTWithdrawPart wPart = new QTWithdrawPart();
		wPart.setId(entity.getId());
		wPart.setLabor_id(entity.getLabor_id());
		wPart.setLabor_id_number(entity.getNumber());
		QTWithdrawPart.deleteAll(wPart);
		
		DBUtility.deleteFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public static boolean insert(RepairLaborTime entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		if (check(entity,conn)) {
			return false;
		} else {
			entity.setStatus(RepairLaborTime.STATUS_OPENED_JOB);
			entity.setCreate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.insertToDB(conn, tableName, entity);
			if (!checkHold(entity, conn)) {
				if (!checkReject(entity, conn)) {
					RepairOrder.updateStatus_SA(entity.getId(), entity.getCreate_by());
				}
			}
		}
		conn.close();
		return true;
	}
	
	public static void opened_job(RepairLaborTime entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException {
		entity.setStatus(STATUS_OPENED_JOB);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, field_status, keys);
	}
	
	public static void outsource(RepairLaborTime entity) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();
		entity.setStatus(STATUS_HOLD_OUTSOURCE);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, field_status, keys);
		conn.close();
	}
	
	public static void delete(RepairLaborTime entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, keys);
		
		RepairLaborMechanic mec = new RepairLaborMechanic();
		mec.setId(entity.getId());
		mec.setLabor_id(entity.getLabor_id());
		mec.setNumber(entity.getNumber());
		RepairLaborMechanic.delete(mec, conn);
		MechanicHold.delete(entity.getId(), entity.getLabor_id(), entity.getNumber());
		
		QTWithdrawPart qtwPart = new QTWithdrawPart();
		qtwPart.setId(entity.getId());
		qtwPart.setLabor_id(entity.getLabor_id());
		qtwPart.setLabor_id_number(entity.getNumber());
		QTWithdrawPart.deleteAll(qtwPart);
		
		checkAll(entity, conn);
		conn.close();
	}
	
	public static void terminate(RepairLaborTime entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		RepairLaborMechanic mec = new RepairLaborMechanic();
		mec.setId(entity.getId());
		mec.setNumber(entity.getNumber());
		mec.setLabor_id(entity.getLabor_id());
		
		RepairLaborTerminate terminate = new RepairLaborTerminate();
		terminate.setId(entity.getId());
		terminate.setLabor_id(entity.getLabor_id());
		terminate.setNumber(entity.getNumber());
		terminate.setHistory(RepairLaborMechanic.terminate(mec, conn));
		terminate.setTerminate_by(entity.getUpdate_by());
		RepairLaborTerminate.insert(terminate, conn);
		
		DBUtility.deleteFromDB(conn, tableName, entity, keys);
		
		MechanicHold.delete(entity.getId(), entity.getLabor_id(), entity.getNumber());
		
		QTWithdrawPart qtwPart = new QTWithdrawPart();
		qtwPart.setId(entity.getId());
		qtwPart.setLabor_id(entity.getLabor_id());
		qtwPart.setLabor_id_number(entity.getNumber());
		QTWithdrawPart.deleteAll(qtwPart);
		
		WithdrawPart wPart = new WithdrawPart();
		wPart.setId(entity.getId());
		wPart.setLabor_id(entity.getLabor_id());
		wPart.setLabor_id_number(entity.getNumber());
		WithdrawPart.deleteAll(wPart);
		
		checkAll(entity, conn);
		conn.close();
	}
	
	public static void terminateReject(RepairLaborTime entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		RepairLaborMechanic mec = new RepairLaborMechanic();
		mec.setId(entity.getId());
		mec.setNumber(entity.getNumber());
		mec.setLabor_id(entity.getLabor_id());
		
		RepairLaborTerminateReject terminate = new RepairLaborTerminateReject();
		terminate.setId(entity.getId());
		terminate.setNumber(entity.getNumber());
		terminate.setLabor_id(entity.getLabor_id());
		terminate.setHistory(RepairLaborMechanic.terminate(mec, conn));
		terminate.setTerminate_by(entity.getUpdate_by());
		RepairLaborTerminateReject.insert(terminate, conn);
		
		DBUtility.deleteFromDB(conn, tableName, entity, keys);

		MechanicHold.delete(entity.getId(), entity.getLabor_id(), entity.getNumber());
		
		QTWithdrawPart wPart = new QTWithdrawPart();
		wPart.setId(entity.getId());
		wPart.setLabor_id(entity.getLabor_id());
		wPart.setLabor_id_number(entity.getNumber());
		QTWithdrawPart.deleteAll(wPart);
		
		checkAll(entity, conn);
		conn.close();
	}
	
	public static void active(RepairLaborTime entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_ACTIVATE);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, field_status, keys);
		
		if (!checkHold(entity, conn)) {
//			RepairOrder repairOrder = new RepairOrder();
//			repairOrder.setId(entity.getId());
//			repairOrder.setUpdate_by(entity.getUpdate_by());
//			RepairOrder.active(repairOrder,conn);
			
			ServiceRepair servicerepair = new ServiceRepair();
			servicerepair.setId(entity.getId());
			servicerepair.setUpdate_by(entity.getUpdate_by());
			ServiceRepair.active(servicerepair, conn);
			//servicerepair.a
		}
	}
	
	public static void hold(RepairLaborTime entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_HOLDPART);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, field_status, keys);
		
		RepairOrder repairOrder = new RepairOrder();
		repairOrder.setId(entity.getId());
		repairOrder.setUpdate_by(entity.getUpdate_by());
		RepairOrder.hold(repairOrder,conn);
	}
	
	public static void unhold(RepairLaborTime entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_ACTIVATE);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, field_status, keys);
		
		if (!checkHold(entity, conn)) {
			RepairOrder repairOrder = new RepairOrder();
			repairOrder.setId(entity.getId());
			repairOrder.setUpdate_by(entity.getUpdate_by());
			RepairOrder.unhold(repairOrder,conn);
		}
	}
	
	public static boolean checkOpenedJob(RepairLaborTime entity, Connection conn) throws SQLException{
		boolean has = false;
		String sql = "SELECT status FROM " + tableName + " WHERE id='" + entity.getId() + "' AND status='" + RepairLaborTime.STATUS_OPENED_JOB + "'";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		if (rs.next()) {
			has = true;
		}
		rs.close();
		return has;
	}
	
	public static boolean checkActive(RepairLaborTime entity, Connection conn) throws SQLException{
		boolean has = false;
		String sql = "SELECT status FROM " + tableName + " WHERE id='" + entity.getId() + "' AND status='" + RepairLaborTime.STATUS_ACTIVATE + "'";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		if (rs.next()) {
			has = true;
		}
		rs.close();
		return has;
	}
	
	public static boolean checkReject(RepairLaborTime entity, Connection conn) throws SQLException{
		boolean has = false;
		String sql = "SELECT status FROM " + tableName + " WHERE id='" + entity.getId() + "' AND status='" + RepairLaborTime.STATUS_REJECT + "'";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		if (rs.next()) {
			has = true;
		}
		rs.close();
		return has;
	}
	
	public static boolean checkHold(RepairLaborTime entity, Connection conn) throws SQLException{
		boolean has = false;
		String sql = "SELECT status FROM " + tableName + " WHERE id='" + entity.getId() + "' AND status='" + RepairLaborTime.STATUS_HOLDPART + "'";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		if (rs.next()) {
			has = true;
		}
		rs.close();
		return has;
	}
	
	public static void close(RepairLaborTime entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_CLOSED);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, field_status, keys);
		
		/*if (check4Close(entity, conn)) {
			RepairOrder repairOrder = new RepairOrder();
			repairOrder.setId(entity.getId());
			repairOrder.setUpdate_by(entity.getUpdate_by());
			RepairOrder.close(repairOrder,conn);
		}*/
		if (check4Close(entity, conn)) {
			ServiceRepair  servicerepair = new ServiceRepair();
			servicerepair.setId(entity.getId());
			servicerepair.setUpdate_by(entity.getUpdate_by());
			ServiceRepair.close(servicerepair, conn);
			
		}
		
	}
	
	private static boolean check4Close(RepairLaborTime entity, Connection conn) throws SQLException{
		boolean close = true;
		String sql = "SELECT id FROM " + tableName + " WHERE id='" + entity.getId() + "' AND status !='" + RepairLaborTime.STATUS_CLOSED + "' AND status !='" + RepairLaborTime.STATUS_SUBMIT + "'";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		if (rs.next()) {
			close = false;
		}
		rs.close();
		return close;
	}
	
	public static void submit(RepairLaborTime entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setStatus(STATUS_SUBMIT);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, field_submit, keys);
		
		if (check4Submit(entity, conn)) {
			/*RepairOrder repairOrder = new RepairOrder();
			repairOrder.setId(entity.getId());
			repairOrder.setUpdate_by(entity.getUpdate_by());
			RepairOrder.submit(repairOrder,conn);*/
			ServiceRepair serviceRepair = new ServiceRepair();
			serviceRepair.setId(entity.getId());
			serviceRepair.setUpdate_by(entity.getUpdate_by());
			ServiceRepair.submit(serviceRepair,conn);
			
		}
		conn.close();
	}
	
	private static boolean check4Submit(RepairLaborTime entity, Connection conn) throws SQLException{
		boolean close = true;
		String sql = "SELECT id FROM " + tableName + " WHERE id='" + entity.getId() + "' AND status !='" + RepairLaborTime.STATUS_SUBMIT + "'";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		if (rs.next()) {
			close = false;
		}
		return close;
	}
	
	public static void reject(RepairLaborTime entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		entity.setStatus(STATUS_REJECT);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, field_submit, keys);
		
		/*RepairOrder repairOrder = new RepairOrder();
		repairOrder.setId(entity.getId());
		repairOrder.setUpdate_by(entity.getUpdate_by());
		RepairOrder.reject(repairOrder,conn);*/
		
		ServiceRepair serviceRepair = new ServiceRepair();
		serviceRepair.setId(entity.getId());
		serviceRepair.setUpdate_by(entity.getUpdate_by());
		ServiceRepair.reject(serviceRepair,conn);

		RepairLaborMechanic laborMec = new RepairLaborMechanic();
		laborMec.setId(entity.getId());
		laborMec.setNumber(entity.getNumber());
		laborMec.setLabor_id(entity.getLabor_id());
		RepairLaborMechanic.reject(laborMec, conn);
		conn.close();
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

	public String getUnit_price() {
		return unit_price;
	}

	public void setUnit_price(String unit_price) {
		this.unit_price = unit_price;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
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

	public List<RepairLaborMechanic> getUIMechanicList() {
		return mechanicList;
	}

	public void setUIMechanicList(List<RepairLaborMechanic> mechanicList) {
		this.mechanicList = mechanicList;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
}