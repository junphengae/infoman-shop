package com.bmp.report.html.TS;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bmp.report.html.bean.JobReportSaleDetailBean;

public class JobReportSaleDetailTS {
	
	@SuppressWarnings("finally")
	public static List<JobReportSaleDetailBean> JobReportSaleDetailList(List<String[]> params) throws Exception{
		Connection conn = DBPool.getConnection();
		List<JobReportSaleDetailBean>  list = new ArrayList<JobReportSaleDetailBean>();
		
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
		query += " SS.job_close_date AS jobdate  ";
		query += " ,SS.id  ";
		query += " ,SS.bill_id   ";
		query += " ,SS.forewordname  ";
		query += " ,SS.cus_name  ";
		query += " ,SS.cus_surname  ";
		query += " ,SS.total,SS.discount,SS.total_amount,SS.total_change,SS.received,SS.pay  ";
		query += " ,SP.pn  ";
		query += " ,SP.name  ";
		query += " ,SP.type  ";
		query += " ,SP.qty  ";
		query += " ,SP.price  ";
		query += " ,SP.dis_total   ";
		query += " ,SP.net_price  ";
		query += " FROM service_sale AS SS    ";
		query += " inner JOIN    ";
		query += " 	(   ";
		query += " 	select spd.id ,spd.number ,spd.pn ,m.description as name ,ut.type_name as type ,spd.qty , spd.price ,spd.spd_dis_total as dis_total, spd.spd_net_price  as net_price  ";
		query += " 	from service_part_detail as spd   ";
		query += " 	LEFT JOIN pa_part_master AS m ON m.pn = spd.pn  ";
		query += " 	LEFT JOIN inv_unit_type AS ut ON ut.id = m.des_unit  ";
		query += " 	UNION  ";
		query += " 	select id ,number ,labor_id as pn,labor_name as name, '-' as type ,'1' as qty ,labor_rate as price ,srd_dis_total as dis_total,srd_net_price as net_price   ";
		query += " 	from service_repair_detail  ";
		query += " 	UNION  ";
		query += " 	select id ,number ,'ค่าบริการอื่นๆ' as pn ,other_name as name,  '-' as type , other_qty as qty,other_price as price,sod_dis_total as dis_total,sod_net_price  as net_price   ";
		query += " 	from service_other_detail  ";
		query += " 	order by id ,number  ";
		query += " 	) AS SP ON SP.id = SS.id			  ";
		query +=WHERE;
		query += " ORDER BY DATE_FORMAT(SS.job_close_date,'%Y-%m-%d %H:%i'),(SS.id *1) ASC ";
		
		System.out.println("Query Report Job detail  : "+query);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(query);
		try{
			while(rs.next()){
				JobReportSaleDetailBean part_bean = new JobReportSaleDetailBean();
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
	
	
}
