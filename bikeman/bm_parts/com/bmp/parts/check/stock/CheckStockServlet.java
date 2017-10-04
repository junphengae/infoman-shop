package com.bmp.parts.check.stock;

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

import org.apache.log4j.Logger;

import com.bitmap.bean.parts.PartMaster;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;
import com.bmp.part.master.bean.PartMasterBean;
import com.bmp.parts.master.bean.PartsMasterBean;
import com.bmp.parts.master.transaction.PartsMasterTS;

/**
 * Servlet implementation class checkStockServlet
 */
public class CheckStockServlet extends ServletUtils {
	private static final long serialVersionUID = 1L;
	private static final int List = 0;
	private int[] String;
	
    public CheckStockServlet() {
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
				
				//actionClose_stock(rr,conn);
				
				conn.commit();
				conn.close();
			}else if(checkAction(rr, "carry")){
				conn = DBPool.getConnection();
				conn.setAutoCommit(false);
				
				actionCarry(rr,conn);
				
				conn.commit();
				conn.close();
			}else if(checkAction(rr, "carry_all")){
				conn = DBPool.getConnection();
				conn.setAutoCommit(false);
				
				actionCarry_All(rr,conn);
				
				conn.commit();
				conn.close();
			}else if (checkAction(rr, "delete")) {
				conn = DBPool.getConnection();
				conn.setAutoCommit(false);
				
				actionDeleteByPn(rr,conn);
				
				conn.commit();
				conn.close();
			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
		
	}
	
	private void actionDeleteByPn(ReqRes rr, Connection conn) throws Exception {
		// TODO actionDeleteByPn 
		try {
			String check_id  = WebUtils.getReqString(rr.req, "check_id");
			String pn = WebUtils.getReqString(rr.req, "pn");
			String update_by= WebUtils.getReqString(rr.req, "update_by");
			
			System.out.println(check_id +"-"+ pn +"-"+ update_by);
			CheckStockBean entity = new CheckStockBean();
			WebUtils.bindReqToEntity(entity, rr.req);
			entity.setCheck_id(Integer.parseInt(check_id));
			entity.setPn(pn);
			entity.setUpdate_by(update_by);
			CheckStockTS.deleteByPn(conn, entity);
			kson.setSuccess("success");
			rr.outTH(kson.getJson());
		} catch (Exception e) {
			e.printStackTrace();
			if( ! conn.isClosed() ){
			   conn.rollback();
			    conn.close();
			} 
		}
		
	}

