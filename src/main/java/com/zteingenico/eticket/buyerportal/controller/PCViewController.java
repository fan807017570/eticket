package com.zteingenico.eticket.buyerportal.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.zteingenico.eticket.business.facade.dto.buyerportal.CouponDetailDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.OrderDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.RefundInfoDTO;
import com.zteingenico.eticket.business.facade.dto.system.SysCodeDto;
import com.zteingenico.eticket.business.facade.enums.coupon.OrderStatus;
import com.zteingenico.eticket.business.facade.service.buyerportal.IBuyerPortalCouponFacadeService;
import com.zteingenico.eticket.business.facade.service.buyerportal.IBuyerPortalOrderFacadeService;
import com.zteingenico.eticket.business.facade.service.system.ISysCodeFacadeService;
import com.zteingenico.eticket.buyerportal.services.PCLoginService;
import com.zteingenico.eticket.buyerportal.services.SessionService;
import com.zteingenico.eticket.buyerportal.vo.UserSessionDTO;
import com.zteingenico.eticket.common.dictionary.RefundReasonDict;


@Controller
@RequestMapping("/view/web")
public class PCViewController {
	
	@Resource
	private PCLoginService pcLoginService;
	@Resource
	private IBuyerPortalCouponFacadeService couponService;
	@Resource
	private SessionService sessionService;
	@Resource
	private IBuyerPortalOrderFacadeService orderService;
	@Autowired
	private ISysCodeFacadeService sysCodeFacadeService;

	
	/**
	 * 进入 我的通知页面
	 */
	@RequestMapping(value = "/usercenter/notice", method = RequestMethod.GET)
	public String toNotice(HttpServletRequest req) {
		return "pc/userCenter-notice";
	}
	
	/**
	 * 进入 我的红包页面
	 */
	@RequestMapping(value = "/usercenter/hongbao", method = RequestMethod.GET)
	public String toHongbao(HttpServletRequest req) {
		return "pc/userCenter-hongbao";
	}
	
	/**
	 * 进入 我领的券页面
	 */
	@RequestMapping(value = "/usercenter/ticket", method = RequestMethod.GET)
	public String toTicket(HttpServletRequest req) {
		return "pc/userCenter-ticket";
	}
	
	/**
	 * 查询券详情信息
	 * @param topicid 券主题ID
	 * @param couponid 券ID
	 * @return 券详情信息页面
	 */
	@RequestMapping(value = "/detail", method = RequestMethod.GET)
	public ModelAndView detail(
			@RequestParam String topicId, 
			@RequestParam String couponId) {
		
		ModelAndView model = new ModelAndView("pc/userCenter-ticketInfo");
		CouponDetailDTO couponDetail = couponService.getCouponDetail(topicId, couponId);
		if(couponDetail == null) throw new RuntimeException("券不存在, topicId: " 
		+ topicId + ", couponId: " + couponId);
		model.addObject("coupon", couponDetail);
		return model;
	}
	
