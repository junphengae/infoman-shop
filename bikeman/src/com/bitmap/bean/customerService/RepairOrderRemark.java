package com.bitmap.bean.customerService;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;

public class RepairOrderRemark {
	public static final String tableName = "cs_repair_order_remark";
	private static String[] keys = {"id"};
	private static String[] edit_fields = {
		"bmp_f",
		"bmp_r",
		"door_fr",
		"door_fl",
		"door_rr",
		"door_rl",
		"hood",
		"trunk",
		"fender_fr",
		"fender_fl",
		"fender_rr",
		"fender_rl",
		"lamp_h",
		"lamp_t",
		"mirror_r",
		"mirror_l",
		"glass",
		"wheel",
		"detail"
	};
	
	String id = "";
	String bmp_f = "";		
	String bmp_r = "";
	String door_fr = "";
	String door_fl = "";
	String door_rr = "";
	String door_rl = "";
	String hood = "";
	String trunk = "";
	String fender_fr = "";
	String fender_fl = "";
	String fender_rr = "";
	String fender_rl = "";
	String lamp_h = "";
	String lamp_t = "";
	String mirror_r = "";
	String mirror_l = "";
	String glass = "";
	String wheel = "";
	String detail = "";
	
	public static RepairOrderRemark select(RepairOrderRemark entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static RepairOrderRemark select(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		RepairOrderRemark entity = new RepairOrderRemark();
		entity.setId(id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	private static boolean check(String id, Connection conn) throws SQLException{
		String sql = "SELECT id FROM " + tableName + " WHERE id='" + id + "'";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		boolean has = false;
		while (rs.next()) {
			has = true;
		}
		return has;
	}
	
	public static RepairOrderRemark insert(RepairOrderRemark entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		if (check(entity.getId(),conn)) { // check in database
			update(entity);
		} else {
			DBUtility.insertToDB(conn, tableName, entity);
		}
		
		conn.close();
		return entity;
	}
	
	public static void update(RepairOrderRemark entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.updateToDB(conn, tableName, entity, edit_fields, keys);
		conn.close();
	}
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getBmp_f() {
		return bmp_f;
	}
	public void setBmp_f(String bmp_f) {
		this.bmp_f = bmp_f;
	}
	public String getBmp_r() {
		return bmp_r;
	}
	public void setBmp_r(String bmp_r) {
		this.bmp_r = bmp_r;
	}
	public String getDoor_fr() {
		return door_fr;
	}
	public void setDoor_fr(String door_fr) {
		this.door_fr = door_fr;
	}
	public String getDoor_fl() {
		return door_fl;
	}
	public void setDoor_fl(String door_fl) {
		this.door_fl = door_fl;
	}
	public String getDoor_rr() {
		return door_rr;
	}
	public void setDoor_rr(String door_rr) {
		this.door_rr = door_rr;
	}
	public String getDoor_rl() {
		return door_rl;
	}
	public void setDoor_rl(String door_rl) {
		this.door_rl = door_rl;
	}
	public String getHood() {
		return hood;
	}
	public void setHood(String hood) {
		this.hood = hood;
	}
	public String getTrunk() {
		return trunk;
	}
	public void setTrunk(String trunk) {
		this.trunk = trunk;
	}
	public String getFender_fr() {
		return fender_fr;
	}
	public void setFender_fr(String fender_fr) {
		this.fender_fr = fender_fr;
	}
	public String getFender_fl() {
		return fender_fl;
	}
	public void setFender_fl(String fender_fl) {
		this.fender_fl = fender_fl;
	}
	public String getFender_rr() {
		return fender_rr;
	}
	public void setFender_rr(String fender_rr) {
		this.fender_rr = fender_rr;
	}
	public String getFender_rl() {
		return fender_rl;
	}
	public void setFender_rl(String fender_rl) {
		this.fender_rl = fender_rl;
	}
	public String getLamp_h() {
		return lamp_h;
	}
	public void setLamp_h(String lamp_h) {
		this.lamp_h = lamp_h;
	}
	public String getLamp_t() {
		return lamp_t;
	}
	public void setLamp_t(String lamp_t) {
		this.lamp_t = lamp_t;
	}
	public String getMirror_r() {
		return mirror_r;
	}
	public void setMirror_r(String mirror_r) {
		this.mirror_r = mirror_r;
	}
	public String getMirror_l() {
		return mirror_l;
	}
	public void setMirror_l(String mirror_l) {
		this.mirror_l = mirror_l;
	}
	public String getGlass() {
		return glass;
	}
	public void setGlass(String glass) {
		this.glass = glass;
	}
	public String getWheel() {
		return wheel;
	}
	public void setWheel(String wheel) {
		this.wheel = wheel;
	}
	public String getDetail() {
		return detail;
	}
	public void setDetail(String detail) {
		this.detail = detail;
	}
	
	
}
