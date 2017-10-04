package com.bmp.web.service.transaction;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.WebUtils;
import com.bmp.web.service.bean.WebServiceUpdateBean;
import com.bmp.web.service.client.bean.getServiceSaleBean;
import com.bmp.web.service.client.bean.getWebServiceUpDateBean;

public class WebServiceUpdateTS {
	
	public static String tableName = "web_service_update";
	private static String[] keys = {"table_name","sync_date"};
	private static String[] fieldNames = {"sync_date","table_name","status"};
	
	public static void main() throws Exception {
		
	WebServiceUpdateTS.getWebServiceUpdateUpdate(new Date());
	}

	private static void getWebServiceUpdateUpdate(Date date) {
	// TODO Auto-generated method stub
	
	}
	private static boolean check(WebServiceUpdateBean entity, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		return DBUtility.getEntityFromDB(conn, tableName, entity, keys);
	}
	
	public  static boolean check(WebServiceUpdateBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}
	
	public static boolean insert(WebServiceUpdateBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		boolean has = false;
		Connection conn = DBPool.getConnection();
		if (check(entity, conn)) {
			has = true;
		} else {
			entity.setSync_date(DBUtility.getDBCurrentDateTime());
			entity.setStatus("N");
			DBUtility.insertToDB(conn, tableName, entity);
		}
		conn.close();
		return has;
	}
	
	public static void update(WebServiceUpdateBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setSync_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public static WebServiceUpdateBean select(WebServiceUpdateBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static WebServiceUpdateBean selectdate(Connection conn,String table_name) throws Exception{
		try{
			String sql ="SELECT MAX(sync_date) AS sync_date FROM  web_service_update WHERE table_name = '"+ table_name +"'";
			
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			
			WebServiceUpdateBean entity = new WebServiceUpdateBean();
			if (rs.next()) {
				DBUtility.bindResultSet(entity, rs);
			}
			
			if (entity.getSync_date() == null) {
				entity.setSync_date(DBUtility.getDBCurrentDateTime());
			}
			rs.close();
			st.close();
			return entity;
		}catch(Exception e){
			conn.rollback();
			//conn.close();
			throw new Exception(e.getMessage());
		}
	
	} 
	
	public static void insertServiceUpdate(Connection conn ,String table_name) throws Exception{
		
		try {
				WebServiceUpdateBean entity = new WebServiceUpdateBean();
				entity.setTable_name(table_name);
				entity.setSync_date(DBUtility.getDBCurrentDateTime());
				entity.setStatus("N");
				
				DBUtility.insertToDB(conn, tableName, entity);
			
				
		} catch (Exception e) {
				conn.rollback();
				//conn.close();
				throw new Exception(e.getMessage());
		}
				
	}
 
	public static String selectCount(Connection conn,String table_name) throws Exception{
		String count_sh ="";
		String sql ="";
		try{
			if(table_name.trim().equalsIgnoreCase("pur_purchase_order")){
				sql ="SELECT COUNT(*) AS count_sh FROM "+table_name.trim()+" WHERE status = '30' "; 
			}else if (table_name.trim().equalsIgnoreCase("pur_purchase_request")) {
				sql ="SELECT COUNT(*) AS count_sh FROM "+table_name.trim()+" WHERE status = '30' "; 
			}else if (table_name.trim().equalsIgnoreCase("service_sale")) {
				sql ="SELECT COUNT(*) AS count_sh FROM "+table_name.trim()+" WHERE status = '100' "; 
			}else if (table_name.trim().equalsIgnoreCase("service_repair")) {
				sql ="SELECT COUNT(*) AS count_sh FROM "+table_name.trim()+" AS t1 INNER JOIN service_sale AS t2 ON  t2.id = t1.id WHERE t2.status = '100' "; 
			}else if (table_name.trim().equalsIgnoreCase("service_repair_detail")) {
				sql ="SELECT COUNT(*) AS count_sh FROM "+table_name.trim()+" AS t1 INNER JOIN service_sale AS t2 ON  t2.id = t1.id WHERE t2.status = '100' "; 
			}else if (table_name.trim().equalsIgnoreCase("service_part_detail")) {
				sql ="SELECT COUNT(*) AS count_sh FROM "+table_name.trim()+" AS t1 INNER JOIN service_sale AS t2 ON  t2.id = t1.id WHERE t2.status = '100' "; 
			}else if (table_name.trim().equalsIgnoreCase("service_other_detail")) {
				sql ="SELECT COUNT(*) AS count_sh FROM "+table_name.trim()+" AS t1 INNER JOIN service_sale AS t2 ON  t2.id = t1.id WHERE t2.status = '100' "; 
			}else if (table_name.trim().equalsIgnoreCase("branch_stock")) {
				sql ="SELECT COUNT(*) AS count_sh FROM pa_part_master"; 
			}else{
				sql ="SELECT COUNT(*) AS count_sh FROM "+table_name.trim();	
			} 
			//System.out.println(sql);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
						
			if (rs.next()) {
				count_sh = DBUtility.getString("count_sh", rs);
				//System.out.println("Count :"+count_sh);
			}				
			rs.close();
			st.close();
			return count_sh;
		}catch(Exception e){
			conn.rollback();			
			throw new Exception(e.getMessage());
		}
	
	} 
	
public static List<getWebServiceUpDateBean> getWebServiceUpDate(Connection conn) throws Exception {
		
		List<getWebServiceUpDateBean> list = new ArrayList<getWebServiceUpDateBean>();
		
		try{			
			String sql = "SELECT table_name AS table_name ,MAX(sync_date)  AS sync_date FROM web_service_update GROUP BY table_name" ;
			//System.out.println(sql);			
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				
				getWebServiceUpDateBean entity = new getWebServiceUpDateBean();
				DBUtility.bindResultSet(entity, rs);
				entity.setCount_sh(selectCount(conn,entity.getTable_name()));
				//System.out.println( entity.getTable_name() +" ### "+  entity.getSync_date() +" ### "+  entity.getCount_sh() );
				list.add(entity);
			}			
			rs.close();
			st.close();
			
		}catch (Exception e) {
			conn.rollback();
			conn.close();
			throw new Exception("getWebServiceUpDateBean SH : " + e.getMessage());
		}
		
		return list;
		
	}
}
