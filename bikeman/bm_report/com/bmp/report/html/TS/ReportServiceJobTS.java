package com.bmp.report.html.TS;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bmp.report.html.bean.ServiceOtherDetailBean;
import com.bmp.report.html.bean.ServicePartDetailAllBean;
import com.bmp.report.html.bean.ServiceRepairDetailBean;
import com.bmp.report.html.bean.ServiceSumBean;

public class ReportServiceJobTS {
	
	private static final String table_service_sale 			= "service_sale";
	private static final String table_service_repair 		= "service_repair";
	private static final String table_service_repair_detail = "service_repair_detail";
	private static final String table_service_other_detail 	= "service_other_detail";
	private static final String table_service_part_detail 	= "service_part_detail";
	private static final String table_brand 				= "mk_brands";
	private static final String table_model 				= "mk_models";
	private static final String table_pa_part_master 		= "pa_part_master";
	

	/***  new 2557-03-12
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public static List<ServiceSumBean> ListServiceSum(List<String[]> params) throws Exception{
		Connection conn = DBPool.getConnection();
		List<ServiceSumBean>  list = new ArrayList<ServiceSumBean>();
		
		String WHERE = "";
		String start_date = "";
		String end_date = "";
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("date")){
					WHERE +=" AND DATE_FORMAT(SS.job_close_date,'%d-%m-%Y')  = '"+str[1].trim() +"'  ";						
				}else
				if (str[0].equalsIgnoreCase("report_job_startdate")){
					start_date = str[1];
				}else if (str[0].equalsIgnoreCase("report_job_enddate")){
					end_date = str[1];
				}else if (str[0].equalsIgnoreCase("report_job_month")){
					WHERE +=" AND MONTH(SS.job_close_date)  = '"+str[1] +"'  ";
				}else if (str[0].equalsIgnoreCase("report_job_month_year")){
					WHERE +=" AND YEAR(SS.job_close_date)  = '"+str[1] +"'  ";
				}else if (str[0].equalsIgnoreCase("report_job_year")){
					WHERE +=" AND YEAR(SS.job_close_date)  = '"+str[1] +"'  ";
				}else if (str[0].equalsIgnoreCase("report_job_id")){
					WHERE +=" AND SS.id =  '"+str[1] +"' ";
				}else if (str[0].equalsIgnoreCase("report_job_status")){
					WHERE +=" AND SS.status =  '"+str[1] +"' ";
				}else if (str[0].equalsIgnoreCase("repair_type")){
					WHERE +=" AND SR.repair_type =  '"+str[1] +"' ";
				}
			}
		}
		
		
		if(start_date.length()>0 &&  end_date.length()>0){
			String start_end_date[] = null;
			start_end_date = start_date.split("-");
			start_date = start_end_date[2]+"-"+start_end_date[1]+"-"+start_end_date[0];
			start_end_date = end_date.split("-");
			end_date = start_end_date[2]+"-"+start_end_date[1]+"-"+start_end_date[0];
			
			WHERE +=" AND DATE(SS.job_close_date) BETWEEN  '"+start_date +"' AND  '"+end_date+"'  ";
		}						
		String query = "";
		query += "SELECT ";
		query += "		DATE_FORMAT(SS.job_close_date,'%d/%m/%Y') AS  job_close_date, ";
		query += "		DATE_FORMAT(SS.job_close_date,'%H:%i') AS time_job_close,    ";
		query += "		SS.id  AS job_id,  ";
		query += "		SS.forewordname AS prefix,   ";
		query += "		SS.cus_name AS name,  ";
		query += "		SS.cus_surname AS surname ";		
		query += " FROM service_sale                 AS SS  ";
		query += " INNER JOIN service_repair         AS SR ON SR.id = SS.id ";		
		query += " WHERE 1=1 ";
		query += WHERE;
		query += " GROUP BY DATE_FORMAT(SS.job_close_date,'%d:%m:%Y') ,DATE_FORMAT(SS.job_close_date,'%H:%i') ";
		query += " ORDER BY DATE_FORMAT(SS.job_close_date,'%d:%m:%Y')  ASC ,DATE_FORMAT(SS.job_close_date,'%H:%i') ASC";
		
		
		System.out.println("SQL : "+query);
	   
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(query);
		try{
			while(rs.next()){
				ServiceSumBean bean = new ServiceSumBean();
				DBUtility.bindResultSet(bean, rs);
				list.add(bean);	
			}
		}catch (Exception e) {
			throw new Exception( e.getMessage() );
		}finally{
			rs.close();
			st.close();
			conn.close();
		}
		return list;
	}

	public static  List<ServicePartDetailAllBean> ListServicePartDetail(String job_id) throws SQLException {
		Connection conn = null;
		List< ServicePartDetailAllBean > list = new ArrayList<ServicePartDetailAllBean>();
		try {
			conn = DBPool.getConnection();
			String 	sql  = " SELECT * FROM "+table_service_part_detail+" WHERE id = '"+job_id+"' ORDER BY number ASC ";
			System.out.println("SQL : "+sql);		
			
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				ServicePartDetailAllBean entity = new ServicePartDetailAllBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);				
			}
		conn.close();	
		} catch (Exception e) {
			if (conn != null) {
				conn.close();
			}
		}
		
		return list;
		
	}
	
	public static  List<ServiceOtherDetailBean> ListServiceOtherDetail(String job_id) throws SQLException {
		Connection conn = null;
		List< ServiceOtherDetailBean > list = new ArrayList<ServiceOtherDetailBean>();
		try {
			conn = DBPool.getConnection();
			String 	sql  = " SELECT * FROM "+table_service_other_detail+" WHERE id = '"+job_id+"' ORDER BY number ASC ";
			System.out.println("SQL : "+sql);		
			
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				ServiceOtherDetailBean entity = new ServiceOtherDetailBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);				
			}
		conn.close();	
		} catch (Exception e) {
			if (conn != null) {
				conn.close();
			}
		}
		
		return list;
		
	}
	
	public static  List<ServiceRepairDetailBean> ListServiceRepairDetail(String job_id) throws SQLException {
		Connection conn = null;
		List< ServiceRepairDetailBean > list = new ArrayList<ServiceRepairDetailBean>();
		try {
			conn = DBPool.getConnection();
			String 	sql  = " SELECT * FROM "+table_service_repair_detail+" WHERE id = '"+job_id+"' ORDER BY number ASC ";
			System.out.println("SQL : "+sql);		
			
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				ServiceRepairDetailBean entity = new ServiceRepairDetailBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);				
			}
		conn.close();	
		} catch (Exception e) {
			if (conn != null) {
				conn.close();
			}
		}
		
		return list;
		
	}
	
	
}
