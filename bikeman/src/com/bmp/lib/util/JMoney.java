package com.bmp.lib.util;



public class JMoney extends UIFormatterJ{

	public static void main(String[] args) {
		double a = 0.00;
		double b = 110.00;
		String xx = "0";
		String yy = "110";
		for (int i = 0; i < 5000; i++) {
		a =	add(a,b);
		xx = add(xx, yy);
		}
		System.out.println(a +"***"+ xx);
		System.out.println(money(a)); 
		
	}
	
	public static String add( String a, String b){		
		Double aa = new Double(removeCommas(money(a)));
		Double bb = new Double(removeCommas(money(b)));
		return addJ(aa, bb).toString();
	}
	public static Double add( Double a, String b){		
		Double aa = new Double(removeCommas(money(a)));
		Double bb = new Double(removeCommas(money(b)));
		return addJ(aa, bb);
	}
	public static Double add( Double a, Double b){		
		Double aa = new Double(removeCommas(money(a)));
		Double bb = new Double(removeCommas(money(b)));
		return addJ(aa, bb);
	}
	public static Double addJ( Double a, Double b){		
		return a += b;
	}
	
	public static String money(Object a){
		String str = "";
		try {
			str = DEC_FORMAT.format(a);
		} catch (Exception e) {
			try {
				str = DEC_FORMAT.format(Double.parseDouble((String) a));
			} catch (Exception e2) {
				str = a + "";
			}
		}
		return str;
	}
	public static String removeCommas(String str){
		return str.replaceAll(",", "");
	}
	public static String moneyNoCommas(Object a){
		String str = "";
		try {
			str = DEC_NOT_COMMAS_FORMAT.format(a);
		} catch (Exception e) {
			try {
				str = DEC_FORMAT.format(Double.parseDouble((String) a));
			} catch (Exception e2) {
				str = a + "";
			}
		}
		return str;
	}
	
}
