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
import com.bitmap.bean.parts.PartVendor;
import com.bitmap.bean.parts.Vendor;
import com.bitmap.utils.Base64ToImage;
import com.bitmap.utils.SNCUtils;
import com.bitmap.webutils.PageControl;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;
import com.bitmap.bean.parts.PartGroups;
import com.bitmap.bean.parts.PartCategories;
import com.bitmap.bean.parts.PartCategoriesSub;

/**
 * Servlet implementation class PartManagement
 */
public class PartManagement extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public PartManagement() {
        super();
    }
    
    public void doPost(ReqRes rr) throws ServletException {
		try {
			if (isAction(rr)) {
				
				if (checkAction(rr, "add")) {
					actionAdd(rr);
				} 
				
				if (checkAction(rr, "edit")) {
					actionEdit(rr);
				} 
					
				if (checkAction(rr, "vendor_add")){
					actionVendorAdd(rr);
				}  
					
				if (checkAction(rr, "vendor_edit")){
					actionVendorEdit(rr);
				}
				
				if (checkAction(rr, "edit_location")) {
					
					PartMaster entity = new PartMaster();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					//System.out.println("pn::"+entity.getPn());
					//System.out.println("location::"+entity.getLocation());
					PartMaster.update_location(entity);
					kson.setSuccess();
					rr.outTH(kson.getJson());
					
					
					
				}
				
				
				if (checkAction(rr, "add_part_vendor")) {
					PartVendor entity = new PartVendor();
					WebUtils.bindReqToEntity(entity, rr.req);
					PartVendor.insert(entity);
					kson.setSuccess();
					kson.setGson("vendor", gson.toJson(entity));
					rr.out(WebUtils.getResponseString(kson.getJson()));
				}
				
				if (checkAction(rr, "delete_part_vendor")) {
					PartVendor entity = new PartVendor();
					WebUtils.bindReqToEntity(entity, rr.req);
					PartVendor.delete(entity);
					kson.setSuccess();
					rr.out(WebUtils.getResponseString(kson.getJson()));
				}
					
				if (checkAction(rr, "upload_img")){
					actionUploadIMG(rr);
				}
				
				
				
				
				
				if (checkAction(rr, "group_add")) {
					PartGroups entity = new PartGroups();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					PartGroups.insert(entity);
					kson.setSuccess();
					kson.setGson(gson.toJson(entity));
					rr.outTH(kson.getJson());
				}

				if (checkAction(rr, "group_edit")) {
					PartGroups entity = new PartGroups();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					PartGroups.update(entity);
					kson.setSuccess();
					kson.setGson(gson.toJson(entity));
					rr.outTH(kson.getJson());
				}
				
				
				if (checkAction(rr, "get_cat_th")) {
					String group_id = WebUtils.getReqString(rr.req, "group_id");
					kson.setSuccess();
					kson.setGson("cat", gson.toJson(PartCategories.selectList(group_id)));
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "get_sub_cat_th")) {
					String group_id = WebUtils.getReqString(rr.req, "group_id");
					String cat_id = WebUtils.getReqString(rr.req, "cat_id");
					kson.setSuccess();
					kson.setGson("sub_cat", gson.toJson(PartCategoriesSub.selectList(cat_id, group_id)));
					rr.outTH(kson.getJson());
				}
				

				if (checkAction(rr, "cat_add")){
					actionCatAdd(rr);
				}  
					
				if (checkAction(rr, "cat_edit")){
					actionCatEdit(rr);
				}  
				
				if (checkAction(rr, "sub_cat_add")){
					actionSubCatAdd(rr);
				}  
					
				if (checkAction(rr, "sub_cat_edit")){
					actionSubCatEdit(rr);
				}
				
				
			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}

	private void actionVendorAdd(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException {
		Vendor entity = new Vendor();
		WebUtils.bindReqToEntity(entity, rr.req);
		Vendor.insert(entity);
		kson.setSuccess();
		kson.setData("vendor_id", entity.getVendor_id());
		kson.setData("vendor_name", entity.getVendor_name());
		rr.outTH(kson.getJson());
	}

	private void actionVendorEdit(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException {
		Vendor entity = new Vendor();
		WebUtils.bindReqToEntity(entity, rr.req);
		Vendor.update(entity);
		kson.setSuccess();
		rr.outTH(kson.getJson());
	}

	private void actionAdd(ReqRes rr) throws UnsupportedEncodingException, IllegalAccessException, InvocationTargetException, SQLException, IllegalArgumentException, ParseException {
		PartMaster entity = new PartMaster();
		WebUtils.bindReqToEntity(entity, rr.req);
		String gen_pn_type = WebUtils.getReqString(rr.req, "gen_pn_type");
		
		if (gen_pn_type.equalsIgnoreCase(PartMaster.PN_TYPE_CUSTOM)) {
			if (PartMaster.insert(entity)){
				kson.setError("P/N ซ้ำ กรุณาตรวจสอบ");
				kson.setData("focus", "pn");
			} else {
				kson.setSuccess();
				kson.setData("pn", entity.getPn());
			}
		} else {
			entity.setPn(PartMaster.genPN(gen_pn_type));
			PartMaster.insert(entity);
			kson.setSuccess();
			kson.setData("pn", entity.getPn());
		}
		rr.outTH(kson.getJson());
		
	}
	
	private void actionEdit(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException {
		PartMaster entity = new PartMaster();
		WebUtils.bindReqToEntity(entity, rr.req);
		
		PartMaster.update(entity);
		kson.setSuccess();
		rr.outTH(kson.getJson());
	}

	private void actionUploadIMG(ReqRes rr) throws IOException{
		String realPath = rr.ses.getServletContext().getInitParameter(SNCUtils.IMG_PATH_PART);
		Base64ToImage.toImage(realPath + "/" + getParam(rr, "pn") + ".jpg", getParam(rr, "base64"));
		redirect(rr, "part_view.jsp?pn=" + getParam(rr, "pn") + "&mm=" + Math.random());
	}
	
	
	private void actionCatAdd(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException {
		PartCategories entity = new PartCategories();
		WebUtils.bindReqToEntity(entity, rr.req);
		if (PartCategories.checkShortName(entity)) {
			kson.setError("ชื่อย่อซ้ำ ควรเปลี่ยนชื่อย่อใหม่!");
		} else {
			PartCategories.insert(entity);
			kson.setSuccess();
			kson.setGson(gson.toJson(entity));
		}
		rr.out(WebUtils.getResponseString(kson.getJson()));
	}

	private void actionCatEdit(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException {
		PartCategories entity = new PartCategories();
		WebUtils.bindReqToEntity(entity, rr.req);
		if (PartCategories.checkShortNameForEdit(entity)) {
			kson.setError("ชื่อย่อซ้ำ ควรเปลี่ยนชื่อย่อใหม่!");
		} else {
			PartCategories.update(entity);
			kson.setSuccess();
		}
		rr.out(WebUtils.getResponseString(kson.getJson()));
	}
	
	
	/*sub cat*/
	private void actionSubCatAdd(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException {
		PartCategoriesSub entity = new PartCategoriesSub();
		WebUtils.bindReqToEntity(entity, rr.req);
		if (PartCategoriesSub.checkShortName(entity)) {
			kson.setError("ชื่อย่อซ้ำ ควรเปลี่ยนชื่อย่อใหม่!");
		} else {
			PartCategoriesSub.insert(entity);
			kson.setSuccess();
			kson.setGson(gson.toJson(entity));
		}
		rr.out(WebUtils.getResponseString(kson.getJson()));
	}

	private void actionSubCatEdit(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException {
		PartCategoriesSub entity = new PartCategoriesSub();
		WebUtils.bindReqToEntity(entity, rr.req);
		if (PartCategoriesSub.checkShortNameForEdit(entity)) {
			kson.setError("ชื่อย่อซ้ำ ควรเปลี่ยนชื่อย่อใหม่!");
		} else {
			PartCategoriesSub.update(entity);
			kson.setSuccess();
		}
		rr.out(WebUtils.getResponseString(kson.getJson()));
	}
}