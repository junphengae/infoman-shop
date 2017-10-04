package com.bitmap.webservice;

import java.sql.Connection;
import java.sql.ResultSet;

import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.WebUtils;


public class PurchaseRequestTS {
	
	public static String tableName = "pur_purchase_request";
	
	public static void main() throws Exception {
		
			//PurchaseRequestTS.getPurchaseRequesUpdate(new Date());
		
		
	}

	public static List<PurchaseRequestBean> getPurchaseRequesUpdate(Connection conn,Date dd) throws Exception {
		List<PurchaseRequestBean> list = new ArrayList<PurchaseRequestBean>();
		//Connection conn = null;
		try{
			
			String time = "01/01/0001" ;
			String dd2 = WebUtils.getDateValue(dd);
			String sql = "SELECT * FROM "+tableName+ " WHERE 1=1 " ;
			if (!time.equalsIgnoreCase(dd2)) {
			 
			 sql+=" AND update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			}
			//conn = DBPool.getConnection();
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
			conn.rollback();
			conn.close();
			throw new Exception("PurchaseRequestTSException: " + e.getMessage());
		}
		
		
		return list;
	}

}
