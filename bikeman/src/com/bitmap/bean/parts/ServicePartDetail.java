package com.bitmap.bean.parts;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.bitmap.bean.sale.MoneyDiscountRound;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.report.job.bean.servicePartBean;
import com.bitmap.utils.Money;
import com.bitmap.webutils.PageControl;
import com.bmp.customer.service.bean.ServicePartDetailBean;

public class ServicePartDetail {
	public static String tableName = "service_part_detail";
	private static String[] keys = {"id","number"};
//	private static String[] key_check_part = {"id","number"};
//private static String[] fieldNames = {"cate","fit_to","description","sn_flag","moq","mor","weight","location","price","price_unit","cost","cost_unit","update_date","update_by"};
	
	String id = "";
	String number = "1"; 
	String pn = "";
	String qty = "0";
	String cutoff_qty = "0";
	String discount = "0";
	String discount_flag = "";	
	String price = "";
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	String vat  = "0";
	String total_vat = "0";
	String total_price = "";// new 27-02-2557
	String spd_dis_total_before="";// new 27-02-2557
	String spd_net_price="0";
	String spd_dis_total ="0";
	
	String sumQTY ="0";
	String sumDIS="0";
	
	
	public String getTotal_price() {
		return total_price;
	}

	public void setTotal_price(String total_price) {
		this.total_price = total_price;
	}

	public String getSpd_dis_total_before() {
		return spd_dis_total_before;
	}

	public void setSpd_dis_total_before(String spd_dis_total_before) {
		this.spd_dis_total_before = spd_dis_total_before;
	}

	public String getSpd_dis_total() {
		return spd_dis_total;
	}

	public void setSpd_dis_total(String spd_dis_total) {
		this.spd_dis_total = spd_dis_total;
	}

	public static String PART_VAT= "7";
	
	String UIDescription = "";
	String UILocation = "";
	String UICus_name = "";
	String UIStatus = "";
	String UIss_flag = "";
	
	String UIforewordname = "";
	String UIcus_surname = "";

	
	public String getUILocation() {
		return UILocation;
	}

	public void setUILocation(String uILocation) {
		UILocation = uILocation;
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

	
	public String getSumQTY() {
		return sumQTY;
	}

	public void setSumQTY(String sumQTY) {
		this.sumQTY = sumQTY;
	}

	public String getSumDIS() {
		return sumDIS;
	}

	public void setSumDIS(String sumDIS) {
		this.sumDIS = sumDIS;
	}

	public String getUIforewordname() {
		return UIforewordname;
	}

	public void setUIforewordname(String uIforewordname) {
		UIforewordname = uIforewordname;
	}

	public String getUIcus_surname() {
		return UIcus_surname;
	}

	public void setUIcus_surname(String uIcus_surname) {
		UIcus_surname = uIcus_surname;
	}

	public static void updateDiscount( String start , String end ) throws Exception{
		Connection conn = null;
		try {
			String hundred = "100";
			conn = DBPool.getConnection();
			String sql = "SELECT * FROM "+tableName+" WHERE id BETWEEN ? AND ? ";
			
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, start);
			ps.setString(2, end);
			
			ResultSet rs = ps.executeQuery();
			while( rs.next() ){
				ServicePartDetail entity = new ServicePartDetail();
				DBUtility.bindResultSet(entity, rs);
				String price = Money.money((Integer.parseInt(entity.getQty())*Double.parseDouble(entity.getPrice().replace(",", "")))).replace(",", "");//ราคา*จำนวน=price 
				String net_price = Money.money(MoneyDiscountRound.disRound(price , Money.money(entity.getDiscount()))).replace(",", "");//price-ส่วนลด=net_price *** มีการปรับเศษสตางค์
				String discount = Money.subtract(price, net_price);//price-net_price=ส่วนลด
				String total_vat = String.format("%.2f", Double.parseDouble( Money.divide( Money.multiple( net_price, entity.getVat() ) , Money.add( entity.getVat() , hundred ) ).replace(",", "") ) );
				
				if( ! entity.getSpd_net_price().equalsIgnoreCase(net_price) || ! entity.getSpd_dis_total().equalsIgnoreCase(discount) || ! entity.getTotal_vat().equalsIgnoreCase(total_vat) ){
					entity.setSpd_net_price(net_price);
					entity.setSpd_dis_total(discount);
					entity.setTotal_vat(total_vat);
					
					DBUtility.updateToDB(conn, tableName, entity, new String[]{"total_vat","spd_dis_total","spd_net"}, keys);
				}
			}
			rs.close();
			ps.close();
			conn.close();
		} catch (Exception e) {
			if( conn != null ){
				conn.close();
			}
			throw new Exception( e.getMessage() );
		}
	}
	
