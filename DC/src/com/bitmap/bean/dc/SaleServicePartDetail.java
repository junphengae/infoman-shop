package com.bitmap.bean.dc;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.bitmap.bean.hr.Personal;
import com.bitmap.bean.inventory.InventoryLot;
import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.bean.inventory.InventoryMasterVendor;
import com.bitmap.bean.parts.PartLot;
import com.bitmap.bean.parts.PartMaster;
import com.bitmap.bean.parts.PartSerial;
import com.bitmap.bean.parts.ServicePartDetail;
import com.bitmap.bean.parts.Vendor;
import com.bitmap.bean.branch.BranchMaster;
import com.bitmap.bean.dc.SaleServicePartDetail;
import com.bitmap.bean.parts.ServiceSale;
import com.bitmap.bean.purchase.PurchaseOrder;
import com.bitmap.bean.purchase.PurchaseRequest;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;
import com.bitmap.webutils.PageControl;

/**
 * @author USER
 *
 */
/**
 * @author USER
 *
 */
public class SaleServicePartDetail {

	public static String tableName = "sale_order_service_part_detail";
	public static String[] keys = {"id","number"};
	public static String[] keyNumber = {"number"};
	public static String[] fieldNames = {"id","number","pn","qty","discount","discount_flag","cutoff_qty","price","create_by"
											,"create_date","update_by","update_date"};
	
	private static String[] updateNoteField = {"status","update_by","update_date","note"};
	//private static String[] key_check_part = {"id","number"};
	
	
	String id = "";
	String number = "1";
	String pn = "";
	String qty = "0";
	String discount = "0";
	String discount_flag = "";
	String cutoff_qty = "0";
	String price = "";
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	Timestamp add_pr_date = null;
	String status = "";
	String note = "";
	String branch_code = "";
	
	
	String UIDescription = "";
	String UICus_name = "";
	String UIStatus = "";
	String UIss_flag = "";
	Map UImap = null;
	
	
	public static String STATUS_CANCEL = "00";
	public static String STATUS_OPENING = "10";
	public static String STATUS_CLOSED = "100";//20
	
	
	public Timestamp getAdd_pr_date() {
		return add_pr_date;
	}

	public void setAdd_pr_date(Timestamp add_pr_date) {
		this.add_pr_date = add_pr_date;
	}

	public Map getUImap() {
		return UImap;
	}

	public void setUImap(Map uImap) {
		UImap = uImap;
	}

	public String getUIss_flag() {
		return UIss_flag;
	}

	public void setUIss_flag(String uIss_flag) {
		UIss_flag = uIss_flag;
	}

	public String getUIStatus() {
		return UIStatus;
	}

	public void setUIStatus(String uIStatus) {
		UIStatus = uIStatus;
	}

	public String getUICus_name() {
		return UICus_name;
	}

	public void setUICus_name(String uICus_name) {
		UICus_name = uICus_name;
	}
	
	private PartMaster UIPartMaster = new PartMaster();
	public PartMaster getUIPartMaster() {return UIPartMaster;}
	public void setUIPartMaster(PartMaster uIPartMaster) {UIPartMaster = uIPartMaster;}
	
