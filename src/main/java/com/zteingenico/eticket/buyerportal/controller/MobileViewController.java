package com.zteingenico.eticket.buyerportal.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.http.HttpHost;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.zteingenico.eticket.business.facade.dto.buyerportal.CheckTopicResultDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.ConfirmOrderDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.CouponDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.CouponDetailDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.HongbaoInfoDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.MemMemberDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.OrderDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.RefundInfoDTO;
import com.zteingenico.eticket.business.facade.dto.fans.Member;
import com.zteingenico.eticket.business.facade.dto.fans.MemberDTO;
import com.zteingenico.eticket.business.facade.dto.logisticsorder.CpnOwnerAddressDto;
import com.zteingenico.eticket.business.facade.dto.verify.OperateLogDTO;
import com.zteingenico.eticket.business.facade.dto.verify.OperateTableDTO;
import com.zteingenico.eticket.business.facade.dto.verify.RespApp027DTO;
import com.zteingenico.eticket.business.facade.dto.verify.RespWeb033DTO;
import com.zteingenico.eticket.business.facade.enums.buyerportal.ClickHongbaoUrlUserType;
import com.zteingenico.eticket.business.facade.enums.buyerportal.ReceiveCouponResult;
import com.zteingenico.eticket.business.facade.enums.coupon.OrderStatus;
import com.zteingenico.eticket.business.facade.enums.member.UserType;
import com.zteingenico.eticket.business.facade.service.buyerportal.IBuyerPortalCouponFacadeService;
import com.zteingenico.eticket.business.facade.service.buyerportal.IBuyerPortalOrderFacadeService;
import com.zteingenico.eticket.business.facade.service.buyerportal.IBuyerPortalShareFacadeService;
import com.zteingenico.eticket.business.facade.service.buyerportal.IBuyerPortalTopicFacadeService;
import com.zteingenico.eticket.business.facade.service.cpnweb.ICpnwebFacadeService;
import com.zteingenico.eticket.business.facade.service.fans.IMemberFacadeService;
import com.zteingenico.eticket.business.facade.service.logisticsorder.IOwnerAddressFacadeService;
import com.zteingenico.eticket.business.facade.service.order.ICpnOrderHeaderFacadeService;
import com.zteingenico.eticket.business.facade.service.verify.IVerifyFacadeService;
import com.zteingenico.eticket.business.facade.service.weixin.IWexinFacadeService;
import com.zteingenico.eticket.buyerportal.annotations.AllowWeixinJSApi;
import com.zteingenico.eticket.buyerportal.services.SessionService;
import com.zteingenico.eticket.buyerportal.utils.MD5Util;
import com.zteingenico.eticket.buyerportal.vo.UserSessionDTO;
import com.zteingenico.eticket.common.dictionary.RefundReasonDict;
import com.zteingenico.eticket.common.weixin.TemplateUtil;
import com.zteingenico.eticket.common.weixin.enums.JSAPIMethod;
import com.zteingenico.eticket.common.weixin.res.BaseResponse;

/**
 * 微信端控制器
 */
@Controller
@RequestMapping("/view/weixin")
public class MobileViewController {
	
	private static final Logger logger = LoggerFactory.getLogger(MobileViewController.class);
	
	@Resource
	private SessionService sessionService;

	@Resource
	private IWexinFacadeService weixinService;

	@Resource
	private IMemberFacadeService memberService;

	@Resource
	private IBuyerPortalCouponFacadeService couponService;
	
	@Resource
	private IBuyerPortalShareFacadeService shareService;
	
	@Resource
	private IBuyerPortalTopicFacadeService topicService;
	
	@Resource
	private IBuyerPortalOrderFacadeService orderService;
	
	@Resource
	private ICpnwebFacadeService cpnwebFacadeService;
	
	@Resource
	private IVerifyFacadeService verifyFacadeService;

	@Resource
	private IOwnerAddressFacadeService ownerAddressFacadeService;
	
	@Resource
	private IWexinFacadeService wexinFacadeService;
	

	
	@Value("#{propertiesHolder.get('query_expirding_max_day')}")
	private int queryExpirdingMaxDay;
	
	@Value("#{propertiesHolder.get('buyer_weixin_domain')}")
	private String buyerWeixinDomain;
	
	@Value("#{propertiesHolder.get('buyer_portal_page_size')}")
	private int pageSize;
	
	@Value("#{propertiesHolder.get('upload_weixin_file_domain')}")
	private String upload_weixin_file_domain;
	
	@Value("#{propertiesHolder.get('verify_mail_expire_time_senond')}")
	private int expireTime;
	
	@Value("#{propertiesHolder.get('buyer_portal_outer_url')}")
	private String buyerPortalOutUrl;
	@Value("#{propertiesHolder.get('person_follow_img')}")
	private String personFollowImg;
	
	@Value("#{propertiesHolder.get('wx_proxy_hostname')}")
	private String wxProxyHostName;
	
	@Value("#{propertiesHolder.get('wx_proxy_hostport')}")
	private int wxProxyHostPort;
	
	@Value("#{propertiesHolder.get('wechat_system_notify_msg_id')}")
	private String wechat_system_notify_msg_id;
	
	/**
	 * 进入抢券首页
	 */
	@RequestMapping(value = "/index", method = RequestMethod.GET)
	@AllowWeixinJSApi(api={
			JSAPIMethod.onMenuShareTimeline, 
			JSAPIMethod.onMenuShareAppMessage,
			JSAPIMethod.showOptionMenu,
			JSAPIMethod.hideMenuItems,
			JSAPIMethod.hideAllNonBaseMenuItem})
	public String index(HttpServletRequest req) {
		return "mobile/index";
	}

	/**
	 * 跳转到我的券页面
	 */
	@RequestMapping(value = "/mycoupon", method = RequestMethod.GET)
	@AllowWeixinJSApi(api={
			JSAPIMethod.onMenuShareTimeline, 
			JSAPIMethod.onMenuShareAppMessage,
			JSAPIMethod.showOptionMenu,
			JSAPIMethod.hideMenuItems,
			JSAPIMethod.hideAllNonBaseMenuItem})
	public String myCoupon(HttpServletRequest req) {
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		if (userinfo == null || userinfo.isVisitor()) {
			return "mobile/index";
		}
		return "mobile/mycoupons";
	}

	/**
	 * 跳转到会员已过期的券首页
	 */
	@RequestMapping(value = "/expiredcoupon", method = RequestMethod.GET)
	@AllowWeixinJSApi(api={
			JSAPIMethod.onMenuShareTimeline, 
			JSAPIMethod.onMenuShareAppMessage,
			JSAPIMethod.showOptionMenu,
			JSAPIMethod.hideMenuItems,
			JSAPIMethod.hideAllNonBaseMenuItem})
	public String expiredCoupon(HttpServletRequest req) {
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		if (userinfo == null || userinfo.isVisitor()) {
			return "mobile/index";
		}
		return "mobile/expiredcoupons";
	}

	/**
	 * 跳转到会员已使用的券首页
	 */
	@RequestMapping(value = "/usedcoupon", method = RequestMethod.GET)
	@AllowWeixinJSApi(api={
			JSAPIMethod.onMenuShareTimeline, 
			JSAPIMethod.onMenuShareAppMessage,
			JSAPIMethod.showOptionMenu,
			JSAPIMethod.hideMenuItems,
			JSAPIMethod.hideAllNonBaseMenuItem})
	public String usedCoupon(HttpServletRequest req) {
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		if (userinfo == null || userinfo.isVisitor()) {
			return "mobile/index";
		}
		return "mobile/usedcoupons";
	}

