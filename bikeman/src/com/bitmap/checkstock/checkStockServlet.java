package com.bitmap.checkstock;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bitmap.bean.parts.PartMaster;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;
import com.bmp.part.master.bean.PartMasterBean;

/**
 * Servlet implementation class checkStockServlet
 */
public class checkStockServlet extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public checkStockServlet() {
        super();
    }

	@Override
	public void doPost(ReqRes rr) throws ServletException {
		Connection conn = null;
		try {
			if(checkAction(rr, "check_stock")){
				conn = DBPool.getConnection();
				conn.setAutoCommit(false);
				
				actionCheck_stock(rr,conn);
				
				conn.commit();
				conn.close();
			}else if(checkAction(rr, "save_stock")){
				conn = DBPool.getConnection();
				conn.setAutoCommit(false);
				
				actionSave_stock(rr,conn);
				
				conn.commit();
				conn.close();
			}else if(checkAction(rr, "edit_stock")){
				conn = DBPool.getConnection();
				conn.setAutoCommit(false);
				
				actionEdit_stock(rr,conn);
				
				conn.commit();
				conn.close();
			}else if(checkAction(rr, "close_stock")){
				conn = DBPool.getConnection();
				conn.setAutoCommit(false);
				
				actionClose_stock(rr,conn);
				
				conn.commit();
				conn.close();
			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
		
	}
	private void actionCheck_stock(ReqRes rr,Connection conn) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException{
		
		try {
			List lst = PartMaster.selectList();
			Iterator itr = lst.iterator();
			while(itr.hasNext()){
				PartMaster pmBean = (PartMaster) itr.next() ;
				checkStockBean entity = new checkStockBean();
				
				WebUtils.bindReqToEntity(entity, rr.req);
				entity.setPn(pmBean.getPn());
				entity.setQty_old(Integer.parseInt(pmBean.getQty()));
				checkStockTS.insert(conn, entity);
			}
			kson.setSuccess("success");
			rr.outTH(kson.getJson());
		} catch (Exception e) {
			System.out.println(e);
			if( ! conn.isClosed() ){
			   conn.rollback();
			    conn.close();
			} 
		}
		
	}
	private void actionSave_stock(ReqRes rr,Connection conn) throws SQLException{
		try {
			checkStockBean entity = new checkStockBean();
			WebUtils.bindReqToEntity(entity, rr.req);
			checkStockTS.Save_Stock(conn, entity);
			kson.setSuccess("success");
			rr.outTH(kson.getJson());
		} catch (Exception e) {
			System.out.println(e);
			if( ! conn.isClosed() ){
			   conn.rollback();
			    conn.close();
			} 
		}
	}
	private void actionEdit_stock(ReqRes rr, Connection conn) throws SQLException{
		try {
			checkStockBean entity = new checkStockBean();
			
			WebUtils.bindReqToEntity(entity, rr.req);
			
			checkStockBean entity2 = new checkStockBean();
			entity2.setCheck_id(entity.getCheck_id());
			entity2.setPn(entity.getPn());
			entity2.setSeq(entity.getSeq());
			checkStockTS.select(entity2);
			
			entity.setCheck_date(entity2.getCheck_date());
			entity.setCheck_by(entity2.getCheck_by());
			checkStockTS.Edit_stock(conn, entity);
			
			kson.setSuccess("success");
			rr.outTH(kson.getJson());
		} catch (Exception e) {
			System.out.println(e);
			if( ! conn.isClosed() ){
			   conn.rollback();
			    conn.close();
			} 
		}
	}
	private void actionClose_stock(ReqRes rr, Connection conn) throws SQLException{
		try {
			checkStockBean entity = new checkStockBean();
			
			WebUtils.bindReqToEntity(entity, rr.req);
			
			List lst = checkStockTS.selectList_check4close();
			Iterator itr = lst.iterator();
			while(itr.hasNext()){
				checkStockBean entity2 = (checkStockBean) itr.next() ;
				
				int qty_diff = 0;
				/*if(entity2.getQty_new() > entity2.getQty_old()){
					qty_diff = entity2.getQty_new() -  entity2.getQty_old();
				}else{
					qty_diff = entity2.getQty_old() -  entity2.getQty_new();
				}*/
				
				qty_diff = entity2.getQty_new() -  entity2.getQty_old();
				entity.setCheck_id(entity2.getCheck_id());
				entity.setPn(entity2.getPn());
				entity.setSeq(entity2.getSeq());
				entity.setQty_diff(qty_diff);
				checkStockTS.Close_stock(conn, entity);
				
				//update pa_part_master
				PartMaster pm = new PartMaster();
				pm.setPn(entity2.getPn());
				pm.setUpdate_by(entity2.getUpdate_by());
				pm.setQty(String.valueOf(entity2.getQty_new()));
				PartMaster.updateQty(pm);
			}
			kson.setSuccess("success");
			rr.outTH(kson.getJson());
		} catch (Exception e) {
			System.out.println(e);
			if( ! conn.isClosed() ){
			   conn.rollback();
			    conn.close();
			} 
		}
	}

}
