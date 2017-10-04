package com.bmp.web.service.transaction;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bmp.web.service.bean.setWebServiceReportBean;

public class WebServiceReportTS {
	public static String tableName = "ws_report";
	public static String[] keys = {"branch_id","table_sh"};
	public static String[] fieldNames = {"table_dc","count_sh","count_dc","sync_date"};
	
	public  static boolean check(String  branch_id,String table_sh) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{		
		setWebServiceReportBean entity = new setWebServiceReportBean();
		entity.setBranch_id(branch_id);
		entity.setTable_sh(table_sh);
		return check(entity);
	}
	
	public  static boolean check(setWebServiceReportBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;				
		check = DBUtility.getEntityFromDB(conn,tableName,entity, keys);				
		conn.close();
		return check;
	}
	public static String selectCount(Connection conn,String table_name,String branch_code) throws Exception{
		String count_dc ="";
		String sql ="";
		try{
			if(table_name.trim().equalsIgnoreCase("branch_stock")){
				sql ="SELECT COUNT(*) AS count_dc FROM "+table_name.trim()+" WHERE branch_id = '"+branch_code.trim()+"' "; 
			}else if (table_name.trim().equalsIgnoreCase("sale_order_service")) {
				sql ="SELECT COUNT(*) AS count_dc FROM "+table_name.trim()+" WHERE cus_id = '"+branch_code.trim()+"' "; 
			}else if (table_name.trim().equalsIgnoreCase("sale_order_service_part_detail")) {
				sql ="SELECT COUNT(*) AS count_dc FROM "+table_name.trim()+" WHERE branch_code = '"+branch_code.trim()+"' "; 
			}else if (table_name.trim().equalsIgnoreCase("service_sale")) {
				sql ="SELECT COUNT(*) AS count_dc FROM "+table_name.trim()+" WHERE branch_code = '"+branch_code.trim()+"' "; 
			}else if (table_name.trim().equalsIgnoreCase("service_repair")) {
				sql ="SELECT COUNT(*) AS count_dc FROM "+table_name.trim()+" WHERE branch_code = '"+branch_code.trim()+"' "; 
			}else if (table_name.trim().equalsIgnoreCase("service_repair_detail")) {
				sql ="SELECT COUNT(*) AS count_dc FROM "+table_name.trim()+" WHERE branch_code = '"+branch_code.trim()+"' "; 
			}else if (table_name.trim().equalsIgnoreCase("service_part_detail")) {
				sql ="SELECT COUNT(*) AS count_dc FROM "+table_name.trim()+" WHERE branch_code = '"+branch_code.trim()+"' "; 
			}else if (table_name.trim().equalsIgnoreCase("service_other_detail")) {
				sql ="SELECT COUNT(*) AS count_dc FROM "+table_name.trim()+" WHERE branch_code = '"+branch_code.trim()+"' "; 
			}else if (table_name.trim().equalsIgnoreCase("branch_master")) {
				sql ="SELECT COUNT(*) AS count_dc FROM "+table_name.trim()+" WHERE branch_code = '"+branch_code.trim()+"' "; 
			}else{
				sql ="SELECT COUNT(*) AS count_dc FROM "+table_name.trim();	
			} 
			System.out.println(sql);
			
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
						
			if (rs.next()) {
				count_dc = DBUtility.getString("count_dc", rs);
				//System.out.println("Count :"+count_sh);
			}				
			rs.close();
			st.close();
			return count_dc;
		}catch(Exception e){
			conn.rollback();			
			throw new Exception(e.getMessage());
		}
	
	} 
	
	

}
