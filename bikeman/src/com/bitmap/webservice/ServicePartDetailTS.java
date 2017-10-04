package com.bitmap.webservice;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;

public class ServicePartDetailTS {
	
	public static String tableName = "service_part_detail";
	
	public static void main(String[] arg) throws Exception{
		
		ServicePartDetailTS.getServicePartDetailUpdate(new Date());
		
	}
	public static List<ServicePartDetailBean> getServicePartDetailUpdate(Date dd) throws Exception{
		
		List<ServicePartDetailBean> list = new ArrayList<ServicePartDetailBean>();
		Connection conn = null;
		
		try{
		
			String sql = "SELECT * FROM "+tableName+" WHERE update_date > '"+DBUtility.DATE_DATABASE_FORMAT.format(dd)+"'";
			
			conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while(rs.next()){
				
				ServicePartDetailBean entity = new ServicePartDetailBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);	
			}
			
			st.close();
			rs.close();
			
		}catch (Exception e) {
			throw new Exception("ServicePartDetailTSException:"+e.getMessage());
		}
		finally{
			if(conn != null){
				
				conn.close();
				
			}
			
		}
		
		return list;
		
		
	}
	
	
	

}
