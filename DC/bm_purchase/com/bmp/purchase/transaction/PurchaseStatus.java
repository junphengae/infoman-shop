package com.bmp.purchase.transaction;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class PurchaseStatus {
	public static String TYPE_PARTS = "P";
	public static String TYPE_INVTY = "I";
	
	public static String STATUS_CANCEL = "00";
	
	public static String STATUS_ORDER = "10";
	
	public static String STATUS_AC_APPROVED = "20";
	public static String STATUS_AC_PASS = "21";	
	public static String STATUS_AC_REPL = "22";
	public static String STATUS_AC_REJECT = "25";

	public static String STATUS_MD_APPROVED = "30";
	public static String STATUS_MD_REJECT_EDIT = "33";
	public static String STATUS_MD_REJECT = "35";
	
	public static String STATUS_PO_OPENING = "40";
	public static String STATUS_PO_OPEN = "41";
	public static String STATUS_PO_CLOSE = "42";
	public static String STATUS_PO_TERMINATE = "45";
	
	
	public static List<String[]> statusDropdown(){
		List<String[]> list = new ArrayList<String[]>();
		
		list.add(new String[]{STATUS_CANCEL, "ยกเลิก"});
		list.add(new String[]{STATUS_ORDER, "รออนุมัติ"});
		list.add(new String[]{STATUS_MD_APPROVED, "อนุมัติแล้ว"});
		list.add(new String[]{STATUS_MD_REJECT_EDIT, "รอการแก้ไข"});
		list.add(new String[]{STATUS_MD_REJECT, "ไม่อนุมัติ"});
		list.add(new String[]{STATUS_PO_OPENING, "กำลังสร้าง PO"});
		list.add(new String[]{STATUS_PO_OPEN, "เปิด PO"});
		list.add(new String[]{STATUS_PO_CLOSE, "ปิด PO"});
		list.add(new String[]{STATUS_PO_TERMINATE, "ยกเลิก PO"});
		
		return list;
	}
	
	public static List<String[]> statusDropdown4PO(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{STATUS_PO_OPENING, "กำลังสร้าง PO"});
		list.add(new String[]{STATUS_PO_OPEN, "เปิด PO"});
		list.add(new String[]{STATUS_PO_CLOSE, "ปิด PO"});
		list.add(new String[]{STATUS_PO_TERMINATE, "ยกเลิก PO"});
		return list;
	}

	public static List<String[]> statusDropdown4POapprove(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{STATUS_ORDER, "รออนุมัติ"});
		list.add(new String[]{STATUS_MD_APPROVED, "อนุมัติแล้ว"});
		list.add(new String[]{STATUS_MD_REJECT, "ไม่อนุมัติ"});

		return list;
	}
	
	public static String status(String status){
		HashMap<String , String> map = new HashMap<String, String>();
		map.put(STATUS_CANCEL, "ยกเลิก");
		map.put(STATUS_ORDER, "รออนุมัติ");
		map.put(STATUS_MD_APPROVED, "อนุมัติแล้ว");
		map.put(STATUS_MD_REJECT_EDIT, "รอการแก้ไข");
		map.put(STATUS_MD_REJECT, "ไม่อนุมัติ");
		map.put(STATUS_PO_OPENING, "กำลังสร้าง PO");
		map.put(STATUS_PO_OPEN, "เปิด PO");
		map.put(STATUS_PO_CLOSE, "ปิด PO");
		map.put(STATUS_PO_TERMINATE, "ยกเลิก PO");
		
		return map.get(status);
	}
	
	public static List<String[]> prTypeDropdown(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{TYPE_PARTS, "Parts"});
		list.add(new String[]{TYPE_INVTY, "Inventory"});
		return list;
	}
	
	public static String PR_Type(String type){
		HashMap<String , String> map = new HashMap<String, String>();
		map.put(TYPE_PARTS, "Parts");
		map.put(TYPE_INVTY, "Inventory");
		return map.get(type);
	}
	

}
