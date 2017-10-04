package com.bitmap.bean.hr;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;


import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;
import com.bitmap.webutils.WebUtils;

public class Leave {
	public static String tableName = "per_leave";
	public static String[] keys = {"per_id","leave_date"};
	public static String[] keys_del = {"per_id","leave_date","leave_type_id"};
	public static String[] fieldName = {"leave_date_end","leave_type_id","leave_remark","apv_by","apv_date","status","update_by","update_date"};
	public static String[] fieldUpdate = {"leave_type_id","leave_remark","update_by","update_date"};
	
	public static String STATUS_PENDING = "3";
	public static String STATUS_APPROVE = "1";
	public static String STATUS_CANCEL = "2";
	
	String per_id = "";
	String leave_type_id = "";
	Date leave_date = null;
	Date leave_date_end = null;
	String leave_remark = "";
	String status = "";
	String apv_by = "";
	Timestamp apv_date = null;
	Timestamp create_date = null;
	String create_by = "";
	Timestamp update_date = null;
	String update_by = "";
	
	LeaveType UILeaveType = new LeaveType();
	
	public static List<String[]> StatusList() {
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[] {"3","Pending"});
		list.add(new String[] {"1","Approve"});
		list.add(new String[] {"2","Cancel"});
		return list;
	}
	
	public static String StatusMap(String status) {
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("3", "Pending");
		map.put("1", "Approve");
		map.put("2", "Cancel");
		return map.get(status);
	}
	
	/**
	 * leave_new.jsp , EmpManageServlet
	 * @param entity
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 */
	public static void insert(Leave entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	/**
	 * Used: leave_view.jap
	 * <br>
	 * แสดงรายละเอียดการขาด ลา มาสาย 
	 * @param ctrl
	 * @param params
	 * @param per_id
	 * @param leave_type_id
	 * @param leave_type_id1
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<Leave> selectByType(PageControl ctrl,List<String[]> params, String per_id, String leave_type_id, String leave_type_id1) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " +tableName+ " WHERE 1=1 AND per_id='"+per_id+"' AND leave_type_id IN ("+leave_type_id+","+leave_type_id1+")";
		
		String m="";
		String y="";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("year")){
					y = str[1];
				} else if (str[0].equalsIgnoreCase("month")) {
					m = str[1];
				} else {
					sql += " AND " + str[0] + " LIKE '%" + str[1] + "%'";
				}
			}
		}
		
		if (m.length() > 0) {
			Calendar sd = DBUtility.calendar();
			sd.clear();
			sd.set(Calendar.YEAR, Integer.parseInt(y));
			sd.set(Calendar.MONTH, Integer.parseInt(m) - 1);
			sd.set(Calendar.DATE, 1);
			
			String s = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
			
			sd.add(Calendar.MONTH, +1);
			sd.add(Calendar.DATE, -1);
			String e = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
			
			sql += " AND (leave_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99')";
		} else {
			if (y.length() > 0) {
				sql += " AND (leave_date between '" + y + "-01-01 00:00:00.00' AND '" + y + "-12-31 23:59:59.99')";
			}
		}
		
		sql += " ORDER BY leave_date";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Leave> list = new ArrayList<Leave>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Leave entity = new Leave();
					DBUtility.bindResultSet(entity, rs);
					entity.setUILeaveType(LeaveType.select(entity.getLeave_type_id(), conn));
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		st.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
	
	/**
	 * Used: leave_manage.jsp
	 * <br>
	 * แสดงรายการ ขาด ลา มาสาย ทั้งหมด
	 * @param ctrl
	 * @param params
	 * @param per_id
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<Leave> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		String m = "";
		String y = "";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("year")){
					y = str[1];
				} else if (str[0].equalsIgnoreCase("month")) {
					m = str[1];
				} else if (str[0].equalsIgnoreCase("per_id")){
					sql += " AND " + str[0] + " = '" + str[1] + "'";
				}
				else {
					sql += " AND " + str[0] + " LIKE '%" + str[1] + "%'";
				}
			}
		}
	
		if (m.length() > 0) {
			Calendar sd = DBUtility.calendar();
			sd.clear();
			sd.set(Calendar.YEAR, Integer.parseInt(y));
			sd.set(Calendar.MONTH, Integer.parseInt(m) - 1);
			sd.set(Calendar.DATE, 1);
			
			String s = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
			
			sd.add(Calendar.MONTH, +1);
			sd.add(Calendar.DATE, -1);
			String e = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
			
			sql += " AND (leave_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99')";
		} else {
			if (y.length() > 0) {
				sql += " AND (leave_date between '" + y + "-01-01 00:00:00.00' AND '" + y + "-12-31 23:59:59.99')";
			}
		}
		
		
		sql += " ORDER BY leave_date";
		////System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Leave> list = new ArrayList<Leave>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Leave entity = new Leave();
					DBUtility.bindResultSet(entity, rs);
					entity.setUILeaveType(LeaveType.select(entity.getLeave_type_id(), conn));
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		st.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
	
	/**
	 * Used leave_manage.jsp
	 * @param ctrl
	 * @param params
	 * @param per_id
	 * @param leave_type
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<Leave> select(PageControl ctrl, List<String[]> params, String per_id, String leave_type_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 AND per_id ='" + per_id + "'";
		String m = "";
		String y = "";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("year")){
					y = str[1];
				} else if (str[0].equalsIgnoreCase("month")) {
					m = str[1];
				} else {
					sql += " AND " + str[0] + " LIKE '%" + str[1] + "%'";
				}
			}
		}
	
		if (m.length() > 0) {
			Calendar sd = DBUtility.calendar();
			sd.clear();
			sd.set(Calendar.YEAR, Integer.parseInt(y));
			sd.set(Calendar.MONTH, Integer.parseInt(m) - 1);
			sd.set(Calendar.DATE, 1);
			
			String s = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
			
			sd.add(Calendar.MONTH, +1);
			sd.add(Calendar.DATE, -1);
			String e = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
			
			sql += " AND (leave_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99')";
		} else {
			if (y.length() > 0) {
				sql += " AND (leave_date between '" + y + "-01-01 00:00:00.00' AND '" + y + "-12-31 23:59:59.99')";
			}
		}
		
		
		sql += " ORDER BY leave_date";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Leave> list = new ArrayList<Leave>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;

		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Leave entity = new Leave();
					DBUtility.bindResultSet(entity, rs);
					
					entity.setUILeaveType(LeaveType.select(entity.getLeave_type_id(), conn));
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		st.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
	
	
	/**
	 * Used hr_report_review.jsp
	 * <br>
	 * ใช้แสดงรายงาน การขาด ลา มาสาย ของพนักงาน
	 * @param params
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<Leave> selectReport(List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException {
		String sql ="SELECT * FROM " + tableName + " WHERE 1=1 AND status=1";
		String m = "";
		String y = "";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[0].length() > 0) {
				if (str[0].equalsIgnoreCase("year")) {
					y = str[1];
				} else if (str[0].equalsIgnoreCase("month")) {
					m = str[1];
				} else {
					sql += " AND " + str[0] + " LIKE '%" + str[1] + "%' ";
				}
			}
		}
		
		if (m.length() > 0) {
			Calendar sd = DBUtility.calendar();
			sd.clear();
			sd.set(Calendar.YEAR, Integer.parseInt(y));
			sd.set(Calendar.MONTH, Integer.parseInt(m)-1);
			sd.set(Calendar.DATE, 1);
			
			//SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			String start_date = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
			sd.add(Calendar.MONTH, +1);
			sd.add(Calendar.DATE, -1);
			String end_date = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
			sql += " AND (leave_date between '" + start_date + " 00:00:00.00' AND '" + end_date + " 23:59:59.99' )";
			
		} else {
			if (y.length() > 0) {
				sql += " AND (leave_date between '" + y + "-01-01 00:00:00.00' AND '" + y + "-12-31 23:59:59.99')";
			}
		}
		
		sql += " ORDER BY leave_date";
		////System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Leave> list = new ArrayList<Leave>();
		while (rs.next()) {
			Leave entity = new Leave();
			DBUtility.bindResultSet(entity, rs);
			//entity.setUIPersonal(Personal.selectOnlyPerson(entity.getRequest_by(), conn));
			//entity.setUIFt_Footage(Ft_Footage.select(entity.getFootage_id(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;		
	}

	
	/**
	 * Used emp_summary.jsp
	 * <br>
	 * sum วันลางาน(รายเดือน)
	 * @param per_id
	 * @param leave_type_id
	 * @param m
	 * @param y
	 * @param conn
	 * @return
	 * @throws SQLException
	 */
	public static String count_leave(String per_id, String leave_type_id,String m,String y) throws SQLException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT count(leave_type_id) as cnt FROM " + tableName + " WHERE per_id ='" + per_id + "' AND leave_type_id = '" + leave_type_id + "' AND status='1'";
		
		Calendar sd = DBUtility.calendar();
		sd.clear();
		sd.set(Calendar.YEAR, Integer.parseInt(y));
		sd.set(Calendar.MONTH, Integer.parseInt(m) - 1);
		sd.set(Calendar.DATE, 1);
		
		String s = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
		
		sd.add(Calendar.MONTH, +1);
		sd.add(Calendar.DATE, -1);
		String e = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
		
		sql += " AND (leave_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99')";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		String cnt = "";
		while (rs.next()) {
			cnt = DBUtility.getString("cnt", rs);
		}
		
		rs.close();
		st.close();
		conn.close();
		return cnt;
	}
	
	/**
	 * Used emp_summary.jsp, emp_summary_edit.jsp
	 * <br>
	 * ใช้ sum วันที่ลางาน (รายปี)
	 * @param per_id
	 * @param leave_type_id
	 * @param y
	 * @param m
	 * @return
	 * @throws SQLException
	 */
	public static String count_leave_year(String per_id, String leave_type_id,String y,String m) throws SQLException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT count(leave_type_id) as cnt FROM " + tableName + " WHERE per_id ='" + per_id + "' AND leave_type_id = '" + leave_type_id + "'";
		
		Calendar sd = DBUtility.calendar();
		sd.clear();
		sd.set(Calendar.YEAR, Integer.parseInt(y));
		sd.set(Calendar.MONTH, 0);
		sd.set(Calendar.DATE, 1);
		
		String s = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
		
		sd.add(Calendar.MONTH, 12);//Integer.parseInt(m) - 1);
		sd.add(Calendar.DATE, -1);
		String e = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
		
		sql += " AND (leave_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99')";
		////System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		String cnt = "";
		while (rs.next()) {
			cnt = DBUtility.getString("cnt", rs);
		}
		
		rs.close();
		st.close();
		conn.close();
		return cnt;
	}
	
	/**
	 * ได้วันทั้งหมดในเดือนนั้น ที่ไม่ได้บันทึกว่าลางาน
	 * @param year
	 * @param month
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static HashMap<String, Leave> selectMap(String year, String month, String per_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException {
		Calendar cd = DBUtility.calendar();
		cd.set(Calendar.YEAR, Integer.parseInt(year));
		cd.set(Calendar.MONTH, Integer.parseInt(month)-1);
		cd.set(Calendar.DATE, 1);
		String s = DBUtility.DATE_DATABASE_FORMAT.format(cd.getTime());
		
		cd.add(Calendar.MONTH, +1);
		cd.add(Calendar.DATE, -1);
		String e = DBUtility.DATE_DATABASE_FORMAT.format(cd.getTime());
		
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM "+tableName+" WHERE per_id='" +per_id+ "' AND (leave_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99')";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		////System.out.println(sql);
		
		HashMap<String, Leave> map = new HashMap<String, Leave>();
		while (rs.next()) {
			Leave entity = new Leave();
			DBUtility.bindResultSet(entity, rs);
			map.put(DBUtility.DATE_DATABASE_FORMAT.format(entity.getLeave_date()), entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		
		return map;
	}
	
	
	
	public static Leave select(String per_id, String leave_date) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, ParseException{
		Leave leave = new Leave();
		leave.setPer_id(per_id);
		leave.setLeave_date(DBUtility.getDate(leave_date));
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, leave, keys);
		conn.close();
		return leave;
	}
	
	public static void select(Leave entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, ParseException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public static void update(Leave entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldName, keys);
		conn.close();
	}
	
	/**
	 * Used leave_manage.jsp, OrgManagement
	 * <br>
	 * delete รายการลางาน
	 * @param entity
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 */
	public static void delete(Leave entity) throws IllegalAccessException, InvocationTargetException, SQLException{	
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, keys_del);
		conn.close();
	}
	
	/**
	 * Check ว่า Record ที่เป็นการขาดงาน นี้มีหรือยัง
	 * @param conn
	 * @param per_id
	 * @param missing_date
	 * @return
	 * @throws IllegalArgumentException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static boolean checkLeave(Connection conn,String per_id,Date missing_date,String leave_type_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException {
		Leave entity = new Leave();
		entity.setPer_id(per_id);
		entity.setLeave_date(missing_date);
		//entity.setLeave_type_id(leave_type_id);
		return DBUtility.getEntityFromDB(conn, tableName, entity, keys);
	}
	
	/**
	 * ถ้าเช็คแล้วว่าไม่มาทำงาน ให้ insert วันที่ขาดงานเหล่านั้นลงใน table Leave โดย leave_type มีค่าเป็น 6 และ status มีค่าเป็น 0
	 * @param per_id
	 * @param missing_date
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 */
	public static void insertLeave(String per_id,Date missing_date, String leave_type_id) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();
		Leave entity = new Leave();

		Calendar today = DBUtility.calendar();
		today.setTime(WebUtils.getCurrentDate());
		
		Calendar missing = DBUtility.calendar();
		missing.setTime(missing_date);
		
		if(today.after(missing)){
			entity.setPer_id(per_id);
			entity.setStatus(STATUS_PENDING);
			entity.setLeave_type_id(leave_type_id);
			entity.setLeave_date(missing_date);
			entity.setCreate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.insertToDB(conn, tableName, entity);
			conn.close();
		}else{
			
		}
		
	}
	/**
	 * ถ้าเช็คว่า record นั้นมีอยู่แล้ว ให้ทำการ update
	 * @param per_id
	 * @param missing_date
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 */
	public static void updateLeave(String per_id,Date missing_date,String leave_type_id) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();
		Leave entity = new Leave();
		entity.setPer_id(per_id);
		entity.setLeave_date(missing_date);
		entity.setLeave_type_id(leave_type_id);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldUpdate, keys);
		conn.close();
	}
	
	public static void insertOrUpdate (String per_id, Date missing_date, String leave_type_id) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();
		if (checkLeave(conn, per_id, missing_date, leave_type_id)){
			updateLeave(per_id, missing_date, leave_type_id);
		}else {
			insertLeave(per_id, missing_date, leave_type_id);
		}
		conn.close();
	}
	
	public static void updateStatusApv(Leave entity) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();	
		entity.setStatus(STATUS_APPROVE);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldName, keys);
		conn.close();
	}
	
	public static void updateStatusCancel(Leave entity) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();	
		entity.setStatus(STATUS_CANCEL);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldName, keys);
		conn.close();
	}
	
	/**
	 * emp_summary.jsp 
	 * <br>
	 * ใช้ count วันที่ missing ในแต่ละเดือน
	 * @param per_id
	 * @param leave_date
	 * @param leave_type_id
	 * @return
	 * @throws SQLException
	 */
	public static String count_missing_month(String per_id, Date leave_date,String leave_type_id) throws SQLException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT count(leave_date) as cnt FROM " + tableName + " WHERE 1=1 AND per_id = '"+per_id+"' AND leave_type_id= '"+ leave_type_id +"' AND status='1'";
		
		Calendar sd = DBUtility.calendar();
		sd.setTime(leave_date);
		sd.set(Calendar.DATE, 1);
		String start = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
		
		sd.add(Calendar.MONTH, +1);
		sd.add(Calendar.DATE, -1);
		String end = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
		
		sql += " AND (leave_date between '" + start + " 00:00:00.00' AND '" + end + " 23:59:59.99')";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String cnt = "";
		while (rs.next()) {
			cnt = DBUtility.getString("cnt", rs);
		}
		rs.close();
		st.close();
		conn.close();
		return cnt;
	}
	
	

	
	public static String count_late_month(String per_id, Date leave_date,String leave_type_id) throws SQLException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT count(leave_date) as cnt FROM " + tableName + " WHERE 1=1 AND per_id = '"+per_id+"' AND leave_type_id='" +leave_type_id+"' AND status='1'";
		
		Calendar sd = DBUtility.calendar();
		sd.setTime(leave_date);
		sd.set(Calendar.DATE, 1);
		String start = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
		
		sd.add(Calendar.MONTH, +1);
		sd.add(Calendar.DATE, -1);
		String end = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
		
		sql += " AND (leave_date between '" + start + " 00:00:00.00' AND '" + end + " 23:59:59.99')";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String cnt = "";
		while (rs.next()) {
			cnt = DBUtility.getString("cnt", rs);
		}
		rs.close();
		st.close();
		conn.close();
		return cnt;
	}
	
	public static String count_leave_half(String per_id,String leave_type_id, String year,String month) throws SQLException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT count(leave_date) as cnt FROM " + tableName + " WHERE 1=1 AND per_id='" +per_id+ "' AND leave_type_id='"+leave_type_id+"'";
		
		Calendar sd = DBUtility.calendar();
		sd.clear();
		sd.set(Calendar.YEAR, Integer.parseInt(year));
		sd.set(Calendar.MONTH, Integer.parseInt(month)-1);
		sd.set(Calendar.DATE, 1);
		String start = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
		
		sd.add(Calendar.MONTH, +1);
		sd.add(Calendar.DATE, -1);
		String end = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
		
		sql += " AND (leave_date between '" + start + " 00:00:00.00' AND '" + end + " 23:59:59.99')";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String cnt = "";
		while (rs.next()){
			cnt = DBUtility.getString("cnt", rs);
		}
		rs.close();
		st.close();
		conn.close();
		return cnt;
	}
		

	public String getPer_id() {
		return per_id;
	}
	public void setPer_id(String per_id) {
		this.per_id = per_id;
	}
	public String getLeave_remark() {
		return leave_remark;
	}
	public void setLeave_remark(String leave_remark) {
		this.leave_remark = leave_remark;
	}
	public String getApv_by() {
		return apv_by;
	}
	public void setApv_by(String apv_by) {
		this.apv_by = apv_by;
	}
	public Date getLeave_date() {
		return leave_date;
	}
	public void setLeave_date(Date leave_date) {
		this.leave_date = leave_date;
	}
	public Timestamp getApv_date() {
		return apv_date;
	}
	public void setApv_date(Timestamp apv_date) {
		this.apv_date = apv_date;
	}
	public Timestamp getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}
	public Timestamp getUpdate_date() {
		return update_date;
	}
	public void setUpdate_date(Timestamp update_date) {
		this.update_date = update_date;
	}
	public String getUpdate_by() {
		return update_by;
	}
	public void setUpdate_by(String update_by) {
		this.update_by = update_by;
	}
	public String getLeave_type_id() {
		return leave_type_id;
	}
	public void setLeave_type_id(String leave_type_id) {
		this.leave_type_id = leave_type_id;
	}
	public LeaveType getUILeaveType() {
		return UILeaveType;
	}
	public void setUILeaveType(LeaveType uILeaveType) {
		UILeaveType = uILeaveType;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Date getLeave_date_end() {
		return leave_date_end;
	}

	public void setLeave_date_end(Date leave_date_end) {
		this.leave_date_end = leave_date_end;
	}
	
	
	
	
	

	
	
	
}
