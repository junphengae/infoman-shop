package com.bitmap.bean.dc;

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
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import sun.awt.geom.AreaOp.AddOp;

import com.bitmap.bean.hr.Personal;
import com.bitmap.bean.inventory.InventoryLot;
import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.bean.inventory.InventoryMasterVendor;
import com.bitmap.bean.inventory.Vendor;
import com.bitmap.bean.parts.PartMaster;
import com.bitmap.bean.parts.ServicePartDetail;
import com.bitmap.bean.parts.ServiceSale;
import com.bitmap.bean.purchase.PurchaseOrder;
import com.bitmap.bean.purchase.PurchaseRequest;
import com.bitmap.bean.branch.BranchMaster;
import com.bitmap.bean.dc.SaleOrderService;
import com.bitmap.bean.sale.Brands;
import com.bitmap.bean.sale.Models;
import com.bitmap.bean.sale.Vehicle;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class SaleOrderService {

	public static String tableName = "sale_order_service"; 
	public static String[] keys = {"id"};
	public static String[] fieldNames = {"id","service_type","cus_id","cus_name","cus_surname","v_id","v_plate","v_plate_province","total","vat"
	,"discount","total_amount","pay","status","flag_pa","duedate","create_by","create_date","update_by","update_date","brand_id","model_id","job_close_date"};
	
	
	
	public static String STATUS_CANCEL = "00";
	public static String STATUS_OPENING = "10";
	public static String STATUS_REQUEST = "11";
	public static String STATUS_MA_REQUEST = "12";
	public static String STATUS_OUTSOURCE = "15";
	public static String STATUS_CLOSED = "100";//20

	public static String FLAG_CREDIT = "10";
	public static String FLAG_CASH = "20";
	
	public static String SERVICE_SALE_PARTS = "10";
	public static String SERVICE_MA			= "20";

	String id = "";
	String service_type = "";
	String cus_id = "";
	String cus_name = "";
	String cus_surname = "";

	String v_id = "";//Vehicle ID
	String v_plate = "";//Vehicle License Plate
	String v_plate_province = "";//Vehicle License Plate
	String total = "0";
	String vat = "0";
	String discount = "0";
	String total_amount = "0";
	String pay = "0";
	String status = STATUS_OPENING;
	String flag_pay = "";
	Date duedate = null;
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	String brand_id = "";
	String model_id = "";
	Timestamp job_close_date = null;
	String UItime_complete  = "";
	Map UImap = null;
	List UIListDetail = null;
	
	Vehicle UIVehicle = new Vehicle();
	
	public static String status(String status){
		HashMap<String, String> map = new HashMap<String, String>();
		map.put(STATUS_CANCEL, "Cancel");
		map.put(STATUS_CLOSED, "Closed");
		map.put(STATUS_OPENING, "Opening");
		map.put(STATUS_REQUEST, "Request");
		map.put(STATUS_MA_REQUEST, "MA Request");
		map.put(STATUS_OUTSOURCE, "Outsource Service");
		return map.get(status);
	}
	
	public static List<String[]> ddl_en(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{STATUS_OPENING,"Opening"});
		list.add(new String[]{STATUS_REQUEST,"Request"});
		list.add(new String[]{STATUS_MA_REQUEST,"MA Request"});
		list.add(new String[]{STATUS_OUTSOURCE,"Outsource Service"});
		list.add(new String[]{STATUS_CLOSED,"Closed"});
		list.add(new String[]{STATUS_CANCEL,"Cancel"});
		return list;
	}
	public static List<String[]> ddl_draw(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{STATUS_OPENING,"Opening"});
		list.add(new String[]{STATUS_CLOSED,"Closed"});
		return list;
	}	
	
	public static String service(String status){
		HashMap<String, String> map = new HashMap<String, String>();
		map.put(SERVICE_MA, "Maintenance");
		map.put(SERVICE_SALE_PARTS, "Parts");
		return map.get(status);
	}
	
	public static List<String[]> ddl_service_en(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{SERVICE_MA,"Maintenance"});
		list.add(new String[]{SERVICE_SALE_PARTS,"Parts"});
		return list;
	}
	public  static boolean check(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		SaleOrderService entity = new SaleOrderService();
		entity.setId(id);
		return check(entity);
	}
	public  static boolean check(SaleOrderService entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}
	public static void insert(SaleOrderService entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		entity.setId(DBUtility.genNumber(conn, tableName, "id"));
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	
	public static String genId(Connection conn) throws SQLException{
		String sql = "SELECT id FROM " + tableName + " ORDER BY id DESC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		String runno = "0";
		if (rs.next()) {
			String id = DBUtility.getString("id", rs);
		
			runno = (Integer.parseInt(id) + 1)+"";
		}
		
		rs.close();
		st.close();
		return runno;
	}
	
	public static void update_customer(SaleOrderService entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"cus_id","cus_name","cus_surname","v_id","v_plate","update_by","update_date"}, keys);
		conn.close();
	}
	
	public static void save_order(SaleOrderService entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"total_amount","vat","total","update_by","update_date"}, keys);
		conn.close();
	}
	
	public static void confirm_order(SaleOrderService entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"total_amount","vat","total","status","update_by","update_date","cus_name","cus_surname","v_plate","v_plate_province","brand_id","model_id"}, keys);
		conn.close();
	}
	
	public static void update_status(SaleOrderService entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"status","update_by","update_date"}, keys);
		conn.close();
	}
	
	public static void updateStatus(SaleOrderService entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"status","vat","update_by","update_date"}, keys);
		conn.close();
	}

	public static void closeJob(SaleOrderService entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		//System.out.println("id::"+entity.getId());
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setJob_close_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(SaleOrderService.STATUS_CLOSED);
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"status","update_by","update_date","job_close_date"}, keys);
		conn.close();
	}
	
	public static List<SaleOrderService> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT *, " +
				"				concat('',TIMEDIFF(job_close_date , create_date )) as complete ,  " +
				"				concat('', TIMESTAMPDIFF(MINUTE, create_date,job_close_date  )) as complete_minute ,  " +
				"				concat('',DATEDIFF(job_close_date , create_date )) as complete_date " +
				"			FROM " + tableName + " WHERE 1=1 and status <> " +STATUS_CANCEL;
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("search")) {
					sql += " AND (cus_name like'%" + str[1] + "%' " +
						   " OR v_plate like'%" + str[1] + "%')";
				} else {
					//sql += " AND " + str[0] + "='" + str[1] + "'";
				}
			}
		}
		sql += " ORDER BY (id*1) desc";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOrderService> list = new ArrayList<SaleOrderService>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;

	
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					SaleOrderService entity = new SaleOrderService();
					Map map = new HashMap();
					DBUtility.bindResultSet(entity, rs);
					if (entity.getStatus().equals(STATUS_OPENING)) {
					
						
						entity.setTotal_amount("-");
					}
					map.put("complete_date", DBUtility.getString("complete_date", rs) );
					map.put("complete", DBUtility.getString("complete", rs) );
					map.put("complete_minute", DBUtility.getString("complete_minute", rs) );
					entity.setUImap(map);
					
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
	
	
	public static List<SaleOrderService> selectstatusWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1  and status <> '" + SaleOrderService.STATUS_OPENING +"' and status <> '" + SaleOrderService.STATUS_CANCEL +"'   ";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("search")) {
					sql += " AND (cus_name like'%" + str[1] + "%' " +
						   " OR v_plate like'%" + str[1] + "%')";
				} else {
					sql += " AND " + str[0] + "='" + str[1] + "'";
				}
			}
		}
		
		sql += " ORDER BY (id*1) desc";
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOrderService> list = new ArrayList<SaleOrderService>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					SaleOrderService entity = new SaleOrderService();
					DBUtility.bindResultSet(entity, rs);
					if (entity.getStatus().equals(STATUS_OPENING)) {
						entity.setTotal_amount("-");
					}
					
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
	private List<SaleServicePartDetail> UIOrderList = new ArrayList<SaleServicePartDetail>();
	public List<SaleServicePartDetail> getUIOrderList() {return UIOrderList;}
	public void setUIOrderList(List<SaleServicePartDetail> uIOrderList) {UIOrderList = uIOrderList;}
	
	
	public static void select(SaleOrderService entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIListDetail(ServicePartDetail.list(entity.getId()));
		conn.close();
	}
	public static SaleOrderService select(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		SaleOrderService entity = new SaleOrderService();
		Connection conn = DBPool.getConnection();	
		entity.setId(id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	public static List<SaleOrderService> listreport(List<String[]> paramsList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
		List<SaleOrderService> list = new ArrayList<SaleOrderService>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 ";
		
		Iterator<String[]> ite = paramsList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {

				if (str[0].equalsIgnoreCase("create_date")){
					
					sql +="AND DATE_FORMAT(create_date, '%Y-%m-%d')='"+str[1]+"' " ;
				} 
				else if (str[0].equalsIgnoreCase("year_month")){
					
					sql +="AND DATE_FORMAT(create_date, '%Y-%m')='"+str[1]+"' " ;
					
				} 
				else if (str[0].equalsIgnoreCase("date_send2")){
					
					sql +="AND DATE_FORMAT(create_date, '%Y-%m-%d') BETWEEN '"+str[1]+"' AND '"+str[2]+"' ";
					
				}
				else {
					
					sql += " AND " + str[0] + "='" + str[1] + "' ";
				}
			}
		}
		
		sql += " ORDER BY (id*1) desc";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			SaleOrderService entity = new SaleOrderService();
			DBUtility.bindResultSet(entity, rs);
			
			Map map = new HashMap();
			
			map.put(Brands.tableName, Brands.select(entity.getBrand_id(), conn));
			map.put(Models.tableName, Models.select(entity.getModel_id(), conn));
			map.put(Personal.tableName, Personal.select(entity.getCreate_by(), conn));
			entity.setUImap(map);
			
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	public static List<SaleOrderService> selectWithCTSaleOrder(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
		String sql = "SELECT * FROM " + tableName + " WHERE status !='100' ";
		
		String m = "";
		String y = "";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if(str[0].equalsIgnoreCase("cus_id")){
					sql += "AND cus_id = '"+str[1] +"' " ;
				}else
				if (str[0].equalsIgnoreCase("year")){
					y = str[1];
				} else 
				if (str[0].equalsIgnoreCase("month")) {
					m = str[1];
				} else {
					sql += " AND " + str[0] + "='" + str[1] + "'";
				}
			}
		}
		
		if (m.length() > 0 && y.length() > 0) {
			/*Calendar sd = Calendar.getInstance();
			sd.clear();
			sd.set(Calendar.YEAR, Integer.parseInt(y));
			sd.set(Calendar.MONTH, Integer.parseInt(m) - 1);
			sd.set(Calendar.DATE, 1);
			
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			
			String s = df.format(sd.getTime());
			
			sd.add(Calendar.MONTH, +1);
			sd.add(Calendar.DATE, -1);
			String e = df.format(sd.getTime());
			
			sql += " AND (duedate between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99')";*/
			sql += " AND MONTH(duedate) = '"+m+"' ";
			sql += " AND YEAR(duedate) = '"+y+"' ";
			
		} else {
			
			if (y.length() > 0) {
				sql += " AND YEAR(duedate) = '"+y+"' ";
				
			}else{
				sql += " AND 1 = 1";
				
			}
			
		}
		
		//sql += " ORDER BY (id*1) DESC ,cus_id ASC ";
		sql += " ORDER BY id DESC , duedate DESC, cus_id ASC";
		//System.out.println("qq="+sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOrderService> list = new ArrayList<SaleOrderService>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					SaleOrderService entity = new SaleOrderService();
					DBUtility.bindResultSet(entity, rs);
					/*entity.setUIVendor(Vendor.select(entity.getVendor_id(), conn));*/
					
					Map map = new HashMap();
					map.put(BranchMaster.tableName, BranchMaster.selectBranchCode(entity.getCus_id(), conn));
					entity.setUImap(map);
					
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
	public static SaleOrderService selectById(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		SaleOrderService entity = new SaleOrderService();
		entity.setId(id);
		
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIOrderList(SaleServicePartDetail.selectListByID(id, conn));
		conn.close();
		return entity;
	}
	public static String CountByStatus(String status) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT count(status) as cnt FROM " + tableName + " WHERE status = '"+status+"' AND duedate != ''";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		String cnt = "";
		while (rs.next()) {
			cnt = DBUtility.getString("cnt", rs);
		}
		rs.close();
		st.close();
		conn.close();
		return cnt;
	}
	public static List<SaleOrderService> listreport2(List<String[]> paramsList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
		List<SaleOrderService> list = new ArrayList<SaleOrderService>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 ";
		
		Iterator<String[]> ite = paramsList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {

				if (str[0].equalsIgnoreCase("create_date")){
					
					sql +="AND DATE_FORMAT(duedate, '%Y-%m-%d')='"+str[1]+"' " ;
				} 
				else if (str[0].equalsIgnoreCase("year_month")){
					
					sql +="AND DATE_FORMAT(duedate, '%Y-%m')='"+str[1]+"' " ;
					
				} 
				else if (str[0].equalsIgnoreCase("date_send2")){
					
					sql +="AND DATE_FORMAT(duedate, '%Y-%m-%d') BETWEEN '"+str[1]+"' AND '"+str[2]+"' ";
					
				}
				else if (str[0].equalsIgnoreCase("report_status")){
					if(!str[1].equalsIgnoreCase("1")){
						sql +=" AND status='"+str[1]+"' ";
					}
				}
				else {
					
					sql += " AND " + str[0] + "='" + str[1] + "' ";
				}
			}
		}
		
		sql += " AND duedate != '' ORDER BY id asc";
		//System.out.println("Q2="+sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			SaleOrderService entity = new SaleOrderService();
			DBUtility.bindResultSet(entity, rs);
			
			Map map = new HashMap();
			map.put(BranchMaster.tableName, BranchMaster.selectBranchCode(entity.getCus_id(), conn));
			entity.setUImap(map);
			
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public List getUIListDetail() {
		return UIListDetail;
	}

	public void setUIListDetail(List uIListDetail) {
		UIListDetail = uIListDetail;
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

	public String getCus_name() {
		return cus_name;
	}

	public void setCus_name(String cus_name) {
		this.cus_name = cus_name;
	}

	public String getV_id() {
		return v_id;
	}

	public void setV_id(String v_id) {
		this.v_id = v_id;
	}

	public String getV_plate() {
		return v_plate;
	}

	public void setV_plate(String v_plate) {
		this.v_plate = v_plate;
	}

	public String getTotal() {
		return total;
	}

	public void setTotal(String total) {
		this.total = total;
	}

	public String getVat() {
		return vat;
	}

	public void setVat(String vat) {
		this.vat = vat;
	}

	public String getDiscount() {
		return discount;
	}

	public void setDiscount(String discount) {
		this.discount = discount;
	}

	public String getTotal_amount() {
		return total_amount;
	}

	public void setTotal_amount(String total_amount) {
		this.total_amount = total_amount;
	}

	public String getPay() {
		return pay;
	}

	public void setPay(String pay) {
		this.pay = pay;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getFlag_pay() {
		return flag_pay;
	}

	public void setFlag_pay(String flag_pay) {
		this.flag_pay = flag_pay;
	}

	public Date getDuedate() {
		return duedate;
	}

	public void setDuedate(Date duedate) {
		this.duedate = duedate;
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

	public String getService_type() {
		return service_type;
	}

	public void setService_type(String service_type) {
		this.service_type = service_type;
	}

	public Vehicle getUIVehicle() {
		return UIVehicle;
	}

	public void setUIVehicle(Vehicle uIVehicle) {
		UIVehicle = uIVehicle;
	}
	public String getV_plate_province() {
		return v_plate_province;
	}

	public void setV_plate_province(String v_plate_province) {
		this.v_plate_province = v_plate_province;
	}


	public String getBrand_id() {
		return brand_id;
	}

	public void setBrand_id(String brand_id) {
		this.brand_id = brand_id;
	}

	public String getModel_id() {
		return model_id;
	}

	public void setModel_id(String model_id) {
		this.model_id = model_id;
	}

	public String getCus_surname() {
		return cus_surname;
	}

	public void setCus_surname(String cus_surname) {
		this.cus_surname = cus_surname;
	}
	public Timestamp getJob_close_date() {
		return job_close_date;
	}
	public void setJob_close_date(Timestamp job_close_date) {
		this.job_close_date = job_close_date;
	}



	public String getUItime_complete() {
		return UItime_complete;
	}

	public void setUItime_complete(String uItime_complete) {
		UItime_complete = uItime_complete;
	}

	public Map getUImap() {
		return UImap;
	}

	public void setUImap(Map uImap) {
		UImap = uImap;
	}



}
