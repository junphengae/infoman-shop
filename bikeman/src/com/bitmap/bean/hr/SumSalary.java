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
import com.bitmap.webutils.WebUtils;


public class SumSalary {
	public static String tableName = "per_sum_salary";
	public static String[] keys = {"per_id","month","year"};
	public static String[] fieldName = {"salary_type","salary","total_salary","salary_net","ot_hrs_sum","total_ot","coco_sum","amount_coco_sum","coco_ot_sum","amount_coco_ot_sum","tax","status_tax","tax_rate","ss","savings","bonus","bal_salary","diligence","allowance","pay_advance","missing","deduction","remark","leave_missing","leave_business","leave_sick","leave_vacation","bal_business","bal_sick","bal_vacation","late_hrs_sum","late_day_sum","status","update_date","update_by"};
	
	public static String HAVE_NO_TAX = "10";
	public static String HAVE_TAX_UNSAVED = "20";
	public static String HAVE_TAX_SAVED = "30";
	
	String per_id = "";
	String salary_type = "";
	String month = "";
	String year = "";
	String salary = "";
	String total_salary = "";
	String salary_net = "";
	String ot_hrs_sum = "";
	String total_ot = "";
	String coco_sum = "";
	String amount_coco_sum = "";
	String coco_ot_sum = "";
	String amount_coco_ot_sum = "";
	String tax = "";
	String status_tax = "";
	String tax_rate = "";
	String ss = "";
	String savings = "";
	String bonus = "";
	String bal_salary = "";
	String diligence = "";
	String allowance = "";
	String pay_advance = "";
	String missing = "";
	String deduction = "";
	String remark = "";
	String leave_missing = "";
	String late_hrs_sum = "";
	String late_day_sum = "";
	String leave_business ="";
	String leave_sick = "";
	String leave_vacation = "";
	String bal_business = "";
	String bal_sick = "";
	String bal_vacation = "";
	String status = "";
	Timestamp create_date = null;
	String create_by = "";
	Timestamp update_date = null;
	String update_by = "";
	
	Salary UISalary = null;
	PersonalDetail UIPersonalDetail = null;
	
	
	public static String statusTax(String status_tax) {
		HashMap<String, String> map = new HashMap<String, String>();
		map.put(HAVE_NO_TAX, "10");
		map.put(HAVE_TAX_UNSAVED, "20");
		map.put(HAVE_TAX_SAVED, "30");
		return map.get(status_tax);
	}
	
	public static List<String[]> statusTaxList() {
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{"10","ไม่เสียภาษี"});
		list.add(new String[]{"20","เสียภาษี รอบันทึกภาษี"});
		list.add(new String[]{"30","บันทึกแล้ว"});
		return list;
	}
	
	/**
	 * Used emp_summary.jsp
	 * <br>
	 * แสดงรายการ สรุปข้อมูลพนักงาน ตามเดือนและปีที่เลือก
	 * @param params
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static SumSalary select(List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {			
					sql += " AND " + str[0] + "  ='" + str[1] + "'";		
			}
		}	
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		////System.out.println(sql);
		SumSalary entity = new SumSalary();
		while(rs.next()){
			DBUtility.bindResultSet(entity, rs);
		}	
		rs.close();
		st.close();
		conn.close();
		return entity;
	}
	
	/**
	 * Used emp_summary.jsp, EmpManageServlet.java
	 * <br>
	 * insert ข้อมูล SumSalary
	 * @param entity
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 */
	public static void insert(SumSalary entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	/**
	 * Used emp_summary_edit.jsp, EmpManageServlet
	 * <br>
	 * update ข้อมูล SumSalary
	 * @param entity
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 */
	public static void update(SumSalary entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldName, keys);
		conn.close();
	}
	
	/**
	 * Used OrgManagement
	 * <br>
	 * update ยอดวันลางานตามประเภทการลาใหม่ เมื่อมีการลบ
	 * @param per_id
	 * @param m
	 * @param y
	 * @param type
	 * @param cnt
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 */
	public static void updateCnt(String per_id,String m,String y,String leave_type_id, String cnt) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		SumSalary entity = new SumSalary();
		entity.setPer_id(per_id);
		entity.setMonth(m);
		entity.setYear(y);
		//entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		if(leave_type_id.equalsIgnoreCase("1")){
			entity.setLeave_sick(cnt);
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"leave_sick"}, keys);
		}else if(leave_type_id.equalsIgnoreCase("2")){
			entity.setLeave_business(cnt);
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"leave_business"}, keys);
		}else if(leave_type_id.equalsIgnoreCase("3")){
			entity.setLeave_vacation(cnt);
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"leave_vacation"}, keys);
		}
		conn.close();
	}	
	
	
	/**
	 * emp_summary.jsp
	 * <br>
	 * เอาค่ายอดวันลาคงเหลือรายปี ของเดือนที่แล้วมาแสดง
	 * @param month
	 * @param year
	 * @param per_id
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static SumSalary selectLimitLeave(String month,String year, String per_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException {
		
		int m = Integer.parseInt(month)-1;
		String sm = Integer.toString(m);
		
		String sql ="SELECT * FROM " +tableName+ " WHERE 1=1 AND per_id = '" +per_id+ "' AND year='" +year+ "' AND month='" +sm+ "'";
	
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		SumSalary entity = new SumSalary();
		while (rs.next()) {
			
			DBUtility.bindResultSet(entity, rs);
			
		}
		rs.close();
		st.close();
		conn.close();
		return entity;		
		
	}
	
	/**
	 * Used hr_report_review.jsp
	 * @param params
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<SumSalary> selectReport(String m,String y) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException {
		String sql ="SELECT * FROM " + tableName + " WHERE 1=1 AND month='"+m+"' AND year='"+y+"' AND salary_type = '" + Salary.TYPE_MONTH + "'";
		/*String m = "";
		String y = "";*/
		
