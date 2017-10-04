package com.bitmap.servlet.sale;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;

import com.bitmap.bean.sale.Customer;
import com.bitmap.bean.sale.Models;
import com.bitmap.bean.sale.Vehicle;
import com.bitmap.bean.sale.VehicleMaster;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;


/**
 * Servlet implementation class VehicleManage
 */
public class VehicleManage extends ServletUtils {
	private static final long serialVersionUID = 1L;
       

    public VehicleManage() {
        super();
    }


    public void doPost(ReqRes rr) throws ServletException {
		try {
			if (isAction(rr)) {
				
				if (checkAction(rr, "select_vehicle")){
					Vehicle vehicle = new Vehicle();
					WebUtils.bindReqToEntity(vehicle, rr.req);
					Vehicle.insert(vehicle);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "vehicle_edit")){
					Vehicle vehicle = new Vehicle();
					WebUtils.bindReqToEntity(vehicle, rr.req);
					Vehicle.vUpdate(vehicle);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				/*if (checkAction(rr, "vehicle_add")){
					Vehicle vehicle = new Vehicle();
					WebUtils.bindReqToEntity(vehicle, rr.req);
					Vehicle.insert(vehicle);
					kson.setSuccess();
					rr.out(kson.getJson());
				}*/
				
				if (checkAction(rr, "brochure_add")) {
					VehicleMaster master = new VehicleMaster();
					WebUtils.bindReqToEntity(master, rr.req);
					VehicleMaster.insert(master);
					kson.setSuccess();
					rr.out(kson.getJson());
				} 
				
				if (checkAction(rr, "brochure_edit")) {
					VehicleMaster master = new VehicleMaster();
					WebUtils.bindReqToEntity(master, rr.req);
					VehicleMaster.update(master);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "model_add")) {
					Models model = new Models();
					WebUtils.bindReqToEntity(model, rr.req);
					Models.insert(model);
					kson.setSuccess();
					kson.setGson("model", gson.toJson(model));
					rr.out(kson.getJson());
				} 
				
				if (checkAction(rr, "model_edit")){
					Models entity = new Models();
					WebUtils.bindReqToEntity(entity, rr.req);
					if (Models.checkNameForEdit(entity)) {
						kson.setError("Model name is duplicate!");
					} else {
						Models.update(entity);
						kson.setSuccess();
					}
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "get_vspec")) {
					List paramList = new ArrayList();

					String brand = getParam(rr, "brand");
					String model = getParam(rr, "model");

					paramList.add(new String[]{"model",model});
					paramList.add(new String[]{"brand",brand});
					
					kson.setSuccess();
					kson.setGson("spec", gson.toJson(VehicleMaster.selectList(paramList)));
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "get_vehicle")) {
					String cus_id = getParam(rr, "cus_id");
					kson.setSuccess();
					kson.setGson("vehicle", gson.toJson(Vehicle.selectByCusID(cus_id)));
					rr.outTH(kson.getJson());
				}
			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}
}
