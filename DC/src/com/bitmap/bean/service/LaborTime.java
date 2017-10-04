package com.bitmap.bean.service;

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

import com.bitmap.bean.parts.ServiceSale;
import com.bitmap.bean.sale.Vehicle;
import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class LaborTime {
	public static final String tableName = "sv_labor_time_guide";
	private static String[] keys = {"labor_id"};
	private static String[] fieldNames = {"labor_th","labor_en","labor_hour","update_by","update_date"};
	
	String main_id = "";
	String labor_id = "";
	String labor_th = "";
	String labor_en = "";
	String labor_hour = "0.0";
	String create_by = "";
	String update_by = "";
	Timestamp create_date = null;
	Timestamp update_date = null;
	
	public static LaborTime select(String labor_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		LaborTime entity = new LaborTime();
		entity.setLabor_id(labor_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static List<LaborTime> list(String main_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE main_id='" + main_id + "' ORDER BY labor_id";
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<LaborTime> list = new ArrayList<LaborTime>();
		while (rs.next()) {
			LaborTime entity = new LaborTime();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		conn.close();
		return list;
	}
	
	
	public static List<LaborTime> listsearch(String main_id,String cate_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "select * from  sv_labor_time_cate  Inner Join sv_labor_time_main  on sv_labor_time_cate.cate_id = sv_labor_time_main.cate_id  Inner Join sv_labor_time_guide on sv_labor_time_main.main_id = sv_labor_time_guide.main_id ";
		sql += "where 1=1 ";
		if(!main_id.equalsIgnoreCase("")){
			sql += " and sv_labor_time_main.main_id = '" + main_id + "' ";
		}
		
		if(!cate_id.equalsIgnoreCase("")){
			sql += " and sv_labor_time_main.cate_id  = '" + cate_id + "' ";
		}
		
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<LaborTime> list = new ArrayList<LaborTime>();
		while (rs.next()) {
			LaborTime entity = new LaborTime();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		conn.close();
		return list;
	}
	
	public static List<LaborTime> listsearchcate(String cate_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "select * from  sv_labor_time_cate  Inner Join sv_labor_time_main  on sv_labor_time_cate.cate_id = sv_labor_time_main.cate_id  Inner Join sv_labor_time_guide on sv_labor_time_main.main_id = sv_labor_time_guide.main_id ";
		if(!cate_id.equalsIgnoreCase("")){
			sql += "where sv_labor_time_main.cate_id  = '" + cate_id + "'";
		}
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<LaborTime> list = new ArrayList<LaborTime>();
		while (rs.next()) {
			LaborTime entity = new LaborTime();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		conn.close();
		return list;
	}
	
	
	
	private static String genId(LaborTime entity, Connection conn) throws SQLException{
		String id = entity.getMain_id() + "-0001";
		String sql = "SELECT labor_id FROM " + tableName + " WHERE main_id = '" + entity.getMain_id() + "' ORDER BY labor_id DESC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		if (rs.next()) {
			String data = rs.getString(1);
			String temp = data.split("-")[2];
			temp = (Integer.parseInt(temp) + 10001) + "";
			id = entity.getMain_id() + "-" + temp.substring(1, temp.length());
		}
		rs.close();
		st.close();
		return id;
	}
	
	public static LaborTime insert(LaborTime entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		
		if (entity.getLabor_en().length() == 0) {
			entity.setLabor_en(entity.getLabor_th());
		}
		
		entity.setLabor_id(genId(entity, conn));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		
		conn.close();
		return entity;
	}
	
	public static void update(LaborTime entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}

	
	public static List<LaborTime> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "select * from  sv_labor_time_cate  Inner Join sv_labor_time_main  on sv_labor_time_cate.cate_id = sv_labor_time_main.cate_id  Inner Join sv_labor_time_guide on sv_labor_time_main.main_id = sv_labor_time_guide.main_id ";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("search")) {
					sql += " AND (sv_labor_time_guide.labor_th like'%" + str[1] + "%' " +
						   " OR sv_labor_time_guide.labor_en like'%" + str[1] + "%')";				
				}
				if (str[0].equalsIgnoreCase("cate_id")) {
					sql += "AND sv_labor_time_main.cate_id  = '" + str[1] + "'";			
				}
				
				if (str[0].equalsIgnoreCase("main_id")) {
					sql += " AND sv_labor_time_main.main_id = '" + str[1]+ "' ";		
				}

			}
		}		
		//sql += " ORDER BY (id*1) desc";
		//System.out.print(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<LaborTime> list = new ArrayList<LaborTime>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					LaborTime entity = new LaborTime();
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
	
	public String getMain_id() {
		return main_id;
	}

	public void setMain_id(String main_id) {
		this.main_id = main_id;
	}

	public String getLabor_id() {
		return labor_id;
	}

	public void setLabor_id(String labor_id) {
		this.labor_id = labor_id;
	}

	public String getLabor_th() {
		return labor_th;
	}

	public void setLabor_th(String labor_th) {
		this.labor_th = labor_th;
	}

	public String getLabor_en() {
		return labor_en;
	}

	public void setLabor_en(String labor_en) {
		this.labor_en = labor_en;
	}

	public String getLabor_hour() {
		return labor_hour;
	}

	public void setLabor_hour(String labor_hour) {
		this.labor_hour = labor_hour;
	}

	public String getCreate_by() {
		return create_by;
	}

	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}

	public String getUpdate_by() {
		return update_by;
	}

	public void setUpdate_by(String update_by) {
		this.update_by = update_by;
	}

	public Timestamp getCreate_date() {
		return create_date;
	}

	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}

	public Timestamp getUpdate_date() {
		return update_date;
	}

	public void setUpdate_date(Timestamp update_date) {
		this.update_date = update_date;
	}
	
	
}
