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

public class VehicleMaster {
	public static final String tableName = "mk_vehicle_master";
	private static String[] keys = {"id"};
	private static String[] fields = {"brand","model","nameplate","year","note","engine","engine_cc","horsepower","torque","transmission","brake_front","brake_rear","d_length","d_width","d_height","d_wheelbase","update_by","update_date"};
	
	String id = ""; 
	String brand = "";
	String model = "";
	String nameplate = "";
	String year = "";
	String note = "";
	String engine = "";
	String engine_cc = "";
	String horsepower = "";
	String torque = "";
	String transmission = "";
	String brake_front = "";
	String brake_rear = "";
	String d_length = "";
	String d_width = "";
	String d_height = "";
	String d_wheelbase = "";
	String create_by = "";
	String update_by = "";
	Timestamp create_date = null;
	Timestamp update_date = null;
	
	String UIBrand = "";
	String UIModel = "";
	String UINameplate = "";
	
	public String getUIBrand() {
		return UIBrand;
	}

	public void setUIBrand(String uIBrand) {
		UIBrand = uIBrand;
	}

	public String getUIModel() {
		return UIModel;
	}

	public void setUIModel(String uIModel) {
		UIModel = uIModel;
	}

	public String getUINameplate() {
		return UINameplate;
	}

	public void setUINameplate(String uINameplate) {
		UINameplate = uINameplate;
	}

	/*
	OptPowerGen optPowerGen = new OptPowerGen();
	OptChassis optChassis = new OptChassis();
	OptCooling optCooling = new OptCooling();
	OptInterior optInterior = new OptInterior();
	OptBody optBody = new OptBody();
	OptExterior optExterior = new OptExterior();
	OptElectrical optElectrical = new OptElectrical();
	OptSafe optSafe = new OptSafe();
	
	public static String genDetail(String headList, VehicleMaster entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		String detail = "";
		if (headList.equalsIgnoreCase("baseInfo")) {
			detail = detail(entity);
		} else if(headList.equalsIgnoreCase("optPowerGen")) {
			detail = OptPowerGen.detail(entity);
		} else if(headList.equalsIgnoreCase("optChassis")) {
			detail = OptChassis.detail(entity);
		} else if(headList.equalsIgnoreCase("optCooling")) {
			detail = OptCooling.detail(entity);
		} else if(headList.equalsIgnoreCase("optInterior")) {
			detail = OptInterior.detail(entity);
		} else if(headList.equalsIgnoreCase("optBody")) {
			detail = OptBody.detail(entity);
		} else if(headList.equalsIgnoreCase("optExterior")) {
			detail = OptExterior.detail(entity);
		} else if(headList.equalsIgnoreCase("optElectrical")) {
			detail = OptElectrical.detail(entity);
		} else if(headList.equalsIgnoreCase("optSafe")) {
			detail = OptSafe.detail(entity);
		}
		
		return detail;
	}
	*/
	public static String detail(VehicleMaster entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		String html = "";
		html += setDetail("Brand",Brands.getUIName(entity.getBrand()));
		html += setDetail("Model",Models.getUIName(entity.getModel()));
		html += setDetail("Nameplate",entity.getNameplate());
		html += setDetail("Year",entity.getYear());
		html += setDetail("Note",entity.getNote());
		return html;
	}
	
	public static String setDetail(String head, String detail){
		String str = "<div class=\"model_head\">" + head + "</div>" + 
					 "<div class=\"model_body\">" + 
					 "<div class=\"item_wrap\">" +
					 "<div class=\"item\">" + detail + "</div>" +
					 "</div></div>";
		return str;
	}
	
