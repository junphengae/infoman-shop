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
import com.bmp.web.service.client.bean.getPurchaseOrderBean;

public class PurchaseOrderTS {
	
	public static String tableName = "pur_purchase_order";
	public static String[] keys = {"po"};
	public static String[] fieldNames = {"po","reference_po","vendor_id","approve_by","approve_date","delivery_date","receive_date","status"
							,"note","gross_amount","discount_pc","discount","net_amount","vat","vat_amount","grand_total","update_by","update_date"};

	
	public static void main(String[] arg) throws Exception {
		
		PurchaseOrderTS.getPurchaseOrderUpdate(new Date());
	}
	public static List<getPurchaseOrderBean> getPurchaseOrderUpdate(Date dd) throws Exception {
		
		List<getPurchaseOrderBean> list = new ArrayList<getPurchaseOrderBean>();
		
		Connection conn = null;
		
		try{
			
			String sql = "SELECT * FROM " + tableName + " WHERE update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			
			conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				getPurchaseOrderBean entity = new getPurchaseOrderBean();
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
	
	/**
	 * By Jack
	 * 08-01-2557
	 * @param conn
	 * @param dd
	 * @return
	 * @throws Exception 
	 */
	public static List<getPurchaseOrderBean> getPurchaseOrderUpdate(Connection conn, Date dd) throws Exception {
		List<getPurchaseOrderBean> list = new ArrayList<getPurchaseOrderBean>();		
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
			while (rs.next()) {
				getPurchaseOrderBean entity = new getPurchaseOrderBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			rs.close();
			st.close();
			
			
		}catch (Exception e) {
			if (conn != null) {
				conn.rollback();
				//conn.close();
			}
			
			throw new Exception("PurchaseOrderTSException: " + e.getMessage());
			
		}
		return list;
	}
	/**
	 * By Jack
	 * 28-03-2557
	 * @param conn
	 * @param dd
	 * @return
	 * @throws Exception 
	 */
	public static List<getPurchaseOrderBean> getPurchaseOrderUpdate(Connection conn, Date dd, String PO ) throws Exception {
		List<getPurchaseOrderBean> list = new ArrayList<getPurchaseOrderBean>();		
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
			while (rs.next()) {
				getPurchaseOrderBean entity = new getPurchaseOrderBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			rs.close();
			st.close();
			
			
		}catch (Exception e) {
			if (conn != null) {
				conn.rollback();
				//conn.close();
			}
			
			throw new Exception("PurchaseOrderTSException: " + e.getMessage());
			
		}
		return list;
	}
}
