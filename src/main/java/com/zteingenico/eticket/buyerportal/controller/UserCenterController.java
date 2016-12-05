package com.zteingenico.eticket.buyerportal.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.zxing.BarcodeFormat;
import com.zteingenico.eticket.business.facade.dto.buyerportal.ConfirmOrderDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.CouponDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.CouponStatisticsDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.ShareDTO;
import com.zteingenico.eticket.business.facade.enums.coupon.OrderStatus;
import com.zteingenico.eticket.business.facade.enums.member.UserType;
import com.zteingenico.eticket.business.facade.service.buyerportal.IBuyerPortalCouponFacadeService;
import com.zteingenico.eticket.business.facade.service.buyerportal.IBuyerPortalOrderFacadeService;
import com.zteingenico.eticket.business.facade.service.buyerportal.IBuyerPortalShareFacadeService;
import com.zteingenico.eticket.business.facade.service.buyerportal.IBuyerPortalTopicFacadeService;
import com.zteingenico.eticket.buyerportal.services.PCLoginService;
import com.zteingenico.eticket.buyerportal.services.SessionService;
import com.zteingenico.eticket.buyerportal.utils.BarcodeImageFormat;
import com.zteingenico.eticket.buyerportal.utils.GenerateBarcode;
import com.zteingenico.eticket.buyerportal.vo.UserSessionDTO;

/** PC用户中心数据查询 */
@Controller
@RequestMapping("/view/user")
public class UserCenterController {
	
//	@Resource
//	private pCLoginService pCLoginService;
	
	@Resource
	private PCLoginService pCLoginService;
	
	@Resource
	private IBuyerPortalCouponFacadeService couponService;
	
	@Resource
	private IBuyerPortalShareFacadeService shareService;
	
	@Resource
	private IBuyerPortalOrderFacadeService orderService;
	
	@Autowired
	private IBuyerPortalTopicFacadeService topicService;
	
	@Value("#{propertiesHolder.get('query_expirding_max_day')}")
	private int queryExpirdingMaxDay;
	
	@Value("#{propertiesHolder.get('buyer_portal_page_size')}")
	private int pageSize;
	
