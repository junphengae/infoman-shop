package com.bitmap.webservice;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.WebUtils;

public class PaPartSnTS {
	
	public static String tableName = "pa_part_sn";
	
	public static void main(String[] arg) throws Exception {
		
		PaPartSnTS.getPaPartSnUpdate(new Date());
	}
	
	public static List<PaPartSnBean> getPaPartSnUpdate(Date dd) throws Exception{
		
		List<PaPartSnBean> list = new ArrayList<PaPartSnBean>();
		
		Connection conn = null;
		
		try{
		
			String time = "01/01/0001" ;
			String dd2 = WebUtils.getDateValue(dd);
			String sql = "SELECT * FROM "+tableName+ " WHERE 1=1 " ;
			if (!time.equalsIgnoreCase(dd2)) {
			 
			 sql+=" AND update_date > '" + DBUtility.DATE_DATABASE_FORMAT.format(dd) + "'";
			}else{
				sql+=" AND 1=1" ;
			}
			
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