	public static String sum(String id, Connection conn) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String total = "0";
		String sql = "SELECT * FROM " + tableName + " WHERE id='" + id + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			ServicePartDetail detail = new ServicePartDetail();
			DBUtility.bindResultSet(detail, rs);
			
			total = Money.add(total, Money.multiple(detail.getQty(), detail.getPrice()));
		}
		rs.close();
		st.close();
		return total;
	}
	
	public static void insert(ServicePartDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
						
			entity.setCreate_date(DBUtility.getDBCurrentDateTime());
			entity.setNumber(DBUtility.genNumberFromDB(conn, tableName, entity, new String[]{"id"}, "number"));
			
			DBUtility.insertToDB(conn, tableName, entity);
			
			conn.commit();
			conn.close();
		} catch (Exception e) {
			if (conn != null) {
				conn.rollback();
				conn.close();
			}
			System.out.println(e.getMessage());
		}
		
		
	}
	
	public static void update_detail(ServicePartDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"qty","price","discount_flag","discount","update_by","update_date","vat","total_vat","total_price","spd_net_price","spd_dis_total_before","spd_dis_total"}, keys);
			conn.commit();
			conn.close();
		} catch (Exception e) {
			if( conn != null ){
				conn.rollback();
				conn.close();
			}
			System.out.println(e.getMessage());
		}
	
	}
	
	public static void update_new_detail(ServicePartDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"qty","price","discount_flag","discount","update_by","update_date","vat","total_vat","total_price","spd_net_price","spd_dis_total_before","spd_dis_total"}, new String[]{"pn","id","discount"});
			
			conn.commit();
			conn.close();
			
		} catch (Exception e) {
			if (conn != null) {
				conn.rollback();
				conn.close();
			}
		}
		
		
	}
	
	
	
	public static void update_discount(ServicePartDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"discount","update_by","update_date"}, keys);
		conn.close();
	}
	public static void update_closewithdraw(ServicePartDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"qty","discount","update_by","update_date","total_vat","total_price","spd_net_price","spd_dis_total_before","spd_dis_total"}, keys);
		
		conn.close();
	}
	public static void delete(ServicePartDetail entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public static void select(ServicePartDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIDescription(PartMaster.select(entity.getPn(), conn).getDescription());
		
		conn.close();
	}
	
	public static void select(ServicePartDetailBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIDescription(PartMaster.select(entity.getPn(), conn).getDescription());
		
		conn.close();
	}
	
	public static void selectLo(ServicePartDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUILocation(PartMaster.select(entity.getPn(), conn).getLocation());
		System.out.println(entity.getUILocation());
		conn.close();
	}
	
	public static ServicePartDetail selectid_pn(String id,String pn) throws IllegalAccessException, InvocationTargetException, SQLException{
		ServicePartDetail entity =new  ServicePartDetail();
		entity.setId(id);
		entity.setPn(pn);
		return selectid_pn(entity);
	}
	
	public static ServicePartDetail selectid_pn(ServicePartDetail entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"id","pn"});
		conn.close();
		return entity;
		
	}
	
	public static String selectQty(String id,String pn) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{
		Connection conn = null;
		String qty = "0";
		try {
			conn = DBPool.getConnection();
			String sql = "SELECT * FROM " + tableName + " WHERE id='"+id.trim()+"'  AND pn='"+pn.trim()+"' AND qty != cutoff_qty";		
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			
			while (rs.next()) {
				ServicePartDetail spd = new ServicePartDetail();
				DBUtility.bindResultSet(spd, rs);
				qty = Money.add(qty, spd.getQty());			
			}
			
			rs.close();
			st.close();
			conn.close();
		} catch (Exception e) {
			if (conn != null) {
				conn.close();
			}
		} 
		return qty;
	}
	
	public static String selectcount(String id,String pn) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{
		
		String count = "0";
		Connection conn = DBPool.getConnection();
		String sql = "SELECT count(number) AS count  FROM " + tableName + " WHERE id='" + id + "'  AND pn='"+pn+"'";
		//System.out.println("sql::"+sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			servicePartBean spd = new servicePartBean();
			DBUtility.bindResultSet(spd, rs);
			count = spd.getCount();			
		}
		
		rs.close();
		st.close();
		conn.close();
		return count;
	
		
		
	}
	
	public static List<ServiceOtherDetail> list_spd(String id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		List<ServiceOtherDetail> list = new ArrayList<ServiceOtherDetail>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE id='" + id + "' ORDER BY (number*1) ASC";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			ServiceOtherDetail entity = new ServiceOtherDetail();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	
	public static List<ServicePartDetail> list(String id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		List<ServicePartDetail> list = new ArrayList<ServicePartDetail>();
		try {
			Connection conn = DBPool.getConnection();
			String sql = "SELECT sd.*,(SELECT p.description FROM " + PartMaster.tableName + " p WHERE p.pn = sd.pn) AS description FROM " + tableName + " sd WHERE sd.id='" + id +"' ORDER BY (sd.number*1) ASC";
			
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			//System.out.println("ServicePartDetail::"+sql);
			while (rs.next()) {
				ServicePartDetail entity = new ServicePartDetail();
				DBUtility.bindResultSet(entity, rs);
				entity.setUIDescription(DBUtility.getString("description", rs));
				
				list.add(entity);
			}
			
			rs.close();
			st.close();
			conn.close();
		} catch (Exception e) {
			System.out.println("list : "+e);
		}
		
		return list;
	}
	
	
	
	public static List<ServicePartDetail> list_psd(List<String[]> paramsList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
		List<ServicePartDetail> list = new ArrayList<ServicePartDetail>();
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
			ServicePartDetail entity = new ServicePartDetail();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	
	
	public static ServicePartDetail selectjob(String id)throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		
		ServicePartDetail entity = new ServicePartDetail();
		entity.setId(id);
		return selectjob(entity);
		
	}
	public static ServicePartDetail selectjob(ServicePartDetail entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"id"});
		conn.close();
		return entity;
		
	}
	
	public static List<servicePartBean> listpn(String pn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = null;
		List<servicePartBean> list =null;
		try {
			list = new ArrayList<servicePartBean>();
			conn = DBPool.getConnection();
			String sql = "SELECT SUM( qty ) AS qty_sum, SUM( spd_dis_total ) AS spd_dis_total, SUM(spd_net_price) AS net_price , price FROM  "+tableName+" ";
			sql+= " WHERE pn = '"+ pn +"' ";
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			
			System.out.println("sql::"+sql);
			
			while (rs.next()) {
				servicePartBean entity = new servicePartBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			rs.close();
			st.close();
			conn.close();
		} catch (Exception e) {
			if(conn!=null){
				
			}
		}
		return list;
	}
	
	
	
	public static List<ServicePartDetail> listall() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		List<ServicePartDetail> list = new ArrayList<ServicePartDetail>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT sd.*,(SELECT p.description FROM " + PartMaster.tableName + " p WHERE p.pn = sd.pn) AS description FROM " + tableName + " sd WHERE 1=1 ORDER BY flag,create_date desc";
		////System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			ServicePartDetail entity = new ServicePartDetail();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIDescription(DBUtility.getString("description", rs));
			//entity.setUILocation(DBUtility.getString("location", rs));
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<ServicePartDetail> selectallWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT DISTINCT "+tableName+".*,service_sale.cus_name, service_sale.status,service_sale.forewordname,service_sale.cus_surname   FROM " + tableName + ",service_sale WHERE 1=1 and service_sale.id = " + tableName + ".id " ;
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
					if (str[0].equalsIgnoreCase("search")) {
						
						sql += " AND (service_sale.cus_name like'%" + str[1] + "%'  " +
							   " OR service_sale.v_plate like'%" + str[1] + "%')  ";
						
					} else 
					   if(str[0].equalsIgnoreCase("status") && str[1].equalsIgnoreCase("12")){	
							    	
							    	sql += " AND qty <> cutoff_qty ";
							    	
					 }else 
						if(str[0].equalsIgnoreCase("status") && str[1].equalsIgnoreCase("100")){
							    	
							    	sql += " AND qty = cutoff_qty ";
							    	
					}else{
							    	sql += " AND " + str[0] + "='" + str[1] + "' ";
					}
					
			}
		}
		
		sql += " ORDER BY (service_sale.id*1) desc ";
		
		//System.out.println(sql);
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<ServicePartDetail> list = new ArrayList<ServicePartDetail>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					ServicePartDetail entity = new ServicePartDetail();
					DBUtility.bindResultSet(entity, rs);
					entity.setUICus_name(rs.getString("cus_name"));
					entity.setUIStatus(rs.getString("status"));
					entity.setUIforewordname(rs.getString("forewordname"));
					entity.setUIcus_surname(rs.getString("cus_surname"));
					
					
					entity.setUIDescription(PartMaster.select(entity.getPn(), conn).getDescription());
					entity.setUILocation(PartMaster.select(entity.getPn(), conn).getLocation());
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
	public static void update_cutoff_sn(ServicePartDetail psd, PartSerial pSerial, PartMaster pMaster) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		pSerial.setSale_order(psd.getId());
		PartSerial.withdraw(pSerial, pMaster, conn);
		cutoff(psd, conn);		
		conn.close();
	}
	
	public static void update_backoff_sn(ServicePartDetail psd, PartSerial pSerial, PartMaster pMaster) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		//pSerial.setSale_order(psd.getId());
		//PartSerial.withdraw(pSerial, pMaster, conn);
		//backoff(psd, conn);		
		conn.close();
	}
	
	
	public static void update_cutoff(ServicePartDetail psd, PartMaster pMaster) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		PartMaster.withdrawQtyNonSN(pMaster, conn);
		cutoff(psd, conn);
		conn.close();
	}
	
	public static void update_claim(ServicePartDetail psd, PartMaster pMaster) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		PartMaster.withdrawQtyNonSN(pMaster, conn);
		conn.close();
	}
	
	public static void update_backoff(ServicePartDetail psd, PartMaster pMaster) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		PartMaster.withdrawQtyNonSN_back(pMaster, conn);
		backoff(psd, conn);
		conn.close();
	}
	
	public static void cutoff(ServicePartDetail psd, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		ServicePartDetail entity = new ServicePartDetail();
		entity.setId(psd.getId());
		entity.setNumber(psd.getNumber());
		entity.setPn(psd.getPn());
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"id","number","pn"});
		
		psd.setCutoff_qty((DBUtility.getInteger(entity.getCutoff_qty()) + 1) + "");

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
	
	
	
	public static void backoff(ServicePartDetail psd, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		ServicePartDetail entity = new ServicePartDetail();
		entity.setId(psd.getId());
		entity.setNumber(psd.getNumber());
		entity.setPn(psd.getPn());
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"id","number","pn"});
		
		psd.setCutoff_qty((DBUtility.getInteger(entity.getCutoff_qty()) - 1) + "");
		
		
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
	public static List<ServicePartDetail> report_out() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		List<ServicePartDetail> list = new ArrayList<ServicePartDetail>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT sp.*,(SELECT pa.description FROM pa_part_master pa WHERE pa.pn = sp.pn) as description FROM " + tableName + " sp WHERE sp.qty = sp.cutoff_qty ORDER BY (sp.id*1) ASC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			ServicePartDetail entity = new ServicePartDetail();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIDescription(DBUtility.getString("description", rs));
			//entity.setUILocation(DBUtility.getString("location", rs));
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
    public static List<ServicePartDetail> report_out(List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		
		List<ServicePartDetail> list = new ArrayList<ServicePartDetail>();
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
			ServicePartDetail entity = new ServicePartDetail();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIDescription(DBUtility.getString("description", rs));
			//entity.setUILocation(DBUtility.getString("location", rs));
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	


    public static List<ServicePartDetail> listreport(List<String[]> paramsList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
{
	List<ServicePartDetail> list = new ArrayList<ServicePartDetail>();
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
	
	////System.out.println(sql);
	
	Statement st = conn.createStatement();
	ResultSet rs = st.executeQuery(sql);
	
	while (rs.next()) {
		ServicePartDetail entity = new ServicePartDetail();
		DBUtility.bindResultSet(entity, rs);
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
	
	/*public static ServicePartDetail  selectcheckName(String id ,String name) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		ServicePartDetail entity = new ServicePartDetail();
		entity.setBranch_id(id);
		entity.setBranch_name(name);
		return selectcheckName(entity);
	}*/
	public static String selectQty(String id,String pn,String discount) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{
			
			Connection conn = DBPool.getConnection();
			String qty ="0";
			String sql = "SELECT qty FROM " + tableName + " WHERE id='" + id + "' AND pn='"+pn+"'"+"  AND  discount='"+discount+"'";
			
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			
			while (rs.next()) {
				ServicePartDetail spd = new ServicePartDetail();
				DBUtility.bindResultSet(spd, rs);
				qty = spd.getQty();
			}
			
			conn.close();
			return qty;
	
	}
	public  static boolean checkDiscount(String id, String pn ,String discount) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		ServicePartDetail entity = new ServicePartDetail();
		entity.setId(id);
		entity.setPn(pn);
		entity.setDiscount(discount);
		return checkDiscount(entity);
	}
	public  static boolean checkDiscount(ServicePartDetail entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"id","pn","discount"});
		conn.close();
		return check;
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
	

	public String getVat() {
		return vat;
	}

	public void setVat(String vat) {
		this.vat = vat;
	}

	public String getTotal_vat() {
		return total_vat;
	}

	public void setTotal_vat(String total_vat) {
		this.total_vat = total_vat;
	}
	
	public String getSpd_net_price() {
		return spd_net_price;
	}

	public void setSpd_net_price(String spd_net_price) {
		this.spd_net_price = spd_net_price;
	}
	
	
}
