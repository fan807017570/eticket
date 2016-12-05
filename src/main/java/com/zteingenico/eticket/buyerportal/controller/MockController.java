package com.zteingenico.eticket.buyerportal.controller;

import java.io.IOException;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.zteingenico.eticket.business.facade.service.buyerportal.IBuyerPortalTopicFacadeService;
import com.zteingenico.eticket.buyerportal.services.SessionService;

@Controller
@RequestMapping("/view/mock")
public class MockController {
	
	@Resource
	private SessionService sessionService;
	
	@Resource 
	private IBuyerPortalTopicFacadeService topicService;
	
	@RequestMapping(value = "/topicdetail", method = RequestMethod.GET)
	public void mockTopicDetail(
			@RequestParam String topicId,
			HttpServletRequest req,
			HttpServletResponse res) throws IOException {
		
		byte[] bytes = topicService.generateTopicDetailPage(topicId);
		
		if(bytes!=null) {
			res.getOutputStream().write(bytes);
			res.getOutputStream().flush();
			res.getOutputStream().close();
		}
	}
	
	@RequestMapping(value = "/mockindex", method = RequestMethod.GET)
	public String mockindex(){
		return "mock/mockindex";
	}

	
	
	@RequestMapping(value = "/topicdetailPC", method = RequestMethod.GET)
	public void mockTopicDetailPC(
			@RequestParam String topicId,
			HttpServletRequest req,
			HttpServletResponse res) throws IOException {
		
		byte[] bytes = topicService.pCgenerateCpnDetailPage(topicId);
		
		if(bytes!=null) {
			res.getOutputStream().write(bytes);
			res.getOutputStream().flush();
			res.getOutputStream().close();
		}
	}
	


	
}
