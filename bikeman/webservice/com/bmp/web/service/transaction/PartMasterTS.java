package com.bmp.web.service.transaction;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.WebUtils;
import com.bmp.web.service.bean.setPartMasterBean;
import com.bmp.web.service.client.bean.getPaPartMasterBean;
import com.bmp.web.service.client.bean.getPartMasterBean;

public class PartMasterTS {
	public static String tableName = "pa_part_master";
	public static String[] keys = {"pn"};	
	public static String[] fieldNames = {"group_id","des_unit","cat_id","sub_cat_id","fit_to","description","sn_flag","moq","mor","weight","location","ss_no","ss_flag","status","price","price_unit","cost","cost_unit","update_date","update_by","reference"};
	//public static String[] fieldNames_ws = {"group_id","cat_id","sub_cat_id","fit_to","description","sn_flag","moq","mor","weight","price","price_unit","cost","cost_unit","update_date","update_by"};
	

	
	public static void main(String[] arg) throws Exception{
		PartMasterTS.getMasterUpdate(new Date());
	}
	
	public static List<getPartMasterBean> getMasterUpdate(Date dd) throws Exception{
		List<getPartMasterBean> list = new ArrayList<getPartMasterBean>();
		
		Connection conn = null;
		
		try {
			String sql = "SELECT * FROM " + tableName + " WHERE update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			
			conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				getPartMasterBean entity = new getPartMasterBean();
				DBUtility.bindResultSet(entity, rs);
				
				list.add(entity);
			}
			
			rs.close();
			st.close();
			
		} catch (Exception e) {
			throw new Exception("PartMasterTSException: " + e.getMessage());
		} finally {
			if (conn != null) {
				conn.close();
			}
		}
		
		return list;
	}
	
	public static List<getPartMasterBean> select(List<String[]> paramsList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
		List<getPartMasterBean> list = new ArrayList<getPartMasterBean>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 ";
		
		Iterator<String[]> ite = paramsList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {

				
					
					sql += " AND " + str[0] + "='" + str[1] + "' ";
				
			}
		}
		
		sql += " ORDER BY (pn*1) desc";
		
		//System.out.println(sql);
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			getPartMasterBean entity = new getPartMasterBean();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	public static SimpleDateFormat DATETIME_FORMAT_EN = new SimpleDateFormat("yyyy-MM-dd ",Locale.ENGLISH);
	public static List<getPaPartMasterBean> getBranchStockUpdate(Connection conn,Date dd) throws Exception {
		
		List<getPaPartMasterBean> list = new ArrayList<getPaPartMasterBean>();
		
		try{
			
			String time = "01/01/0001" ;
			String dd2 = WebUtils.getDateValue(dd);
			String sql = "SELECT pn,qty,create_by,create_date,update_by,update_date FROM "+tableName+ " WHERE 1=1 " ;
			if (!time.equalsIgnoreCase(dd2)) {
			 sql+=" AND update_date > '" + DATETIME_FORMAT_EN.format(dd) + "'";
			}
			//System.out.println("sql branch="+sql);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while(rs.next()){
				getPaPartMasterBean entity = new getPaPartMasterBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			st.close();
			rs.close();
		}catch (Exception e) {
			conn.rollback();
			//conn.close();
			throw new Exception("BranchStockException:"+e.getMessage());
			
		}
		
		return list;

		
	}

	public  static boolean check(setPartMasterBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}	
	public  static boolean check(String pn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		setPartMasterBean entity = new setPartMasterBean();
		entity.setPn(pn);
		return check(entity);
	}
	
}
