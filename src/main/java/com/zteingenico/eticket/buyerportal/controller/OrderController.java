package com.zteingenico.eticket.buyerportal.controller;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zteingenico.eticket.business.facade.dto.buyerportal.CheckTopicResultDTO;
import com.zteingenico.eticket.business.facade.dto.payment.UnifiedOrderDTO;
import com.zteingenico.eticket.business.facade.dto.payment.WeixinJSPaymentDTO;
import com.zteingenico.eticket.business.facade.service.buyerportal.IBuyerPortalOrderFacadeService;
import com.zteingenico.eticket.business.facade.service.buyerportal.IBuyerPortalTopicFacadeService;
import com.zteingenico.eticket.business.facade.service.order.ICpnOrderLineFacadeService;
import com.zteingenico.eticket.business.facade.service.payment.IBuyerPaymentFacadeService;
import com.zteingenico.eticket.buyerportal.services.SessionService;
import com.zteingenico.eticket.buyerportal.vo.UserSessionDTO;
import com.zteingenico.eticket.common.payment.enums.UnifiedOrderType;
import com.zteingenico.eticket.common.utils.CookieUtil;
import com.zteingenico.eticket.common.utils.WeixinUtil;

@Controller
@RequestMapping("/view/order")
public class OrderController {

	private static final String VISITOR_TAKEN_NUMBERS_PREFIX = "visitor_taken_numbers_";

	private static final Logger logger = LoggerFactory
			.getLogger(OrderController.class);

	@Resource
	private IBuyerPortalOrderFacadeService orderService;

	@Resource
	private IBuyerPortalTopicFacadeService topicService;

	@Resource
	private IBuyerPaymentFacadeService paymentService;

	@Resource
	private SessionService sessionService;
	
	@Resource 
	private ICpnOrderLineFacadeService cpnOrderLineService;

	@RequestMapping(value = "/create", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> createOrder(HttpServletRequest req,
			HttpServletResponse res, @RequestParam String topicid,
			@RequestParam String token) {
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		if(userinfo==null){
			return createResult(true, "invalid_token","","订单已过期，请重新下单");
		}
		//验证未付款的券数是否超过了3张
//		boolean valid = cpnOrderLineService.getUnPayCount(
//				userinfo.getUserid(), topicid);
//		if (!valid) {
//			return createResult(true, "invalid_token","","未支付的订单超过3张了，请先支付！");
//		}
		// 验证订单token
		boolean validToken = topicService.verifyOrderToken(
				userinfo.getUserid(), token, topicid);
		if (!validToken) {
			return createResult(true, "invalid_token","","订单已过期，请重新下单");
		}
		int userTakenNums = getUserTakenCouponNums(userinfo,req,topicid);
		// 验证topic状态
		CheckTopicResultDTO status = topicService.checkCondition(
		userinfo.getUserType(), topicid,userTakenNums);
		if (!status.isAvailable()) {
			return createResult(true, Boolean.toString(status.isAvailable()), "", status.getTipsMessage());
		}
		// PC端游客抢券,不创建订单，直接返回券码
		if (userinfo.isVisitor()) {
			return takeCouponByVistor(topicid,userTakenNums,req,res);
			// 会员领券
		} else {
			boolean isWeixin = WeixinUtil.isWeixinAgent(req);
			// 如果是有价的券
			if (!topicService.isFree(topicid)) {
				return initPayment(isWeixin, userinfo, topicid);
			} else {
				return takeFreeCoupon(topicid, userinfo);
			}
		}
	}

	/**
	 * 游客领券，不生成订单，直接返回券码
	 */
	private Map<String, Object> takeCouponByVistor(String topicid,
			int takenNums,
			HttpServletRequest req, HttpServletResponse res) {
		String couponCode = topicService
				.takeCouponByVisitor(topicid, takenNums);
		if (!StringUtils.isBlank(couponCode)) {
			takenNums++;
			CookieUtil.createCookie(VISITOR_TAKEN_NUMBERS_PREFIX + topicid,
					String.valueOf(takenNums), null, 30*24*60*60, res);
			Map<String, Object> result = createResult(false, "success", "",null);
			result.put("couponCode", couponCode);
			logger.info("游客领券成功，领取的券码为:" + couponCode);
			return result;
		} else {
			logger.error("游客领券失败，无券码返回！");
			return createResult(false,"failed","","领券失败");
		}
	}

	/**
	 * 如果是有价券，需要初始化相关的支付参数
	 */
	private Map<String, Object> initPayment(boolean isWeixin,
			UserSessionDTO userinfo, String topicid) {
		String orderid = orderService.createOrderId(topicid);
		logger.info("生成的内部订单ID为:" + orderid);
		UnifiedOrderType orderType = null;
		if (isWeixin) {
			// 公众号支付
			orderType = UnifiedOrderType.JSAPI;
		} else {
			// 扫码支付
			orderType = UnifiedOrderType.NATIVE;
		}
		UnifiedOrderDTO unifiedOrder = paymentService.createOutOrder(topicid,
				orderid, orderType, userinfo.getUserid());
		if (unifiedOrder == null || unifiedOrder.getPrepayId()==null) {
			logger.error("创建外部订单号失败！");
			return createResult(true,"failed","","调用微信接口失败");
		}
		logger.info("成功创建外部订单，外部订单号为:" + unifiedOrder.getPrepayId());
		String couponCode = orderService.createOrder(orderid,
				unifiedOrder.getPrepayId(), orderType, userinfo.getUserid(),
				topicid);
		if (StringUtils.isBlank(couponCode)) {
			logger.error("创建内部订单失败！");
			return createResult(true, "failed", "","订单创建失败");
		}
		Map<String, Object> result = createResult(true, "success", orderid,null);
		if (isWeixin) {
			// 初始化微信JS支付的相关数据
			WeixinJSPaymentDTO params = paymentService
					.prepareJSPaymentParams(unifiedOrder.getPrepayId());
			result.put("jsparams", params);
		} else {
			// 初始化PC端扫码支付的二维码链接
			result.put("codeUrl", unifiedOrder.getCodeUrl());
		}
		return result;
	}

	/**
	 * 处理领取免费券的情况，无需进行支付，直接生成订单
	 */
	private Map<String, Object> takeFreeCoupon(String topicid,
			UserSessionDTO userinfo) {
		String orderid = topicService.takeFreeCouponByMember(topicid,
				userinfo.getUserid());
		if (!StringUtils.isBlank(orderid)) {
			logger.info("领取免费券成功，领券用户ID为：" + userinfo.getUserid() + ",topicid:"
					+ topicid);
			return createResult(false, "success", orderid,null);
		} else {
			logger.error("领取免费券失败，领券用户ID为：" + userinfo.getUserid()
					+ ",topicid:" + topicid);
			return createResult(false,"failed","","订单生成失败");
		}
	}

	private Map<String, Object> createResult(boolean needPay,
			String resultCode,String orderid,String errorMsg) {
		Map<String, Object> datas = new HashMap<String, Object>(3);
		datas.put("needPay", needPay);
		datas.put("resultCode", resultCode);
		datas.put("orderid", orderid);
		datas.put("errorMsg", errorMsg);
		return datas;
	}
	
	private int  getUserTakenCouponNums(UserSessionDTO user,HttpServletRequest req, String topicid){
		if(user.isVisitor()){
			String tempStr = CookieUtil.getCookieValue(VISITOR_TAKEN_NUMBERS_PREFIX
					+ topicid, req);
			if (tempStr != null) {
				return Integer.parseInt(tempStr);
			}
			return 0;
		}else{
			return topicService.getUserTakenNum(topicid, user.getUserid());
		}
	}

}
