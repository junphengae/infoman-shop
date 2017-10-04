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
import com.bmp.web.service.bean.setServiceSaleBean;
import com.bmp.web.service.client.bean.getServiceSaleBean;

public class ServiceSaleTS {
	
	public static String tableName = "service_sale"; 
	public static String[] keys = {"id"};
	public static String[] fieldNames = {"id","service_type","cus_id","cus_name","cus_surname","cus_surname","addressnumber",
	"villege","district","prefecture","province","postalcode","phonenumber","moo","road","soi","v_id","v_plate","v_plate_province"
	,"total","vat","discount","total_amount","received","total_change","pay","status","flag_pay","duedate","create_by","update_by","create_date",
	"update_date","brand_id","model_id","job_close_date","tax_id","flage","bill_id","branch_code","forewordname"};
	
	
	public static void main() throws Exception {
		
		//ServiceSaleTS.getServiceSaleUpdate(new Date());
	}
	public static List<getServiceSaleBean> getServiceSaleUpdate(Connection conn,Date dd) throws Exception {
		
		List<getServiceSaleBean> list = new ArrayList<getServiceSaleBean>();
		//Connection conn= null;
		
		try{
			String time = "01/01/0001" ;
			String dd2 = WebUtils.getDateValue(dd);
			String sql = "SELECT * FROM "+tableName+ " WHERE 1=1 " ;
			if (!time.equalsIgnoreCase(dd2)) {
			 
			 sql+=" AND update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			}
			
			//System.out.println("sql service sale ="+sql);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				
				getServiceSaleBean entity = new getServiceSaleBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			
			rs.close();
			st.close();
			
		}catch (Exception e) {
			conn.rollback();
			conn.close();
			throw new Exception("ServiceSaleTSException: " + e.getMessage());
		}
		
		return list;
		
	}
	
	public  static boolean check(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		setServiceSaleBean entity = new setServiceSaleBean();
		entity.setId(id);
		return check(entity);
	}
	public  static boolean check(setServiceSaleBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}

	

}
