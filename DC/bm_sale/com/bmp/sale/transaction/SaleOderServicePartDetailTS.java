package com.bmp.sale.transaction;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.bitmap.bean.dc.SaleServicePartDetail;
import com.bitmap.bean.parts.PartMaster;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bmp.sale.bean.SaleOderServicePartDetailBean;

public class SaleOderServicePartDetailTS {
	public static String tableName = "sale_order_service_part_detail"; 
	public static String[] keys = {"id"};
	public static String[] fieldNames = {"status","branch_code","number","id","pn","price","note","update_by","qty","discount_flag","discount","cutoff_qty","create_by","update_date","create_date","add_pr_date"};
	

	public static List<SaleOderServicePartDetailBean> selectListByID(String id, Connection conn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE id='" + id + "' ORDER BY (number*1) ASC";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOderServicePartDetailBean> list = new ArrayList<SaleOderServicePartDetailBean>();
		while (rs.next()) {
			SaleOderServicePartDetailBean entity = new SaleOderServicePartDetailBean();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIPartMaster(PartMaster.select(entity.getPn(), conn));
			
			list.add(entity);
		}
		
		rs.close();
		st.close();
		return list;
	}
	
	
	
	public static List<SaleOderServicePartDetailBean> selectList(List<String[]> paramsList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
		List<SaleOderServicePartDetailBean> list = new ArrayList<SaleOderServicePartDetailBean>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE  status !='00' ";
		
		Iterator<String[]> ite = paramsList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
					if(str[0].equalsIgnoreCase("1")){
						
						sql += " AND " + " id " + "='" + str[1] + "'  AND number = '"+ str[2] + "'  AND  pn = '"+ str[3] + "'";
						
					}else{
						sql += " AND " + str[0] + "='" + str[1] + "' ";
					}
					
				
			}
		}
		
		sql += " ORDER BY add_pr_date ASC";
		
		//System.out.println("SaleServicePartDetail_selectList::"+sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			SaleOderServicePartDetailBean entity = new SaleOderServicePartDetailBean();
			DBUtility.bindResultSet(entity, rs);
			Map map = new HashMap();
			map.put(PartMaster.tableName, PartMaster.select(entity.getPn(), conn));
			entity.setUImap(map);
			
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}

}
