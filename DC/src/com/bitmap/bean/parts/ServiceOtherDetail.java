package com.bitmap.bean.parts;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.bitmap.bean.hr.Personal;
import com.bitmap.bean.sale.MoneyDiscountRound;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;

public class ServiceOtherDetail {
	public static String tableName = "service_other_detail";
	public static String[] keys = {"id","number"};
	public static String[] fieldNames = {"id","number","other_name","other_qty","other_price","discount","discount_flag","note","create_by","create_date","update_by","update_date","branch_code","sod_net_price","sod_dis_total"};
	
	public static String STATUS_OPENED = "10";
	public static String STATUS_CLOSED = "11";
	public static String STATUS_CANCEL = "00";
	
	String id = "";
	String number = "";
	String other_name = "";
	String other_qty = "";
	String other_price = "0";
	String discount = "0";
	String discount_flag = "";
	String note = "";
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	String branch_code = "";
	String sod_net_price ="0";
	String sod_dis_total ="0";
	Map UImap = null;
	
	
	public String getSod_dis_total() {
		return sod_dis_total;
	}

	public void setSod_dis_total(String sod_dis_total) {
		this.sod_dis_total = sod_dis_total;
	}

	public Map getUImap() {
		return UImap;
	}

	public void setUImap(Map uImap) {
		UImap = uImap;
	}
	
	public static void updateDiscount( String start , String end ) throws Exception{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			String sql = "SELECT * FROM "+tableName+" WHERE id BETWEEN ? AND ? ";

			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, start);
			ps.setString(2, end);
			
			ResultSet rs = ps.executeQuery();
			while( rs.next() ){
				ServiceOtherDetail entity = new ServiceOtherDetail();
				DBUtility.bindResultSet(entity, rs);
				String price = Money.money((Integer.parseInt(entity.getOther_qty())*Double.parseDouble(entity.getOther_price().replace(",", "")))).replace(",", "");//ราคา*จำนวน=price 
				String net_price = Money.money(MoneyDiscountRound.disRound(price , Money.money(entity.getDiscount()))).replace(",", "");//price-ส่วนลด=net_price *** มีการปรับเศษสตางค์
				String discount = Money.subtract(price, net_price);//price-net_price=ส่วนลด
				
				if( ! entity.getSod_net_price().equalsIgnoreCase(net_price) || ! entity.getSod_dis_total().equalsIgnoreCase(discount) ){
					entity.setSod_net_price(net_price);
					entity.setSod_dis_total(discount);
				
					DBUtility.updateToDB(conn, tableName, entity, new String[]{"sod_dis_total","sod_net"}, keys);
				}
			}
			rs.close();
			ps.close();
			conn.close();
		} catch (Exception e) {
			if( conn != null ){
				conn.close();
			}
			System.out.println(e);
			throw new Exception( e.getMessage() );
		}
	}
	
	public static String status(String status){
		HashMap<String, String> map = new HashMap<String, String>();
		map.put(STATUS_OPENED, "Opened");
		map.put(STATUS_CLOSED, "Closed");
		map.put(STATUS_CANCEL, "Cancel");
		return map.get(status);
	}
	
	public static List<String[]> ddl_status_en(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{STATUS_OPENED,"Opened"});
		list.add(new String[]{STATUS_CLOSED,"Closed"});
		list.add(new String[]{STATUS_CANCEL,"Cancel"});
		return list;
	}
	
	public  static boolean check(String id ,String number) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		ServiceOtherDetail entity = new ServiceOtherDetail();
		entity.setId(id);
		entity.setNumber(number);
		return check(entity);
	}
	public  static boolean check(ServiceOtherDetail entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}
	public static void insert(ServiceOtherDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setNumber(DBUtility.genNumberFromDB(conn, tableName, entity, new String[]{"id"}, "number"));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static ServiceOtherDetail select(String id,String number) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		ServiceOtherDetail entity = new ServiceOtherDetail();
		entity.setId(id);
		entity.setNumber(number);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static ServiceOtherDetail select(ServiceOtherDetail entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static void update(ServiceOtherDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public static void update_detail(ServiceOtherDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"other_name","other_qty","other_price","discount_flag","discount","update_by","update_date"}, keys);
		conn.close();
	}
	
	public static void delete(ServiceOtherDetail entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public static List<ServiceOtherDetail> list(String id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		List<ServiceOtherDetail> list = new ArrayList<ServiceOtherDetail>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE id='" + id + "' ORDER BY (number*1) ASC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			ServiceOtherDetail entity = new ServiceOtherDetail();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}

	
	public static List<ServiceOtherDetail> listreport(List<String[]> paramsList) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 " ;
		
		Iterator<String[]> ite = paramsList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {

				if (str[0].equalsIgnoreCase("create_date")){
					
					sql +="  AND DATE_FORMAT(create_date, '%Y-%m-%d')='"+str[1]+"' " ;
					
				} 
				else if (str[0].equalsIgnoreCase("year_month")){
					
					sql +="  AND DATE_FORMAT(create_date, '%Y-%m')='"+str[1]+"' " ;
					
				} 
				else if (str[0].equalsIgnoreCase("date_send2")){
					
					sql +="  AND DATE_FORMAT(create_date, '%Y-%m-%d') BETWEEN '"+str[1]+"' AND '"+str[2]+"' ";
					
				}
				else if (str[0].equalsIgnoreCase("branch")){
					
					if(str[1].equalsIgnoreCase("all")){
					}else{
						sql +=" AND branch_code = '"+str[1]+"' ";
					}
				}
				else {
					
					sql += "  AND " + str[0] + "='" + str[1] + "' ";
				}
			}
		}
		
		sql += " ORDER BY (id*1) asc";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<ServiceOtherDetail> list = new ArrayList<ServiceOtherDetail>();
		while (rs.next()) {
			ServiceOtherDetail entity = new ServiceOtherDetail();
			DBUtility.bindResultSet(entity, rs);
			
			Map map = new HashMap();
			map.put(Personal.tableName, Personal.select(entity.getCreate_by(), conn));
			entity.setUImap(map);
			list.add(entity);
		}
		
		//System.out.println("sql::"+sql);
		rs.close();
		st.close();
		conn.close();
		return list;
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

	public String getOther_name() {
		return other_name;
	}

	public void setOther_name(String other_name) {
		this.other_name = other_name;
	}

	public String getOther_qty() {
		return other_qty;
	}

	public void setOther_qty(String other_qty) {
		this.other_qty = other_qty;
	}

	public String getOther_price() {
		return other_price;
	}

	public void setOther_price(String other_price) {
		this.other_price = other_price;
	}

	public String getDiscount() {
		return discount;
	}

	public void setDiscount(String discount) {
		this.discount = discount;
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

	public String getDiscount_flag() {
		return discount_flag;
	}

	public void setDiscount_flag(String discount_flag) {
		this.discount_flag = discount_flag;
	}

	public String getBranch_code() {
		return branch_code;
	}

	public void setBranch_code(String branch_code) {
		this.branch_code = branch_code;
	}

	public String getSod_net_price() {
		return sod_net_price;
	}

	public void setSod_net_price(String sod_net_price) {
		this.sod_net_price = sod_net_price;
	}
	
	
	
}