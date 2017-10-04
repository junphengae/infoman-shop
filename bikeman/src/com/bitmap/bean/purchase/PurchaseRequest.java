package com.bitmap.bean.purchase;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.bitmap.bean.inventory.InventoryLot;
import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.bean.inventory.InventoryMasterVendor;
import com.bitmap.bean.parts.PartMaster;
import com.bitmap.bean.parts.PartLot;
import com.bitmap.bean.parts.Vendor;
import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class PurchaseRequest {
	public static String TYPE_PARTS = "P";
	public static String TYPE_INVTY = "I";
	
	public static String STATUS_CANCEL = "00";
	
	public static String STATUS_ORDER = "10";
	
	public static String STATUS_AC_APPROVED = "20";
	public static String STATUS_AC_PASS = "21";	
	public static String STATUS_AC_REPL = "22";
	public static String STATUS_AC_REJECT = "25";

	public static String STATUS_MD_APPROVED = "30";
	public static String STATUS_MD_REJECT_EDIT = "33";
	public static String STATUS_MD_REJECT = "35";
	
	public static String STATUS_PO_OPENING = "40";
	public static String STATUS_PO_OPEN = "41";
	public static String STATUS_PO_CLOSE = "42";
	public static String STATUS_PO_TERMINATE = "45";
	
	
	public static List<String[]> statusDropdown(){
		List<String[]> list = new ArrayList<String[]>();
		
		list.add(new String[]{STATUS_CANCEL, "ยกเลิก"});
		list.add(new String[]{STATUS_ORDER, "รออนุมัติ"});
		list.add(new String[]{STATUS_MD_APPROVED, "อนุมัติแล้ว"});
		list.add(new String[]{STATUS_MD_REJECT_EDIT, "รอการแก้ไข"});
		list.add(new String[]{STATUS_MD_REJECT, "ไม่อนุมัติ"});
		list.add(new String[]{STATUS_PO_OPENING, "กำลังสร้าง PO"});
		list.add(new String[]{STATUS_PO_OPEN, "เปิด PO"});
		list.add(new String[]{STATUS_PO_CLOSE, "ปิด PO"});
		list.add(new String[]{STATUS_PO_TERMINATE, "ยกเลิก PO"});
		
		return list;
	}
	
	public static List<String[]> statusDropdown4PO(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{STATUS_PO_OPENING, "กำลังสร้าง PO"});
		list.add(new String[]{STATUS_PO_OPEN, "เปิด PO"});
		list.add(new String[]{STATUS_PO_CLOSE, "ปิด PO"});
		list.add(new String[]{STATUS_PO_TERMINATE, "ยกเลิก PO"});
		return list;
	}
	
	public static List<String[]> statusDropdownReStatusPO(){
		List<String[]> list = new ArrayList<String[]>();
		
		list.add(new String[]{STATUS_PO_OPENING, "กำลังสร้าง PO"});
		list.add(new String[]{STATUS_PO_OPEN, "เปิด PO"});
		list.add(new String[]{STATUS_PO_CLOSE, "ปิด PO"});
		list.add(new String[]{STATUS_PO_TERMINATE, "ยกเลิก PO"});
		list.add(new String[]{STATUS_CANCEL,"ยกเลิก"});
		list.add(new String[]{STATUS_ORDER,"รออนุมัติ"});
		list.add(new String[]{STATUS_MD_APPROVED,"อนุมัติแล้ว"});
		list.add(new String[]{STATUS_MD_REJECT_EDIT,"รอการแก้ไข"});
		list.add(new String[]{STATUS_MD_REJECT,"ไม่อนุมัติ"});
		
		
		
		return list;
	}

	public static List<String[]> statusDropdown4POapprove(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{STATUS_ORDER, "รออนุมัติ"});
		list.add(new String[]{STATUS_MD_APPROVED, "อนุมัติแล้ว"});
		list.add(new String[]{STATUS_MD_REJECT, "ไม่อนุมัติ"});

		return list;
	}
	
	public static String status(String status){
		HashMap<String , String> map = new HashMap<String, String>();
		map.put(STATUS_CANCEL, "ยกเลิก");
		map.put(STATUS_ORDER, "รออนุมัติ");
		map.put(STATUS_MD_APPROVED, "อนุมัติแล้ว");
		map.put(STATUS_MD_REJECT_EDIT, "รอการแก้ไข");
		map.put(STATUS_MD_REJECT, "ไม่อนุมัติ");
		
		map.put(STATUS_PO_OPENING, "กำลังสร้าง PO");
		map.put(STATUS_PO_OPEN, "เปิด PO");
		map.put(STATUS_PO_CLOSE, "ปิด PO");
		map.put(STATUS_PO_TERMINATE, "ยกเลิก PO");
		
		return map.get(status);
	}
	
	public static List<String[]> prTypeDropdown(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{TYPE_PARTS, "Parts"});
		list.add(new String[]{TYPE_INVTY, "Inventory"});
		return list;
	}
	
	public static String PR_Type(String type){
		HashMap<String , String> map = new HashMap<String, String>();
		map.put(TYPE_PARTS, "Parts");
		map.put(TYPE_INVTY, "Inventory");
		return map.get(type);
	}
	
	public static String tableName = "pur_purchase_request";
	private static String[] keys = {"id"};
	private static String[] keys_po = {"po"};
	private static String[] fieldNames = {"order_qty","order_price","vendor_id","update_by","update_date","note"};
	private static String[] updateField = {"status","update_by","update_date"};
	private static String[] updateNoteField = {"status","update_by","update_date","note"};
	private static String[] approveField = {"status","approve_by","approve_date"};
	private static String[] approveNoteField = {"status","approve_by","approve_date","note"};
	
	String po = "";
	String id = "";
	String pr_type = "";
	String mat_code = "";
	String order_qty = "";
	String order_price = "0";
	String vendor_id = "";
	String status = "10";
	String note = "";
	String create_by = "";
	String update_by = "";
	String approve_by = "";
	Timestamp create_date = null;
	Timestamp update_date = null;
	Timestamp approve_date = null;
	Timestamp add_pr_date = null;
	
	String UIrecive_qty = "0";
	String UIcnt = "";

	Double UIInletSum = 0.0;
	public Double getUIInletSum() {return UIInletSum;}
	public void setUIInletSum(Double uIInletSum) {UIInletSum = uIInletSum;}
	
	private InventoryMasterVendor UIInvVendor = new InventoryMasterVendor();
	public InventoryMasterVendor getUIInvVendor() {return UIInvVendor;}
	public void setUIInvVendor(InventoryMasterVendor uIInvVendor) {UIInvVendor = uIInvVendor;}

	private InventoryMaster UIInvMaster = new InventoryMaster();
	public InventoryMaster getUIInvMaster() {return UIInvMaster;}
	public void setUIInvMaster(InventoryMaster uIInvMaster) {UIInvMaster = uIInvMaster;}
	
	private PartMaster UIPartMaster = new PartMaster();
	public PartMaster getUIPartMaster() {return UIPartMaster;}
	public void setUIPartMaster(PartMaster uIPartMaster) {UIPartMaster = uIPartMaster;}
	
	public static List<String[]> vendorDropdown() throws SQLException{
		String sql = "SELECT DISTINCT(pr.vendor_id) AS value, vd.vendor_name AS text " +
					 "FROM " + tableName + "  pr INNER JOIN " + Vendor.tableName + " vd ON pr.vendor_id = vd.vendor_id ";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<String[]> list = new ArrayList<String[]>();
		while(rs.next()){
			HashMap<String,Object> entity = DBUtility.getEntity(rs);
			String value = (String) entity.get("value");
			String text = (String) entity.get("text");
			String[] data = {value,text};
			list.add(data);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<String[]> vendorDropdown4PR() throws SQLException{
		String sql = "SELECT DISTINCT(pr.vendor_id) AS value, vd.vendor_name AS text " +
					 "FROM " + tableName + "  pr INNER JOIN " + Vendor.tableName + " vd ON pr.vendor_id = vd.vendor_id " +
					 "WHERE status='10'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<String[]> list = new ArrayList<String[]>();
		while(rs.next()){
			HashMap<String,Object> entity = DBUtility.getEntity(rs);
			String value = (String) entity.get("value");
			String text = (String) entity.get("text");
			String[] data = {value,text};
			list.add(data);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<String[]> vendorDropdown4PO() throws SQLException{
		String sql = "SELECT DISTINCT(pr.vendor_id) AS value, vd.vendor_name AS text " +
					 "FROM " + tableName + "  pr INNER JOIN " + Vendor.tableName + " vd ON pr.vendor_id = vd.vendor_id " +
					 "WHERE status='20' OR status='30'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<String[]> list = new ArrayList<String[]>();
		while(rs.next()){
			HashMap<String,Object> entity = DBUtility.getEntity(rs);
			String value = (String) entity.get("value");
			String text = (String) entity.get("text");
			String[] data = {value,text};
			list.add(data);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static PurchaseRequest select(String id) throws Exception{
		PurchaseRequest entity = new PurchaseRequest();
		entity.setId(id);
		select(entity);
		return entity;
	}
	
	public static void select(PurchaseRequest entity) throws Exception{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIrecive_qty(PartLot.sumRecivePR(entity.getPo(), entity.getMat_code(), entity.getId() ,conn));
		conn.close();
	}
	public static PurchaseRequest select1(PurchaseRequest entity) throws Exception{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIrecive_qty(PartLot.sumRecivePR(entity.getPo(), entity.getMat_code(), entity.getId() ,conn));
		conn.close();
		return entity;
	}
	
	
	public static PurchaseRequest select(String po ,String mat_code) throws Exception{
		PurchaseRequest entity = new PurchaseRequest();
		entity.setPo(po);
		entity.setMat_code(mat_code);
		selectmat_code_po(entity);
		return entity;
	}
	
	public static void selectmat_code_po(PurchaseRequest entity) throws Exception{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"po","mat_code"});
		conn.close();
	}
	

	public static PurchaseRequest select(String po, Connection conn) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		PurchaseRequest entity = new PurchaseRequest();
		entity.setPo(entity.getPo());
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		return entity;
}
	
	public static void delete(String po, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
			
		PurchaseRequest entity = new PurchaseRequest();
		entity.setPo(po);
		DBUtility.deleteFromDB(conn,  tableName, entity,  keys_po);
	}
	
	public static void select4Inlet(PurchaseRequest entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIInvMaster(InventoryMaster.select(entity.getMat_code(), conn));
		entity.setUIInletSum(InventoryLot.totalInlet(entity.getPo(), entity.getMat_code()));
		conn.close();
	}
	
	public static void insert(PurchaseRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		
		entity.setId(DBUtility.genNumber(conn, tableName, "id"));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		
		conn.close();
	}
	
	public static void update(PurchaseRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public static void update_datePR(PurchaseRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"update_by","update_date"}, keys);
		conn.close();
	}
	
	public static void updateStatus(PurchaseRequest entity, String[] fieldNames) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setApprove_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	public static void updateStatusRemove(PurchaseRequest entity, String[] fieldNames) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setAdd_pr_date(null);
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	/**
	 * By JACK 27-02-2557
	 * @param entity  PurchaseRequest
	 * @param fieldNames = {"po","status","add_pr_date","update_by","update_date"}
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 */
	public static void updateStatusAddPR(PurchaseRequest entity, String[] fieldNames) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setAdd_pr_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}

	public static void updateStatusClosePo(PurchaseRequest entity, String[] fieldNames) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setApprove_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys_po);
		conn.close();
	}
	
	public static void status_cancel(PurchaseRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_CANCEL);
		updateStatus(entity, updateNoteField);
	}
	
	public static void status_ac_approve(PurchaseRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_AC_APPROVED);
		updateStatus(entity, approveNoteField);
	}
	
	public static void status_ac_pass(PurchaseRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_AC_PASS);
		updateStatus(entity, updateNoteField);
	}
	
	public static void status_ac_reject(PurchaseRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_AC_REJECT);
		updateStatus(entity, approveNoteField);
	}
	
	public static void status_md_approve(PurchaseRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_MD_APPROVED);
		updateStatus(entity, approveNoteField);
	}
	
	public static void status_md_reject(PurchaseRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_MD_REJECT);
		updateStatus(entity, approveNoteField);
	}
	
	public static void status_po_open(PurchaseRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_PO_OPEN);
		updateStatus(entity, new String[]{"po","status","approve_by","approve_date"});
	}
	
	public static void status_po_close(PurchaseRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_PO_CLOSE);
		updateStatusClosePo(entity, approveNoteField);
	}
	
	public static List<PurchaseRequest> selectList() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE status!='" + STATUS_CANCEL + "' ORDER BY (id*1) ASC";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PurchaseRequest> list = new ArrayList<PurchaseRequest>();
		while (rs.next()) {
			PurchaseRequest entity = new PurchaseRequest();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIInvMaster(InventoryMaster.select(entity.getMat_code(), conn));
			entity.setUIInvVendor(InventoryMasterVendor.select(entity.getMat_code(), entity.getVendor_id(), conn));
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static void status_po_terminate(PurchaseOrder po) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		List<PurchaseRequest> list = selectListByPO(po.getPo(), conn);
		for (PurchaseRequest purchaseRequest : list) {
			purchaseRequest.setStatus(STATUS_PO_TERMINATE);

			purchaseRequest.setNote(po.getNote());
			purchaseRequest.setUpdate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, purchaseRequest, approveNoteField, keys);
		}
		conn.close();
	}
	
	public static void dupicatePO(String new_po,String old_po, Connection conn) throws Exception{
	
		
		String sql = "SELECT * FROM " + tableName + " WHERE po='" + old_po + "' ";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			PurchaseRequest entity = new PurchaseRequest();
			DBUtility.bindResultSet(entity, rs);
			entity.setPo(new_po);
			entity.setId(DBUtility.genNumber(conn, tableName, "id"));
			entity.setCreate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.insertToDB(conn, tableName, entity);
			
		}
		
		rs.close();
		st.close();
		
	
	}

	public static void approvePo(String po, Connection conn) throws SQLException{
		
		String sql = "UPDATE " + tableName + " SET status='" +STATUS_MD_APPROVED+ "', update_date ='"+DBUtility.getDBCurrentDateTime()+"' where po='" + po + "'";
		Statement st = conn.createStatement();
		st.executeUpdate(sql);
		st.close();
		System.out.println(sql);
	}
	public static void rejectPo(String po, Connection conn) throws SQLException{
		String sql = "UPDATE " + tableName + " SET note = 'ยกเลิกใบสั่งซื้อ' ,status='" +STATUS_MD_REJECT+ "' where po='" + po + "'";
		Statement st = conn.createStatement();
		st.executeUpdate(sql);
		st.close();
	}

	public static void approvePo_Ap(PurchaseRequest entity, Connection conn) throws SQLException{
			
		try {
	    	
	    	entity.setStatus(STATUS_MD_APPROVED);
	    	entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
	    	entity.setApprove_date(DBUtility.getDBCurrentDateTime());
	    	
	    	DBUtility.updateToDB(conn, tableName, entity, new String[]{"status","update_by","update_date","approve_by","approve_date"}, keys_po);		
			
			conn.close();
		} catch (Exception e) {
			if (conn != null) {
				conn.close();
			}
		}
		}
	public static void rejectPo_Ap(PurchaseRequest entity, Connection conn) throws SQLException{
	    try {
	    	entity.setNote("ยกเลิกใบสั่งซื้อ");
	    	entity.setStatus(STATUS_MD_REJECT);
	    	entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
	    	
	    	DBUtility.updateToDB(conn, tableName, entity, new String[]{"status","note","update_by","update_date"}, keys_po);		
			
			conn.close();
		} catch (Exception e) {
			if (conn != null) {
				conn.close();
			}
		}
		
	}
	
	public static void rejectPo4new(PurchaseRequest entity  , Connection conn) throws SQLException, IllegalAccessException, InvocationTargetException{

//		//System.out.println("Data :  "+entity.getPo()+" , STATUS : "+entity.getStatus()+" , NOTE :"+entity.getNote());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"update_by","update_date","status","note"}, keys_po);
	}
	
	public static List<PurchaseRequest> selectListByPO(String po, Connection conn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE po='" + po + "' ORDER BY add_pr_date ASC";
		
		//System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PurchaseRequest> list = new ArrayList<PurchaseRequest>();
		while (rs.next()) {
			PurchaseRequest entity = new PurchaseRequest();
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
	
	public static List<PurchaseRequest> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
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
		
		if(m.length() > 0 && y.length() > 0){

			sql += " AND (MONTH(create_date) = '"+m+"' AND YEAR(create_date) ='" + y + "')";
			
		}else if (m.length() > 0) {
			/*
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
			*/
			//Bank 05-01-55
			sql += " AND MONTH(create_date) = '"+m+"'";
		} else {
			if (y.length() > 0) {
				//sql += " AND (create_date between '" + y + "-01-01 00:00:00.00' AND '" + y + "-12-31 23:59:59.99')";
				//Bank
				sql += " AND (YEAR(create_date) ='" + y + "')";
				
			}
		}
		
		sql += " ORDER BY (id*1) DESC , create_date DESC";
	//	//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PurchaseRequest> list = new ArrayList<PurchaseRequest>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					PurchaseRequest entity = new PurchaseRequest();
					DBUtility.bindResultSet(entity, rs);
					if (entity.getPr_type().equals(TYPE_PARTS)) {
						entity.setUIPartMaster(PartMaster.select(entity.getMat_code(), conn));
						entity.setUIInvVendor(InventoryMasterVendor.select(entity.getMat_code(), entity.getVendor_id(), conn));
					} else {
						entity.setUIInvMaster(InventoryMaster.select(entity.getMat_code(), conn));
						entity.setUIInvVendor(InventoryMasterVendor.select(entity.getMat_code(), entity.getVendor_id(), conn));
					}
					
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		st.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
	
	public static List<PurchaseRequest> select4IssuePO(List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				sql += " AND " + str[0] + "='" + str[1] + "'";
			}
		}
		
	//	sql += " AND (status ='" + STATUS_ORDER + "' OR status='" + STATUS_MD_REJECT + "')";
		sql += " AND (status ='" + STATUS_ORDER + "' )";
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PurchaseRequest> list = new ArrayList<PurchaseRequest>();
		while (rs.next()) {
			PurchaseRequest entity = new PurchaseRequest();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIInvMaster(InventoryMaster.select(entity.getMat_code(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	
	public static List<PurchaseRequest> select4MDWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE status='" + STATUS_MD_APPROVED + "'";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				sql += " AND " + str[0] + "='" + str[1] + "'";
			}
		}
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PurchaseRequest> list = new ArrayList<PurchaseRequest>();
		while (rs.next()) {
			PurchaseRequest entity = new PurchaseRequest();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIInvMaster(InventoryMaster.select(entity.getMat_code(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static String pr_opened_list_sum(String mat_code) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT sum(order_qty*1) as sum FROM " + tableName + " WHERE (status='" + STATUS_ORDER + "' OR status='" + STATUS_PO_OPEN + "' OR status='" + STATUS_PO_OPENING + "') AND mat_code='" + mat_code + "'";
		////System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String sum = "0";
		while (rs.next()) {
			sum = DBUtility.getString("sum", rs);
		}
		rs.close();
		st.close();
		conn.close();
		return sum;
	}
	public static String CountByStatus(String status) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT count(status) as cnt FROM " + tableName + " WHERE status = '"+status+"' ";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String cnt = "";
		while (rs.next()) {
			cnt = DBUtility.getString("cnt", rs);
		}
		rs.close();
		st.close();
		conn.close();
		return cnt;
	}
	public static String CountByStatus(String status ,String mat_code) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT count(status) as cnt FROM " + tableName + " WHERE status = '"+status+"' and mat_code='"+mat_code+"' ";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		//System.out.println("Q="+sql);
		String cnt = "";
		while (rs.next()) {
			cnt = DBUtility.getString("cnt", rs);
		}
		rs.close();
		st.close();
		conn.close();
		return cnt;
	}
	
	public static List<PurchaseRequest> pr_opened_list(String mat_code) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE status='" + STATUS_PO_OPEN + "' OR status='" + STATUS_PO_OPENING + "' AND mat_code='" + mat_code + "'";
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PurchaseRequest> list = new ArrayList<PurchaseRequest>();
		while (rs.next()) {
			PurchaseRequest entity = new PurchaseRequest();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIInvMaster(InventoryMaster.select(entity.getMat_code(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	
	/**
	 * Used: pr_create.jsp
	 * <br>
	 * ดึงราย�?าร PR ที่ยังไม่ปิด เพื่อนเตือน�?่ายจัดซื้อไม่ให้ซื้อซ้ำ
	 * @param mat_code
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<PurchaseRequest> list_status_open(String mat_code) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE mat_code='" + mat_code + "' AND (status='" + PurchaseRequest.STATUS_ORDER + "' OR status='" + PurchaseRequest.STATUS_MD_REJECT + "' OR status='" + PurchaseRequest.STATUS_PO_OPEN + "') ORDER BY (id*1) ASC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PurchaseRequest> list = new ArrayList<PurchaseRequest>();
		while (rs.next()) {
			PurchaseRequest entity = new PurchaseRequest();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIInvVendor(InventoryMasterVendor.select(entity.getMat_code(), entity.getVendor_id(), conn));
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<PurchaseRequest> selectListAll(String po, Connection conn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE po='" + po + "' AND status!='" + PurchaseRequest.STATUS_PO_TERMINATE + "' AND status!='" + PurchaseRequest.STATUS_CANCEL + "' ORDER BY (id*1) ASC";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PurchaseRequest> list = new ArrayList<PurchaseRequest>();
		while (rs.next()) {
			PurchaseRequest entity = new PurchaseRequest();
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
	
	public static List<PurchaseRequest> selectPRlist(PageControl ctrl, List<String[]> params) throws Exception{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			
					sql += " AND " + str[0] + "='" + str[1] + "'";
				
		}
		sql += " ORDER BY add_pr_date ASC";
		//System.out.println("sql::"+sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PurchaseRequest> list = new ArrayList<PurchaseRequest>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					PurchaseRequest entity = new PurchaseRequest();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIPartMaster(PartMaster.select(entity.getMat_code(), conn));
					entity.setUIrecive_qty(PartLot.sumRecivePR(entity.getPo(),entity.getMat_code(), entity.getId(), conn));
					//entity.setUIrecive_qty(PartLot)
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
	
	public static List<PurchaseRequest> selectPRlist3Month(String mat_code)  throws Exception{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 AND  mat_code = ? AND status = ? ";
		sql +=  " AND DATE(create_date) Between (DATE_SUB(DATE(NOW()) ,INTERVAL '3' MONTH)) AND  (DATE(NOW())) ";
			
		////System.out.println("SQL : "+sql);
		Connection conn = DBPool.getConnection();
		
		
		
		
		PreparedStatement ps = conn.prepareStatement(sql);
		
		ps.setString(1, mat_code);
		ps.setString(2, STATUS_PO_CLOSE);
		
		ResultSet rs = ps.executeQuery();
		List<PurchaseRequest> list = new ArrayList<PurchaseRequest>();

		while (rs.next()) {
					PurchaseRequest entity = new PurchaseRequest();
					DBUtility.bindResultSet(entity, rs);
					list.add(entity);
		}

		rs.close();
		ps.close();
		conn.close();
		return list;
	}


	public static String sumPO(String mat_code) throws Exception{
		
			String sum_PO = "0";
				 
			Connection conn = DBPool.getConnection();
			//String sql = "SELECT COUNT(po) AS order_qty_PO  FROM " + tableName + " WHERE status= "+STATUS_MD_APPROVED+"  AND mat_code = ? AND ( status <>  ? AND status <> ? AND status <> ?)   GROUP BY po";
			String sql = "SELECT COUNT(po) AS order_qty_PO  FROM "+tableName+" WHERE status= '"+STATUS_MD_APPROVED+"'  AND mat_code = '"+mat_code.trim()+"' AND ( status <>  '"+STATUS_MD_REJECT+"' AND status <> '"+STATUS_PO_TERMINATE+"' AND status <> '"+STATUS_CANCEL+"')   GROUP BY po";
			/*PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1,mat_code.trim());
			ps.setString(2,STATUS_MD_REJECT);
			ps.setString(3,STATUS_PO_TERMINATE);
			ps.setString(4,STATUS_CANCEL);
			ps.addBatch();*/
			//System.out.println(sql+"/"+mat_code+"/"+STATUS_MD_REJECT+"/"+STATUS_PO_TERMINATE+"/"+STATUS_CANCEL);
			/*ResultSet rs = ps.executeQuery();*/
			
			//System.out.println(sql);
			
			Statement ps = conn.createStatement();
			ResultSet rs = ps.executeQuery(sql);
			
			if (rs != null) {
				if (rs.next()) {
					sum_PO = DBUtility.getString("order_qty_PO", rs);				
				}
			}
			
			rs.close();
			ps.close();
			conn.close();
		
		
		return sum_PO;
	}
	
	

	public static String sumPR(String mat_code) throws Exception{
		Connection conn = null;
		conn = DBPool.getConnection();
		
		String sum = "0";
		try {
			
			String sql = "SELECT SUM(order_qty) AS order_qty  FROM " + tableName + " WHERE  mat_code = ? AND ( status <>  ? AND status <> ? AND status <> ?  AND status <> ?  AND status <> ?  AND status <> ? ) ";
			
			
			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, mat_code.trim());
			ps.setString(2,STATUS_MD_REJECT);
			ps.setString(3, STATUS_PO_TERMINATE);
			ps.setString(4, STATUS_CANCEL);
			ps.setString(5, STATUS_PO_OPEN);
			ps.setString(6, STATUS_MD_APPROVED);
			ps.setString(7, STATUS_PO_CLOSE);
			
			ResultSet rs = ps.executeQuery();
			
			if (rs.next()) {
				sum = DBUtility.getString("order_qty", rs);
				
			}
			rs.close();
			ps.close();
			
			conn.close();
		} catch (Exception e) {
			if (conn!=null) {
				conn.close();
				throw new Exception(e.getMessage());
			}
		}
		return sum;
	}
	
	public static String selectOrderPrice(String po ,String id ,String pn) throws Exception{
		Connection conn = null;
		conn = DBPool.getConnection();
		String OrderPrice = "0";
		try {
			
			String sql = " SELECT order_price FROM pur_purchase_request WHERE po = ? and   id= ? and trim(mat_code)= ?  ";
			
			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, po.trim());
			ps.setString(2, id.trim());
			ps.setString(3, pn.trim());
			
			ResultSet rs = ps.executeQuery();
			
			if (rs.next()) {
				OrderPrice = DBUtility.getString("order_price", rs);
				
			}
			rs.close();
			ps.close();
			conn.close();
		} catch (Exception e) {
			if (conn!=null) {
				conn.close();
				throw new Exception(e.getMessage());
			}
		}
		return OrderPrice;
	}
	
	
	public String getPo() {
		return po;
	}
	public void setPo(String po) {
		this.po = po;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getMat_code() {
		return mat_code;
	}
	public void setMat_code(String mat_code) {
		this.mat_code = mat_code;
	}
	public String getOrder_qty() {
		return order_qty;
	}
	public void setOrder_qty(String order_qty) {
		this.order_qty = order_qty;
	}
	public String getOrder_price() {
		return order_price;
	}
	public void setOrder_price(String order_price) {
		this.order_price = order_price;
	}
	public String getVendor_id() {
		return vendor_id;
	}
	public void setVendor_id(String vendor_id) {
		this.vendor_id = vendor_id;
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
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}
	public String getApprove_by() {
		return approve_by;
	}
	public void setApprove_by(String approve_by) {
		this.approve_by = approve_by;
	}
	public Timestamp getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}
	public Timestamp getApprove_date() {
		return approve_date;
	}
	public void setApprove_date(Timestamp approve_date) {
		this.approve_date = approve_date;
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

	public String getPr_type() {
		return pr_type;
	}

	public void setPr_type(String pr_type) {
		this.pr_type = pr_type;
	}

	public String getUIrecive_qty() {
		return UIrecive_qty;
	}

	public void setUIrecive_qty(String uIrecive_qty) {
		UIrecive_qty = uIrecive_qty;
	}	
	public Timestamp getAdd_pr_date() {
		return add_pr_date;
	}

	public void setAdd_pr_date(Timestamp add_pr_date) {
		this.add_pr_date = add_pr_date;
	}

	public String getUIcnt() {
		return UIcnt;
	}

	public void setUIcnt(String uIcnt) {
		UIcnt = uIcnt;
	}

	// Nut Update 2013-04-01
	Map UImap = null;
	public Map getUImap() {
			return UImap;
	}
	public void setUImap(Map uImap) {
			UImap = uImap;
	}

	public static List<PurchaseRequest> listreport(List<String[]> paramsList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
		{
			List<PurchaseRequest> list = new ArrayList<PurchaseRequest>();
			Connection conn = DBPool.getConnection();
			String sql = "SELECT * FROM " + tableName + " WHERE 1=1 ";
			
			Iterator<String[]> ite = paramsList.iterator();
			while (ite.hasNext()) {
				String[] str = (String[]) ite.next();
				if (str[1].length() > 0) {
						
						if (str[0].equalsIgnoreCase("create_date")){
							
							sql +="AND DATE_FORMAT(create_date, '%Y-%m-%d')='"+str[1]+"' " ;
							
						} 
						else if (str[0].equalsIgnoreCase("year_month")){
							
							sql +="AND DATE_FORMAT(create_date, '%Y-%m')='"+str[1]+"' " ;
							
						} 
						else if (str[0].equalsIgnoreCase("date_send2")){
							
							sql +="AND DATE_FORMAT(create_date, '%Y-%m-%d') BETWEEN '"+str[1]+"' AND '"+str[2]+"' ";
							
						}
						
						else {
							
							sql += " AND " + str[0] + "='" + str[1] + "' ";
						}
					
							
				}
			}
			
			sql += " ORDER BY po asc";
			
			//System.out.println(sql);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			
			while (rs.next()) {
				PurchaseRequest entity = new PurchaseRequest();
				DBUtility.bindResultSet(entity, rs);
				
				Map map = new HashMap();
				map.put(PartMaster.tableName, PartMaster.select(entity.getMat_code(), conn));
				map.put(Vendor.tableName, Vendor.select(entity.getVendor_id(), conn));
				entity.setUImap(map);
				
				list.add(entity);
			}
			
			rs.close();
			st.close();
			conn.close();
			return list;
	}
	public static List<PurchaseRequest> listreport2() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
		List<PurchaseRequest> list = new ArrayList<PurchaseRequest>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT DISTINCT mat_code,description AS cnt FROM "+tableName+" join pa_part_master on mat_code = pn ORDER BY PO ASC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			PurchaseRequest entity = new PurchaseRequest();
			entity.setUIcnt(DBUtility.getString("cnt", rs));
			DBUtility.bindResultSet(entity, rs);
		
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<PurchaseRequest> selectPRlist( List<String[]> params ) throws Exception{
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
		
		List<PurchaseRequest> list = new ArrayList<PurchaseRequest>();		
		
		while (rs.next()) {			
				
					PurchaseRequest entity = new PurchaseRequest();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIPartMaster(PartMaster.select(entity.getMat_code(), conn));
					entity.setUIrecive_qty(PartLot.sumRecivePR(entity.getPo(),entity.getMat_code(), entity.getId(), conn));
					//entity.setUIrecive_qty(PartLot)
					list.add(entity);
				
		}
		rs.close();		
		conn.close();
		return list;
	}

	public static void ClosePRAddStock(PurchaseRequest entity) throws SQLException {
		Connection conn = null;
		try {
			conn = DBPool.getConnection();			
			/*entity.setUpdate_date(DBUtility.getDBCurrentDateTime());			
			entity.setStatus(STATUS_PO_CLOSE);
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"status","update_by","update_date"}, keys);		*/
			
			String sql ="UPDATE pur_purchase_request SET status='"+STATUS_PO_CLOSE+"',update_by='"+entity.getUpdate_by()+"',update_date='"+DBUtility.getDBCurrentDateTime()+"' WHERE po='"+entity.getPo()+"'";
			//System.out.println("PR :"+sql);
			Statement st = conn.createStatement();
			int rs = st.executeUpdate(sql);
			
			conn.close();
		} catch (Exception e) {
			if (conn != null) {
				conn.close();
			}
		}
		
	}

	public static void update_statusPO(PurchaseRequest pr, Connection conn) throws Exception {
		try {
			String sql ="UPDATE pur_purchase_request SET status='"+pr.getStatus()+"',update_by='"+pr.getUpdate_by()+"',update_date='"+DBUtility.getDBCurrentDateTime()+"' WHERE po='"+pr.getPo()+"'";
			System.out.println("PR :"+sql);
			Statement st = conn.createStatement();
			int rs = st.executeUpdate(sql);
			
		} catch (Exception e) {
			if ( conn != null) {
				 conn.rollback();
				 conn.close();
			}
		}
		
	}
	
}