	public static void updateStatus(SaleServicePartDetail entity, String[] fieldNames) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	public static void status_cancel(SaleServicePartDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_CANCEL);
		updateStatus(entity, updateNoteField);
	}
	public static SaleServicePartDetail select(String id) throws Exception{
		SaleServicePartDetail entity = new SaleServicePartDetail();
		entity.setId(id);
		select(entity);
		return entity;
	}
	public static void updateItem(SaleServicePartDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"price","qty","note"}, keys);
		conn.close();
	}
	public static void closeJob(SaleServicePartDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		//System.out.println("number::"+entity.getNumber());
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(SaleServicePartDetail.STATUS_CLOSED);
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"status","update_date"}, keyNumber);
		conn.close();
	}
	public static SaleServicePartDetail select(String id ,String number) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		
		SaleServicePartDetail entity = new SaleServicePartDetail();
		Connection conn = DBPool.getConnection();	
		entity.setId(id);
		entity.setNumber(number);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	public static List<SaleServicePartDetail> selectListByID(String id, Connection conn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE id='" + id + "' ORDER BY (number*1) ASC";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleServicePartDetail> list = new ArrayList<SaleServicePartDetail>();
		while (rs.next()) {
			SaleServicePartDetail entity = new SaleServicePartDetail();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIPartMaster(PartMaster.select(entity.getPn(), conn));
			
			list.add(entity);
		}
		
		rs.close();
		st.close();
		return list;
	}
	public  static boolean check(String id ,String number) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		SaleServicePartDetail entity = new SaleServicePartDetail();
		entity.setId(id);
		entity.setNumber(number);
		return check(entity);
	}
	public  static boolean check(SaleServicePartDetail entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}
	public static String sum(String id, Connection conn) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String total = "0";
		String sql = "SELECT * FROM " + tableName + " WHERE id='" + id + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			SaleServicePartDetail detail = new SaleServicePartDetail();
			DBUtility.bindResultSet(detail, rs);
			
			total = Money.add(total, Money.multiple(detail.getQty(), detail.getPrice()));
		}
		rs.close();
		st.close();
		return total;
	}
	
	public static void insert(SaleServicePartDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		entity.setNumber(DBUtility.genNumberFromDB(conn, tableName, entity, new String[]{"id"}, "number"));
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static void update_detail(SaleServicePartDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"qty","price","discount_flag","discount","update_by","update_date"}, keys);
		conn.close();
	}
	
	public static void update_discount(SaleServicePartDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"discount","update_by","update_date"}, keys);
		conn.close();
	}
	
	public static void delete(SaleServicePartDetail entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public static void select(SaleServicePartDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIDescription(PartMaster.select(entity.getPn(), conn).getDescription());
		conn.close();
	}
	
	public static List<SaleServicePartDetail> list(String id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		List<SaleServicePartDetail> list = new ArrayList<SaleServicePartDetail>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT sd.*,(SELECT p.description FROM " + PartMaster.tableName + " p WHERE p.pn = sd.pn) AS description FROM " + tableName + " sd WHERE sd.id='" + id + "' ORDER BY (sd.number*1) ASC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			SaleServicePartDetail entity = new SaleServicePartDetail();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIDescription(DBUtility.getString("description", rs));
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<SaleServicePartDetail> listall() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		List<SaleServicePartDetail> list = new ArrayList<SaleServicePartDetail>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT sd.*,(SELECT p.description FROM " + PartMaster.tableName + " p WHERE p.pn = sd.pn) AS description FROM " + tableName + " sd WHERE 1=1 ORDER BY flag,create_date desc";
		////System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			SaleServicePartDetail entity = new SaleServicePartDetail();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIDescription(DBUtility.getString("description", rs));
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	public static List<SaleServicePartDetail> selectList(List<String[]> paramsList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
		List<SaleServicePartDetail> list = new ArrayList<SaleServicePartDetail>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE  status !='00' ";
		
		Iterator<String[]> ite = paramsList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
					if(str[0].equalsIgnoreCase("1")){
						
						sql += " AND " + " id " + "='" + str[1] + "'  AND number = '"+ str[2] + "'  AND  pn = '"+ str[3] + "'";
						
					}else{
						sql += " AND " + str[0] + "='" + str[1] + "' ";
					}
					
				
			}
		}
		
		sql += " ORDER BY add_pr_date ASC";
		
		//System.out.println("SaleServicePartDetail_selectList::"+sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			SaleServicePartDetail entity = new SaleServicePartDetail();
			DBUtility.bindResultSet(entity, rs);
			Map map = new HashMap();
			map.put(PartMaster.tableName, PartMaster.select(entity.getPn(), conn));
			entity.setUImap(map);
			
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}

	public static List<SaleServicePartDetail> selectallWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT  DISTINCT  "+tableName+".*,sale_order_service.cus_name, sale_order_service.status   FROM " + tableName + " ,sale_order_service ,branch_master  ";
			   sql +=" WHERE 1=1 AND sale_order_service.id = " + tableName + ".number  ";
			   sql +=" AND  sale_order_service_part_detail.status != '00' "; 
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("search")) {
					sql += " AND (branch_master.branch_name like'%" + str[1] + "%' " +
						   " OR branch_master.branch_code like'%" + str[1] + "%' ";
					sql += " OR sale_order_service_part_detail.pn like'%" + str[1] + "%') ";
				} else 
					   if(str[0].equalsIgnoreCase("status") && str[1].equalsIgnoreCase("10")){	
					    	
					    	sql += " AND qty <> cutoff_qty ";
					    	
			 }else 
				if(str[0].equalsIgnoreCase("status") && str[1].equalsIgnoreCase("100")){
					    	
					    	sql += " AND qty = cutoff_qty ";
					    	
			 }else{
					    	sql += " AND " + str[0] + "='" + str[1] + "' ";
			 }
			}
		}
		
		sql += " ORDER BY  sale_order_service_part_detail.create_date DESC , sale_order_service_part_detail.number  DESC ";
		 
		//System.out.println(sql);
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleServicePartDetail> list = new ArrayList<SaleServicePartDetail>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					SaleServicePartDetail entity = new SaleServicePartDetail();
					DBUtility.bindResultSet(entity, rs);
					entity.setUICus_name(rs.getString("cus_name"));
					entity.setUIStatus(rs.getString("status"));
					
					entity.setUIDescription(PartMaster.select(entity.getPn(), conn).getDescription());
					Map map = new HashMap();
					map.put(BranchMaster.tableName, BranchMaster.selectBranchCode(entity.getBranch_code(), conn));
					entity.setUImap(map);
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
	public static void update_cutoff_sn(SaleServicePartDetail psd, PartSerial pSerial, PartMaster pMaster) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		////System.out.println("update_cutoff_sn::"+psd.getQty());
		pSerial.setSale_order(psd.getId());
		PartSerial.withdraw(pSerial, pMaster, conn);
		cutoff(psd, conn);		
		conn.close();
	}
	
	public static void update_backoff_sn(SaleServicePartDetail psd, PartSerial pSerial, PartMaster pMaster) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		//pSerial.setSale_order(psd.getId());
		//PartSerial.withdraw(pSerial, pMaster, conn);
	//	backoff(psd, conn);		
		conn.close();
	}
	
	
	public static void update_cutoff(SaleServicePartDetail psd, PartMaster pMaster) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		String order_qty = psd.getQty();
		////System.out.println("update_cutoff::"+order_qty);
		pMaster.setQty(order_qty);
		PartMaster.withdrawQtyNonSN(pMaster, conn);
		cutoff(psd, conn);
		conn.close();
	}
	
	public static void update_claim(SaleServicePartDetail psd, PartMaster pMaster) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		PartMaster.withdrawQtyNonSN(pMaster, conn);
		conn.close();
	}
	
	public static void update_backoff(SaleServicePartDetail psd, PartMaster pMaster) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException {
		
		Connection conn = DBPool.getConnection();
		String order_qty = psd.getQty();
		System.out.println("update_backoff::"+order_qty);
		pMaster.setQty(order_qty);
		PartMaster.withdrawQtyNonSN_back(pMaster, conn);
		backoff(psd, conn);
		conn.close();
		
	}
	
	public static void cutoff(SaleServicePartDetail psd, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		SaleServicePartDetail entity = new SaleServicePartDetail();
		String order_qty = psd.getQty();
		int qty = Integer.parseInt(order_qty);
		entity.setId(psd.getId());
		entity.setNumber(psd.getNumber());
		entity.setPn(psd.getPn());
	
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"id","number","pn"});
		
		psd.setCutoff_qty((DBUtility.getInteger(entity.getCutoff_qty()) + qty) + "");

		psd.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, psd, new String[]{"cutoff_qty","update_by","update_date"}, new String[]{"id","number","pn"});
		
		String sql = "SELECT  COALESCE(count(id),0) AS cnt FROM " + tableName + " WHERE qty != cutoff_qty AND id='" + psd.getId() + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		if (rs.next()) {
			if (DBUtility.getInteger("cnt", rs) == 0) {
				ServiceSale ps = new ServiceSale();
				ps.setId(psd.getId());
				ps.setUpdate_by(psd.getUpdate_by());
				ps.setStatus(ServiceSale.STATUS_CLOSED);
				//ServiceSale.updateStatus(ps);
			}
		}
		rs.close();
		st.close();
	}
	
	
	
	public static void backoff(SaleServicePartDetail psd, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		System.out.println("backoff_psd.getQty();"+psd.getQty());
		String order_qty = psd.getQty();
		int qty = Integer.parseInt(order_qty);
		SaleServicePartDetail entity = new SaleServicePartDetail();
	
		entity.setId(psd.getId());
		entity.setNumber(psd.getNumber());
		entity.setPn(psd.getPn());
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"id","number","pn"});
		
		psd.setCutoff_qty((DBUtility.getInteger(entity.getCutoff_qty()) - qty) + "");
		
