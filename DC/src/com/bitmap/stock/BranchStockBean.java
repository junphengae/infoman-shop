package com.bitmap.stock;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.bitmap.bean.branch.BranchMaster;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class BranchStockBean {
	public static String tableName  = "branch_stock";
	public static String[] keys      = {"pn","branch_id"};
	public static String[] fieldName = {"stock","update_date"};
	
	String pn 				= "";
	String branch_id 		= "";
	String stock			= "";
	Timestamp update_date 	= null;
	
	public String getPn() {
		return pn;
	}
	public void setPn(String pn) {
		this.pn = pn;
	}
	public String getBranch_id() {
		return branch_id;
	}
	public void setBranch_id(String branch_id) {
		this.branch_id = branch_id;
	}
	public String getStock() {
		return stock;
	}
	public void setStock(String stock) {
		this.stock = stock;
	}
	public Timestamp getUpdate_date() {
		return update_date;
	}
	public void setUpdate_date(Timestamp update_date) {
		this.update_date = update_date;
	}
	public static void Select(BranchStockBean entity) throws Exception{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			DBUtility.getEntityFromDB(conn, tableName, entity, keys);
			conn.close();
		} catch (Exception e) {
			if(conn != null){
				conn.rollback();
				conn.close();
			}
			throw new Exception(e.getMessage());
		}
	}
	public static List<BranchStockBean> SelectList(PageControl ctrl,String pn) throws Exception{
		Connection conn  = null;
		List<BranchStockBean> lst = null;
		try {
			conn  = DBPool.getConnection();
			conn.setAutoCommit(false);
			String query = "SELECT pn,branch_id,stock,update_date FROM "+tableName+" stock WHERE pn = '"+pn+"' ORDER BY pn ASC ";
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(query);
			
			lst = new ArrayList<BranchStockBean>();
			int min = (ctrl.getPage_num() - 1) * ctrl.getLine_per_page();
	        int max = (min + ctrl.getLine_per_page()) - 1;
	        int cnt = 0;
			while(rs.next()){
				if (cnt > max) {
	                cnt++;
	            } else {
	            	if (cnt >= min) {
	            		BranchStockBean entity = new BranchStockBean();
	    				DBUtility.bindResultSet(entity, rs);
	    				lst.add(entity);
	            	}
	            	  cnt++;
	            }
			}
			ctrl.setMin(min);
	        ctrl.setMax(cnt);
	        conn.commit();
			st.close();
			rs.close();
			conn.close();
		} catch (Exception e) {
			if(conn !=null){
				conn.rollback();
				conn.close();
			}
			throw new Exception(e.getMessage());
		}
		return lst;
	}
	public static List<BranchStockBean> SelectList() throws Exception{
		Connection conn  = null;
		List<BranchStockBean> lst = null;
		try {
			conn  = DBPool.getConnection();
			conn.setAutoCommit(false);
			String query = "SELECT pn,branch_id,stock,update_date FROM "+tableName+" ORDER BY pn ASC ";
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(query);
			
			lst = new ArrayList<BranchStockBean>();
			while(rs.next()){
	            		BranchStockBean entity = new BranchStockBean();
	    				DBUtility.bindResultSet(entity, rs);
	    				lst.add(entity);
			}
	        conn.commit();
			st.close();
			rs.close();
			conn.close();
		} catch (Exception e) {
			if(conn !=null){
				conn.rollback();
				conn.close();
			}
			throw new Exception(e.getMessage());
		}
		return lst;
	}
	public static void UpdateStockBranchFromWebService(BranchStockBean entity) throws Exception{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			if(checkDuplicate(conn,entity)){//ซ้ำ อัพเดต
				UpdateStock(conn,entity);
			}else{// ไม่ซ้ำ เพิ่ม
				Insert(conn,entity);
			}
			conn.close();
		} catch (Exception e) {
			if(conn!=null){
				conn.rollback();
				conn.close();
			}
			throw new Exception(e.getMessage());
		}
	}
	public static boolean checkDuplicate(Connection conn ,BranchStockBean entity) throws Exception{
		boolean check = false;
		try {
			check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		} catch (Exception e) {
			if(conn !=null){
				conn.rollback();
				conn.close();
			}
			throw new Exception(e.getMessage());
		}
		return check;
	}
	public static void Insert(Connection conn ,BranchStockBean entity) throws Exception{
		try {
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.insertToDB(conn, tableName, entity);
		} catch (Exception e) {
			if(conn !=null){
				conn.rollback();
				conn.close();
			}
			throw new Exception(e.getMessage());
		}
	}
	public static void UpdateStock(Connection conn ,BranchStockBean entity) throws Exception{
		try {
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity, fieldName, keys);
		} catch (Exception e) {
			if(conn !=null){
				conn.rollback();
				conn.close();
			}
			throw new Exception(e.getMessage());
		}
	}
}