	/**
	 * 游客领券成功后的提示页面
	 */
	@RequestMapping(value = "/visitorfollow", method = RequestMethod.GET)
	public String visitorFollow(HttpServletRequest req) {
		return "mobile/visitorfollow";
	}


	@RequestMapping(value = "/evaluate", method = RequestMethod.GET)
	public ModelAndView evaluate(HttpServletRequest req, @RequestParam String couponid) {
		ModelAndView model = new ModelAndView("mobile/evaluate");
		model.addObject("couponid", couponid);
		return model;
	}

	@RequestMapping(value = "/doevaluate", method = RequestMethod.POST)
	public String doEvaluate(HttpServletRequest req, @RequestParam String couponid, @RequestParam int point) {
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		if (userinfo == null || userinfo.isVisitor()) {
			return "mobile/index";
		}
		couponService.markTopic(couponid, userinfo.getUserid(), point);
		return "mobile/usedcoupons";
	}

	/**
	 * 跳转到我的收到的红包页面
	 */
	@RequestMapping(value = "/hongbao", method = RequestMethod.GET)
	@AllowWeixinJSApi(api={
			JSAPIMethod.onMenuShareTimeline, 
			JSAPIMethod.onMenuShareAppMessage,
			JSAPIMethod.showOptionMenu,
			JSAPIMethod.hideMenuItems,
			JSAPIMethod.hideAllNonBaseMenuItem})
	public String hongbao(HttpServletRequest req) {
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		if (userinfo == null || userinfo.isVisitor()) {
			return "mobile/index";
		} else {
			return "mobile/hongbao";
		}
	}
	
	/**
	 * 跳转到 我的通知-快过期的券页面
	 */
	@RequestMapping(value = "/expiring", method = RequestMethod.GET)
	@AllowWeixinJSApi(api={
			JSAPIMethod.onMenuShareTimeline, 
			JSAPIMethod.onMenuShareAppMessage,
			JSAPIMethod.showOptionMenu,
			JSAPIMethod.hideMenuItems,
			JSAPIMethod.hideAllNonBaseMenuItem})
	public ModelAndView expiringCoupon(HttpServletRequest req) {
		
		ModelAndView model = null;
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		if (userinfo == null || userinfo.isVisitor()) {
			model = new ModelAndView("mobile/index");
		} else {
			model = new ModelAndView("mobile/expireTicket");
			List<CouponDTO> nearExpiredCoupon = couponService.getMyNearExpiredCoupon(
					userinfo.getUserid(), 
					this.queryExpirdingMaxDay);
			model.addObject("coupons", nearExpiredCoupon);
		}
		
		return model;
	}
	
	/**
	 * 跳转到发红包页面（页面采用Ajax获取券列表数据）
	 */
	@RequestMapping(value = "/sendable", method = RequestMethod.GET)
	@AllowWeixinJSApi(api={
			JSAPIMethod.onMenuShareTimeline, 
			JSAPIMethod.onMenuShareAppMessage,
			JSAPIMethod.showOptionMenu,
			JSAPIMethod.hideMenuItems,
			JSAPIMethod.hideAllNonBaseMenuItem})
	public ModelAndView toSendableCoupon(HttpServletRequest req) {
		
		ModelAndView model = null;
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		if (userinfo == null || userinfo.isVisitor()) {
			model = new ModelAndView("mobile/index");
		} else {
			model = new ModelAndView("mobile/sendablecoupon");
		}
		return model;
	}
	
	/**
	 * 跳转 关于橙e券页面
	 */
	@RequestMapping(value = "/about", method = RequestMethod.GET)
	public String about() {
		String redirectUrl = "resources/html/about.html";
		return "redirect:/" + redirectUrl;
	}
	
	/**
	 * 跳转 券使用指南页面
	 */
	@RequestMapping(value = "/guide", method = RequestMethod.GET)
	public String guide() {
		String redirectUrl = "resources/html/guide.html";
		return "redirect:/" + redirectUrl;
	}
	
	/**
	 * 跳转 联系我们页面
	 */
	@RequestMapping(value = "/contact", method = RequestMethod.GET)
	public String contact() {
		String redirectUrl = "resources/html/contactus.html";
		return "redirect:/" + redirectUrl;
	}
	
	/**
	 * 跳转验券页面
	 */
	@RequestMapping(value = "/checkcpn", method = RequestMethod.GET)
	@AllowWeixinJSApi(api={JSAPIMethod.scanQRCode})
	public ModelAndView checkcpn(HttpServletRequest req) {
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		
		MemberDTO memberDTO = memberService.getMemberByUserId(userinfo.getUserid());
		if(memberDTO!=null&&  !org.springframework.util.StringUtils.isEmpty(memberDTO.getOrgPersonId()) &&memberDTO.getOrgPersonId()!=0){
			ModelAndView model = new ModelAndView("mobile/checkcpn");
			model.addObject("userid", userinfo.getUserid());
			return model;
		}else{
			ModelAndView model = new ModelAndView("mobile/bindCheckUser");
			model.addObject("userid", userinfo.getUserid());
			return model;
		}
	}
	
	/**
	 * 查询券详情信息
	 * @param topicid 券主题ID
	 * @param couponid 券ID
	 * @return 券详情信息页面
	 */
	@RequestMapping(value = "/detail", method = RequestMethod.GET)
//	@AllowWeixinJSApi(api={
//			JSAPIMethod.showOptionMenu,
//			JSAPIMethod.hideMenuItems,
//			JSAPIMethod.hideAllNonBaseMenuItem})
	/*zhuyanqing 20160116*/
	@AllowWeixinJSApi(api={ 
			JSAPIMethod.onMenuShareTimeline, 
			JSAPIMethod.onMenuShareAppMessage,
			JSAPIMethod.showOptionMenu,
			JSAPIMethod.hideMenuItems,
			JSAPIMethod.hideAllNonBaseMenuItem})
	public ModelAndView detail(
			HttpServletRequest req,
			@RequestParam String topicid, 
			@RequestParam String couponid) {
		ModelAndView model = null;
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		if(userinfo==null || userinfo.isVisitor()) {
			model = new ModelAndView("mobile/index");
			return model;
		}
		
		CouponDetailDTO couponDetail = couponService.getCouponDetail(topicid, couponid);
		if(couponDetail == null) throw new RuntimeException("券不存在, topicId: " 
		+ topicid + ", couponId: " + couponid);
		// 判断用户ID是否一致
		if(couponDetail.getUserId()!=userinfo.getUserid()) {
			model = new ModelAndView("mobile/errMsg");
			model.addObject("errMsg", "只能查看自己的券");
		} else {
			model = new ModelAndView("mobile/coupondetail");
			model.addObject("coupon", couponDetail);
		}
		return model;
	}
	
