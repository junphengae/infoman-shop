package com.bitmap.bean.parts;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.bitmap.bean.hr.Personal;
import com.bitmap.bean.purchase.PurchaseOrder;
import com.bitmap.bean.sale.Brands;
import com.bitmap.bean.sale.Models;
import com.bitmap.bean.sale.Vehicle;
import com.bitmap.bean.sale.VehicleMaster;
import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;
import com.bitmap.webutils.PageControl;
import com.bitmap.webutils.WebUtils;

public class ServiceSale {
	public static String tableName = "service_sale"; 
	private static String[] keys = {"id"};
	//private static String[] fieldNames = {"cate","fit_to","description","sn_flag","moq","mor","weight","location","price","price_unit","cost","cost_unit","update_date","update_by"};
	
	public static String STATUS_CANCEL = "00";
	public static String STATUS_OPENING = "10";
	public static String STATUS_FORWARDJOB = "010";
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
	String forewordname ="";
	String cus_name = "";
	String cus_surname = "";
	String addressnumber ="";
	String villege ="";
	String district  ="";
	String district_cd ="";
	String prefecture  ="";
	String prefecture_cd ="";
	String province  ="";
	String province_cd ="";
	String postalcode  ="";
	String phonenumber  ="";
	String moo ="";
	String road  ="";
	String soi  ="";
	
	String v_id = "";//Vehicle ID
	String v_plate = "";//Vehicle License Plate
	String v_plate_province = "";//Vehicle License Plate
	String v_plate_province_cd = "";
	String total = "0";
	String vat = "0";
	String discount = "0";
	String total_amount = "0";
	String received ="0";
	String total_change  ="0";
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
	
	String flage ="";
	String tax_id="";
	String bill_id="";
	
	String UItitle_name = "";
	
