package com.zteingenico.eticket.buyerportal.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zteingenico.eticket.business.facade.dto.lottery.LotteryDTO;
import com.zteingenico.eticket.business.facade.service.lottery.ILotteryFacadeService;

@Controller
@RequestMapping("/lottery")
public class LotteryController {

	@Autowired
	private ILotteryFacadeService lotteryFacadeService;

	/**
	 * 跳转到抢券列表页面
	 */
	@RequestMapping(value={ "/toLotteryPage" }, method = RequestMethod.GET)
	public String toLotteryPage(HttpServletRequest request){
		return "mock/lotteryList_new";
	}
	
	/**
	 * 查询抢券名单
	 */
	@RequestMapping(value = "/getLotteryList", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getLotteryList(HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> result = new HashMap<String, Object>();
		List<LotteryDTO> list = lotteryFacadeService.getLotteryList(null);
		result.put("data", list);
		return result;
	}
}
