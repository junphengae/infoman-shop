package com.bmp.web.service.client.sevrlet;

public class CleanXml {
	   
	public static String CleanInvalidXmlChars(String text)
       {
           // From xml spec valid chars:
           // #x9 | #xA | #xD | [#x20-#xD7FF] | [#xE000-#xFFFD] | [#x10000-#x10FFFF]    
           // any Unicode character, excluding the surrogate blocks, FFFE, and FFFF.
           String re = "[^\\x09\\x0A\\x0D\\x20-\\xD7FF\\xE000-\\xFFFD\\x10000-x10FFFF]";
           return text.replaceAll( re, "");
       }

}
