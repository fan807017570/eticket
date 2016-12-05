package com.zteingenico.eticket.buyerportal.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.zteingenico.eticket.business.facade.dto.adv.AdvParamsDTO;
import com.zteingenico.eticket.business.facade.dto.adv.CpnAdvDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.GdClassDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.TopicDTO;
import com.zteingenico.eticket.business.facade.service.adv.ICpnAdvFacadeService;
import com.zteingenico.eticket.business.facade.service.buyerportal.IBuyerPortalTopicFacadeService;
import com.zteingenico.eticket.business.facade.service.coupon.ICouponClassFacadeService;
import com.zteingenico.eticket.business.facade.service.cpnweb.ICpnwebFacadeService;
import com.zteingenico.eticket.business.facade.service.system.ISysAreaFacadeService;
import com.zteingenico.eticket.business.facade.service.system.ISysDataCodeFacadeService;
import com.zteingenico.eticket.business.facade.service.system.ISysLeaguePersonFacadeService;
import com.zteingenico.eticket.buyerportal.services.PCLoginService;
import com.zteingenico.eticket.common.Pagination;
//import com.zteingenico.eticket.buyerportal.services.SessionService;

/**
 * 类  编  号：
 * 类  名  称：WebEntryController
 * 类  描  述：网页端入口  首页以及登录注销
 * 完成日期：2015年1月4日
 * 编码作者：卢志方
 */

@Controller("webEntryController")
public class WebEntryController {
	
	//private static final String VISITOR_TAKEN_NUMBERS_PREFIX = "visitor_taken_numbers_";
	
	@Autowired
	private ICpnwebFacadeService cpnwebFacadeService;

	@Autowired
	private IBuyerPortalTopicFacadeService topicService;
	
	@Autowired
	private ICouponClassFacadeService couponClassFacadeService;
	
	@Resource
	private PCLoginService pcLoginService;
	
	
	@Autowired
	private ISysLeaguePersonFacadeService sysLeaguePersonservice;
	@Autowired
	private ISysDataCodeFacadeService sysDataCodeService;//数据字典服务
	@Autowired
	private ISysAreaFacadeService sysAreaService;//地区服务

	
//	@Value("#{properties.upload_file_domain}")
//	private String upload_file_domain;
	
	@Resource
	private ICpnAdvFacadeService cpnAdvFacadeService;

	
	private static int GOODS_CLASS_LEVEL_1 = 1;  //商品一级类别  父类为0
	
	private static int TOPIC_STATUS_5 = 5;  //已发布的券

	/**
	 * 方法说明：门户首页
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value={ "/" }, method = RequestMethod.GET)
	public String cpnIndex(HttpServletRequest request, HttpServletResponse response,ModelMap model){
			
//		int userType = getUserType(request);
		
		Map<String, Object> advParams1 = new HashMap<String, Object>();
		Map<String, Object> advParams2 = new HashMap<String, Object>();
		advParams1.put("advPosition", 1);
		advParams2.put("advPosition", 2);
		//获取滚动广告图片和链接
		List<AdvParamsDTO> bannerAdvList = cpnAdvFacadeService.getPCAdvByParams(advParams1); //1为滚动广告

		
		//获取栏目广告和链接
		List<CpnAdvDTO> tmpList = cpnAdvFacadeService.getOpmAdvList(advParams2);
		List<CpnAdvDTO> classAdvList = new ArrayList<CpnAdvDTO>();
		if(tmpList!=null && tmpList.size()>0){
			for(CpnAdvDTO advdto : tmpList){
				Map<String, Object> tmpParams = new HashMap<String, Object>();
				tmpParams.put("advSid", advdto.getSid());
				List<AdvParamsDTO> tmpParamsList = cpnAdvFacadeService.getListByParams(tmpParams);
				advdto.setListAdvParams(tmpParamsList);
				classAdvList.add(advdto);
			}
		}
		
		
		//查找出所有一级类别
		List<GdClassDTO> listGCParent = this.cpnwebFacadeService.getSonClassByParID(0);
		List<GdClassDTO> resList = new ArrayList<GdClassDTO>();
		if(listGCParent!=null && listGCParent.size()>0){
			int i = 0;
			int j = 1; //商品类别不超过6组
		
			for(GdClassDTO gcd : listGCParent){
			
//				if(gcd.getGoodClassSid()>6){  //所有小于7的id
//					continue;
//				}
				if(j>6){   //最多显示6组类别
					break;
				}
				
				List<Integer> classIdList = new ArrayList<Integer>();
				classIdList.add(gcd.getGoodClassSid());
				List<GdClassDTO> idList2 = this.cpnwebFacadeService.getSonClassByParID(gcd.getGoodClassSid());
				for(GdClassDTO gcd2 :idList2){
					//将2级类的id加到idList
					classIdList.add(gcd2.getGoodClassSid());
					List<GdClassDTO> idList3 = this.cpnwebFacadeService.getSonClassByParID(gcd2.getGoodClassSid());
					for(GdClassDTO gcd3 : idList3){
						classIdList.add(gcd3.getGoodClassSid());
					}
				}
				
				//找出显示到首页的4张券
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("classLevel",GOODS_CLASS_LEVEL_1);
//				params.put("classId", gcd.getGoodClassSid());
				params.put("list", classIdList);
				params.put("topicStatus", TOPIC_STATUS_5); //已发布的券
			
//				params.put("userType", userType);
			
				Pagination<TopicDTO> pagination = this.cpnwebFacadeService.getListByParam(1, 4, params);
				if(pagination.getContent()!=null && pagination.getContent().size()>0){
					gcd.setListCoupon(pagination.getContent());
				}

				//添加每个侧边广告栏目css class
				String adClassCss = "swiper-container swiper-container-ad ad"+j;
				gcd.setAdClassCss(adClassCss);
				
				String swiperId = "swiperWrapper"+j;
				gcd.setSwiperId(swiperId);
				
				//添加栏目广告图
				if(classAdvList!=null && classAdvList.size()>i){
					gcd.setCpnAdv(classAdvList.get(i));
					i++;
				}
				j++;
				resList.add(gcd);
			}
		}


		model.addAttribute("bannerList",bannerAdvList);
		model.addAttribute("allList",resList);
		
	
		return "pc/cpnIndex";
		
	}
	/**
	 * 登录处理
	 * @param request
	 * @param response
	 * @param model
	 */
	@RequestMapping(value={"/login"},method=RequestMethod.GET)
	public String loginTo(HttpServletRequest request,HttpServletResponse response,ModelMap model) {
		pcLoginService.login(request);
		return "redirect:/view/web/usercenter/ticket";
	}
	/**
	 * 登出处理
	 * @param request
	 * @param response
	 * @param model
	 */
	@RequestMapping(value={"/logout"},method=RequestMethod.GET)
	public String loginOut( HttpServletRequest request,HttpServletResponse response,ModelMap model) {
		HttpSession session =request.getSession(); 
		if(session !=null){
			session.invalidate();
		}
        return "redirect:/";
	}

}
