package com.bitmap.bean.sale;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class Vehicle {
	public static String tableName = "mk_vehicle";
	private static String[] keys = {"id"};
	private static String[] fieldNames = {"master_id","license_plate","vin","engine_no",
		"color","note","cus_id","vehicle_type","purchase_status","update_by","update_date"};
	private static String[] fieldUpdate = {"license_plate","vin","engine_no",
		"color","note","cus_id","vehicle_type","purchase_status","update_by","update_date"};
	
	String id = "";
	String master_id = "";
	String license_plate = "";
	String vin = "";
	String engine_no = "";
	String color = "";
	String note = "";
	String cus_id = "";
	String vehicle_type = "";
	String purchase_status = "";
	String create_by = "";
	String update_by = "";
	Timestamp create_date = null;
	Timestamp update_date = null;
	
	
	VehicleMaster UIMaster = new VehicleMaster();
	public VehicleMaster getUIMaster() 
	{return UIMaster;
	}
	public void setUIMaster(VehicleMaster uIMaster) 
	{
		UIMaster = uIMaster;
	}
	
	public static List<String[]> listOfVehicleType(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{"New","01"});
		list.add(new String[]{"Used","02"});
		list.add(new String[]{"Consignment","03"});
		return list;
	}
	
	public static List<String> listOfPurchaseType(){
		List<String> list = new ArrayList<String>();
		list.add("Building");
		list.add("Exporting");
		list.add("Shipping");
		list.add("Custom");
		list.add("PDI");
		list.add("Receipt");
		return list;
	}
	
	public static Vehicle select(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		Vehicle entity = new Vehicle();
		entity.setId(id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIMaster(VehicleMaster.select(entity.getMaster_id(),conn));
		conn.close();
		return entity;
	}
	
	
	
	public static Vehicle select(Vehicle entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static List<Vehicle> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT " +
						"* " +
					"FROM " + tableName + " vehicle " +
						" LEFT JOIN " + Customer.tableName + " cus ON vehicle.cus_id = cus.cus_id " + 
						" LEFT JOIN " + VehicleMaster.tableName + " vmaster ON vehicle.master_id = vmaster.id  " +
						" LEFT JOIN " + Brands.tableName + " brand ON brand.brand_id = vmaster.brand " +
						" LEFT JOIN " + Models.tableName + " model ON model.model_id = vmaster.model " +
					"  WHERE 1=1 ";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("keyword")){
					sql += "AND (cus.cus_name_th LIKE '%" + str[1] + "%' OR " +
							   "cus.cus_surname_th LIKE '%" + str[1] + "%' OR " +
							   "cus.cus_email LIKE '%" + str[1] + "%' OR " +
							   "cus.cus_phone LIKE '%" + str[1] + "%' OR " +
							   "cus.cus_mobile LIKE '%" + str[1] + "%' OR " +
							   "cus.cus_id_card LIKE '%" + str[1] + "%' OR " +
							   "vehicle.license_plate LIKE '%" + str[1] + "%' OR " + 
							   "vehicle.vin LIKE '%" + str[1] + "%' OR " + 
							   "vehicle.engine_no LIKE '%" + str[1] + "%' OR " + 
						       "vmaster.nameplate LIKE '%" + str[1] + "%' OR " + 
						       "brand.brand_name LIKE '%" + str[1] + "%' OR " + 
						       "model.model_name LIKE '%" + str[1] + "%') ";
				} else if(str[0].equalsIgnoreCase("brand")) {
					sql += "AND brand.brand_id = '" + str[1] + "' "; 
				} else {
					sql += "AND vehicle." + str[0] + "='" + str[1] + "' ";
				}
			}
		}
		
		sql += "ORDER BY brand.brand_name ASC, vehicle.license_plate ASC";
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Vehicle> list = new ArrayList<Vehicle>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Vehicle entity = new Vehicle();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIMaster(VehicleMaster.select(entity.getMaster_id(),conn));
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		st.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
	
	public static List<Vehicle> selectByCusID(String cus_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE cus_id ='" + cus_id + "'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Vehicle> list = new ArrayList<Vehicle>();
		while (rs.next()){
			Vehicle entity = new Vehicle();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIMaster(VehicleMaster.select(entity.getMaster_id(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<Vehicle> pageList(PageControl ctrl,String search) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName;
		if (search.length() > 0) {
			sql += " WHERE license_plate LIKE '%" + search + "%' OR " +
				   "vin LIKE '%" + search + "%' OR " +
				   "nameplate LIKE '%" + search + "%'";
		}
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Vehicle> list = new ArrayList<Vehicle>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Vehicle entity = new Vehicle();
					DBUtility.bindResultSet(entity, rs);
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		st.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
	
	public static List<Vehicle> pageList4CusService(PageControl ctrl,String search) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " vehicle";
		if (search.length() > 0) {
			sql += " LEFT JOIN " + Customer.tableName + " cus ON vehicle.cus_id = cus.cus_id " + 
			" LEFT JOIN " + VehicleMaster.tableName + " vmaster ON vehicle.master_id = vmaster.id  " +
			" LEFT JOIN " + Brands.tableName + " brand ON brand.brand_id = vmaster.brand " +
			" LEFT JOIN " + Models.tableName + " model ON model.model_id = vmaster.model " +
			" WHERE " +
				   "cus.cus_name_en LIKE '%" + search + "%' OR " +
				   "cus.cus_surname_en LIKE '%" + search + "%' OR " +
				   "cus.cus_name_th LIKE '%" + search + "%' OR " +
				   "cus.cus_surname_th LIKE '%" + search + "%' OR " +
				   "cus.cus_email LIKE '%" + search + "%' OR " +
				   "cus.cus_phone LIKE '%" + search + "%' OR " +
				   "cus.cus_mobile LIKE '%" + search + "%' OR " +
				   "cus.cus_id_card LIKE '%" + search + "%' OR " +
				   "vehicle.license_plate LIKE '%" + search + "%' OR " + 
			       "vehicle.vin LIKE '%" + search + "%' OR " + 
			       "vmaster.nameplate LIKE '%" + search + "%' OR " + 
			       "brand.brand_name LIKE '%" + search + "%' OR " + 
			       "model.model_name LIKE '%" + search + "%'";
		}
		sql += " ORDER BY vehicle.license_plate";
		////System.out.println("sql: " + sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Vehicle> list = new ArrayList<Vehicle>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Vehicle entity = new Vehicle();
					//DBUtility.bindResultSet(entity, rs);
					bindRS(entity, rs);
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		st.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
	
	private static void bindRS(Vehicle entity, ResultSet rs) throws SQLException{
		entity.setId(rs.getString("vehicle.id"));
		entity.setCus_id(rs.getString("vehicle.cus_id"));
		entity.setMaster_id(rs.getString("vehicle.master_id"));
		entity.setLicense_plate(rs.getString("vehicle.license_plate"));
		entity.setVin(rs.getString("vehicle.vin"));
		entity.setEngine_no(rs.getString("vehicle.engine_no"));
	}
	
	
	
	public static String genVehicleId(Connection conn) throws SQLException{
		String id = "v000001";
		String sql = "SELECT id FROM " + tableName + " ORDER BY id DESC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		if (rs.next()) {
			String data = rs.getString(1);
			String temp = (Integer.parseInt(data.substring(1, data.length())) + 1000001) + "";
			id = "v" + temp.substring(1, temp.length());
		}
		rs.close();
		st.close();
		return id;
	}
	
	public static Vehicle insert(Vehicle entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setId(genVehicleId(conn));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
		return entity;
	}
	
	public static void update(Vehicle entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public static void vUpdate(Vehicle entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldUpdate, keys);
		conn.close();
	}
	
	public static void updateInfo(Vehicle entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"license_plate","vin","engine_no","color","update_by","update_date"}, keys);
		conn.close();
	}
	
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getLicense_plate() {
		return license_plate;
	}
	public void setLicense_plate(String license_plate) {
		this.license_plate = license_plate;
	}
	public String getVin() {
		return vin;
	}
	public void setVin(String vin) {
		this.vin = vin;
	}
	public String getEngine_no() {
		return engine_no;
	}
	public void setEngine_no(String engine_no) {
		this.engine_no = engine_no;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
	}
	public String getCus_id() {
		return cus_id;
	}
	public void setCus_id(String cus_id) {
		this.cus_id = cus_id;
	}
	public String getMaster_id() {
		return master_id;
	}
	public void setMaster_id(String master_id) {
		this.master_id = master_id;
	}
	public String getVehicle_type() {
		return vehicle_type;
	}
	public void setVehicle_type(String vehicle_type) {
		this.vehicle_type = vehicle_type;
	}
	public String getPurchase_status() {
		return purchase_status;
	}
	public void setPurchase_status(String purchase_status) {
		this.purchase_status = purchase_status;
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