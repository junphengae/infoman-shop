package com.bmp.lib.util;

import java.io.UnsupportedEncodingException;
import java.sql.Timestamp;
import java.sql.Types;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

import com.bitmap.dbutils.EntityDataType;

public class UIFormatterJ {

	public static String DATA_ENCODE = "ISO8859_1";
	public static String PAGE_ENCODE = "UTF-8";
	
	public static Locale DATA_LOCALE = new Locale("en","US");
	public static Locale PAGE_LOCALE = new Locale("th","TH");
	public static Locale TH_LOCALE   = new Locale("th","TH");
	
	public static DecimalFormat DEC_FORMAT 				= new DecimalFormat("###,###,##0.00");
	public static DecimalFormat DEC_NOT_COMMAS_FORMAT	= new DecimalFormat("########0.00");
	public static DecimalFormat DOUBLE_FORMAT 			= new DecimalFormat("###,###,###.0000");
	public static DecimalFormat INT_FORMAT 				= new DecimalFormat("###,###,###");	
	public static DecimalFormat GENERAL_FORMAT 			= new DecimalFormat("################");	

	public static SimpleDateFormat DATE_FORMAT 		  = new SimpleDateFormat("dd/MM/yyyy",Locale.ENGLISH);
	public static SimpleDateFormat DATE_FORMAT_TH 	  = new SimpleDateFormat("dd/MM/yyyy",TH_LOCALE);
	public static SimpleDateFormat DATE_FORMAT_EN 	  = new SimpleDateFormat("dd/MM/yyyy",Locale.ENGLISH);
	
	public static SimpleDateFormat DATETIME_FORMAT	  = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss",Locale.ENGLISH);
	public static SimpleDateFormat DATETIME_FORMAT_TH = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss",TH_LOCALE);
	public static SimpleDateFormat DATETIME_FORMAT_EN = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss",Locale.ENGLISH);
	
	public static SimpleDateFormat DATE_DATABASE_FORMAT = new SimpleDateFormat("yyyy-MM-dd",Locale.ENGLISH);
	
	public static SimpleDateFormat LOT_FORMAT = new SimpleDateFormat("yyyyMMdd-",Locale.ENGLISH);
	
	//
	public static String getStringValue(Object obj){
		String value = "";
		if(obj!=null){
			int type = EntityDataType.getTypeNumber(obj.getClass().getSimpleName());
			switch(type){
			case Types.DATE:
				value = DATE_FORMAT.format((Date) obj);
				break;
			case Types.TIMESTAMP:
				value = DATETIME_FORMAT.format((Timestamp) obj);
				break;
			case Types.INTEGER:
				value = INT_FORMAT.format((Integer) obj);
				break;
			case Types.DOUBLE:
				value = DEC_FORMAT.format((Double) obj);
				break;
			case Types.DECIMAL:
				value = DEC_FORMAT.format((Double) obj);
				break;
			case Types.NUMERIC:
				value = getNumberValue((Number) obj);
				break;
			case Types.FLOAT:
				value = DEC_FORMAT.format((Float) obj);
				break;
			case Types.BOOLEAN:
				value = Boolean.toString( (Boolean) obj );
				break;
			default:
				value = obj.toString();
				break;
			}
		}
		return value;
	}
	//
	public static String getIdIntegerValue(Object obj){
		return getIntegerValue(obj, GENERAL_FORMAT);
	}
	public static String getIntegerValue(Object obj){
		return getIntegerValue(obj, INT_FORMAT);
	}
	//
	public static String getIntegerValue(Object obj, DecimalFormat formater){
		String value = "DataError";
		if(obj!=null){
			int type = EntityDataType.getTypeNumber(obj.getClass().getSimpleName());
			switch(type){
			case Types.INTEGER:
				value = formater.format((Integer) obj);
				break;
			case Types.DOUBLE:
				Double d = (Double) obj;
				value = formater.format(d.intValue());
				break;
			case Types.DECIMAL:
				Double d1 = (Double) obj;
				value = formater.format(d1.intValue());
				break;
			case Types.FLOAT:
				value = formater.format((Float) obj);
				break;
			}
		}
		return value;
	}
	//
	public static String getDoubleValue(Object obj){
		String value = "DataError";
		if(obj!=null){
			int type = EntityDataType.getTypeNumber(obj.getClass().getSimpleName());
			switch(type){
			case Types.INTEGER:
				value = DEC_FORMAT.format((Integer) obj);
				break;
			case Types.DOUBLE:
				Double d = (Double) obj;
				value = DEC_FORMAT.format(d.intValue());
				break;
			case Types.DECIMAL:
				Double d1 = (Double) obj;
				value = DEC_FORMAT.format(d1.intValue());
				break;
			case Types.FLOAT:
				value = DEC_FORMAT.format((Float) obj);
				break;
			}
		}
		return value;
	}
	
