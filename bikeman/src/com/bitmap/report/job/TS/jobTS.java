package com.bitmap.report.job.TS;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;


import com.bitmap.report.job.bean.serviceInfoBean;
import com.bitmap.report.job.bean.serviceMiscellaneousBean;
import com.bitmap.report.job.bean.servicePartBean;
import com.bitmap.report.job.bean.serviceServiceBean;

import com.bitmap.bean.parts.ServiceOtherDetail;
import com.bitmap.bean.parts.ServiceSale;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bmp.report.html.bean.ServiceOtherDetailBean;
import com.bmp.report.html.bean.ServiceRepairDetailBean;
import com.bmp.report.html.bean.servicePartDetailBean;

public class jobTS {
	private static final String table_service_sale = "service_sale";
	private static final String table_service_repair = "service_repair";
	private static final String table_service_repair_detail = "service_repair_detail";
	private static final String table_service_other_detail = "service_other_detail";
	private static final String table_service_part_detail = "service_part_detail";
	private static final String table_brand = "mk_brands";
	private static final String table_model = "mk_models";
	private static final String table_pa_part_master = "pa_part_master";
	
	// Min Year
	public static Integer checkMinYear() throws Exception{
		Connection conn = DBPool.getConnection();
		int min_year =  0;
		String query = "";
		query += "SELECT  ";
		query += "		YEAR(MIN(create_date)) AS min_year  ";
		query += "FROM "+table_service_sale+"   ";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(query);
		try{
			while(rs.next()){
				min_year = DBUtility.getInteger("min_year", rs);
				
			}
		}catch (Exception e) {
			throw new Exception( e.getMessage() );
		}finally{
			rs.close();
			st.close();
			conn.close();
		}
		return min_year;
	}
	
	
	// Service Sale
	@SuppressWarnings("finally")
	
	public static List<serviceInfoBean> list_serviceInfo(List<String[]> params) throws SQLException{
		Connection conn = DBPool.getConnection();
		Statement st = null;
		ResultSet rs = null;
		List<serviceInfoBean>  list = new ArrayList<serviceInfoBean>();

		String WHERE = "";
		String start_date = "";
		String end_date = "";
		String status  ="";
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("report_job_startdate")){
					start_date = str[1];
				}else if (str[0].equalsIgnoreCase("report_job_enddate")){
					end_date = str[1];
				}else if (str[0].equalsIgnoreCase("report_job_status")){
					WHERE +=" AND SS.status =  '"+str[1] +"' ";
					status = str[1];
				}else if (str[0].equalsIgnoreCase("report_job_month")){
					if (status.equalsIgnoreCase("12")) {
					WHERE +=" AND MONTH(SS.create_date)  = '"+str[1] +"'  ";	
					}else{
					WHERE +=" AND MONTH(SS.job_close_date)  = '"+str[1] +"'  ";
					}
				}else if (str[0].equalsIgnoreCase("report_job_month_year")){
				    if (status.equalsIgnoreCase("12")) {
					WHERE +=" AND YEAR(SS.create_date)  = '"+str[1] +"'  ";	
					}else{
					WHERE +=" AND YEAR(SS.job_close_date)  = '"+str[1] +"'  ";
					}
				}else if (str[0].equalsIgnoreCase("report_job_year")){
				    if (status.equalsIgnoreCase("12")) {
					WHERE +=" AND YEAR(SS.create_date)  = '"+str[1] +"'  ";	
					}else{
					WHERE +=" AND YEAR(SS.job_close_date)  = '"+str[1] +"'  ";
					}
				}else if (str[0].equalsIgnoreCase("report_job_id")){
					WHERE +=" AND SS.id =  '"+str[1] +"' ";
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
			
			if (status.equalsIgnoreCase("12")) {
				WHERE +=" AND DATE_FORMAT(SS.create_date,'%Y-%m-%d') BETWEEN  '"+start_date +"' AND  '"+end_date+"'  ";
			}else {
				WHERE +=" AND DATE_FORMAT(SS.job_close_date,'%Y-%m-%d') BETWEEN  '"+start_date +"' AND  '"+end_date+"'  ";
			}
		}
		
		
		String query = "";
		query += "SELECT ";
		query += "  	SS.id AS job_id, ";
		query += "  	SS.cus_name AS name,  ";
		query += " 	    SS.cus_surname AS surname, ";
		query += "  	SS.v_plate AS plate, ";
		query += "  	SS.v_plate_province AS plate_province, ";
		query += "  	SS.status AS status, ";
		query += "  	SS.create_by AS  create_by,  " ;
		query += "  	SS.job_close_date AS job_close_datetime , ";
		query += "  	SS.create_date AS create_date_time , ";
		query += "  	DATE_FORMAT(SS.create_date, '%Y-%m-%d') AS create_date, ";
		query += "  	DATE_FORMAT(SS.job_close_date, '%Y-%m-%d') AS job_close,  ";
		query += "  	concat('', TIMESTAMPDIFF(MINUTE, SS.create_date, SS.job_close_date  )) as time_complete,  ";
		query += "  	SS.total_amount AS total_amount, ";
		query += "  	SS.total As total, ";
		query += "  	SS.discount AS discount, ";
		query += "  	SS.pay AS pay,  " ;
		query += "  	BRAND.brand_name AS brand, ";
		query += "  	MODEL.model_name AS model  " ;
		query += " FROM "+table_service_sale+" AS SS  ";
		query += "	LEFT JOIN "+table_brand+" AS BRAND ON BRAND.brand_id = SS.brand_id ";
		query += " LEFT JOIN "+table_model+" AS MODEL ON MODEL.model_id = SS.model_id ";
		query += " LEFT JOIN "+table_service_repair+" AS SR ON SR.id = SS.id ";
		query += " WHERE 1 = 1 AND ";
		query += WHERE;
		query += " ORDER BY (SS.id *1) DESC ";
	
