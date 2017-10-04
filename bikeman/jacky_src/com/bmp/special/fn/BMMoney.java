package com.bmp.special.fn;

import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;

import Component.Accounting.Money.MoneyAccounting;

import com.bitmap.utils.Money;

public class BMMoney {
	public static void main(String[] args) throws SQLException, IllegalAccessException, InvocationTargetException {
		String qty = "3";
		String price_unit ="5600";		
		String dis_p ="2.75";
		String vat ="7";
		
		
		String price_sum ="";
		String dis_bat_befor ="";
		String dis_bat_after ="";
		String net_price ="";
		String total_vat ="";
		
		price_sum = MoneyMultiple(qty, price_unit); /** a X b **/
		dis_bat_befor =MoneyDiscount(price_sum, dis_p);
		dis_bat_after = MoneyDiscountRound(price_sum, dis_p);
		net_price = MoneySubtract(price_sum, dis_bat_after);
		total_vat = MoneyVat(net_price, vat);
		System.out.println("QTY :"+Money.moneyInteger(qty)+" | PRICE@ :"+Money.money(price_unit)+" | PRICE :"+Money.money(price_sum)+" | DIS(%) :"+Money.money(dis_p)+" | DIS(฿) befor:"+Money.money(dis_bat_befor)+" | DIS(฿) after:"+Money.money(dis_bat_after)+" NET PRICE:"+Money.money(net_price));
		System.out.println("Total VAT :"+Money.money(total_vat));
		
		System.out.println(Money.subtract(vat, qty));
		
	}
	public static String MoneyVat( String a,String b ) {
		String vat = "";
		Double v = 0.00;
		Double aa = DoubleParse(removeCommas(a));
		Double bb = DoubleParse(removeCommas(b));
		v  = (aa * bb)/107;
		vat = v.toString();
		return vat;
	}
	public static String MoneyMultiple( String a,String b ) {
		String multiple = "";
		Double mul = 0.00;
		Double aa = DoubleParse(removeCommas(a));
		Double bb = DoubleParse(removeCommas(b));
		mul  = aa * bb;
		multiple = mul.toString();
		return multiple;
	}
	public static String MoneySubtract( String a,String b ) {
		String subtract = "";
		Double sub = 0.00;
		Double aa = DoubleParse(removeCommas(a));
		Double bb = DoubleParse(removeCommas(b));
		sub  = aa - bb;
		subtract = sub.toString();
		return subtract;
	}
	
	public static String MoneyDiscount( String a,String b) {
		String discount ="";
		Double dis = 0.00;
		Double aa = DoubleParse(removeCommas(a));
		Double bb = DoubleParse(removeCommas(b));
		
		dis = (aa *bb )/100;
		discount = dis.toString();
		return discount;
		
	}
	public static String MoneyDiscountRound( String a,String b) {
		String discount ="";
		Double dis = 0.00;
		Double round = 0.00;
		Double aa = DoubleParse(removeCommas(a));
		Double bb = DoubleParse(removeCommas(b));
		
		dis = (aa *bb )/100;
		round = MoneyAccounting.MoneyCeilSatangDiscount(dis);
		discount = round.toString();
		return discount;		
	}
	
	public static String removeCommas(String str)
	 {
	    return str.replaceAll(",", "");
	 }
	private static Double DoubleParse( String x) {
		Double xx=0.00;
				
		if(x.equalsIgnoreCase("")){
			xx = Double.parseDouble("0.00");
		}else{
			xx = Double.parseDouble(x);
		}		
		return xx;
		
	}

	
}
