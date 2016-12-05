package com.zteingenico.eticket.buyerportal.mock;

import java.util.ArrayList;
import java.util.List;

public class Catalog {
	
	private String id;
	
	private String name;
	
	private List<Catalog> children;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public List<Catalog> getChildren() {
		return children;
	}

	public void setChildren(List<Catalog> children) {
		this.children = children;
	}
	
	public void addChild(Catalog child){
		if(children==null){
			children = new ArrayList<Catalog>();
			children.add(child);
		}
	}
}
