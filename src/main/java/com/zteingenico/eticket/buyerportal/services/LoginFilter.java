package com.zteingenico.eticket.buyerportal.services;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 类说明：防止未登录用户直接访问页面地址
 * @author 梁俊辉
 *
 */

public class LoginFilter implements Filter{

	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		HttpServletRequest httpRequest = (HttpServletRequest)request;
		HttpSession session = httpRequest.getSession();
		Object obj = session.getAttribute(SessionService.USER_INFO_SESSION_KEY);
		if(obj!=null){
			chain.doFilter(request, response);
		}else {
			HttpServletResponse httpResponse = (HttpServletResponse)response;
			httpResponse.sendRedirect(httpRequest.getContextPath()+"/login");
		}
	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {}

	
	@Override
	public void destroy() {}
}
