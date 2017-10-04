package com.bmp.web.service.transaction;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.WebUtils;
import com.bmp.web.service.bean.getInventoryPackingBean;

public class InventoryPackingTS {
	
	public static String tableName = "inv_packing";
	public static String[] keys = {"mat_code","run_id"};
	public static String[] fieldName = {"description","unit","update_by","update_date"};
	public static String[] fieldNameWS = {"run_id","mat_code","description","unit","create_by","create_date","update_by","update_date"};
	
	
	public static void main(String[] arg) throws Exception{
		
		InventoryPackingTS.getPackingUpdate(new Date());
	}
	
	public static List<getInventoryPackingBean> getPackingUpdate(Date dd) throws Exception{
		
		List<getInventoryPackingBean> list = new ArrayList<getInventoryPackingBean>();
		
		Connection conn = null;
		
		try{
			
			String time = "01/01/0001" ;
			String dd2 = WebUtils.getDateValue(dd);
			String sql = "SELECT * FROM "+tableName+ " WHERE 1=1 " ;
			if (!time.equalsIgnoreCase(dd2)) {
			 
			 sql+=" AND update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			}
			
			conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				getInventoryPackingBean entity = new getInventoryPackingBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			
			rs.close();
			st.close();
			
		}catch (Exception e) {
			throw new Exception("InventoryPackingTSException: " + e.getMessage());
		}finally {
			if (conn != null) {
				conn.close();
			}
		}
		
		return list;
		
	} 
	
	public static List<getInventoryPackingBean> select(List<String[]> paramsList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
		List<getInventoryPackingBean> list = new ArrayList<getInventoryPackingBean>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 ";
		
		Iterator<String[]> ite = paramsList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {

				
					
					sql += " AND " + str[0] + "='" + str[1] + "' ";
				
			}
		}
		
		sql += " ORDER BY (run_id*1) desc";
		
		
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			getInventoryPackingBean entity = new getInventoryPackingBean();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
}