	private void actionCheck_stock(ReqRes rr,Connection conn) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException{		
		try {
			String pn  = WebUtils.getReqString(rr.req, "pn");
			String qty = WebUtils.getReqString(rr.req, "qty");
			String flag= WebUtils.getReqString(rr.req, "flag");
			String check_id = WebUtils.getReqString(rr.req, "check_id_");
			
			String keyword  = WebUtils.getReqString(rr.req, "keyword");
			String group_id  = WebUtils.getReqString(rr.req, "group_id");
			String cat_id  = WebUtils.getReqString(rr.req, "cat_id");
			String sub_cat_id  = WebUtils.getReqString(rr.req, "sub_cat_id");
			
			System.out.println("Params ===> "+keyword +"keyword:"+group_id+"group_id:"+cat_id+"cat_id:"+sub_cat_id+":sub_cat_id");
		
			CheckStockBean entity_check = new CheckStockBean();
			System.out.println("flag:"+flag +" check_id::"+check_id);
			if(flag.equalsIgnoreCase("one")){	
				entity_check.setCheck_id(Integer.parseInt(check_id));
				entity_check.setPn(pn);
				
				CheckStockBean entity = new CheckStockBean();
				WebUtils.bindReqToEntity(entity, rr.req);
				entity.setPn(pn);
				entity.setQty_old(Integer.parseInt(qty));
				entity.setCheck_id(Integer.parseInt(check_id));
				if(CheckStockTS.Check_PN(conn,entity_check)){
					entity.setStatus("00");
					CheckStockTS.update_status(conn, entity);
				}else{
					CheckStockTS.insert(conn, entity);
				}
			}else if(flag.equalsIgnoreCase("all")){
						
				List<PartsMasterBean> lst = PartsMasterTS.selectListCheckStock(check_id, keyword.trim() ,group_id.trim() ,cat_id.trim() ,sub_cat_id.trim());
				
				Iterator<PartsMasterBean> itr = lst.iterator();
				while(itr.hasNext()){
					PartsMasterBean pmBean = (PartsMasterBean) itr.next() ;
					CheckStockBean entity = new CheckStockBean();
					
					WebUtils.bindReqToEntity(entity, rr.req);
					entity.setPn(pmBean.getPn());
					entity.setQty_old(Integer.parseInt(pmBean.getQty()));
					entity.setCheck_id(Integer.parseInt(check_id));
					
					entity_check.setCheck_id(Integer.parseInt(check_id));
					entity_check.setPn(pmBean.getPn());
					
					if(CheckStockTS.Check_PN(conn,entity_check)){
						entity.setStatus("00");
						CheckStockTS.update_status(conn, entity);
						System.out.println("flag:"+flag +" check_id::"+check_id+" PN"+pmBean.getPn());
					}else{
						CheckStockTS.insert(conn, entity);
						System.out.println("flag:"+flag +" check_id::"+check_id+" PN"+pmBean.getPn());
					}
				}
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
			CheckStockBean entity = new CheckStockBean();
			WebUtils.bindReqToEntity(entity, rr.req);
			CheckStockTS.Save_Stock(conn, entity);
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
			CheckStockBean entity = new CheckStockBean();
			
			WebUtils.bindReqToEntity(entity, rr.req);
			CheckStockTS.Edit_stock(conn, entity);
			
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
	/*private void actionClose_stock(ReqRes rr, Connection conn) throws SQLException{
		try {
			CheckStockBean entity = new CheckStockBean();
			
			WebUtils.bindReqToEntity(entity, rr.req);
			
			List lst = CheckStockTS.selectList_check4close();
			Iterator itr = lst.iterator();
			while(itr.hasNext()){
				CheckStockBean entity2 = (CheckStockBean) itr.next() ;
				
				int qty_diff = 0;
				if(entity2.getQty_new() > entity2.getQty_old()){
					qty_diff = entity2.getQty_new() -  entity2.getQty_old();
				}else{
					qty_diff = entity2.getQty_old() -  entity2.getQty_new();
				}
				
				qty_diff = entity2.getQty_new() -  entity2.getQty_old();
				entity.setCheck_id(entity2.getCheck_id());
				entity.setPn(entity2.getPn());
				entity.setSeq(entity2.getSeq());
				entity.setQty_diff(qty_diff);
				CheckStockTS.Close_stock(conn, entity);
				
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
	}*/
	private void actionCarry(ReqRes rr, Connection conn) throws SQLException{
		try {
			
			CheckStockBean entity = new CheckStockBean();
			WebUtils.bindReqToEntity(entity, rr.req);
			
			List<CheckStockBean> lst = CheckStockTS.selectList_Check4Carry();
			Iterator<CheckStockBean> itr = lst.iterator();
			while(itr.hasNext()){
				CheckStockBean entity2 = (CheckStockBean) itr.next() ;
				entity.setCheck_id(entity2.getCheck_id());
				entity.setPn(entity2.getPn());
				entity.setSeq(entity2.getSeq());
				entity.setQty_new(entity2.getQty_old());
				CheckStockTS.Carry(conn, entity);
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
	private void actionCarry_All(ReqRes rr, Connection conn) throws SQLException{
		try {
			
			CheckStockBean entity = new CheckStockBean();
			WebUtils.bindReqToEntity(entity, rr.req);
			
			List<CheckStockBean> lst = CheckStockTS.selectList_Check4CarryAll();
			Iterator<CheckStockBean> itr = lst.iterator();
			while(itr.hasNext()){
				CheckStockBean entity2 = (CheckStockBean) itr.next() ;
				entity.setCheck_id(entity2.getCheck_id());
				entity.setPn(entity2.getPn());
				entity.setSeq(entity2.getSeq());
				entity.setQty_new(entity2.getQty_old());
				entity.setQty_diff(0);
				CheckStockTS.Carry(conn, entity);
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