	/**
	 * 查询券数量统计信息
	 */
	@RequestMapping(value = "/statistics", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getStatistics(HttpServletRequest req) {
		
		UserSessionDTO userInfo = pCLoginService.getUserInfoInSession(req);
		CouponStatisticsDTO statistics = couponService.getCouponStatistics(
				userInfo.getUserid(), 
				this.queryExpirdingMaxDay);
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("statistics", statistics);
		return result;
	}
	
	/**
	 * 查询我的通知
	 */
	@RequestMapping(value = "/notice", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getNotice(HttpServletRequest req) {
		
		UserSessionDTO userInfo = pCLoginService.getUserInfoInSession(req);
		
		List<CouponDTO> notices = couponService.getMyNearExpiredCoupon(
				userInfo.getUserid(), 
				this.queryExpirdingMaxDay);
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("notices", notices);
		return result;
	}
	
	/**
	 * 查询我的红包 - 收到的红包
	 */
	@RequestMapping(value = "/received", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getRecieved(
			@RequestParam int page,
			HttpServletRequest req) {
		
		UserSessionDTO userInfo = pCLoginService.getUserInfoInSession(req);
		
		List<ShareDTO> receiveds = shareService.getMyReceivedCoupon(userInfo.getUserid(), page);
		
		Map<String, Object> result = new HashMap<String, Object>();
		if (receiveds.size() < (pageSize + 1)) {
			result.put("hasmore", false);
		} else {
			receiveds.remove(receiveds.size() - 1);
			result.put("hasmore", true);
		}
		result.put("receiveds", receiveds);
		return result;
	}
	
	/**
	 * 查询我的红包 - 送出的红包
	 */
	@RequestMapping(value = "/sended", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getSended(
			@RequestParam int page,
			HttpServletRequest req) {
		
		UserSessionDTO userInfo = pCLoginService.getUserInfoInSession(req);
		
		List<ShareDTO> sendeds = shareService.getMySharedCoupon(userInfo.getUserid(), page);
		
		Map<String, Object> result = new HashMap<String, Object>();
		if (sendeds.size() < (pageSize + 1)) {
			result.put("hasmore", false);
		} else {
			sendeds.remove(sendeds.size() - 1);
			result.put("hasmore", true);
		}
		result.put("sendeds", sendeds);
		return result;
	}
	
	/**
	 * 查询我领的券 - 未使用
	 */
	@RequestMapping(value = "/unused", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getUnused(
			@RequestParam int page,
			HttpServletRequest req) {
		
		UserSessionDTO userInfo = pCLoginService.getUserInfoInSession(req);
		
		List<CouponDTO> unuseds = couponService.getMyCoupon(userInfo.getUserid(), page);
		
		Map<String, Object> result = new HashMap<String, Object>();
		if (unuseds.size() < (pageSize + 1)) {
			result.put("hasmore", false);
		} else {
			unuseds.remove(unuseds.size() - 1);
			result.put("hasmore", true);
		}
		result.put("unuseds", unuseds);
		return result;
	}
	
	/**
	 * 查询我领的券 - 已使用
	 */
	@RequestMapping(value = "/used", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getUsed(
			@RequestParam int page,
			HttpServletRequest req) {
		
		UserSessionDTO userInfo = pCLoginService.getUserInfoInSession(req);
		
		List<CouponDTO> useds = couponService.getMyUsedCoupon(userInfo.getUserid(), page);
		
		Map<String, Object> result = new HashMap<String, Object>();
		if (useds.size() < (pageSize + 1)) {
			result.put("hasmore", false);
		} else {
			useds.remove(useds.size() - 1);
			result.put("hasmore", true);
		}
		result.put("useds", useds);
		return result;
	}
	
	/**
	 * 查询我领的券 - 已过期
	 */
	@RequestMapping(value = "/expired", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getExpired(
			@RequestParam int page,
			HttpServletRequest req) {
		
		UserSessionDTO userInfo = pCLoginService.getUserInfoInSession(req);
		
		List<CouponDTO> expireds = couponService.getMyExpiredCoupon(userInfo.getUserid(), page);
		
		Map<String, Object> result = new HashMap<String, Object>();
		if (expireds.size() < (pageSize + 1)) {
			result.put("hasmore", false);
		} else {
			expireds.remove(expireds.size() - 1);
			result.put("hasmore", true);
		}
		result.put("expireds", expireds);
		return result;
	}
	
	@RequestMapping(value = "/refund", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getMyRefundConpons(
			@RequestParam(required = false) Integer page,
			HttpServletRequest req) {
		UserSessionDTO userinfo = pCLoginService.getUserInfoInSession(req);
		List<CouponDTO>  coupons = couponService.getMyRefundCoupon(userinfo.getUserid(), page);
		Map<String, Object> datas = new HashMap<String, Object>(2);
		if (coupons.size() < (pageSize + 1)) {
			datas.put("hasmore", false);
		} else {
			coupons.remove(coupons.size() - 1);
			datas.put("hasmore", true);
		}
		datas.put("coupons", coupons);
		return datas;
	}
	
	/**
	 * 支付结果查询
	 * @param orderid 订单id
	 * @return
	 */
	@RequestMapping(value={ "/payment_result.htm" })
	@ResponseBody
	public Map<String, Object> paymentResult(String orderid,HttpServletRequest request, HttpServletResponse response,ModelMap model){
		UserSessionDTO userinfo = pCLoginService.getUserInfoInSession(request);
		if(null == userinfo || userinfo.isVisitor()){
			return createResult(-1, "请先进行登录");
		}
		if(orderid == null || "".equals(orderid)){
			return createResult(-2, "订单无效");
		}
		OrderStatus orderStatus = orderService.getOrderStatusById(orderid);
		if(null == orderStatus){
			return createResult(-3, "订单无效");
		}
		return createResult(orderStatus.getCode(),orderStatus.getName());
	}
	
	@RequestMapping(value = "/doevaluate", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> doEvaluate(HttpServletRequest req, @RequestParam String couponId, @RequestParam int point) {
		UserSessionDTO userinfo = pCLoginService.getUserInfoInSession(req);
		if (null == userinfo || userinfo.isVisitor()) {
			return createResult(0,"评论失败");
		}
		try {
			couponService.markTopic(couponId, userinfo.getUserid(), point);
		} catch (Exception e) {
			return createResult(0,"评论失败");
		}
		return createResult(1,"评论成功");
	}
	
	private Map<String, Object> createResult(
			int code, String message) {
		Map<String, Object> datas = new HashMap<String, Object>(2);
		datas.put("code", code);
		datas.put("message", message);
		return datas;
	}
	
	
	@RequestMapping(value={ "/qrcode.htm" })
	@ResponseBody
	public void qrCode(String download,String content,HttpServletRequest request, HttpServletResponse response,ModelMap model){
        if (content != null && !"".equals(content)) {
            ServletOutputStream stream = null;
            try {
            	if(!StringUtils.isBlank(download) && "yes".equals(download)){
            		response.setContentType("image/jpeg");
            		response.setHeader("Content-type: ", "image/jpeg");
            		response.setHeader("content-disposition", "attachment;fileName=qrcode.jpeg");
            	}
				stream = response.getOutputStream();
				
            	new GenerateBarcode().outputBarcode(content, BarcodeImageFormat.jpeg, 99, 99, BarcodeFormat.QR_CODE, stream);
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (stream != null) {
                    try {
						stream.flush();
						stream.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
                    
                }
            }
        }
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
	@RequestMapping(value={ "/paymentinfo.htm" }, method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> paymentStep1(String topicId,HttpServletRequest request, HttpServletResponse response,ModelMap model){
		UserSessionDTO userinfo = pCLoginService.getUserInfoInSession(request);
		if(null == userinfo){
			SessionService session = new SessionService();
			userinfo = new UserSessionDTO();
			long tempUserId = -System.nanoTime();
			userinfo.setUserid(tempUserId);
			userinfo.setUserType(UserType.GUEST);
			session.login(userinfo, request);
		}
		ConfirmOrderDTO order = topicService.getConfirmInfoByTopicid(userinfo.getUserid(),topicId);
		Map<String, Object> datas = new HashMap<String, Object>();
		datas.put("number", 0);
		if(null != order){
			datas.put("token", order.getToken());
			datas.put("price", order.getPrice());
			datas.put("topicId", order.getTopicid());
			datas.put("topicName", order.getTopicName());
			datas.put("number", 1);
		}
		return datas;
	}
	
	@RequestMapping(value={ "/payqrcode.htm" })
	@ResponseBody
	public void createPayQrCode(String content,HttpServletRequest request, HttpServletResponse response,ModelMap model){
		UserSessionDTO userinfo = pCLoginService.getUserInfoInSession(request);
		if(null == userinfo || userinfo.isVisitor()){
			return;
		}
        if (content != null && !"".equals(content)) {
            ServletOutputStream stream = null;
            try {
				stream = response.getOutputStream();
            	new GenerateBarcode().outputBarcode(content, BarcodeImageFormat.jpeg, 200, 200, BarcodeFormat.QR_CODE, stream);
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (stream != null) {
                    try {
						stream.flush();
						stream.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
                    
                }
            }
        }
	}
	
}
