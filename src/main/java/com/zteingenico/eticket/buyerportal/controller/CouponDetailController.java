package com.zteingenico.eticket.buyerportal.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zteingenico.eticket.business.facade.dto.buyerportal.CouponDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.PositionDTO;
import com.zteingenico.eticket.business.facade.dto.fans.MemberDTO;
import com.zteingenico.eticket.business.facade.service.buyerportal.IBuyerPortalCouponFacadeService;
import com.zteingenico.eticket.business.facade.service.buyerportal.IBuyerPortalShareFacadeService;
import com.zteingenico.eticket.business.facade.service.buyerportal.IBuyerPortalTopicFacadeService;
import com.zteingenico.eticket.business.facade.service.checkrecord.ICheckRecFacadeService;
import com.zteingenico.eticket.business.facade.service.fans.IMemberFacadeService;
import com.zteingenico.eticket.buyerportal.services.SessionService;
import com.zteingenico.eticket.buyerportal.vo.UserSessionDTO;
import com.zteingenico.eticket.common.utils.CommUtil;

@Controller
@RequestMapping("/view/coupon")
public class CouponDetailController {

	@Resource
	private IBuyerPortalCouponFacadeService couponService;
	
	@Resource
	private IBuyerPortalShareFacadeService shareService;
	
	@Resource
	private SessionService sessionService;
	
	@Resource 
	private IBuyerPortalTopicFacadeService topicService;

	
	@Resource
	private IMemberFacadeService memberService;
	@Autowired
	private ICheckRecFacadeService checkRecFacadeService;
	
	@Value("#{propertiesHolder.get('buyer_weixin_domain')}")
	private String buyer_weixin_domain;
	
	@Value("#{propertiesHolder.get('buyer_portal_page_size')}")
	private int pageSize;
	
	/**
	 * 查询商户自提点
	 * @param orgId 商户ID
	 * @param req 
	 * @return 自提点DTO列表
	 */
	@RequestMapping(value = "/orgposition", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getOrgPositions(@RequestParam int orgId,
			HttpServletRequest req) {
		Map<String, Object> result = new HashMap<String, Object>();
		List<PositionDTO> positions = couponService.getOrgPositions(orgId);
		result.put("positions", positions);
		return result;
	}
	
	/**
	 * 查询 可送红包的券列表
	 */
	@RequestMapping(value = "/sendable", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getSendableCoupon(
			@RequestParam(required = false) Integer page,
			HttpServletRequest req) {
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		List<CouponDTO> couponList = couponService.getMyCoupon(userinfo.getUserid(), page);
		Map<String, Object> result = new HashMap<String, Object>(2);
		if (couponList.size() < (pageSize + 1)) {
			result.put("hasmore", false);
		} else {
			couponList.remove(couponList.size() - 1);
			result.put("hasmore", true);
		}
		result.put("coupons", couponList);
		return result;
	}
	
	/**
	 * 验券
	 */
	@RequestMapping(value = "/submtCheckCpn")
	@ResponseBody
	public Map<String, Object> submtCheckCpn(HttpServletRequest request,@RequestParam String serialNo,@RequestParam String userId) {
		//1判断帐号是否被禁用，2判断是否有权限验该券
		Map<String, Object> result = checkRecFacadeService.wxCheckCpn(serialNo.trim(),Long.parseLong(userId),CommUtil.getIpAddr(request));
		//此券有效
		if("1".equals(result.get("code"))||"2".equals(result.get("code"))){
			//如果存在 则显示该券信息
			Map<String,Object> dto   = topicService.getCouponTopic2(serialNo.trim(),(String) result.get("code"),"1");
			result.put("dto", dto);
		}
		return result;
	}
	
	
	
	/**
	 * 兑券
	 */
	@RequestMapping(value = "/submtUuseCpn")
	@ResponseBody
	public Map<String, Object> submtUuseCpn(HttpServletRequest request,@RequestParam String serialNo,@RequestParam String userId) {
		Map<String, Object> result = checkRecFacadeService.useCpn(serialNo,Long.parseLong(userId),CommUtil.getIpAddr(request));
		return result;
	}
	
	/**
	 * 绑定验券员
	 */
	@RequestMapping(value = "/bindCheckUser")
	@ResponseBody
	public Map<String, Object> bindCheckUser(
			@RequestParam String username,
			@RequestParam String password,
			@RequestParam String userid,
			HttpServletRequest req) {
		String returnStr ="9";//默认绑定失败
		Map<String, Object> result = new HashMap<String, Object>(2);
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		MemberDTO memberDTO = memberService.getMemberByUserId(userinfo.getUserid());
		if(memberDTO!=null&&memberDTO.getOrgPersonId()!=null&&memberDTO.getOrgPersonId()!=0){
			returnStr = "5";//该帐号已经绑定验券员
		}else{
			if(!StringUtils.isEmpty(userid)&&!StringUtils.isEmpty(username)&&!StringUtils.isEmpty(password)){
				returnStr = checkRecFacadeService.bingdCheckUser(userid, username, password);
			}
		}
		result.put("result", returnStr);
		return result;
	}
	
}
