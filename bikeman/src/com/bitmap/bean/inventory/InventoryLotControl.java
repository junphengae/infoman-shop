package com.bitmap.bean.inventory;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import com.bitmap.bean.hr.Personal;
import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;

public class InventoryLotControl {
	public static String tableName = "inv_lot_control";
	public static String[] keys = {"lot_no","lot_id"};
	public static String[] fieldNames = {"request_no","request_type","request_qty","control_status","update_by","update_date","request_by","request_date"};
	
	String lot_no = "";
	String lot_id = "";
	String lot_balance = "";
	String request_no = "";
	String request_type = "";
	String request_qty = "";
	String control_status = "";
	String request_by = "";
	Date request_date = null;
	Timestamp create_date = DBUtility.getDBCurrentDateTime();
	String update_by = "";
	Timestamp update_date = null;
	private InventoryLot UILot = new InventoryLot();
	private Personal UIPersonal = new Personal();
	
	String UIqty = "";
	
	public Personal getUIPersonal() {
		return UIPersonal;
	}

	public void setUIPersonal(Personal uIPersonal) {
		UIPersonal = uIPersonal;
	}

	public static String sumPD(String mat_code,String pro_id, Connection conn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT SUM(inv_lot_control.request_qty) as sumOut FROM inv_lot_control,inv_lot WHERE inv_lot_control.lot_no = inv_lot.lot_no AND inv_lot_control.request_no = '" + pro_id +"' AND inv_lot.mat_code = '" + mat_code + "' GROUP BY inv_lot.mat_code";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		String sumOut = new String();
		if (rs.next()) {
			sumOut = DBUtility.getString("sumOut", rs);
		}else{
			sumOut = "0";
		}
		rs.close();
		st.close();
		
		return sumOut;
	}


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
	
