package com.bmp.utits.reference.transaction;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;



import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bmp.utils.reference.bean.BmpAmphurBean;
import com.bmp.utils.reference.bean.BmpProvinceBean;

public class BmpAmphurTS {

		public static String tableName ="bmp_amphur";
		public static String[] keys = {"bmp_ampr_id"};
		public static  HashMap<String, String> mapAmphur = new HashMap<String, String>();
		private static boolean init_already = false;
		
		public static void InitMappingAmphur() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
			if( ! init_already){
					Connection connBA = DBPool.getConnection();
					final String query = "SELECT * FROM "+tableName+" WHERE bmp_ampr_del_flag != '1'  ORDER BY  (bmp_ampr_cd * 1) ASC ";
					Statement st = connBA.createStatement();
					ResultSet rs = st.executeQuery(query);
					
					while(rs.next()){
						BmpAmphurBean entity = new BmpAmphurBean();
						DBUtility.bindResultSet(entity, rs);
						mapAmphur.put( entity.getBmp_ampr_provnc_gov_cd() + entity.getBmp_ampr_cd() , entity.getBmp_ampr_name());
					}
					
					rs.close();
					st.close();
					connBA.close();
					init_already = true	;		
			}
			
		}
		public static String GetAmphurDescription(String bmp_ampr_cd){
				if(init_already){
						return mapAmphur.get(bmp_ampr_cd);
				}else
					return "";
			
		}
		
		public static void Select(BmpAmphurBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
				Connection connBA = DBPool.getConnection();
				DBUtility.getEntityFromDB( connBA, tableName, entity, keys);
				connBA.close();
		}
		
		public static List<BmpAmphurBean> SelectListByProvince( String provnc_gov_cd ) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
			Connection connBA = DBPool.getConnection();
			List<BmpAmphurBean> lst = new ArrayList<BmpAmphurBean>();
			final String query = "SELECT * FROM "+tableName+" WHERE bmp_ampr_del_flag != '1' AND  bmp_ampr_provnc_gov_cd = "+provnc_gov_cd  + " ORDER BY  (bmp_ampr_cd * 1) ASC ";
			Statement st = connBA.createStatement();
			ResultSet rs = st.executeQuery(query);
			
			while( rs.next() ){
				BmpAmphurBean entity = new BmpAmphurBean();
				DBUtility.bindResultSet(entity, rs);
				lst.add(entity);
				
			}
			rs.close();
			st.close();
			connBA.close();
			
			return lst;			
		}
		
		public static String GenListAmphur(String bmp_provnc_cd ,String bmp_ampr_cd) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
			Connection connBA = DBPool.getConnection();
			String html = "<option value=\"\">เลือกอำเภอ/เขต...</option>" ;
			final String query = "SELECT * FROM "+tableName+" WHERE bmp_ampr_del_flag != '1' AND  bmp_ampr_provnc_gov_cd = "+bmp_provnc_cd +" ORDER BY  (bmp_ampr_cd * 1) ASC ";
			Statement st = connBA.createStatement();
			ResultSet rs = st.executeQuery(query);
			
			while(rs.next()){
				BmpAmphurBean atb = new BmpAmphurBean();
				DBUtility.bindResultSet(atb, rs);
				
				if( atb.getBmp_ampr_cd().equals(bmp_ampr_cd) ){
					html+="<option value=\""+atb.getBmp_ampr_cd()+"\" bmp_ampr_pc=\""+atb.getBmp_ampr_pc()+"\" bmp_ampr_name=\""+atb.getBmp_ampr_name()+"\" selected=\"selected\" >"+atb.getBmp_ampr_sname()+"</option> ";
				}else{
					html+="<option value=\""+atb.getBmp_ampr_cd()+"\" bmp_ampr_pc=\""+atb.getBmp_ampr_pc()+"\" bmp_ampr_name=\""+atb.getBmp_ampr_name()+"\">"+atb.getBmp_ampr_sname()+"</option> ";
				}
				
			}
			rs.close();
			st.close();
			connBA.close();
			return html;
			
		}
		public static  BmpAmphurBean Select_name(String  bmp_ampr_cd ,String bmp_ampr_provnc_gov_cd) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
			
				BmpAmphurBean entityR = new BmpAmphurBean();
				entityR.setBmp_ampr_cd(bmp_ampr_cd);
				entityR.setBmp_ampr_provnc_gov_cd(bmp_ampr_provnc_gov_cd);
				return Select_name(entityR);
			
		}
		
		public static  BmpAmphurBean Select_name(BmpAmphurBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
			Connection connBT = DBPool.getConnection();
			DBUtility.getEntityFromDB(connBT, tableName, entity, new String[]{"bmp_ampr_cd","bmp_ampr_provnc_gov_cd"});
			connBT.close();
			return entity;
			
			
			}

}
