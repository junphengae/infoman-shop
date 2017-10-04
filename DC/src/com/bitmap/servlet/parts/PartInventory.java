package com.bitmap.servlet.parts;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.ServletException;

import com.bitmap.bean.parts.PartLot;
import com.bitmap.bean.parts.PartMaster;
import com.bitmap.bean.parts.PartSearch;
import com.bitmap.bean.parts.PartSerial;
import com.bitmap.bean.purchase.PurchaseRequest;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class PartInventory
 */
public class PartInventory extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
	public PartInventory() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (isAction(rr)) {
				
				if (checkAction(rr, "search")){
					actionSearch(rr);
				} 
					
				if (checkAction(rr, "search_pn")){
					actionSearchPn(rr);
				} 	
					
				if (checkAction(rr, "search_after_edit")){
					actionSearchAfterEdit(rr);
				} 
				
				if (checkAction(rr, "stock_in_sn")) {
					actionStockIn(rr);
				} 
					
				if (checkAction(rr, "stock_in_non_sn")) {
					actionStockInNonSn(rr);
				}			
				
				
			} else {
				removeSession(rr, "BASE_PART_LIST");
				removeSession(rr, "BASE_PART_SEARCH");
				redirect(rr, "part_inventory.jsp");
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
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private void actionSearchPn(ReqRes rr) throws IllegalArgumentException, ParseException, IllegalAccessException, InvocationTargetException, SQLException, IOException{
		PartMaster entity = new PartMaster();
		WebUtils.bindReqToEntity(entity, rr.req);
		
		if (PartMaster.check(entity)) {
			PartMaster.select(entity);
			kson.setData("SearchStatus", "success");
			kson.setGson(gson.toJson(entity));
			rr.out(WebUtils.getResponseString(kson.getJson()));
		} else {
			kson.setData("SearchStatus", "error");
			kson.setError("P/N not found!");
			rr.out(kson.getJson());
		}
	}
	
	private void actionSearch(ReqRes rr) throws IllegalArgumentException, ParseException, IllegalAccessException, InvocationTargetException, IOException, SQLException {
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
		redirect(rr, "part_inventory.jsp");
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
		redirect(rr, "part_inventory.jsp");
	}
	
	private void actionStockIn(ReqRes rr) throws Exception{
		
		
		String pn_sn = getParam(rr, "pn_sn");
		String p_s[] = pn_sn.split("--");
		String recive_qty = "0";
		
		////System.out.println("addpn_sn:"+pn_sn);

		PartLot pl  = new PartLot();
		WebUtils.bindReqToEntity(pl, rr.req);
		PurchaseRequest pr =PurchaseRequest.select(pl.getPo(), pl.getPn());
		PurchaseRequest pr1 = PurchaseRequest.select1(pr);
		
		if (pr.getOrder_qty().equalsIgnoreCase(Money.moneyInteger(pr1.getUIrecive_qty())) ) {
			kson.setError("ท่านกำลังนำเข้าอะไหล่เกินกว่าจำนวนที่จัดส่ง");
		}else{
			
			if (p_s.length == 2) {
				String create_by = getParam(rr, "create_by");
				PartSerial entity = new PartSerial();
				entity.setCreate_by(create_by);
				entity.setPn(p_s[0]);
				entity.setSn(p_s[1]);
				if (PartMaster.check(p_s[0])){
					String qty = "0";
					qty = PartSerial.insert(entity);
					
					PartLot entityPI  = new PartLot();
					WebUtils.bindReqToEntity(entityPI, rr.req);
					entityPI.setLot_qty("1");
					entityPI.setCreate_by(create_by);
					entityPI.setPn(p_s[0]);
					entityPI.setSn(p_s[1]);
					//entityPI.set
					PartLot.insert(entityPI);
					recive_qty= PartLot.sumRecivePO(rr.getParameter("po"), p_s[0]);

					kson.setSuccess();
					kson.setData("qty", qty);
					kson.setData("recive_qty", recive_qty);
				} else {
					kson.setError("Invalid P/N");
				}
			} else {
				kson.setError("Invalid Format! Ex: xxxxxxx--xxx");
			}
		}
		rr.outTH(kson.getJson());
	}
	
	private void actionStockInNonSn(ReqRes rr) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, IOException, ParseException{
		String qty = getParam(rr, "qty");
		String pn = getParam(rr, "pn");
		String create_by = getParam(rr, "create_by");
		String qty_response = PartMaster.updateInventory(pn, qty, create_by);
		
		PartLot entityPI  = new PartLot();
		WebUtils.bindReqToEntity(entityPI, rr.req);
		entityPI.setLot_qty(qty);
		entityPI.setCreate_by(create_by);
		PartLot.insert(entityPI);
		//actionSearchAfterEdit(rr);
		
		kson.setSuccess();
		kson.setData("qty", qty_response);
		rr.out(WebUtils.getResponseString(kson.getJson()));
		
	}
}
