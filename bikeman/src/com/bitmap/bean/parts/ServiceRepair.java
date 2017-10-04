package com.bitmap.bean.parts;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.bitmap.bean.customerService.RepairOrder;
import com.bitmap.bean.hr.Personal;
import com.bitmap.bean.service.RepairLaborTime;
import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class ServiceRepair {
	public static String tableName = "service_repair";
	public static String[] keys = {"id"};
	public static String[] fieldNames = {"repair_type","driven_by","driven_contact","fuel_level","mile","problem","note","due_date","update_by","update_date","flag"};
	
	public static String TYPE_WARRANTY = "10";//ค่าบริการ
	public static String TYPE_REPAIR = "11";//รายการสินค้าและค่าบริการ
	public static String TYPE_INSURANCE = "12";//รายการสินค้า

	
	private static String[] field_status = {"flag","update_by","update_date"};
	
	String id = "";
	String repair_type = "";
	String driven_by = "";
	String driven_contact = "";
	String fuel_level = "";
	String mile = "";
	String problem = "";
	String note = "";
	Date due_date = null;
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	String flag = "";
	Map UImap = null;


	public static String getUIStatusTH(ServiceRepair entity) throws IllegalArgumentException, UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String status = entity.getFlag();
		String jobStatus = "-";
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_QT)) {
			jobStatus = "รอออกใบเสนอราคาให้ลูกค้า";
		} else
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_SA)) {
			jobStatus = "กำลังเลือกช่าง";
		} else
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_OPENED_JOB)) {
			jobStatus = "กำลังรอช่างเปิดงานซ่อม";
		} else 
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_ACTIVATE)) {
			jobStatus = RepairLaborTime.selectClosedStatus(entity.getId()) + " (งานที่เสร็จ / งานทั้งหมด)";
		} else 
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_QC)) {
			jobStatus = "กำลังตรวจสอบคุณภาพ";
		} else 
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_SUBMIT)) {
			jobStatus = "ตรวจสอบคุณภาพผ่าน เตรียมส่งรถ";
		} else 
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_REJECT)) {
			jobStatus = "ตรวจสอบคุณภาพไม่ผ่าน กำลังกลับไปแก้ไข";
		} else 
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_HOLDPART)) {
			jobStatus = "กำลังรออะไหล่";
		} else 
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_HOLD_OUTSOURCE)) {
			jobStatus = "ส่งซ่อมอู่นอก";
		}  else 
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_CS)) {
			jobStatus = "รอเปิดการซ่อม";
		}  else 
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_FINISH)) {
			jobStatus = "รอออกใบแจ้งหนี้";
		}  else 
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_ACCOUNT)) {
			jobStatus = "กำลังตรวจสอบจากฝ่ายการเงิน";
		}  else 
		if (status.equalsIgnoreCase(RepairLaborTime.STATUS_SUCCESS)) {
			jobStatus = "จบงาน";
		}
		return jobStatus;
	}
	
	public static String repairType(String status){
		HashMap<String, String> map = new HashMap<String, String>();
	
		map.put(TYPE_INSURANCE, "Product");
		map.put(TYPE_REPAIR, "Product &amp; Service");
		return map.get(status);
	}
	
	public static String repairType_th(String status){
		HashMap<String, String> map = new HashMap<String, String>();
	
		map.put(TYPE_INSURANCE, "ซื้อสินค้า");//12
		map.put(TYPE_WARRANTY, "บริการ");//10
		map.put(TYPE_REPAIR, "ซื้อสินค้าและบริการ");//11
		
		
		return map.get(status);
	}
	
	
	public static List<String[]> repair_type_alert(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{TYPE_INSURANCE,"รายการสินค้า"});
		list.add(new String[]{TYPE_REPAIR,"รายการสินค้าและค่าบริการ"});
		list.add(new String[]{TYPE_WARRANTY,"ค่าบริการ"});
	
		return list;
	}
	
	public static List<String[]> ddl_repair_type_en(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{TYPE_INSURANCE,"Product"});
		list.add(new String[]{TYPE_REPAIR,"Product &amp; Service"});
		list.add(new String[]{TYPE_WARRANTY,"Service"});
	
		return list;
	}
	
	public static List<String[]> ddl_repair_type_th(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{TYPE_INSURANCE,"ซื้อสินค้า"});
		list.add(new String[]{TYPE_WARRANTY,"บริการ"});
		list.add(new String[]{TYPE_REPAIR,"ซื้อสินค้าและบริการ"});
		return list;
	}
	
	public static void insert(ServiceSale svs) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		ServiceRepair entity = new ServiceRepair();
		entity.setId(svs.getId());
		entity.setCreate_by(svs.getCreate_by());
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static ServiceRepair select(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		ServiceRepair entity = new ServiceRepair();
		entity.setId(id);	
		//System.out.println("service repair : "+entity.getId());
		if ( !entity.getId().equalsIgnoreCase("") ) {			
			Connection conn = DBPool.getConnection();
			DBUtility.getEntityFromDB(conn, tableName, entity, keys);		
			conn.close();
		}
		return entity;
	}
	
	public static void update(ServiceRepair entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public static List<ServiceRepair> list4InboxService(PageControl ctrl) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException {
		String sql = "SELECT * FROM " + tableName + " WHERE flag ='" + RepairLaborTime.STATUS_CS + "' OR flag='" + RepairLaborTime.STATUS_QT + "' order by due_date asc";
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		//System.out.println(sql);
		List<ServiceRepair> list = new ArrayList<ServiceRepair>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					ServiceRepair entity = new ServiceRepair();
					DBUtility.bindResultSet(entity, rs);
					list.add(entity);
				}
				cnt++;
			}
		}
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		rs.close();
		conn.close();
		return list;
	}
	
	public static List<ServiceRepair> list4ViewJob(PageControl ctrl) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException {
		String sql = "SELECT * FROM " + tableName + " WHERE flag !='" + RepairLaborTime.STATUS_CS + "' AND flag !='" + RepairLaborTime.STATUS_FINISH + "' AND flag !='" + RepairLaborTime.STATUS_QT + "' AND flag !='" + RepairLaborTime.STATUS_ACCOUNT + "' AND flag !='" + RepairLaborTime.STATUS_SUCCESS + "' ";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<ServiceRepair> list = new ArrayList<ServiceRepair>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					ServiceRepair entity = new ServiceRepair();
					DBUtility.bindResultSet(entity, rs);
					list.add(entity);
				}
				cnt++;
			}
		}
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		rs.close();
		conn.close();
		return list;
	}
	
	public static List<ServiceRepair> list4QC(PageControl ctrl) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException {
		String sql = "SELECT * FROM " + tableName + " WHERE flag ='" + RepairLaborTime.STATUS_QC + "' ORDER BY CAST(create_date AS DATETIME) ASC";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<ServiceRepair> list = new ArrayList<ServiceRepair>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					ServiceRepair entity = new ServiceRepair();
					DBUtility.bindResultSet(entity, rs);
					list.add(entity);
				}
				cnt++;
			}
		}
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		rs.close();
		conn.close();
		return list;
	}
	
	
	
	public static void active(ServiceRepair entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setFlag(RepairLaborTime.STATUS_ACTIVATE);
		DBUtility.updateToDB(conn, tableName, entity, field_status, keys);
	}
	
	public static void close(ServiceRepair entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setFlag(RepairLaborTime.STATUS_QC);
		DBUtility.updateToDB(conn, tableName, entity, field_status, keys);
	}
	public static void reject(ServiceRepair entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setFlag(RepairLaborTime.STATUS_REJECT);
		DBUtility.updateToDB(conn, tableName, entity, field_status, keys);
	}
	public static void submit(ServiceRepair entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setFlag(RepairLaborTime.STATUS_SUBMIT);
		DBUtility.updateToDB(conn, tableName, entity, field_status, keys);
	}
	
	
