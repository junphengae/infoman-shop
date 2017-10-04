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
import com.bmp.web.service.bean.setSaleServicePartDetailBean;

public class SaleServicePartDetailTS {
	
	public static String tableName = "sale_order_service_part_detail";
	public static String[] keys = {"id","number"};
	public static String[] keyNumber = {"number"};
	public static String[] fieldNames = {"id","number","pn","qty","discount","discount_flag","cutoff_qty","price","create_by"
											,"create_date","update_by","update_date"};
	
	private static String[] updateNoteField = {"status","update_by","update_date","note"};
	
	
	
	public static void main(String[] arg) throws Exception{
		
		SaleServicePartDetailTS.getSaleServicePartDetailUpdate(new Date());
	}

	public static List<setSaleServicePartDetailBean> getSaleServicePartDetailUpdate(Date dd) throws Exception {
		

		List<setSaleServicePartDetailBean> list = new ArrayList<setSaleServicePartDetailBean>();
		
		Connection conn = null;
		
		try{
			
			String sql = "SELECT * FROM "+tableName+" WHERE update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			
			conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				setSaleServicePartDetailBean entity = new setSaleServicePartDetailBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			
			rs.close();
			st.close();
			
		}catch (Exception e) {
			throw new Exception("SaleServicePartDetailTSException: " + e.getMessage());
		}finally {
			if (conn != null) {
				conn.close();
			}
		}
		
		return list;
	
		
	}
	
	public  static boolean check(String id ,String number) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		setSaleServicePartDetailBean entity = new setSaleServicePartDetailBean();
		entity.setId(id);
		entity.setNumber(number);
		return check(entity);
	}
	public  static boolean check(setSaleServicePartDetailBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}
	
}
