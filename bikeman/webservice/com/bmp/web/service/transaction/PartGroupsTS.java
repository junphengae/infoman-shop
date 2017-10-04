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
import com.bmp.web.service.bean.setPartGroupsBean;
import com.bmp.web.service.client.bean.getPartGroupsBean;

public class PartGroupsTS {
	
	public static String tableName = "pa_groups";
	public static String[] keys = {"group_id"};
	public static String[] fieldNames = {"group_id", "group_name_en", "group_name_th", "create_by", "create_date"};
	
		public static void main(String[] arg) throws Exception{
			
			PartGroupsTS.getPartGroupsUpdate(new Date());
		}
		public static List<getPartGroupsBean> getPartGroupsUpdate(Date dd) throws Exception {


			List<getPartGroupsBean> list = new ArrayList<getPartGroupsBean>();
			
			Connection conn = null;
			
			try{
				
				String sql = "SELECT * FROM "+tableName+" WHERE update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
				
				conn = DBPool.getConnection();
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery(sql);
				while (rs.next()) {
					getPartGroupsBean entity = new getPartGroupsBean();
					DBUtility.bindResultSet(entity, rs);
					list.add(entity);
				}
				
				rs.close();
				st.close();
				
			}catch (Exception e) {
				throw new Exception("PartGroupsTSException: " + e.getMessage());
			}finally {
				
				if (conn != null) {
					conn.close();
				}
			}
			
			return list;
			
		}

		
		public  static boolean check(String group_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
			setPartGroupsBean entity = new setPartGroupsBean();
			entity.setGroup_id(group_id);
			return check(entity);
		}
		public  static boolean check(setPartGroupsBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
			Connection conn = DBPool.getConnection();
			boolean check = false;
			check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
			conn.close();
			return check;
		}
		
		
		
}
