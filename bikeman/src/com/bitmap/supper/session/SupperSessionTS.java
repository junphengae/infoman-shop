package com.bitmap.supper.session;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bmp.part.master.bean.PartMasterBean;

public class SupperSessionTS {
	public static List<PartMasterBean> selectListSS(String pn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		List<PartMasterBean> list = new ArrayList<PartMasterBean>();
		List<PartMasterBean> size_list = Select(conn);
		int i = 1;
		String ss_no = pn;
		while( i <= size_list.size() ){
			if( ! ss_no.equalsIgnoreCase("") ){
				String sql = "SELECT * FROM pa_part_master WHERE ss_no = '" + ss_no + "' ";
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery(sql);
				if(rs.next()){
					PartMasterBean entity = new PartMasterBean();
					DBUtility.bindResultSet(entity, rs);
					list.add(entity);
					ss_no = DBUtility.getString("pn", rs);					
				}else{
					ss_no = "";
				}
				rs.close();
				st.close();
				i++;
			}else{
				break;
			}
		}
		
		i = 1;
		while( i <= size_list.size() ){
			if( ! pn.equalsIgnoreCase("") ){
				String sql = "SELECT * FROM pa_part_master WHERE pn = '" + pn + "' ";
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery(sql);
				if(rs.next()){
					PartMasterBean entity = new PartMasterBean();
					DBUtility.bindResultSet(entity, rs);
					list.add(entity);
					pn = DBUtility.getString("ss_no", rs);					
				}else{
					pn = "";
				}
				rs.close();
				st.close();
				i++;
			}else{
				break;
				/*i = ( size_list.size() + 1 );*/
			}
		}
		conn.close();
		return list;
	}
	
	public static List<PartMasterBean> Select( Connection conn ) throws SQLException, IllegalAccessException, InvocationTargetException{
		List<PartMasterBean> list = new ArrayList<PartMasterBean>();
		String sql = " SELECT * FROM pa_part_master ";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		while( rs.next() ){
			PartMasterBean entity = new PartMasterBean();
			DBUtility.bindObject(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		return list;
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException {
		//String pn = "1599822750017";
		String pn = "1719662000017";
		
		int i = 1;
		Iterator<PartMasterBean> ite = selectListSS(pn).listIterator();
		while (ite.hasNext()) {
			PartMasterBean en = (PartMasterBean) ite.next();
			System.out.println("--> "+i+" PN : "+en.getPn()+"  SS_NO : "+en.getSs_no());
			i++;
		}
	
	}

}
