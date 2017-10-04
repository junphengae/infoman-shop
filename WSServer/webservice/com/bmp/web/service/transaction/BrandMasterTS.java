package com.bmp.web.service.transaction;

import java.sql.Connection;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.WebUtils;
import com.bmp.web.service.bean.getBrandMasterBean;
import com.mysql.jdbc.Statement;

public class BrandMasterTS {
	
	public static String tableName = "mk_brands";
	public static String[] keys = {"order_by_id"};//primary keys 
	public static String[] fieldNames = {"order_by_id", "brand_id", "brand_name", "create_by", "create_date", "update_by", "update_date"};
	
	public static void main(String arg) throws Exception{
		BrandMasterTS.getBrandUpdate(new Date());
	}
	public static List<getBrandMasterBean> getBrandUpdate(Date dd) throws Exception{
		
		List<getBrandMasterBean> list = new ArrayList<getBrandMasterBean>();
		
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
			Statement st = (Statement) conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while(rs.next()){
				
				getBrandMasterBean entity = new getBrandMasterBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			rs.close();
			st.close();
			
			
		}catch (Exception e) {
			throw new Exception("BrandMasterTSException: " + e.getMessage());
		}finally{
			if (conn != null) {
				conn.close();
			}
		}
		
		return list;
		
	}

	
}
