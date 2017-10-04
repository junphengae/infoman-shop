package com.bmp.part.master.TS;

import java.sql.Connection;
import java.sql.SQLException;
import java.text.DecimalFormat;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bmp.part.master.bean.PartMasterBean;

public class PartMasterTS {
	public static String tableName = "pa_part_master";
	public static String[] keys = {"pn"};
	public static String[] fieldName = {"group_id","des_unit","cat_id","sub_cat_id","fit_to","description","qty","sn_flag","moq","mor","price","price_unit","cost","cost_unit","weight","location","ss_no","ss_flag","status","create_by","create_date","update_by","update_date","barcode","reference"};
	public static DecimalFormat df = new DecimalFormat("#.##");
	
	public static void Select( PartMasterBean entity ) throws Exception {
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			DBUtility.getEntityFromDB(conn, tableName, entity, keys);
			conn.close();
		} catch (Exception e) {
			if (conn != null) {
				conn.rollback();
				conn.close();
			}
		}
	}
	
	
	
	
	
			 
}