	/**
	 * 进入 提交订单也没
	 * @Title: paymentStep1 
	 * @param topicId 卷id
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value={ "/payment_step1.htm" }, method = RequestMethod.GET)
	public String paymentStep1(String topicId,HttpServletRequest request, HttpServletResponse response,ModelMap model){
//		UserSessionDTO userinfo = sessionService.getUserInfoInSession(request);
		if(topicId == null || "".equals(topicId)){
			return "redirect:/resources/html/404.html";
		}
//		if(null == userinfo){
//			SessionService session = new SessionService();
//			userinfo = new UserSessionDTO();
//			long tempUserId = -System.nanoTime();
//			userinfo.setUserid(tempUserId);
//			userinfo.setUserType(UserType.GUEST);
//			session.login(userinfo, request);
//		}
//		ConfirmOrderDTO order = topicService.getConfirmInfoByTopicid(userinfo.getUserid(),topicId);
//		model.put("order", order);
		model.put("number", 1);
		model.put("topicId", topicId);
		return "pc/paymentStep1";
	}
	
	/**
	 * 进入 微信支付页面
	 * @Title: paymentStep2 
	 * @param orderid 订单id
	 * @param codeUrl 微信支付链接
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value={ "/payment_step2.htm" })
	public String paymentStep2(String orderid,String codeUrl,HttpServletRequest request, HttpServletResponse response,ModelMap model){
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(request);
		if(userinfo == null || userinfo.isVisitor()){
			return "redirect:/resources/html/404.html";
		}
		if(orderid == null || "".equals(orderid)){
			return "redirect:/resources/html/404.html";
		}
		OrderDTO order = orderService.getOrderById(orderid);
		if(OrderStatus.FOR_PAY == order.getOrderStatus()){
			model.put("codeUrl", codeUrl);
			model.put("orderid", orderid);
		}else{
			return "redirect:/resources/html/404.html";
		}
		return "pc/paymentStep2";
	}
	
	/**
	 * 进入 支付成功页面
	 * @Title: paymentStep3 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value={ "/payment_step3.htm" })
	public String paymentStep3(HttpServletRequest request, HttpServletResponse response,ModelMap model){
		return "pc/paymentStep3";
	}
	
	/**
	 * 进入 退款申请页面
	 * @Title: refundApply 
	 * @param orderid 订单id
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value={ "/refund_apply.htm" })
	public String refundApply(String couponName,String couponPrice,String couponId,
			HttpServletRequest request, HttpServletResponse response,ModelMap model){
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(request);
		if(userinfo == null || userinfo.isVisitor()){
			return "redirect:web/index";
		}
		model.put("couponName", couponName);
		model.put("couponPrice", couponPrice);
		model.put("couponId", couponId);
		model.put("dicts", RefundReasonDict.dicts);
		return "pc/refundApply";
	}
	
	/**
	 * 提交退款申请
	 * @Title: refundApplySave 
	 * @param reasonKey 退款申请原因
	 * @param couponId 券实例ID
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value={ "/refund_apply_save.htm" })
	public String refundApplySave(String reasonKey,String couponId,HttpServletRequest request, HttpServletResponse response,ModelMap model){
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(request);
		if(userinfo == null || userinfo.isVisitor()){
			return "redirect:web/index";
		}
		String redirectUrl = "";
		if(RefundReasonDict.dicts.containsKey(reasonKey)) {
			RefundInfoDTO refund = orderService.handleRefundApply(
					userinfo.getUserid(), couponId, reasonKey);
			// 退款申请处理成功
			if(refund!=null && refund.isSuccess()) {
				// 跳转到 退款单详情页面
				model.put("refund", refund);
				redirectUrl =  "redirect:web/refund_detail.htm?couponId=" + couponId;
			} else {
				redirectUrl =  "redirect:/resources/html/404.html";
			}
		} else {
			redirectUrl =  "redirect:/resources/html/404.html";
		}
		return redirectUrl;
	}
	
	/**
	 * 退款单页面点击 退款详情 跳转到 退款详情页面
	 */
	@RequestMapping(value = "/refund_detail.htm", method = RequestMethod.GET)
	public String refundDetail(String couponId,String couponName,HttpServletRequest request, 
			HttpServletResponse response,ModelMap model) {
		String redirectUrl = "redirect:/resources/html/404.html";
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(request);
		if(userinfo == null || userinfo.isVisitor()){
			return redirectUrl;
		}
		
		RefundInfoDTO refund = orderService.getRefundInfoByCouponId(userinfo.getUserid(), couponId);
		if(refund!=null) {
			redirectUrl = "pc/refundDetails";
			model.put("refund", refund);
		}
		return redirectUrl;
	}
	
	/**
	 * 退款帮助页面
	 */
	@RequestMapping(value = "/refund_help.htm", method = RequestMethod.GET)
	public String refundHelp(String couponId,HttpServletRequest request, 
			HttpServletResponse response,ModelMap model) {
		String redirectUrl = "redirect:/resources/html/404.html";
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(request);
		if(userinfo == null || userinfo.isVisitor()){
			return redirectUrl;
		}
		SysCodeDto codeDto = sysCodeFacadeService.querySysCodeByCode("refundhelp");
		String contentStr = "";
		if(null != codeDto){
			contentStr = codeDto.getDescription();
		}
		model.put("content", contentStr);
		redirectUrl = "pc/refundHelp";
		return redirectUrl;
	}
	

	
}