public static List<ServiceRepairDetail> listreport(List<String[]> paramsList) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 " ;
		
		Iterator<String[]> ite = paramsList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {

				if (str[0].equalsIgnoreCase("create_date")){
					
					sql +="AND DATE_FORMAT(create_date, '%Y-%m-%d')='"+str[1]+"' " ;
					
				} 
				else if (str[0].equalsIgnoreCase("year_month")){
					
					sql +="AND DATE_FORMAT(create_date, '%Y-%m')='"+str[1]+"' " ;
					
				} 
				else if (str[0].equalsIgnoreCase("date_send2")){
					
					sql +="AND DATE_FORMAT(create_date, '%Y-%m-%d') BETWEEN '"+str[1]+"' AND '"+str[2]+"' ";
					
				}
				
				else {
					
					sql += " AND " + str[0] + "='" + str[1] + "' ";
				}
			}
		}
		
		sql += " ORDER BY (id*1) desc ";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<ServiceRepairDetail> list = new ArrayList<ServiceRepairDetail>();
		while (rs.next()) {
			ServiceRepairDetail entity = new ServiceRepairDetail();
			DBUtility.bindResultSet(entity, rs);
			
			Map map = new HashMap();
			
			map.put(Personal.tableName, Personal.select(entity.getCreate_by(), conn));
			entity.setUImap(map);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}



	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getRepair_type() {
		return repair_type;
	}

	public void setRepair_type(String repair_type) {
		this.repair_type = repair_type;
	}

	public String getDriven_by() {
		return driven_by;
	}

	public void setDriven_by(String driven_by) {
		this.driven_by = driven_by;
	}

	public String getDriven_contact() {
		return driven_contact;
	}

	public void setDriven_contact(String driven_contact) {
		this.driven_contact = driven_contact;
	}

	public String getFuel_level() {
		return fuel_level;
	}

	public void setFuel_level(String fuel_level) {
		this.fuel_level = fuel_level;
	}

	public String getMile() {
		return mile;
	}

	public void setMile(String mile) {
		this.mile = mile;
	}

	public String getProblem() {
		return problem;
	}

	public void setProblem(String problem) {
		this.problem = problem;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public Date getDue_date() {
		return due_date;
	}

	public void setDue_date(Date due_date) {
		this.due_date = due_date;
	}

	public String getCreate_by() {
		return create_by;
	}

	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}

	public Timestamp getCreate_date() {
		return create_date;
	}

	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}

	public String getUpdate_by() {
		return update_by;
	}

	public void setUpdate_by(String update_by) {
		this.update_by = update_by;
	}

	public Timestamp getUpdate_date() {
		return update_date;
	}

	public void setUpdate_date(Timestamp update_date) {
		this.update_date = update_date;
	}	
	
	public String getFlag() {
		return flag;
	}
	
	public void setFlag(String flag) {
		this.flag = flag;
	}

	public Map getUImap() {
		return UImap;
	}

	public void setUImap(Map uImap) {
		UImap = uImap;
	}

	public static void UpdateDate(String update_by,String id ) throws SQLException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		String sql = "UPDATE "+tableName+" SET update_by= '"+update_by+"' ,update_date= '"+DBUtility.getDBCurrentDateTime()+"' WHERE id = '"+id+"' ";
		//System.out.println(sql);
		Statement st = conn.createStatement();
		int rs = st.executeUpdate(sql);		
		conn.close();
		
	}

	

}