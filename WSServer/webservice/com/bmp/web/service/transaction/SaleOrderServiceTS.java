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
import com.bmp.web.service.bean.setSaleOrderServiceBean;

public class SaleOrderServiceTS {
		
	public static String tableName = "sale_order_service"; 
	public static String[] keys = {"id"};
	public static String[] fieldNames = {"id","service_type","cus_id","cus_name","cus_surname","v_id","v_plate","v_plate_province","total","vat"
	,"discount","total_amount","pay","status","flag_pa","duedate","create_by","create_date","update_by","update_date","brand_id","model_id","job_close_date"};
	
	
	public static void main(String[] arg) throws Exception{
		
		SaleOrderServiceTS.getSaleOrderServiceUpdate(new Date());
	}

	public static List<setSaleOrderServiceBean> getSaleOrderServiceUpdate(Date dd) throws Exception{
		

		
		List<setSaleOrderServiceBean> list = new ArrayList<setSaleOrderServiceBean>();
		
		Connection conn = null;
		
		try{
			
			String sql = "SELECT * FROM "+tableName+" WHERE update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			
			conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				setSaleOrderServiceBean entity = new setSaleOrderServiceBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			
			rs.close();
			st.close();
			
		}catch (Exception e) {
			throw new Exception("SaleOrderServicTSException: " + e.getMessage());
		}finally {
			if (conn != null) {
				conn.close();
			}
		}
		
		return list;
		
	
		
	}
	
	public  static boolean check(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		setSaleOrderServiceBean entity = new setSaleOrderServiceBean();
		entity.setId(id);
		return check(entity);
	}
	public  static boolean check(setSaleOrderServiceBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}
	
}
