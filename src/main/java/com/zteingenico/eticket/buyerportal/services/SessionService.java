package com.zteingenico.eticket.buyerportal.services;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.zteingenico.eticket.business.facade.enums.member.UserType;
import com.zteingenico.eticket.business.facade.service.fans.IMemberFacadeService;
import com.zteingenico.eticket.buyerportal.vo.UserSessionDTO;
import com.zteingenico.eticket.common.utils.ClientEnvUtil;

@Service
public class SessionService {
	Logger log = Logger.getLogger(SessionService.class);

	public static final String USER_INFO_SESSION_KEY = "portal_userinfo_session_key";

	public static final String USERAGENT_SESSION_KEY = "portal_useragent_session_key";
	
	/** 保存用户未关注前点击的链接，可在用户关注后使用 */
	public static final String USER_URL_SESSION_KEY = "portal_userurl_session_key";
	
	/** 免费券token的session key */
	public static final String FREECOUPON_TOKEN_SESSION_KEY = "freecoupon_token_session_key";
	
	@Resource
	private IMemberFacadeService memberService;
	
	@Value("#{propertiesHolder.get('dev_mode')}")
	private boolean devMode;

	public UserSessionDTO getUserInfoInSession(HttpServletRequest req) {
		HttpSession session = req.getSession(false);
		UserSessionDTO user = null;
		// 游客访问的情况
		if (session == null
				|| session.getAttribute(USER_INFO_SESSION_KEY) == null) {
			//TODO:开发模式代码
			if(devMode){
				user = new UserSessionDTO();
				user.setUsername("测试用户");
				user.setUserType(UserType.CHEWUSER);
				user.setUserid(29);
			}else{
				return null;
			}
		} else {
			user = (UserSessionDTO) session.getAttribute(USER_INFO_SESSION_KEY);
			// 检查用户是否 关注公众号（有可能用户在操作中，取消了关注，但session仍保留了用户信息）
			if(user!=null && user.getUserType() == UserType.WECHAT && 
					!memberService.isMemberSubscribe(user.getUserid())) {
				session.removeAttribute(USER_INFO_SESSION_KEY);
				user = null;
			}
		}
		return user;
	}

	public void login(UserSessionDTO user, HttpServletRequest req) {
		HttpSession session = req.getSession();
		session.setAttribute(USER_INFO_SESSION_KEY, user);
		String userAgent = req.getHeader("USER-AGENT").toLowerCase();
		if (null == userAgent) {
			userAgent = "";
		}
		boolean isFromMobile = ClientEnvUtil.check(userAgent);
		session.setAttribute(USERAGENT_SESSION_KEY, isFromMobile);
	}

	public boolean isMobile(HttpServletRequest req) {
		HttpSession session = req.getSession(false);
		if (session == null
				|| session.getAttribute("USERAGENT_SESSION_KEY") == null) {
			String userAgent = req.getHeader("USER-AGENT").toLowerCase();
			if (null == userAgent) {
				userAgent = "";
			}
			return ClientEnvUtil.check(userAgent);
		} else {
			return (Boolean) session.getAttribute("USERAGENT_SESSION_KEY");
		}
	}

	public void saveSessionUserUrl(HttpServletRequest req, String url) {
		HttpSession session = req.getSession(false);
		if(session != null) {
			// 清除微信增加的request参数
			url = url.replaceAll("&from=[\\w]+", "").replaceAll("&isappinstalled=[\\w]+", "");
			session.setAttribute(
					USER_URL_SESSION_KEY, 
					url);
		}
	}
	
	public String getSessionUserUrl(HttpServletRequest req) {
		HttpSession session = req.getSession(false);
		if(session != null) {
			return (String)session.getAttribute(USER_URL_SESSION_KEY);
		}
		return null;
	}
	
	public void saveSessionFreeCouponToken(HttpServletRequest req) {
		HttpSession session = req.getSession(false);
		if(session!=null) {
			session.setAttribute(
					FREECOUPON_TOKEN_SESSION_KEY, 
					"freecoupon_token");
		}
	}
	
	public boolean hasSessionFreeCouponToken(HttpServletRequest req) {
		HttpSession session = req.getSession(false);
		if(session!=null) {
			if(session.getAttribute(FREECOUPON_TOKEN_SESSION_KEY)!=null) {
				return true;
			}
		}
		return false;
	}
	
	public void removeSessionFreeCouponToken(HttpServletRequest req) {
		HttpSession session = req.getSession(false);
		if(session!=null) {
			session.removeAttribute(FREECOUPON_TOKEN_SESSION_KEY); 
		}
	}
	public void setSessionUserType(HttpServletRequest req,UserType userType)
	{
		HttpSession session=req.getSession(false);
		if(session!=null)
		{
			UserSessionDTO userInfo=(UserSessionDTO) session.getAttribute(USER_INFO_SESSION_KEY);
			userInfo.setUserType(userType);
			session.setAttribute(USER_INFO_SESSION_KEY,userInfo);
		}
	}
}
