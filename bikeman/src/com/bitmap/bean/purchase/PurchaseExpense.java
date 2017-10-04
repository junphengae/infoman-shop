package com.bitmap.bean.purchase;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.naming.NamingException;

//import com.bitmap.dbconnection.mysql.databasepool.part2day.DBPool;
import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class PurchaseExpense {

		public static String tableName = "pur_expense";
		private static String[] keys = {"pur_id"};
		private static String[] fieldNames = {"expense_id","cat_id","sub_cat_id","pur_date","mat_code","po","qty","type_unit","description","net_amount"
			 ,"vat","vat_amount","grand_total","status","update_by"
			 ,"update_date"};
		
		String pur_id = "";
		String expense_id = "";
		String cat_id = "";
		String sub_cat_id = "";
		Date pur_date = null;
		String mat_code = "";
		String po = "";
		String qty = "0";
		String type_unit = "";
		String description = "";
		String purchase_by = "";
		String net_amount = "0";
		String vat	 = "0";
		String vat_amount = "0";
		String grand_total	 = "0";
		String status = "";
		String create_by = "";	
		Timestamp create_date = null;
		String update_by = "";
		Timestamp update_date = null;
		
		String UIexpense = "";
		String UIcat = "";
		String UIsubcat = "";
		
		
		public String getUIexpense() {
			return UIexpense;
		}
		public void setUIexpense(String uIexpense) {
			UIexpense = uIexpense;
		}
		public String getUIcat() {
			return UIcat;
		}
		public void setUIcat(String uIcat) {
			UIcat = uIcat;
		}
		public String getUIsubcat() {
			return UIsubcat;
		}
		public void setUIsubcat(String uIsubcat) {
			UIsubcat = uIsubcat;
		}
		public String getExpense_id() {
			return expense_id;
		}
		public void setExpense_id(String expense_id) {
			this.expense_id = expense_id;
		}
		public String getPur_id() {
			return pur_id;
		}
		public void setPur_id(String pur_id) {
			this.pur_id = pur_id;
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
		public Date getPur_date() {
			return pur_date;
		}
		public void setPur_date(Date pur_date) {
			this.pur_date = pur_date;
		}
		public String getMat_code() {
			return mat_code;
		}
		public void setMat_code(String mat_code) {
			this.mat_code = mat_code;
		}
		public String getQty() {
			return qty;
		}
		public void setQty(String qty) {
			this.qty = qty;
		}
		public String getType_unit() {
			return type_unit;
		}
		public void setType_unit(String type_unit) {
			this.type_unit = type_unit;
		}
		public String getDescription() {
			return description;
		}
		public void setDescription(String description) {
			this.description = description;
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
		public String getVat_amount() {
			return vat_amount;
		}
		public void setVat_amount(String vat_amount) {
			this.vat_amount = vat_amount;
		}
		public String getGrand_total() {
			return grand_total;
		}
		public void setGrand_total(String grand_total) {
			this.grand_total = grand_total;
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
		public String getPo() {
			return po;
		}
		public void setPo(String po) {
			this.po = po;
		}
		public String getPurchase_by() {
			return purchase_by;
		}
		public void setPurchase_by(String purchase_by) {
			this.purchase_by = purchase_by;
		}
		/**
		 * whan 
		 * select all weight type
		 * @return
		 * @throws NamingException
		 * @throws SQLException
		 */
		public static List<String[]> selectList() throws NamingException, SQLException{
			List<String[]> l = new ArrayList<String[]>();
			String sql = "SELECT * FROM " + tableName;
			Connection conn = DBPool.getConnection();
			
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while(rs.next()){
				String id = DBUtility.getString("expense_id",rs);
				String name = DBUtility.getString("expense_name",rs);
				String[] vals = {id,name};
				l.add(vals);
			}
			rs.close();
			st.close();
			conn.close();
			return l;
		}

		public static PurchaseExpense select(PurchaseExpense entity) throws IllegalAccessException, InvocationTargetException, SQLException{
			Connection conn = DBPool.getConnection();
			DBUtility.getEntityFromDB(conn, tableName, entity, keys);
			conn.close();
			return entity;
		}

		public static void insert(PurchaseExpense entity) throws SQLException, IllegalAccessException, InvocationTargetException{
			Connection conn = DBPool.getConnection();
			entity.setPur_id(DBUtility.genNumber(conn, tableName,"pur_id"));
			entity.setCreate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.insertToDB(conn, tableName, entity);
			conn.close();
		}
		
		public static void update(PurchaseExpense entity) throws SQLException, IllegalAccessException, InvocationTargetException{
			Connection conn = DBPool.getConnection();
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
			conn.close();
		}
		
		public static List<PurchaseExpense> selectWithCTRL(PageControl ctrl, List<String[]> param) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
			Connection conn = DBPool.getConnection();
			String sql = "SELECT " +
							"a.*," +
							"(SELECT g.expense_name FROM pur_expense_group g WHERE g.expense_id = a.expense_id) AS expense_name," +
							"(SELECT c.cat_name FROM pur_expense_cat c WHERE c.cat_id = a.cat_id AND c.expense_id = a.expense_id) AS cat_name," +
							"(SELECT s.sub_cat_name FROM pur_expense_subcat s WHERE s.sub_cat_id = a.sub_cat_id AND s.cat_id = a.cat_id AND s.expense_id = a.expense_id) AS sub_cat_name " +
						 "FROM " + tableName + " a " +
						 "WHERE 1=1 ";
			
			for (Iterator<String[]> iterator = param.iterator(); iterator.hasNext();) {
				String[] pm = (String[]) iterator.next();
				if (pm[1].length() > 0) {
					if(pm[0].equalsIgnoreCase("keyword")) {
						sql += " AND (a.po like '%" + pm[1] + "%')";
					} else {
						sql += " AND a." + pm[0] + " ='" + pm[1] + "'";
					}
				}
			}
			
			sql += " ORDER BY create_date DESC";
			////System.out.println(sql);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			
			List<PurchaseExpense> list = new ArrayList<PurchaseExpense>();
			int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
			int max = (min + ctrl.getLine_per_page()) - 1;
			int cnt = 0;
			while (rs.next()) {
				if (cnt > max) {
					cnt++;
				} else {
					if (cnt >= min) {
						PurchaseExpense entity = new PurchaseExpense();
						DBUtility.bindResultSet(entity, rs);
						entity.setUIexpense(rs.getString("expense_name"));
						entity.setUIcat(rs.getString("cat_name"));
						entity.setUIsubcat(rs.getString("sub_cat_name"));
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
		
		public static PurchaseExpense selectForView(PurchaseExpense entity2) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{
			Connection conn = DBPool.getConnection();
			String sql = "SELECT a.*," +
			"(SELECT g.expense_name FROM pur_expense_group g WHERE g.expense_id = a.expense_id) AS expense_name," +
			"(SELECT c.cat_name FROM pur_expense_cat c WHERE c.cat_id = a.cat_id AND c.expense_id = a.expense_id) AS cat_name," +
			"(SELECT s.sub_cat_name FROM pur_expense_subcat s WHERE s.sub_cat_id = a.sub_cat_id AND s.cat_id = a.cat_id AND s.expense_id = a.expense_id) AS sub_cat_name " +
		 "FROM " + tableName + " a WHERE pur_id = '" + entity2.getPur_id() + "'";
			////System.out.println(sql);
			
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			PurchaseExpense entity = new PurchaseExpense();
			if(rs.next()){
				DBUtility.bindResultSet(entity, rs);
				entity.setUIexpense(rs.getString("expense_name"));
				entity.setUIcat(rs.getString("cat_name"));
				entity.setUIsubcat(rs.getString("sub_cat_name"));
			}
			
			rs.close();
			st.close();
			conn.close();
			return entity;
		}
}

