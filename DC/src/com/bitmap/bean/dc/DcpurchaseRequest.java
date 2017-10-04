package com.bitmap.bean.dc;

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
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import com.bitmap.bean.branch.BranchMaster;
import com.bitmap.bean.inventory.InventoryLot;
import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.bean.inventory.InventoryMasterVendor;
import com.bitmap.bean.parts.PartMaster;
import com.bitmap.bean.parts.Vendor;
import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class DcpurchaseRequest {
	public static String TYPE_PARTS = "P";
	public static String TYPE_INVTY = "I";
	
	public static String STATUS_CANCEL = "00";
	
	public static String STATUS_ORDER = "10";
	
	public static String STATUS_AC_APPROVED = "20";
	public static String STATUS_AC_PASS = "21";
	public static String STATUS_AC_REPL = "22";
	public static String STATUS_AC_REJECT = "25";
	
	public static String STATUS_MD_APPROVED = "30";
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
	
	public static String status(String status){
		HashMap<String , String> map = new HashMap<String, String>();
		map.put(STATUS_CANCEL, "ยกเลิก");
		map.put(STATUS_ORDER, "รออนุมัติ");
		map.put(STATUS_MD_APPROVED, "อนุมัติแล้ว");
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
	
	public static String tableName = "dc_purchase_request";
	private static String[] keys = {"id"};
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
	
	public static DcpurchaseRequest select(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		DcpurchaseRequest entity = new DcpurchaseRequest();
		entity.setId(id);
		select(entity);
		return entity;
	}
	
	
	public static void select(DcpurchaseRequest entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		
		conn.close();
	}
	
	public static void select4Inlet(DcpurchaseRequest entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIInvMaster(InventoryMaster.select(entity.getMat_code(), conn));
		entity.setUIInletSum(InventoryLot.totalInlet(entity.getPo(), entity.getMat_code()));
		conn.close();
	}
	
	public static void insert(DcpurchaseRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		
		entity.setId(DBUtility.genNumber(conn, tableName, "id"));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		
		conn.close();
	}
	
	public static void update(DcpurchaseRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public static void updateStatus(DcpurchaseRequest entity, String[] fieldNames) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setApprove_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public static void status_cancel(DcpurchaseRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_CANCEL);
		updateStatus(entity, updateNoteField);
	}
	
	public static void status_ac_approve(DcpurchaseRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_AC_APPROVED);
		updateStatus(entity, approveNoteField);
	}
	
	public static void status_ac_pass(DcpurchaseRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_AC_PASS);
		updateStatus(entity, updateNoteField);
	}
	
	public static void status_ac_reject(DcpurchaseRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_AC_REJECT);
		updateStatus(entity, approveNoteField);
	}
	
	public static void status_md_approve(DcpurchaseRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_MD_APPROVED);
		updateStatus(entity, approveNoteField);
	}
	
	public static void status_md_reject(DcpurchaseRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_MD_REJECT);
		updateStatus(entity, approveNoteField);
	}
	
	public static void status_po_open(DcpurchaseRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_PO_OPEN);
		updateStatus(entity, new String[]{"po","status","approve_by","approve_date"});
	}
	
	public static void status_po_close(DcpurchaseRequest entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_PO_CLOSE);
		updateStatus(entity, approveNoteField);
	}
	
	public static List<DcpurchaseRequest> selectList() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE status!='" + STATUS_CANCEL + "' ORDER BY (id*1) ASC";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<DcpurchaseRequest> list = new ArrayList<DcpurchaseRequest>();
		while (rs.next()) {
			DcpurchaseRequest entity = new DcpurchaseRequest();
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
	
	public static void status_po_terminate(DcpurchaseOrder po) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		List<DcpurchaseRequest> list = selectListByPO(po.getPo(), conn);
		for (DcpurchaseRequest purchaseRequest : list) {
			purchaseRequest.setStatus(STATUS_PO_TERMINATE);
			purchaseRequest.setUpdate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, purchaseRequest, approveNoteField, keys);
		}
		conn.close();
	}
	
	public static void dupicatePO(String new_po,String old_po, Connection conn) throws SQLException{
		String sql = "UPDATE " + tableName + " SET po='" + new_po + "' where po='" + old_po + "'";
		Statement st = conn.createStatement();
		st.executeUpdate(sql);
		st.close();
	}
	
	public static List<DcpurchaseRequest> selectListByPO(String po, Connection conn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE po='" + po + "' ORDER BY (id*1) ASC";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<DcpurchaseRequest> list = new ArrayList<DcpurchaseRequest>();
		while (rs.next()) {
			DcpurchaseRequest entity = new DcpurchaseRequest();
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
	
	public static List<DcpurchaseRequest> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
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
		
		sql += " ORDER BY (id*1) ASC";

		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<DcpurchaseRequest> list = new ArrayList<DcpurchaseRequest>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					DcpurchaseRequest entity = new DcpurchaseRequest();
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
	
	public static List<DcpurchaseRequest> select4IssuePO(List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				sql += " AND " + str[0] + "='" + str[1] + "'";
			}
		}
		
		sql += " AND (status ='" + STATUS_ORDER + "' OR status='" + STATUS_MD_REJECT + "')";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<DcpurchaseRequest> list = new ArrayList<DcpurchaseRequest>();
		while (rs.next()) {
			DcpurchaseRequest entity = new DcpurchaseRequest();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIInvMaster(InventoryMaster.select(entity.getMat_code(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	
	public static List<DcpurchaseRequest> select4MDWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
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
		
		List<DcpurchaseRequest> list = new ArrayList<DcpurchaseRequest>();
		while (rs.next()) {
			DcpurchaseRequest entity = new DcpurchaseRequest();
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
	
	public static List<DcpurchaseRequest> pr_opened_list(String mat_code) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE status='" + STATUS_PO_OPEN + "' OR status='" + STATUS_PO_OPENING + "' AND mat_code='" + mat_code + "'";
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<DcpurchaseRequest> list = new ArrayList<DcpurchaseRequest>();
		while (rs.next()) {
			DcpurchaseRequest entity = new DcpurchaseRequest();
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
	public static List<DcpurchaseRequest> list_status_open(String mat_code) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE mat_code='" + mat_code + "' AND (status='" + DcpurchaseRequest.STATUS_ORDER + "' OR status='" + DcpurchaseRequest.STATUS_MD_REJECT + "' OR status='" + DcpurchaseRequest.STATUS_PO_OPEN + "') ORDER BY (id*1) ASC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<DcpurchaseRequest> list = new ArrayList<DcpurchaseRequest>();
		while (rs.next()) {
			DcpurchaseRequest entity = new DcpurchaseRequest();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIInvVendor(InventoryMasterVendor.select(entity.getMat_code(), entity.getVendor_id(), conn));
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<DcpurchaseRequest> selectListAll(String po, Connection conn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE po='" + po + "' AND status!='" + DcpurchaseRequest.STATUS_PO_TERMINATE + "' AND status!='" + DcpurchaseRequest.STATUS_CANCEL + "' ORDER BY (id*1) ASC";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<DcpurchaseRequest> list = new ArrayList<DcpurchaseRequest>();
		while (rs.next()) {
			DcpurchaseRequest entity = new DcpurchaseRequest();
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
	
	public static DcpurchaseRequest select(String id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		DcpurchaseRequest entity = new DcpurchaseRequest();
		entity.setId(id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		return entity;
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
}