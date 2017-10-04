package com.bitmap.bean.purchase;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.servlet.purchase.ReportPurchase;
import com.bitmap.webutils.PageControl;
import com.bitmap.bean.inventory.Vendor;
import com.bitmap.bean.parts.PartLot;
import com.bitmap.bean.parts.PartMaster;
import com.bitmap.bean.parts.ServiceRepairDetail;
import com.bitmap.bean.purchase.PurchaseRequest;
import com.bitmap.bean.sale.Brands;
import com.bitmap.bean.inventory.InventoryLot;

public class PurchaseOrder {
	public static String tableName = "pur_purchase_order";
	public static String[] keys = {"po"};
	public static String[] fieldNames = {"po","reference_po","vendor_id","approve_by","approve_date","delivery_date","receive_date","status"
							,"note","gross_amount","discount_pc","discount","net_amount","vat","vat_amount","grand_total","update_by","update_date"};
	
	private String po = "0000001";
	private String reference_po = "";
	private String vendor_id = "";
	private String approve_by = "";
	private Timestamp approve_date = null;
	private Date delivery_date = null;
	private Timestamp receive_date = null;
	private String status = "";
	private String note = "";
	
	private String gross_amount = "0";
	private String discount_pc = "0";
	private String discount = "0";
	private String net_amount = "0";
	private String vat = "0";
	private String vat_amount = "0";
	private String grand_total = "0";
	
	private String update_by = "";
	private Timestamp update_date = null;
	
	/*private String rp_description ="";
	private String rp_vender="";
	private String rp_order_qty="";
	private String rp_price ="";
	private Date rp_date =null;
	private String rp_po = "";
	 
	public String getRp_description() {
		return rp_description;
	}
	public void setRp_description(String rp_description) {
		this.rp_description = rp_description;
	}
	public String getRp_vender() {
		return rp_vender;
	}
	public void setRp_vender(String rp_vender) {
		this.rp_vender = rp_vender;
	}
	public String getRp_order_qty() {
		return rp_order_qty;
	}
	public void setRp_order_qty(String rp_order_qty) {
		this.rp_order_qty = rp_order_qty;
	}
	public String getRp_price() {
		return rp_price;
	}
	public void setRp_price(String rp_price) {
		this.rp_price = rp_price;
	}
	public Date getRp_date() {
		return rp_date;
	}
	public void setRp_date(Date rp_date) {
		this.rp_date = rp_date;
	}
	public String getRp_po() {
		return rp_po;
	}
	public void setRp_po(String rp_po) {
		this.rp_po = rp_po;
	}*/
	
	
	Map UImap = null;
	
	 
	
	public Map getUImap() {
		return UImap;
	}
	public void setUImap(Map uImap) {
		UImap = uImap;
	}
	private com.bitmap.bean.parts.Vendor UIVendor = new com.bitmap.bean.parts.Vendor();

	public com.bitmap.bean.parts.Vendor getUIVendor() {
		return UIVendor;
	}
	public void setUIVendor(com.bitmap.bean.parts.Vendor uIVendor) {
		UIVendor = uIVendor;
	}
	private List<PurchaseRequest> UIOrderList = new ArrayList<PurchaseRequest>();
	public List<PurchaseRequest> getUIOrderList() {return UIOrderList;}
	public void setUIOrderList(List<PurchaseRequest> uIOrderList) {UIOrderList = uIOrderList;}
	
	
	
