package com.bitmap.security;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.bitmap.bean.hr.Personal;
import com.bitmap.dbconnection.mysql.dbpool.*;
import com.bitmap.dbutils.DBUtility;
public class SecurityProfile {
	private boolean login = false;
	private Personal personal = new Personal();
	private List<SecuritySystem> list = new ArrayList<SecuritySystem>();
	private List<String[]> roleList = new ArrayList<String[]>();
	
	public static SecurityProfile login(SecurityUser user) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException {
		SecurityProfile profile = new SecurityProfile();
		
		Connection conn = DBPool.getConnection();
		SecurityUser securUser = SecurityUser.login(conn, user);
		
		profile.setLogin(securUser.isLogin());
		
		if (profile.isLogin()) {
			profile.setPersonal(Personal.login(conn, securUser.getUser_id()));
			profile.setList(SecuritySystem.selectListByUserId(securUser.getUser_id()));
			profile.setRoleList(SecurityRole.selectUserRole(securUser.getUser_id()));
		}
		conn.close();
		return profile;
	}
	
	public static boolean check(String id, SecurityProfile profile){
		boolean isRole = false;
		Iterator<String[]> ite = profile.getRoleList().iterator();
		while (ite.hasNext()) {
			String[] role = (String[]) ite.next();
			if (id.equalsIgnoreCase(role[0])) {
				isRole = true;
			}
		}
		return isRole;
	}

	public static void main(String[] arg) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "select * from security_role";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		while (rs.next()){
			SecurityRole entity = new SecurityRole();
			DBUtility.bindResultSet(entity, rs);
			//System.out.println(entity.getRole_id() +"_"+ entity.getRole_name());
		}
	}
	public boolean isLogin() {
		return login;
	}
	public void setLogin(boolean login) {
		this.login = login;
	}
	public Personal getPersonal() {
		return personal;
	}
	public void setPersonal(Personal personal) {
		this.personal = personal;
	}
	public List<SecuritySystem> getList() {
		return list;
	}
	public void setList(List<SecuritySystem> list) {
		this.list = list;
	}

	public List<String[]> getRoleList() {
		return roleList;
	}

	public void setRoleList(List<String[]> roleList) {
		this.roleList = roleList;
	}
}