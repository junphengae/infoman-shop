package com.bitmap.webservice;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;

public class PartBorrowTS {
	
	public static String tableName = "pa_borrow_part";
	public static void main(String[] arg) throws Exception{
		
		PartBorrowTS.getPartBorrowUpdate(new Date());
	}
	public static List<PartBorrowBean> getPartBorrowUpdate(Date dd) throws Exception {

		List<PartBorrowBean> list = new ArrayList<PartBorrowBean>();
		
		Connection conn = null;
		
		try{
			
			String sql = "SELECT * FROM "+tableName+" WHERE update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			
			conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				PartBorrowBean entity = new PartBorrowBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			
			rs.close();
			st.close();
			
		}catch (Exception e) {
			throw new Exception("PartBorrowTSException: " + e.getMessage());
		}finally {
			
			if (conn != null) {
				conn.close();
			}
		}
		
		return list;
		
		
	}

}
