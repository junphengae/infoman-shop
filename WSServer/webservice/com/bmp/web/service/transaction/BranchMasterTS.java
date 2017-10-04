package com.bmp.web.service.transaction;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.WebUtils;
import com.bmp.web.service.bean.getBranchMasterBean;

public class BranchMasterTS {
	
	public static String tableName = "branch_master";
	public static String[] keys = {"branch_id"};
	public static String[] fieldNames = {"branch_id","branch_code","branch_name", "branch_order","branch_name_en","create_by","update_by","create_date","update_date","branch_lane","branch_road"
										,"branch_addressnumber","branch_moo","branch_villege","branch_district","branch_prefecture","branch_province"
										,"branch_postalcode","branch_phonenumber","branch_fax"};
							
	
	
	public static void main(String[] arg) throws Exception{
		
		BranchMasterTS.getBranchUpdate(new Date());
	}
	
	public static List<getBranchMasterBean> getBranchUpdate(Date dd) throws Exception{
		
		List<getBranchMasterBean> list = new ArrayList<getBranchMasterBean>();
		
		Connection conn = null;
		
		try{
			
			String time = "01/01/0001" ;
			String dd2 = WebUtils.getDateValue(dd);
			String sql = "SELECT * FROM "+tableName+ " WHERE 1=1 " ;
			if (!time.equalsIgnoreCase(dd2)) {
			 
			 sql+=" AND update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			}
			
			conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				getBranchMasterBean entity = new getBranchMasterBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			
			rs.close();
			st.close();
			
		}catch (Exception e) {
			throw new Exception("BranchMasterTSException: " + e.getMessage());
			
		}finally {
			if (conn != null) {
				conn.close();
			}
		}
		
		return list;
		
	} 
	
	public static List<getBranchMasterBean> select(List<String[]> paramsList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
		List<getBranchMasterBean> list = new ArrayList<getBranchMasterBean>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 ";
		
		Iterator<String[]> ite = paramsList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {

				
					
					sql += " AND " + str[0] + "='" + str[1] + "' ";
				
			}
		}
		
		sql += " ORDER BY (branch_id*1) desc";
		
		//System.out.println(sql);
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			getBranchMasterBean entity = new getBranchMasterBean();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}

	
}
