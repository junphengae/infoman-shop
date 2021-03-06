package com.bitmap.webservice;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;


public class ServiceOutsourceDetailTS {
	
	public static String tableName = "";
	
	public static void main(String[] arg) throws Exception{
		
		ServiceOutsourceDetailTS.getServiceOutsourceDetailUpdate(new Date());
		
	}
	public static List<ServiceOutsourceDetailBean> getServiceOutsourceDetailUpdate(Date dd) throws Exception {
		List<ServiceOutsourceDetailBean> list = new ArrayList<ServiceOutsourceDetailBean>();
		Connection conn = null;
		try{
			
			String sql ="SELECT * FROM "+tableName+ " WHERE update_date > ' "+DBUtility.DATE_DATABASE_FORMAT.format(dd)+"'";
			
			conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			
			while(rs.next()){
				
				ServiceOutsourceDetailBean entity = new ServiceOutsourceDetailBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			
			st.close();
			rs.close();
			
		}
		catch (Exception e) {
			throw new Exception("ServiceOutsourceDetailTSException:" + e.getMessage());
		}
		finally{
			
			if(conn != null){
				
				conn.close();
			}
			
		}
		
		
		
		return list;
	}

}
