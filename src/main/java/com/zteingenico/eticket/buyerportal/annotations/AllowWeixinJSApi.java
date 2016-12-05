package com.zteingenico.eticket.buyerportal.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import com.zteingenico.eticket.common.weixin.enums.JSAPIMethod;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface AllowWeixinJSApi {
	
	public JSAPIMethod[] api();

}
