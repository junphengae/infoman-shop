package com.bitmap.webservice;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;

public class PaPartSnTS {
	
	public static String tableName = "pa_part_sn";
	
	public static void main(String[] arg) throws Exception {
		
		PaPartSnTS.getPaPartSnUpdate(new Date());
	}
	
	public static List<PaPartSnBean> getPaPartSnUpdate(Date dd) throws Exception{
		
		List<PaPartSnBean> list = new ArrayList<PaPartSnBean>();
		
		Connection conn = null;
		
		try{
		
			String sql = "SELECT * FROM "+tableName+" WHERE update_date > '"+DBUtility.DATE_DATABASE_FORMAT.format(dd)+"'";
			
			conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while(rs.next()){
			
				PaPartSnBean entity = new PaPartSnBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
				
			}
			
			st.close();
			rs.close();
			
		}
		catch (Exception e) {
			throw new Exception("PaPartSnTSException:"+e.getMessage());
		}
		finally{
			if(conn != null){
				conn.close();
			}
		}
		return list;
	}

}
