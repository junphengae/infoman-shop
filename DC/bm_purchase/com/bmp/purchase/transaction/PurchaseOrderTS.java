package com.bmp.purchase.transaction;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;

import com.bitmap.bean.purchase.PurchaseOrder;
import com.bitmap.bean.purchase.PurchaseRequest;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;
import com.bmp.purchase.bean.PurchaseOrderBean;

public class PurchaseOrderTS {
	public static String tableName = "pur_purchase_order";
	public static String[] keys = {"po"};
	public static String[] fieldNames = {"po","reference_po","vendor_id","approve_by","approve_date","delivery_date","receive_date","status","note","gross_amount","discount","discount_pc","net_amount","vat","vat_amount","grand_total","update_by","update_date","create_date","create_by"};


	public static List<PurchaseOrderBean> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		String m = "";
		String y = "";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("year")){
					y = str[1];
				} else 
				if (str[0].equalsIgnoreCase("month")) {
					m = str[1];
				} else {
					sql += " AND " + str[0] + "='" + str[1] + "'";
				}
			}
		}
		
		if (m.length() > 0) {
			Calendar sd = Calendar.getInstance();
			sd.clear();
			sd.set(Calendar.YEAR, Integer.parseInt(y));
			sd.set(Calendar.MONTH, Integer.parseInt(m) - 1);
			sd.set(Calendar.DATE, 1);
			
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			
			String s = df.format(sd.getTime());
			
			sd.add(Calendar.MONTH, +1);
			sd.add(Calendar.DATE, -1);
			String e = df.format(sd.getTime());
			
			sql += " AND (create_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99')";
		} else {
			if (y.length() > 0) {
				sql += " AND (create_date between '" + y + "-01-01 00:00:00.00' AND '" + y + "-12-31 23:59:59.99')";
			}
		}
		
		sql += " ORDER BY po  DESC";
	    //System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PurchaseOrderBean> list = new ArrayList<PurchaseOrderBean>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					PurchaseOrderBean entity = new PurchaseOrderBean();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIVendor(VendorTS.select(entity.getVendor_id(), conn));
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
	
	public static PurchaseOrderBean select(String po) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		
		PurchaseOrderBean entity = new PurchaseOrderBean();
		entity.setPo(po);
		
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIOrderList(PurchaseRequestTS.selectListByPO(po, conn));
		//entity.setUIVendor(Vendor.select(entity.getVendor_id(),conn));
		conn.close();
		return entity;
	}
	
	public static String createPO(PurchaseOrderBean po) throws SQLException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		po.setPo(genNumber(conn));
		po.setCreate_date(DBUtility.getDBCurrentDateTime());
		po.setStatus(PurchaseStatus.STATUS_PO_OPENING);
		DBUtility.insertToDB(conn, tableName, po);
		
		conn.close();
		return po.getPo();
	}
	public static String genNumber(Connection conn) throws SQLException{
		String sql = "SELECT po FROM " + tableName + " ORDER BY po DESC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		String year = (DBUtility.getCurrentYear() + "").substring(2, 4);
		String number = year + "-0001";
		
		if (rs.next()) {
			String po = DBUtility.getString("po", rs);
			String run = (Integer.parseInt(po.substring(3, po.length())) + 10001) + "";
			number = year + "-" + run.substring(1);
		}

		rs.close();
		st.close();
		return number;
	}
	
	public static PurchaseOrderBean selectInfo(String po) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		PurchaseOrderBean entity = new PurchaseOrderBean();
		entity.setPo(po);
		
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIOrderList(PurchaseRequestTS.selectListAll(po, conn));
		entity.setUIVendor(VendorTS.select(entity.getVendor_id(), conn));
		
		conn.close();
		return entity;
	}
	
	public static String updateVendor(PurchaseOrderBean entity) throws SQLException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"vendor_id"}, keys);
		conn.close();
		return entity.getPo();
	}
	
	public static void update(PurchaseOrderBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(PurchaseStatus.STATUS_PO_OPEN);
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"delivery_date","note","gross_amount","discount","discount_pc","net_amount","vat","vat_amount","grand_total","update_by","update_date","status"}, keys);
		conn.close();
	}
	
	public static List<PurchaseOrderBean> selectWithCTRLapprove(PageControl ctrl, List<String[]> params)throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 ";

		sql += " AND (status = '"+PurchaseStatus.STATUS_ORDER+"' ";
		sql += " OR status = '"+PurchaseStatus.STATUS_MD_APPROVED+"'";
		sql += " OR status = '"+PurchaseStatus.STATUS_MD_REJECT+"')";
		String m = "";
		String y = "";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("year")){
					y = str[1];
				} else 
				if (str[0].equalsIgnoreCase("month")) {
					m = str[1];
				} else {
					sql += " AND " + str[0] + "='" + str[1] + "'";
				}
			}
		}
		
		if (m.length() > 0) {
			sql += " AND MONTH(create_date) = '"+m+"'";
		} 
		
		if (y.length() > 0) {
				//sql += " AND (approve_date between '" + y + "-01-01 00:00:00.00' AND '" + y + "-12-31 23:59:59.99')";
				sql  += " AND YEAR(create_date) = '"+y+"'";
			}
		
		
		sql += " ORDER BY create_date DESC";
		////System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PurchaseOrderBean> list = new ArrayList<PurchaseOrderBean>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					PurchaseOrderBean entity = new PurchaseOrderBean();
					DBUtility.bindResultSet(entity, rs);
					//entity.setUIVendor(Vendor.select(entity.getVendor_id(), conn));
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}

	public static void approvedPo(PurchaseOrderBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setApprove_by(entity.getUpdate_by());
		entity.setApprove_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(PurchaseStatus.STATUS_MD_APPROVED);
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"status","approve_by","approve_date","update_by","update_date"}, keys);
		String pono = entity.getPo();
		PurchaseRequestTS.approvePo(pono,entity.getUpdate_by(), conn);
		conn.close();
	}

	public static void rejectPo(PurchaseOrderBean po) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		po.setUpdate_date(DBUtility.getDBCurrentDateTime());
		po.setStatus(PurchaseStatus.STATUS_MD_REJECT);
		po.setApprove_by("");
		po.setApprove_date(null);
		DBUtility.updateToDB(conn, tableName, po, new String[]{"status","approve_by","approve_date","update_by","update_date"}, keys);
		String pono = po.getPo();
		PurchaseRequestTS.rejectPo(pono,po.getUpdate_by(), conn);	
		conn.close();
	}
	
	
}
