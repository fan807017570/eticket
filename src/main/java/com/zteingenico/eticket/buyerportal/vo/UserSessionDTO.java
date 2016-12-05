package com.zteingenico.eticket.buyerportal.vo;

import java.io.Serializable;

import com.zteingenico.eticket.business.facade.enums.member.UserType;

public class UserSessionDTO implements Serializable{
	
	private static final long serialVersionUID = 1L;

	private long userid;
	
	private String username;
	
	private UserType userType;
	
	private String isBind = "N";
	
	public boolean isVisitor(){
		if(userType==null||userType==UserType.GUEST){
			return true;
		}
		return false;
	}

	
	public String getIsBind() {
		return isBind;
	}

	public void setIsBind(String isBind) {
		this.isBind = isBind;
	}



	public long getUserid() {
		return userid;
	}

	public void setUserid(long userid) {
		this.userid = userid;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public UserType getUserType() {
		return userType;
	}

	public void setUserType(UserType userType) {
		this.userType = userType;
	}
}
