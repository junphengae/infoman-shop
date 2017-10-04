package com.bitmap.webservice;

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

public class PartMasterTS {
	public static String tableName = "pa_part_master";
	
	public static void main(String[] arg) throws Exception{
		PartMasterTS.getMasterUpdate(new Date());
	}
	
	public static List<PartMasterBean> getMasterUpdate(Date dd) throws Exception{
		List<PartMasterBean> list = new ArrayList<PartMasterBean>();
		
		Connection conn = null;
		
		try {
			String sql = "SELECT * FROM " + tableName + " WHERE update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			
			conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				PartMasterBean entity = new PartMasterBean();
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
	
	public static List<PartMasterBean> select(List<String[]> paramsList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
		List<PartMasterBean> list = new ArrayList<PartMasterBean>();
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
			PartMasterBean entity = new PartMasterBean();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	
	
}