	public static List<String[]> optList(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{"baseInfo","Base Information"});
		list.add(new String[]{"optPowerGen","Power Generation"});
		list.add(new String[]{"optChassis","Chassis"});
		list.add(new String[]{"optCooling","Cooling &amp; HVAC"});
		list.add(new String[]{"optInterior","Interior"});
		list.add(new String[]{"optBody","Body &amp; Paint"});
		list.add(new String[]{"optExterior","Exterior"});
		list.add(new String[]{"optElectrical","Electrical"});
		list.add(new String[]{"optSafe","Security &amp; Safety"});
		return list;
	}
	
	public static VehicleMaster select(VehicleMaster entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIBrand(Brands.getUIName(entity.getBrand(), conn));
		entity.setUIModel(Models.getUIName(entity.getModel(), conn));
		entity.setUINameplate(Models.getUIName(entity.getNameplate(), conn));
		conn.close();
		return entity;
	}
	
	public static VehicleMaster select(String id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		VehicleMaster entity = new VehicleMaster();
		entity.setId(id);
		
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIBrand(Brands.getUIName(entity.getBrand(), conn));
		entity.setUIModel(Models.getUIName(entity.getModel(), conn));
		entity.setUINameplate(Models.getUIName(entity.getNameplate(), conn));
		return entity;
	}
	
	public static VehicleMaster select(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		VehicleMaster entity = new VehicleMaster();
		entity.setId(id);
		
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIBrand(Brands.getUIName(entity.getBrand(), conn));
		entity.setUIModel(Brands.getUIName(entity.getModel(), conn));
		entity.setUINameplate(Models.getUIName(entity.getNameplate(), conn));
		conn.close();
		return entity;
	}
	
	public static List<VehicleMaster> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("keyword")){
					sql += " AND (nameplate like'%" + str[1] + "%' " +
						   " OR year like'%" + str[1] + "%')";
				} else {
					sql += " AND " + str[0] + "='" + str[1] + "'";
				}
			}
		}
		
		sql += " ORDER BY brand ASC";
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<VehicleMaster> list = new ArrayList<VehicleMaster>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					VehicleMaster entity = new VehicleMaster();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIBrand(Brands.getUIName(entity.getBrand(), conn));
					entity.setUIModel(Models.getUIName(entity.getModel(), conn));
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
	
	public static List<VehicleMaster> selectList(List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				sql += " AND " + str[0] + "='" + str[1] + "'";
			}
		}
		
		sql += " ORDER BY brand ASC";
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<VehicleMaster> list = new ArrayList<VehicleMaster>();
		
		while (rs.next()) {
			VehicleMaster entity = new VehicleMaster();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIBrand(Brands.getUIName(entity.getBrand(), conn));
			entity.setUIModel(Models.getUIName(entity.getModel(), conn));
			entity.setUINameplate(Models.getUIName(entity.getNameplate(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	/*
	public static VehicleMaster selectDetail(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		VehicleMaster entity = new VehicleMaster();
		entity.setId(id);
		
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		setUIAll(entity, conn);
		conn.close();
		return entity;
	}
	
	public static List<VehicleMaster> list(Connection conn, String brand,String model) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE brand = '" + brand + "' AND model = '" + model + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<VehicleMaster> list = new ArrayList<VehicleMaster>();
		while (rs.next()) {
			VehicleMaster entity = new VehicleMaster();
			DBUtility.bindResultSet(entity, rs);
			setUIAll(entity,conn);
			list.add(entity);
		}
		rs.close();
		st.close();
		return list;
	}
	
	public static List<VehicleMasterEntity> search(String brand,String model) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE brand = '" + brand + "'";
		if (model.length() > 0) {
			sql +=  " AND model = '" + model + "'";
		}
		sql += " ORDER BY model";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<VehicleMasterEntity> list = new ArrayList<VehicleMasterEntity>();
		while (rs.next()) {
			VehicleMasterEntity entity = new VehicleMasterEntity();
			DBUtility.bindResultSet(entity, rs);
			entity.setBrand_name(Brands.getUIName(entity.getBrand()));
			entity.setModel_name(Models.getUIName(entity.getModel()));
			list.add(entity);
		}
		conn.close();
		return list;
	}
	
	private static void setUIAll(VehicleMaster entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		entity.setUIOptPowerGen(OptPowerGen.select(entity.getId()));
		entity.setUIOptBody(OptBody.select(entity.getId()));
		entity.setUIOptChassis(OptChassis.select(entity.getId()));
		entity.setUIOptCooling(OptCooling.select(entity.getId()));
		entity.setUIOptElectrical(OptElectrical.select(entity.getId()));
		entity.setUIOptExterior(OptExterior.select(entity.getId()));
		entity.setUIOptInterior(OptInterior.select(entity.getId()));
		entity.setUIOptSafe(OptSafe.select(entity.getId()));
	}
	
	private static void setUIAll(VehicleMaster entity, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		entity.setUIOptPowerGen(OptPowerGen.select(entity.getId(),conn));
		entity.setUIOptBody(OptBody.select(entity.getId(),conn));
		entity.setUIOptChassis(OptChassis.select(entity.getId(),conn));
		entity.setUIOptCooling(OptCooling.select(entity.getId(),conn));
		entity.setUIOptElectrical(OptElectrical.select(entity.getId(),conn));
		entity.setUIOptExterior(OptExterior.select(entity.getId(),conn));
		entity.setUIOptInterior(OptInterior.select(entity.getId(),conn));
		entity.setUIOptSafe(OptSafe.select(entity.getId(),conn));
	}
	*/
	public static List<VehicleMaster> pageList(PageControl ctrl,String search) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName;
		if (search.length() > 0) {
			sql += " WHERE nameplate LIKE '%" + search + "%'";
		}
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<VehicleMaster> list = new ArrayList<VehicleMaster>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					VehicleMaster entity = new VehicleMaster();
					DBUtility.bindResultSet(entity, rs);
					list.add(entity);
				}
				cnt++;
			}
			
		}
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
	
	public static String genVehicleId() throws SQLException{
		String id = "v000001";
		Connection conn = DBPool.getConnection();
		String sql = "SELECT id FROM " + tableName + " ORDER BY id DESC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		if (rs.next()) {
			String data = rs.getString(1);
			String temp = (Integer.parseInt(data.substring(1, data.length())) + 1000001) + "";
			id = "v" + temp.substring(1, temp.length());
		}
		conn.close();
		return id;
	}
	
	private static boolean check(String id, Connection conn) throws SQLException{
		String sql = "SELECT id FROM " + tableName + " WHERE id='" + id + "'";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		boolean has = false;
		while (rs.next()) {
			has = true;
		}
		return has;
	}
	/*
	public static VehicleMaster insert(VehicleMaster entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		
		// check id
		if (entity.getId()!=null) {
			if (check(entity.getId(),conn)) { // check in database
				update(entity);
			} else {
				entity.setId(genVehicleId());
				entity.setCreate_date(DBUtility.getDBCurrentDateTime());
				DBUtility.insertToDB(conn, tableName, entity);
			}
		} else { // insert new vehicle
			entity.setId(genVehicleId());
			entity.setCreate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.insertToDB(conn, tableName, entity);
		}
		
		conn.close();
		return entity;
	}*/
	
	public static void insert(VehicleMaster entity) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();
		entity.setId(genVehicleId());
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static void update(VehicleMaster entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fields, keys);
		conn.close();
	}
	/*
	public OptPowerGen getUIOptPowerGen() {
		return optPowerGen;
	}
	public void setUIOptPowerGen(OptPowerGen optPowerGen) {
		this.optPowerGen = optPowerGen;
	}
	public OptChassis getUIOptChassis() {
		return optChassis;
	}
	public void setUIOptChassis(OptChassis optChassis) {
		this.optChassis = optChassis;
	}
	public OptCooling getUIOptCooling() {
		return optCooling;
	}
	public void setUIOptCooling(OptCooling optCooling) {
		this.optCooling = optCooling;
	}
	public OptInterior getUIOptInterior() {
		return optInterior;
	}
	public void setUIOptInterior(OptInterior optInterior) {
		this.optInterior = optInterior;
	}
	public OptBody getUIOptBody() {
		return optBody;
	}
	public void setUIOptBody(OptBody optBody) {
		this.optBody = optBody;
	}
	public OptExterior getUIOptExterior() {
		return optExterior;
	}
	public void setUIOptExterior(OptExterior optExterior) {
		this.optExterior = optExterior;
	}
	public OptSafe getUIOptSafe() {
		return optSafe;
	}
	public void setUIOptSafe(OptSafe optSafe) {
		this.optSafe = optSafe;
	}
	public OptElectrical getUIOptElectrical() {
		return optElectrical;
	}
	public void setUIOptElectrical(OptElectrical optElectrical) {
		this.optElectrical = optElectrical;
	}
	*/
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getBrand() {
		return brand;
	}
	public void setBrand(String brand) {
		this.brand = brand;
	}
	public String getModel() {
		return model;
	}
	public void setModel(String model) {
		this.model = model;
	}
	public String getNameplate() {
		return nameplate;
	}
	public void setNameplate(String nameplate) {
		this.nameplate = nameplate;
	}
	public String getYear() {
		return year;
	}
	public void setYear(String year) {
		this.year = year;
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

	public String getEngine() {
		return engine;
	}

	public void setEngine(String engine) {
		this.engine = engine;
	}

	public String getEngine_cc() {
		return engine_cc;
	}

	public void setEngine_cc(String engine_cc) {
		this.engine_cc = engine_cc;
	}

	public String getHorsepower() {
		return horsepower;
	}

	public void setHorsepower(String horsepower) {
		this.horsepower = horsepower;
	}

	public String getTorque() {
		return torque;
	}

	public void setTorque(String torque) {
		this.torque = torque;
	}

	public String getTransmission() {
		return transmission;
	}

	public void setTransmission(String transmission) {
		this.transmission = transmission;
	}

	public String getBrake_front() {
		return brake_front;
	}

	public void setBrake_front(String brake_front) {
		this.brake_front = brake_front;
	}

	public String getBrake_rear() {
		return brake_rear;
	}

	public void setBrake_rear(String brake_rear) {
		this.brake_rear = brake_rear;
	}

	public String getD_length() {
		return d_length;
	}

	public void setD_length(String d_length) {
		this.d_length = d_length;
	}

	public String getD_width() {
		return d_width;
	}

	public void setD_width(String d_width) {
		this.d_width = d_width;
	}

	public String getD_height() {
		return d_height;
	}

	public void setD_height(String d_height) {
		this.d_height = d_height;
	}

	public String getD_wheelbase() {
		return d_wheelbase;
	}

	public void setD_wheelbase(String d_wheelbase) {
		this.d_wheelbase = d_wheelbase;
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
