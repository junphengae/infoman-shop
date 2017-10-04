package com.bitmap.webservice;

import java.sql.Connection;
import java.sql.ResultSet;

import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;


public class PurchaseRequestTS {
	
	public static String tableName = "pur_purchase_request";
	
	public static void main() throws Exception {
		
		PurchaseRequestTS.getPurchaseRequesUpdate(new Date());
		
		
	}

	public static List<PurchaseRequestBean> getPurchaseRequesUpdate(Date dd) throws Exception {
		List<PurchaseRequestBean> list = new ArrayList<PurchaseRequestBean>();
		
		Connection conn = null;
		try{
			
			String sql = "SELECT * FROM " + tableName + " WHERE update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			
			conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while(rs.next()){
				
				PurchaseRequestBean entity = new PurchaseRequestBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
				
			}
			
			st.close();
			rs.close();
			
		}catch (Exception e) {
			throw new Exception("PurchaseRequestTSException: " + e.getMessage());
		}
		finally{
			
			if (conn != null) {
				conn.close();
			}
			
		}
		
		return list;
	}

}
