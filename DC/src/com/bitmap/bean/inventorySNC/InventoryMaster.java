package com.bitmap.bean.inventorySNC;

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

import com.bitmap.bean.util.StatusUtil;
import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;
import com.bitmap.webutils.WebUtils;

public class InventoryMaster {
	public static String tableName = "inv_master";
	private static String[] keys = {"mat_code"};
	private static String[] fieldInfo = {"group_id","cat_id","sub_cat_id","ref_code","brand_name","description","fifo_flag"
										 ,"mor","price","cost","std_unit","menu_order","unit_pack","balance"
										 ,"des_unit","location","update_by","update_date"};
	
	String group_id = "";
	String cat_id = "";
	String sub_cat_id = "";
	String mat_code = "";
	String ref_code = "";
	String brand_name = "";
	String description = "";
	String fifo_flag = "";
	String mor	 = "0";
	String price = "0";
	String cost	 = "0";
	String std_unit	 = "";
	String des_unit = "";
	String unit_pack = "";
	String location	 = "";
	String ss_code	 = "";
	String menu_order = "99";
	String UINew_menu_order = "99";
	String remark = "";
	String ss_flag	 = "";
	String balance = "0";
	String create_by = "";	
	String status = StatusUtil.INACTIVE;
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	
	private SubCategories UISubCat = new SubCategories();
	public SubCategories getUISubCat() {return UISubCat;}
	public void setUISubCat(SubCategories uISubCat) {UISubCat = uISubCat;}

