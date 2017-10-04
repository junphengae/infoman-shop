package com.bitmap.webservice;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;

public class SaleOrderServiceTS {
		
	public static String tableName = "sale_order_service";
	
	public static void main(String[] arg) throws Exception{
		
		SaleOrderServiceTS.getSaleOrderServiceUpdate(new Date());
	}

	public static List<SaleOrderServiceBean> getSaleOrderServiceUpdate(Date dd) throws Exception{
		

		
		List<SaleOrderServiceBean> list = new ArrayList<SaleOrderServiceBean>();
		
		Connection conn = null;
		
		try{
			
			String sql = "SELECT * FROM "+tableName+" WHERE update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			
			conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				SaleOrderServiceBean entity = new SaleOrderServiceBean();
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
}
