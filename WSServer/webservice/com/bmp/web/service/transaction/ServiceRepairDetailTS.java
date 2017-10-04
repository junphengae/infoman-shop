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
import com.bitmap.webutils.WebUtils;
import com.bmp.web.service.bean.setServiceRepairDetailBean;
import com.bmp.web.service.client.bean.getServiceRepairDetailBean;

public class ServiceRepairDetailTS {
	
	public static String tableName = "service_repair_detail";
	public static String[] keys = {"id","number"};
	public static String[] fieldNames = {"id","number","labor_id","labor_name","labor_qty","labor_rate","discount","discount_flag","note"
										,"due_date","create_by","create_date","update_by","update_date","branch_code","srd_net_price","srd_dis_total","vat","total_vat","srd_dis_total_before"};
	
	public static String STATUS_OPENED = "10";
	public static String STATUS_CLOSED = "11";
	public static String STATUS_CANCEL = "00";
	
	public static void main(String[] arg) throws Exception{
		
	//	ServiceRepairDetailTS.getServiceRepairDetailUpdate(new Date());
	}
	public static List<getServiceRepairDetailBean> getServiceRepairDetailUpdate(Connection conn,Date dd) throws Exception {
		
		List<getServiceRepairDetailBean> list = new ArrayList<getServiceRepairDetailBean>();
		//Connection conn =null;
		try{
			
			String time = "01/01/0001" ;
			String dd2 = WebUtils.getDateValue(dd);
			String sql = "SELECT * FROM "+tableName+ " WHERE 1=1 " ;
			if (!time.equalsIgnoreCase(dd2)) {
			 
			 sql+=" AND update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			}
			
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while(rs.next()){
				
				getServiceRepairDetailBean entity = new getServiceRepairDetailBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			
			st.close();
			rs.close();
			
		}catch (Exception e) {
			conn.rollback();
			conn.close();
			throw new Exception("ServiceRepairDetailTSException:" + e.getMessage());
		}
		
		
		return list;
		
	}	
	
	public  static boolean check(String id ,String number) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		setServiceRepairDetailBean entity = new setServiceRepairDetailBean();
		entity.setId(id);
		entity.setNumber(number);
		return check(entity);
	}
	public  static boolean check(setServiceRepairDetailBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}

}
