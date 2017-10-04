package com.bitmap.utils;

import java.io.FileOutputStream;
import java.io.IOException;

import sun.misc.BASE64Decoder;

public class Base64ToImage {
	public static void toImage(String fileName, String base64) throws IOException{
		String[] temp = base64.split(",");
		new FileOutputStream(fileName).write((new BASE64Decoder()).decodeBuffer(temp[1]));
	}
}