	/**
	 * 跳转到 券使用二维码页面
	 * @param picturePath 券主题图片路径
	 * @param orgName 商家名称
	 * @param useSpan 使用期
	 * @param couponSN 券码
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value = "/use", method = RequestMethod.GET)
	public ModelAndView useTicket(
			HttpServletRequest req,
			@RequestParam String picturePath, 
			@RequestParam String orgName, 
			@RequestParam String useSpan, 
			@RequestParam String topicId, 
			@RequestParam String couponId,
			@RequestParam String realCouponSN,
			@RequestParam String couponSN) throws UnsupportedEncodingException {
		
		ModelAndView model = null;
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		if(userinfo==null || userinfo.isVisitor()) {
			model = new ModelAndView("mobile/index");
			return model;
		}
		
		CouponDetailDTO couponDetail = couponService.getCouponDetail(topicId, couponId);
		if(couponDetail == null) throw new RuntimeException("券不存在, topicId: " 
		+ topicId + ", couponId: " + couponId);
		// 判断用户ID是否一致
		if(couponDetail.getUserId()!=userinfo.getUserid()) {
			model = new ModelAndView("mobile/errMsg");
			model.addObject("errMsg", "只能使用自己的券");
		} else {
			model = new ModelAndView("mobile/useTicket");
			model.addObject("picturePath", picturePath);
			model.addObject("orgName", orgName);
			model.addObject("useSpan", useSpan);
			model.addObject("topicId", topicId);
			model.addObject("couponId", couponId);
			model.addObject("couponSN", couponSN);
			model.addObject("realCouponSN", realCouponSN);
			model.addObject("couponName", couponDetail.getCouponName());
			model.addObject("isShow", couponDetail.getIsShow());
		}
		
		return model;
	}
	
	/**
	 * 点击发送红包后生成分享链接
	 */
	@RequestMapping(value = "/presend", method = RequestMethod.GET)
	@AllowWeixinJSApi(api={
			JSAPIMethod.onMenuShareTimeline, 
			JSAPIMethod.onMenuShareAppMessage,
			JSAPIMethod.showOptionMenu,
			JSAPIMethod.hideMenuItems,
			JSAPIMethod.hideAllNonBaseMenuItem})
	public ModelAndView preSend(@RequestParam String couponId, @RequestParam String couponName, @RequestParam String couponImage, @RequestParam String couponDesc,
			@RequestParam String topicId, HttpServletRequest req) {
		
		logger.info("微信分享presend, 图片参数为{}", couponImage);

		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		String shareUrl = shareService.getShareCouponUrl(userinfo.getUserid(), couponId);
		if (StringUtils.isEmpty(shareUrl)){
			throw new RuntimeException("分享链接生成失败！");
		}
			
		ModelAndView model = new ModelAndView("mobile/getgoldcoin");
		model.addObject("shareUrl", shareUrl);
		model.addObject("couponId", couponId);
		model.addObject("topicId", topicId);
		model.addObject("couponName", couponName);
		model.addObject("couponImage", couponImage);
		model.addObject("couponDesc", couponDesc);
		return model;
	}
	
	/**
	 * 点击分享链接
	 * @throws IOException 重定向错误
	 */
	@RequestMapping(value = "/shareget", method = RequestMethod.GET)
	@AllowWeixinJSApi(api={
		JSAPIMethod.onMenuShareTimeline, 
		JSAPIMethod.onMenuShareAppMessage,
		JSAPIMethod.showOptionMenu,
		JSAPIMethod.hideMenuItems,
		JSAPIMethod.hideAllNonBaseMenuItem})
	public ModelAndView receiveCoupon(HttpServletRequest req, HttpServletResponse response) throws IOException {
		
		ModelAndView model = new ModelAndView();
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		logger.info("用户信息：" + userinfo);
		
		// 调用后台进行红包分享链接处理
		String urlParams = req.getQueryString();
		Member member = (Member) req.getAttribute("member");
		logger.info("member信息：" + member);
		if(member == null){
			member = new Member();
			member.setId(0l);
		}
		logger.info("receiveCoupon  urlParams:" + urlParams);
		HongbaoInfoDTO result = shareService.receiveCoupon(urlParams, userinfo==null?0:userinfo.getUserid(),member, false);
		logger.info("receiveCoupon  result 信息：" + result + "urlParams:" + urlParams);
		req.setAttribute("member", null);
		logger.info("receiveCoupon  result 信息：" + result);
		if(result.getResult() == ReceiveCouponResult.USER_RE_SUBSCRIBE){
			logger.info("跳到关注页面");
			model.setViewName("mock/follow");
			model.addObject("personFollowImg", personFollowImg);
			return model;
			//return new ModelAndView(new RedirectView(buyerWeixinDomain + "/resources/html/follow.html"));
		}
		// 设置 分享人 信息
		if(result.getSender()!=null) {
			model.addObject("senderName", result.getSender().getUserWxName());
			model.addObject("senderImg", result.getSender().getWxImgUrl());
			model.addObject("userId", result.getSender().getMemberSid());
		}
		
		// 设置 券 信息
		if(result.getCoupon()!=null) {
			model.addObject("couponName", result.getCoupon().getCouponName());
			model.addObject("couponId", result.getCoupon().getCouponId());
			// 按券类型设置 显示内容
			// 券类型：FOR_CASH OFF_PRICE PERCENT_PRICE USER_DEFINE
			String topicClass = result.getCoupon().getTopicClass();
			model.addObject("topicId", result.getCoupon().getTopicId());
			if("FOR_CASH".equals(topicClass)) {
				model.addObject("couponOriInfo", result.getCoupon().getOriPrice());
				model.addObject("couponInfo", result.getCoupon().getPrice());
			} else if("OFF_PRICE".equals(topicClass)) {
				String tips = "满" + result.getCoupon().getFullPrice() + 
						"减" + result.getCoupon().getOffPrice() + "元";
				model.addObject("couponInfo", tips);
			} else if("PERCENT_PRICE".equals(topicClass)) {
				String tips = result.getCoupon().getPercentPrice() + "折";
				model.addObject("couponInfo", tips);
			} else {
				model.addObject("couponInfo", result.getCoupon().getTopicContent());
			}
		}
		// 设置领红包状态
		model.addObject("couponStatus", result.getResult().name());
		
		// 券已被领取
		if(result.getResult() == ReceiveCouponResult.COUPON_GOT) {
			model.setViewName("mobile/hongbaoDetail");
			model.addObject("userType", result.getUserType().name());
		} 
		// 券分享中
		else if(result.getResult() == ReceiveCouponResult.COUPON_SHARING) {
			// 分享人点击 分享链接
			if(result.getUserType() == ClickHongbaoUrlUserType.SENDER) {
				// 进入 红包详情 页面（包含抢券人列表）
				model.setViewName("mobile/hongbaoDetail");
				model.addObject("userType", "SENDER");
			// 其他人 点击 分享链接
			} else {
				// 进入 红包信息 页面（拆红包）
				model.setViewName("mobile/hongbaoInfo");
				model.addObject("userType", "OTHERS");
				model.addObject("nextUrl", result.getNextUrl());
			}
		} 
		// 分享过期
		else if(result.getResult() == ReceiveCouponResult.SHARE_EXPIRED) {
			// 分享人点击 分享链接
			if(result.getUserType() == ClickHongbaoUrlUserType.SENDER) {
				// 进入 红包信息 页面（提示分享过期，查看详情，再发红包）
				model.setViewName("mobile/hongbaoInfo");
				model.addObject("userType", "SENDER");
				model.addObject("expiredTips", result.getShareExpiredDate());
				model.addObject("nextUrl", result.getNextUrl());
			} 
			// 其他人 点击 分享链接
			else {
				// 进入 红包详情 页面（包含抢券人列表）
				model.setViewName("mobile/hongbaoDetail");	
				model.addObject("userType", result.getUserType().name());
				model.addObject("expiredTips", result.getShareExpiredDate());
			}	
		// 券过期
		} else if(result.getResult() == ReceiveCouponResult.COUPON_EXPIRED) {
			// 分享人点击 分享链接
			if(result.getUserType() == ClickHongbaoUrlUserType.SENDER) {
				// 进入 红包信息 页面
				model.setViewName("mobile/hongbaoInfo");
				model.addObject("userType", "SENDER");
				model.addObject("expiredTips", result.getCouponExpiredDate());
				model.addObject("nextUrl", result.getNextUrl());
			// 其他人 点击 分享链接
			} else {
				// 进入 红包详情 页面（包含抢券人列表）
				model.setViewName("mobile/hongbaoDetail");	
				model.addObject("userType", result.getUserType().name());
				model.addObject("expiredTips", result.getCouponExpiredDate());
			}
		// 领券成功
		} else if(result.getResult() == ReceiveCouponResult.SUCCESS) {
			// 进入 红包详情 页面（包含抢券人列表）
			model.setViewName("mobile/hongbaoDetail");
			model.addObject("userType", "RECEIVER");
		// 其他状态，转到错误提示页面
		} else {
			model.setViewName("mobile/errMsg");
			model.addObject("errMsg", result.getResult().getName());
		}
		//领取生成的orderlineid
		model.addObject("recCouponId", result.getRecCouponId());
		model.addObject("wxDetailImage", result.getCoupon().getWxDetailImage());
		model.addObject("wxDetailHtmlUrl", result.getCoupon().getWxDetailHtmlUrl());
		logger.info("红包分享连接  最后返回信息 = " + model.toString() + result.toString() + "用户ID：" + userinfo);
		return model;
	}
	
