package com.bitmap.webservice;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;

public class ServiceRepairConditionTS {
	
	public static String tableName = "service_repair_condition";
	
	public static void main(String[] arg) throws Exception {
		
		ServiceRepairConditionTS.getServiceRepairConditionUpdate(new Date());
	}
	public static List<ServiceRepairConditionBean> getServiceRepairConditionUpdate(Date dd) throws Exception{
		
		List<ServiceRepairConditionBean> list = new ArrayList<ServiceRepairConditionBean>();
		
		Connection conn = null;
		
		try{
			
			String sql ="SELECT * FROM " + tableName + " WHERE update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			
			conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				ServiceRepairConditionBean entity = new ServiceRepairConditionBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			
			rs.close();
			st.close();
			
			
		}catch (Exception e) {
			throw new Exception("ServiceRepairConditionTS: " + e.getMessage());
		}
		finally{
			
			if (conn != null) {
				conn.close();
			}
		}
		return list;
		
		
		
		
	} 
	
	

}
