package com.bmp.web.service.transaction;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.WebUtils;
import com.bmp.web.service.client.bean.getServiceRepairBean;

public class ServiceRepairTS {
	public static String tableName = "service_repair";
	public static String[] keys = {"id"};
	public static String[] fieldNames = {"repair_type","driven_by","driven_contact","fuel_level","mile","problem","note","due_date","update_by","update_date","flag"};
	public static String[] fieldName = {"id","repair_type","driven_by","driven_contact","fuel_level","mile","problem","note","due_date","create_by","create_date","update_by","update_date","flag"};
	
	public static String TYPE_WARRANTY = "10";
	public static String TYPE_REPAIR = "11";
	public static String TYPE_INSURANCE = "12";
	
	
	public static List<getServiceRepairBean> getServiceRepair(Connection conn,Date dd) throws Exception{
		
		List<getServiceRepairBean> list = new ArrayList<getServiceRepairBean>();
				
		try{
			
			String time = "01/01/0001" ;
			String dd2 = WebUtils.getDateValue(dd);
			String sql = "SELECT * FROM "+tableName+ " WHERE 1=1 " ;
			if (!time.equalsIgnoreCase(dd2)) {
			 
			 sql+=" AND update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			}
			
			
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				getServiceRepairBean entity = new getServiceRepairBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			
			rs.close();
			st.close();
			
			
		}catch (Exception e) {
			conn.rollback();
			conn.close();
			throw new Exception("ServiceRepairConditionTS: " + e.getMessage());
		}
		
		return list;
		
		
		
		
	} 
	
}
