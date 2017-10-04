package com.bmp.web.service.transaction;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.WebUtils;
import com.bmp.web.service.client.bean.getPurchaseRequestBean;


public class PurchaseRequestTS {
	
	public static String tableName = "pur_purchase_request";
	public static String[] keys = {"id"};
	public static String[] keys_po = {"po"};
	public static String[] fieldName = {"po","id","pr_type","mat_code","order_qty","order_price","vendor_id","status","note"
										,"create_by","update_by ","approve_by" };	
	
	public static void main() throws Exception {
		
		PurchaseRequestTS.getPurchaseRequesUpdate(new Date());
		
		
	}

	public static List<getPurchaseRequestBean> getPurchaseRequesUpdate(Date dd) throws Exception {
		List<getPurchaseRequestBean> list = new ArrayList<getPurchaseRequestBean>();
		
		Connection conn = null;
		try{
			
			String sql = "SELECT * FROM " + tableName + " WHERE update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			
			conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while(rs.next()){
				
				getPurchaseRequestBean entity = new getPurchaseRequestBean();
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

	public static List<getPurchaseRequestBean> getPurchaseRequesUpdate(Connection conn,Date dd) throws Exception {
		List<getPurchaseRequestBean> list = new ArrayList<getPurchaseRequestBean>();
		
		try{
			
			String time = "01/01/0001" ;
			String dd2 = WebUtils.getDateValue(dd);
			String sql = "SELECT * FROM "+tableName+ " WHERE 1=1 " ;
			if (!time.equalsIgnoreCase(dd2)) {
			 
			 sql+=" AND update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			}
			System.out.println(sql);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while(rs.next()){
				
				getPurchaseRequestBean entity = new getPurchaseRequestBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
				
			}
			
			st.close();
			rs.close();
			
		}catch (Exception e) {
			if (conn != null) {
				conn.rollback();
				//conn.close();
			}
			throw new Exception("PurchaseRequestTSException: " + e.getMessage());
		}
		
		return list;
	}

	/**
	 * 28-03-2557
	 * @param conn
	 * @param dd
	 * @param PO
	 * @return
	 * @throws Exception
	 */
	public static List<getPurchaseRequestBean> getPurchaseRequesUpdate(Connection conn,Date dd,String PO) throws Exception {
		List<getPurchaseRequestBean> list = new ArrayList<getPurchaseRequestBean>();
		
		try{
			
			String time = "01/01/0001" ;
			String dd2 = WebUtils.getDateValue(dd);
			String sql = "SELECT * FROM "+tableName+ " WHERE 1=1 " ;
			if (!PO.trim().equalsIgnoreCase("")) {			 
			 sql+=" AND po = '" + PO.trim() + "'";
			}
			System.out.println(sql);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while(rs.next()){
				
				getPurchaseRequestBean entity = new getPurchaseRequestBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
				
			}
			
			st.close();
			rs.close();
			
		}catch (Exception e) {
			if (conn != null) {
				conn.rollback();
				//conn.close();
			}
			throw new Exception("PurchaseRequestTSException: " + e.getMessage());
		}
		
		return list;
	}
}