	public static String getDoubleNotCommasValue(Object obj){
		String value = "DataError";
		Double d = (Double) obj;
		value = DEC_NOT_COMMAS_FORMAT.format(d.intValue());
		return value;
	}
	//
	public static String getStringData(Object obj){
		String value = "";
		if(obj!=null){
			int type = EntityDataType.getTypeNumber(obj.getClass().getSimpleName());
			switch(type){
			case Types.DATE:
				value = DATE_FORMAT.format((Date) obj);
				break;
			case Types.TIMESTAMP:
				value = DATETIME_FORMAT.format((Timestamp) obj);
				break;
			case Types.INTEGER:
				Integer i = (Integer) obj;
				int j = 0;
				if (i != null) {
					j = i;
				} 
				value = ""+j;
				break;
			case Types.DOUBLE:
				value = ""+((Double) obj);
				break;
			case Types.NUMERIC:
				value = getNumberData((Number) obj);
				break;
			case Types.FLOAT:
				value = ""+((Float) obj);
				break;
			case Types.BOOLEAN:
				value = Boolean.toString( (Boolean) obj );
				break;
			default:
				value = obj.toString();
				break;
			}
		}
		return value;
	}
	//
	public static Date getDateTime(String value) throws ParseException{
		if(value==null){
			return null;
		}else{
			return DATETIME_FORMAT.parse(value);
		}
	}

	
	public static Calendar getTimeStamp(String value) throws ParseException{
		if(value==null){
			return null;
		}else{
			Locale lc= new Locale("en", "US");
			Calendar c = Calendar.getInstance(TimeZone.getDefault(),lc );
			c.setTime(DATETIME_FORMAT.parse(value));
			return c;
		}
	}
	
	public static String getLotDate(){
		return LOT_FORMAT.format(Calendar.getInstance().getTime());
	}
	
	public static String getDateDBValue(Date dd){
		if(dd==null){
			return "";
		}else{
			return DATE_DATABASE_FORMAT.format(dd);
		}
	}
	
	public static String getDateValue(Date dd){
		if(dd==null){
			return "";
		}else{
			return DATE_FORMAT.format(dd);
		}
	}
	
	public static String getDateTimeValue(Date dd){
		if(dd==null){
			return "";
		}else{
			return DATETIME_FORMAT.format(dd);
		}
	}
	
	public static String getIntStrValue(Integer value, String format){
		DecimalFormat df = INT_FORMAT;
		if(format != null){
			df = new DecimalFormat(format);
		}
		return df.format(value);
	}
	
	public static String getDecStrValue(Double value, String format){
		DecimalFormat df = DEC_FORMAT;
		if(format != null){
			df = new DecimalFormat(format);
		}
		return df.format(value);
	}
	
	public static Date getCurrentDate(){
		return Calendar.getInstance().getTime();
	}
	
	public static String getTimeStampValue(){
		return getDateTimeValue(getCurrentDate());
	}
	
	public static String getNumberValue(Number num){
		// if(Math.getExponent(num.doubleValue())>0){ // use in java6
		if(num.doubleValue()>0){ // use in java5
					return DEC_FORMAT.format(num.doubleValue());
		}else{
			return INT_FORMAT.format(num.intValue());
		}
	}
	
	public static String getNumberData(Number num){
		// if(Math.getExponent(num.doubleValue())>0){ // use in java6
		if(num.doubleValue()>0){ // use in java5
			return ""+num.doubleValue();
		}else{
			return ""+num.intValue();
		}
	}
	
	public static String encode(String str){
		String encode = null;
		try {
			if (str == null) {
				str = "";
			}
			encode = new String(str.getBytes(DATA_ENCODE), PAGE_ENCODE);
		} catch (UnsupportedEncodingException e) {
			System.out.println(e.toString());
		}
		return encode;
	}
	
