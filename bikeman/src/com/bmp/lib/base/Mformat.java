package com.bmp.lib.base;

public class Mformat {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String a = "40.8000";
		System.out.println("666666666");
		System.out.println("MM "+Decimal(a));
	}

	public static String Decimal(String number) {
		String num = ""+number;
		String split_number[] = {""};
		String result = "";
		split_number = num.split("\\.");
		if( split_number.length > 1 ){
			if( split_number[1].length() > 2 ){
				split_number[1] = split_number[1].substring(0,2);
			}
			result = ( split_number[0]+"."+split_number[1] );
		}else{
			result = num+".00";
		}
		return result;
	} 
	
		
}
