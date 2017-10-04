package com.bmp.imgges;

import java.io.File;
import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;


import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;

public class PartMasterBarcodeTS {

	public static String tableName = "pa_part_master";
	public static String[] keys = {"pn"};
	public static String[] fieldNames = {"sn_flag","update_by","update_date","barcode"};
	
	
	public static void UpDateBarCode(PartMasterBean entity,String barcode) throws SQLException {
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);	
			
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());

			File imgfile = new File(barcode);
			FileInputStream fin = new FileInputStream(imgfile);
			
			String sql ="UPDATE pa_part_master SET sn_flag=?,update_by=?,update_date=?,barcode=?  WHERE pn=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, entity.getSn_flag());
			ps.setString(2, entity.getUpdate_by());
			ps.setTimestamp(3, entity.getUpdate_date());
			ps.setBinaryStream(4,fin,(int)imgfile.length());
			ps.setString(5, entity.getPn());
			
			ps.executeUpdate();
			
			System.out.println("INSERT Barcode");
									
			conn.commit();
			conn.close();
		} catch (Exception e) {
			if (conn  != null) {
				conn.rollback();
				conn.close();
			}
			System.out.println(e.getMessage());
		}
		
	}

	
}