	public static String dateFormat(Date date) throws ParseException{
		return DATE_FORMAT.format(date);
	}
	
	public static String dateTimeFormat(Date dateTime) throws ParseException{
		return DATETIME_FORMAT.format(dateTime);
	}
	
	
	public static int getCurrentYear(){
		Calendar c = Calendar.getInstance(TimeZone.getDefault(),Locale.ENGLISH);
		c.setTime(new Date());
		return c.get(Calendar.YEAR);
	}
	
	public static int getCurrentYearTH(){
		Calendar c = Calendar.getInstance(TimeZone.getDefault(),PAGE_LOCALE);
		c.setTime(new Date());
		return c.get(Calendar.YEAR);
	}
	
	
	public static Date getDate(String value) throws ParseException{
		if(value==null || value.length()==0){
			return null;
		}else{
			return DATE_FORMAT.parse(value);
		}
	}
	
	public static Double getDecimal(String value){
		return getDouble(value);
	}
	
	public static Double getDouble(String value){
		if(value==null || value.length()==0){
			value = "0";
		}
		return Double.parseDouble(value);
	}
	
	public static Float getFloat(String value){
		if(value==null || value.length()==0){
			value = "0";
		}
		return Float.parseFloat(value);
	}
		
	public static Integer getInteger(String value){
		if(value==null){
			value = "0";
		}
		return getFloat(value).intValue();
	}
	
	public static Number getNumeric(String value){
		Double d = Double.parseDouble(value);
		// if(Math.getExponent(d)>0){ // use in java6
		if(d>0){ // use in java5
			return d;
		}else{
			return d.intValue();
		}
	}
	
	public static Boolean getBoolean(String value) throws ParseException{
		if("Y,YES,T,TRUE,M".indexOf(value.toUpperCase())>-1){
			return true;
		}else{
			return false;
		}
	}
	
	public static boolean isNumberType(int type){
		if(type==Types.DECIMAL || type==Types.INTEGER || type==Types.NUMERIC || type==Types.FLOAT){
			return true;
		}else{
			return false;
		}
	}
	
	public static Double getDouble(Object obj){
		int type = EntityDataType.getTypeNumber(obj.getClass().getSimpleName());
		Double d = 0.00;
		switch(type){
		case Types.INTEGER:
			d = ((Integer) obj).doubleValue();
			break;
		case Types.FLOAT:
			d = ((Float) obj).doubleValue();
			break;
		case Types.DECIMAL:
			d = (Double) obj;
			break;
		case Types.NUMERIC:
			d = ((Number) obj).doubleValue();
			break;
		case Types.DOUBLE:
			d = (Double) obj;
			break;
		default: 
			d = Double.parseDouble((String) obj);
			break;
		}
		return d;
	}
	
	public static Object getObjectValue(String strValue, int type) throws ParseException{
		Object value = null;
		switch(type){
		case Types.DATE:
			value = getDate(strValue);
			break;
		case Types.TIMESTAMP:
			value = getDateTime(strValue);
			break;
		case Types.DOUBLE:
			value = getDecimal(strValue);
			break;
		case Types.DECIMAL:
			value = getDecimal(strValue);
			break;
		case Types.FLOAT:
			value = getDecimal(strValue);
			break;
		case Types.NUMERIC:
			value = getNumeric(strValue);
			break;
		case Types.INTEGER:
			value = getInteger(strValue);
			break;
		case Types.SMALLINT:
			value = getInteger(strValue);
			break;
		default:
			value = strValue;
			break;
		}
		return value;
		
	}
	
	
	public static void main(String[] args) throws Exception{
		System.out.println(""+((Double) 10.00));
		System.out.println(""+((Number) 100.23));
		System.out.println(""+((Integer) 10));
		Integer d = 200000;
		Number n = d;
		System.out.println(n.getClass().getSimpleName());
		//System.out.println(""+Math.getExponent(10000.123)); // use in java6
		System.out.println(""+getStringValue(n));
		System.out.println(""+getStringData(n));
		
		Double d1 = 200000.01;
		Integer d2 = 100000;
		System.out.println(getIntegerValue(d1));
		System.out.println(getIntegerValue(d2));
		System.out.println(getDoubleValue(d1));
		System.out.println(getDoubleValue(d2));
		System.out.println(DOUBLE_FORMAT.format(d1));
	}

}
