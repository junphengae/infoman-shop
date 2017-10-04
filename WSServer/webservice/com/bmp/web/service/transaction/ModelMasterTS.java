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
import com.bmp.web.service.bean.getModelMasterBean;


public class ModelMasterTS {
	
	public static String tableName = "mk_models";
	public static String[] keys = {"id"};//primary keys
	public static String[] fieldNames = {"id", "model_id", "model_name", "brand_id", "create_by", "create_date", "update_by", "update_date"};
	
	
	public static void main(String[] arg) throws Exception{
		ModelMasterTS.getModelUpdate(new Date());
	}
	public static List<getModelMasterBean> getModelUpdate(Date dd) throws Exception{
		
		List<getModelMasterBean> list = new ArrayList<getModelMasterBean>();
		
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
				getModelMasterBean entity = new getModelMasterBean();
				DBUtility.bindResultSet(entity, rs);				
				list.add(entity);
			}
			
			rs.close();
			st.close();
			
		}catch (Exception e) {
			throw new Exception("ModelMasterTSException: " + e.getMessage());
		}finally{
			if (conn != null) {
				conn.close();
			}
		}
		return list;
	}
	
}
