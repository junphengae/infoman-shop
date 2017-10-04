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
import com.bmp.web.service.bean.getPartCategoriesSubBean;

public class PartCategoriesSubTS {
	
	public static String tableName = "pa_categories_sub";
	public static String[] keys = {"sub_cat_id"};
	public static String[] fieldNames = { "sub_cat_id","cat_id", "group_id", "sub_cat_name_short", "sub_cat_name_th", "create_by", "create_date"};
		

	public static void main(String[] arg) throws Exception{
		
		PartCategoriesSubTS.getPartCategoriesSubUpdate(new Date());
	}
	public static List<getPartCategoriesSubBean> getPartCategoriesSubUpdate(Date dd) throws Exception {
		List<getPartCategoriesSubBean> list = new ArrayList<getPartCategoriesSubBean>();
		
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
				getPartCategoriesSubBean entity = new getPartCategoriesSubBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			
			rs.close();
			st.close();
			
		}catch (Exception e) {
			throw new Exception("PartCategoriesSubTSException: " + e.getMessage());
		}finally {
			
			if (conn != null) {
				conn.close();
			}
		}
		return list;
	}
	
}
