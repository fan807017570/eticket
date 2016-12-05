package com.zteingenico.eticket.buyerportal.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zteingenico.eticket.business.facade.dto.buyerportal.JoinerDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.ShareDTO;
import com.zteingenico.eticket.business.facade.service.buyerportal.IBuyerPortalShareFacadeService;
import com.zteingenico.eticket.buyerportal.services.SessionService;
import com.zteingenico.eticket.buyerportal.vo.UserSessionDTO;

@Controller
@RequestMapping("/view/share")
public class CouponShareController {

	@Resource
	private SessionService sessionService;
	
	@Resource
	private IBuyerPortalShareFacadeService shareService;
	
	@Value("#{propertiesHolder.get('buyer_weixin_domain')}")
	private String buyer_weixin_domain;
	
	@Value("#{propertiesHolder.get('buyer_portal_page_size')}")
	private int pageSize;
	
	/**
	 * 查询 我送出的红包
	 */
	@RequestMapping(value = "/shared", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getMySharedCoupon(
			@RequestParam(required = false) Integer page,
			HttpServletRequest req) {
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		List<ShareDTO> list = shareService.getMySharedCoupon(userinfo.getUserid(), page);
		Map<String, Object> result = new HashMap<String, Object>(2);
		if (list.size() < (pageSize + 1)) {
			result.put("hasmore", false);
		} else {
			list.remove(list.size() - 1);
			result.put("hasmore", true);
		}
		result.put("shares", list);
		return result;
	}
	
	/**
	 * 查询 我收到的红包
	 */
	@RequestMapping(value = "/received", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getMyReceivedCoupon(
			@RequestParam(required = false) Integer page,
			HttpServletRequest req) {
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		List<ShareDTO> list = shareService.getMyReceivedCoupon(userinfo.getUserid(), page);
		Map<String, Object> result = new HashMap<String, Object>(2);
		if (list.size() < (pageSize + 1)) {
			result.put("hasmore", false);
		} else {
			list.remove(list.size() - 1);
			result.put("hasmore", true);
		}
		result.put("shares", list);
		return result;
	}
	
	/**
	 * 用户确认分享后的回调地址
	 */
	@RequestMapping(value = "/confirm", method = RequestMethod.GET)
	@ResponseBody
	public String confirmShare(
			@RequestParam String couponId,
			HttpServletRequest req) {
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		if(userinfo!=null){
			shareService.shareCoupon(couponId, userinfo.getUserid());
		}
		return "true";
	}
	
	/**
	 * 查询 参与抢红包人信息
	 */
	@RequestMapping(value = "/joiner", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getJoinerList(
			@RequestParam Long userId,
			@RequestParam Long couponId,
			@RequestParam Integer page) {
		List<JoinerDTO> list = shareService.getJoinerDTOList(
				userId, 
				couponId, 
				page);
		Map<String, Object> result = new HashMap<String, Object>(2);
		if (list.size() < (this.pageSize + 1)) {
			result.put("hasmore", false);
		} else {
			list.remove(list.size() - 1);
			result.put("hasmore", true);
		}
		result.put("joiners", list);
		return result;
	}
}
