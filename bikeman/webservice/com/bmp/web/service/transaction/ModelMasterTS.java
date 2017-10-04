package com.bmp.web.service.transaction;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bmp.web.service.bean.setModelMasterBean;
import com.bmp.web.service.client.bean.getModelMasterBean;


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
			
			String sql = "SELECT * FROM "+tableName+" WHERE update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			
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
	
	public  static boolean check(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		setModelMasterBean entity = new setModelMasterBean();
		entity.setId(id);
		return check(entity);
	}
	public  static boolean check(setModelMasterBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}
	
	

}