//		if(entity.getQty().equalsIgnoreCase(entity.getCutoff_qty())){
//			entity.setFlag("0");
//		}else{
//			entity.setFlag("1");
//		}
		
		psd.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, psd, new String[]{"cutoff_qty","update_by","update_date"}, new String[]{"id","number","pn"});
		
		String sql = "SELECT  COALESCE(count(id),0) AS cnt FROM " + tableName + " WHERE qty != cutoff_qty AND id='" + psd.getId() + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		if (rs.next()) {
			if (DBUtility.getInteger("cnt", rs) == 0) {
				ServiceSale ps = new ServiceSale();
				ps.setId(psd.getId());
				ps.setUpdate_by(psd.getUpdate_by());
				ps.setStatus(ServiceSale.STATUS_CLOSED);
				//ServiceSale.updateStatus(ps);
			}
		}
		rs.close();
		st.close();
	}
	/**
	 * whan : report_review
	 * <br>
	 * รายงานการเบิกสินค้า
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<SaleServicePartDetail> report_out() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		List<SaleServicePartDetail> list = new ArrayList<SaleServicePartDetail>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT sp.*,(SELECT pa.description FROM pa_part_master pa WHERE pa.pn = sp.pn) as description FROM " + tableName + " sp WHERE sp.qty = sp.cutoff_qty ORDER BY (sp.id*1) ASC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			SaleServicePartDetail entity = new SaleServicePartDetail();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIDescription(DBUtility.getString("description", rs));
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<SaleServicePartDetail> report_out(List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		
		List<SaleServicePartDetail> list = new ArrayList<SaleServicePartDetail>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT sp.*,(SELECT pa.description FROM pa_part_master pa WHERE pa.pn = sp.pn) as description FROM " + tableName + " sp WHERE sp.qty = sp.cutoff_qty "; // AND sp.pn LIKE '%abcsdefg%' ";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {

				if (str[0].equalsIgnoreCase("create_date")){
					
					sql +="AND DATE_FORMAT(sp.create_date, '%Y-%m-%d')='"+str[1]+"' " ;
					
				} 
				else if (str[0].equalsIgnoreCase("year_month")){
					
					sql +="AND DATE_FORMAT(sp.create_date, '%Y-%m')='"+str[1]+"' " ;
					
				} 
				else if (str[0].equalsIgnoreCase("date_send2")){
					
					sql +="AND DATE_FORMAT(sp.create_date, '%Y-%m-%d') BETWEEN '"+str[1]+"' AND '"+str[2]+"' ";
					
				}
				
				else {
					
					sql += " AND " + str[0] + "='" + str[1] + "' ";
				}
			}
		}
		
		sql += " ORDER BY (sp.id*1) ASC ";
		
		
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			SaleServicePartDetail entity = new SaleServicePartDetail();
			DBUtility.bindResultSet(entity, rs);
			
			Map map = new HashMap();
			
			map.put(Personal.tableName, Personal.select(entity.getCreate_by(), conn));
			
			entity.setUIDescription(DBUtility.getString("description", rs));
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	


	public static List<SaleServicePartDetail> listreport(List<String[]> paramsList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
		List<SaleServicePartDetail> list = new ArrayList<SaleServicePartDetail>();
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
	
		sql += " ORDER BY (id*1) desc";
	
		
	
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
	
		while (rs.next()) {
			SaleServicePartDetail entity = new SaleServicePartDetail();
			DBUtility.bindResultSet(entity, rs);
			
			Map map = new HashMap();
			
			map.put(Personal.tableName, Personal.select(entity.getCreate_by(), conn));			
			entity.setUImap(map);
			entity.setUIDescription(PartMaster.select(entity.getPn(), conn).getDescription());
			list.add(entity);
		}
	
		rs.close();
		st.close();
		conn.close();
		return list;
	}

	public static boolean checkSnFlag(String pn) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		PartMaster entity = new PartMaster();
		entity.setPn(pn);
		boolean hasPN = false;
		
		if (DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"pn"})) {
			if ((entity.getSn_flag()).equalsIgnoreCase("1")){
				hasPN = true;
			}
		}
		conn.close();
		return hasPN;
	}
	
	public static List<SaleServicePartDetail> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + "  AS SSPD   ";
		       sql +=" LEFT JOIN  sale_order_service  AS SOS ON SSPD.number = SOS.id  ";
			   sql += " WHERE SOS.status !='"+STATUS_CLOSED+"' ";
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
					sql += " AND  SSPD." + str[0] + "='" + str[1] + "' ";
				}
			}
		}
		
		if (m.length() > 0 && y.length() > 0) {
			
			
			sql += " AND MONTH(SSPD.create_date) = '"+m+"' ";
			sql += " AND (YEAR(SSPD.create_date) ='" + y + "') ";
			
			
			
		} else {
			if (y.length() > 0) {
				
				sql += " AND (YEAR(SSPD.create_date) ='" + y + "') ";
				
			}else {
				sql += " AND 1 = 1";
			}
		}
		
		sql += " ORDER BY  SSPD.create_date DESC , SSPD.number DESC ,SSPD.branch_code ASC ";  
		
		//System.out.println("pr_list::"+sql);
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleServicePartDetail> list = new ArrayList<SaleServicePartDetail>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					SaleServicePartDetail entity = new SaleServicePartDetail();
					DBUtility.bindResultSet(entity, rs);
					Map map = new HashMap();
					map.put(PartMaster.tableName, PartMaster.select(entity.getPn(), conn));
					entity.setUImap(map);
					
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
	public static String CountByStatus(String status,String branch_code) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT count(status) as cnt FROM " + tableName + " WHERE status = '"+status+"' ";
		if(branch_code.equalsIgnoreCase("all")){
			
		}else{
			sql += "AND branch_code='"+branch_code+"'";
		}
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
	public static List<SaleServicePartDetail> listreport2(List<String[]> paramsList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
		List<SaleServicePartDetail> list = new ArrayList<SaleServicePartDetail>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 ";
		
		Iterator<String[]> ite = paramsList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("create_date")){
					
					sql +=" AND DATE_FORMAT(create_date, '%Y-%m-%d')='"+str[1]+"' " ;
					
				} 
				else if (str[0].equalsIgnoreCase("year_month")){
					
					sql +=" AND DATE_FORMAT(create_date, '%Y-%m')='"+str[1]+"' " ;
					
				} 
				else if (str[0].equalsIgnoreCase("date_send2")){
					
					sql +=" AND DATE_FORMAT(create_date, '%Y-%m-%d') BETWEEN '"+str[1]+"' AND '"+str[2]+"' ";
					
				}
				else if (str[0].equalsIgnoreCase("report_status")){
					if(!str[1].equalsIgnoreCase("1")){
						sql +=" AND status='"+str[1]+"' ";
					}
				}
				else if (str[0].equalsIgnoreCase("branch")){
					
					if(str[1].equalsIgnoreCase("all")){
					}else{
						sql +=" AND branch_code = '"+str[1]+"' ";
					}
				}
				else {
					
					sql += " AND " + str[0] + "='" + str[1] + "' ";
				}
			}
		}
		
		sql += " ORDER BY number asc";
		//System.out.println("Q1="+sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			SaleServicePartDetail entity = new SaleServicePartDetail();
			DBUtility.bindResultSet(entity, rs);
			Map map = new HashMap();
			map.put(PartMaster.tableName, PartMaster.select(entity.getPn(), conn));
			entity.setUImap(map);
			
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getNumber() {
		return number;
	}
	public void setNumber(String number) {
		this.number = number;
	}
	public String getPn() {
		return pn;
	}
	public void setPn(String pn) {
		this.pn = pn;
	}
	public String getQty() {
		return qty;
	}
	public void setQty(String qty) {
		this.qty = qty;
	}
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
	}
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}
	public Timestamp getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
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

	public String getUIDescription() {
		return UIDescription;
	}

	public void setUIDescription(String uIDescription) {
		UIDescription = uIDescription;
	}

	public String getCutoff_qty() {
		return cutoff_qty;
	}

	public void setCutoff_qty(String cutoff_qty) {
		this.cutoff_qty = cutoff_qty;
	}

	public String getDiscount() {
		return discount;
	}

	public void setDiscount(String discount) {
		this.discount = discount;
	}
	public String getDiscount_flag() {
		return discount_flag;
	}
	public void setDiscount_flag(String discount_flag) {
		this.discount_flag = discount_flag;
	}
	public String getBranch_code() {
		return branch_code;
	}

	public void setBranch_code(String branch_code) {
		this.branch_code = branch_code;
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
	
	
	

}
