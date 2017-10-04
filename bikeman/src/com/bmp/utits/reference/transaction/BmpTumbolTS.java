package com.bmp.utits.reference.transaction;



import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.bitmap.bean.parts.ServiceSale;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bmp.utils.reference.bean.BmpTumbolBean;




public class BmpTumbolTS {

	private static final ServiceSale District = null;
	public static String tableName ="bmp_tumbol";
	public static String[] keys = {"bmp_tum_id"};
	public static  HashMap<String, String> mapTumbol = new HashMap<String, String>();
	private static boolean init_already = false;
	
	public static void InitMappingTumbol() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		if( ! init_already ){
			Connection connBT = DBPool.getConnection();
			final String query = "SELECT * FROM "+tableName+" WHERE bmp_tum_del_flag != '1'  ORDER BY bmp_tum_order ASC ";
			Statement st = connBT.createStatement();
			ResultSet rs = st.executeQuery(query);
			
			while( rs.next()){
				BmpTumbolBean entity = new BmpTumbolBean();
				DBUtility.bindResultSet(entity, rs);
				mapTumbol.put(entity.getBmp_tum_provnc_gov_cd()+entity.getBmp_tum_ampr_cd()+ entity.getBmp_tum_cd(), entity.getBmp_tum_name());
			}
			connBT.close();
			init_already = true;
		}	
	}
	
	public static String GetTumbolDescription(String bmp_tum_cd){
		if( init_already ){
			 return  mapTumbol.get(bmp_tum_cd);		
		}else
			return "";	
	}
	
	
	public static void Select(BmpTumbolBean  entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection connBT = DBPool.getConnection();
		DBUtility.getEntityFromDB(connBT, tableName, entity, keys);
		connBT.close();
		
	}
	
	
	public static  BmpTumbolBean Select_name(String  bmp_tum_cd ,String bmp_tum_ampr_cd,String bmp_tum_provnc_gov_cd) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		
		BmpTumbolBean entityR = new BmpTumbolBean();
		entityR.setBmp_tum_cd(bmp_tum_cd);
		entityR.setBmp_tum_ampr_cd(bmp_tum_ampr_cd);
		entityR.setBmp_tum_provnc_gov_cd(bmp_tum_provnc_gov_cd);
		return Select_name(entityR);
		
	}
	
	public static  BmpTumbolBean Select_name(BmpTumbolBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection connBT = DBPool.getConnection();
		DBUtility.getEntityFromDB(connBT, tableName, entity, new String[]{"bmp_tum_cd","bmp_tum_ampr_cd","bmp_tum_provnc_gov_cd"});
		connBT.close();
		return entity;
		
		
	}
	
	
	
	public static List<BmpTumbolBean> SelectListByAmphurAndProvince(String provnc_cd ,String ampr_cd) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection connBT = DBPool.getConnection();
		final String query = "SELECT * FROM "+tableName+" WHERE bmp_tum_del_flag != '1' AND  bmp_tum_provnc_gov_cd = '"+provnc_cd+"' AND bmp_tum_ampr_cd = '"+ampr_cd+"'  ORDER BY bmp_tum_order ASC ";
		Statement st = connBT.createStatement();
		ResultSet rs = st.executeQuery(query);
		
		List<BmpTumbolBean> lst = new ArrayList<BmpTumbolBean>();
		while( rs.next()){
				BmpTumbolBean entity = new BmpTumbolBean();
				DBUtility.bindResultSet(entity, rs);
				lst.add(entity);
		}
		rs.close();
		st.close();
		connBT.close();
		return lst;
	}
	public static String GenListTumbol(String bmp_provnc_cd, String bmp_ampr_cd,String bmp_tumbol_cd ) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection connBT = DBPool.getConnection();
		String html = "" ;
		final String query = "SELECT * FROM "+tableName+" WHERE  bmp_tum_del_flag != '1' AND bmp_tum_provnc_gov_cd = '"+bmp_provnc_cd+"' AND bmp_tum_ampr_cd = '"+bmp_ampr_cd+"' ORDER BY bmp_tum_order ASC ";
		Statement st = connBT.createStatement();
		ResultSet rs = st.executeQuery(query);
		while(rs.next()){
			BmpTumbolBean entity = new BmpTumbolBean();
			DBUtility.bindResultSet(entity, rs);
			
			if( entity.getBmp_tum_cd().equals(bmp_tumbol_cd)){
				html+="<option value=\""+entity.getBmp_tum_cd()+"\"  bmp_tum_name=\""+entity.getBmp_tum_name()+"\" selected=\"selected\" >"+entity.getBmp_tum_sname()+"</option> ";				
			}else{
				html+="<option value=\""+entity.getBmp_tum_cd()+"\"  bmp_tum_name=\""+entity.getBmp_tum_name()+"\">"+entity.getBmp_tum_sname()+"</option> ";
				
			}
		}
	
		String first_html = ""; 
		if(bmp_tumbol_cd.equals(""))
			first_html = "<option value=\"\" bmp_tum_name=\"\" selected=\"selected\"  >เลือกตำบล/แขวง...</option>";
		else
			first_html = "<option value=\"\" bmp_tum_name=\"\">เลือกตำบล/แขวง...</option>";
		
		html = first_html + html;
		
		rs.close();
		st.close();
		connBT.close();
		return html;

	}
	
	/*public static void main(String[] args){
			try{
				//System.out.println( BmpTumbolTS.GenListTumbol("81", "02", "03"));
				
				
			}catch(Exception E){
				
				
			}
		
		
		
	}*/
	
	
	
	
}