	/**
	 * 点击抢券，进入订单确认页面
	 */
	@RequestMapping(value = "/toorderconfirm")
	@AllowWeixinJSApi(api={JSAPIMethod.chooseWXPay})
	public ModelAndView toOrderConfirm(HttpServletRequest req,@RequestParam String topicid) {
		ModelAndView model = null;
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		if(userinfo==null || userinfo.isVisitor()) {
			model = new ModelAndView("mobile/index");
			return model;
		}
		ConfirmOrderDTO order = topicService.getConfirmInfoByTopicid(userinfo.getUserid(),topicid);
		model = new ModelAndView("mobile/orderconfirm");
		model.addObject("order", order);
		return model;
	}
	
	/**
	 * 点击抢券，进入订单提示页面
	 */
	@RequestMapping(value = "/beforeorderconfirm")
	@AllowWeixinJSApi(api={JSAPIMethod.chooseWXPay})
	public ModelAndView beforeOrderConfirm(HttpServletRequest req,@RequestParam String topicid) {
		ModelAndView model = null;
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		if(userinfo==null || userinfo.isVisitor()) {
			model = new ModelAndView("mobile/index");
			return model;
		}
//		ConfirmOrderDTO order = topicService.getConfirmInfoByTopicid(userinfo.getUserid(),topicid);
		model = new ModelAndView("mock/ordertips");
		model.addObject("topicid", topicid);
		return model;
	}
	
	/**
	 * 免费券点击领券，直接领券，并跳转到我的券页面
	 */
	@RequestMapping(value = "/takefreecoupon", method = RequestMethod.POST)
	public ModelAndView takeFreeCoupon(HttpServletRequest req,@RequestParam String topicid) {
		ModelAndView model = null;
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		if(userinfo==null || userinfo.isVisitor()) {
			model = new ModelAndView("mobile/index");
			return model;
		}
		// 用户重复提交
		if(!sessionService.hasSessionFreeCouponToken(req)) {
			model = new ModelAndView("mobile/mycoupons");
			return model;
		}
		// 清除session的token
		sessionService.removeSessionFreeCouponToken(req);
		int userTakenNums = topicService.getUserTakenNum(topicid, userinfo.getUserid());
		// 验证topic状态
		CheckTopicResultDTO status = topicService.checkCondition(userinfo.getUserType(), 
				topicid,
				userTakenNums);
		if (!status.isAvailable()) {
			model = new ModelAndView("mobile/errMsg");
			model.addObject("errMsg", status.getTipsMessage());
		} else {
			String orderid = topicService.takeFreeCouponByMember(
					topicid,
					userinfo.getUserid());
			// 领券成功
			if (StringUtils.isNotBlank(orderid)) {				
				/*业务变更，领取完成后不再是跳转到券管理页面，而是直接跳转到券使用界面  2016-01-26  zhuyanqing start*/
//				model = new ModelAndView("mobile/mycoupons");
//				// 页面提示 标志
//				model.addObject("freecoupon", "freecoupon");
				//根据orderCode获取counonId
				String couponId = topicService.getOrderByOrderCode(orderid);
				if(StringUtils.isNotEmpty(couponId)){
					CouponDetailDTO couponDetail = couponService.getCouponDetailByLineId(topicid, couponId);
					if(couponDetail == null){
						throw new RuntimeException("券不存在, topicId: " + topicid + ", couponId: " + couponId);
					}
					// 判断用户ID是否一致
					if(couponDetail.getUserId()!=userinfo.getUserid()) {
						model = new ModelAndView("mobile/errMsg");
						model.addObject("errMsg", "只能查看自己的券");
					} else {
						model = new ModelAndView("mobile/coupondetail");
						model.addObject("coupon", couponDetail);
					}
				}else{
					model = new ModelAndView("mobile/errMsg");
					model.addObject("errMsg", "该券不存在");
				}
				/*业务变更，领取完成后不再是跳转到券管理页面，而是直接跳转到券使用界面  2016-01-26  zhuyanqing end*/
			} else {
				model = new ModelAndView("mobile/errMsg");
				model.addObject("errMsg", "订单生成失败!");
			}
		}
		return model;
	}
	
	
	/**
	 * 领券或支付成功后，查询订单相关状态，展示给用户
	 */ 
	@RequestMapping(value = "/orderquerynotice", method = RequestMethod.GET)
	public ModelAndView orderqueryNotice(HttpServletRequest req,@RequestParam String orderid) {
		
		// 获取微信 AccessToken
		String accesstoken = wexinFacadeService.getAccessToken();
		HttpHost proxy = new HttpHost(wxProxyHostName, wxProxyHostPort);
		// 通知的数据结构
		Map<String, Object> first = new HashMap<String, Object>();
		first.put("color", "#173177");
		Map<String, Object> keyword1 = new HashMap<String, Object>();
		keyword1.put("color", "#173177");
		Map<String, Object> keyword2 = new HashMap<String, Object>();
		keyword2.put("color", "#173177");
		Map<String, Object> remark = new HashMap<String, Object>();
		remark.put("color", "#173177");
		//
		Map<String, Object> wdata = new HashMap<String, Object>();
		wdata.put("first", first);
		wdata.put("keyword1", keyword1);
		wdata.put("keyword2", keyword2); 
		wdata.put("remark", remark);
		ModelAndView model = new ModelAndView("mobile/paymentresultnotice");
		OrderDTO order = orderService.getOrderById(orderid);
		String urlt = buyerWeixinDomain + "/view/weixin/toorderconfirm?topicid="+order.getTopicId();
		if(order.getOrderStatus()==OrderStatus.FOR_USE){
			model.addObject("paystatus","success");
		}else if(order.getOrderStatus()==OrderStatus.FOR_PAY){
			model.addObject("paystatus","unknow");
			// 支付确认通知
			first.put("value", "你好，你有未支付商品，请在一小时内支付！");
			keyword1.put("value", "橙E券");
			String tmp = 
			 "订单流水号：" + order.getOrderid() + "\n" 
			+ "订单状态：" + order.getOrderStatus() + "\n"
			+ "券数量：" + order.getAmount()+ "\n"
			+ "总价格：" + order.getPrice()+ "\n"
			+ "券名称：" + order.getTopicName()  ;
			keyword2.put("value", tmp);
		}else{
			model.addObject("paystatus","failed");
			first.put("value", "你好，你有未支付陈功商品，请在一小时内支付！");
			keyword1.put("value", "橙E券");
			String tmp = 
			 "订单流水号：" + order.getOrderid() + "\n" 
			+ "订单状态：" + order.getOrderStatus() + "\n"
			+ "券数量：" + order.getAmount()
			+ "总价格：" + order.getPrice()
			+ "券名称：" + order.getTopicName()  ;
			keyword2.put("value", tmp);
		}
		// 查找用户信息
		MemberDTO member =memberService.getMemberByUserId(order.getUserId());
		BaseResponse res = TemplateUtil.sendTemplateMessage(
				accesstoken, 
				urlt, 
				member.getWxOpenId(), 
				wechat_system_notify_msg_id,
				wdata,
				proxy);
		
		model.addObject("order", order);
		return model;
	}
	
