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
import com.bmp.date.time.format.DateTimeFormat;
import com.bmp.web.service.bean.getPartMasterBean;

public class PartMasterTS {
	public static String tableName = "pa_part_master";
	public static String[] keys = {"pn"};	
	public static String[] fieldNames = {"group_id","des_unit","cat_id","sub_cat_id","fit_to","description","sn_flag","moq","mor","weight","location","price","price_unit","cost","cost_unit","update_date","update_by","reference"};


	public static void main(String[] arg) throws Exception{
		//PartMasterTS.getMasterUpdate(new Date());
	}
	
	public static List<getPartMasterBean> getMasterUpdate(Date dd) throws Exception{
		
		List<getPartMasterBean> list = new ArrayList<getPartMasterBean>();
		
		Connection conn = null;
		try {
			
			String time = "01/01/0001" ;
			String dd2 = WebUtils.getDateValue(dd);
			String sql = "SELECT * FROM "+tableName+ " WHERE 1=1 " ;
			if (!time.equalsIgnoreCase(dd2)) {
			 sql+=" AND update_date > '" + DateTimeFormat.DATETIME_FORMAT_EN.format(dd) + " '";
			}else{
				sql+=" AND 1=1" ;
			}
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

}
