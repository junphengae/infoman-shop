package com.bitmap.webservice;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;

public class ServiceOtherDetailTS {
	
	public static String tableName = "service_other_detail";
	
	public static void main(String[] arg) throws Exception {
		
		ServiceOtherDetailTS.getServiceOtherDetailUpdate(new Date());
	
	}
	public static List<ServiceOtherDetailBean> getServiceOtherDetailUpdate(Date dd) throws Exception {
		
		List<ServiceOtherDetailBean> list = new ArrayList<ServiceOtherDetailBean>();
		
		Connection conn = null;
		
		try{
			
			String sql ="SELECT * FROM "+tableName+" WHERE update_date > '"+DBUtility.DATE_DATABASE_FORMAT.format(dd)+"'";
			
			conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while(rs.next()){
				
				ServiceOtherDetailBean entity = new ServiceOtherDetailBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			
			st.close();
			rs.close();
			
		}catch (Exception e) {
			
			throw new Exception("ServiceOtherDetailTSException:"+e.getMessage());
			
		}
		finally{
			
			if(conn != null){
				
				conn.close();
			}
			
		}
		
		return list;
	
		
	}

}
