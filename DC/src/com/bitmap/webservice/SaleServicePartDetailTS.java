package com.bitmap.webservice;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.WebUtils;

public class SaleServicePartDetailTS {
	
	public static String tableName = "sale_order_service_part_detail";
	
	public static void main(String[] arg) throws Exception{
		
		SaleServicePartDetailTS.getSaleServicePartDetailUpdate(new Date());
	}

	public static List<SaleServicePartDetailBean> getSaleServicePartDetailUpdate(Date dd) throws Exception {
		

		List<SaleServicePartDetailBean> list = new ArrayList<SaleServicePartDetailBean>();
		
		Connection conn = null;
		
		try{
			
			String time = "01/01/0001" ;
			String dd2 = WebUtils.getDateValue(dd);
			String sql = "SELECT * FROM "+tableName+ " WHERE 1=1 " ;
			if (!time.equalsIgnoreCase(dd2)) {
			 
			 sql+=" AND update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			}else{
				sql+=" AND 1=1" ;
			}
			conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				SaleServicePartDetailBean entity = new SaleServicePartDetailBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			
			rs.close();
			st.close();
			
		}catch (Exception e) {
			throw new Exception("SaleServicePartDetailTSException: " + e.getMessage());
		}finally {
			if (conn != null) {
				conn.close();
			}
		}
		
		return list;
	
		
	}
	
}