	/**
	 * 领券或支付成功后，查询订单相关状态，展示给用户
	 */ 
	@RequestMapping(value = "/orderquery", method = RequestMethod.GET)
	public ModelAndView orderquery(HttpServletRequest req,@RequestParam String orderid) {
		
		ModelAndView model = new ModelAndView("mobile/paymentresult");
		OrderDTO order = orderService.getOrderById(orderid);
		String urlt = buyerWeixinDomain + "/view/weixin/toorderconfirm?topicid="+order.getTopicId();
		if(order.getOrderStatus()==OrderStatus.FOR_USE){
			model.addObject("paystatus","success");
		}else if(order.getOrderStatus()==OrderStatus.FOR_PAY){
			model.addObject("paystatus","unknow");
			
		}else{ 
			model.addObject("paystatus","failed");
			
		}
		
		model.addObject("order", order);
		return model;
	}
	
	

	
	/**
	 * 跳转到我的退款单页面
	 */
	@RequestMapping(value = "/refundcoupon", method = RequestMethod.GET)
	@AllowWeixinJSApi(api={
			JSAPIMethod.onMenuShareTimeline, 
			JSAPIMethod.onMenuShareAppMessage,
			JSAPIMethod.showOptionMenu,
			JSAPIMethod.hideMenuItems,
			JSAPIMethod.hideAllNonBaseMenuItem})
	public String myRefundCoupon(HttpServletRequest req) {
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		if (userinfo.isVisitor()) {
			return "mobile/index";
		}
		return "mobile/refundcoupons";
	}
	
	/**
	 * 退款单页面点击 退款详情 跳转到 退款详情页面
	 */
	@RequestMapping(value = "/refunddetail", method = RequestMethod.GET)
	public ModelAndView refundDetail(
			HttpServletRequest req,
			@RequestParam String couponId) {
		
		ModelAndView model = null;
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		
		if(userinfo!=null) {
			RefundInfoDTO refund = orderService.getRefundInfoByCouponId(userinfo.getUserid(), couponId);
			if(refund!=null) {
				if(refund.isSuccess()) {
					model = new ModelAndView("mobile/refunddetail");
					model.addObject("refund", refund);
				} else {
					model = new ModelAndView("mobile/errMsg");
					model.addObject("errMsg", "退款单查询失败！");
				}
			} else {
				model = new ModelAndView("mobile/errMsg");
				model.addObject("errMsg", "退款单不存在！");
			}
		} else {
			model = new ModelAndView("mobile/errMsg");
			model.addObject("errMsg", "用户不存在！");
		}
		
		return model;
	}
	
	/**
	 * 跳转到申请退款页面
	 */
	@RequestMapping(value = "/torefundapply", method = RequestMethod.GET)
	public ModelAndView toRefundApply(
			HttpServletRequest req,
			@RequestParam String couponName,
			@RequestParam String couponPrice,
			@RequestParam String couponId) {
		
		ModelAndView model = null;
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		
		if(userinfo!=null) {
			if (userinfo.isVisitor()) {
				model = new ModelAndView("mobile/index");
			} else {
				model = new ModelAndView("mobile/refundapply");
				model.addObject("couponName", couponName);
				model.addObject("couponPrice", couponPrice);
				model.addObject("couponId", couponId);
				model.addObject("refundReason", RefundReasonDict.dicts);
			}
		} else {
			model = new ModelAndView("mobile/errMsg");
			model.addObject("errMsg", "用户不存在！");
		}
		
		return model;
	}
	
	/**
	 * 退款申请处理
	 */
	@RequestMapping(value = "/refundapply", method = RequestMethod.GET)
	public ModelAndView handleRefundApply(
			HttpServletRequest req,
			@RequestParam String reasonKey,
			@RequestParam String couponId) {
		
		ModelAndView model = null;
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		
		if(userinfo!=null) {
			if (userinfo.isVisitor()) {
				model = new ModelAndView("mobile/index");
			} else {
				if(RefundReasonDict.dicts.containsKey(reasonKey)) {
					RefundInfoDTO refund = orderService.handleRefundApply(
							userinfo.getUserid(), 
							couponId, 
							reasonKey);
					// 退款申请处理成功
					if(refund!=null) {
						if(refund.isSuccess()) {
							// 跳转到 退款单详情页面
							model = new ModelAndView("mobile/refunddetail");
							model.addObject("refund", refund);
						} else {
							// 显示退款失败原因
							model = new ModelAndView("mobile/errMsg");
							model.addObject("errMsg", "退款申请处理失败，原因：" + refund.getErrMsg());
						}
					} else {
						model = new ModelAndView("mobile/errMsg");
						model.addObject("errMsg", "退款申请处理失败！");
					}
				} else {
					model = new ModelAndView("mobile/errMsg");
					model.addObject("errMsg", "退款原因：" + reasonKey + " 不存在！");
				}
			}
		} else {
			model = new ModelAndView("mobile/errMsg");
			model.addObject("errMsg", "用户不存在！");
		}
		
		return model;
	}
	
	/**
	 * 进入抢券详情页，仅限于分享和二维码抢券
	 * @return
	 * @throws IOException 
	 */
	@RequestMapping(value = "/topicdetail", method = RequestMethod.GET)
	public String getTopicDetail(@RequestParam String location,
			@RequestParam(required=false) String from,
			HttpServletResponse res) throws IOException{
		if(location.startsWith(upload_weixin_file_domain)){
			res.sendRedirect(location);
			return null;
		}else{
			return "mobile/index";
		}
	}
	
	/**
	 * 跳转到 自提点 页面
	 */
	@RequestMapping(value = "/position", method = RequestMethod.GET)
	public ModelAndView toOrgPosition(
			HttpServletRequest req,
			@RequestParam String orgId) {
		
		ModelAndView model = null;
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		
		if(userinfo!=null) {
			if (userinfo.isVisitor()) {
				model = new ModelAndView("mobile/index");
			} else {
				model = new ModelAndView("mobile/orgposition");
				model.addObject("orgId", orgId);
			}
		} else {
			model = new ModelAndView("mobile/errMsg");
			model.addObject("errMsg", "用户不存在！");
		}
		
		return model;
	}
	
