package com.bitmap.servlet.inventory;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.ServletException;

import com.bitmap.bean.inventory.Categories;
import com.bitmap.bean.inventory.Group;
import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.bean.inventory.InventoryMasterTemp;
import com.bitmap.bean.inventory.InventoryMasterTempDetail;
import com.bitmap.bean.inventory.InventoryMasterVendor;
import com.bitmap.bean.inventory.SubCategories;
import com.bitmap.security.SecurityProfile;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;
import com.bitmap.bean.inventory.Vendor;

public class MaterialManage extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public MaterialManage() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			SecurityProfile sp = new SecurityProfile();
			sp = (SecurityProfile) getSession(rr,"securProfile");
			 
			if (isAction(rr)) {
				if (checkAction(rr, "group_add")) {
					Group entity = new Group();
					WebUtils.bindReqToEntity(entity, rr.req);
					Group.insert(entity);
					kson.setSuccess();
					kson.setGson(gson.toJson(entity));
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "group_edit")) {
					Group entity = new Group();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					Group.update(entity);
					kson.setSuccess();
					kson.setGson(gson.toJson(entity));
					rr.outTH(kson.getJson());
				}
				if (checkAction(rr, "get_cat_th")) {
					String group_id = WebUtils.getReqString(rr.req, "group_id");
					kson.setSuccess();
					kson.setGson("cat", gson.toJson(Categories.selectList(group_id)));
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "get_sub_cat_th")) {
					String group_id = WebUtils.getReqString(rr.req, "group_id");
					String cat_id = WebUtils.getReqString(rr.req, "cat_id");
					kson.setSuccess();
					kson.setGson("sub_cat", gson.toJson(SubCategories.selectList(cat_id, group_id)));
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "add_material")) {
					InventoryMaster entity = new InventoryMaster();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					InventoryMaster.insert(entity);
					kson.setSuccess();
					kson.setGson("mat", gson.toJson(entity));
					
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "add_material_with_matcode")) {
					InventoryMaster entity = new InventoryMaster();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					InventoryMaster.insertWithMatcode(entity);
					kson.setSuccess();
					kson.setGson("mat", gson.toJson(entity));
					
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "edit_material")) {
					InventoryMaster entity = new InventoryMaster();
					WebUtils.bindReqToEntity(entity, rr.req);
					InventoryMaster.updateInfo(entity);
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				
				
				if (checkAction(rr, "add_material_vendor")) {
					InventoryMasterVendor entity = new InventoryMasterVendor();
					WebUtils.bindReqToEntity(entity, rr.req);
					InventoryMasterVendor.insert(entity);
					kson.setSuccess();
					kson.setGson("vendor", gson.toJson(entity));
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "delete_material_vendor")) {
					InventoryMasterVendor entity = new InventoryMasterVendor();
					WebUtils.bindReqToEntity(entity, rr.req);
					InventoryMasterVendor.delete(entity);
					kson.setSuccess();
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
				
				
				if (checkAction(rr, "vendor_add")){
					actionVendorAdd(rr);
				}  
					
				if (checkAction(rr, "vendor_edit")){
					actionVendorEdit(rr);
				}
				
				if (checkAction(rr, "developUpdateBalance")) {
					InventoryMaster.developUpdateBalance();
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "add_matcode_detail")) {
					InventoryMasterTempDetail entity = new InventoryMasterTempDetail();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					boolean check = InventoryMasterTempDetail.selectHave(entity.getMaster_matcode(),entity.getMat_code());
					if(!(check)){
						InventoryMasterTempDetail.insert(entity);
						kson.setSuccess();
					}else{
						kson.setError("ขออภัย ข้อมูลอะไหล่ไม่สามารถซ้ำกันได้");
					}
					rr.outTH(kson.getJson());
				}
				if (checkAction(rr, "del_matcode_detail")) {
					InventoryMasterTempDetail entity = new InventoryMasterTempDetail();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					InventoryMasterTempDetail.delete(entity);
					
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				if (checkAction(rr, "temp_add")) {
					InventoryMasterTemp entity = new InventoryMasterTemp();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					InventoryMasterTemp.insert(entity);
					
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
			} else {

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
		rr.out(WebUtils.getResponseString(kson.getJson()));
	}

	private void actionVendorEdit(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException {
		Vendor entity = new Vendor();
		WebUtils.bindReqToEntity(entity, rr.req);
		Vendor.update(entity);
		kson.setSuccess();
		rr.out(WebUtils.getResponseString(kson.getJson()));
	}
	
	private void actionCatAdd(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException {
		Categories entity = new Categories();
		WebUtils.bindReqToEntity(entity, rr.req);
		if (Categories.checkShortName(entity)) {
			kson.setError("ชื่อย่อซ้ำ ควรเปลี่ยนชื่อย่อใหม่!");
		} else {
			Categories.insert(entity);
			kson.setSuccess();
			kson.setGson(gson.toJson(entity));
		}
		rr.out(WebUtils.getResponseString(kson.getJson()));
	}

	private void actionCatEdit(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException {
		Categories entity = new Categories();
		WebUtils.bindReqToEntity(entity, rr.req);
		if (Categories.checkShortNameForEdit(entity)) {
			kson.setError("ชื่อย่อซ้ำ ควรเปลี่ยนชื่อย่อใหม่!");
		} else {
			Categories.update(entity);
			kson.setSuccess();
		}
		rr.out(WebUtils.getResponseString(kson.getJson()));
	}
	
	
	/*sub cat*/
	private void actionSubCatAdd(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException {
		SubCategories entity = new SubCategories();
		WebUtils.bindReqToEntity(entity, rr.req);
		if (SubCategories.checkShortName(entity)) {
			kson.setError("ชื่อย่อซ้ำ ควรเปลี่ยนชื่อย่อใหม่!");
		} else {
			SubCategories.insert(entity);
			kson.setSuccess();
			kson.setGson(gson.toJson(entity));
		}
		rr.out(WebUtils.getResponseString(kson.getJson()));
	}

	private void actionSubCatEdit(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException {
		SubCategories entity = new SubCategories();
		WebUtils.bindReqToEntity(entity, rr.req);
		if (SubCategories.checkShortNameForEdit(entity)) {
			kson.setError("ชื่อย่อซ้ำ ควรเปลี่ยนชื่อย่อใหม่!");
		} else {
			SubCategories.update(entity);
			kson.setSuccess();
		}
		rr.out(WebUtils.getResponseString(kson.getJson()));
	}
}
