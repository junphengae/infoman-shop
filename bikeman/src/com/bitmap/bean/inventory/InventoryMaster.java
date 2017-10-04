package com.bitmap.bean.inventory;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class InventoryMaster {
	public static String tableName = "inv_master";
	private static String[] keys = {"mat_code"};
	private static String[] fieldInfo = {"group_id","cat_id","sub_cat_id","mat_code","serial","mfg_date","description","fifo_flag"
		 ,"mor","price","cost","std_unit","unit_pack"
		 ,"des_unit","update_by","update_date"};

	String group_id = "";
	String cat_id = "";
	String sub_cat_id = "";
	String mat_code = "";
	String serial = "";
	String status = "0";
	String description = "";
	String fifo_flag = "";
	String mor	 = "0";
	String mfg_date = "";
	String location = "";
	String price = "0";
	String cost	 = "0";
	String std_unit	 = "";
	String des_unit = "";
	String balance = "0";
	String remark = "";
	String create_by = "";	
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	
	
	String UIGroup_name = "";
	public String getUIGroup_name() {return UIGroup_name;}
	public void setUIGroup_name(String uIGroup_name) {UIGroup_name = uIGroup_name;}
	
	String UICat_name = "";
	public String getUICat_name() {return UICat_name;}
	public void setUICat_name(String uICat_name) {UICat_name = uICat_name;}

	String UISub_cat_name = "";
	public String getUISub_cat_name() {return UISub_cat_name;}
	public void setUISub_cat_name(String uISub_cat_name) {UISub_cat_name = uISub_cat_name;}

	String UILocation = "";
	public String getUILocation() {return UILocation;}
	public void setUILocation(String uILocation) {UILocation = uILocation;}

	String UIBalance = "-";
	public String getUIBalance() {return UIBalance;}
	public void setUIBalance(String uIBalance) {UIBalance = uIBalance;}
	
	String UImat_code = "";
	public String getUImat_code() {return UImat_code;}
	public void setUImat_code(String uImat_code) {UImat_code = uImat_code;}

	private SubCategories UISubCat = new SubCategories();
	public SubCategories getUISubCat() {return UISubCat;}
	public void setUISubCat(SubCategories uISubCat) {UISubCat = uISubCat;}
	
	String UIdesUnit = "";
	public String getUIdesUnit() {
		return UIdesUnit;
	}
	public void setUIdesUnit(String uIdesUnit) {
		UIdesUnit = uIdesUnit;
	}
	
	/**
	 * Ken : Update Balance
	 * @throws InvocationTargetException 
	 * @throws IllegalAccessException 
	 * @throws SQLException 
	 * @throws UnsupportedEncodingException 
	 */
	public static void developUpdateBalance() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT mat_code FROM " + tableName ;
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while(rs.next()){
			InventoryMaster master = new InventoryMaster();
			DBUtility.bindResultSet(master, rs);
			//master.setBalance(InventoryLot.selectActiveSum(master.getMat_code(), conn));
			InventoryMaster.updateBalance(master, conn);
		}
		
		conn.close();
	}
	
	
	public static InventoryMaster select(String mat_code) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		InventoryMaster entity = new InventoryMaster();
		entity.setMat_code(mat_code);
		select(entity);
		return entity;
	}
	
	
	public static  InventoryMaster select_DescriptMatCode(InventoryMaster entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException
	{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity,keys);
		conn.close();
		return entity;
	}
	
	public static  String checkSerial(String mat_code) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException
	{
		Connection conn = DBPool.getConnection();
		InventoryMaster entity = new InventoryMaster();
		entity.setMat_code(mat_code);
		DBUtility.getEntityFromDB(conn, tableName, entity,keys);
		conn.close();
		return entity.getSerial();
	}
	
	public static  boolean checkHave(InventoryMaster entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException
	{
		Connection conn = DBPool.getConnection();
		boolean check = DBUtility.getEntityFromDB(conn, tableName, entity,keys);
		conn.close();
		return check;
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
		select(entity);
		return entity;
	}
	
	public static InventoryMaster select_sh(String mat_code, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		InventoryMaster entity = new InventoryMaster();
		entity.setMat_code(mat_code);
		DBUtility.getEntityFromDB(conn,tableName,entity, keys);
		return entity;
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
	
	public static void insertWithMatcode(InventoryMaster entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	private static String genMatCode(InventoryMaster entity, Connection conn) throws SQLException{
		String sql = "SELECT mat_code FROM " + tableName + " WHERE mat_code LIKE 'kd%' ORDER BY mat_code DESC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String mat_code = "kd0001";
		if (rs.next()) {
			String temp = DBUtility.getString("mat_code", rs);
			mat_code = (Integer.parseInt(temp.substring(2, temp.length())) + 10001) + "";
			mat_code = "kd" + mat_code.substring(1, mat_code.length());
		}
		rs.close();
		st.close();
		return mat_code;
	}
	
	public static List<InventoryMaster> selectList() throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " ORDER BY (mat_code*1)";
		
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
	
	public static List<Master> selectList(InventoryMaster master) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE group_id='" + master.getGroup_id() + "' AND cat_id='" + master.getCat_id() + "' AND sub_cat_id='" + master.getSub_cat_id() + "' ORDER BY (mat_code*1)";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Master> list = new ArrayList<Master>();
		
		while (rs.next()) {
			Master entity = new Master();
			DBUtility.bindResultSet(entity, rs);
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
	
	public static void updateBalance(InventoryMaster entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{		
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"balance"}, keys);
	}
	
	public static void updateBalance(InventoryMaster entity) throws IllegalAccessException, InvocationTargetException, SQLException{		
		Connection conn = DBPool.getConnection();
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"balance"}, keys);
		conn.close();
	}
	

	public static List<InventoryMaster> selectFGWithCTRL(PageControl ctrl, List<String[]> param) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT " +
						"a.*," +
						"(SELECT g.group_name_en FROM inv_group g WHERE g.group_id = a.group_id) AS group_name," +
						"(SELECT c.cat_name_short FROM inv_categories c WHERE c.cat_id = a.cat_id AND c.group_id = a.group_id) AS cat_name," +
						"(SELECT s.sub_cat_name_short FROM inv_sub_categories s WHERE s.sub_cat_id = a.sub_cat_id AND s.cat_id = a.cat_id AND s.group_id = a.group_id) AS sub_cat_name " +
					 "FROM " + tableName + " a " +
					 "WHERE 1=1 ";
		//String sql = "SELECT * FROM inv_master";
		
		for (Iterator<String[]> iterator = param.iterator(); iterator.hasNext();) {
			String[] pm = (String[]) iterator.next();
			if (pm[1].length() > 0) {
				if(pm[0].equalsIgnoreCase("keyword")) {
					sql += " AND (a.description like '%" + pm[1] + "%'" +
						   " OR a.mat_code like '%" + pm[1] + "%')";
				} else if(pm[0].equalsIgnoreCase("id_template") || pm[0].equalsIgnoreCase("order_id")){
					
				} else if(pm[0].equalsIgnoreCase("page")){
					if(pm[1].equalsIgnoreCase("fg_item_search")){
						sql += " AND (a.group_id = '3' OR a.group_id = '4')";
					}else if(pm[1].equalsIgnoreCase("fg_search")){
							sql += " AND a.group_id <> '3' AND a.group_id <> '4' ";
						}
				}else {
					//sql += " AND a." + pm[0] + " ='" + pm[1] + "'";
				}
			}
		}
		
		sql += " ORDER BY (a.mat_code*1)";
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
					entity.setUIGroup_name(DBUtility.getString("group_name", rs));
					entity.setUICat_name(DBUtility.getString("cat_name", rs));
					entity.setUISub_cat_name(DBUtility.getString("sub_cat_name", rs));
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
	
	/**
	 * ken: inventory/inventory_list.jsp
	 * <br>
	 * �?�?้ไขให้�?สดง status ทั้งหมด
	 * @param ctrl
	 * @param param
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<InventoryMaster> selectWithCTRL(PageControl ctrl, List<String[]> param) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT " +
						"a.*," +
						"(SELECT g.group_name_en FROM inv_group g WHERE g.group_id = a.group_id) AS group_name," +
						"(SELECT c.cat_name_short FROM inv_categories c WHERE c.cat_id = a.cat_id AND c.group_id = a.group_id) AS cat_name," +
						"(SELECT s.sub_cat_name_short FROM inv_sub_categories s WHERE s.sub_cat_id = a.sub_cat_id AND s.cat_id = a.cat_id AND s.group_id = a.group_id) AS sub_cat_name " +
					 "FROM " + tableName + " a " +
					 "WHERE 1=1 ";
		
		for (Iterator<String[]> iterator = param.iterator(); iterator.hasNext();) {
			String[] pm = (String[]) iterator.next();
			if (pm[1].length() > 0) {
				if(pm[0].equalsIgnoreCase("keyword")) {
					sql += " AND (a.description like '%" + pm[1] + "%'" +
						   " OR a.mat_code like '%" + pm[1] + "%')";
				} else if(pm[0].equalsIgnoreCase("master_matcode")){
					
				} else {
					sql += " AND a." + pm[0] + " ='" + pm[1] + "'";
				}
			}
		}
		
		sql += " ORDER BY (a.mat_code*1)";
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
					entity.setUIGroup_name(DBUtility.getString("group_name", rs));
					entity.setUICat_name(DBUtility.getString("cat_name", rs));
					entity.setUISub_cat_name(DBUtility.getString("sub_cat_name", rs));
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
	 * whan : inv_template 
	 * <br>
	 * select serial ='y'
	 * @param ctrl
	 * @param param
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<InventoryMaster> selectHaveSerial(PageControl ctrl) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE serial='y' ORDER BY (mat_code*1)";
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
	
	
	/**
	 * whan : menu_add
	 * select only description by mat_code
	 * @param mat_code
	 * @return
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 */
	public static String selectOnlyDescrip(String mat_code) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		InventoryMaster entity = new InventoryMaster();
		entity.setMat_code(mat_code);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity.getDescription();
	}
	
	public static String selectDesUnit(String mat_code) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		InventoryMaster entity = new InventoryMaster();
		entity.setMat_code(mat_code);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity.getDes_unit();
	}
	
	public static String selectBalance(String mat_code) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		InventoryMaster mat = new InventoryMaster();
		mat.setMat_code(mat_code);	
		DBUtility.getEntityFromDB(conn, tableName, mat, keys);
		conn.close();
		return mat.getBalance();	
	}
	
	public static List<InventoryMaster> selectinv_branch(InventoryMaster master,String branch_id) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT master.*,b.price as branch_price FROM " + tableName + " master,inv_master_branch b WHERE master.group_id='" + master.getGroup_id() + "' AND master.cat_id='" + master.getCat_id() + "' AND master.sub_cat_id='" + master.getSub_cat_id() + "'";
		sql +=" AND master.mat_code = b.mat_code AND b.branch_id = '" + branch_id + "' ORDER BY (master.mat_code*1)";

		////System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryMaster> list = new ArrayList<InventoryMaster>();
		while (rs.next()) {
				InventoryMaster entity = new InventoryMaster();
				DBUtility.bindResultSet(entity, rs);
				entity.setUIBalance(rs.getString("branch_price"));
				
				list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static String selectPrice(String mat_code) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		InventoryMaster mat = new InventoryMaster();
		mat.setMat_code(mat_code);	
		DBUtility.getEntityFromDB(conn, tableName, mat, keys);
		conn.close();
		return mat.getPrice();	
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
	public String getBalance() {
		return balance;
	}
	public void setBalance(String balance) {
		this.balance = balance;
	}
	public String getSerial() {
		return serial;
	}
	public void setSerial(String serial) {
		this.serial = serial;
	}
	public String getMfg_date() {
		return mfg_date;
	}
	public void setMfg_date(String mfg_date) {
		this.mfg_date = mfg_date;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}

}