	/**
	 * 跳转到我的发出的红包页面
	 */
	@RequestMapping(value = "/mygift", method = RequestMethod.GET)
	@AllowWeixinJSApi(api={
			JSAPIMethod.onMenuShareTimeline, 
			JSAPIMethod.onMenuShareAppMessage,
			JSAPIMethod.showOptionMenu,
			JSAPIMethod.hideMenuItems,
			JSAPIMethod.hideAllNonBaseMenuItem})
	public String mygift(HttpServletRequest req) {
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		if (userinfo.isVisitor()) {
			return "mobile/index";
		} else {
			return "mobile/mygift";
		}
	}
	
	
	
	/**
	 * 方法说明：转入粉丝绑定已有橙E券帐号页面（微信页面）
	 * @param 
	 * @return
	 */
	@RequestMapping(value={ "/binding" }, method = RequestMethod.GET)
	public String bind(HttpServletRequest request, HttpServletResponse response,ModelMap model){
		
		String ceName = "NULL"; //橙E用户名
		String isBind = "N";
		

		UserSessionDTO userInfo = sessionService.getUserInfoInSession(request);
		Map<String,Object> map = new HashMap<String,Object>();
		MemMemberDTO memberDto = null;
		if(userInfo!=null){
			map.put("memberSid", userInfo.getUserid());
			List<MemMemberDTO> listMember = cpnwebFacadeService.getMemberByParams(map);
			if(listMember!=null && !listMember.isEmpty()) {
				memberDto=listMember.get(0); //根据userid获取用户信息
				if(memberDto.getRemark()!=null&&"BIND".equals(memberDto.getRemark())){ //该用户已经绑定
					ceName =  memberDto.getUserCode();
					isBind = "Y";
					model.put("ceName", ceName);
					model.put("wxImgUrl", memberDto.getWxImgUrl());
					model.put("isBind", isBind);
					userInfo.setIsBind("Y");
					request.getSession().setAttribute(SessionService.USER_INFO_SESSION_KEY, userInfo);
					return "mobile/bindSucc";
				}
				else
				{
					return "mobile/binding";
				}
			} else {
				//账户不存在 或 已失效
				model.put("userError", "未获取到您的微信用户信息，请重新打开微信");
				return "mobile/binding";
			}
		}else {
			//账户不存在 或 已失效
			model.put("userError", "未获取到您的微信用户信息，请重新打开微信");
			return "mobile/binding";
		}
	}
	
	@RequestMapping(value={ "/checkIsBand" })
	public void checkIsBand(HttpServletRequest request, HttpServletResponse res,ModelMap model){
		
			UserSessionDTO userInfo = sessionService.getUserInfoInSession(request);
			System.out.println("userInfo isband status :"+userInfo.getUserid() +"-" +userInfo.getIsBind());
			try {
				res.getOutputStream().write(userInfo.getIsBind().getBytes());
				res.getOutputStream().flush();
				res.getOutputStream().close();
			} catch (IOException e) {
				e.printStackTrace();
			}
	}
	
	
	
	
	/**
	 * 方法说明：转入平安员工身份验证页面（微信页面）
	 * @param 
	 * @return
	 */
	@RequestMapping(value={ "/check" }, method = RequestMethod.GET)
	public String check(HttpServletRequest request, HttpServletResponse response,ModelMap model){
		
		String isCheck = "N";
		String umAccount = "NULL"; //um帐号
		UserSessionDTO userInfo = sessionService.getUserInfoInSession(request);

		MemMemberDTO memberDtoFromTab = null;
		Map<String,Object> map = new HashMap<String,Object>();
		if(userInfo!=null){
			map.put("memberSid", userInfo.getUserid());
//			String testUserId = request.getParameter("id"); //testing 
//			if(testUserId!=null && !"".equals(testUserId)){ //testing
//				map.put("memberSid", testUserId); //testing 
//			} 

			List<MemMemberDTO> listMember = cpnwebFacadeService.getMemberByParams(map);
			if(null!=listMember && !listMember.isEmpty()){
				memberDtoFromTab=listMember.get(0); //根据userid获取用户信息
				if(null!=memberDtoFromTab && memberDtoFromTab.getUserTypeVO()!=null){ //该用户已经验证
					if(memberDtoFromTab.getUserTypeVO().getCode()==3){
						umAccount =  memberDtoFromTab.getUserUmAccount();
						isCheck = "Y";
						model.put("isCheck", isCheck);
						model.put("umAccount", umAccount);
					}
				}
			}else {
				model.put("userError", "未获取到您的微信用户信息，请重新打开微信！");
				return "mobile/check"; 
			}
		}
		
		return "mobile/check";
		 
	}
	

