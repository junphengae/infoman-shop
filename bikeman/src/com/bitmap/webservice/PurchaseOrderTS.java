package com.bitmap.webservice;

import java.sql.Connection;
import java.sql.ResultSet;

import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;

public class PurchaseOrderTS {
	
	public static String tableName = "pur_purchase_order";
	
	public static void main(String[] arg) throws Exception {
		
		PurchaseOrderTS.getPurchaseOrderUpdate(new Date());
	}
	public static List<PurchaseOrderBean> getPurchaseOrderUpdate(Date dd) throws Exception {
		
		List<PurchaseOrderBean> list = new ArrayList<PurchaseOrderBean>();
		
		Connection conn = null;
		
		try{
			
			String sql = "SELECT * FROM " + tableName + " WHERE update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			
			conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				PurchaseOrderBean entity = new PurchaseOrderBean();
				DBUtility.bindResultSet(entity, rs);
				////System.out.println(entity.getPn());
				list.add(entity);
			}
			
			rs.close();
			st.close();
			
			
		}catch (Exception e) {
			
			throw new Exception("PurchaseOrderTSException: " + e.getMessage());
			
		}finally{
			
			if (conn != null) {
				conn.close();
			}
			
		}
		return list;
		
		
	
		
	}
}
