package com.zteingenico.eticket.buyerportal.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class ReadFile {

	public static void main(String[] args) {
		System.out.println(readFile("D:\\class.txt"));

	}

	
	
	//读文件，返回字符串
	public static String readFile(String path){
	    File file = new File(path);
	    BufferedReader reader = null;
	    String laststr = "";
	    try {
	     reader = new BufferedReader(new FileReader(file));
	     String tempString = null;

	     while ((tempString = reader.readLine()) != null) {
	      laststr = laststr + tempString;
	
	     }
	     reader.close();
	    } catch (IOException e) {
	     e.printStackTrace();
	    } finally {
	     if (reader != null) {
	      try {
	       reader.close();
	      } catch (IOException e1) {
	      }
	     }
	    }
	    return laststr;
	}
}
