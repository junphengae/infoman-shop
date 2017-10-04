package com.bitmap.utils.report;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
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
		}else {
			if(conn != null) conn.commit();
			conn.close();
		}						
		} catch (Exception e) {
		  System.out.println(e.getMessage());
		  PrintWriter out = response.getWriter();
		  out.println(e.getMessage());
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

	private void PrintPOShop(Connection conn, HttpServletRequest request,HttpServletResponse response, String main_DIR) throws Exception {
		try{
			
			String  PO_NO  			=  request.getParameter("po");		
			String	file_name	    =  "PO-"+PO_NO+".pdf";
			String 	reportFile_path =  main_DIR+"PO_DC.jasper";
			
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
