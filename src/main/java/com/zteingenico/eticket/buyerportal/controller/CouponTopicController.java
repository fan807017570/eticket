package com.zteingenico.eticket.buyerportal.controller;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zteingenico.eticket.business.facade.dto.buyerportal.CheckTopicResultDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.TopicDTO;
import com.zteingenico.eticket.business.facade.service.buyerportal.IBuyerPortalTopicFacadeService;
import com.zteingenico.eticket.business.facade.service.weixin.IWexinFacadeService;
import com.zteingenico.eticket.buyerportal.services.SessionService;
import com.zteingenico.eticket.buyerportal.vo.UserSessionDTO;

@Controller
@RequestMapping("/view/topic")
public class CouponTopicController {
	
	private static final Logger logger = LoggerFactory.getLogger(CouponTopicController.class);
	
	@Resource 
	private IBuyerPortalTopicFacadeService topicService;
	
	@Resource
	private IWexinFacadeService  weixinService;

	@Resource
	private SessionService sessionService;
	
	@Value("#{propertiesHolder.get('buyer_weixin_domain')}")
	private String buyer_weixin_domain;
	
	@Value("#{propertiesHolder.get('buyer_portal_page_size')}")
	private int pageSize;

	@RequestMapping(value = "/list", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getTopics(
			@RequestParam(required = false) Integer page,
			@RequestParam(required = false) String catalog,
			@RequestParam(required = false) String group,
			@RequestParam(required = false) String order, 
			HttpServletRequest req) {
		Map<String, Object> datas = new HashMap<String, Object>(2);
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		if(userinfo!=null) {
			List<TopicDTO> topics = topicService.getCouponTopics(catalog, group,
					order, userinfo.getUserType().getCode(), page);
			if (topics.size() < (pageSize + 1)) {
				datas.put("hasmore", false);
			} else {
				topics.remove(topics.size() - 1);
				datas.put("hasmore", true);
			}
			datas.put("topics", topics);
		} else {
			datas.put("hasmore", false);
			datas.put("topics", Collections.EMPTY_LIST);
		}
		
		return datas;
	}

	/**
	 * 用于抢券的静态页查询当前券状态是否可抢,仅用于微信端
	 */
	@RequestMapping(value = "/status", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getTopicStatus(@RequestParam String topicid,
			@RequestParam(required=false) String htmlurl,
			HttpServletRequest req) {
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		sessionService.saveSessionFreeCouponToken(req);
		Map<String, Object> datas = new HashMap<String, Object>(2);
		if(userinfo==null){
			datas.put("resultCode","NOUSER");
			datas.put("errorMsg","");
			return datas;
		}
		int takenNum = topicService.getUserTakenNum(topicid, userinfo.getUserid());
		CheckTopicResultDTO result = topicService.checkCondition(userinfo.getUserType(),topicid,takenNum);
		
		logger.info("getTopicStatus-----" + htmlurl);
		if(htmlurl!=null){
			logger.info("getTopicStatus-----" + htmlurl);
			String jsapiparams = weixinService.getShareBaseConfigParams(htmlurl);
			logger.info("getTopicStatus-----" + jsapiparams);
			datas.put("jsapiConfig", jsapiparams);
		}
		long []  reuslts = topicService.getTakenNumsAndRemainDays(topicid);
		if(reuslts.length==3){
			datas.put("takenTotals", reuslts[0]);
			datas.put("beginTime", reuslts[1]);
			datas.put("endTime", reuslts[2]);
		}
		datas.put("resultCode", Boolean.toString(result.isAvailable()));
		datas.put("errorMsg", result.getTipsMessage());
		return datas;
	}

}
