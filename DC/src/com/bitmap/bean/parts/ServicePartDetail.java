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
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;


import com.bitmap.bean.hr.Personal;
import com.bitmap.bean.sale.MoneyDiscountRound;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;
import com.bitmap.webutils.PageControl;

public class ServicePartDetail {
	public static String tableName = "service_part_detail";
	public static String[] keys = {"id","number"};
	public static String[] fieldNames = {"id","number","pn","qty","discount","discount_flag","cutoff_qty","price","create_by"
										,"create_date","update_by","update_date","branch_code","spd_net_price","spd_dis_total"};
	
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
	String branch_code = "";
	String spd_net_price = "0";
	String spd_dis_total  = "0";
	
	
	
	public String getSpd_dis_total() {
		return spd_dis_total;
	}

	public void setSpd_dis_total(String spd_dis_total) {
		this.spd_dis_total = spd_dis_total;
	}

	String UIDescription = "";
	String UICus_name = "";
	String UIStatus = "";
	String UIss_flag = "";
	
	Map UImap = null;
	
	
	
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


/*	public static void select(String job_id) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException {
		
		ServicePartDetail entity = new ServicePartDetail();
		entity.setId(job_id);
		//utoff(psd, conn);		
		Connection conn = DBPool.getConnection();
		 DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			ServicePartDetail detail = new ServicePartDetail();
			DBUtility.bindResultSet(detail, rs);
			
			total = Money.add(total, Money.multiple(detail.getQty(), detail.getPrice()));
		}
		rs.close();
		st.close();
		conn.close();
		return total;
	}*/
	public static void updateDiscount( String start , String end ) throws Exception{
		Connection conn = null;
		try {
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
				
				if( ! entity.getSpd_net_price().equalsIgnoreCase(net_price) || ! entity.getSpd_dis_total().equalsIgnoreCase(discount) ){
					entity.setSpd_net_price(net_price);
					entity.setSpd_dis_total(discount);
					
					DBUtility.updateToDB(conn, tableName, entity, new String[]{"spd_dis_total","spd_net"}, keys);
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
	public  static boolean check(String id ,String number) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		ServicePartDetail entity = new ServicePartDetail();
		entity.setId(id);
		entity.setNumber(number);
		return check(entity);
	}
	public  static boolean check(ServicePartDetail entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
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
			ServicePartDetail detail = new ServicePartDetail();
			DBUtility.bindResultSet(detail, rs);
			
			total = Money.add(total, Money.multiple(detail.getQty(), detail.getPrice()));
		}
		rs.close();
		st.close();
		return total;
	}
	
	public static void insert(ServicePartDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		entity.setNumber(DBUtility.genNumberFromDB(conn, tableName, entity, new String[]{"id"}, "number"));
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static void update_detail(ServicePartDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"qty","price","discount_flag","discount","update_by","update_date"}, keys);
		conn.close();
	}
	
	public static void update_discount(ServicePartDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"discount","update_by","update_date"}, keys);
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
	
	public static List<ServicePartDetail> list(String id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		List<ServicePartDetail> list = new ArrayList<ServicePartDetail>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT sd.*,(SELECT p.description FROM " + PartMaster.tableName + " p WHERE p.pn = sd.pn) AS description FROM " + tableName + " sd WHERE sd.id='" + id + "' ORDER BY (sd.number*1) ASC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			ServicePartDetail entity = new ServicePartDetail();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIDescription(DBUtility.getString("description", rs));
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<ServicePartDetail> listall() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		List<ServicePartDetail> list = new ArrayList<ServicePartDetail>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT sd.*,(SELECT p.description FROM " + PartMaster.tableName + " p WHERE p.pn = sd.pn) AS description FROM " + tableName + " sd WHERE 1=1 ORDER BY flag,create_date desc";
		//////System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			ServicePartDetail entity = new ServicePartDetail();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIDescription(DBUtility.getString("description", rs));
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<ServicePartDetail> selectallWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT "+tableName+".*,service_sale.cus_name, service_sale.status   FROM " + tableName + ",service_sale WHERE 1=1 and service_sale.id = " + tableName + ".id" ;
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("search")) {
					sql += " AND (service_sale.cus_name like'%" + str[1] + "%' " +
						   " OR service_sale.v_plate like'%" + str[1] + "%')";
				} else {
					sql += " AND " + str[0] + "='" + str[1] + "'";
				}
			}
		}
		
		sql += " ORDER BY (service_sale.id*1) desc";
		
		//////System.out.print("Draw::"+sql);
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
					
					entity.setUIDescription(PartMaster.select(entity.getPn(), conn).getDescription());
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
	//	backoff(psd, conn);		
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
//			if(entity.getQty().equalsIgnoreCase(entity.getCutoff_qty())){
//				entity.setFlag("1");
//			}else{
//				entity.setFlag("0");
//			}
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
		
		try {
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
			conn.commit();
			conn.close();
		} catch (Exception e) {
			conn.rollback();
			conn.close();
		}
		
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
				
				sql +=" AND DATE_FORMAT(create_date, '%Y-%m-%d')='"+str[1]+"' " ;
				
			} 
			else if (str[0].equalsIgnoreCase("year_month")){
				
				sql +=" AND DATE_FORMAT(create_date, '%Y-%m')='"+str[1]+"' " ;
				
			} 
			else if (str[0].equalsIgnoreCase("date_send2")){
				
				sql +=" AND DATE_FORMAT(create_date, '%Y-%m-%d') BETWEEN '"+str[1]+"' AND '"+str[2]+"' ";
				
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
	
	sql += " ORDER BY branch_code ASC, (id*1) ASC ,(number*1) ASC ";
	
	 //System.out.println(sql);
	
	Statement st = conn.createStatement();
	ResultSet rs = st.executeQuery(sql);
	
	while (rs.next()) {
		ServicePartDetail entity = new ServicePartDetail();
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

	public String getSpd_net_price() {
		return spd_net_price;
	}

	public void setSpd_net_price(String spd_net_price) {
		this.spd_net_price = spd_net_price;
	}
	
	
	
}