	Map UImap = null;
	List UIListDetail = null;
	String UItime_complete  = "";
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
		list.add(new String[]{STATUS_MA_REQUEST,"MA Request"});
		list.add(new String[]{STATUS_CLOSED,"Closed"});
		list.add(new String[]{STATUS_CANCEL,"Cancel"});
		return list;
	}
	
	public static List<String[]> ddl_draw(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{STATUS_MA_REQUEST,"MA Request"});
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
		ServiceSale entity = new ServiceSale();
		entity.setId(id);
		return check(entity);
	}
	public  static boolean check(ServiceSale entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}
	public  static boolean checkBill(String bill_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		ServiceSale entity = new ServiceSale();
		entity.setBill_id(bill_id);
		return checkBill(entity);
	}
	public  static boolean checkBill(ServiceSale entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity,new String[]{"bill_id"});
		conn.close();
		return check;
	}
	
	public static void  update_sale(ServiceSale entity) throws SQLException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();		
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"forewordname","cus_name","cus_surname","addressnumber","villege","district","district_cd","prefecture","prefecture_cd","province","province_cd","postalcode","phonenumber","moo","road","soi","v_plate","v_plate_province","v_plate_province_cd","brand_id","model_id"},keys);
		conn.close();
	}
	
	public static void  Restatus(ServiceSale entity) throws SQLException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		entity.setId(entity.getId());
		entity.setStatus(STATUS_MA_REQUEST);
		entity.setUpdate_by(entity.getUpdate_by());
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"status","update_by","pdate_date"},keys);
		conn.close();
	}

	public static void insert(ServiceSale entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setService_type(SERVICE_MA);
		entity.setStatus(STATUS_MA_REQUEST);
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
		    ////System.out.print("ID : "+id);
			runno = (Integer.parseInt(id) + 1)+"";
		}
		////System.out.print("ID+ "+runno);
		rs.close();
		st.close();
		return runno;
	}
	
	public static void update_customer(ServiceSale entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"cus_id","cus_name","cus_surname","v_id","v_plate","update_by","update_date"}, keys);
		conn.close();
	}
	public static void save_order(ServiceSale entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"discount","total_amount","pay","vat","total","update_by","update_date"}, keys);
		conn.close();
	}
	public static void confirm_order(ServiceSale entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"total_amount","vat","total","status","update_by","update_date","cus_name","cus_surname","v_plate","v_plate_province","brand_id","model_id","district_cd","prefecture_cd ","province_cd ","v_plate_province_cd","district","prefecture","province","tax_id","forewordname"}, keys);
		conn.close();
	}
	
	public static void update_status(ServiceSale entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"status","update_by","update_date"}, keys);
		conn.close();
	}
	
	public static void updateStatus(ServiceSale entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"status","vat","update_by","update_date"}, keys);
		conn.close();
	}

	public static void closeJob(ServiceSale entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setJob_close_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"total_change","received","total","discount","total_amount","pay","status","vat","update_by","update_date","job_close_date"}, keys);
		conn.close();
	}
	public static void print_bill(ServiceSale entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setFlage("1");//พิมพ์ใบเสร็จอย่างเต็ม
		entity.setBill_id(bill_id(conn,entity.getJob_close_date()));//เลขที่ใบเสร็จ
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"update_date","flage","bill_id"}, keys);
		conn.close();
		
	}
	public static  String bill_id(Connection conn,Date dd) throws SQLException, IllegalAccessException, InvocationTargetException
	{
		  	 String chkDate1  = WebUtils.getDateValue(dd);
			 String[] yy = chkDate1.split("/");
			 String Y = Money.subtract(Money.add(yy[2],"543"), "2500");
			 String DMY =Y+yy[1];
			 String bill=""; 
			 System.out.println("Run bill_id"+DMY);
			 int number;
				String sql = "SELECT count(*) 	AS number  FROM  service_sale WHERE  bill_id LIKE  '"+DMY+"%'";
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery(sql);
				
				if (rs.next()) {
					
							String data = DBUtility.getString("number", rs); 
							number = (Integer.parseInt(data) + 1);
							if (data.equalsIgnoreCase("0")) {
								
								bill = DMY+"001";
								
							}else{
								
									if(number < 10){
										
										bill = DMY+"00"+number; 
									}	
									else if(number < 100){ 
										
										bill = DMY+"0"+number;
										
									}else{
										bill = DMY+number;
									}
							}
							
					
				}
				rs.close(); 
				st.close();
		return bill;

	}
	
	public static List<ServiceSale> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
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
					sql += " AND (cus_name like'%" + str[1] + "%' " ;
					sql += " OR forewordname like'%" + str[1] + "%' ";
					sql += " OR cus_surname like'%" + str[1] + "%' ";
					sql += " OR v_plate like'%" + str[1] + "%' ";
					sql += " OR id like'%" + str[1] + "%') ";
								
				}else if (str[0].equalsIgnoreCase("id")) {
					sql += " AND id ='" + str[1] + "' " ;
				} 
				else {
					sql += " AND " + str[0] + "='" + str[1] + "'";
				}
			}
		}
		sql += " ORDER BY (id*1) desc";
		
		//System.out.println("sql:Search:"+sql);
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<ServiceSale> list = new ArrayList<ServiceSale>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;

	
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					ServiceSale entity = new ServiceSale();
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
	
	
	public static List<ServiceSale> selectstatusWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1  and status <> '" + ServiceSale.STATUS_OPENING +"' and status <> '" + ServiceSale.STATUS_CANCEL +"'   ";
		
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
		
		List<ServiceSale> list = new ArrayList<ServiceSale>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					ServiceSale entity = new ServiceSale();
					DBUtility.bindResultSet(entity, rs);
					if (entity.getStatus().equals(STATUS_OPENING)) {
						entity.setTotal_amount("-");
					}
					//entity.setUIVehicle(Vehicle.select(entity.getV_id()));
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
	
	public static void select(ServiceSale entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIListDetail(ServicePartDetail.list(entity.getId()));
		conn.close();
	}
	
	public static ServiceSale select(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		ServiceSale entity = new ServiceSale();
		Connection conn = DBPool.getConnection();	
		entity.setId(id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	
	public static List<ServiceSale> listreport(List<String[]> paramsList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
		List<ServiceSale> list = new ArrayList<ServiceSale>();
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
		
		System.out.println("sql:"+sql);
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			ServiceSale entity = new ServiceSale();
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
	
	public String getForewordname() {
		return forewordname;
	}

	public void setForewordname(String forewordname) {
		this.forewordname = forewordname;
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
	
	
	public String getReceived() {
		return received;
	}

	public void setReceived(String received) {
		this.received = received;
	}

	public String getTotal_change() {
		return total_change;
	}

	public void setTotal_change(String total_change) {
		this.total_change = total_change;
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
	
	
	public String getAddressnumber() {
		return addressnumber;
	}

	public void setAddressnumber(String addressnumber) {
		this.addressnumber = addressnumber;
	}

	public String getVillege() {
		return villege;
	}

	public void setVillege(String villege) {
		this.villege = villege;
	}

	public String getDistrict() {
		return district;
	}

	public void setDistrict(String district) {
		this.district = district;
	}

	public String getPrefecture() {
		return prefecture;
	}

	public void setPrefecture(String prefecture) {
		this.prefecture = prefecture;
	}

	public String getProvince() {
		return province;
	}

	public void setProvince(String province) {
		this.province = province;
	}

	public String getPostalcode() {
		return postalcode;
	}

	public void setPostalcode(String postalcode) {
		this.postalcode = postalcode;
	}

	public String getPhonenumber() {
		return phonenumber;
	}

	public void setPhonenumber(String phonenumber) {
		this.phonenumber = phonenumber;
	}

	public String getMoo() {
		return moo;
	}

	public void setMoo(String moo) {
		this.moo = moo;
	}

	public String getRoad() {
		return road;
	}

	public void setRoad(String road) {
		this.road = road;
	}

	public String getSoi() {
		return soi;
	}

	public void setSoi(String soi) {
		this.soi = soi;
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

	public String getDistrict_cd() {
		return district_cd;
	}

	public void setDistrict_cd(String district_cd) {
		this.district_cd = district_cd;
	}

	public String getPrefecture_cd() {
		return prefecture_cd;
	}

	public void setPrefecture_cd(String prefecture_cd) {
		this.prefecture_cd = prefecture_cd;
	}

	public String getProvince_cd() {
		return province_cd;
	}

	public void setProvince_cd(String province_cd) {
		this.province_cd = province_cd;
	}

	public String getV_plate_province_cd() {
		return v_plate_province_cd;
	}

	public void setV_plate_province_cd(String v_plate_province_cd) {
		this.v_plate_province_cd = v_plate_province_cd;
	}

	public String getFlage() {
		return flage;
	}

	public void setFlage(String flage) {
		this.flage = flage;
	}

	public String getTax_id() {
		return tax_id;
	}

	public void setTax_id(String tax_id) {
		this.tax_id = tax_id;
	}

	public String getBill_id() {
		return bill_id;
	}

	public void setBill_id(String bill_id) {
		this.bill_id = bill_id;
	}

	public String getUItitle_name() {
		return UItitle_name;
	}

	public void setUItitle_name(String uItitle_name) {
		UItitle_name = uItitle_name;
	}
    

	
	

}
