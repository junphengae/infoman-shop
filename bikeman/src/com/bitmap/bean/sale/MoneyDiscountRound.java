package com.bitmap.bean.sale;

import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;

import com.bitmap.utils.Money;

import Component.Accounting.Money.MoneyAccounting;


public class MoneyDiscountRound {
	public static void main(String[] arg) throws SQLException, IllegalAccessException, InvocationTargetException{
		
		//MoneyDiscountRound.disRound("92","10");
		//MoneyDiscountRound.disRound(92.00, 10.00);
	}
	public static  String disRound(String a,String b) throws SQLException, IllegalAccessException, InvocationTargetException
	{
		
		Double dis;
		Double dis_round;
		Double dis_sub;
		String discount;
		Double a1;
		Double b1;
		if(a.equalsIgnoreCase("")){
			a1 = Double.parseDouble("0");
		}else{
			a1 = Double.parseDouble(a);
		}
		if(b.equalsIgnoreCase("")){	
			b1 = Double.parseDouble("0");
		}else{
			b1 = Double.parseDouble(b);
		}
		dis = (a1 * b1) / 100 ;
		dis_round = MoneyAccounting.MoneyCeilSatangDiscount(dis);
		dis_sub = (a1 - dis_round);
		discount = String.valueOf(dis_sub);
		
		return discount;

	}
	public static  String disRound(Double a,Double b) throws SQLException, IllegalAccessException, InvocationTargetException
	{
		Double dis;
		Double dis_round;
		Double dis_sub;
		String discount;
		
		dis = (a * b) / 100 ;
		dis_round = MoneyAccounting.MoneyCeilSatangDiscount(dis);
		dis_sub = (a - dis_round);
		discount = String.valueOf(dis_sub);
		return discount;
	
 
	}
}