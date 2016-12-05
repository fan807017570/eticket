package com.zteingenico.eticket.buyerportal.interceptor;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.zteingenico.eticket.business.facade.dto.fans.Member;
import com.zteingenico.eticket.business.facade.enums.member.UserType;
import com.zteingenico.eticket.business.facade.service.fans.IMemberFacadeService;
import com.zteingenico.eticket.business.facade.service.weixin.IWexinFacadeService;
import com.zteingenico.eticket.buyerportal.annotations.AllowWeixinJSApi;
import com.zteingenico.eticket.buyerportal.services.SessionService;
import com.zteingenico.eticket.buyerportal.vo.UserSessionDTO;
import com.zteingenico.eticket.common.utils.WeixinUtil;
import com.zteingenico.eticket.common.weixin.enums.OauthScope;

/**
 * 微信处理拦截器
 */
public class WeixinInterceptor extends HandlerInterceptorAdapter {

	public Logger logger = LoggerFactory.getLogger(WeixinInterceptor.class);

	@Resource
	private IWexinFacadeService weixinService;

	@Resource
	private IMemberFacadeService memberService;
	
	@Resource
	private SessionService sessionService;

	@Value("#{propertiesHolder.get('buyer_weixin_domain')}")
	private String buyer_weixin_domain;

	/** 抢红包url关键字 */
	private String hongbaoUrlKeyword = "shareget?";

	/*券列表URL关键字*/
	private String indexUrlKeyWord = "/weixin/index?";
	/*券详情URL关键字(券管理)*/
	private String couponDetailKeyWord = "/weixin/detail?";
	/*券详情URL关键字*/
	private String topicDetailKeyWord = "/weixin/topicdetail?";
	//关注页面跳转路径
	private String followUrl = "/view/weixin/follow";
	
	/**
	 * 拦截未认证的微信请求
	 */
	@Override
	public boolean preHandle(HttpServletRequest req, HttpServletResponse res, Object handler) throws Exception {
		if (handler instanceof HandlerMethod) {
			logger.info("current req url:" + req.getRequestURL());
			logger.info("current req uri:" + req.getRequestURI());
			UserSessionDTO user = sessionService.getUserInfoInSession(req);
			String currentUrl = getCurrentUrl(req);
			if (user == null) {
				String code = req.getParameter("code");
				logger.info("进入微信拦截器，当前的code值为：" + code);
				// 外部点击链接进入的情况，未登陆，也没有授权码
				if (StringUtils.isBlank(code)) {
					logger.info("currentUrl：" + currentUrl);
					String redirectUrl = WeixinUtil.getOauthPageUrl(currentUrl, OauthScope.SNSAPI_BASE, null, weixinService.getAppid());
					logger.info("用户首次进入系统，跳转到OAUTH链接获取openid：" + redirectUrl);
					// 跳转到微信OAUTH链接获取code
					res.sendRedirect(redirectUrl);
					return false;
				} else {
					//关注页面直接进入
					if(currentUrl.indexOf(followUrl ) != -1){
						return true;
					}
					// 用户通过微信授权后重定向到此处(若是在微信中访问此链接,则无交互,直接)
					String openid = weixinService.getOpenidByCode(code);
					logger.info("获取到用户的openid：" + openid);
					if (openid == null) {
						throw new IllegalStateException("无效的OAUTH code:" + code);
					}
					  
					// 添加根据openId查询微信用户基本信息
//					GetUserInfoResponse getUserInfoResponse = weixinService.getUserInfoByOpenid(openid);
//					logger.info("根据openId获取微信用户信息:{}", getUserInfoResponse);
					
					// 根据openId查询当前数据库用户对象信息
					Member member = memberService.getMemberByOpenId(openid);
					logger.info("获取member信息：" + member);
					// 如果当前用户未关注，直接跳转到关注页面，否则进行登录处理
					if (member == null || member.getFollowed() == 0) {
						// 把微信传过来的参数code和state删掉,因为已经拿到了openId了
						currentUrl = currentUrl.replaceAll("&code=[\\w]+", "").replaceAll("&state=[\\w]+", "");
						// 如果用户是点击关键链接：抢红包链接  
						if (currentUrl.indexOf(hongbaoUrlKeyword) != -1) {
							logger.info("save key url：" + currentUrl);  
							// 调用 用户服务 在 redis 中缓存 关键链接
							memberService.saveMemberKeyUrl(openid, currentUrl);
							if(StringUtils.isNotEmpty(req.getParameter("unpack"))){
								req.setAttribute("member", member);
								return true;
							}
						}
						
						/*从首页，券详情，红包详情进入*/
						if (currentUrl.indexOf(indexUrlKeyWord) != -1
								|| currentUrl.indexOf(couponDetailKeyWord) != -1
								|| currentUrl.indexOf(topicDetailKeyWord) != -1) {
							logger.info("----save new key url：" + currentUrl); 
							// 调用 用户服务 在 redis 中缓存 关键链接
							memberService.saveMemberKeyUrl(openid+"_other", currentUrl);
							//缓存分享链接中的图片地址
							if(StringUtils.isNotEmpty(req.getParameter("couponImg"))){
								logger.info("----couponImg is not null----"+req.getParameter("couponImg"));
								memberService.saveMemberKeyUrl(openid+"_other_img", req.getParameter("couponImg"));
							}
							//缓存分享链接中的标题
							if(StringUtils.isNotEmpty(req.getParameter("couponName"))){
								logger.info("----couponName is not null----"+req.getParameter("couponName"));
								memberService.saveMemberKeyUrl(openid+"_other_couponName", req.getParameter("couponName"));
							}
						}
						req.getRequestDispatcher(followUrl).forward(req, res);
						return false;
					} else {
						user = new UserSessionDTO();
						user.setUserid(member.getId());
						user.setUsername(member.getUserName());
						user.setUserType(UserType.codeOfEnum(member.getType()));
						sessionService.login(user, req);
						logger.info("首次获取到用户session信息：" + user.getUserid());
					}
				}
			} else {
				logger.info("该用户已登录：" + user.getUserid());
			}
			HandlerMethod handlerMethod = (HandlerMethod) handler;
			AllowWeixinJSApi anno = handlerMethod.getMethod().getAnnotation(AllowWeixinJSApi.class);
			if (anno != null) {
				String configStr = weixinService.getConfigParams(getCurrentUrl(req), anno.api());
				req.setAttribute("jsapiconfig", configStr);
				logger.info("当前页面的config信息为：" + configStr);
			}
		}
		return true;
	}

	private String getCurrentUrl(HttpServletRequest req) {
		String temp = req.getRequestURI().toString().substring(req.getContextPath().length() + 1, req.getRequestURI().toString().length());
		String currentUrl = buyer_weixin_domain + "/" + temp;
		if (req.getQueryString() != null) {
			currentUrl += "?" + req.getQueryString();
		}
		return currentUrl;
	}
	public static void main(String[] args) {
		System.out.println(new SimpleDateFormat("yyyyMMdd HH:mm:ss").format(new Date(1453270908625l)));
	}
}