	/**
	 * 方法说明：通过平安封装好的jar包组装成xml文件，通过jar包在服务器端发送ESB转橙E网，
	 *   橙E网验证密码后返回结果，服务端接收，整个过程是同步的
     *    接收返回状态后，如果是成功的，则更新我方系统帐号表里的状态
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value={ "/bindUpdate" }, method = RequestMethod.GET)
	public String updateBindStatus(String username,String password,
				HttpServletRequest request, HttpServletResponse response,ModelMap model){
		
		String bindStatus = "FAIL";
		String errorMsg = "抱歉，绑定失败，请稍后再试！";
		UserSessionDTO userInfo = sessionService.getUserInfoInSession(request);
		//预留接口，从平安接口获取是否通过验证
		RespApp027DTO respApp027DTO = null;
		if(username!=null && password
				!=null 
				&& !"".equals(username) && !"".equals(password)){
			try{
				respApp027DTO = verifyFacadeService.checkedEticketUser(username,password); //调用ESB接口 获取用户信息
			}catch(Exception e){
				errorMsg = "抱歉，服务器忙，请稍后再试！";
				model.put("bindStatus",bindStatus);
				model.put("errorMsg",errorMsg);
				return "mobile/binding";
			}
		}
		MemMemberDTO tableMemberDto = null;
		Map<String,Object> map = new HashMap<String,Object>();
		if(userInfo!=null){
			map.put("memberSid", userInfo.getUserid());
			List<MemMemberDTO> listMember = cpnwebFacadeService.getMemberByParams(map);
			if(null!=listMember && !listMember.isEmpty()){
				tableMemberDto=listMember.get(0); //根据userid获取用户信息
				if(tableMemberDto.getRemark()!=null&&"BIND".equals(tableMemberDto.getRemark())){
					/*model.put("bindStatus","SUCC");
					model.put("ceName", respApp027DTO.getUserNo());
					model.put("wxImgUrl", tableMemberDto.getWxImgUrl());
					return "mobile/bindSucc";*/
					errorMsg = "抱歉，您输入的帐号已被绑定！";
					model.put("bindStatus",bindStatus);
					model.put("errorMsg",errorMsg);
					return "mobile/binding";
				}
			}
		}else {
			errorMsg = "抱歉，未获取到您的账户信息，请重新打开微信！";
			model.put("bindStatus",bindStatus);
			model.put("errorMsg",errorMsg);
			return "mobile/binding";
		}
		
		if(respApp027DTO!=null && "00".equals(respApp027DTO.getReturnCode())){  //从ESB获取用户信息成功
			 //根据橙E账户获取用户信息
			map.clear();
			map.put("chewUserId", respApp027DTO.getScfpId());
			List<MemMemberDTO> listMember = cpnwebFacadeService.getMemberByParams(map);
			if(null!=listMember && !listMember.isEmpty()){
				errorMsg = "抱歉，该帐号为非法帐号，请用其他帐号！";
				model.put("bindStatus",bindStatus);
				model.put("errorMsg",errorMsg);
				return "mobile/binding";
			}
			
			MemMemberDTO pcLoginMember = null;  //曾经登录过系统
			//检测该橙E账户是否被别的帐号绑定
			for(MemMemberDTO memdto : listMember){
				memdto.setRemark(null);
				if("BIND".equals(memdto.getRemark())){
					errorMsg = "抱歉，您输入的帐号已被绑定！";
					model.put("bindStatus",bindStatus);
					model.put("errorMsg",errorMsg);
					return "mobile/binding";
				}else {
					pcLoginMember = memdto;
				}
			}
			if(pcLoginMember!=null && pcLoginMember.getMemberSid()>0){  //曾经登录过系统
			
				//将原先pc端用户记录作废
				verifyFacadeService.updateMemberEnableStatus(pcLoginMember);  
					
				//订单合并
				//需要更新id的表
				List<OperateTableDTO> allOperateList =  verifyFacadeService.getAllOperateTableList();
				if(null!=allOperateList && !allOperateList.isEmpty()){
					for(OperateTableDTO tableDTO : allOperateList){
						
						//需要保存的日志记录
						List<OperateLogDTO> needOperateList = verifyFacadeService.getNeedUpdateRecordList(tableDTO);

						//更新记录 将涉及到的表更新
						if(needOperateList!=null && !needOperateList.isEmpty()){
							tableDTO.setAfterUserId(Integer.parseInt(String.valueOf(tableMemberDto.getMemberSid())));
							tableDTO.setBeforeUserId(Integer.parseInt(String.valueOf(pcLoginMember.getMemberSid())));
							verifyFacadeService.updateUserIdByTableName(tableDTO);
							
								for(OperateLogDTO logDTO : needOperateList){//插入日志表 
								logDTO.setTableName(tableDTO.getTableName()); //
								logDTO.setIdFieldName(tableDTO.getIdFieldName());
								logDTO.setAfterUserId(Integer.parseInt(String.valueOf(tableMemberDto.getMemberSid())));
								logDTO.setBeforeUserId(Integer.parseInt(String.valueOf(pcLoginMember.getMemberSid())));
								verifyFacadeService.addOperateLog(logDTO);
							}
						}
					}
				}
			}
			
			//更新用户信息状态
			MemMemberDTO newMemberDTO = new MemMemberDTO();
			newMemberDTO.setMemberSid(userInfo.getUserid());
			newMemberDTO.setUserName(respApp027DTO.getUserName());
			newMemberDTO.setUserCode(respApp027DTO.getUserNo());
			newMemberDTO.setChewUserId(respApp027DTO.getScfpId());
			newMemberDTO.setRemark("BIND");//橙e绑定状态
			if(tableMemberDto.getUserTypeVO()!=null&&tableMemberDto.getUserTypeVO().getCode()<3){
				newMemberDTO.setUserTypeVO(UserType.codeOfEnum(2));  //用户类型（0-1-2-3） 游客/微信用户/橙e会员/平安员工/
			}else {
				newMemberDTO.setUserTypeVO(UserType.codeOfEnum(3));  
			}
			verifyFacadeService.updateBindStatus(newMemberDTO); 
			if(tableMemberDto.getUserTypeVO()!=null&&tableMemberDto.getUserTypeVO().getCode()<3)
			{
				sessionService.setSessionUserType(request,UserType.codeOfEnum(2));
			}else
			{
				sessionService.setSessionUserType(request,UserType.codeOfEnum(3));
			}
			logger.info("成功更改用户级别为{}", userInfo.getUserType());
			bindStatus = "SUCC";
			model.put("bindStatus",bindStatus);
			model.put("ceName", respApp027DTO.getUserNo());
			model.put("wxImgUrl", tableMemberDto.getWxImgUrl());
			return "mobile/bindSucc";
		}else {
			errorMsg = "您输入的账户或密码有误！";
			model.put("bindStatus",bindStatus);
			model.put("errorMsg",errorMsg);
			return "mobile/binding";
		}
		
	}
	

	
	/**
	 * 方法说明：通过封装好的jar包组装成xml文件，通过jar包在服务器端发送ESB转橙E网，获取UM用户信息， 
     * 获取到用户信息后，通过jar包，将邮件内容封装成XML格式，访问平安提供的接口，此接口作用为发送邮件。
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value={ "/sendMail" }, method = RequestMethod.GET)
	public String checkStatusSendEMail(HttpServletRequest request, HttpServletResponse response,ModelMap model){
		String mailTitle = "橙E券平安员工UM帐号验证邮件";//邮件标题
		String checkUrl= buyerPortalOutUrl+"/view/verify/updateCheck?key=";  //linux
		StringBuffer content = new StringBuffer();
		String result = "FAIL";
		String errorMsg = "";
		
		UserSessionDTO userInfo = sessionService.getUserInfoInSession(request);
		long userid = 0;
		if(null!=userInfo){
			 userid = userInfo.getUserid();
		}else {
			model.put("result", result);
			model.put("errorMsg", "抱歉，未获取到您的微信用户信息，请重新打开微信");
			return "mobile/check";
		}

		String umId = request.getParameter("umAccount");

		RespWeb033DTO respWeb033DTO = null;
		if(null!=umId && !"".equals(umId.trim())){
			try{
				respWeb033DTO = verifyFacadeService.checkedEticketUM(umId); 
			}catch(Exception e){
				model.put("result", result);
				model.put("errorMsg", "服务器忙，请稍后再试！(991)");
				return "mobile/check";

			}

		//检查UM帐号是否合法
			if(null==respWeb033DTO || !"00".equals(respWeb033DTO.getReturnCode()) || "".equals(respWeb033DTO.getEmail())){
				model.put("errorMsg", "无效的UM帐号，请重新输入！");
				model.put("result", result);
				return "mobile/check";
			}
		}
		

		//检测该UM账户是否被别的帐号绑定
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("userUmAccount", umId);
		List<MemMemberDTO> listMember = cpnwebFacadeService.getMemberByParams(map);

		if(null!=listMember&&!listMember.isEmpty()){
			for(MemMemberDTO memdto : listMember){
				if(null!=memdto.getUserUmAccount()&&!"".equals(memdto.getUserUmAccount().trim())){
					model.put("errorMsg", "抱歉，您输入的帐号已被绑定！");
					model.put("result", result);
					return "mobile/check";
				}
			}
		}
		
		boolean res = false;  //邮件是否发送成功
		String useridMD5 = "";
		if(userid!=0){
			useridMD5 = MD5Util.string2MD5(String.valueOf(userid));
		}
		int expireHour = expireTime/3600;
		String mailAddress = respWeb033DTO.getEmail();
		String contentPrefix = "您好‘"+respWeb033DTO.getName()+"’,请在"+expireHour+"小时内点击下方\"立即验证\"验证您的帐号,如果不能打开,请复制地址到浏览器打开!<br>"; //邮箱内容前缀

		String url = "";
		if(!"".equals(mailAddress)){
			//设置redis缓存，用于用户点击验证链接地址时的校验
			String useridStr = String.valueOf(userid);
			verifyFacadeService.putUserTokenToCache(useridMD5, useridStr+"#"+umId, expireTime);
			url = checkUrl +useridMD5;
			String hrefUrl = "<a href=\""+url+"\" >立即验证</a> <br>";

			content.append(contentPrefix);
			content.append(hrefUrl);
			content.append("<br>");
			content.append("链接地址：<br>"+url);
			content.append("<br>提醒：该邮件为橙E券粉丝绑定平安员工帐号的验证邮件，如果是非本人操作，那可能是其他人误输入您的UM帐号，请忽略此邮件。<br>");
			
			try{
				//发送邮件
				res = verifyFacadeService.mailSend(mailTitle, mailAddress, content.toString());
			}catch(Exception e){
				model.put("errorMsg", "服务器忙，请稍后再试！(992)");
				model.put("result", result);
				return "mobile/check";

			}
		}else {
			model.put("errorMsg", "抱歉，未获取到邮箱地址！");
			model.put("result", result);
			return "mobile/check";
		}


		if(res){
			result ="SUCC";
			model.put("succMsg", "系统已向您的UM绑定邮箱发送了一封邮件，请于"+expireHour+"小时内前往验证！");
		}
		
		model.put("errorMsg", errorMsg);
		model.put("result", result);
		return "mobile/check";
	}
	
	
	/**
	 * 跳转到我的券页面
	 */
	@RequestMapping(value = "/bindSucc", method = RequestMethod.GET)
	public String bindSucc(String ceName,String wxImgUrl,HttpServletRequest req,ModelMap model) {
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		if (userinfo == null || userinfo.isVisitor()) {
			return "mobile/index";
		}
		model.put("ceName", ceName);
		model.put("wxImgUrl", wxImgUrl);
		return "mobile/bindSucc";
	}
	
	/**
	 * 跳转到 券选择物流地址页面
	 * @param 
	 * @param topicId 
	 * @param couponId 
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value = "/ownedAddress", method = RequestMethod.GET)
	public ModelAndView ownedAddress(
			HttpServletRequest req, 
			@RequestParam String topicId, 
			@RequestParam String couponId) throws UnsupportedEncodingException {
		
		ModelAndView model = null;
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		if(userinfo==null || userinfo.isVisitor()) {
			model = new ModelAndView("mobile/index");
			return model;
		}
		
			model = new ModelAndView("mobile/selectAddress");
			model.addObject("topicId", topicId);
			model.addObject("couponId", couponId);
		
		return model;
	}
	
	
	/**
	 * 跳转到 添加物流地址页面
	 * @param topicId 
	 * @param couponId
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value = "/addAddress", method = RequestMethod.GET)
	public ModelAndView addAddress(
			HttpServletRequest req,
			@RequestParam String topicId, 
			@RequestParam String couponId) throws UnsupportedEncodingException {
		
		ModelAndView model = null;
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		if(userinfo==null || userinfo.isVisitor()) {
			model = new ModelAndView("mobile/index");
			return model;
		}
		
		model = new ModelAndView("mobile/addAddress");
		
		//进入标识页，只有从确认快递页才有该值 
		String fromPage = req.getParameter("fromPage");
		if(StringUtils.isNotEmpty(fromPage)){
			model.addObject("fromPage", fromPage);
		}else{
			model.addObject("fromPage", "");
		}
		model.addObject("topicId", topicId);
		model.addObject("couponId", couponId);
		
		return model;
	}
	
	/**
	 * 获取快递列表
	 * @param req
	 * @param showCount
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value = "/getAddressList")
	@ResponseBody
	public Map<String, Object> getAddressList(HttpServletRequest req,
			@RequestParam String showCount) throws UnsupportedEncodingException {
		
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		Map<String, Object> datas = new HashMap<String, Object>();
		
		List<CpnOwnerAddressDto> list = ownerAddressFacadeService
				.getOwnedAddressList(userinfo.getUserid(),
						Integer.parseInt(showCount));
		
		datas.put("addressList", list);

		return datas;
	}
	
	/**
	 * 跳转到 物流物流订单详情页面
	 * @param topicId 
	 * @param couponId 
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value = "/logistOrderInfo")
	public ModelAndView logistOrderInfo(
			HttpServletRequest req,
			@RequestParam String topicId, 
			@RequestParam String couponId,
			@RequestParam String type,
			@RequestParam String logistInfo) throws UnsupportedEncodingException {
		
		ModelAndView model = null;
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		if(userinfo==null || userinfo.isVisitor()) {
			model = new ModelAndView("mobile/index");
			return model;
		}
		
			model = new ModelAndView("mobile/logistOrderInfo");
			CouponDetailDTO couponDetail = couponService.getCouponDetail(topicId, couponId);
			
			if(couponDetail == null) throw new RuntimeException("券不存在, topicId: " 
			+ topicId + ", couponId: " + couponId);
			model.addObject("picturePath", couponDetail.getWxListImage());
			model.addObject("topicId", topicId);
			model.addObject("couponId", couponId);
			model.addObject("amount", couponDetail.getAmount());
			model.addObject("price", couponDetail.getPrice());
			model.addObject("couponName", couponDetail.getCouponName());
			
			/*业务变更，确认订单页显示三条可选快递地址  2016-01-29 zhuyanqing start*/
			
