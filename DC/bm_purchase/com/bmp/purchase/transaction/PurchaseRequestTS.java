package com.bmp.purchase.transaction;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.bitmap.bean.inventory.InventoryLot;
import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.bean.inventory.InventoryMasterVendor;
import com.bitmap.bean.parts.PartLot;
import com.bitmap.bean.parts.PartMaster;
import com.bitmap.bean.purchase.PurchaseRequest;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bmp.purchase.bean.PurchaseRequestBean;

public class PurchaseRequestTS {
	public static String tableName = "pur_purchase_request";
	public static String[] keys = {"id"};
	public static String[] keys_po = {"po"};
	public static String[] fieldNames = {"po","id","add_pr_date","pr_type","mat_code","order_qty","order_price","vendor_id","status","note","create_by","create_date","update_by","update_date","approve_by","approve_date"};


	public static List<PurchaseRequestBean> selectListByPO(String po, Connection conn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE po='" + po + "' ORDER BY add_pr_date ASC";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PurchaseRequestBean> list = new ArrayList<PurchaseRequestBean>();
		while (rs.next()) {
			PurchaseRequestBean entity = new PurchaseRequestBean();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIPartMaster(PartMaster.select(entity.getMat_code(), conn));
			
			entity.setUIInvMaster(InventoryMaster.select(entity.getMat_code(), conn));
			entity.setUIInvVendor(InventoryMasterVendor.select(entity.getMat_code(), entity.getVendor_id(), conn));
			entity.setUIInletSum(InventoryLot.totalInlet(po, entity.getMat_code()));
			list.add(entity);
		}
		
		rs.close();
		st.close();
		return list;
	}
	public static List<PurchaseRequestBean> selectListAll(String po, Connection conn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE po='" + po + "' AND status!='" + PurchaseRequest.STATUS_PO_TERMINATE + "' AND status!='" + PurchaseRequest.STATUS_CANCEL + "' ORDER BY add_pr_date ASC";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PurchaseRequestBean> list = new ArrayList<PurchaseRequestBean>();
		while (rs.next()) {
			PurchaseRequestBean entity = new PurchaseRequestBean();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIInvMaster(InventoryMaster.select(entity.getMat_code(), conn));
			entity.setUIInvVendor(InventoryMasterVendor.select(entity.getMat_code(), entity.getVendor_id(), conn));
			entity.setUIInletSum(InventoryLot.totalInlet(po, entity.getMat_code()));
			list.add(entity);
		}
		
		rs.close();
		st.close();
		return list;
	}
	
	public static List<PurchaseRequestBean> select4IssuePO(List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				sql += " AND " + str[0] + "='" + str[1] + "'";
			}
		}
			
		sql += " AND (status ='" +PurchaseStatus.STATUS_ORDER + "' )";
				
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PurchaseRequestBean> list = new ArrayList<PurchaseRequestBean>();
		while (rs.next()) {
			PurchaseRequestBean entity = new PurchaseRequestBean();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIInvMaster(InventoryMaster.select(entity.getMat_code(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static void updateStatus(PurchaseRequestBean entity, String[] fieldNames) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setApprove_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	public static void UpdateStatusAddPR(PurchaseRequestBean entity, String[] fieldNames) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setAdd_pr_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	public static void approvePo(String po,String update_by,  Connection conn) throws SQLException{
		/*{"status","approve_by","approve_date","update_by","update_date"}*/
		String sql  = "UPDATE " + tableName ;
		sql += "  SET status='" +PurchaseStatus.STATUS_MD_APPROVED+ "' ";
		sql += "  ,approve_by ='" + update_by + "'  ";
		sql += "  ,approve_date ='" + DBUtility.getDBCurrentDateTime() + "'  ";
		sql += "  ,update_by ='" + update_by + "'  ";
		sql += "  ,update_date ='" + DBUtility.getDBCurrentDateTime() + "'  ";
		sql += "  where po='" + po + "' ";
		
		Statement st = conn.createStatement();
		st.executeUpdate(sql);
		st.close();
	}
	
	public static void rejectPo(String po,String update_by, Connection conn) throws SQLException{
		
		String sql  = "UPDATE " + tableName ;
		sql += "  SET status='" +PurchaseStatus.STATUS_MD_REJECT+ "' ";
		sql += "  ,note = 'ยกเลิกใบสั่งซื้อ'  ";
		sql += "  ,approve_by = null  ";
		sql += "  ,approve_date = null  ";
		sql += "  ,update_by ='" + update_by + "'  ";
		sql += "  ,update_date ='" + DBUtility.getDBCurrentDateTime() + "'  ";
		sql += "  where po='" + po + "' ";
		
		
		Statement st = conn.createStatement();
		st.executeUpdate(sql);
		st.close();
	}
	
	public static List<PurchaseRequestBean> selectPRlist( List<String[]> params ) throws Exception{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			
					sql += " AND " + str[0] + "='" + str[1] + "'";
				
		}
		sql += " ORDER BY add_pr_date ASC";
		//System.out.println("sql:: "+sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PurchaseRequestBean> list = new ArrayList<PurchaseRequestBean>();		
		
		while (rs.next()) {			
				
					PurchaseRequestBean entity = new PurchaseRequestBean();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIPartMaster(PartMaster.select(entity.getMat_code(), conn));
					entity.setUIrecive_qty(PartLot.sumRecivePR( entity.getPo(),entity.getMat_code(), entity.getId(), conn));
					//entity.setUIrecive_qty(PartLot)
					list.add(entity);
				
		}
		rs.close();		
		conn.close();
		return list;
	}

	
	
}
