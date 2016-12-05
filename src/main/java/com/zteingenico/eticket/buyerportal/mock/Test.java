package com.zteingenico.eticket.buyerportal.mock;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.zteingenico.eticket.common.utils.JSONUtil;

public class Test {
	
	public static void main(String[] args){
		
		Catalog lvl3 = new Catalog();
		lvl3.setId("111");
		lvl3.setName("榴莲");
		
		Catalog lvl2 = new Catalog();
		lvl2.setId("110");
		lvl2.setName("热带水果");
		lvl2.addChild(lvl3);
		
		Catalog lvl1 = new Catalog();
		lvl1.setId("100");
		lvl1.setName("新鲜水果");
		lvl1.addChild(lvl2);
		
		List<Catalog> catalogs = new ArrayList<Catalog>();
		catalogs.add(lvl1);
		List<Map<String,String>> groups = new ArrayList<Map<String,String>>();
		HashMap<String,String> g1 = new HashMap<String,String>();
		g1.put("id","1");
		g1.put("name","当前热卖");
		HashMap<String,String> g2 = new HashMap<String,String>();
		g2.put("id","2");
		g2.put("name","周周特价");
		HashMap<String,String> g3 = new HashMap<String,String>();
		g3.put("id","3");
		g3.put("name","银行周末团");
		HashMap<String,String> g4 = new HashMap<String,String>();
		g4.put("id","2");
		g4.put("name","月月惊喜");
		groups.add(g1);
		groups.add(g2);
		groups.add(g3);
		groups.add(g4);
		List<Map<String,String>> orders = new ArrayList<Map<String,String>>();
		HashMap<String,String> o1 = new HashMap<String,String>();
		o1.put("id","1");
		o1.put("name","人气最高");
		HashMap<String,String> o2 = new HashMap<String,String>();
		o2.put("id","2");
		o2.put("name","评价最好");
		HashMap<String,String> o3 = new HashMap<String,String>();
		o3.put("id","3");
		o3.put("name","最新发布");
		HashMap<String,String> o4 = new HashMap<String,String>();
		o4.put("id","2");
		o4.put("name","价值最惠");
		orders.add(o1);
		orders.add(o2);
		orders.add(o3);
		orders.add(o4);
		HashMap<String,Object> datas = new HashMap<String,Object>();
		datas.put("catalogs", catalogs);
		datas.put("groups", groups);
		datas.put("orders", orders);
		System.out.println(JSONUtil.obj2json(datas));
	
	}

}
