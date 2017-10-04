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
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.bitmap.bean.hr.Personal;
import com.bitmap.bean.inventory.InventoryLot;
import com.bitmap.bean.inventory.InventoryLotControl;
import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;

public class PartLotControl {
	public static String tableName = "part_lot_control";
	private static String[] keys = {"job_id","lot_id"};
	private static String[] upDateField = {  "draw_qty",  "draw_price", "update_by", "update_date"};
//	private static String[] UpdateField = {"po"};

	String job_id = "";
	String lot_id = "";
	String pn = "";	
	String sn = "";
	String draw_qty = "";
	String draw_price = "";
	String draw_discount = "";

	String draw_by = "";
	Timestamp draw_date = null;
	String update_by = "";
	Timestamp update_date = null;
	
	Map UImap = null;
	
	
	
	public Map getUImap() {
		return UImap;
	}


	public void setUImap(Map uImap) {
		UImap = uImap;
	}


	public static boolean checkPnInJob(String job_id, String pn) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		PartLotControl entity = new PartLotControl();
		entity.setJob_id(job_id);
		entity.setPn(pn);
		boolean hasPN = false;
		hasPN = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"job_id","pn"});
		if (hasPN) {
			if ((entity.getPn()).trim().equalsIgnoreCase(pn.trim())) {
				hasPN = false;
			}
		}
		conn.close();
		return hasPN;
	}
	public  static boolean check(String job_id,String pn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PartLotControl entity = new PartLotControl();
		entity.setJob_id(job_id);
		entity.setPn(pn);
		return check(entity);
	}
	public  static boolean check(PartLotControl entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity,new String[]{"job_id","pn"});
		conn.close();
		return check;
	}
	
	
	
	
	public static void insert(PartLotControl entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		//System.out.println("PartLotControl:::"+ entity.getDraw_qty());
		entity.setDraw_date(DBUtility.getDBCurrentDateTime());
		entity.setLot_id(genLotId(entity, conn));
		entity.setDraw_qty(entity.getDraw_qty());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static void select(PartLotControl entity , Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException {
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"job_id","pn"});
		
	}

	public static void update(PartLotControl entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		String order_qty = entity.getDraw_qty();
		int qty = Integer.parseInt(order_qty);
		PartLotControl entityCheck = new PartLotControl();
		entityCheck.setJob_id(entity.getJob_id());
		entityCheck.setPn(entity.getPn());
		select(entityCheck, conn);
		
		entity.setDraw_qty((DBUtility.getInteger(entityCheck.getDraw_qty()) + qty) + "");
		//System.out.println("Draw : "+qty);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName,entity, upDateField , new String[]{"job_id","pn"});
		
		conn.close();
	}
	
	private static String genLotId(PartLotControl entity, Connection conn) throws SQLException{
		String sql = "SELECT lot_id FROM " + tableName + " ORDER BY (lot_id*1) DESC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String lot_id = "1";
		if (rs.next()) {
			String temp = DBUtility.getString("lot_id", rs);
			lot_id = (Integer.parseInt(temp) + 1) + "";
		}
		
		rs.close();
		st.close();
		return lot_id;
	}
		

	public static String sumRecivePO(String po , String pn ) throws Exception{
		Connection conn = DBPool.getConnection();
		//conn.setAutoCommit(false);     ////  #####
		String sum = "0";
			String sql = "	SELECT SUM(lot_qty) as lot_qty FROM " + tableName + " WHERE po  = ? AND pn = ?";
			//String sql = "SELECT  po, SUM(order_qty) AS order_qty FROM " + tableName + " WHERE po = ? GROUP BY po"; // ตัวอย่างการใช้ Object Bean
			//System.out.println("SQL : "+sql	);
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, po);
			ps.setString(2, pn);
			ResultSet rs = ps.executeQuery();
			//PurchaseRequest entity = new PurchaseRequest();
			if (rs.next()) {
				sum = DBUtility.getString("lot_qty", rs);
				//DBUtility.bindResultSet(entity, rs);
			}
			rs.close();
			ps.close();
			//conn.commit(); //#####
		
		return sum;
	}
	public static String sumRecivePO(String po , String pn , Connection conn) throws Exception{
		
		//conn.setAutoCommit(false);     ////  #####
		String sum = "0";
			String sql = "	SELECT SUM(lot_qty) as lot_qty FROM " + tableName + " WHERE po  = ? AND pn = ?";
			//String sql = "SELECT  po, SUM(order_qty) AS order_qty FROM " + tableName + " WHERE po = ? GROUP BY po"; // ตัวอย่างการใช้ Object Bean
			//System.out.println("SQL : "+sql	);
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, po);
			ps.setString(2, pn);
			ResultSet rs = ps.executeQuery();
			//PurchaseRequest entity = new PurchaseRequest();
			if (rs.next()) {
				sum = DBUtility.getString("lot_qty", rs);
				//DBUtility.bindResultSet(entity, rs);
			}
			rs.close();
			ps.close();
			//conn.commit(); //#####
		
		return sum;
	}
	
public static List<PartLotControl> report(List<String[]> paramsList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		
		List<PartLotControl> list = new ArrayList<PartLotControl>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM "+tableName +" WHERE 1=1 ";
		
		Iterator<String[]> ite = paramsList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {

				if (str[0].equalsIgnoreCase("create_date")){
					
					sql +=" AND DATE_FORMAT(draw_date, '%Y-%m-%d')='"+str[1]+"' " ;
					
				} 
				else if (str[0].equalsIgnoreCase("year_month")){
					
					sql +=" AND DATE_FORMAT(draw_date, '%Y-%m')='"+str[1]+"' " ;
					
				} 
				else if (str[0].equalsIgnoreCase("date_send2")){
					
					sql +=" AND DATE_FORMAT(draw_date, '%Y-%m-%d') BETWEEN '"+str[1]+"' AND '"+str[2]+"' ";
					
				}
				
				else {
					
					sql += " AND " + str[0] + "='" + str[1] + "' ";
				}
			}
		}
		
		sql += " ORDER BY draw_date asc ";
		
		//System.out.println("เบิกสินค้า::"+sql);
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			PartLotControl entity = new PartLotControl();
			DBUtility.bindResultSet(entity, rs);
			
			Map map = new HashMap();
			map.put(Personal.tableName, Personal.select(entity.getDraw_by(), conn));
			entity.setUImap(map);
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	
	
	
	public String getJob_id() {
		return job_id;
	}


	public void setJob_id(String job_id) {
		this.job_id = job_id;
	}


	public String getLot_id() {
		return lot_id;
	}


	public void setLot_id(String lot_id) {
		this.lot_id = lot_id;
	}


	public String getPn() {
		return pn;
	}


	public void setPn(String pn) {
		this.pn = pn;
	}


	public String getSn() {
		return sn;
	}


	public void setSn(String sn) {
		this.sn = sn;
	}


	public String getDraw_qty() {
		return draw_qty;
	}


	public void setDraw_qty(String draw_qty) {
		this.draw_qty = draw_qty;
	}


	public String getDraw_price() {
		return draw_price;
	}


	public void setDraw_price(String draw_price) {
		this.draw_price = draw_price;
	}


	public String getDraw_by() {
		return draw_by;
	}


	public void setDraw_by(String draw_by) {
		this.draw_by = draw_by;
	}


	public Timestamp getDraw_date() {
		return draw_date;
	}


	public void setDraw_date(Timestamp draw_date) {
		this.draw_date = draw_date;
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


	public String getDraw_discount() {
		return draw_discount;
	}


	public void setDraw_discount(String draw_discount) {
		this.draw_discount = draw_discount;
	}

}