package com.bitmap.webserviceTEST;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;
import java.util.ArrayList;
import java.util.Date;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;


public class PartMasterTS {
	public static String tableName = "pa_part_master";
	public static void main (String[]arg) throws Exception {
		PartMasterTS.getMasterUpdatedate(new Date());
	}
	
	public static List<PartMasterBean> getMasterUpdatedate(Date dd) throws Exception{
		List<PartMasterBean> list = new ArrayList<PartMasterBean>();
		Connection conn = null;
		
		try{
			String sql = "SELECT * FROM "+tableName+" WHERE update_date > '"+DBUtility.DATE_DATABASE_FORMAT.format(dd)+"'";
			conn = DBPool.getConnection();
			//System.out.println("SQL : "+sql);
			Statement stm = conn.createStatement();
			ResultSet rs = stm.executeQuery(sql);
			while (rs.next()) {
				PartMasterBean entity = new PartMasterBean();
				DBUtility.bindResultSet(entity, rs);
				
				list.add(entity);
				//System.out.println(entity.getDescription());
			}
			rs.close();
			stm.close();
		}catch(Exception e){
			throw new Exception("PartMaster "+e.getMessage());
		}finally{
			if(conn != null){
				conn.close();
			}
				
		}
		
		return list;
		
		
	}
		
}
