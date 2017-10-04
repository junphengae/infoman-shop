package com.bitmap.bean.hr;

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

import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.security.SecurityUser;
import com.bitmap.security.SecurityUserRole;
import com.bitmap.webutils.PageControl;
import com.bitmap.ajax.AutoComplete;
import com.bitmap.bean.service.Mechanic;

public class Personal {
	public static String tableName = "per_personal";
	private static String[] keys = {"per_id"};
	private static String[]	field = {"prefix","name","surname","emp_type","sex","mobile","email","dep_id","div_id","pos_id","date_start","create_by","date_update"};
	
	
	public static String TYPE_MONTH = "1";
	public static String TYPE_DAY = "2";
	
	private String per_id = "";
	private String tag_id = "";
	private String emp_type = "";
	private String prefix = "";
	private String name = "";
	private String surname = "";
	private String sex = "";
	private String mobile = "";
	private String email = "";
	private String div_id = "";
	private String dep_id = "";
	private String pos_id = "";
	private String branch_id = "";
	private Timestamp date_start = null;
	private Timestamp date_end = null;
	private String image = "";
	private String create_by = "";
	private Timestamp date_create = null;
	private Timestamp date_update = null;
	
	public static String empType(String type){
		HashMap<String, String> map = new HashMap<String, String>();
		map.put(TYPE_MONTH, "รายเดือน");
		map.put(TYPE_DAY, "รายวัน");
		return map.get(type);
	}
	
