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
import com.bmp.web.service.bean.setServicePartDetailBean;
import com.bmp.web.service.client.bean.getServicePartDetailBean;

public class ServicePartDetailTS {
	
	public static String tableName = "service_part_detail";
	public static String[] keys = {"id","number"};
	public static String[] fieldNames = {"id","number","pn","qty","discount","discount_flag","cutoff_qty","price","create_by"
										,"create_date","update_by","update_date","branch_code","spd_net_price","spd_dis_total","vat","total_vat","total_price","spd_dis_total_before"};
	
	
	public static void main(String[] arg) throws Exception{
		
		//ServicePartDetailTS.getServicePartDetailUpdate(new Date());
		
	}
	public static List<getServicePartDetailBean> getServicePartDetailUpdate(Connection conn,Date dd) throws Exception{
		
		List<getServicePartDetailBean> list = new ArrayList<getServicePartDetailBean>();
		//Connection  conn =null;
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
				
				getServicePartDetailBean entity = new getServicePartDetailBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);	
			}
			
			st.close();
			rs.close();
			
		}catch (Exception e) {
			conn.rollback();
			conn.close();
			throw new Exception("ServicePartDetailTSException:"+e.getMessage());
		}
		
		return list;
		
	}
	
	public  static boolean check(String id ,String number) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		setServicePartDetailBean entity = new setServicePartDetailBean();
		entity.setId(id);
		entity.setNumber(number);
		return check(entity);
	}
	public  static boolean check(setServicePartDetailBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}
	
}
