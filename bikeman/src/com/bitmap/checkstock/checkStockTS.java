package com.bitmap.checkstock;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import com.bitmap.bean.parts.PartGroups;
import com.bitmap.bean.parts.PartMaster;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class checkStockTS {
	public static final String tableName 	= "check_stock";
	public static final String[] keys    	= {"check_id","seq","pn"};
	public static final String[] fieldNames_save = "qty_new,qty_diff,status,update_date,update_by".split(",");
	public static final String[] fieldNames_close= "qty_diff,status,close_date,close_by".split(",");
	public static String STATUS_NOT_CLOSE = "00";
	public static String STATUS_SAVE_FINISH = "10";
	public static String STATUS_CLOSE_FINISH = "20";
	
	public static String status(String status){
		HashMap<String , String> map = new HashMap<String, String>();
		map.put(STATUS_NOT_CLOSE, "ยังไม่ได้ปิด");
		map.put(STATUS_SAVE_FINISH, "บันทึกแล้ว");
		map.put(STATUS_CLOSE_FINISH, "ปิดยอดแล้ว");
		
		return map.get(status);
	}
	
	public static void insert(Connection conn, checkStockBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setCheck_id(Integer.parseInt(DBUtility.genNumberFromDB(conn, tableName, entity, new String[]{"pn"}, "check_id")));
		entity.setSeq(Integer.parseInt(DBUtility.genNumberFromDB(conn, tableName, entity, new String[]{"check_id","pn"}, "seq")));
		entity.setStatus("00");
		entity.setCheck_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
	}
	public static void Edit_stock(Connection conn, checkStockBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus("10");
		entity.setSeq(Integer.parseInt(DBUtility.genNumberFromDB(conn, tableName, entity, new String[]{"check_id"}, "seq")));
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
	}
	public static void Save_Stock(Connection conn ,checkStockBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus("10");
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames_save, keys);
	}
	public static List<checkStockBean> selectWithCTRL(PageControl ctrl, List<String[]> params) throws Exception{
		String sql = "SELECT * FROM " + tableName + " a WHERE 1=1  ";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("pn")){
					
					sql += " AND pn='"+str[1]+"' ";
				}
			}
		}
		String check_id_max = SelectMaxCheckID();
		String seq_max      = SelectMaxSEQ();
		if(check_id_max.equalsIgnoreCase("")||check_id_max.equalsIgnoreCase("0")){
			
		}else{
			sql += " AND a.check_id= "+check_id_max+" AND a.seq= ( SELECT MAX(b.seq) FROM "+tableName+" b WHERE b.check_id = "+check_id_max+" AND b.pn = a.pn)";
		}
		sql += " ORDER BY pn ASC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<checkStockBean> list = new ArrayList<checkStockBean>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					checkStockBean entity = new checkStockBean();
					DBUtility.bindResultSet(entity, rs);
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
	public static String SelectMaxCheckID() throws Exception{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			String sql = "SELECT max(check_id) as cnt FROM "+tableName+" ";
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			String cnt= "";
			while(rs.next()){
				cnt = DBUtility.getString("cnt", rs);
			}
			st.close();
			rs.close();
			conn.close();
			return cnt;
		} catch (Exception e) {
			if( conn != null){
				conn.rollback();
				conn.close();
			 }
			System.out.println(e.getMessage());
			 throw new Exception(e.getMessage());
		}
	}
	public static String SelectMaxSEQ() throws Exception{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			String sql = "SELECT max(seq) as cnt FROM "+tableName+" ";
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			String cnt= "";
			while(rs.next()){
				cnt = DBUtility.getString("cnt", rs);
			}
			st.close();
			rs.close();
			conn.close();
			return cnt;
		} catch (Exception e) {
			if( conn != null){
				conn.rollback();
				conn.close();
			 }
			System.out.println(e.getMessage());
			 throw new Exception(e.getMessage());
		}
	}
	
	@SuppressWarnings("unused")
	public static void select(checkStockBean entity) throws Exception{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		} catch (Exception e) {
			if( conn != null){
				conn.rollback();
				conn.close();
			 }
			System.out.println(e.getMessage());
			 throw new Exception(e.getMessage());
		}
		
		
	}
	public static boolean checkClose_stock() throws Exception{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			String max_check_id = checkStockTS.SelectMaxCheckID();
			boolean cnt= false;
			if(max_check_id.equalsIgnoreCase("") || max_check_id.equalsIgnoreCase("0")){
				cnt = false;
			}else{
				String sql = "SELECT * FROM "+tableName+" a WHERE  a.check_id = "+max_check_id+" AND a.seq = ( SELECT MAX(b.seq) FROM check_stock b WHERE b.check_id = "+max_check_id+" AND b.pn = a.pn) and status !='20' ";
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery(sql);
				while(rs.next()){
					cnt = true;
				}
				st.close();
				rs.close();
				conn.commit();
				conn.close();
			}
			//System.out.println("CHECK CLOSE = "+cnt);
			return cnt;
		} catch (Exception e) {
			if( conn != null){
				conn.rollback();
				conn.close();
			 }
			System.out.println(e.getMessage());
			 throw new Exception(e.getMessage());
		}
	}
	public static boolean checkCheck_stock() throws Exception{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			String max_check_id = checkStockTS.SelectMaxCheckID();
			boolean cnt= true;
			if(max_check_id.equalsIgnoreCase("") || max_check_id.equalsIgnoreCase("0")){
					cnt = true;
			}else{
				String sql = "SELECT * FROM "+tableName+" a WHERE  a.check_id = "+max_check_id+" AND a.seq = ( SELECT MAX(b.seq) FROM check_stock b WHERE b.check_id = "+max_check_id+" AND b.pn = a.pn) and status ='10' or status='00' ";
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery(sql);
				while(rs.next()){
					cnt = false;
				}
				st.close();
				rs.close();
				conn.commit();
				conn.close();
			}
			//System.out.println("CHECK STOCK = "+cnt);
			return cnt;
		} catch (Exception e) {
			if( conn != null){
				conn.rollback();
				conn.close();
			 }
			System.out.println(e.getMessage());
			 throw new Exception(e.getMessage());
		}
	}
	public static List<checkStockBean> selectList() throws Exception{
		Connection conn = DBPool.getConnection();
		String max_check_id = checkStockTS.SelectMaxCheckID();
		String sql = "SELECT * FROM "+tableName+" a WHERE  a.check_id = "+max_check_id+" AND a.seq = ( SELECT MAX(b.seq) FROM check_stock b WHERE b.check_id = "+max_check_id+" AND b.pn = a.pn) ";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<checkStockBean> list = new ArrayList<checkStockBean>();
		while (rs.next()) {
			checkStockBean entity = new checkStockBean();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	public static List<checkStockBean> selectList_check4close() throws Exception{
		Connection conn = DBPool.getConnection();
		String max_check_id = checkStockTS.SelectMaxCheckID();
		String sql = "SELECT * FROM "+tableName+" a WHERE  a.check_id = "+max_check_id+" AND a.seq = ( SELECT MAX(b.seq) FROM check_stock b WHERE b.check_id = "+max_check_id+" AND b.pn = a.pn) and status='10'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<checkStockBean> list = new ArrayList<checkStockBean>();
		while (rs.next()) {
			checkStockBean entity = new checkStockBean();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	public static void Close_stock(Connection conn,checkStockBean entity) throws NumberFormatException, IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		entity.setStatus("20");
		entity.setClose_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames_close, keys);
	}
}