	public static List<String[]> empTypeList(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{"1","รายเดือน"});
		list.add(new String[]{"2","รายวัน"});
		return list;
	}
	
	private Position UIPosition = new Position();
	public Position getUIPosition() {return UIPosition;}
	public void setUIPosition(Position uIPosition) {UIPosition = uIPosition;}
	
	private Division UIDivision = new Division();
	public Division getUIDivision() {return UIDivision;}
	public void setUIDivision(Division uIDivision) {UIDivision = uIDivision;}
	
	private Department UIDepartment = new Department();
	public Department getUIDepartment() {return UIDepartment;}
	public void setUIDepartment(Department uIDepartment) {UIDepartment = uIDepartment;}
	
	private SecurityUser UISecurity = new SecurityUser();
	public SecurityUser getUISecurity() {return UISecurity;}
	public void setUISecurity(SecurityUser uISecurity) {UISecurity = uISecurity;}

	private PersonalDetail perDetail = new PersonalDetail();
	
	private SumSalary UISumSalary = null;
	private Salary UISalary = null;
	
	public static Personal login(Connection conn, String per_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Personal entity = new Personal();
		entity.setPer_id(per_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIPerDetail(PersonalDetail.select(conn, per_id));
		return entity;
	}
	
	public static Personal select(String per_id, Connection conn) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException {
		Personal entity = new Personal();
		entity.setPer_id(per_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);	
		return entity;
	}
	
	public static Personal selectOnlyPerson(String per_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Personal entity = new Personal();
		entity.setPer_id(per_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static Personal selectOnlyPerson(String per_id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Personal entity = new Personal();
		entity.setPer_id(per_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		return entity;
	}
	public static Personal select(String per_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, Exception{
		Connection conn = null;
		
		Personal entity = new Personal();
		entity.setPer_id(per_id);		
		if (!entity.getPer_id().equalsIgnoreCase("")) {
			//System.out.println(">> : "+entity.getPer_id());		
			conn = DBPool.getConnection();			
			String sql = "SELECT * FROM "+tableName+" WHERE per_id='"+entity.getPer_id()+"' ";
			//System.out.println("New : "+sql);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
					
			//DBUtility.getEntityFromDB(conn, tableName,entity, keys);
			if (rs !=null) {
				if (rs.next()) {
					
					DBUtility.bindResultSet(entity,rs);
					//System.out.println(entity.getName()); 
					entity.setUIPerDetail(PersonalDetail.select(conn, entity.getPer_id()));
					//System.out.println(enP.getPos_id());
					entity.setUIPosition(Position.select(entity.getPos_id(), conn));
					entity.setUIDivision(Division.select(entity.getDiv_id(), conn));
					entity.setUIDepartment(Department.select(entity.getDep_id(), conn));
					
					
				}
			}			
			
			st.close();
			rs.close();
			conn.close();
		}
		return entity;
		
		
	
	}
	public static void insert(Personal personal) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();
		personal.setPer_id(genPer_id(conn));
		
		////System.out.println("perid : " + personal.getPer_id());
		personal.setDate_create(DBUtility.getDBCurrentDateTime());
		if (personal.getPrefix().equalsIgnoreCase("นาย")) {
			personal.setSex("m");
		} else { 
			personal.setSex("f");
		}
		DBUtility.insertToDB(conn, tableName, personal);
		conn.close();
	}	
	
	private static String genPer_id(Connection conn) throws SQLException{
		String per_id = "00001";
		String sql = "SELECT per_id FROM " + tableName + " ORDER BY (per_id*1) DESC";
		
		ResultSet rs = conn.createStatement().executeQuery(sql);
		if (rs.next()) {
			String temp = rs.getString(1);
			
			if (temp.indexOf("dev") == -1) {
				String id = (Integer.parseInt(temp) + 100001) + "";
				per_id = id.substring(1,id.length());
			}
		}
		rs.close();
		return per_id;
	}
	
	public static List<Personal> listAll() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName;
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Personal> list = new ArrayList<Personal>();
		while (rs.next()) {
			Personal entity = new Personal();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<Personal> listByDep(String dep_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE dep_id='" + dep_id + "'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Personal> list = new ArrayList<Personal>();
		while (rs.next()) {
			Personal entity = new Personal();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<Personal> listByPosition(String pos_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE pos_id='" + pos_id + "'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Personal> list = new ArrayList<Personal>();
		while (rs.next()) {
			Personal entity = new Personal();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<String[]> listDropdown(String pos_id) throws SQLException{
		Connection conn = DBPool.getConnection();
		List<String[]> list = DBUtility.getDropDownList(conn, tableName, "per_id", new String[]{"name","surname"}, "per_id","pos_id='" + pos_id + "'");
		conn.close();
		return list;
	}
	
	public static List<AutoComplete> listByAutocomplete(String str) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE name LIKE '%" + str + "%' OR surname LIKE '%" + str + "%'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<AutoComplete> list = new ArrayList<AutoComplete>();
		while (rs.next()) {
			Personal entity = new Personal();
			AutoComplete ac = new AutoComplete();
			DBUtility.bindResultSet(entity, rs);
			ac.setId(entity.getPer_id());
			ac.setValue(entity.getName() + " " + entity.getSurname());
			list.add(ac);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<Personal> pageList(PageControl ctrl) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName;
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Personal> list = new ArrayList<Personal>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Personal entity = new Personal();
					DBUtility.bindResultSet(entity, rs);
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
	
	public static List<Personal> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 ";
		
		for (Iterator<String[]> iterator = params.iterator(); iterator.hasNext();) {
			String[] pm = (String[]) iterator.next();
			if (pm[1].length() > 0) {
				if (pm[0].equalsIgnoreCase("search")) {
					sql += " AND per_id LIKE '%" + pm[1] + "%' OR name LIKE '%" + pm[1] + "%'";
				} else {
					sql += " AND " + pm[0] + "='" + pm[1] + "'";
				}
			}
		}
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Personal> list = new ArrayList<Personal>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Personal entity = new Personal();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIPosition(Position.select(entity.getPos_id(), conn));
					entity.setUIDivision(Division.select(entity.getDiv_id(), conn));
					entity.setUIDepartment(Department.select(entity.getDep_id(), conn));
					entity.setUISecurity(SecurityUser.select(entity.getPer_id(),conn));
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
	
	public static void update(Personal entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setDate_update(DBUtility.getDBCurrentDateTime());
		if (entity.getPrefix().equalsIgnoreCase("นาย")) {
			entity.setSex("m");
		} else {
			entity.setSex("f");
		}
		//System.out.println(entity.getDate_start());
		DBUtility.updateToDB(conn, tableName, entity,field, keys);
		conn.close();
	}
	
	public static void updateImg(String per_id, String imgName) throws IllegalAccessException, InvocationTargetException, SQLException{
		Personal entity = new Personal();
		entity.setPer_id(per_id);
		entity.setImage(imgName);
		Connection conn = DBPool.getConnection();
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"image"}, keys);
		conn.close();
	}
	
	public static boolean updateTagID(String per_id, String tag_id) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		Personal check = new Personal();
		check.setTag_id(tag_id);
		boolean tag = true;
		if (!DBUtility.getEntityFromDB(conn, tableName, check, new String[] {"tag_id"})){
			Personal entity = new Personal();
			entity.setPer_id(per_id);
			entity.setTag_id(tag_id);
			tag = false;
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"tag_id"}, keys);
		}
		
		conn.close();
		return tag;
	}
	
	public static void delete(Personal entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, keys);
		PersonalDetail perDetail = new PersonalDetail();
		perDetail.setPer_id(entity.getPer_id());
		PersonalDetail.delete(perDetail);
		conn.close();
	}
	
	public static boolean checkPosition(String pos_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		Personal entity = new Personal();
		entity.setPos_id(pos_id);
		boolean empty = false ;
		empty =  DBUtility.getEntityFromDB(conn, tableName, entity, new String[] {"pos_id" });
		conn.close();
		
		return empty ;
	}
	
	public static List<Personal> reportList() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException {
		String sql = "SELECT * FROM " +tableName+ " ORDER BY per_id" ;
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Personal> list  = new ArrayList<Personal>();
		while (rs.next()) {
			Personal entity = new Personal();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIPerDetail(PersonalDetail.select(conn, entity.getPer_id()));
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
		
	}
	
	public static String countRunID(String emp_type) throws SQLException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT count(per_personal.per_id) AS cnt FROM " + tableName + ",per_salary WHERE per_personal.per_id = per_salary.per_id AND per_personal.emp_type ='" +emp_type+ "'";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		String cnt = "1";
		while (rs.next()) {
			cnt = DBUtility.getString("cnt", rs);
		}
		rs.close();
		st.close();
		conn.close();
		
		String id = (Integer.parseInt(cnt) + 1000) + "" ;
		
		return id.substring(1, id.length());
	}
	
	public static List<Mechanic> listMechanic() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String role_id = "sv_mec";
		String sql = "SELECT * FROM " + tableName + " per " +
				"INNER JOIN " + SecurityUserRole.tableName + " role ON per.per_id = role.user_id WHERE role.role_id='" + role_id + "' ORDER BY per.per_id";
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<Mechanic> list = new ArrayList<Mechanic>();
		while (rs.next()) {
			Mechanic entity = new Mechanic();
			entity.setPer_id(DBUtility.getString("per.per_id", rs));
			entity.setPrefix(DBUtility.getString("per.prefix", rs));
			entity.setName(DBUtility.getString("per.name", rs));
			entity.setSurname(DBUtility.getString("per.surname", rs));
			
			entity.setUITimeLine(Mechanic.mechanicTimeLine(entity.getPer_id(), conn));
			list.add(entity);
		}
		rs.close();
		conn.close();
		return list;
	}
	
	/**
	 * emp_sum_salary.jsp
	 * @param ctrl
	 * @param params
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<Personal> selectPerSalaryWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		
		// SELECT * FROM  per_salary s,per_personal p LEFT JOIN per_sum_salary  ps ON p.per_id = ps.per_id AND ps.month = '2' AND ps.year = '2011' 
		// WHERE p.per_id = s.per_id AND status_tax = 30
		
		String sql = "SELECT *," +
				"(SELECT s.salary FROM per_salary s WHERE p.per_id = s.per_id) AS salary," +
				"(SELECT s.flag_tax FROM per_salary s WHERE p.per_id = s.per_id) AS flag_tax " +
				"FROM per_personal p LEFT JOIN per_sum_salary ps ON p.per_id = ps.per_id ";
		String m = "";
		String y = "";
		for (Iterator<String[]> iterator = params.iterator(); iterator.hasNext();) {
			String[] pm = (String[]) iterator.next();
			if (pm[1].length() > 0) {
				 if (pm[0].equalsIgnoreCase("month")) {
					m = pm[1];
					sql += " AND ps.month ='" + m + "'";
				} else if (pm[0].equalsIgnoreCase("year")) {
					y = pm[1];
					sql += " AND ps.year ='" + y + "'";
				} else if (pm[0].equalsIgnoreCase("search")) {
					sql += " AND per_id LIKE '%" + pm[1] + "%' OR name LIKE '%" + pm[1] + "%'";
				} else {
					sql += " AND " + pm[0] + "='" + pm[1] + "'";
				}
			}
		}
		
		sql += " WHERE 1=1";
		
		for (Iterator<String[]> iterator = params.iterator(); iterator.hasNext();) {
			String[] pm = (String[]) iterator.next();
			if (pm[1].length() > 0) {
				 if (pm[0].equalsIgnoreCase("status_tax")) {
					sql += " AND ps." + pm[0] + "='" + pm[1] + "'";
				}
			}
		}
		
		sql += " ORDER BY (p.per_id*1)";
		////System.out.println(sql);
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Personal> list = new ArrayList<Personal>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Personal entity = new Personal();
					DBUtility.bindResultSet(entity, rs);
					
					SumSalary sumsalary = new SumSalary();
					DBUtility.bindResultSet(sumsalary, rs);
					
					Salary salary = new Salary();
					DBUtility.bindResultSet(salary, rs);
					
					entity.setUISumSalary(sumsalary);
					entity.setUISalary(salary);
					
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
	
	public PersonalDetail getUIPerDetail() {
		return perDetail;
	}
	public void setUIPerDetail(PersonalDetail perDetail) {
		this.perDetail = perDetail;
	}
	public String getPer_id() {
		return per_id;
	}
	public void setPer_id(String per_id) {
		this.per_id = per_id;
	}
	public String getTag_id() {
		return tag_id;
	}
	public void setTag_id(String tag_id) {
		this.tag_id = tag_id;
	}
	public String getPrefix() {
		return prefix;
	}
	public void setPrefix(String prefix) {
		this.prefix = prefix;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getSurname() {
		return surname;
	}
	public void setSurname(String surname) {
		this.surname = surname;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getDiv_id() {
		return div_id;
	}
	public void setDiv_id(String div_id) {
		this.div_id = div_id;
	}
	public String getDep_id() {
		return dep_id;
	}
	public void setDep_id(String dep_id) {
		this.dep_id = dep_id;
	}
	public String getPos_id() {
		return pos_id;
	}
	public void setPos_id(String pos_id) {
		this.pos_id = pos_id;
	}
	public String getBranch_id() {
		return branch_id;
	}
	public void setBranch_id(String branch_id) {
		this.branch_id = branch_id;
	}
	
	public Timestamp getDate_start() {
		return date_start;
	}

	public void setDate_start(Timestamp date_start) {
		this.date_start = date_start;
	}

	public Timestamp getDate_end() {
		return date_end;
	}

	public void setDate_end(Timestamp date_end) {
		this.date_end = date_end;
	}

	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}
	public Timestamp getDate_create() {
		return date_create;
	}
	public void setDate_create(Timestamp date_create) {
		this.date_create = date_create;
	}
	public Timestamp getDate_update() {
		return date_update;
	}
	public void setDate_update(Timestamp date_update) {
		this.date_update = date_update;
	}
	public String getEmp_type() {
		return emp_type;
	}
	public void setEmp_type(String emp_type) {
		this.emp_type = emp_type;
	}

	public SumSalary getUISumSalary() {
		return UISumSalary;
	}

	public void setUISumSalary(SumSalary uISumSalary) {
		UISumSalary = uISumSalary;
	}

	public Salary getUISalary() {
		return UISalary;
	}

	public void setUISalary(Salary uISalary) {
		UISalary = uISalary;
	}

	
}