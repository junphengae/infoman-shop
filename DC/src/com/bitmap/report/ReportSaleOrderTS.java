package com.bitmap.report;

import java.io.File;
import java.io.InputStream;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.catalina.core.ApplicationContext;

import jxl.CellView;
import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

import Component.Accounting.Money.MoneyAccounting;

import com.bitmap.bean.parts.ServiceRepair;
import com.bitmap.bean.sale.Brands;
import com.bitmap.bean.sale.Models;
import com.bitmap.bean.service.RepairLaborTime;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;

public class ReportSaleOrderTS {

	
public static  void getReportSaleOrderExcel(List<ReportSaleOrderBean> dataList ,String HeaderDate) throws Exception {
	//String patchLocation = "/home/bitmap/bikeman/report/excel/"; 
	String patchLocation = "D:/Dev/Bikeman/report/excel/"; 
	
	String prefixFileName = "SaleOrder-"+(DBUtility.getDateTimeValue(new Date())).toString();					
	DecimalFormat format = new DecimalFormat("####0.00");			
	//************************************************************************//	 
	 String  tempFileName = patchLocation +File.separatorChar+prefixFileName+".xls"; 
	 String  nameFile = prefixFileName+".xls"; 
	 File file = new File(tempFileName);
	 file.deleteOnExit();
	 WritableWorkbook workbook = Workbook.createWorkbook(file);      
	 WritableSheet sheet= workbook.createSheet(prefixFileName, 0); 				
	//*************************************************************************//	
	 sheet.addCell(new Label(0, 0, "รายงานสรุปการขายรวม All"));
	 sheet.mergeCells(0,0,5,0);
	 sheet.addCell(new Label(0, 1, HeaderDate));
	 sheet.mergeCells(0,1,5,1);
	//Header
	 createHeaderColumn(sheet);
	 
	
		
}
	
public static void createHeaderColumn(WritableSheet sheet) {
	try {
		 WritableFont ARIAL10ptBold = new WritableFont(WritableFont.ARIAL, 10, WritableFont.BOLD, false);
		    WritableCellFormat headerformat = new WritableCellFormat(ARIAL10ptBold);
			headerformat.setBorder(Border.ALL, BorderLineStyle.THIN,Colour.BLACK);
			headerformat.setBackground(Colour.GREY_25_PERCENT);
			headerformat.setAlignment(Alignment.CENTRE);
			
			headerformat.setWrap(true);
			sheet.mergeCells(0, 3, 0, 6);
		    sheet.addCell(new Label(0, 5, "Branch Code",headerformat));
		    sheet.mergeCells(1, 3, 1, 6);
		    sheet.addCell(new Label(1, 5, "Branch Name",headerformat));
		    sheet.mergeCells(2, 3, 2, 6);
		    sheet.addCell(new Label(2, 5, "Job Close Date",headerformat));
		
		    
		    
		for(int x=0;x<24;x++)
		{  			    
		  CellView  cell = sheet.getColumnView(x);
		  cell.setSize(23*400); 
		  sheet.setColumnView(x, cell);
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
	
}

public static List<ReportSaleOrderBean> getReportSaleOrderList(List<String[]> paramsList) throws Exception {
		
		Connection conn = DBPool.getConnection();
		String  date = "";
		String  date_start = "";
		String  date_end = "";
		String year_month ="";
		String branch ="";
		
		Iterator<String[]> ite = paramsList.iterator();		
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			
			if (str[1].length() > 0) {

				if (str[0].equalsIgnoreCase("create_date")){
					//date: 2016-04-16
					System.out.println("create_date"+str[1]);
				   date = str[1];									
				} 
				else if (str[0].equalsIgnoreCase("date_send2")){
					//date_start    :2016-04-01
					//date_end		:2016-04-16
					System.out.println("date_start"+str[1]);
					System.out.println("date_end"+str[2]);
					date_start =	str[1];	
					date_end = 		str[2];	
				}
				else if (str[0].equalsIgnoreCase("year_month")){
					//2016-01
					System.out.println("year_month"+str[1]);
					year_month	 = 	str[1];										
				} 				
				else if (str[0].equalsIgnoreCase("branch")){
					System.out.println("branch"+str[1]);
					if (str[1].equalsIgnoreCase("all")) {
					branch  = "";
					}else {
					branch  = 	str[1];		
					}
											
				}
				
			
			}
		}
		
		StringBuffer sql =new StringBuffer();
				sql.append("  	SELECT  					 	\n 	" );				 
				sql.append("      s.branch_code,	     				\n 	" );
				sql.append("      m.branch_name,		     			\n 	" );
				sql.append("      s.job_close_date,	     			\n 	" );
				sql.append("      REPLACE(s.id,SUBSTRING(s.id,-6,6),'') as job_id,  	     			\n 	" );
				sql.append("      s.bill_id,	     					\n 	" );
				sql.append("      s.forewordname,	     				\n 	" );
				sql.append("      s.cus_name,	     					\n 	" );
				sql.append("      s.cus_surname,	     				\n 	" );
				sql.append("      s.brand_id,	     					\n 	" );
				sql.append("      s.model_id,	     					\n 	" );
				sql.append("      s.v_plate,	     					\n 	" );
				sql.append("      s.v_plate_province,	     			\n 	" );
				sql.append("      s.service_type  ,  	     			\n 	" );
				sql.append("      j.id, j.number ,  	     			\n 	" );
				sql.append("      j.part_number,  	     				\n 	" );
				sql.append("      j.description,  	     				\n 	" );
				sql.append("      j.unit_type,  	     				\n 	" );
				sql.append("      j.group_name,	  	     			\n 	" );
				sql.append("      j.categories_name,	  	     			\n 	" );
				sql.append("      j.sub_categories_name,  	     			\n 	" );
				sql.append("      j.cost,  	     						\n 	" );
				sql.append("      j.unit_price,		  	     			\n 	" );
				sql.append("      j.quantity,  	     					\n 	" );
				sql.append("      j.discount,  	     					\n 	" );
				sql.append("      j.total,  	     						\n 	" );
				sql.append("      j.vat  	     							\n 	" );
				sql.append("      from service_sale s  	     			\n 	" );
				sql.append("      inner join branch_master m on m.branch_code = s.branch_code	     			\n 	" );
				sql.append("      inner join (	     															\n 	" );
				sql.append("          select  p.id, p.number ,	     											\n 	" );
				sql.append("                  p.pn as part_number,	     										\n 	" );
				sql.append("                  mp.description,	     											\n 	" );
				sql.append("                  u.type_name as  unit_type,	     								\n 	" );
				sql.append("                  g.group_name_th as group_name,	     							\n 	" );
				sql.append("                  c.cat_name_th as categories_name, 	     						\n 	" );
				sql.append("                  cs.sub_cat_name_th as sub_categories_name,	     				\n 	" );
				sql.append("                  mp.cost,	     													\n 	" );
				sql.append("                  p.price as unit_price,	     									\n 	" );
				sql.append("                  p.qty as quantity,	     										\n 	" );
				sql.append("                  p.spd_dis_total as  discount,	     							\n 	" );
				sql.append("                  p.spd_net_price as  total ,	     								\n 	" );
				sql.append("                  null as vat	     												\n 	" );
				sql.append("          from service_part_detail p	     										\n 	" );
				sql.append("          inner join pa_part_master mp on mp.pn = p.pn	     						\n 	" );
				sql.append("          inner join inv_unit_type u on u.id = mp.des_unit	     					\n 	" );
				sql.append("          inner join pa_groups g on g.group_id = mp.group_id	     				\n 	" );
				sql.append("          inner join  pa_categories c on c.group_id = mp.group_id and c.cat_id=mp.cat_id	     														\n 	" );
				sql.append("          inner join  pa_categories_sub cs on  cs.group_id = mp.group_id and cs.cat_id=mp.cat_id and cs.sub_cat_id =mp.sub_cat_id	     				\n 	" );
				sql.append("          where 1=1				    	     										\n 	" );
				sql.append("          UNION ALL				    	     										\n 	" );
				sql.append("          select r.id , rd.number ,	     											\n 	" );
				sql.append("                 rd.labor_id as part_number,	     										\n 	" );
				sql.append("                 rd.labor_name as description,	     										\n 	" );
				sql.append("                 null as unit_type,	     											\n 	" );
				sql.append("                 null as group_name,	     											\n 	" );
				sql.append("                 null as categories_name, 	     										\n 	" );
				sql.append("                 null as sub_categories_name,	     										\n 	" );
				sql.append("                 null as cost,	     													\n 	" );
				sql.append("                 rd.labor_rate as unit_price,	     										\n 	" );
				sql.append("                  1   as  quantity,	     											\n 	" );
				sql.append("                 rd.srd_dis_total as discount,	     										\n 	" );
				sql.append("                 rd.srd_net_price as total,	     										\n 	" );
				sql.append("                 null as vat	     													\n 	" );
				sql.append("          from service_repair r	     												\n 	" );
				sql.append("          inner join service_repair_detail rd  on r.id = rd.id	     					\n 	" );
				sql.append("          where 1=1    	     														\n 	" );
				sql.append("          UNION All    	     														\n 	" );
				sql.append("          select o.id ,o.number ,	     												\n 	" );
				sql.append("                 'ค่าบริการอื่นๆ'  as part_number,	     										\n 	" );
				sql.append("                 o.other_name as description,	     										\n 	" );
				sql.append("                 null as unit_type,	     											\n 	" );
				sql.append("                 null as group_name,	     											\n 	" );
				sql.append("                 null as categories_name, 	     										\n 	" );
				sql.append("                 null as sub_categories_name,	     										\n 	" );
				sql.append("                 null as cost,	     													\n 	" );
				sql.append("                 o.other_price as unit_price,	     										\n 	" );
				sql.append("                 o.other_qty   as  quantity,	     										\n 	" );
				sql.append("                 o.sod_dis_total as discount,	     										\n 	" );
				sql.append("                 o.sod_net_price as total,	     										\n 	" );
				sql.append("                 null as vat	     													\n 	" );
				sql.append("          from service_other_detail o	     											\n 	" );
				sql.append("          where 1=1	     															\n 	" );
				sql.append("      )j on  s.id = j.id	     																		\n 	" );
				sql.append("      where 1=1 	     															\n 	" );
				
				if(!date.equalsIgnoreCase("")){
					sql.append(" 		and  DATE_FORMAT(s.job_close_date,'%Y-%m-%d')  =  ?	 \n ");
				}else if ( !date_start.equalsIgnoreCase("") && !date_end.equalsIgnoreCase("")) {
					sql.append(" 		and  s.job_close_date >= ?	 \n ");	
					sql.append(" 		and  s.job_close_date <= ? 	 \n ");	
				}else if (!year_month.equalsIgnoreCase("")) {
					sql.append(" 		and  DATE_FORMAT(s.job_close_date,'%Y-%m') = ?	 \n ");	
				}
				
				if(!branch.equalsIgnoreCase("")){
				sql.append(" 		and  s.branch_code = ?	 \n ");
				}
				sql.append("      order by m.branch_code , REPLACE(s.id,SUBSTRING(s.id,-6,6),'')*1 , j.part_number ,j.number	    \n 	" );			
				sql.append(" ");
		
		PreparedStatement pst = conn.prepareStatement(sql.toString());
		int pstm = 0;
		if(!date.equalsIgnoreCase("")){
			//sql.append(" 		and  DATE_FORMAT(s.job_close_date,'%Y-%m-%d')  =  ?	 \n ");
			pstm = 1;
			pst.setString(pstm, date);
		}else if ( !date_start.equalsIgnoreCase("") && !date_end.equalsIgnoreCase("")) {
			//sql.append(" 		and  s.job_close_date >= ?	 \n ");	
			//sql.append(" 		and  s.job_close_date <= ? 	 \n ");	
			pstm = 1;
			pst.setString(pstm, date_start);
			pst.setString(pstm+1, date_end);
			pstm = 2;
		}else if (!year_month.equalsIgnoreCase("")) {
			//sql.append(" 		DATE_FORMAT(s.job_close_date,'%Y-%m') = ?	 \n ");
			pstm = 1;
			pst.setString(pstm, year_month);
		}		
		
		if(!branch.equalsIgnoreCase("")){
		//sql.append(" 		and  s.branch_code = ?	 \n ");
			pst.setString(pstm+1, branch);
		}
		
		
		
		ResultSet rs = pst.executeQuery();
		
		List<ReportSaleOrderBean> list = new ArrayList<ReportSaleOrderBean>();
		while (rs.next()) {
			
			ReportSaleOrderBean entity = new ReportSaleOrderBean();
			entity.setBranch_code(checkData(rs.getString("branch_code")));
			entity.setBranch_name(checkData(rs.getString("branch_name")));
			entity.setJob_close_date(rs.getDate("job_close_date"));
			entity.setJob_id(checkData(rs.getString("job_id")));
			entity.setBill_id(checkData(rs.getString("bill_id")));
			entity.setForewordname(rs.getString("forewordname"));
			entity.setCus_name(rs.getString("cus_name"));
			entity.setCus_surname(rs.getString("cus_surname"));
			entity.setBrand_id(rs.getString("brand_id"));
			entity.setModel_id(rs.getString("model_id"));
			entity.setV_plate(checkData(rs.getString("v_plate")));
			entity.setV_plate_province(checkData(rs.getString("v_plate_province")));
			entity.setService_type(rs.getString("service_type"));
			entity.setId(rs.getString("id"));
			entity.setNumber(rs.getString("number"));
			entity.setPart_number(checkData(rs.getString("part_number")));
			entity.setDescription(checkData(rs.getString("description")));
			entity.setUnit_type(checkData(rs.getString("unit_type")));
			entity.setGroup_name(checkData(rs.getString("group_name")));
			entity.setCategories_name(checkData(rs.getString("categories_name")));
			entity.setSub_categories_name(checkData(rs.getString("sub_categories_name")));
			
			entity.setCost(checkData(customFormat("#,##0.00",rs.getString("cost"))));
			entity.setUnit_price(checkData(customFormat("#,##0.00",rs.getString("unit_price"))));
			entity.setQuantity(checkData(customFormat("#,##0",rs.getString("quantity"))));
			entity.setDiscount(checkData(customFormat("#,##0.00",rs.getString("discount"))));
			entity.setTotal(rs.getString("total"));
			
			entity.setVat(rs.getString("vat"));
			
			
			entity.setVat(customFormat("#,##0.00",MoneyVat(entity.getTotal(),"7")));
			entity.setTotal(customFormat("#,##0.00",entity.getTotal()));
			
			entity.setBrand_id(checkData(selectMKBrands(entity.getBrand_id())));
			entity.setModel_id(checkData(selectMKModels(entity.getModel_id())));
			entity.setService_type(checkData(repairType_th(selectRepairType(entity.getId()))));
			
			list.add(entity);
					
		}
		System.out.println("Count:"+list.size());
		rs.close();
		pst.close();
		conn.close();
		return list;
	}

		public static String selectRepairType(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
			String repairType ="";	
			if ( !id.equalsIgnoreCase("") ) {	
				String sql = "SELECT repair_type FROM service_repair WHERE id ='" + id + "'";				
				Connection conn = DBPool.getConnection();
				ResultSet rs = conn.createStatement().executeQuery(sql);
				while (rs.next()) {
					repairType = rs.getString("repair_type");
				}
				rs.close();		
				conn.close();
			}
			return repairType;
		}

		public static String selectMKBrands(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
			String brand_name ="";	
			if ( !id.equalsIgnoreCase("") ) {	
				String sql = "SELECT brand_name FROM mk_brands WHERE brand_id ='" + id + "'";				
				Connection conn = DBPool.getConnection();
				ResultSet rs = conn.createStatement().executeQuery(sql);
				while (rs.next()) {
					brand_name = rs.getString("brand_name");
				}
				rs.close();		
				conn.close();
			}
			return brand_name;
		}
		
		public static String selectMKModels(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
			String model_name ="";	
			if ( !id.equalsIgnoreCase("") ) {	
				String sql = "SELECT model_name FROM mk_models WHERE model_id ='" + id + "'";				
				Connection conn = DBPool.getConnection();
				ResultSet rs = conn.createStatement().executeQuery(sql);
				while (rs.next()) {
					model_name = rs.getString("model_name");
				}
				rs.close();		
				conn.close();
			}
			return model_name;
		}
	
	public static String repairType_th(String status){
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("12", "ซื้อสินค้า");//12
		map.put("10", "บริการ");//10
		map.put("11", "ซื้อสินค้าและบริการ");//11
		return map.get(status);
	}
	
	public static String removeCommas(String str)
	 {
	    return str.replaceAll(",", "");
	 }
	private static Double DoubleParse( String x) {
		Double xx=0.00;
				
		if(x.equalsIgnoreCase("")){
			xx = Double.parseDouble("0.00");
		}else{
			xx = Double.parseDouble(removeCommas(x));
		}		
		return xx;
		
	}
	public static String MoneyVat( String a,String b ) {
		String vat = "";
		Double v = 0.00;
		Double aa = DoubleParse(removeCommas(a));
		Double bb = DoubleParse(removeCommas(b));
		v  = (aa * bb)/107;				
		vat = MoneyAccounting.MoneyCeilSatangDiscount(v).toString();
		return vat;
	}
	
	public static String checkData( Object a ) {
		String data="";
		if (a == null) {
			data="-";
		}else{
			data = a.toString();
		}
		return data;
	}
	
	public static String customFormat(String pattern, Object value ) {
		
		  DecimalFormat myFormatter = new DecimalFormat(pattern);		  
		  if(value != null){
			  return  myFormatter.format(DoubleParse(value.toString()));
		  }
		  return null;
		
	}
	
}
