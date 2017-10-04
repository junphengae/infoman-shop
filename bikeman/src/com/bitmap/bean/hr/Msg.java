package com.bitmap.bean.hr;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.dbpool.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class Msg {
	
	public static String tableName = "msg";
	public static String[] keys = {"msg_id"};
	public static String[] feildNames = {"receiver","message","req_status","response_by","response_date"};
	
	public static String STATUS_REQUEST = "10";
	public static String STATUS_APPROVE = "20";
	public static String STATUS_REJECT = "30";
	
	public static String REQ_TYPE = "10";
	public static String MSG_TYPE = "20";
	
	public static String NORMAL = "10";
	public static String URGENT = "20";
	

	public static String FLAG_READ = "1";
	public static String FLAG_UNREAD = "0";
	public static String FLAG_REPLY = "2";
	
	String msg_id = "";
	String receiver = "";
	String footage_id = "";
	String title = "";
	String message = "";
	String req_status = "";
	String req_type = "";
	String flag_read = FLAG_UNREAD;
	Date rec_date = null;
	String priority = "";
	String reference = "";
	String request_by = "";
	Timestamp request_date = null;
	String response_by = "";
	Timestamp response_date = null;
	

	Personal UIPer_Personal = new Personal();
	Personal UIPer = new Personal();
	Personal UIPersonal = null;
	
	String UIReceiver = "";
	
	public static List<String[]> FlagList() {
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{"1","Read"});
		list.add(new String[]{"0","Unread"});
		//list.add(new String[]{"0","Reply"});
		return list;
	}
	
	public static String Flag(String flag_read){
		HashMap<String,String> map = new HashMap<String,String>();
		map.put("1", "Read");
		map.put("0", "Unread");
		map.put("0", "Reply");
		return map.get(flag_read);
	}
	
	public static List<String[]> ReqStatusList(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{"10","Request"});
		list.add(new String[]{"20","Approve"});
		list.add(new String[]{"30","Reject"});
		return list;
	}
	
	public static String ReqStatus(String req_status){
		HashMap<String , String> map = new HashMap<String, String>();
		map.put("10","Request");
		map.put("20","Approve");
		map.put("30","Reject");
		return map.get(req_status);
	}
	
	public static List<String[]> TypeList() {
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{"10","Request"});
		list.add(new String[]{"20","Message"});
		return list;
	}
	
	public static String ReqType(String req_type) {
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("10", "Request");
		map.put("20", "Message");
		return map.get(req_type);
	}
	
	public static List<String[]> PriorList(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{"10","Normal"});
		list.add(new String[]{"20","Urgent"});
		return list;
	}
	
	public static String Priority(String priority){
		HashMap<String,String> map = new HashMap<String,String>();
		map.put("10", "Normal");
		map.put("20", "Urgent");
		return map.get(priority);
	}
	
	public static void insertReq(Msg entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setReq_type(REQ_TYPE);
		entity.setReq_status(STATUS_REQUEST);
		entity.setMsg_id(DBUtility.genNumber(conn, tableName, "msg_id"));
		entity.setRequest_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static void insertMsg(Msg entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		
		String flag = "0";
		int rec = entity.getReceiver().split(",").length;
		if (rec > 1) {
			for (int i = 1; i < rec; i++) {
				flag += ",0";
			}
		}
		entity.setFlag_read(flag);
		entity.setReq_type(MSG_TYPE);
		entity.setMsg_id(DBUtility.genNumber(conn, tableName, "msg_id"));
		entity.setRequest_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static boolean checkFlagRead(Msg entity, String per_id) throws IllegalAccessException, InvocationTargetException, SQLException{
		boolean read = false;
		String[] rec = entity.getReceiver().split(",");
		int position = -1;
		for (int i = 0; i < rec.length; i++) {
			if (rec[i].equalsIgnoreCase(per_id)) {
				position = i;
			}
		}
		
		String[] flag = entity.getFlag_read().split(",");
		
		if (position > -1) {
			read = flag[position].equalsIgnoreCase(FLAG_UNREAD);
		}
		
		return read;
	}
	
	public static void updateFlagRead(Msg entity, String per_id) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		String[] rec = entity.getReceiver().split(",");
		int position = -1;
		for (int i = 0; i < rec.length; i++) {
			if (rec[i].equalsIgnoreCase(per_id)) {
				position = i;
			}
		}
		
		String flagRead = "";
		String[] flag = entity.getFlag_read().split(",");
		for (int i = 0; i < flag.length; i++) {
			if (i == position) {
				flagRead += ",1";
			} else {
				flagRead += "," + flag[i];
			}
		}
		
		if (position > -1) {
			flagRead = flagRead.substring(1, flagRead.length());
			entity.setFlag_read(flagRead);
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"flag_read"}, keys);
		}
		
		conn.close();
	}
	
	private static void selectReceiver(Msg entity, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		String[] rec = entity.getReceiver().split(",");
		for (int i = 0; i < rec.length; i++) {
			Personal per = Personal.select(rec[i], conn);
			entity.setUIReceiver(entity.getUIReceiver() + "," + per.getName() + " " + per.getSurname());
		}
		entity.setUIReceiver(entity.getUIReceiver().substring(1, entity.getUIReceiver().length()));
	}
	
	public static void selectMsg(Msg entity) throws Exception, SQLException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();		
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIPer_Personal(Personal.select(entity.getRequest_by(), conn));
		selectReceiver(entity, conn);
		conn.close();	
	}
	
	public static void selectMsgR(Msg entity) throws Exception, SQLException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();		
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		//entity.setUIFt_Footage(Ft_Footage.select(entity.getFootage_id(), conn));
		entity.setUIPer_Personal(Personal.select(entity.getRequest_by(), conn));
		entity.setUIPer(Personal.select(entity.getResponse_by(), conn));
		selectReceiver(entity, conn);
		conn.close();	
	}
	
	public static void updateApprove(Msg entity) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();	
		entity.setReq_status(STATUS_APPROVE);
		entity.setResponse_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, feildNames, keys);
		conn.close();
	}
	
	public static void updateRej(Msg entity) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();	
		entity.setReq_status(STATUS_REJECT);
		entity.setResponse_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, feildNames, keys);
		conn.close();
	}
	
	public static List<Msg> selectWithCTRL(PageControl ctrl, List<String[]> params, String per_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 " ;
			
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
			
			sql += " AND (request_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99')";
		} else {
			if (y.length() > 0) {
				sql += " AND (request_date between '" + y + "-01-01 00:00:00.00' AND '" + y + "-12-31 23:59:59.99')";
			}
		}
		
		sql += " ORDER BY req_status";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Msg> list = new ArrayList<Msg>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Msg entity = new Msg();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIPer_Personal(Personal.select(entity.getRequest_by(), conn));
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
	
	/**
	 * Used ft_manage_request.jsp
	 * <br>
	 * แสดงรายการ request footage 
	 * @param ctrl
	 * @param params
	 * @param per_id
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<Msg> selectWithCTRLByName(PageControl ctrl, List<String[]> params, String per_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + ",footage,Personal WHERE 1=1 AND " + tableName + ".footage_id = footage.footage_id AND " + tableName + ".request_by = Personal.per_id";
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
			
			//SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			
			String s = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
			
			sd.add(Calendar.MONTH, +1);
			sd.add(Calendar.DATE, -1);
			String e = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
			
			sql += " AND (request_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99')";
		} else {
			if (y.length() > 0) {
				sql += " AND (request_date between '" + y + "-01-01 00:00:00.00' AND '" + y + "-12-31 23:59:59.99')";
			}
		}
		
		sql += " ORDER BY req_status ASC, request_date DESC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Msg> list = new ArrayList<Msg>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Msg entity = new Msg();
					DBUtility.bindResultSet(entity, rs);
					//entity.setUIFt_Footage(Ft_Footage.select(entity.getFootage_id(), conn));
					entity.setUIPer_Personal(Personal.select(entity.getRequest_by(), conn));
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
	
	/**
	 * ft_manage_request.jsp
	 * <br>
	 * count จำนวน msg ใหม่
	 * @return
	 * @throws SQLException
	 */
	public static String count_msg(String req_status) throws SQLException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT count(msg_id) as cnt FROM " + tableName + " WHERE req_status ='"+req_status+"'";
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
	 * ft_preview.jsp
	 * <br>
	 * check ว่า per_id นั้นมีการ request footage_id นั้นไปแล้วหรือยัง
	 * @param per_id
	 * @param footage_id
	 * @return
	 * @throws SQLException
	 */
	public static String check_request(String per_id,String footage_id) throws SQLException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT count(msg_id) as cnt_check FROM " + tableName + " WHERE request_by ='"+per_id+"' AND footage_id='" + footage_id + "' AND req_status = '10'";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String cnt_check = "";
		while (rs.next()) {
			cnt_check = DBUtility.getString("cnt_check", rs);
		}
		rs.close();
		st.close();
		conn.close();
		return cnt_check;
		
	}
	
	/**
	 * Used report_request.jsp
	 * <br>
	 * รายงานการขอฟุตเทจ
	 * @param params
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<Msg> selectReport(List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException {
		String sql ="SELECT * FROM " + tableName + " WHERE 1=1";
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
			sql += " AND (request_date between '" + start_date + " 00:00:00.00' AND '" + end_date + " 23:59:59.99' )";
			
		} else {
			if (y.length() > 0) {
				sql += " AND (request_date between '" + y + "-01-01 00:00:00.00' AND '" + y + "-12-31 23:59:59.99')";
			}
		}
		
		sql += " ORDER BY request_date";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Msg> list = new ArrayList<Msg>();
		while (rs.next()) {
			Msg entity = new Msg();
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
	
		
	public static List<Msg> editorSelectWithCTRLByName(PageControl ctrl, List<String[]> params, String per_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + ",footage WHERE 1=1 AND " + tableName + ".footage_id = footage.footage_id AND " + tableName+ ".request_by ='" + per_id + "'"; 
			
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
			
			//SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			
			String s = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
			
			sd.add(Calendar.MONTH, +1);
			sd.add(Calendar.DATE, -1);
			String e = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
			
			sql += " AND (request_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99')";
		} else {
			if (y.length() > 0) {
				sql += " AND (request_date between '" + y + "-01-01 00:00:00.00' AND '" + y + "-12-31 23:59:59.99')";
			}
		}
		
		sql += " ORDER BY req_status";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Msg> list = new ArrayList<Msg>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Msg entity = new Msg();
					DBUtility.bindResultSet(entity, rs);
					//entity.setUIFt_Footage(Ft_Footage.select(entity.getFootage_id(), conn));
					entity.setUIPer_Personal(Personal.select(entity.getRequest_by(), conn));
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
	
	public static List<Msg> SelectMsgWithCTRLByName(PageControl ctrl, List<String[]> params, String per_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + ",footage WHERE 1=1 AND " + tableName + ".footage_id = footage.footage_id AND " + tableName+ ".request_by ='" + per_id + "'"; 
			
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
			
			//SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			
			String s = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
			
			sd.add(Calendar.MONTH, +1);
			sd.add(Calendar.DATE, -1);
			String e = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
			
			sql += " AND (request_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99')";
		} else {
			if (y.length() > 0) {
				sql += " AND (request_date between '" + y + "-01-01 00:00:00.00' AND '" + y + "-12-31 23:59:59.99')";
			}
		}
		
		sql += " ORDER BY req_status";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Msg> list = new ArrayList<Msg>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Msg entity = new Msg();
					DBUtility.bindResultSet(entity, rs);
					//entity.setUIFt_Footage(Ft_Footage.select(entity.getFootage_id(), conn));
					entity.setUIPer_Personal(Personal.select(entity.getReceiver(), conn));
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
	
	
	public static String count_generalMsg(String per_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException {
		String sql = "SELECT * FROM " +tableName+ " WHERE msg.receiver LIKE '%" + per_id + "%' AND msg.req_type='" + MSG_TYPE + "'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		int cnt = 0;
		
		while (rs.next()) {
			Msg entity = new Msg();
			DBUtility.bindResultSet(entity, rs);
			
			if (checkFlagRead(entity, per_id)){
				cnt++;
			}
		}
		rs.close();
		st.close();
		conn.close();
		return cnt+"";
	}
	
	
	/**
	 * Used msg_list.jsp
	 * <br>
	 * แสดงรายการข้อความ ในกล่องข้อความ
	 * @param ctrl
	 * @param params
	 * @param per_id
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	
	public static List<Msg> selectGeneralWithCTRL(PageControl ctrl, List<String[]> params, String per_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + ", per_personal WHERE 1=1 AND "+ tableName + ".request_by = per_personal.per_id AND msg.receiver LIKE '%" + per_id + "%' AND msg.req_type='" + MSG_TYPE + "'";
			
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
			
			//SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			
			String s = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
			
			sd.add(Calendar.MONTH, +1);
			sd.add(Calendar.DATE, -1);
			String e = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
			
			sql += " AND (request_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99')";
		} else {
			if (y.length() > 0) {
				sql += " AND (request_date between '" + y + "-01-01 00:00:00.00' AND '" + y + "-12-31 23:59:59.99')";
			}
		}
		
		sql += " ORDER BY request_date DESC";
		////System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Msg> list = new ArrayList<Msg>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Msg entity = new Msg();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIPer_Personal(Personal.select(entity.getRequest_by(), conn));
					selectReceiver(entity, conn);
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
	
	public static List<Msg> selectSentWithCTRL(PageControl ctrl, List<String[]> params, String per_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE request_by='" + per_id + "' AND req_type='20'";
			
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
			
			//SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			
			String s = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
			
			sd.add(Calendar.MONTH, +1);
			sd.add(Calendar.DATE, -1);
			String e = DBUtility.DATE_DATABASE_FORMAT.format(sd.getTime());
			
			sql += " AND (request_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99')";
		} else {
			if (y.length() > 0) {
				sql += " AND (request_date between '" + y + "-01-01 00:00:00.00' AND '" + y + "-12-31 23:59:59.99')";
			}
		}
		
		sql += " ORDER BY request_date DESC";
		////System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Msg> list = new ArrayList<Msg>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Msg entity = new Msg();
					DBUtility.bindResultSet(entity, rs);
					
					//entity.setUIPersonal(Personal.select(entity.getReceiver(), conn));
					selectReceiver(entity, conn);
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
	
	
	
	public Personal getUIPer() {
		return UIPer;
	}

	public void setUIPer(Personal uIPer) {
		UIPer = uIPer;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}



	

	public String getMsg_id() {
		return msg_id;
	}
	public void setMsg_id(String msg_id) {
		this.msg_id = msg_id;
	}
	public String getReceiver() {
		return receiver;
	}
	public void setReceiver(String receiver) {
		this.receiver = receiver;
	}
	public String getFootage_id() {
		return footage_id;
	}
	public void setFootage_id(String footage_id) {
		this.footage_id = footage_id;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getReq_status() {
		return req_status;
	}
	public void setReq_status(String req_status) {
		this.req_status = req_status;
	}
	public String getReq_type() {
		return req_type;
	}
	public void setReq_type(String req_type) {
		this.req_type = req_type;
	}
	public Date getRec_date() {
		return rec_date;
	}
	public void setRec_date(Date rec_date) {
		this.rec_date = rec_date;
	}
	public String getPriority() {
		return priority;
	}
	public void setPriority(String priority) {
		this.priority = priority;
	}
	public String getReference() {
		return reference;
	}
	public void setReference(String reference) {
		this.reference = reference;
	}
	public String getRequest_by() {
		return request_by;
	}
	public void setRequest_by(String request_by) {
		this.request_by = request_by;
	}
	public Timestamp getRequest_date() {
		return request_date;
	}
	public void setRequest_date(Timestamp request_date) {
		this.request_date = request_date;
	}
	public String getResponse_by() {
		return response_by;
	}
	public void setResponse_by(String response_by) {
		this.response_by = response_by;
	}
	public Timestamp getResponse_date() {
		return response_date;
	}
	public void setResponse_date(Timestamp response_date) {
		this.response_date = response_date;
	}

	public String getFlag_read() {
		return flag_read;
	}

	public void setFlag_read(String flag_read) {
		this.flag_read = flag_read;
	}

	public String getUIReceiver() {
		return UIReceiver;
	}

	public void setUIReceiver(String uIReceiver) {
		UIReceiver = uIReceiver;
	}

	public Personal getUIPersonal() {
		return UIPersonal;
	}

	public void setUIPersonal(Personal uIPersonal) {
		UIPersonal = uIPersonal;
	}

	public Personal getUIPer_Personal() {
		return UIPer_Personal;
	}

	public void setUIPer_Personal(Personal uIPer_Personal) {
		UIPer_Personal = uIPer_Personal;
	}
	
	

}
