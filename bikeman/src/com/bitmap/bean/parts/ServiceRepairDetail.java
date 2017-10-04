package com.bitmap.bean.parts;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.el.ELException;

import com.bitmap.bean.sale.MoneyDiscountRound;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;

public class ServiceRepairDetail {
	public static String tableName = "service_repair_detail";
	public static String[] keys = {"id","number"};
	public static String[] fieldNames = {};
	
	public static String STATUS_OPENED = "10";
	public static String STATUS_CLOSED = "11";
	public static String STATUS_CANCEL = "00";
	

	String id = "";
	String number = "";
	String labor_id = "";
	String labor_name = "";
	String labor_qty = "";
	String labor_rate = "0";
	String discount = "0";
	String cash_discount = "0";
	String discount_flag = "";
	String status ="";
	String note = "";
	Timestamp due_date = null;
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	String vat  = "0";
	String total_vat = "0";
	String srd_dis_total_before ="0";
	String srd_dis_total ="0";
	String srd_net_price ="0";
	
	Map UImap = null;


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

	public String getLabor_name() {
		return labor_name;
	}

	public void setLabor_name(String labor_name) {
		this.labor_name = labor_name;
	}

	public String getLabor_qty() {
		return labor_qty;
	}

	public void setLabor_qty(String labor_qty) {
		this.labor_qty = labor_qty;
	}

	public String getLabor_rate() {
		return labor_rate;
	}

	public void setLabor_rate(String labor_rate) {
		this.labor_rate = labor_rate;
	}

	public String getDiscount() {
		return discount;
	}

	public void setDiscount(String discount) {
		this.discount = discount;
	}

	public String getDiscount_flag() {
		return discount_flag;
	}

	public void setDiscount_flag(String discount_flag) {
		this.discount_flag = discount_flag;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public Timestamp getDue_date() {
		return due_date;
	}

	public void setDue_date(Timestamp due_date) {
		this.due_date = due_date;
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

	public String getVat() {
		return vat;
	}

	public void setVat(String vat) {
		this.vat = vat;
	}

	public String getTotal_vat() {
		return total_vat;
	}

	public void setTotal_vat(String total_vat) {
		this.total_vat = total_vat;
	}

	public String getSrd_dis_total_before() {
		return srd_dis_total_before;
	}

	public void setSrd_dis_total_before(String srd_dis_total_before) {
		this.srd_dis_total_before = srd_dis_total_before;
	}

	public String getSrd_dis_total() {
		return srd_dis_total;
	}

	public void setSrd_dis_total(String srd_dis_total) {
		this.srd_dis_total = srd_dis_total;
	}

	public String getSrd_net_price() {
		return srd_net_price;
	}

	public void setSrd_net_price(String srd_net_price) {
		this.srd_net_price = srd_net_price;
	}

	public Map getUImap() {
		return UImap;
	}

	public void setUImap(Map uImap) {
		UImap = uImap;
	}
	public String getCash_discount() {
		return cash_discount;
	}

	public void setCash_discount(String cash_discount) {
		this.cash_discount = cash_discount;
	}


	public static String SERVICE_VAT= "7";
	
	
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
	
	public static void updateDiscount( String start , String end ) throws Exception{
		Connection conn = null;
		try {
			String hundred = "100";
			conn = DBPool.getConnection();
			String sql = "SELECT * FROM "+tableName+" WHERE id BETWEEN ? AND ? ";
			
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, start);
			ps.setString(2, end);
			
			ResultSet rs = ps.executeQuery();
			while( rs.next() ){
				ServiceRepairDetail entity = new ServiceRepairDetail();
				DBUtility.bindResultSet(entity, rs);
				String net_price = Money.money(MoneyDiscountRound.disRound(entity.getLabor_rate() , Money.money(entity.getDiscount().replace(",", "")))).replace(",", "");//price-ส่วนลด=net_price *** มีการปรับเศษสตางค์
				String discount = Money.subtract(entity.getLabor_rate(), net_price);//price-net_price=ส่วนลด
				String total_vat = String.format("%.2f", Double.parseDouble( Money.divide( Money.multiple( net_price, entity.getVat() ) , Money.add( entity.getVat() , hundred ) ).replace(",", "") ) );
				
				if( ! entity.getSrd_net_price().equalsIgnoreCase(net_price) || ! entity.getSrd_dis_total().equalsIgnoreCase(discount) || ! entity.getTotal_vat().equalsIgnoreCase(total_vat) ){
					entity.setSrd_net_price(net_price);
					entity.setSrd_dis_total(discount);
					entity.setTotal_vat(total_vat);
				
					DBUtility.updateToDB(conn, tableName, entity, new String[]{"total_vat","srd_dis_total","srd_net"}, keys);
				}
			}
			rs.close();
			ps.close();
			conn.close();
		} catch (Exception e) {
			if( conn != null ){
				conn.close();
			}
			throw new Exception( e.getMessage() );
		}
	}
	
	public static void insert(ServiceRepairDetail entity) throws Exception{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			entity.setCreate_date(DBUtility.getDBCurrentDateTime());
			entity.setNumber(DBUtility.genNumberFromDB(conn, tableName, entity, new String[]{"id"}, "number"));
			DBUtility.insertToDB(conn, tableName, entity);
			conn.commit();
			conn.close();
		} catch (Exception e) {
			if( conn != null ){
				conn.rollback();
				conn.close();
			}
			throw new Exception(e);
		}

	}
	
	public static ServiceRepairDetail select(String id,String number) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		ServiceRepairDetail entity = new ServiceRepairDetail();
		entity.setId(id);
		entity.setNumber(number);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static ServiceRepairDetail select(ServiceRepairDetail entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static void update(ServiceRepairDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public static void update_detail(ServiceRepairDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"labor_name","labor_qty","labor_rate","discount_flag","discount","note","update_by","update_date","vat","total_vat","srd_dis_total_before","srd_net_price","srd_dis_total","cash_discount"}, keys);
			conn.commit();
			conn.close();
		} catch (Exception e) {
			if( conn != null ){
				conn.rollback();
				conn.close();
			}
		}
	
	}
	
	public static void delete(ServiceRepairDetail entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public static List<ServiceRepairDetail> list(String id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		List<ServiceRepairDetail> list = new ArrayList<ServiceRepairDetail>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM "+tableName+" WHERE id='"+id+"' ORDER BY (number*1) ASC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		if (rs != null) {
			while (rs.next()) {
				ServiceRepairDetail entity = new ServiceRepairDetail();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
		} 		
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}

	public static void UpdateDate(String update_by,String id ) throws SQLException {
		Connection conn = DBPool.getConnection();
		String sql = "UPDATE "+tableName+" SET update_by= '"+update_by+"' ,update_date= '"+DBUtility.getDBCurrentDateTime()+"' WHERE id = '"+id+"' ";
		//System.out.println(sql);
		Statement st = conn.createStatement();
		int rs = st.executeUpdate(sql);		
		conn.close();
		
	}

	public static void main(String[] args) throws SQLException {
		UpdateDate("yyy01", "131");
		System.out.println("OK");
	}
}