	public static InventoryMaster select(String mat_code) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		InventoryMaster entity = new InventoryMaster();
		entity.setMat_code(mat_code);
		select(entity);
		return entity;
	}
	
	public static boolean select(InventoryMaster entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean has = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUISubCat(SubCategories.select(entity.getSub_cat_id(), entity.getCat_id(), entity.getGroup_id(), conn));
		conn.close();
		return has;
	}
	
	public static InventoryMaster select(String mat_code, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		InventoryMaster entity = new InventoryMaster();
		entity.setMat_code(mat_code);
		select(entity, conn);
		return entity;
	}
	
	public static String clone(String mat_code, String desc, String create_by, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		InventoryMaster entity = new InventoryMaster();
		entity.setMat_code(mat_code);
		select(entity, conn);
		
		entity.setCreate_by(create_by);
		entity.setDescription(desc);
		entity.setUpdate_by("");
		entity.setUpdate_date(null);
		clone4RD(entity,mat_code, conn);
		
		return entity.getMat_code();
	}
	
	public static boolean select(InventoryMaster entity, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		boolean has = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUISubCat(SubCategories.select(entity.getSub_cat_id(), entity.getCat_id(), entity.getGroup_id(), conn));
		return has;
	}
	
	public static void insert(InventoryMaster entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setMat_code(genMatCode(entity, conn));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	/**
	 * Insert for create by R&amp;D<br/> set status = RD_CREATE
	 * @param entity
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 */
	public static void insert4RD(InventoryMaster entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(StatusUtil.RD_CREATE);
		entity.setRemark(WebUtils.getDateTimeValue(DBUtility.getDBCurrentDateTime())+" - Create Formular<br>");
		String mat_code = genMatCode(entity, conn);
		entity.setMat_code(mat_code);
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
	}
	
	public static void clone4RD(InventoryMaster entity, String old_mat_code, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(StatusUtil.RD_CREATE);
		entity.setRemark(WebUtils.getDateTimeValue(DBUtility.getDBCurrentDateTime())+" - Clone Formular from " + old_mat_code + "<br>");
		String mat_code = genMatCode(entity, conn);
		entity.setMat_code(mat_code);
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
	}
	
	public static void update4RD(InventoryMaster entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"group_id","cat_id","sub_cat_id","ref_code","brand_name","description","fifo_flag","price","cost","std_unit","des_unit","update_date","update_by"}, keys);
	}
	
	public static boolean checkName(InventoryMaster entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean has = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"description"});
		conn.close();
		return false;
		//return has;
	}
	
	public static boolean checkNameForEdit(InventoryMaster entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT mat_code FROM " + tableName + " WHERE mat_code!='" + entity.getMat_code() + "' AND description='" + entity.getDescription() + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		boolean has = false;
		if (rs.next()) {
			has = true;
		}
		rs.close();
		st.close();
		conn.close();
		return false;
		//return has;
	}
	
	
	private static String genMatCode(InventoryMaster entity, Connection conn) throws SQLException{
		String sql = "SELECT mat_code FROM " + tableName + " ORDER BY (mat_code*1) DESC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String mat_code = "1000001";
		if (rs.next()) {
			String temp = DBUtility.getString("mat_code", rs);
			mat_code = (Integer.parseInt(temp) + 1000001) + "";
		}
		rs.close();
		st.close();
		return mat_code.substring(1, mat_code.length()) ;
	}
	
	public static List<InventoryMaster> selectList(String group_id, String cat_id, String sub_cat_id,String status) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE group_id='" + group_id + "' AND cat_id='" + cat_id + "' AND sub_cat_id='" + sub_cat_id + "'" + ((status.length() > 0)?" AND status='" + status + "'":"") + " ORDER BY (menu_order*1)";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryMaster> list = new ArrayList<InventoryMaster>();
		while (rs.next()) {
			InventoryMaster entity = new InventoryMaster();
			DBUtility.bindResultSet(entity, rs);
			entity.setUISubCat(SubCategories.select(entity.getSub_cat_id(), entity.getCat_id(), entity.getGroup_id(), conn));
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<InventoryMaster> selectWithCTRL(PageControl ctrl, String where) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName;
		if (where.length() > 0) {
			sql += " WHERE " + where;
		}
		sql += " ORDER BY (mat_code*1)";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryMaster> list = new ArrayList<InventoryMaster>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					InventoryMaster entity = new InventoryMaster();
					DBUtility.bindResultSet(entity, rs);
					entity.setUISubCat(SubCategories.select(entity.getSub_cat_id(), entity.getCat_id(), entity.getGroup_id(), conn));
					list.add(entity);
				}
				cnt++;
			}
		}
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<InventoryMaster> selectWithCTRL(PageControl ctrl, List<String[]> param) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE group_id != 'MT' AND group_id!= 'PK'";;
		
		for (Iterator<String[]> iterator = param.iterator(); iterator.hasNext();) {
			String[] pm = (String[]) iterator.next();
			if (!pm[0].equalsIgnoreCase("where") && !pm[0].equalsIgnoreCase("keyword")) {
				if (pm[1].length() > 0) {
					if(pm[0].equalsIgnoreCase("description") || pm[0].equalsIgnoreCase("location") || pm[0].equalsIgnoreCase("ref_code")) {
						sql += " AND " + pm[0] + " like '%" + pm[1] + "%'";
					} else {
						sql += " AND " + pm[0] + " ='" + pm[1] + "'";
					}
				}
			}
		}
		
		sql += " ORDER BY (mat_code*1)";
		////System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryMaster> list = new ArrayList<InventoryMaster>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					InventoryMaster entity = new InventoryMaster();
					DBUtility.bindResultSet(entity, rs);
					entity.setUISubCat(SubCategories.select(entity.getSub_cat_id(), entity.getCat_id(), entity.getGroup_id(), conn));
					list.add(entity);
				}
				cnt++;
			}
		}
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static void updateInfo(InventoryMaster entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldInfo, keys);
		conn.close();
	}
	
	/**
	 * update status <br/>
	 * -group_id
	 * -cat_id
	 * -mat_code
	 * @param entity
	 * @throws SQLException 
	 * @throws InvocationTargetException 
	 * @throws IllegalAccessException 
	 */
	public static void updateStausInfo(InventoryMaster entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"status","update_date","update_by"}, keys);
		conn.close();
	}
	
	public static void updateOrder(String[] menu) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		
		for (int i = 0; i < menu.length; i++) {
			InventoryMaster entity = new InventoryMaster();
			entity.setMat_code(menu[i]);
			entity.setMenu_order((i+1) + "");
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"menu_order"}, keys);
		}
		
		conn.close();
	}
	
	public static void updateRemark(InventoryMaster entity) throws SQLException{
		Connection conn = DBPool.getConnection();
		String sql = "update "+tableName+" set remark = concat(remark,'" + WebUtils.getDateTimeValue(DBUtility.getDBCurrentDateTime()) + " - " + entity.getRemark() + "<br>') " +
					 " where mat_code = '"+entity.getMat_code()+"'";
		
		PreparedStatement ps = conn.prepareStatement(sql);		
		ps.execute();
		ps.close();
		conn.close();
	}

	public String getGroup_id() {
		return group_id;
	}
	public void setGroup_id(String group_id) {
		this.group_id = group_id;
	}
	public String getCat_id() {
		return cat_id;
	}
	public void setCat_id(String cat_id) {
		this.cat_id = cat_id;
	}
	public String getSub_cat_id() {
		return sub_cat_id;
	}
	public void setSub_cat_id(String sub_cat_id) {
		this.sub_cat_id = sub_cat_id;
	}
	public String getMat_code() {
		return mat_code;
	}
	public void setMat_code(String mat_code) {
		this.mat_code = mat_code;
	}
	public String getRef_code() {
		return ref_code;
	}
	public void setRef_code(String ref_code) {
		this.ref_code = ref_code;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getFifo_flag() {
		return fifo_flag;
	}
	public void setFifo_flag(String fifo_flag) {
		this.fifo_flag = fifo_flag;
	}
	public String getMor() {
		return mor;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public void setMor(String mor) {
		this.mor = mor;
	}
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
	}
	public String getCost() {
		return cost;
	}
	public void setCost(String cost) {
		this.cost = cost;
	}
	public String getStd_unit() {
		return std_unit;
	}
	public void setStd_unit(String std_unit) {
		this.std_unit = std_unit;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getSs_code() {
		return ss_code;
	}
	public void setSs_code(String ss_code) {
		this.ss_code = ss_code;
	}
	public String getSs_flag() {
		return ss_flag;
	}
	public void setSs_flag(String ss_flag) {
		this.ss_flag = ss_flag;
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
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getDes_unit() {
		return des_unit;
	}
	public void setDes_unit(String des_unit) {
		this.des_unit = des_unit;
	}
	public String getBrand_name() {
		return brand_name;
	}
	public void setBrand_name(String brand_name) {
		this.brand_name = brand_name;
	}
	public String getMenu_order() {
		return menu_order;
	}
	public void setMenu_order(String menu_order) {
		this.menu_order = menu_order;
	}
	public String getUINew_menu_order() {
		return UINew_menu_order;
	}
	public void setUINew_menu_order(String uINew_menu_order) {
		UINew_menu_order = uINew_menu_order;
	}
	public String getUnit_pack() {
		return unit_pack;
	}
	public void setUnit_pack(String unit_pack) {
		this.unit_pack = unit_pack;
	}
	public String getBalance() {
		return balance;
	}
	public void setBalance(String balance) {
		this.balance = balance;
	}
}