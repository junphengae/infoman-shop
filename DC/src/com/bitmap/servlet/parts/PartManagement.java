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
				if (checkAction(rr, "addManage")) {
					actionAdd(rr);
				} 	
				if (checkAction(rr, "upload_img")){
					actionUploadIMG(rr);
				}
				
				
				
				
				
			if (checkAction(rr, "group_add")) {
					
					
					PartGroups entity = new PartGroups();
					WebUtils.bindReqToEntity(entity, rr.req);
					
							if (PartGroups.checkName(entity.getGroup_name_th(), entity.getGroup_name_en())) {
										
										
										kson.setError("Name");
										rr.out(kson.getJson());
										
										
							}else{
								
								
								  if (PartGroups.checkName_th(entity.getGroup_name_th())) {
									 
									  	kson.setError("Name_th");
										rr.out(kson.getJson());
								 }
								  else if (PartGroups.checkName_en(entity.getGroup_name_en())) {
									 
									  	
									  	kson.setError("Name_en");
										rr.out(kson.getJson());
								 }else{
									 
										PartGroups.insert(entity);
										kson.setSuccess();
										kson.setGson(gson.toJson(entity));
										rr.outTH(kson.getJson());
									
								 }
								
							}
					
			}
			if (checkAction(rr, "group_edit")) {
				
					PartGroups entity = new PartGroups();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					if (PartGroups.checkName(entity.getGroup_name_th(), entity.getGroup_name_en())) {
						
						////System.out.println("if");
						PartGroups name = PartGroups.selectcheckName(entity.getGroup_id(), entity.getGroup_name_th(), entity.getGroup_name_en());
						if (name.getCreate_date() == null) {
							////System.out.println("Name");
							kson.setError("Name");
							rr.out(kson.getJson());
							
						}else{
							
							PartGroups.update(entity);
							kson.setSuccess();
							kson.setGson(gson.toJson(entity));
							rr.outTH(kson.getJson());
							
						}
						
						
						
					}else {
						////System.out.println("else");
						
						if (PartGroups.checkName_th(entity.getGroup_name_th())) {
							////System.out.println("checkName_th");
							PartGroups name_th = PartGroups.selectcheckName_th(entity.getGroup_id(), entity.getGroup_name_th());
							  
							if (name_th.getCreate_date() == null) {
								kson.setError("Name_th");
								rr.out(kson.getJson());
								
							}else {
								////System.out.println("else--checkName_th");
									   if (PartGroups.checkName_en(entity.getGroup_name_en())) {
										   ////System.out.println("checkName_en");
											  PartGroups name_en = PartGroups.selectcheckName_en(entity.getGroup_id(), entity.getGroup_name_en());
											 
											  if (name_en.getCreate_date() == null) {
												  kson.setError("Name_en");
													rr.out(kson.getJson());
												
											  }else {
												  	PartGroups.update(entity);
													kson.setSuccess();
													kson.setGson(gson.toJson(entity));
													rr.outTH(kson.getJson());
												
											  }
											  	
										 }
										else {
											PartGroups.update(entity);
											kson.setSuccess();
											kson.setGson(gson.toJson(entity));
											rr.outTH(kson.getJson());
										
									    }
								 
							}
							
								
						 
						} else if (PartGroups.checkName_en(entity.getGroup_name_en())) {
							   ////System.out.println("checkName_en");
								  PartGroups name_en = PartGroups.selectcheckName_en(entity.getGroup_id(), entity.getGroup_name_en());
								 
								  if (name_en.getCreate_date() == null) {
									  	
									  	kson.setError("Name_en");
										rr.out(kson.getJson());
									
								  }else {
									  
									  if (PartGroups.checkName_th(entity.getGroup_name_th())) {
											////System.out.println("checkName_th");
											PartGroups name_th = PartGroups.selectcheckName_th(entity.getGroup_id(), entity.getGroup_name_th());
											  
											if (name_th.getCreate_date() == null) {
												kson.setError("Name_th");
												rr.out(kson.getJson());
												
											}else{
												PartGroups.update(entity);
												kson.setSuccess();
												kson.setGson(gson.toJson(entity));
												rr.outTH(kson.getJson());
											}
									  
									
									
								       }else{
								    	   PartGroups.update(entity);
											kson.setSuccess();
											kson.setGson(gson.toJson(entity));
											rr.outTH(kson.getJson());
										}
								 }  	
						}
						else {
							
							PartGroups.update(entity);
							kson.setSuccess();
							kson.setGson(gson.toJson(entity));
							rr.outTH(kson.getJson());
						
					    }
					}
					
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
		
		if (PartCategories.checkName(entity)) {
				kson.setError("ชื่อชนิดและชื่อย่อ ซ้ำ!");
		}else{
				if (PartCategories.checkShortName(entity)) {
					kson.setError("ชื่อย่อซ้ำ !");
				}else if (PartCategories.checkName_th(entity)) { 
					kson.setError("ชื่อชนิด ซ้ำ!");
				}else {
					PartCategories.insert(entity);
					kson.setSuccess();
					kson.setGson(gson.toJson(entity));
				}
		}		
		rr.out(WebUtils.getResponseString(kson.getJson()));
		
	}

	private void actionCatEdit(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException {
		
		PartCategories entity = new PartCategories();
		WebUtils.bindReqToEntity(entity, rr.req);
		////System.out.println("PartCategories Cat_id::" + entity.getCat_id()+"PartCategories Group_id::" + entity.getGroup_id());
		
		String Cat_id= entity.getCat_id();
		String Group_id= entity.getGroup_id();
		String cat_name_short = entity.getcat_name_short();
		String Cat_name_th = entity.getCat_name_th();
		
		PartCategories enPC = new PartCategories();
		enPC.setCat_id(entity.getCat_id());
		enPC.setGroup_id(entity.getGroup_id());
		PartCategories.select(enPC);
		
		//System.out.println(enPC.getCat_id()+" : "+enPC.getGroup_id()+" : "+enPC.getCat_name_th()+" : "+enPC.getcat_name_short());
		
		if(Cat_id.equalsIgnoreCase(enPC.getCat_id()) ){
			System.out.println();
			if(Group_id.equalsIgnoreCase(enPC.getGroup_id())){
				if(Cat_name_th.equalsIgnoreCase(enPC.getCat_name_th())){
					if(cat_name_short.equalsIgnoreCase(enPC.getcat_name_short())){
						entity.setUpdate_by(enPC.getUpdate_by());
						PartCategories.update(entity);
						kson.setSuccess();
					}else {
						if(PartCategories.checkShortName(entity)){
							kson.setError("ชื่อย่อซ้ำ!");
						}else {
							entity.setUpdate_by(enPC.getUpdate_by());
							PartCategories.update(entity);
							kson.setSuccess();
						}
					}
					
				}else {
					if(PartCategories.checkName_th(entity)){
						kson.setError("ชื่อชนิด ซ้ำ!");
					}else {
						entity.setUpdate_by(enPC.getUpdate_by());
						PartCategories.update(entity);
						kson.setSuccess();
					}
					
				}
				
			}
			
		}
		
		
		/*if (PartCategories.checkName(entity)) {
			////System.out.println("PartCategories1 Cat_id::" + Cat_id+"PartCategories1 Group_id::" + Group_id);
			////System.out.println("checkName");
			PartCategories cat =PartCategories.selectcheckName(Cat_id, Group_id, Cat_name_th, cat_name_short);
			
			if (cat.getCreate_date() == null) {
				kson.setError("ชื่อชนิดและชื่อย่อ ซ้ำ!");
				////System.out.println("ชื่อชนิดและชื่อย่อ");
			}else {
				////System.out.println("checkName---else");
				PartCategories.update(entity);
				kson.setSuccess();
			}
			
		}else{
			//System.out.println("else");
			if (PartCategories.checkName_th(entity)) {
				////System.out.println("checkName_th");
				////System.out.println("PartCategories2 Cat_id::" + Cat_id+"PartCategories2 Group_id::" + Group_id);
				PartCategories name_th = PartCategories.selectcheckName_th(Cat_id, Group_id, Cat_name_th);
				
				if (name_th.getCreate_date() == null) {
					
					////System.out.println("ชื่อชนิด");
					kson.setError("ชื่อชนิด ซ้ำ!");
				}else{
					
					if (PartCategories.checkName_short(entity)) {
							PartCategories shortName = PartCategories.selectcheckNameShort(Cat_id, Group_id, cat_name_short);
							////System.out.println("shortName::"+shortName.getCreate_date());
							System.out.println("shortName::"+shortName.getCreate_date());
							if (shortName.getCreate_date() == null) {
								////System.out.println("ชื่อย่อซ้ำ");
								kson.setError("ชื่อย่อซ้ำ!1");
								
							}else{
								////System.out.println("ชื่อย่อซ้ำ--else");
								PartCategories.update(entity);
								kson.setSuccess();
							}
							
					}else {
						////System.out.println("ชื่อย่อซ้ำ--else--else");
						PartCategories.update(entity);
						kson.setSuccess();
					}
				}
				
			}
			else if (PartCategories.checkName_short(entity)) {
				////System.out.println("checkName_short");
				PartCategories shortName = PartCategories.selectcheckNameShort(Cat_id, Group_id, cat_name_short);
				
				if (shortName.getCreate_date() == null) {
					////System.out.println("ชื่อย่อซ้ำ");
					kson.setError("ชื่อย่อซ้ำ!2");
				}else{
					
					if (PartCategories.checkName_th(entity)) {		
							PartCategories name_th = PartCategories.selectcheckName_th(Cat_id, Group_id, Cat_name_th);
							
							if (name_th.getCreate_date() == null) {
								
								kson.setError("ชื่อชนิด ซ้ำ!");
								////System.out.println("ชื่อชนิด");
							}else{
								////System.out.println("ชื่อย่อซ้ำ--else");
								PartCategories.update(entity);
								kson.setSuccess();
							}
					}else{
						////System.out.println("ชื่อย่อซ้ำ--else--else");
						PartCategories.update(entity);
						kson.setSuccess();
					}
				}
				
				
			} else {
				////System.out.println("else--else");
				PartCategories.update(entity);
				kson.setSuccess();
			}
			
			
		}	*/
		rr.out(WebUtils.getResponseString(kson.getJson()));
		
	}
	
	
	/*sub cat*/
	private void actionSubCatAdd(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException {
		PartCategoriesSub entity = new PartCategoriesSub();
		WebUtils.bindReqToEntity(entity, rr.req);
		
		if (PartCategoriesSub.checkName(entity)) {
			
			kson.setError("ชื่อชนิดย่อยและชื่อย่อ ซ้ำ!");
			
		}else{
					
					if (PartCategoriesSub.checkName_th(entity)) {
						kson.setError("ชื่อชนิดย่อย ซ้ำ!");
					}
					else if (PartCategoriesSub.checkShortName(entity)) {
						kson.setError("ชื่อย่อซ้ำ !");
					}
					else {
						PartCategoriesSub.insert(entity);
						kson.setSuccess();
						kson.setGson(gson.toJson(entity));
					}
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