	public static String selectLot(String auto_id) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		InventoryLotControl entity = new InventoryLotControl();
		entity.setRequest_no(auto_id);
		entity.setRequest_type("SV");
		DBUtility.getEntityFromDB(conn,tableName,entity,new String[] {"request_no","request_type"});
		conn.close();
		return entity.getLot_no();
	}
	
	public static String selectSerialFromAutoid(String auto_id) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT l.serial FROM " + tableName + " lc,inv_lot l WHERE lc.request_no='" + auto_id + "' AND lc.request_type = 'SV' AND lc.lot_no = l.lot_no";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		String serial = "";
		//System.out.println(sql);
		if (rs.next()) {
			serial = DBUtility.getString("serial", rs);
		}
		rs.close();
		st.close();
		conn.close();
		return serial;
	}
	
	public static InventoryLotControl selectMaxLotid(String lot_no, Connection conn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		InventoryLotControl entity = new InventoryLotControl();
		String sql = "SELECT * FROM " + tableName + " WHERE lot_no='" + lot_no + "' order by (lot_id*1) DESC";
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
		String sql = "SELECT * FROM " + tableName + " WHERE lot_no='" + lot_no + "' AND control_status='A' ORDER BY lot_id ASC";
		//System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		if (rs.next()) {
			DBUtility.bindResultSet(entity, rs);
		}
		rs.close();
		st.close();
		
		return entity;
	}
	
	public static void insertAfterWithdraw_2(Connection conn,InventoryLotControl entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		int id = Integer.parseInt(entity.getLot_id())+1;										
		entity.setLot_id(""+id);
		entity.setControl_status("A");
		DBUtility.insertToDB(conn, tableName, new String[]{"mat_code","branch_id","lot_no","lot_id","lot_balance","control_status","create_date"},entity);
	}
	
	public static void withdraw(InventoryLotControl entity, InventoryMaster master) throws SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		Double lotBalance = Double.parseDouble(entity.getLot_balance());
		Double reqQty = Double.parseDouble(entity.getRequest_qty());		
		if(lotBalance.equals(reqQty)){
			//update status i		
			entity.setRequest_qty(Money.moneyNoCommas(reqQty));			
			entity.setControl_status("I");
			entity.setRequest_date(DBUtility.getCurrentDate());
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"request_type","request_no","request_qty","control_status","request_by","request_date","update_by","update_date"}, new String[]{"lot_id","lot_no"});
			InventoryLot.updateIStatus(conn, entity);
		}else{
			//update status c			
			entity.setControl_status("C");
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			entity.setRequest_date(DBUtility.getCurrentDate());
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"request_type","request_no","request_qty","control_status","request_by","request_date","update_by","update_date"}, new String[]{"lot_id","lot_no"});
			entity.setLot_balance(Money.moneyNoCommas(lotBalance-reqQty));
			insertAfterWithdraw(conn, entity);
		}
		
		master.setBalance(InventoryLot.selectActiveSum(master.getMat_code(), conn));
		InventoryMaster.updateBalance(master, conn);
		
		conn.close();
	}
	
	public static void insertAfterWithdraw(Connection conn,InventoryLotControl entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setLot_id(Money.add(entity.getLot_id(),"1"));
		entity.setControl_status("A");
		DBUtility.insertToDB(conn, tableName, new String[]{"lot_no","lot_id","lot_balance","control_status","create_date"}, entity);
	}
	
	public static void updateStatus2A(Connection conn,InventoryLotControl entity) throws IllegalAccessException, InvocationTargetException, SQLException{									
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"lot_balance","update_by","update_date"},new String[] {"lot_no","lot_id"});
	}
	
	public static void updateStatus2I(Connection conn,InventoryLotControl entity) throws IllegalAccessException, InvocationTargetException, SQLException{									
		entity.setControl_status("C");
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"lot_balance","control_status","update_by","update_date"},new String[] {"lot_no","lot_id"});
			
		InventoryLot lot = new InventoryLot();
		lot.setLot_no(entity.getLot_no());	
		lot.setLot_status("A");
		lot.setUpdate_by(entity.getUpdate_by());
		lot.setUpdate_date(DBUtility.getDBCurrentDateTime());
		InventoryLot.updateAStatus(conn, lot);
	}
	
	/**
	 * whan : report_review
	 * <br> 
	 * เพิ่มค้นหาด้วย matcode 
	 * @param year
	 * @param month
	 * @param mat_code
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<InventoryLotControl> report(String year, String month,String mat_code) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		Calendar sd = Calendar.getInstance();
		sd.clear();
		sd.set(Calendar.YEAR, Integer.parseInt(year));
		sd.set(Calendar.MONTH, Integer.parseInt(month) - 1);
		sd.set(Calendar.DATE, 1);
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		
		String s = df.format(sd.getTime());
		
		sd.add(Calendar.MONTH, +1);
		sd.add(Calendar.DATE, -1);
		String e = df.format(sd.getTime());
			
		String sql = "SELECT lotc.* FROM inv_lot_control as lotc,inv_lot as lot WHERE lotc.request_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99' AND lotc.lot_no = lot.lot_no";
		////System.out.println("m : " + sql);
		if(!(mat_code.equalsIgnoreCase(""))){
			sql += " AND lot.mat_code = '" + mat_code + "'";
		}
		sql += " ORDER BY (lotc.lot_no*1)";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryLotControl> list = new ArrayList<InventoryLotControl>();
		while (rs.next()) {
			InventoryLotControl entity = new InventoryLotControl();
			DBUtility.bindResultSet(entity, rs);
			entity.setUILot(InventoryLot.select(entity.getLot_no(), conn));
			entity.setUIPersonal(Personal.selectOnlyPerson(entity.getRequest_by(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		
		return list;
	}
	
	
	public static List<InventoryLotControl> report(Date d,String mat_code) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		
		String s = df.format(d.getTime());
		String e = df.format(d.getTime());
		
		String sql = "SELECT lotc.* FROM inv_lot_control as lotc,inv_lot as lot WHERE lotc.request_date BETWEEN '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99' AND lotc.lot_no = lot.lot_no";
		////System.out.println("d : " + sql);
		if(!(mat_code.equalsIgnoreCase(""))){
			sql += " AND lot.mat_code = '" + mat_code + "'";
		}
		sql += " ORDER BY (lotc.lot_no*1)";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryLotControl> list = new ArrayList<InventoryLotControl>();
		while (rs.next()) {
			InventoryLotControl entity = new InventoryLotControl();
			DBUtility.bindResultSet(entity, rs);
			entity.setUILot(InventoryLot.select(entity.getLot_no(), conn));
			entity.setUIPersonal(Personal.selectOnlyPerson(entity.getRequest_by(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		
		return list;
	}
	
	public static int sumOutlet(String request_no) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		String sql = "SELECT sum(request_qty) as qty FROM " + tableName + " WHERE request_no = '" + request_no  + "'";
		////System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		int val = 0;
		while (rs.next()){
			val = DBUtility.getInteger("qty", rs);
		}
		conn.close();
		return val;
	}
	
	public static List<InventoryLotControl> outletReport(List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "select *,sum(request_qty) as qty from inv_lot_control where request_no != '' AND request_type = 'IV'";	
		Iterator<String[]> ite = paramList.iterator();
		String m = "";
		String y = "";
		
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("year")){
					y = str[1];
				} else 
				if (str[0].equalsIgnoreCase("month")) {
					m = str[1];
				}
			}
		}
		
		if (m.length() > 0) {
			Calendar sd = Calendar.getInstance();
			sd.clear();
			sd.set(Calendar.YEAR, Integer.parseInt(y));
			sd.set(Calendar.MONTH, Integer.parseInt(m) - 1);
			sd.set(Calendar.DATE, 1);
			
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			
			String s = df.format(sd.getTime());
			
			sd.add(Calendar.MONTH, +1);
			sd.add(Calendar.DATE, -1);
			String e = df.format(sd.getTime());
			
			sql += " AND (create_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99')";
		} else {
			if (y.length() > 0) {
				sql += " AND (create_date between '" + y + "-01-01 00:00:00.00' AND '" + y + "-12-31 23:59:59.99')";
			}
		}
		
		sql += "  group by lot_no ORDER BY (request_no*1) ASC";
		////System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryLotControl> list = new ArrayList<InventoryLotControl>();
		while (rs.next()) {
			InventoryLotControl entity = new InventoryLotControl();
			DBUtility.bindResultSet(entity, rs);
			
			entity.setUIPersonal(Personal.selectOnlyPerson(entity.getRequest_by(), conn));
			entity.setUIqty(DBUtility.getString("qty", rs));
			list.add(entity);
		}
		st.close();
		rs.close();
		conn.close();
		return list;
	}
	
	/**
	 * Gen Report for Approve PR
	 * @param mat_code
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static String reportSUM4PR(String mat_code) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		Calendar today = Calendar.getInstance();
		today.setTime(DBUtility.getCurrentDate());
		//today.set(Calendar.DATE, 1);
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		
		String e = df.format(today.getTime());
		
		today.add(Calendar.MONTH, -3);
		String s = df.format(today.getTime());
		
		String sql = "SELECT SUM(inv_lot_control.request_qty) as sum FROM " + tableName + ",inv_lot WHERE inv_lot_control.lot_no = inv_lot.lot_no AND (inv_lot_control.request_date between '" + s + " 00:00:00.00' AND '" + e + " 00:00:00.00') AND inv_lot.mat_code='" + mat_code + "' GROUP BY inv_lot.mat_code";
		//"SELECT SUM(inv_lot_control.request_qty) as sumOut FROM inv_lot_control,inv_lot WHERE inv_lot_control.lot_no = inv_lot.lot_no AND inv_lot_control.request_no = '" + pro_id +"' AND inv_lot.mat_code = '" + mat_code + "' GROUP BY inv_lot.mat_code";
		////System.out.println("m : " + sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String sum = "0";
		
		if (rs.next()) {
			sum = DBUtility.getString("sum", rs);
		}
		rs.close();
		st.close();
		conn.close();
		
		return sum;
	}
	/**
	 * whan : OutletManagement.withdraw_for_sell
	 * <br>
	 * @param request_no
	 * @return
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static int sumTakelot(String request_no) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT sum(request_qty) as qty FROM " + tableName + " WHERE request_no = '" + request_no  + "' AND request_type ='IV'";
		////System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		int val = 0;
		while (rs.next()){
			val = DBUtility.getInteger("qty", rs);
		}
		conn.close();
		return val;
	}
	
	public static String sum(String mat_code) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT SUM(lot_balance) as sumOut FROM " + tableName + " WHERE mat_code = '" + mat_code + "' AND control_status='A'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		String sumOut = new String();
		if (rs.next()) {
			sumOut = DBUtility.getString("sumOut", rs);
		}else{
			sumOut = "0";
		}
		rs.close();
		st.close();
		return sumOut;
	}
	
	public static InventoryLotControl select(String request_no) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE request_no ='" + request_no + "' AND request_type = 'IV'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);

		InventoryLotControl entity = new InventoryLotControl();
		
		while(rs.next()) {
			DBUtility.bindResultSet(entity, rs);
		}
		rs.close();
		st.close();
		conn.close();
		return entity;
	}
	
	public static void withdraw_ins(InventoryLotControl entity, InventoryMaster master) throws SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		Double lotBalance = Double.parseDouble(entity.getLot_balance());
		Double reqQty = Double.parseDouble(entity.getRequest_qty());
		////System.out.println(lotBalance + ":" + reqQty);
		if(lotBalance.equals(reqQty)){
			//update status i		
			entity.setRequest_qty(Money.moneyNoCommas(reqQty));			
			entity.setControl_status("I");
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"request_type","request_no","request_qty","control_status","request_by","request_date","update_by","update_date"}, new String[]{"lot_id","lot_no"});
			InventoryLot.updateIStatus(conn, entity);
		}else{
			//System.out.println("-------");
			//update status c			
			entity.setControl_status("C");
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			//System.out.println(entity.getLot_id() + ":::" + entity.getLot_no());
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"request_type","request_no","request_qty","control_status","request_by","request_date","update_by","update_date"}, new String[]{"lot_id","lot_no"});
			entity.setLot_balance(Money.moneyNoCommas(lotBalance-reqQty));
			////System.out.println(entity.getLot_balance());
			insertAfterWithdraw(conn, entity);
		}
		
		master.setBalance(InventoryLot.selectActiveSum(master.getMat_code(), conn));
		InventoryMaster.updateBalance(master, conn);
		
		conn.close();
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
	public Date getRequest_date() {
		return request_date;
	}
	public void setRequest_date(Date request_date) {
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

	public InventoryLot getUILot() {
		return UILot;
	}

	public void setUILot(InventoryLot uILot) {
		UILot = uILot;
	}

	public String getUIqty() {
		return UIqty;
	}

	public void setUIqty(String uIqty) {
		UIqty = uIqty;
	}
}