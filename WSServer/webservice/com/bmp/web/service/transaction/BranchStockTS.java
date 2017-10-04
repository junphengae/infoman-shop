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
import com.bmp.web.service.bean.setBranchStockBean;

public class BranchStockTS {

	public static String tableName = "branch_stock";
	public static String[] keys = {"pn","branch_id"};
	public static String[] fieldName = {"pn","branch_id","stock","update_date"};
	
	

	public  static boolean check(String pn ,String  branch_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{		
		setBranchStockBean entity = new setBranchStockBean();
		entity.setBranch_id(branch_id);
		entity.setPn(pn);		
		return check(entity);
	}
	
	public  static boolean check(setBranchStockBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;				
		check = DBUtility.getEntityFromDB(conn,tableName,entity, keys);				
		conn.close();
		return check;
	}
	
	
	public static List<setBranchStockBean> getBranchUpdate(Date dd) throws Exception{
		
		List<setBranchStockBean> list = new ArrayList<setBranchStockBean>();
		
		Connection conn = null;
		
		try{
			
			String time = "01/01/0001" ;
			String dd2 = WebUtils.getDateValue(dd);
			System.out.println("branch_stock dd="+dd2);
			String sql = "SELECT * FROM "+tableName+ " WHERE 1=1 " ;
			if (!time.equalsIgnoreCase(dd2)) {
			 
			 sql+=" AND update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			}
			System.out.println("branch_stock="+sql);
			conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				setBranchStockBean entity = new setBranchStockBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			
			rs.close();
			st.close();
			
		}catch (Exception e) {
			throw new Exception("BranchStockBeanTSException: " + e.getMessage());
			
		}finally {
			if (conn != null) {
				conn.close();
			}
		}
		
		return list;
		
	} 


}
