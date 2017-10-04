package com.bmp.lib.date.thai;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class DateDMYTH {
	public static String DATA_ENCODE = "ISO8859_1";
	public static String PAGE_ENCODE = "UTF-8";
	
	public static Locale DATA_LOCALE = new Locale("en", "US");
	public static Locale PAGE_LOCALE = new Locale("th", "TH");
	public static Locale TH_LOCALE = new Locale("th", "TH");
	  
	public static SimpleDateFormat DATE_FORMAT_TH_LONG = new SimpleDateFormat("d MMMM yyyy", TH_LOCALE);
	public static SimpleDateFormat DATE_FORMAT_TH_MY = new SimpleDateFormat("MMMM yyyy", TH_LOCALE);
	public static SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);

	public static String getDMYFullPattern(Date date)
	  {
	    if (date != null) {
	      return DATE_FORMAT_TH_LONG.format(date);
	    }
	    return "-";
	  }
	
	public static String getMYFullPattern(Date date)
	  {
	    if (date != null) {
	      return DATE_FORMAT_TH_MY.format(date);
	    }
	    return "-";
	  }
	
	public static int getMonthOfDate(Date date){
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		int month = cal.get(Calendar.MONTH)+1;
		return month ;
	} 
	
	public static int getDayOfDate(Date date){
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		int day   = cal.get(Calendar.DAY_OF_MONTH);
		return day;
	} 
	
	public static int getYearOfDate(Date date){		
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);		
		int year  = cal.get(Calendar.YEAR);		
		return year;
	}
	
	public static  String getFullDMYTH(String date1 , String date2) throws ParseException{		
		String FullDMYTH ="";
		Date d1  = 	DATE_FORMAT.parse(date1);
		Date d2  = 	DATE_FORMAT.parse(date2);
		
		//System.out.println(getDMYFullPattern(d1)+" - "+getDMYFullPattern(d2));
		
		if (getMonthOfDate(d1) == getMonthOfDate(d2) && getYearOfDate(d1) == getYearOfDate(d2)) {
			//System.out.println("--------- Month == Month && Year == Year --------");
			FullDMYTH =  getDayOfDate(d1)+" - "+getDayOfDate(d2) +" "+getMYFullPattern(d2);
		}else {
			//System.out.println("--------- Month != Month || Year != Year --------");
			FullDMYTH = getDMYFullPattern(d1)+" ถึง "+getDMYFullPattern(d2);
		}
		
	return	FullDMYTH;
	}
	
	public static  String getFullDMYTH(String date1 ) throws ParseException{		
		String FullDMYTH ="";
		Date d1  = 	DATE_FORMAT.parse(date1);
		
		if (d1 != null) {			
			FullDMYTH =  getDMYFullPattern(d1);
		}
	return	FullDMYTH;
	}
	
	public static void main(String[] args) throws ParseException   {
		/*Date date1  = 	DATE_FORMAT.parse("01/12/2014");
		Date date2  = 	DATE_FORMAT.parse("30/12/2014");
		
		System.out.println(getDMYFullPattern(date1)+" - "+getDMYFullPattern(date2));
		
		if (getMonthOfDate(date1) == getMonthOfDate(date2) && getYearOfDate(date1) == getYearOfDate(date2)) {
			System.out.println("--------- Month == Month && Year == Year --------");
			System.out.println(getDayOfDate(date1)+" - "+getDayOfDate(date2) +" "+getMYFullPattern(date2));
		}else {
			System.out.println("--------- Month != Month || Year != Year --------");
			System.out.println(getDMYFullPattern(date1)+" - "+getDMYFullPattern(date2));
		}*/
		
		System.out.println(getFullDMYTH("01/12/2014", "30/01/2015"));
		}
}
