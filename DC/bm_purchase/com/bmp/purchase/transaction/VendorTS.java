package com.bmp.purchase.transaction;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;

import com.bitmap.bean.parts.Vendor;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bmp.purchase.bean.VendorBean;

public class VendorTS {
	public static String tableName = "pa_vendor";
	private static String[] keys = {"vendor_id"};
	private static String[] fieldNames = {"vendor_name",
											"vendor_phone",
											"vendor_fax",
											"vendor_address",
											"vendor_email",
										  "vendor_contact",
										  "vendor_ship",
										  "vendor_condition",
										  "vendor_credit",
										  "create_by",
										  "create_date",
										  "update_by",
										  "update_date"};
	
	public static VendorBean select(String vendor_id) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		VendorBean entity = new VendorBean();
		entity.setVendor_id(vendor_id);
		select(entity);
		return entity;
	}
	public static VendorBean select(VendorBean entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}

	public static VendorBean select(String vendor_id,Connection conn) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		VendorBean entity = new VendorBean();
		entity.setVendor_id(vendor_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		return entity;
	}
}
