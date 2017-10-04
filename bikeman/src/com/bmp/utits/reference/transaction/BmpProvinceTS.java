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




import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bmp.utils.reference.bean.BmpProvinceBean;
import com.bmp.utils.reference.bean.BmpTumbolBean;

public class BmpProvinceTS {

		public static String tableName = "bmp_province";
		public static String[] keys = {"bmp_pt_id"};
		public static boolean init_already = false;
		public static HashMap<String, String>  mapProvince = new HashMap<String, String>();
		
		
		
		public static void Select(BmpProvinceBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
			Connection connBP = DBPool.getConnection();
			DBUtility.getEntityFromDB(connBP, tableName, entity, keys);
			connBP.close();		
		}
		
		public static void InitMappingProvince() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
			if( init_already == false)
			{
				Connection connBP = DBPool.getConnection();
				String query = "SELECT * FROM "+tableName+" WHERE bmp_pt_del_flag  != '1'  ORDER BY bmp_pt_order ASC ";
				Statement st = connBP.createStatement();
				ResultSet rs = st.executeQuery(query);
				while(rs.next()){
					BmpProvinceBean entity = new BmpProvinceBean();
					DBUtility.bindResultSet(entity, rs);
					mapProvince.put(entity.getBmp_pt_gov_cd(), entity.getBmp_pt_name());
				}
				rs.close();
				st.close();
				connBP.close();
				init_already = true;
			}
		}
		
		public static String GetProvinceDescription( String bmp_pt_gov_cd){
			if(init_already == true)
				return mapProvince.get(bmp_pt_gov_cd);
			else
				return "";
			
		}
		
		public static List<BmpProvinceBean> SelectListAll() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
			Connection connBP = DBPool.getConnection();
			final String query = "SELECT * FROM "+tableName+" WHERE bmp_pt_del_flag  != '1'   ORDER BY bmp_pt_order ASC ";
			Statement  st = connBP.createStatement();
			ResultSet rs = st.executeQuery(query);
			
			List<BmpProvinceBean> lst = new ArrayList<BmpProvinceBean>();
			while(rs.next()){
				BmpProvinceBean entity = new BmpProvinceBean();
				DBUtility.bindResultSet(entity, rs);
				lst.add(entity);				
			}
			rs.close();
			st.close();
			connBP.close();
			return lst;
	
		}
		
		public static List<BmpProvinceBean> SelectForeignProvince() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
			Connection connBP = DBPool.getConnection();
			final String query = "SELECT * FROM "+tableName+" WHERE  bmp_pt_del_flag  != '1'  AND bmp_pt_order >= 9  ORDER BY bmp_pt_order ASC ";
			Statement  st = connBP.createStatement();
			ResultSet rs = st.executeQuery(query);
			
			List<BmpProvinceBean> lst = new ArrayList<BmpProvinceBean>();
			while(rs.next()){
				BmpProvinceBean entity = new BmpProvinceBean();
				DBUtility.bindResultSet(entity, rs);
				lst.add(entity);				
			}
			rs.close();
			st.close();
			connBP.close();
			return lst;
		}
		
		public static List<BmpProvinceBean> SelectThailandProvince() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
			Connection connBP = DBPool.getConnection();
			final String query = "SELECT * FROM "+tableName+" WHERE bmp_pt_del_flag  != '1'  AND  bmp_pt_order < 9  ORDER BY bmp_pt_order ASC ";
			Statement  st = connBP.createStatement();
			ResultSet rs = st.executeQuery(query);
			
			List<BmpProvinceBean> lst = new ArrayList<BmpProvinceBean>();
			while(rs.next()){
				BmpProvinceBean entity = new BmpProvinceBean();
				DBUtility.bindResultSet(entity, rs);
				lst.add(entity);				
			}
			rs.close();
			st.close();
			connBP.close();
			return lst;
		}
		
		public static String SetHtmlSelectForeignProvince( String bmp_provnc_name ) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
			Connection connBP = DBPool.getConnection();
			String html = "<option value=\"\" >เลือกทะเบียนจังหวัด</option> ";
			final String query = "SELECT * FROM "+tableName+" WHERE bmp_pt_del_flag  != '1'  AND  bmp_pt_order >= 9  ORDER BY bmp_pt_order ASC ";
			Statement  st = connBP.createStatement();
			ResultSet rs = st.executeQuery(query);
			while(rs.next()){
					BmpProvinceBean entity = new BmpProvinceBean();
					DBUtility.bindResultSet(entity, rs);
					if( entity.getBmp_pt_name().equals(bmp_provnc_name) ){
						html+="<option value=\""+entity.getBmp_pt_name()+"\"  code=\""+entity.getBmp_pt_gov_cd()+"\" selected=\"selected\" >"+entity.getBmp_pt_name()+"</option> ";
					}else{
						html+="<option value=\""+entity.getBmp_pt_name()+"\" code=\""+entity.getBmp_pt_gov_cd()+"\"  >"+entity.getBmp_pt_name()+"</option> ";
					}
			}
			rs.close();
			st.close();
			connBP.close();
			return html;
		}
		public static String SetHtmlSelectThailandProvince( String bmp_provnc_name ) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
			Connection connBP = DBPool.getConnection();
			String html = "<option value=\"\" >เลือกทะเบียนจังหวัด</option> ";
			final String query = "SELECT * FROM "+tableName+" WHERE bmp_pt_del_flag  != '1'  AND  bmp_pt_order < 9  ORDER BY bmp_pt_order ASC ";
			Statement  st = connBP.createStatement();
			ResultSet rs = st.executeQuery(query);
			while(rs.next()){
					BmpProvinceBean entity = new BmpProvinceBean();
					DBUtility.bindResultSet(entity, rs);
					if( entity.getBmp_pt_name().equals(bmp_provnc_name) ){
						html+="<option value=\""+entity.getBmp_pt_name()+"\"  code=\""+entity.getBmp_pt_gov_cd()+"\" selected=\"selected\" >"+entity.getBmp_pt_name()+"</option> ";
					}else{
						html+="<option value=\""+entity.getBmp_pt_name()+"\" code =\""+entity.getBmp_pt_gov_cd()+"\"  >"+entity.getBmp_pt_name()+"</option> ";
					}
			}
			rs.close();
			st.close();
			connBP.close();
			return html;
		}
		/*public static void main(String[] args){
			try{
				List<BmpProvinceBean> lst = BmpProvinceTS.SelectThailandProvince();
				Iterator<BmpProvinceBean> itr = lst.iterator();
				while(itr.hasNext())
				{
					BmpProvinceBean entity = itr.next();
					
					//System.out.println( "bmp_pt_id = "+entity.getBmp_pt_id() + 
												"bmp_pt_name = "+ entity.getBmp_pt_name() +
												" bmp_pt_gov_cd = "+ entity.getBmp_pt_gov_cd());
				
				}
				
			}catch(Exception e){
				e.printStackTrace();
				
			}			
		}*/


		public static  BmpProvinceBean Select_name(String  bmp_pt_gov_cd) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
			
			BmpProvinceBean entityR = new BmpProvinceBean();
			entityR.setBmp_pt_gov_cd(bmp_pt_gov_cd);
			return Select_name(entityR);
			
		}
		
		public static  BmpProvinceBean Select_name(BmpProvinceBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
			Connection connBT = DBPool.getConnection();
			DBUtility.getEntityFromDB(connBT, tableName, entity, new String[]{"bmp_pt_gov_cd"});
			connBT.close();
			return entity;
			
			
		}


}
