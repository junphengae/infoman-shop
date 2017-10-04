package com.bmp.special.fn;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.WebUtils;

public class DateFunctional {
		private static SimpleDateFormat dateBar = new SimpleDateFormat("yyyy-mm-dd");
		private static SimpleDateFormat dateSlash = new SimpleDateFormat("dd/mm/yyyy",Locale.ENGLISH);
		
		
		/**
		 * 
		 * @param target EN format(dd/mm/yyyy)
		 * @return   timestamp
		 * @throws ParseException
		 */
		
		
		/*public static Timestamp Formatter(String target ) throws ParseException{		
			Date date = dateSlash.parse(target);	
			return new Timestamp( date.getTime());
		}*/
		
		public static Timestamp Formatter(String target ) throws ParseException{		
			Date date = dateSlash.parse(target);
			Timestamp datetime = new Timestamp( date.getTime());
			String SData = String.valueOf(datetime);
			String[] NewDate = SData.split(" ");
			String[] Newtime = String.valueOf(DBUtility.getDBCurrentDateTime()).split(" ");
			String time = Newtime[1].substring(0, 8);
			Timestamp NewDateTime = Timestamp.valueOf(NewDate[0]+" "+time);
			//System.out.println(NewDate[0]+" "+time +"----"+NewDateTime);
			return NewDateTime;
		}
		public static void main(String [] args ) throws ParseException{
			
			System.out.println( DateFunctional.Formatter("07/01/2014") );
		}
		
}
