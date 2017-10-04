package com.bitmap.servlet.parts;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bitmap.bean.parts.PartMaster;
import com.bitmap.bean.parts.PartSearch;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class PartSupersession
 */
public class PartSupersession extends ServletUtils {
	 public PartSupersession() {
	        super();
	    }

		public void doPost(ReqRes rr) throws ServletException {
			try {
				if (getAction(rr).length() > 0) {
					
					if (checkAction(rr, "search")){
						actionSearch(rr);
					} else 
						
					if (checkAction(rr, "search_after_edit")){
						actionSearchAfterEdit(rr);
					} else 
					
					if (checkAction(rr, "search_ss")) {
						actionSearchSS(rr);
					}else 
					
					if (checkAction(rr, "add_ss")){
						actionAddSS(rr);
					}else 
						
					if (checkAction(rr, "update_status")){
						actionUpdateStatus(rr);
					}else 
						
					if (checkAction(rr, "update_ss_flag")){
						actionAddSSFlag(rr);
					}
				} else {
					removeSession(rr, "BASE_PART_LIST");
					removeSession(rr, "BASE_PART_SEARCH");
					redirect(rr, "part_ss_search.jsp");
				}
			} catch (IOException e) {
				kson.setError(e);
				rr.out(kson.getJson());
			} catch (IllegalArgumentException e) {
				kson.setError(e);
				rr.out(kson.getJson());
			} catch (ParseException e) {
				kson.setError(e);
				rr.out(kson.getJson());
			} catch (IllegalAccessException e) {
				kson.setError(e);
				rr.out(kson.getJson());
			} catch (InvocationTargetException e) {
				kson.setError(e);
				rr.out(kson.getJson());
			} catch (SQLException e) {
				kson.setError(e);
				rr.out(kson.getJson());
			}
		}
		
		private void actionSearch(ReqRes rr) throws IllegalArgumentException, ParseException, IllegalAccessException, InvocationTargetException, SQLException, IOException{
			PartSearch pSearch = new PartSearch();
			WebUtils.bindReqToEntity(pSearch, rr.req);
			
			String sql = "";
			if (pSearch.getWhere().equalsIgnoreCase("pn")) {
				sql += pSearch.getWhere() + "='" + pSearch.getKeyword() + "'";
			} else {
				sql += pSearch.getWhere() + " like '%" + pSearch.getKeyword() + "%'";
			}
			
			if (!pSearch.getCate().equalsIgnoreCase("n/a")) {
				sql += " AND cate ='" + pSearch.getCate() + "'";
			}
			setSession(rr, "BASE_PART_LIST", PartMaster.selectWhere(sql));
			setSession(rr, "BASE_PART_SEARCH", pSearch);
			redirect(rr, "part_ss_search.jsp");
		}
		
		private void actionSearchAfterEdit(ReqRes rr) throws IOException, IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
			PartSearch pSearch = (PartSearch)getSession(rr, "BASE_PART_SEARCH");
			
			String sql = "";
			if (pSearch.getWhere().equalsIgnoreCase("pn")) {
				sql += pSearch.getWhere() + "='" + pSearch.getKeyword() + "'";
			} else {
				sql += pSearch.getWhere() + " like '%" + pSearch.getKeyword() + "%'";
			}
			
			if (!pSearch.getCate().equalsIgnoreCase("n/a")) {
				sql += " AND cate ='" + pSearch.getCate() + "'";
			}
			setSession(rr, "BASE_PART_LIST", PartMaster.selectWhere(sql));
			redirect(rr, "part_ss_search.jsp");
		}
		
		private void actionSearchSS(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException, ParseException{
			if (PartMaster.check(getParam(rr, "ss_no"))) {
				if (PartMaster.checkSS(getParam(rr, "ss_no"),getParam(rr, "pn"))) {
					kson.setData("SearchStatus", "error");
					kson.setError("อะไหล่หมายเลข : " + getParam(rr, "ss_no") + " ถูกกำหนดเป็น Supersession แล้ว กรุณาตรวจสอบ!");
					rr.out(WebUtils.getResponseString(kson.getJson()));
				} else {
					PartMaster entity = new PartMaster();
					entity.setPn(getParam(rr, "ss_no"));
					PartMaster.select(entity);
					kson.setData("SearchStatus", "success");
					kson.setGson(gson.toJson(entity));
					rr.out(WebUtils.getResponseString(kson.getJson()));
				}
			} else {
				kson.setData("SearchStatus", "error");
				kson.setError("P/N not found! ไม่พบอะไหล่หมายเลข : " + getParam(rr, "ss_no"));
				rr.out(WebUtils.getResponseString(kson.getJson()));
			}
		}
		
		private void actionAddSS(ReqRes rr) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException, ParseException{
			PartMaster entity = new PartMaster();
			WebUtils.bindReqToEntity(entity, rr.req);
			PartMaster.updateSS(entity);
			kson.setSuccess();
			rr.out(kson.getJson());
		}
		
		private void actionAddSSFlag(ReqRes rr) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException, ParseException{
			PartMaster entity = new PartMaster();
			WebUtils.bindReqToEntity(entity, rr.req);
			PartMaster.updateSSFlag(entity);
			kson.setSuccess();
			rr.out(kson.getJson());
		}
		
		private void actionUpdateStatus(ReqRes rr) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException, ParseException{
			PartMaster entity = new PartMaster();
			WebUtils.bindReqToEntity(entity, rr.req);
			PartMaster.updateStatus(entity);
			kson.setSuccess();
			rr.out(kson.getJson());
		}

}
