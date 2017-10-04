package com.bitmap.bean.util;

import java.util.HashMap;

public class StatusUtil {
	public static String RD_CREATE = "10";
	public static String RD_ACTIVE = "110";
	
	public static String RD_SUBMIT = "20";
	public static String SAMPLE = "30";
	public static String PRE_PRODUCTION = "40";
	public static String PRODUCTION = "50";
	public static String QC_APPROVE = "60";
	public static String QC_REJECT = "70";
	public static String CUSTOMER_APPROVE = "80";
	public static String CUSTOMER_REJECT = "90";
	
	public static String ACTIVE = "100";
	public static String ON_MENU = "101";
	public static String INACTIVE = "0";
		

	public static String getStatus(String find) {
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("10", "R&D CREATE");
		map.put("20", "R&D SUBMIT");
		map.put("30", "SAMPLE");
		map.put("40", "PRE-PRODUCTION");
		map.put("50", "PRODUCTION");
		map.put("60", "QC APPROVE");
		map.put("70", "QC REJECT");
		map.put("80", "CUSTOMER APPROVE");
		map.put("90", "CUSTOMER REJECT");
		map.put("100", "ACTIVED");
		map.put("101", "ON MENU");
		map.put("0", "INACTIVE");
		map.put("110", "R&D ACTIVE");
		return map.get(find);
	}
}
