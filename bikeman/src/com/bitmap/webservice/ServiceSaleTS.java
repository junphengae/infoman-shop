package com.bitmap.webservice;

import java.sql.Connection;
import java.sql.ResultSet;

import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;

public class ServiceSaleTS {
	
	public static String tableName = "service_sale";
	
	public static void main() throws Exception {
		
		ServiceSaleTS.getServiceSaleUpdate(new Date());
	}
	public static List<ServiceSaleBean> getServiceSaleUpdate(Date dd) throws Exception {
		
		List<ServiceSaleBean> list = new ArrayList<ServiceSaleBean>();
		
		Connection conn = null;
		try{
			
			String sql ="SELECT * FROM " + tableName + " WHERE update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'"; 
			
			conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				ServiceSaleBean entity = new ServiceSaleBean();
				DBUtility.bindResultSet(entity, rs);
				////System.out.println(entity.getPn());
				list.add(entity);
			}
			
			rs.close();
			st.close();
			
			
		}catch (Exception e) {
			throw new Exception("ServiceSaleTSException: " + e.getMessage());
		}
		finally{
			if (conn != null) {
				conn.close();
			}
		}
		return list;
		
	}
	

}
