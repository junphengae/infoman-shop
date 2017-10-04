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

import com.bitmap.bean.branch.BranchMaster;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;
import com.bmp.sale.bean.SaleOderServiceBean;

public class SaleOderServiceTS {
	public static String tableName = "sale_order_service"; 
	public static String[] keys = {"id"};
	public static String[] fieldNames = {"id","service_type","cus_id","cus_name","cus_surname","v_id","v_plate","v_plate_province","status","flag_pay","duedate","create_by","create_date","update_by","update_date","job_close_date","vehicle_plate","brand_id","model_id","time_complete","note","discount","discount_pc","gross_amount","net_amount","vat","vat_amount","grand_total"};
	
	public static SaleOderServiceBean selectById(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		SaleOderServiceBean entity = new SaleOderServiceBean();
		entity.setId(id);
		
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIOrderList(SaleOderServicePartDetailTS.selectListByID(id, conn));
		conn.close();
		return entity;
	}

	
	public static List<SaleOderServiceBean> selectWithCTSaleOrder(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
		String sql = "SELECT * FROM " + tableName + " WHERE status !='100' ";
		
		String m = "";
		String y = "";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if(str[0].equalsIgnoreCase("cus_id")){
					sql += "AND cus_id = '"+str[1] +"' " ;
				}else
				if (str[0].equalsIgnoreCase("year")){
					y = str[1];
				} else 
				if (str[0].equalsIgnoreCase("month")) {
					m = str[1];
				} else {
					sql += " AND " + str[0] + "='" + str[1] + "'";
				}
			}
		}
		
		if (m.length() > 0 && y.length() > 0) {
			/*Calendar sd = Calendar.getInstance();
			sd.clear();
			sd.set(Calendar.YEAR, Integer.parseInt(y));
			sd.set(Calendar.MONTH, Integer.parseInt(m) - 1);
			sd.set(Calendar.DATE, 1);
			
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			
			String s = df.format(sd.getTime());
			
			sd.add(Calendar.MONTH, +1);
			sd.add(Calendar.DATE, -1);
			String e = df.format(sd.getTime());
			
			sql += " AND (duedate between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99')";*/
			sql += " AND MONTH(duedate) = '"+m+"' ";
			sql += " AND YEAR(duedate) = '"+y+"' ";
			
		} else {
			
			if (y.length() > 0) {
				sql += " AND YEAR(duedate) = '"+y+"' ";
				
			}else{
				sql += " AND 1 = 1";
				
			}
			
		}
		
		//sql += " ORDER BY (id*1) DESC ,cus_id ASC ";
		sql += " ORDER BY id DESC , duedate DESC, cus_id ASC";
		//System.out.println("qq="+sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOderServiceBean> list = new ArrayList<SaleOderServiceBean>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					SaleOderServiceBean entity = new SaleOderServiceBean();
					DBUtility.bindResultSet(entity, rs);
					
					Map map = new HashMap();
					map.put(BranchMaster.tableName, BranchMaster.selectBranchCode(entity.getCus_id(), conn));
					entity.setUImap(map);
					
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
}
