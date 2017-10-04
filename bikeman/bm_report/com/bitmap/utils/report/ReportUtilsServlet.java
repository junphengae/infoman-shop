package com.bitmap.utils.report;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;


public class ReportUtilsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public ReportUtilsServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = null;
		try {
		conn = DBPool.getConnection();
		conn.setAutoCommit(false);
		
		String TYPE = request.getParameter("type");	
		//String Main_DIR = "D:/lib_project/report/"; 
		//String Main_DIR = "/var/www/vhosts/infoman.asia/home/test/report/"; 
		//String Main_DIR = "/var/www/vhosts/infoman.asia/home/demo/report/"; 
		String Main_DIR = "/var/www/vhosts/infoman.asia/home/infoman/report/"; 
		if (TYPE.equals("PO")) {
			PrintPOShop(conn,request,response,Main_DIR);
		}else if(TYPE.equals("OPENJOB")){
			PrintOPENJOBShop(conn,request,response,Main_DIR);
		}else if(TYPE.equals("OPENJOBBILL")){
			PrintJOBShopBill(conn,request,response,Main_DIR);
		}else if(TYPE.equals("check_stock_all")){
			PrintCheckStockShopAll(conn,request,response,Main_DIR);
		}else if(TYPE.equals("check_stock_by_checkId")){
			PrintCheckStockShopId(conn,request,response,Main_DIR);
		}else
		{
			if(conn != null) conn.commit();
			conn.close();
		}						
		} catch (Exception e) {
		  System.out.println(e.getMessage());
		  PrintWriter out = response.getWriter();
		  out.println(e.getMessage());
		}
	}

	private void PrintCheckStockShopId(Connection conn,HttpServletRequest request, HttpServletResponse response,String main_DIR) throws Exception {
		 try {
			String CHECK_ID = request.getParameter("check_id");
			String file_name ="CheckStock-"+CHECK_ID+".pdf";
			String reportFile_path 	= main_DIR+"check_stock_by_check_id.jasper";
				 
			String jaspar_path = ""; 
			JasReportBM jr_report = new JasReportBM();
			Map param = jr_report.MapParamCheckStock(CHECK_ID);
			param.put("CHECK_ID",CHECK_ID);
			
			jaspar_path = reportFile_path;
			 
			jaspar_path = reportFile_path;				
			jr_report.PrintReportToPDF(conn,jaspar_path, param, response,file_name);

			conn.commit();
			conn.close();
			
			
		} catch (Exception e) {
			if(conn != null){
				conn.rollback();
				conn.close();
			}
			throw new Exception( e.getMessage() );
		}
				 				
		
	}

	private void PrintCheckStockShopAll(Connection conn,HttpServletRequest request, HttpServletResponse response,String main_DIR) throws Exception {
		try{
		String CHECK_ID = request.getParameter("check_id");
		String file_name ="CheckStock-"+CHECK_ID+".pdf";
		String reportFile_path 	= main_DIR+"check_stock_all.jasper";
		 
		String jaspar_path = ""; 

		JasReportBM jr_report = new JasReportBM();
		Map param = jr_report.MapParamCheckStock(CHECK_ID);
		param.put("CHECK_ID",CHECK_ID);
		
		jaspar_path = reportFile_path;
		 
		jaspar_path = reportFile_path;				
		jr_report.PrintReportToPDF(conn,jaspar_path, param, response,file_name);

		conn.commit();
		conn.close();
		

		}catch( Exception e){
			if(conn != null){
				conn.rollback();
				conn.close();
			}
			throw new Exception( e.getMessage() );
		}
	}

	private void PrintOPENJOBShop(Connection conn, HttpServletRequest request,HttpServletResponse response, String main_DIR) throws Exception {
		try{
			String  JOB_ID  		=  request.getParameter("id");		
			String	file_name	    =  "JOB-"+JOB_ID+".pdf";
			String 	reportFile_path =  main_DIR+"JOB.jasper";
			
			String jaspar_path = ""; 
						
			JasReportBM jr_report = new JasReportBM();
			Map param = jr_report.MapParameterJob(JOB_ID);
			param.put("SUBREPORT_DIR", main_DIR);
			jaspar_path = reportFile_path;				
			jr_report.PrintReportToPDF(conn,jaspar_path, param, response,file_name);
			
			conn.commit();
			conn.close();
			
		
		}catch( Exception e){
			if(conn != null){
				conn.rollback();
				conn.close();
			}
			throw new Exception( e.getMessage() );
		}
		
	}

	private void PrintJOBShopBill(Connection conn, HttpServletRequest request,HttpServletResponse response, String main_DIR) throws Exception {
		try{
			SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
			SimpleDateFormat s = new SimpleDateFormat("yyMMdd");
			String  start_date  	=  request.getParameter("start_date");	
			String  end_date  		=  request.getParameter("end_date" );	
			String	file_name	    =  "JOB-"+s.format(f.parse(start_date))+"_"+s.format(f.parse(end_date))+".pdf";
			String 	reportFile_path =  main_DIR+"JOB_BILL.jasper";
		
			String jaspar_path = ""; 
			
				JasReportBM jr_report = new JasReportBM();
				Map param = jr_report.MapParameterJobBill(start_date, end_date);
				param.put("SUBREPORT_DIR", main_DIR);
				jaspar_path = reportFile_path;				
				jr_report.PrintReportToPDF(conn,jaspar_path, param, response,file_name);				
			
			conn.commit();
			conn.close();
			
		
		}catch( Exception e){
			if(conn != null){
				conn.rollback();
				conn.close();
			}
			throw new Exception( e.getMessage() );
		}
		
	}
	private void PrintPOShop(Connection conn, HttpServletRequest request,HttpServletResponse response, String main_DIR) throws Exception {
		try{
			
			String  PO_NO  			=  request.getParameter("po");		
			String	file_name	    =  "PO-"+PO_NO+".pdf";
			String 	reportFile_path =  main_DIR+"PO.jasper";
			
			String jaspar_path = ""; 
			
			JasReportBM jr_report = new JasReportBM();
			Map param = jr_report.MapParameterPO(PO_NO);
			jaspar_path = reportFile_path;		
			jr_report.PrintReportToPDF(conn, jaspar_path, param, response,file_name);
			conn.commit();
			conn.close();
			}catch( Exception e){
				if(conn != null){
					conn.rollback();
					conn.close();
				}
				throw new Exception( e.getMessage() );
			}
		 
	}

}