//			if("0".equals(type)){//第一次进来选择默认地址
//				List<CpnOwnerAddressDto> list = ownerAddressFacadeService.getOwnedAddress(userinfo.getUserid(), 1,"1");
//				if(list!=null&&list.size()>0){
//					model.addObject("id", list.get(0).getOwnerAddressId());
//					model.addObject("name", list.get(0).getName());
//					model.addObject("tel", list.get(0).getTel());
//					model.addObject("pro", list.get(0).getPro());
//					model.addObject("city", list.get(0).getCity());
//					model.addObject("borough", list.get(0).getBorough());
//					model.addObject("detailAddress", list.get(0).getDetailAddress());
//				}else{
//					model.addObject("id", 0);
//					model.addObject("name", "");
//					model.addObject("tel", "");
//					model.addObject("pro", "");
//					model.addObject("city", "");
//					model.addObject("borough", "");
//					model.addObject("detailAddress", "");
//				}
//			}else{
//				if(!StringUtils.isEmpty(logistInfo)){
//				String addressArr[] = logistInfo.split("-");
//				model.addObject("id", addressArr[0]);
//				model.addObject("name", addressArr[1]);
//				model.addObject("tel", addressArr[2]);
//				model.addObject("pro", addressArr[3]);
//				model.addObject("city", addressArr[4]);
//				model.addObject("borough", addressArr[5]);
//				model.addObject("detailAddress", addressArr[6]);
//				}
//			}
			
			
//			List<CpnOwnerAddressDto> list = ownerAddressFacadeService.getOwnedAddressList(userinfo.getUserid(), 3);
//			if(list!=null&&list.size()>0){
//				model.addObject("addressList", list);
//			}else{
//				model.addObject("addressList", null);
//			}
			/*业务变更，确认订单页显示三条可选快递地址  2016-01-29 zhuyanqing end*/
		
		return model;
	}
	
	/**
	 * 跳转到 物流地址管理页面
	 * @param topicId 
	 * @param couponId 
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value = "/manageAddress", method = RequestMethod.GET)
	public ModelAndView manageAddress(
			HttpServletRequest req,
			@RequestParam String topicId, 
			@RequestParam String couponId) throws UnsupportedEncodingException {
		
		ModelAndView model = null;
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		if(userinfo==null || userinfo.isVisitor()) {
			model = new ModelAndView("mobile/index");
			return model;
		}
			model = new ModelAndView("mobile/manageAddress");
			model.addObject("topicId", topicId);
			model.addObject("couponId", couponId);
		return model;
	}
	/**
	 * 跳转到 关注页面
	 * @return ModelAndView 关注页面
	 */
	@RequestMapping(value = "/follow")
	public ModelAndView toFollow() {
		ModelAndView model = new ModelAndView("mock/follow");
		model.addObject("personFollowImg", personFollowImg);
		return model;
	}
}
