package com.bmp.report.web.service;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;

public class WebServiceReportTS {
	public static String tableName = "ws_report"; 
	public static String[] keys = {"branch_id","table_sh"};
	public static String[] fieldNames = {"table_dc","count_sh","count_dc","sync_date"};
	
	public static List<WebServiceReportBean> ReportListWebService(List<String[]> paramsList) throws Exception {
		List<WebServiceReportBean> list = new ArrayList<WebServiceReportBean>();
		Connection conn = DBPool.getConnection();
		
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1  " ; 
		
		Iterator<String[]> ite = paramsList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("branch_id")){
					sql +=" AND branch_id ='"+str[1]+"' " ;
				}
			}
		}
		sql += " ORDER BY branch_id DESC";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		while (rs.next()) {
			WebServiceReportBean entity = new WebServiceReportBean();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;		
	}

}