		//System.out.println("query::"+query);
		
		
		try{
			st = conn.createStatement();
			rs = st.executeQuery(query);
			while(rs.next()){
				serviceInfoBean service_bean = new serviceInfoBean();
				DBUtility.bindResultSet(service_bean, rs);
				list.add(service_bean);			
			}
		}catch (Exception e) {
			throw new Exception( e.getMessage() );
		}finally{
			rs.close();
			st.close();
			conn.close();
			return list;
		}
}
	@SuppressWarnings("finally")
	public static List<serviceInfoBean> list_serviceBillInfo(List<String[]> params) throws SQLException{
		Connection conn = DBPool.getConnection();
		Statement st = null;
		ResultSet rs = null;
		List<serviceInfoBean>  list = new ArrayList<serviceInfoBean>();

		String WHERE = "";
		String start_date = "";
		String end_date = "";
		String status  ="";
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("report_job_startdate")){
					start_date = str[1];
				}else if (str[0].equalsIgnoreCase("report_job_enddate")){
					end_date = str[1];
				}else if (str[0].equalsIgnoreCase("report_job_status")){
					WHERE +=" AND SS.status =  '"+str[1] +"' ";
					status = str[1];
				}else 
					if (str[0].equalsIgnoreCase("date")){						
						if (status.equalsIgnoreCase("12")) {		
							WHERE +=" AND DATE_FORMAT(SS.create_date,'%d-%m-%Y')  = '"+str[1].trim() +"'  ";	
						}else {							
							WHERE +=" AND DATE_FORMAT(SS.job_close_date,'%d-%m-%Y')  = '"+str[1].trim() +"'  ";	
						}
				}else
					if (str[0].equalsIgnoreCase("report_job_month")){
						if (status.equalsIgnoreCase("12")) {
						WHERE +=" AND MONTH(SS.create_date)  = '"+str[1] +"'  ";	
						}else{
						WHERE +=" AND MONTH(SS.job_close_date)  = '"+str[1] +"'  ";
						}
				}else 
					if (str[0].equalsIgnoreCase("report_job_month_year")){
				    if (status.equalsIgnoreCase("12")) {
					WHERE +=" AND YEAR(SS.create_date)  = '"+str[1] +"'  ";	
					}else{
					WHERE +=" AND YEAR(SS.job_close_date)  = '"+str[1] +"'  ";
					}
				}else 
					if (str[0].equalsIgnoreCase("report_job_year")){
				    if (status.equalsIgnoreCase("12")) {
					WHERE +=" AND YEAR(SS.create_date)  = '"+str[1] +"'  ";	
					}else{
					WHERE +=" AND YEAR(SS.job_close_date)  = '"+str[1] +"'  ";
					}
				}else if (str[0].equalsIgnoreCase("report_job_id")){
					WHERE +=" AND SS.id =  '"+str[1] +"' ";
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
			
			if (status.equalsIgnoreCase("12")) {
				WHERE +=" AND DATE_FORMAT(SS.create_date,'%Y-%m-%d') BETWEEN  '"+start_date +"' AND  '"+end_date+"'  ";
			}else {
				WHERE +=" AND DATE_FORMAT(SS.job_close_date,'%Y-%m-%d') BETWEEN  '"+start_date +"' AND  '"+end_date+"'  ";
			}
		}
		
		
		String query = "";
		query += "SELECT ";
		query += "  	SS.id AS job_id, ";
		query += "  	SS.cus_name AS name,  ";
		query += " 	    SS.cus_surname AS surname, ";			
		query += "  	SS.status AS status, ";
		query += "  	SS.create_by AS  create_by,  " ;
		query += "  	SS.job_close_date AS job_close_datetime , ";
		query += "  	SS.create_date AS create_date_time , ";
		query += "  	DATE_FORMAT(SS.create_date, '%Y-%m-%d') AS create_date, ";
		query += "  	DATE_FORMAT(SS.job_close_date, '%Y-%m-%d') AS job_close,  ";		
		query += "  	SS.bill_id AS bill_id  " ;		
		query += " FROM "+table_service_sale+" AS SS  ";		
		query += " LEFT JOIN "+table_service_repair+" AS SR ON SR.id = SS.id ";
		query += " WHERE SS.bill_id IS NOT NULL AND SS.bill_id <> ''   ";
		query += WHERE;
		query += " ORDER BY (SS.id *1) , SS.bill_id";
	
		//System.out.println("query::"+query);
		
		
		try{
			st = conn.createStatement();
			rs = st.executeQuery(query);
			while(rs.next()){
				serviceInfoBean service_bean = new serviceInfoBean();
				DBUtility.bindResultSet(service_bean, rs);
				list.add(service_bean);			
			}
		}catch (Exception e) {
			throw new Exception( e.getMessage() );
		}finally{
			rs.close();
			st.close();
			conn.close();
			return list;
		}
	}
	
	public static List<serviceInfoBean> list_serviceInfo_report(List<String[]> params) throws SQLException{
			Connection conn = DBPool.getConnection();
			Statement st = null;
			ResultSet rs = null;
			List<serviceInfoBean>  list = new ArrayList<serviceInfoBean>();

			String WHERE = "";
			String start_date = "";
			String end_date = "";
			String status = "";
			Iterator<String[]> ite = params.iterator();
			while (ite.hasNext()) {
				String[] str = (String[]) ite.next();
				if (str[1].length() > 0) {
					
					if (str[0].equalsIgnoreCase("report_job_status")){
						WHERE +=" AND SS.status =  '"+str[1]+"' ";
						status = str[1].trim();							
					}else 
					if (str[0].equalsIgnoreCase("date")){						
						if (status.equalsIgnoreCase("12")) {		
							WHERE +=" AND DATE_FORMAT(SS.create_date,'%d-%m-%Y')  = '"+str[1].trim() +"'  ";	
						}else {							
							WHERE +=" AND DATE_FORMAT(SS.job_close_date,'%d-%m-%Y')  = '"+str[1].trim() +"'  ";	
						}
					}else
					if (str[0].equalsIgnoreCase("report_job_startdate")){
						start_date = str[1];
					}else 
					if (str[0].equalsIgnoreCase("report_job_enddate")){
						end_date = str[1];
					}else
					if (str[0].equalsIgnoreCase("report_job_month")){
						if (status.equalsIgnoreCase("12")) {					
							WHERE +=" AND MONTH(SS.create_date)  = '"+str[1] +"'  ";
						}else {
							WHERE +=" AND MONTH(SS.job_close_date)  = '"+str[1] +"'  ";
						}
					}else 
					if (str[0].equalsIgnoreCase("report_job_month_year")){
						if (status.equalsIgnoreCase("12")) {					
							WHERE +=" AND YEAR(SS.create_date)  = '"+str[1] +"'  ";
						}else {
							WHERE +=" AND YEAR(SS.job_close_date)  = '"+str[1] +"'  ";
						}
					}else 
					if (str[0].equalsIgnoreCase("report_job_year")){
						if (status.equalsIgnoreCase("12")) {					
							WHERE +=" AND YEAR(SS.create_date)  = '"+str[1] +"'  ";
						}else {
							WHERE +=" AND YEAR(SS.job_close_date)  = '"+str[1] +"'  ";
						}
					}else 
					if (str[0].equalsIgnoreCase("report_job_id")){
						WHERE +=" AND SS.id =  '"+str[1] +"' ";
					}else 
					if (str[0].equalsIgnoreCase("repair_type")){
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
								
				if (status.equalsIgnoreCase("12")) {
					WHERE +=" AND DATE_FORMAT(SS.create_date,'%Y-%m-%d') BETWEEN  '"+start_date +"' AND  '"+end_date+"'  ";
				}else {
					WHERE +=" AND DATE_FORMAT(SS.job_close_date,'%Y-%m-%d') BETWEEN  '"+start_date +"' AND  '"+end_date+"'  ";
				}
			}
			
			
			String query = "";
			query += "SELECT ";
			query += "  	SS.id AS job_id, ";
			query += "  	SS.forewordname AS perfix,  ";
			query += "  	SS.cus_name AS name,  ";
			query += " 		SS.cus_surname AS surname, ";
			query += "  	SS.v_plate AS plate, ";
			query += "  	SS.v_plate_province AS plate_province, ";
			query += "  	SS.status AS status, ";
			query += "  	SS.create_by AS  create_by,  " ;
			query += "  	SS.job_close_date AS job_close_datetime , ";
			query += "  	SS.create_date AS create_date_time , ";
			
			query += "  	SR.driven_by AS driven_by , ";
			query += "  	SR.driven_contact AS driven_contact , ";
			query += "  	SR.repair_type AS repair_type , ";
			query += "  	SR.mile AS mile , ";
			query += "  	SR.due_date AS due_date , ";
			query += "  	SR.problem AS problem , ";
			query += "  	SR.note AS note , ";
			
			query += "  	DATE_FORMAT(SS.create_date, '%Y-%m-%d') AS create_date, ";
			query += "  	DATE_FORMAT(SS.job_close_date, '%Y-%m-%d') AS job_close,  ";
			query += "  	concat('', TIMESTAMPDIFF(MINUTE, SS.create_date, SS.job_close_date  )) as time_complete,  ";
			query += "  	SS.total_amount AS total_amount, ";
			query += "  	SS.total As total, ";
			query += "  	SS.discount AS discount, ";
			query += "  	SS.pay AS pay,  " ;
			query += "  	BRAND.brand_name AS brand, ";
			query += "  	MODEL.model_name AS model  " ;
			query += " FROM "+table_service_sale+" AS SS  ";
			query += " LEFT JOIN "+table_brand+" AS BRAND ON BRAND.brand_id = SS.brand_id ";
			query += " LEFT JOIN "+table_model+" AS MODEL ON MODEL.model_id = SS.model_id ";
			query += " LEFT JOIN "+table_service_repair+" AS SR ON SR.id = SS.id ";
			query += " WHERE 1 = 1 ";
			query += WHERE;
			query += " ORDER BY DATE_FORMAT(SS.job_close_date,'%Y-%m-%d %H:%i') DESC,(SS.id *1) ASC ";
		
			//System.out.println("SQL : "+query);
			
			
			try{
				st = conn.createStatement();
				rs = st.executeQuery(query);
				while(rs.next()){
					serviceInfoBean service_bean = new serviceInfoBean();
					DBUtility.bindResultSet(service_bean, rs);
					list.add(service_bean);			
				}
			}catch (Exception e) {
				throw new Exception( e.getMessage() );
			}finally{
				rs.close();
				st.close();
				conn.close();
				return list;
			}
	}
	
	
	
	
	// Service Part Detail
	@SuppressWarnings("finally")
	public static List<servicePartBean> list_servicePart(List<String[]> params) throws Exception{
			Connection conn = DBPool.getConnection();
			List<servicePartBean>  list = new ArrayList<servicePartBean>();
			
			String WHERE = "";
			String start_date = "";
			String end_date = "";
			String status ="";
			Iterator<String[]> ite = params.iterator();
			while (ite.hasNext()) {
				String[] str = (String[]) ite.next();
				if (str[1].length() > 0) {
					if (str[0].equalsIgnoreCase("report_job_status")){
						WHERE +=" AND SS.status =  '"+str[1] +"' ";
						status = str[1];
					}else
					if (str[0].equalsIgnoreCase("date")){
						if (status.equalsIgnoreCase("12")) {
							WHERE +=" AND DATE_FORMAT(SS.create_date,'%d-%m-%Y')  = '"+str[1].trim() +"'  ";
						}else {
							WHERE +=" AND DATE_FORMAT(SS.job_close_date,'%d-%m-%Y')  = '"+str[1].trim() +"'  ";
						}
					}else
					if (str[0].equalsIgnoreCase("report_job_startdate")){
						start_date = str[1];
					}else 
						if (str[0].equalsIgnoreCase("report_job_enddate")){
						end_date = str[1];
					}else 
						if (str[0].equalsIgnoreCase("report_job_month")){
						if (status.equalsIgnoreCase("12")) {
							WHERE +=" AND MONTH(SS.create_date)  = '"+str[1] +"'  ";
						}else {
							WHERE +=" AND MONTH(SS.job_close_date)  = '"+str[1] +"'  ";
						}
					}else 
						if (str[0].equalsIgnoreCase("report_job_month_year")){
						if (status.equalsIgnoreCase("12")) {
							WHERE +=" AND YEAR(SS.create_date)  = '"+str[1] +"'  ";
						}else {
							WHERE +=" AND YEAR(SS.job_close_date)  = '"+str[1] +"'  ";
						}
					}else 
						if (str[0].equalsIgnoreCase("report_job_year")){
						if (status.equalsIgnoreCase("12")) {
							WHERE +=" AND YEAR(SS.create_date)  = '"+str[1] +"'  ";
						}else {
							WHERE +=" AND YEAR(SS.job_close_date)  = '"+str[1] +"'  ";
						}
					}else 
						if (str[0].equalsIgnoreCase("report_job_id")){
						WHERE +=" AND SS.id =  '"+str[1] +"' ";
					}else 
						if (str[0].equalsIgnoreCase("repair_type")){
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
				
				if (status.equalsIgnoreCase("12")) {
					WHERE +=" AND DATE(SS.create_date) BETWEEN  '"+start_date +"' AND  '"+end_date+"'  ";
				}else {
					WHERE +=" AND DATE(SS.job_close_date) BETWEEN  '"+start_date +"' AND  '"+end_date+"'  ";
				}
			}						
			String query = "";
			query += "SELECT  ";
			query += "		SPD.id AS job_id,  ";
			query += "		SPD.pn as pn,  ";
			query += "		PM.description AS part_name,  ";
			query += "		SPD.cutoff_qty AS draw,  ";
			query += "		SPD.discount AS discount,  SPD.cash_discount AS cash_discount, ";
			query += " 	SPD.price as price,  ";
			query += "SPD.total_vat AS total_vat,";
			query += "SPD.spd_dis_total AS dis_total, ";
			query += "SPD.spd_net_price  AS net_price,";
			query += " 	DATE(SS.create_date) AS create_date  ,";
			query += " 	SS.job_close_date AS job_close_date  ";
			query += "FROM "+table_service_part_detail+" AS SPD ";
			query += "LEFT JOIN "+table_service_sale+" AS SS ON SPD.id = SS.id  ";
			query += "LEFT JOIN "+table_pa_part_master+" AS PM ON PM.pn = SPD.pn  ";
			query += "LEFT JOIN "+table_service_repair+" AS SR ON SR.id = SPD.id ";
			query += " WHERE 1=1 ";
			query +=WHERE;
			query += " ORDER BY DATE_FORMAT(SS.job_close_date,'%Y-%m-%d %H:%i') DESC,(SS.id *1) ASC ";
			
			//System.out.println("Query Report Job Other  : "+query);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(query);
			try{
				while(rs.next()){
					servicePartBean part_bean = new servicePartBean();
					DBUtility.bindResultSet(part_bean, rs);
					list.add(part_bean);			
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
	
	public static List<servicePartDetailBean> list_servicePartSum(List<String[]> params) throws Exception{
		Connection conn = DBPool.getConnection();
		List<servicePartDetailBean>  list = new ArrayList<servicePartDetailBean>();
		
		String WHERE = "";
		String start_date = "";
		String end_date = "";
		String status = "";
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("report_job_status")){
					WHERE +=" AND SS.status =  '"+str[1] +"' ";
					status = str[1];
				}else
				if (str[0].equalsIgnoreCase("date")){
					if (status.equalsIgnoreCase("12")) {
						WHERE +=" AND DATE_FORMAT(SS.create_date,'%d-%m-%Y')  = '"+str[1].trim() +"'  ";
					}else {
						WHERE +=" AND DATE_FORMAT(SS.job_close_date,'%d-%m-%Y')  = '"+str[1].trim() +"'  ";
					}
				}else
				if (str[0].equalsIgnoreCase("report_job_startdate")){
					start_date = str[1];
				}else 
					if (str[0].equalsIgnoreCase("report_job_enddate")){
					end_date = str[1];
				}else 
					if (str[0].equalsIgnoreCase("report_job_month")){
					if (status.equalsIgnoreCase("12")) {
						WHERE +=" AND MONTH(SS.create_date)  = '"+str[1] +"'  ";
					}else {
						WHERE +=" AND MONTH(SS.job_close_date)  = '"+str[1] +"'  ";
					}
				}else 
					if (str[0].equalsIgnoreCase("report_job_month_year")){
					if (status.equalsIgnoreCase("12")) {
						WHERE +=" AND YEAR(SS.create_date)  = '"+str[1] +"'  ";
					}else {
						WHERE +=" AND YEAR(SS.job_close_date)  = '"+str[1] +"'  ";
					}
				}else 
					if (str[0].equalsIgnoreCase("report_job_year")){
					if (status.equalsIgnoreCase("12")) {
						WHERE +=" AND YEAR(SS.create_date)  = '"+str[1] +"'  ";
					}else {
						WHERE +=" AND YEAR(SS.job_close_date)  = '"+str[1] +"'  ";
					}
				}else 
					if (str[0].equalsIgnoreCase("report_job_id")){
					WHERE +=" AND SS.id =  '"+str[1] +"' ";
				}else 
					if (str[0].equalsIgnoreCase("repair_type")){
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
		
			if (status.equalsIgnoreCase("12")) {
				WHERE +=" AND DATE(SS.create_date) BETWEEN  '"+start_date +"' AND  '"+end_date+"'  ";
			}else {
				WHERE +=" AND DATE(SS.job_close_date) BETWEEN  '"+start_date +"' AND  '"+end_date+"'  ";
			}
			
		}						
		String query = "";
		query += "SELECT ";
		query += "		SPD.pn as pn,  ";
		query += "		PM.description AS description,  ";
		query += "		SUM( SPD.qty ) AS sum_qty,  ";
		query += "		SUM( SPD.spd_dis_total ) AS sum_spd_dis_total,   ";
		query += "		SUM( SPD.spd_net_price) AS sum_net_price , ";
		query += "		SPD.price  AS unit_price ,";
		query += "		UT.type_name AS type_name ,";	
		query += "		SS.job_close_date AS job_close_date  ";
		query += " FROM "+table_service_part_detail+" AS SPD ";
		query += " LEFT JOIN "+table_pa_part_master+" AS PM ON PM.pn = SPD.pn  ";
		query += " LEFT JOIN inv_unit_type  AS UT ON UT.id = PM.des_unit  	  ";
		query += " LEFT JOIN "+table_service_sale+" AS SS ON SPD.id = SS.id    ";
		query += " LEFT JOIN "+table_service_repair+" AS SR ON SR.id = SS.id   ";
		query += " WHERE 1=1 ";
		query += WHERE;
		query += " GROUP BY  SPD.pn";
		query += " ORDER BY sum_qty DESC ";
		
		
		//System.out.println("Query Report Job Other  : "+query);
	   
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(query);
		try{
			while(rs.next()){
				servicePartDetailBean bean = new servicePartDetailBean();
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

	
	// Service Service Detail
	@SuppressWarnings("finally")
	public static List<serviceServiceBean> list_serviceService(List<String[]> params) throws Exception{
			Connection conn = DBPool.getConnection();
			List<serviceServiceBean>  list = new ArrayList<serviceServiceBean>();

			String WHERE = "";
			String start_date = "";
			String end_date = "";
			String status = "";
			Iterator<String[]> ite = params.iterator();
			while (ite.hasNext()) {
				String[] str = (String[]) ite.next();
				if (str[1].length() > 0) {
					if (str[0].equalsIgnoreCase("report_job_status")){
						WHERE +=" AND SS.status =  '"+str[1] +"' ";
						status=str[1];
					}else
					if (str[0].equalsIgnoreCase("date")){
						if(status.equalsIgnoreCase("12")){
							WHERE +=" AND DATE_FORMAT(SS.create_date,'%d-%m-%Y')  = '"+str[1].trim() +"'  ";	
						}else {
							WHERE +=" AND DATE_FORMAT(SS.job_close_date,'%d-%m-%Y')  = '"+str[1].trim() +"'  ";	
						}
					}else
					if (str[0].equalsIgnoreCase("report_job_startdate")){
						start_date = str[1];
					}else 
						if (str[0].equalsIgnoreCase("report_job_enddate")){
						end_date = str[1];
					}else 
						if (str[0].equalsIgnoreCase("report_job_month")){
						if(status.equalsIgnoreCase("12")){
							WHERE +=" AND MONTH(SS.create_date)  = '"+str[1] +"'  ";
						}else {
							WHERE +=" AND MONTH(SS.job_close_date)  = '"+str[1] +"'  ";
						}
					}else 
						if (str[0].equalsIgnoreCase("report_job_month_year")){
						if(status.equalsIgnoreCase("12")){
							WHERE +=" AND YEAR(SS.create_date)  = '"+str[1] +"'  ";
						}else {
							WHERE +=" AND YEAR(SS.job_close_date)  = '"+str[1] +"'  ";
						}
					}else 
						if (str[0].equalsIgnoreCase("report_job_year")){
						if(status.equalsIgnoreCase("12")){
							WHERE +=" AND YEAR(SS.create_date)  = '"+str[1] +"'  ";
						}else {
							WHERE +=" AND YEAR(SS.job_close_date)  = '"+str[1] +"'  ";	
						}
					}else 
						if (str[0].equalsIgnoreCase("report_job_id")){
						WHERE +=" AND SS.id =  '"+str[1] +"' ";
					} 
						
				}
			}
			
			
			if(start_date.length()>0 &&  end_date.length()>0){
				String start_end_date[] = null;
				start_end_date = start_date.split("-");
				start_date = start_end_date[2]+"-"+start_end_date[1]+"-"+start_end_date[0];
				start_end_date = end_date.split("-");
				end_date = start_end_date[2]+"-"+start_end_date[1]+"-"+start_end_date[0];
				
				if(status.equalsIgnoreCase("12")){
					WHERE +=" AND DATE(SS.create_date) BETWEEN  '"+start_date +"' AND  '"+end_date+"'  ";
				}else {
					WHERE +=" AND DATE(SS.job_close_date) BETWEEN  '"+start_date +"' AND  '"+end_date+"'  ";
				}
			}
			String query = "";
			query += "SELECT  ";
			query += "	SRD.id AS job_id,  ";
			query += "	SRD.labor_id AS labor, ";
			query += "	SRD.labor_name AS labor_name, ";
			query += "	SRD.labor_rate AS rate,  ";
			query += "	SRD.discount AS discount,  SRD.cash_discount AS cash_discount, ";
			query += " 	SRD.total_vat AS total_vat, ";
			query += " 	SRD.srd_dis_total AS  srd_dis_total,";
			query += " 	SRD.srd_net_price AS  srd_net_price,";
			query += " 	(1.00 * SRD.labor_rate - ((SRD.labor_rate*SRD.discount)/100)) AS net_price,  ";
			query += " 	DATE(SS.create_date) AS create_date  ,";
			query += " 	SS.job_close_date AS job_close_date  ";
			query += "FROM "+table_service_repair_detail+" AS SRD ";
			query += "LEFT JOIN "+table_service_sale+" AS SS ON SRD.id = SS.id  ";
			query += " WHERE 1=1  ";
			query += WHERE;			
			query += " ORDER BY DATE_FORMAT(SS.job_close_date,'%Y-%m-%d %H:%i') DESC,(SS.id *1) ASC ";
			
			//System.out.println("SQL Service : "+query);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(query);
			try{
				while(rs.next()){
					serviceServiceBean service_bean = new serviceServiceBean();
					DBUtility.bindResultSet(service_bean, rs);
					list.add(service_bean);			
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
	
	// Service Miscellaneous 
	@SuppressWarnings("finally")
	public static List<serviceMiscellaneousBean> list_serviceMiscellaneous(List<String[]> params) throws Exception{
			Connection conn = DBPool.getConnection();
			List<serviceMiscellaneousBean>  list = new ArrayList<serviceMiscellaneousBean>();

			String WHERE = "";
			String start_date = "";
			String end_date = "";
			String status ="";
			Iterator<String[]> ite = params.iterator();
			while (ite.hasNext()) {
				String[] str = (String[]) ite.next();
				if (str[1].length() > 0) {
					if (str[0].equalsIgnoreCase("report_job_status")){
						WHERE +=" AND SS.status =  '"+str[1] +"' ";
						status = str[1];
					}else
					if (str[0].equalsIgnoreCase("date")){
						if (status.equalsIgnoreCase("12")) {
							WHERE +=" AND DATE_FORMAT(SS.create_date,'%d-%m-%Y')  = '"+str[1].trim() +"'  ";
						} else {
							WHERE +=" AND DATE_FORMAT(SS.job_close_date,'%d-%m-%Y')  = '"+str[1].trim() +"'  ";
						}
					}else
					if (str[0].equalsIgnoreCase("report_job_startdate")){
						start_date = str[1];
					}else 
						if (str[0].equalsIgnoreCase("report_job_enddate")){
						end_date = str[1];
					}else 
						if (str[0].equalsIgnoreCase("report_job_month")){
						if (status.equalsIgnoreCase("12")) {
							WHERE +=" AND MONTH(SS.create_date)  = '"+str[1] +"'  ";
						} else {
							WHERE +=" AND MONTH(SS.job_close_date)  = '"+str[1] +"'  ";
						}
					}else 
						if (str[0].equalsIgnoreCase("report_job_month_year")){
						if (status.equalsIgnoreCase("12")) {
							WHERE +=" AND YEAR(SS.create_date)  = '"+str[1] +"'  ";
						} else {
							WHERE +=" AND YEAR(SS.job_close_date)  = '"+str[1] +"'  ";
						}
					}else 
						if (str[0].equalsIgnoreCase("report_job_year")){
						if (status.equalsIgnoreCase("12")) {
							WHERE +=" AND YEAR(SS.create_date)  = '"+str[1] +"'  ";
						} else {
							WHERE +=" AND YEAR(SS.job_close_date)  = '"+str[1] +"'  ";
						}
					}else 
						if (str[0].equalsIgnoreCase("report_job_id")){
						WHERE +=" AND SS.id =  '"+str[1] +"' ";
					} 
					
				}
			}
			
			
			if(start_date.length()>0 &&  end_date.length()>0){
				String start_end_date[] = null;
				start_end_date = start_date.split("-");
				start_date = start_end_date[2]+"-"+start_end_date[1]+"-"+start_end_date[0];
				start_end_date = end_date.split("-");
				end_date = start_end_date[2]+"-"+start_end_date[1]+"-"+start_end_date[0];
				if (status.equalsIgnoreCase("12")) {
					WHERE +=" AND DATE(SS.create_date) BETWEEN  '"+start_date +"' AND  '"+end_date+"'  ";
				} else {
					WHERE +=" AND DATE(SS.job_close_date) BETWEEN  '"+start_date +"' AND  '"+end_date+"'  ";
				}
				
			}
			String query = "";
			query += "SELECT  ";
			query += "	SOD.id AS job_id,  ";
			query += "	SOD.other_Name AS name, ";
			query += "	SOD.other_qty AS qty, ";
			query += "	SOD.other_price AS price ,  ";
			query += "	SOD.discount AS discount,  SOD.cash_discount AS cash_discount, ";
			query += " 	SOD.total_vat AS total_vat, ";
			query += " 	SOD.sod_dis_total AS sod_dis_total,";
			query += " 	SOD.sod_net_price AS sod_net_price,";
			query += " 	(1.00 * (SOD.other_price*SOD.other_qty) - (((SOD.other_price*SOD.other_qty) * SOD.discount)/100)) AS net_price,   ";
			query += " 	DATE(SS.create_date) AS create_date  ,";
			query += " 	SS.job_close_date AS job_close_date  ";
			query += "FROM "+table_service_other_detail+" AS SOD ";
			query += "LEFT JOIN "+table_service_sale+" AS SS ON SOD.id = SS.id  ";
			query += " WHERE 1=1  ";
			query += WHERE;			
			query += " ORDER BY DATE_FORMAT(SS.job_close_date,'%Y-%m-%d %H:%i') DESC,(SS.id *1) ASC ";
		    //System.out.println("Query Report Job Other : "+query);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(query);
			try{
				while(rs.next()){
					serviceMiscellaneousBean service_bean = new serviceMiscellaneousBean();
					DBUtility.bindResultSet(service_bean, rs);
					list.add(service_bean);			
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
	
	 
	// Draw Part
	@SuppressWarnings("finally")
	public static List<servicePartBean> list_partDraw(List<String[]> params) throws Exception{
			Connection conn = DBPool.getConnection();
			List<servicePartBean>  list = new ArrayList<servicePartBean>();
			
			String WHERE = "";
			String start_date = "";
			String end_date = "";
			String query = "";
			query += "SELECT  ";
			query += "		SPD.id AS job_id,  ";
			query += "		SPD.pn as pn,  ";
			query += "		PM.description AS part_name,  ";
			query += "		SPD.cutoff_qty AS draw,  ";
			query += "		SPD.discount AS discount,  ";
			query += " 	SPD.price as price,  ";
			query += " 	SPD.total_vat AS total_vat,  ";
			query += " 	(1.00 * SPD.price - ((1.00*SPD.price *SPD.discount)/100) ) AS net_price,  ";
			query += " 	DATE(SS.create_date) AS create_date  ";
			query += "FROM "+table_service_part_detail+" AS SPD ";
			query += "LEFT JOIN "+table_service_sale+" AS SS ON SPD.id = SS.id  ";
			query += "LEFT JOIN "+table_pa_part_master+" AS PM ON PM.pn = SPD.pn  ";
			query += " WHERE 1=1 AND SS.status = '"+ServiceSale.STATUS_CLOSED +"' ";
			query += WHERE;
			query += " ORDER BY (SPD.id * 1), (SPD.number * 1) DESC ";
			

		    //System.out.println("Query Report Job Other  : "+query);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(query);
			try{
				while(rs.next()){
					servicePartBean part_bean = new servicePartBean();
					DBUtility.bindResultSet(part_bean, rs);
					list.add(part_bean);			
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
	
	public static List<servicePartDetailBean> list_PartNotSale(List<String[]> params) throws Exception{
		Connection conn = DBPool.getConnection();
		List<servicePartDetailBean>  list = new ArrayList<servicePartDetailBean>();
		
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
		query += " SELECT pns.pn, ";
		query += "	ps.pn AS part_sale, ";
		query += "	pns.description, ";
		query += "	pns.price AS unit_price, ";
		query += "	pns.qty AS sum_qty, ";
		query += "	pns.type_name, ";
		query += " pns.update_date ";
		query += " FROM (SELECT pn, ";
		query += "			description, ";
		query += "			price, ";
		query += "			qty, ";
		query += "			type_name, ";
		query += "			pa_part_master.update_date ";
		query += "			FROM "+table_pa_part_master;
		query += "			LEFT JOIN inv_unit_type AS UT ON UT.id = des_unit ) pns ";
		query += " LEFT JOIN (SELECT SPD.pn AS pn ";
		query += " 				FROM "+table_service_part_detail+" AS SPD ";
		query += "				LEFT JOIN "+table_pa_part_master+" AS PM ON PM.pn = SPD.pn ";
		query += " 				LEFT JOIN "+table_service_sale+" AS SS ON SPD.id = SS.id WHERE 1=1 ";
		query += 				WHERE;   
		query += " 				Group By SPD.pn ) ps ON pns.pn = ps.pn";
		query += " WHERE ps.pn is NULL ";
		query += " ORDER BY pns.update_date asc ";
		
		//System.out.println("Query Report Job Other : "+query);
	   
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(query);
		try{
			while(rs.next()){
				servicePartDetailBean bean = new servicePartDetailBean();
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
	
	public static List<servicePartDetailBean> list_PartGoodSale() throws Exception{
		Connection conn = DBPool.getConnection();
		List<servicePartDetailBean>  list = new ArrayList<servicePartDetailBean>();
		
		
		String sql = "";
		sql += " SELECT SPD.pn, ";
		sql += " PM.description AS description, ";
		sql += " SUM(SPD.qty) AS sum_qty, ";
		sql += " UT.type_name, ";
		sql += " SPD.price  AS unit_price, ";
		sql += " SUM( SPD.total_vat ) AS sum_spd_vat_total, ";
		sql += " SUM( SPD.spd_dis_total ) AS sum_spd_dis_total, ";
		sql += " SUM( SPD.spd_net_price) AS sum_net_price , ";
		sql += " MIN(SPD.update_date) AS date_sale_min, ";
		sql += " MAX(SPD.update_date) AS date_sale_max ";
		sql += " FROM service_part_detail AS SPD ";
		sql += " LEFT JOIN "+table_pa_part_master+" AS PM ON PM.pn = SPD.pn ";
		sql += " LEFT JOIN "+table_service_sale+" AS SS ON SPD.id = SS.id ";
		sql += " LEFT JOIN inv_unit_type AS UT ON UT.id = PM.des_unit ";
		sql += " WHERE 1=1 ";
		sql += " Group By SPD.pn ";
		sql += " ORDER BY sum_qty DESC ";
		//System.out.println("Query Report Job Other : "+sql);
		
		String query = "";
		query += " SELECT pns.pn, ";
		query += "	ps.pn AS part_sale, ";
		query += "	pns.description, ";
		query += "  sum_qty, ";
		query += "	pns.type_name, ";
		query += "	pns.price AS unit_price ";
		query += " FROM (SELECT pn, ";
		query += "			description, ";
		query += "			price, ";
		query += "			'0' AS sum_qty, ";
		query += "			type_name, ";
		query += "			pa_part_master.update_date ";
		query += "			FROM "+table_pa_part_master;
		query += "			LEFT JOIN inv_unit_type AS UT ON UT.id = des_unit ) pns ";
		query += " LEFT JOIN (SELECT SPD.pn AS pn ";
		query += " 				FROM "+table_service_part_detail+" AS SPD ";
		query += "				LEFT JOIN "+table_pa_part_master+" AS PM ON PM.pn = SPD.pn ";
		query += " 				LEFT JOIN "+table_service_sale+" AS SS ON SPD.id = SS.id WHERE 1=1 ";   
		query += " 				Group By SPD.pn ) ps ON pns.pn = ps.pn";
		query += " WHERE ps.pn is NULL ";
		query += " ORDER BY pns.update_date asc ";
		
		//System.out.println("Query Report Job Other : "+query);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		Statement st2 = conn.createStatement();
		ResultSet rs2 = st2.executeQuery(query);
		try{
			while(rs.next()){
				servicePartDetailBean bean = new servicePartDetailBean();
				DBUtility.bindResultSet(bean, rs);
				list.add(bean);	
			}
			rs.close();
			st.close();
			while(rs2.next()){
				servicePartDetailBean bean = new servicePartDetailBean();
				DBUtility.bindResultSet(bean, rs2);
				list.add(bean);	
			}
			rs2.close();
			st2.close();
			conn.close();
		}catch (Exception e) {
			if( rs != null ){
				rs.close();
			}
			if( st != null ){
				st.close();
			}
			if( rs2 != null ){
				rs2.close();
			}
			if( st2 != null ){
				st2.close();
			}
			if( conn != null ){
				conn.close();
			}
			throw new Exception( e.getMessage() );
		}
		
		
		
		return list;
	}
	
	public static List<serviceInfoBean> list_SaleDetail(List<String[]> params) throws Exception{
		Connection conn = DBPool.getConnection();
		Statement st = null;
		ResultSet rs = null;
		List<serviceInfoBean>  list = new ArrayList<serviceInfoBean>();

		String WHERE = "";
		String start_date = "";
		String end_date = "";
		String status = "";
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				
				if (str[0].equalsIgnoreCase("report_job_status")){
					WHERE +=" AND SS.status =  '"+str[1] +"' ";
					status = str[1];
				}else
				if (str[0].equalsIgnoreCase("date")){
					if (status.equalsIgnoreCase("12")) {
						WHERE +=" AND DATE_FORMAT(SS.create_date,'%d-%m-%Y')  = '"+str[1].trim() +"'  ";		
					} else {
						WHERE +=" AND DATE_FORMAT(SS.job_close_date,'%d-%m-%Y')  = '"+str[1].trim() +"'  ";		
					}			
				}else
				if (str[0].equalsIgnoreCase("report_job_startdate")){
					start_date = str[1];
				}else 
				if (str[0].equalsIgnoreCase("report_job_enddate")){
					end_date = str[1];
				}else 
				if (str[0].equalsIgnoreCase("report_job_month")){
					if (status.equalsIgnoreCase("12")) {
						WHERE +=" AND MONTH(SS.create_date)  = '"+str[1] +"'  ";
					} else {
						WHERE +=" AND MONTH(SS.job_close_date)  = '"+str[1] +"'  ";
					}
				}else 
				if (str[0].equalsIgnoreCase("report_job_month_year")){
					if (status.equalsIgnoreCase("12")) {
						WHERE +=" AND YEAR(SS.create_date)  = '"+str[1] +"'  ";
					} else {
						WHERE +=" AND YEAR(SS.job_close_date)  = '"+str[1] +"'  ";
					}
				}else 
				if (str[0].equalsIgnoreCase("report_job_year")){
					if (status.equalsIgnoreCase("12")) {
						WHERE +=" AND YEAR(SS.create_date)  = '"+str[1] +"'  ";
					} else {
						WHERE +=" AND YEAR(SS.job_close_date)  = '"+str[1] +"'  ";
					}
				}else 
				if (str[0].equalsIgnoreCase("report_job_id")){
					WHERE +=" AND SS.id =  '"+str[1] +"' ";
				}else 
				if (str[0].equalsIgnoreCase("repair_type")){
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
			
			if (status.equalsIgnoreCase("12")) {
				WHERE +=" AND DATE_FORMAT(SS.create_date,'%Y-%m-%d') BETWEEN  '"+start_date +"' AND  '"+end_date+"'  ";
			}else {
				WHERE +=" AND DATE_FORMAT(SS.job_close_date,'%Y-%m-%d') BETWEEN  '"+start_date +"' AND  '"+end_date+"'  ";
			}
		}
		
		
		String query = "";
		query += " SELECT ";
		query += "	DISTINCT job_close_date AS job_close ";
		query += " FROM ( SELECT ";
		query += "			DATE_FORMAT(SS.job_close_date,'%Y-%m-%d') AS job_close_date ";
		query += "			FROM "+table_service_sale+" AS SS";
		query += "			WHERE 1 = 1 ";
		query += 			WHERE;
		query += "			ORDER BY DATE_FORMAT(SS.job_close_date,'%Y-%m-%d') ASC";
		query += "		) AS JCD";
		query += " WHERE 1 = 1 AND job_close_date IS NOT NULL ";
	
		query += " ORDER BY job_close_date ASC ";
		System.out.println("SQL : "+query);
		
		
		try{
			st = conn.createStatement();
			rs = st.executeQuery(query);
			while(rs.next()){
				serviceInfoBean service_bean = new serviceInfoBean();
				DBUtility.bindResultSet(service_bean, rs);
				list.add(service_bean);			
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
	
	public static List<serviceInfoBean> list_SaleDetailJobNo(Timestamp job_close_date,String status,String job_no) throws Exception{
		Connection conn = DBPool.getConnection();
		Statement st = null;
		ResultSet rs = null;
		List<serviceInfoBean>  list = new ArrayList<serviceInfoBean>();
		String Where = "";
		if( ! status.equals("") && status != null ){
			Where += " AND SS.status = '"+status+"' ";
		}
		if( ! job_no.equals("") && job_no != null ){
			Where += " AND SS.id = '"+job_no+"' ";
		}
		String query = "";
		query += " SELECT ";
		query += "  	SS.id AS job_id, ";
		query += "		SS.job_close_date AS job_close_datetime, ";
		query += "  	SS.forewordname AS perfix,  ";
		query += "		SS.cus_name AS name, ";
		query += "		SS.cus_surname AS surname, ";
		query += "		SS.bill_id AS bill_id , ";
		query += "		SS.total," ;
		query += "		SS.vat," ;
		query += "		SS.discount," ;
		query += "		SS.total_amount," ;
		query += "		SS.total_change," ;
		query += "		SS.received," ;
		query += "		SS.pay ";
		query += " FROM "+table_service_sale+" AS SS";
		query += " WHERE 1 = 1 ";
		query += " AND DATE_FORMAT(SS.job_close_date,'%Y-%m-%d') = DATE_FORMAT('"+job_close_date+"','%Y-%m-%d')  ";
		query += Where;
		query += " GROUP BY SS.id ";
		query += " ORDER BY DATE_FORMAT(SS.job_close_date,'%Y-%m-%d %H:%i') ASC ";
	
		//System.out.println("SQL : "+query); 
		
		
		try{
			st = conn.createStatement();
			rs = st.executeQuery(query);
			while(rs.next()){
				serviceInfoBean service_bean = new serviceInfoBean();
				DBUtility.bindResultSet(service_bean, rs);
				list.add(service_bean);			
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
	
	public static List<servicePartDetailBean> list_SaleDetailPart(String job_No) throws Exception{
		Connection conn = DBPool.getConnection();
		Statement st = null;
		ResultSet rs = null;
		List<servicePartDetailBean>  list = new ArrayList<servicePartDetailBean>();

		String query = "";
		query += " SELECT ";
		query += "  	SPD.pn, ";
		query += "		PM.description, ";
		query += "		UT.type_name, ";
		query += "		SPD.price AS unit_price, ";
		query += "		SPD.qty AS sum_qty, ";
		query += "		SPD.spd_dis_total  AS sum_spd_dis_total, ";
		query += "		SPD.spd_net_price AS sum_net_price ";
		query += " FROM "+table_service_part_detail+" AS SPD ";
		query += " LEFT JOIN pa_part_master AS PM ON PM.pn = SPD.pn ";
		query += " LEFT JOIN inv_unit_type AS UT ON UT.id = PM.des_unit ";
		query += " WHERE 1 = 1 ";
		query += " AND SPD.id = '"+job_No+"'  ";
		query += " ORDER BY (SPD.number *1) ASC  ";
	
		//System.out.println("SQL : "+query);
		
		
		try{
			st = conn.createStatement();
			rs = st.executeQuery(query);
			while(rs.next()){
				servicePartDetailBean service_bean = new servicePartDetailBean();
				DBUtility.bindResultSet(service_bean, rs);
				list.add(service_bean);			
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
	public static List<ServiceRepairDetailBean> list_SaleDetailRepair(String job_No) throws Exception{
		Connection conn = DBPool.getConnection();
		Statement st = null;
		ResultSet rs = null;
		List<ServiceRepairDetailBean>  list = new ArrayList<ServiceRepairDetailBean>();

		String query = "";
		query += " SELECT ";
		query += "  	SRD.labor_id, ";
		query += "		SRD.labor_name, ";
		query += "		SRD.labor_rate, ";
		query += "		SRD.srd_dis_total, ";
		query += "		SRD.srd_net_price ";
		query += " FROM "+table_service_repair_detail+" AS SRD ";
		query += " WHERE 1 = 1 ";
		query += " AND SRD.id = '"+job_No+"'  ";
		query += " ORDER BY (SRD.number *1) ASC  ";
	
		//System.out.println("SQL : "+query);
		
		
		try{
			st = conn.createStatement();
			rs = st.executeQuery(query);
			while(rs.next()){
				ServiceRepairDetailBean service_bean = new ServiceRepairDetailBean();
				DBUtility.bindResultSet(service_bean, rs);
				list.add(service_bean);			
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
	public static List<ServiceOtherDetailBean> list_SaleDetailOther(String job_No) throws Exception{
		Connection conn = DBPool.getConnection();
		Statement st = null;
		ResultSet rs = null;
		List<ServiceOtherDetailBean>  list = new ArrayList<ServiceOtherDetailBean>();

		String query = "";
		query += " SELECT ";
		query += "		SOD.other_name, ";
		query += "		SOD.other_qty,";
		query += "		SOD.other_price, ";
		query += "		SOD.sod_dis_total, ";
		query += "		SOD.sod_net_price ";
		query += " FROM "+table_service_other_detail+" AS SOD ";
		query += " WHERE 1 = 1 ";
		query += " AND SOD.id = '"+job_No+"'  ";
		query += " ORDER BY (SOD.number *1) ASC  ";
	
		//System.out.println("SQL : "+query);
		
		
		try{
			st = conn.createStatement();
			rs = st.executeQuery(query);
			while(rs.next()){
				ServiceOtherDetailBean service_bean = new ServiceOtherDetailBean();
				DBUtility.bindResultSet(service_bean, rs);
				list.add(service_bean);			
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
	
	public static int list_SaleDetailRow(Timestamp job_close_date,String status,String job_no) throws Exception{
		Connection conn = DBPool.getConnection();
		Statement st = null;
		ResultSet rs = null;
		Statement st2 = null;
		ResultSet rs2 = null;
		Statement st3 = null;
		ResultSet rs3 = null;
		int row = 0;
		String Where = "";
		if( ! status.equals("") && status != null ){
			Where += " AND SS.status = '"+status+"' ";
		}
		if( ! job_no.equals("") && job_no != null ){
			Where += " AND SS.id = '"+job_no+"' ";
		}
		String query = "";
		query += " SELECT ";
		query += " 	SUM(row_part) AS sum_part ";
		query += " FROM ";
		query += "		( SELECT ";
		query += "			Count(SS.id) AS row_part ";
		query += " 		FROM "+table_service_sale+" AS SS";
		query += " 		LEFT JOIN "+table_service_part_detail+" AS SPD ON SPD.id = SS.id ";
		query += " 		WHERE 1 = 1 ";
		query += " 		AND DATE_FORMAT(SS.job_close_date,'%Y-%m-%d') = DATE_FORMAT('"+job_close_date+"','%Y-%m-%d')  ";
		query += "		AND SPD.number IS NOT NULL ";
		query += 		Where;
		query += " 		GROUP BY SS.id ";
		query += " 		ORDER BY DATE_FORMAT(SS.job_close_date,'%Y-%m-%d %H:%i') ASC ";
		query += "		) AS sum_tr";
	
		String sql = "";
		sql += " SELECT ";
		sql += " 	SUM(row_repair) AS sum_repair ";
		sql += " FROM ";
		sql += "		( SELECT ";
		sql += "			Count(SS.id) AS row_repair ";
		sql += " 		FROM "+table_service_sale+" AS SS";
		sql += " 		LEFT JOIN "+table_service_repair_detail+" AS SRD ON SRD.id = SS.id ";
		sql += " 		WHERE 1 = 1 ";
		sql += " 		AND DATE_FORMAT(SS.job_close_date,'%Y-%m-%d') = DATE_FORMAT('"+job_close_date+"','%Y-%m-%d')  ";
		sql += "		AND SRD.number IS NOT NULL ";
		sql += 			Where;
		sql += " 		GROUP BY SS.id ";
		sql += " 		ORDER BY DATE_FORMAT(SS.job_close_date,'%Y-%m-%d %H:%i') ASC ";
		sql += "		) AS sum_tr";
		
		String sql_query = "";
		sql_query += " SELECT ";
		sql_query += " 	SUM(row_other) AS sum_other ";
		sql_query += " FROM ";
		sql_query += "		( SELECT ";
		sql_query += "			Count(SS.id) AS row_other ";
		sql_query += " 		FROM "+table_service_sale+" AS SS";
		sql_query += " 		LEFT JOIN "+table_service_other_detail+" AS SOD ON SOD.id=SS.id ";
		sql_query += " 		WHERE 1 = 1 ";
		sql_query += " 		AND DATE_FORMAT(SS.job_close_date,'%Y-%m-%d') = DATE_FORMAT('"+job_close_date+"','%Y-%m-%d')  ";
		sql_query += "		AND SOD.number IS NOT NULL ";
		sql_query += 		Where;
		sql_query += " 		GROUP BY SS.id ";
		sql_query += " 		ORDER BY DATE_FORMAT(SS.job_close_date,'%Y-%m-%d %H:%i') ASC ";
		sql_query += "		) AS sum_tr";
		/*System.out.println("Part :"+query);
		System.out.println("Repair :"+sql);
		System.out.println("Other :"+sql_query);*/
		try{
			st = conn.createStatement();
			rs = st.executeQuery(query);
			st2 = conn.createStatement();
			rs2 = st2.executeQuery(sql);
			st3 = conn.createStatement();
			rs3 = st3.executeQuery(sql_query);
			while(rs.next()){
				if( !DBUtility.getString("sum_part", rs).equals("") && DBUtility.getString("sum_part", rs) != null){
					row = row+DBUtility.getInteger("sum_part", rs);
				}
			}
			rs.close();
			st.close();
			while(rs2.next()){
				if( !DBUtility.getString("sum_repair", rs2).equals("") && DBUtility.getString("sum_repair", rs2) != null){
					row = row+DBUtility.getInteger("sum_repair", rs2);
				}
			}
			rs2.close();
			st2.close();
			while(rs3.next()){
				if( !DBUtility.getString("sum_other", rs3).equals("") && DBUtility.getString("sum_other", rs3) != null){
					row = row+DBUtility.getInteger("sum_other", rs3);
				}
			}
			//System.out.println("ROW :"+row);
			rs3.close();
			st3.close();
			conn.close();
		}catch (Exception e) {
			if( rs != null ){
				rs.close();
			}
			if( st != null ){
				st.close();
			}
			if( rs2 != null ){
				rs2.close();
			}
			if( st2 != null ){
				st2.close();
			}
			if( rs3 != null ){
				rs3.close();
			}
			if( st3 != null ){
				st3.close();
			}
			if( conn != null ){
				conn.close();
			}
			throw new Exception( e.getMessage() );
		}
		return row;
	}
}
