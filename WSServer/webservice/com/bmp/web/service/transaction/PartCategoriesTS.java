package com.bmp.web.service.transaction;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.WebUtils;
import com.bmp.web.service.bean.getPartCategoriesBean;

public class PartCategoriesTS {
		
	public static String tableName = "pa_categories";
	public static String[] keys = {"cat_id"};
	public static String[] fieldNames = {"cat_id", "group_id", "cat_name_short", "cat_name_th", "create_by", "create_date"};

	public static void main(String[] arg) throws Exception{
		
		PartCategoriesTS.getPartCategoriesUpdate(new Date());
	}
	public static List<getPartCategoriesBean> getPartCategoriesUpdate(Date dd) throws Exception {
		
		List<getPartCategoriesBean> list = new ArrayList<getPartCategoriesBean>();
		
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
				getPartCategoriesBean entity = new getPartCategoriesBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			
			rs.close();
			st.close();
			
		}catch (Exception e) {
			throw new Exception("PartCategoriesTSException: " + e.getMessage());
		}finally {			
			if (conn != null) {
				conn.close();
			}
		}	
		return list;		
	}
	

}
