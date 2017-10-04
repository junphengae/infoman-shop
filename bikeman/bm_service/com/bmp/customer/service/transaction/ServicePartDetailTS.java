package com.bmp.customer.service.transaction;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;

import com.bitmap.bean.parts.ServicePartDetail;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bmp.customer.service.bean.ServicePartDetailBean;

public class ServicePartDetailTS {
	public static String tableName = "service_part_detail";
	private static String[] keys = {"id","number"};
	private static String[] fieldNames = {"id","number","pn","qty","cutoff_qty","discount","discount_flag","cash_discount","price","create_by","create_date","vat","total_vat","total_price","spd_dis_total_before","spd_dis_total","spd_net_price"};
	
	public static void insertPart(ServicePartDetailBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
						
			entity.setCreate_date(DBUtility.getDBCurrentDateTime());
			entity.setNumber(DBUtility.genNumberFromDB(conn, tableName, entity, new String[]{"id"}, "number"));
			
			DBUtility.insertToDB(conn, tableName, fieldNames, entity);
			
			conn.commit();
			conn.close();
		} catch (Exception e) {
			if (conn != null) {
				conn.rollback();
				conn.close();
			}
			System.out.println(e.getMessage());
		}
		
		
	}
	public static void updatePartdetail(ServicePartDetailBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"qty","price","discount_flag","discount","cash_discount","update_by","update_date","vat","total_vat","total_price","spd_net_price","spd_dis_total_before","spd_dis_total"}, new String[]{"pn","id","discount"});
			
			conn.commit();
			conn.close();
			
		} catch (Exception e) {
			if (conn != null) {
				conn.rollback();
				conn.close();
			}
			System.out.println(e.getMessage());
		}
		
		
	}
	
	public static void updatePartdetail(ServicePartDetailBean entity,boolean updateDiscount) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"qty","price","discount_flag","discount","cash_discount","update_by","update_date","vat","total_vat","total_price","spd_net_price","spd_dis_total_before","spd_dis_total"}, keys);
			
			conn.commit();
			conn.close();
			
		} catch (Exception e) {
			if (conn != null) {
				conn.rollback();
				conn.close();
			}
			System.out.println(e.getMessage());
		}
		
		
	}
	
	
	
	
	

}