	public static void update(PurchaseOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(PurchaseRequest.STATUS_PO_OPEN);
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"delivery_date","note","gross_amount","discount","discount_pc","net_amount","vat","vat_amount","grand_total","update_by","update_date","status"}, keys);
		conn.close();
	}
	
	public static void updateAPPROVED(PurchaseOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(PurchaseRequest.STATUS_ORDER);
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"status"}, keys);
		
		conn.close();
	}
	
	public static void closePO(PurchaseOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(PurchaseRequest.STATUS_PO_CLOSE);
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"status"}, keys);
		//System.out.println("PPP : "+entity.getPo()+"  STATUS : "+entity.getStatus());
		
		conn.close();
	}
	public static PurchaseOrder selectpo(String po) throws Exception{
		PurchaseOrder entity = new PurchaseOrder();
		entity.setPo(po);
		select(entity);
		return entity;
	}
	
	public static void select(PurchaseOrder entity) throws Exception{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public static PurchaseOrder select(String po) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		PurchaseOrder entity = new PurchaseOrder();
		entity.setPo(po);
		
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIOrderList(PurchaseRequest.selectListByPO(po, conn));
		//entity.setUIVendor(Vendor.select(entity.getVendor_id(),conn));
		conn.close();
		return entity;
	}
	public static List<PurchaseOrder> selectList() throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE status!='" + PurchaseRequest.STATUS_PO_CLOSE + "' OR status='" + PurchaseRequest.STATUS_PO_TERMINATE + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PurchaseOrder> list = new ArrayList<PurchaseOrder>();
		
		while (rs.next()) {
			PurchaseOrder entity = new PurchaseOrder();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIVendor(com.bitmap.bean.parts.Vendor.select(entity.getVendor_id(), conn));
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		
		return list;
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
	public static void main(String[] str) throws SQLException{
		Connection conn = DBPool.getConnection();
		//System.out.println(PurchaseOrder.genNumber(conn));
		conn.close();
	}
	
	public static String createPO(PurchaseOrder po) throws SQLException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		po.setPo(genNumber(conn));
		po.setApprove_date(DBUtility.getDBCurrentDateTime());
		po.setStatus(PurchaseRequest.STATUS_PO_OPENING);
		DBUtility.insertToDB(conn, tableName, po);
		
		conn.close();
		return po.getPo();
	}
	
	public static String updateVendor(PurchaseOrder entity) throws SQLException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"vendor_id"}, keys);
		conn.close();
		return entity.getPo();
	}
	
	public static String createPO4cancelPO(PurchaseOrder po) throws SQLException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		po.setPo(genNumber(conn));
		po.setApprove_date(DBUtility.getDBCurrentDateTime());
		po.setStatus(PurchaseRequest.STATUS_PO_OPENING);
		DBUtility.insertToDB(conn, tableName, po);
		
		PurchaseRequest.dupicatePO(po.getPo(), po.getReference_po(), conn);
		
		conn.close();
		return po.getPo();
	}

	public static void cancelPO(PurchaseOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		entity.setStatus(PurchaseRequest.STATUS_PO_TERMINATE);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"update_by","update_date","status","note"}, keys);
		conn.close();
	}
	
	public static List<PurchaseOrder> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
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
	 //  System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PurchaseOrder> list = new ArrayList<PurchaseOrder>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					PurchaseOrder entity = new PurchaseOrder();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIVendor( com.bitmap.bean.parts.Vendor.select(entity.getVendor_id(), conn));
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
	
	public static List<PurchaseOrder> selectWithCTRLaddStock(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		
		String sql = "SELECT * FROM " + tableName + " AS po , pur_purchase_request AS pr WHERE 1=1";
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
				}  
				if (str[0].equalsIgnoreCase("status")){
					
					sql += " AND  po."+str[0]+ "='" + str[1] + "' AND pr.status != '00' AND po.po = pr.po  ";
				}
				else {
					sql += " AND  po."+str[0]+ "='" + str[1] + "'";
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
			
			sql += " AND (po.approve_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99')";
		} else {
			if (y.length() > 0) {
				sql += " AND (po.approve_date between '" + y + "-01-01 00:00:00.00' AND '" + y + "-12-31 23:59:59.99')";
			}
		}
		
		sql += " ORDER BY po.approve_date ASC";
		
		////System.out.println("sql:"+sql);
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PurchaseOrder> list = new ArrayList<PurchaseOrder>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					PurchaseOrder entity = new PurchaseOrder();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIVendor(com.bitmap.bean.parts.Vendor.select(entity.getVendor_id(), conn));
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
	/**
	 * Used: inlet.jsp
	 * <br>
	 * For check PO and select PR List
	 * @param entity
	 * @return
	 * @throws IllegalArgumentException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws UnsupportedEncodingException
	 */
	public  static boolean check(String po) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PurchaseOrder entity = new PurchaseOrder();
		entity.setPo(po);
		return checkpo(entity);
	}
	public  static boolean checkpo(PurchaseOrder entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}
	
	public static boolean check(PurchaseOrder entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		entity.setStatus(PurchaseRequest.STATUS_PO_OPEN);
		boolean has = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"po","status"});
		
		if (has) {
			entity.setUIOrderList(PurchaseRequest.selectListByPO(entity.getPo(), conn));
			entity.setUIVendor(com.bitmap.bean.parts.Vendor.select(entity.getVendor_id(), conn));
		}
		
		conn.close();
		return has;
	}
	
	/**
	 * Used: InventoryLot.insert()
	 * <br>
	 * For Control Status when Inlet by Purchase
	 * @param po
	 * @param update_by
	 * @throws IllegalArgumentException
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static void controlStatus(String po, String update_by) throws IllegalArgumentException, UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		PurchaseOrder PO = select(po);
		Iterator<PurchaseRequest> prIte = PO.getUIOrderList().iterator();
		
		boolean poClose = true;
		
		while (prIte.hasNext()) {
			PurchaseRequest pr = (PurchaseRequest) prIte.next();
			if (pr.getUIInletSum() >= DBUtility.getDouble(pr.getOrder_qty())){
				pr.setUpdate_by(update_by);
				pr.setStatus(PurchaseRequest.STATUS_PO_CLOSE);
				PurchaseRequest.updateStatus(pr, new String[]{"status","update_by","update_date"});
			} else {
				poClose = false;
			}
		}
		
		if (poClose) {
			Connection conn = DBPool.getConnection();
			PO.setUpdate_by(update_by);
			PO.setUpdate_date(DBUtility.getDBCurrentDateTime());
			PO.setReceive_date(DBUtility.getDBCurrentDateTime());
			PO.setStatus(PurchaseRequest.STATUS_PO_CLOSE);
			DBUtility.updateToDB(conn, tableName, PO, new String[]{"receive_date","update_by","update_date","status"}, keys);
			conn.close();
		}
	}
	
	public static List<PurchaseReport> report4purchase(String year, String month) throws UnsupportedEncodingException, IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		Calendar sd = Calendar.getInstance();
		sd.clear();
		sd.set(Calendar.YEAR, Integer.parseInt(year));
		sd.set(Calendar.MONTH, Integer.parseInt(month) - 1);
		sd.set(Calendar.DATE, 1);
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		
		String s = df.format(sd.getTime());
		
		sd.add(Calendar.MONTH, +1);
		sd.add(Calendar.DATE, -1);
		String e = df.format(sd.getTime());
		
		String sql = "SELECT count(*) AS cnt, vendor_id FROM " + tableName + " WHERE approve_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99' AND status !='" + PurchaseRequest.STATUS_PO_OPENING + "'  GROUP BY vendor_id";
		////System.out.println("m : " + sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PurchaseReport> list = new ArrayList<PurchaseReport>();
		while (rs.next()) {
			PurchaseReport rp = new PurchaseReport();
			rp.setDate_start(s);
			rp.setDate_end(e);
			
			rp.setPo_sum(DBUtility.getString("cnt", rs));
			rp.setVendor(Vendor.select(DBUtility.getString("vendor_id", rs), conn)); 
			////System.out.println("vendor: " + rp.getVendor().getVendor_id() + " , ");
			report4checkDue(rp, conn);
			
			list.add(rp);
		}
		rs.close();
		st.close();
		conn.close();
		
		return list;
		
		/*
		 	select DISTINCT(vendor_id) from pur_purchase_order where 
			approve_date BETWEEN '2011-11-01 00:00:00.00' AND '2011-11-30 23:59:59.99' and status !='45' and status!='40' 
			
			select count(*), vendor_id as cnt from pur_purchase_order where 
			approve_date BETWEEN '2011-11-01 00:00:00.00' AND '2011-11-30 23:59:59.99' and status !='45' and status!='40' 
			GROUP by vendor_id
			
			
			select inv_lot.po,inv_lot.create_date,pur_purchase_order.delivery_date,pur_purchase_order.vendor_id from inv_lot, pur_purchase_order where inv_lot.po = pur_purchase_order.po 
			group by pur_purchase_order.vendor_id,inv_lot.po
		 */
	}
	
	public static void report4checkDue(PurchaseReport rp, Connection conn) throws SQLException{
		String sql = "SELECT " + 
						InventoryLot.tableName + ".po," + 
						InventoryLot.tableName + ".create_date," + 
						tableName + ".delivery_date " +
					 "FROM " + tableName + "," + InventoryLot.tableName + " " +
					 "WHERE " +
					 	tableName + ".vendor_id ='" + rp.getVendor().getVendor_id() + "' AND " +
					 	InventoryLot.tableName + ".po = " + tableName + ".po AND " +
					 	tableName + ".approve_date between '" + rp.getDate_start() + " 00:00:00.00' AND '" + rp.getDate_end() + " 23:59:59.99' " +
					 "GROUP BY " + InventoryLot.tableName + ".po";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		int on = 0;
		int late = 0;
		while (rs.next()) {
			Date c = DBUtility.getDate("create_date", rs);
			Date d = DBUtility.getDate("delivery_date", rs);
			if (c.getTime() <= d.getTime()) {
				on++;
			} else {
				late++;
			}
		}
		rp.setPo_close_on_time(on + "");
		rp.setPo_close_late(late + "");
		rs.close();
		st.close();
		
		sql = "SELECT count(*) AS cnt FROM " + tableName + " WHERE approve_date between '" + rp.getDate_start() + " 00:00:00.00' AND '" + rp.getDate_end() + " 23:59:59.99' AND status ='" + PurchaseRequest.STATUS_PO_TERMINATE + "' AND vendor_id ='" + rp.getVendor().getVendor_id() + "'";
		st = conn.createStatement();
		rs = st.executeQuery(sql);
		while (rs.next()) {
			rp.setPo_terminate(DBUtility.getString("cnt", rs));
		}
		rs.close();
		st.close();
		
		
	}
	
	
	
	
	
	////////////


	public static PurchaseOrder selectInfo(String po) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		PurchaseOrder entity = new PurchaseOrder();
		entity.setPo(po);
		
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIOrderList(PurchaseRequest.selectListAll(po, conn));
		entity.setUIVendor(com.bitmap.bean.parts.Vendor.select(entity.getVendor_id(), conn));
		
		conn.close();
		return entity;
	}
	
	
	
	
	public static List<PurchaseOrder> selectWithCTRLapprove(PageControl ctrl, List<String[]> params)throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 ";

		sql += " AND (status = '"+PurchaseRequest.STATUS_ORDER+"' ";
		sql += " OR status = '"+PurchaseRequest.STATUS_MD_APPROVED+"'";
		sql += " OR status = '"+PurchaseRequest.STATUS_MD_REJECT+"')";
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
			sql += " AND MONTH(approve_date) = '"+m+"'";
		} 
		
		if (y.length() > 0) {
				//sql += " AND (approve_date between '" + y + "-01-01 00:00:00.00' AND '" + y + "-12-31 23:59:59.99')";
				sql  += " AND YEAR(approve_date) = '"+y+"'";
			}
		
		
		sql += " ORDER BY approve_date DESC";
		////System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PurchaseOrder> list = new ArrayList<PurchaseOrder>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					PurchaseOrder entity = new PurchaseOrder();
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
	
	
	
	
	
	public static void approvedPo(PurchaseOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(PurchaseRequest.STATUS_MD_APPROVED);
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"status"}, keys);
		String pono = entity.getPo();
		PurchaseRequest.approvePo(pono, conn);
		conn.close();
	}
	public static void rejectPo(PurchaseOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(PurchaseRequest.STATUS_MD_REJECT);
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"status"}, keys);
		String pono = entity.getPo();
		PurchaseRequest.rejectPo(pono, conn);
	/*	String pono = entity.getPo();
		//System.out.println("PO reject : "+pono);
		PurchaseRequest.delete(pono, conn);
	*/
	//	String pono = entity.getPo();
	//	PurchaseRequest.
		conn.close();
	}
	
	public static List<ReportPurchase> listreport(List<String[]> paramsList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
		List<ReportPurchase> list = new ArrayList<ReportPurchase>();
		Connection conn = DBPool.getConnection();
		
		String  sql = "SELECT po.approve_date AS rp_date ,po.po AS rp_po " ;
		sql +=" ,part.description AS rp_description  " ;
		sql +=" ,part.des_unit AS rp_desUnit  " ;
		sql +=" ,pv.vendor_name AS rp_vender " ;
		sql +=" ,pr.order_qty AS rp_order_qty, pr.order_price AS rp_price " ;
		sql +="  FROM pur_purchase_order AS po  " ;
		sql +="  LEFT JOIN pur_purchase_request AS pr ON po.po = pr.po  " ;
		sql +="  LEFT JOIN pa_part_master AS part ON pr.mat_code = part.pn  " ;
		sql +="  LEFT JOIN pa_vendor AS pv ON pv.vendor_id = pr.vendor_id  " ;
		sql +="WHERE 1=1";
		//LEFT JOIN pa_vendor AS pv LEFT JOIN pa_part_master
		Iterator<String[]> ite = paramsList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
					
					if (str[0].equalsIgnoreCase("create_date")){
						
						sql +="AND DATE_FORMAT(po.approve_date, '%Y-%m-%d')='"+str[1]+"' " ;
						
					} 
					else if (str[0].equalsIgnoreCase("year_month")){
						
						sql +="AND DATE_FORMAT(po.approve_date, '%Y-%m')='"+str[1]+"' " ;
						
					} 
					else if (str[0].equalsIgnoreCase("date_send2")){
						
						sql +="AND DATE_FORMAT(po.approve_date, '%Y-%m-%d') BETWEEN '"+str[1]+"' AND '"+str[2]+"' ";
						
					}
					
					else {
						
						sql += " AND po."+ str[0] + "='" + str[1] + "' ";
						
						
						
					}
				
						
			}
		}
		
		sql += " ORDER BY (po.po*1) asc";
		
		//System.out.println("sql::"+sql);
		
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			ReportPurchase entity = new ReportPurchase();
			DBUtility.bindResultSet(entity, rs);
			
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	

	
	/*public static List<PurchaseOrder> listreport(List<String[]> paramsList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
		List<PurchaseOrder> list = new ArrayList<PurchaseOrder>();
		Connection conn = DBPool.getConnection();
		
		String  sql = "SELECT po.approve_date AS rp_date ,po.po AS rp_po  " ;
		sql +="   ,part.description AS rp_description  " ;
		sql +=" ,pv.vendor_name AS rp_vender " ;
		sql +=" ,pr.order_qty AS rp_order_qty, pr.order_price AS rp_price " ;
		sql +="  FROM pur_purchase_order AS po  " ;
		sql +="  LEFT JOIN pur_purchase_request AS pr ON po.po = pr.po  " ;
		sql +="  LEFT JOIN pa_part_master AS part ON pr.mat_code = part.pn  " ;
		sql +="  LEFT JOIN pa_vendor AS pv ON pv.vendor_id = po.vendor_id  " ;
		
		//LEFT JOIN pa_vendor AS pv LEFT JOIN pa_part_master
		Iterator<String[]> ite = paramsList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
					
					if (str[0].equalsIgnoreCase("create_date")){
						
						sql +="AND DATE_FORMAT(po.create_date, '%Y-%m-%d')='"+str[1]+"' " ;
						
					} 
					else if (str[0].equalsIgnoreCase("year_month")){
						
						sql +="AND DATE_FORMAT(po.create_date, '%Y-%m')='"+str[1]+"' " ;
						
					} 
					else if (str[0].equalsIgnoreCase("date_send2")){
						
						sql +="AND DATE_FORMAT(po.create_date, '%Y-%m-%d') BETWEEN 'po."+str[1]+"' AND '"+str[2]+"' ";
						
					}
					
					else {
						
						sql += " AND po."+ str[0] + "='" + str[1] + "' ";
						
					}
				
						
			}
		}
		
		sql += " ORDER BY (po.po*1) desc";
		
		//System.out.println("sql::"+sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			PurchaseOrder entity = new PurchaseOrder();
			DBUtility.bindResultSet(entity, rs);
			
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	*/
	
	
	
	public String getPo() {
		return po;
	}

	public void setPo(String po) {
		this.po = po;
	}

	public String getReference_po() {
		return reference_po;
	}

	public void setReference_po(String reference_po) {
		this.reference_po = reference_po;
	}

	public String getVendor_id() {
		return vendor_id;
	}

	public void setVendor_id(String vendor_id) {
		this.vendor_id = vendor_id;
	}

	public String getApprove_by() {
		return approve_by;
	}

	public void setApprove_by(String approve_by) {
		this.approve_by = approve_by;
	}

	public Timestamp getApprove_date() {
		return approve_date;
	}

	public void setApprove_date(Timestamp approve_date) {
		this.approve_date = approve_date;
	}

	public Date getDelivery_date() {
		return delivery_date;
	}

	public void setDelivery_date(Date delivery_date) {
		this.delivery_date = delivery_date;
	}

	public Timestamp getReceive_date() {
		return receive_date;
	}

	public void setReceive_date(Timestamp receive_date) {
		this.receive_date = receive_date;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public String getGross_amount() {
		return gross_amount;
	}

	public void setGross_amount(String gross_amount) {
		this.gross_amount = gross_amount;
	}

	public String getDiscount() {
		return discount;
	}

	public void setDiscount(String discount) {
		this.discount = discount;
	}

	public String getNet_amount() {
		return net_amount;
	}

	public void setNet_amount(String net_amount) {
		this.net_amount = net_amount;
	}

	public String getVat() {
		return vat;
	}

	public void setVat(String vat) {
		this.vat = vat;
	}

	public String getGrand_total() {
		return grand_total;
	}

	public void setGrand_total(String grand_total) {
		this.grand_total = grand_total;
	}

	public String getUpdate_by() {
		return update_by;
	}

	public void setUpdate_by(String update_by) {
		this.update_by = update_by;
	}

	public Timestamp getUpdate_date() {
		return update_date;
	}

	public void setUpdate_date(Timestamp update_date) {
		this.update_date = update_date;
	}
	public String getVat_amount() {
		return vat_amount;
	}
	public void setVat_amount(String vat_amount) {
		this.vat_amount = vat_amount;
	}
	public String getDiscount_pc() {
		return discount_pc;
	}
	public void setDiscount_pc(String discount_pc) {
		this.discount_pc = discount_pc;
	}
	

	
}