/*		Iterator<String[]> ite = params.iterator();
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
		}*/
		
		/*if (m.length() > 0) {
			Calendar sd = Calendar.getInstance();
			sd.clear();
			sd.set(Calendar.YEAR, Integer.parseInt(y));
			sd.set(Calendar.MONTH, Integer.parseInt(m)-1);
			sd.set(Calendar.DATE, 1);
			
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			String start_date = df.format(sd.getTime());
			sd.add(Calendar.MONTH, +1);
			sd.add(Calendar.DATE, -1);
			String end_date = df.format(sd.getTime());
			sql += " AND (leave_date between '" + start_date + " 00:00:00.00' AND '" + end_date + " 23:59:59.99' )";
			
		} else {
			if (y.length() > 0) {
				sql += " AND (leave_date between '" + y + "-01-01 00:00:00.00' AND '" + y + "-12-31 23:59:59.99')";
			}
		}*/
		
		sql += " ORDER BY per_id";
		////System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SumSalary> list = new ArrayList<SumSalary>();
		while (rs.next()) {
			SumSalary entity = new SumSalary();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIPersonalDetail(PersonalDetail.select(conn, entity.getPer_id()));
			//entity.setUIPersonal(Personal.selectOnlyPerson(entity.getRequest_by(), conn));
			//entity.setUIFt_Footage(Ft_Footage.select(entity.getFootage_id(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;		
	}
	
	
	
	
	public static List<SumSalary> selectReportBySalaryType(String m,String y,String salaryType) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException {
		String sql ="SELECT * FROM " + tableName + " WHERE 1=1 AND month='"+m+"' AND year='"+y+"' AND salary_type='"+ salaryType +"'";
		sql += " ORDER BY per_id";
		////System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SumSalary> list = new ArrayList<SumSalary>();
		while (rs.next()) {
			SumSalary entity = new SumSalary();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIPersonalDetail(PersonalDetail.select(conn, entity.getPer_id()));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;		
	}
	
	/**
	 * emp_info.jsp
	 * <br>
	 * count จำนวน ยอดลาคงเหลือต่อปี
	 * @param year
	 * @param per_id
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static SumSalary countLeaveAmount(String year, String per_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT per_id , sum(leave_missing)as leave_missing, sum(leave_business) as leave_business, sum(leave_sick) as leave_sick, sum(leave_vacation) as leave_vacation FROM "+tableName+" WHERE per_id='"+per_id+"' AND year='"+year+"' group by per_id";
		// ถ้า per_id นั้นไม่เคย save ลงตาราง sum_salary จะ select ไม่เจอ (ไม่ return ค่าออกไปทำให้ error)
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		SumSalary entity = new SumSalary();
		if (rs.next()) {
			DBUtility.bindResultSet(entity, rs);
		}
		
		rs.close();
		st.close();
		conn.close();
		return entity;
		
	}
	
	
	

	
	public String getPer_id() {
		return per_id;
	}
	public void setPer_id(String per_id) {
		this.per_id = per_id;
	}
	public String getSalary_type() {
		return salary_type;
	}
	public void setSalary_type(String salary_type) {
		this.salary_type = salary_type;
	}
	public String getSalary() {
		return salary;
	}
	public void setSalary(String salary) {
		this.salary = salary;
	}
	public String getOt_hrs_sum() {
		return ot_hrs_sum;
	}
	public void setOt_hrs_sum(String ot_hrs_sum) {
		this.ot_hrs_sum = ot_hrs_sum;
	}
	public String getTax() {
		return tax;
	}
	public void setTax(String tax) {
		this.tax = tax;
	}
	public String getSs() {
		return ss;
	}
	public void setSs(String ss) {
		this.ss = ss;
	}
	public String getSavings() {
		return savings;
	}
	public void setSavings(String savings) {
		this.savings = savings;
	}
	public String getDeduction() {
		return deduction;
	}
	public void setDeduction(String deduction) {
		this.deduction = deduction;
	}
	public String getTotal_salary() {
		return total_salary;
	}
	public void setTotal_salary(String total_salary) {
		this.total_salary = total_salary;
	}
	public String getTotal_ot() {
		return total_ot;
	}
	public void setTotal_ot(String total_ot) {
		this.total_ot = total_ot;
	}
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}
	public String getUpdate_by() {
		return update_by;
	}
	public void setUpdate_by(String update_by) {
		this.update_by = update_by;
	}
	public String getMonth() {
		return month;
	}
	public void setMonth(String month) {
		this.month = month;
	}
	public String getYear() {
		return year;
	}
	public void setYear(String year) {
		this.year = year;
	}
	public String getAmount_coco_sum() {
		return amount_coco_sum;
	}
	public void setAmount_coco_sum(String amount_coco_sum) {
		this.amount_coco_sum = amount_coco_sum;
	}
	public String getAmount_coco_ot_sum() {
		return amount_coco_ot_sum;
	}
	public void setAmount_coco_ot_sum(String amount_coco_ot_sum) {
		this.amount_coco_ot_sum = amount_coco_ot_sum;
	}
	public String getPay_advance() {
		return pay_advance;
	}
	public void setPay_advance(String pay_advance) {
		this.pay_advance = pay_advance;
	}
	public String getLeave_missing() {
		return leave_missing;
	}
	public void setLeave_missing(String leave_missing) {
		this.leave_missing = leave_missing;
	}
	public String getLeave_business() {
		return leave_business;
	}
	public void setLeave_business(String leave_business) {
		this.leave_business = leave_business;
	}
	public String getLeave_sick() {
		return leave_sick;
	}
	public void setLeave_sick(String leave_sick) {
		this.leave_sick = leave_sick;
	}
	public String getLeave_vacation() {
		return leave_vacation;
	}
	public void setLeave_vacation(String leave_vacation) {
		this.leave_vacation = leave_vacation;
	}
	public String getLate_hrs_sum() {
		return late_hrs_sum;
	}
	public void setLate_hrs_sum(String late_hrs_sum) {
		this.late_hrs_sum = late_hrs_sum;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Timestamp getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}
	public Timestamp getUpdate_date() {
		return update_date;
	}
	public void setUpdate_date(Timestamp update_date) {
		this.update_date = update_date;
	}
	public Salary getUISalary() {
		return UISalary;
	}
	public void setUISalary(Salary uISalary) {
		UISalary = uISalary;
	}
	public String getBonus() {
		return bonus;
	}
	public void setBonus(String bonus) {
		this.bonus = bonus;
	}
	public String getDiligence() {
		return diligence;
	}
	public void setDiligence(String diligence) {
		this.diligence = diligence;
	}
	public String getTax_rate() {
		return tax_rate;
	}
	public void setTax_rate(String tax_rate) {
		this.tax_rate = tax_rate;
	}
	public String getBal_business() {
		return bal_business;
	}
	public void setBal_business(String bal_business) {
		this.bal_business = bal_business;
	}
	public String getBal_sick() {
		return bal_sick;
	}
	public void setBal_sick(String bal_sick) {
		this.bal_sick = bal_sick;
	}
	public String getBal_vacation() {
		return bal_vacation;
	}
	public void setBal_vacation(String bal_vacation) {
		this.bal_vacation = bal_vacation;
	}
	public String getSalary_net() {
		return salary_net;
	}
	public void setSalary_net(String salary_net) {
		this.salary_net = salary_net;
	}
	public String getCoco_sum() {
		return coco_sum;
	}
	public void setCoco_sum(String coco_sum) {
		this.coco_sum = coco_sum;
	}
	public String getCoco_ot_sum() {
		return coco_ot_sum;
	}
	public void setCoco_ot_sum(String coco_ot_sum) {
		this.coco_ot_sum = coco_ot_sum;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getAllowance() {
		return allowance;
	}

	public void setAllowance(String allowance) {
		this.allowance = allowance;
	}

	public String getMissing() {
		return missing;
	}

	public void setMissing(String missing) {
		this.missing = missing;
	}

	public String getLate_day_sum() {
		return late_day_sum;
	}

	public void setLate_day_sum(String late_day_sum) {
		this.late_day_sum = late_day_sum;
	}

	public String getBal_salary() {
		return bal_salary;
	}

	public void setBal_salary(String bal_salary) {
		this.bal_salary = bal_salary;
	}

	public PersonalDetail getUIPersonalDetail() {
		return UIPersonalDetail;
	}

	public void setUIPersonalDetail(PersonalDetail uIPersonalDetail) {
		UIPersonalDetail = uIPersonalDetail;
	}

	public String getStatus_tax() {
		return status_tax;
	}

	public void setStatus_tax(String status_tax) {
		this.status_tax = status_tax;
	}
	
	
	
}
