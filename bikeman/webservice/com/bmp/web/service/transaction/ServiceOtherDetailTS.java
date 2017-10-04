package com.bmp.web.service.transaction;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.WebUtils;
import com.bmp.web.service.client.bean.getServiceOtherDetailBean;

public class ServiceOtherDetailTS {
	
	public static String tableName = "service_other_detail";
	public static String[] keys = {"id","number"};
	public static String[] fieldNames = {"id","number","other_name","other_qty","other_price","discount","discount_flag","note","create_by","create_date","update_by","update_date","branch_code","sod_net_price","sod_dis_total"};
	
	public static String STATUS_OPENED = "10";
	public static String STATUS_CLOSED = "11";
	public static String STATUS_CANCEL = "00";
	
	public static void main(String[] arg) throws Exception {
		
		//ServiceOtherDetailTS.getServiceOtherDetailUpdate(new Date());
	
	}
public static List<getServiceOtherDetailBean> getServiceOtherDetailUpdate(Connection conn,Date dd) throws Exception {
		
		List<getServiceOtherDetailBean> list = new ArrayList<getServiceOtherDetailBean>();
		
		try{
			
			String time = "01/01/0001" ;
			String dd2 = WebUtils.getDateValue(dd);
			String sql = "SELECT * FROM "+tableName+ " WHERE 1=1 " ;
			if (!time.equalsIgnoreCase(dd2)) {
			 sql+=" AND update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			}
			//System.out.println("sql ServiceOtherDetail="+sql);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while(rs.next()){
				getServiceOtherDetailBean entity = new getServiceOtherDetailBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			st.close();
			rs.close();
			
		}catch (Exception e) {
			conn.rollback();
			conn.close();
			throw new Exception("ServiceOtherDetailTSException:"+e.getMessage());
			
		}
		
		return list;
	
		
	}

}
