package com.zteingenico.eticket.buyerportal.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zteingenico.eticket.business.facade.dto.adv.AdvParamsDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.CheckTopicResultDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.GdClassDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.OrgBranchInfoDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.TopicDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.TopicDetailDTO;
import com.zteingenico.eticket.business.facade.dto.topic.DefinePicRefDto;
import com.zteingenico.eticket.business.facade.dto.topic.PicDto;
import com.zteingenico.eticket.business.facade.enums.member.UserType;
import com.zteingenico.eticket.business.facade.service.adv.ICpnAdvFacadeService;
import com.zteingenico.eticket.business.facade.service.buyerportal.IBuyerPortalTopicFacadeService;
import com.zteingenico.eticket.business.facade.service.coupon.ICouponClassFacadeService;
import com.zteingenico.eticket.business.facade.service.cpnweb.ICpnwebFacadeService;
import com.zteingenico.eticket.business.facade.service.system.ISysAreaFacadeService;
import com.zteingenico.eticket.business.facade.service.system.ISysDataCodeFacadeService;
import com.zteingenico.eticket.business.facade.service.system.ISysLeaguePersonFacadeService;
import com.zteingenico.eticket.buyerportal.services.PCLoginService;
//import com.zteingenico.eticket.buyerportal.services.SessionService;
import com.zteingenico.eticket.buyerportal.vo.UserSessionDTO;
import com.zteingenico.eticket.common.Pagination;
import com.zteingenico.eticket.common.utils.CookieUtil;
import com.zteingenico.eticket.common.utils.PageUtil;

/**
 * 类  编  号：
 * 类  名  称：CpnwebController
 * 类  描  述：橙E券首页
 * 完成日期：2015年8月7日
 * 编码作者：梁俊辉
 */

@Controller("cpnwebController")
@RequestMapping(value="/view/cpnweb")
public class CpnwebController {
	
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

	
	private static int LIST_EVERY_PAGE_NUM = 12; //每页显示数量 (栏目和类别页面)

	private static int GOODS_CLASS_LEVEL_1 = 1;  //商品一级类别  父类为0
	private static int GOODS_CLASS_LEVEL_2 = 2;  //商品二级类别  父类为一级
	private static int GOODS_CLASS_LEVEL_3 = 3;  //商品三级类别  父类为二级
	
	private static int TOPIC_STATUS_5 = 5;  //已发布的券
	
	private static final String VISITOR_TAKEN_NUMBERS_PREFIX = "visitor_taken_numbers_";

	
	/**
	 * 方法说明：跳转到券详情页
	 * @param 
	 * @return
	 */

	@RequestMapping(value={ "/cpnDetail" }, method = RequestMethod.GET)
	public String cpnDetail(HttpServletRequest request, HttpServletResponse response,ModelMap model){
		
		String topicId = request.getParameter("topicId");
		TopicDetailDTO topicDTO = cpnwebFacadeService.getTopicDetail(topicId);
		
		GdClassDTO class1 = new GdClassDTO();
		GdClassDTO class2 = new GdClassDTO();
		GdClassDTO class3 = new GdClassDTO();
	
		//该券所有父类
		List<GdClassDTO> tmpList = cpnwebFacadeService.getGoodParents(topicDTO.getTopicGoodsClassId());

		if(tmpList!=null && tmpList.size()>0){
			
			class1 = tmpList.get(0);
			class1.setLevel(GOODS_CLASS_LEVEL_1);
			model.addAttribute("class1",class1);
			
			if(tmpList.size()>1){
				class2 = tmpList.get(1);
				class2.setLevel(GOODS_CLASS_LEVEL_2);
				model.addAttribute("class2",class2);
			}
			
			if(tmpList.size()>2){
				class3 = tmpList.get(2);
				class3.setLevel(GOODS_CLASS_LEVEL_3);
				model.addAttribute("class3",class3);
			}
			
		}
		
			//显示图片
			//1.web列表图   2.web详情图    3.weChat列表图    4.weChat详情图
				

		String defineId = topicDTO.getTopicDefineId();

		Map<String,Object> webDetailinParams = new LinkedHashMap<String, Object>();
		webDetailinParams.put("picType", 2);
		webDetailinParams.put("defineId", defineId);
		List<DefinePicRefDto> allDetalPicList = cpnwebFacadeService.getPicRef(webDetailinParams);
		List<PicDto> smallPicPathList = new ArrayList<PicDto>();
		List<PicDto> bigPicPathList = new ArrayList<PicDto>();
		
		//大图和小图分开
		for(DefinePicRefDto picDto:allDetalPicList){
			PicDto pic = cpnwebFacadeService.getPicById(picDto.getPicId());
			if(picDto.getDescrition()<6){
				smallPicPathList.add(pic);
			}else {
				bigPicPathList.add(pic);
			}
			
		}
		
		String firstPicPath = "";
		if(smallPicPathList!=null && smallPicPathList.size()>0){
			firstPicPath=smallPicPathList.get(0).getPath();
		}
		
		
		
		//获取商家分店信息list
		List<OrgBranchInfoDTO> branchList = cpnwebFacadeService.getOrgBranchListByOrgId(topicDTO.getOrgId());
		
		model.addAttribute("firstPic",firstPicPath);
		model.addAttribute("smallPicPathList", smallPicPathList);  //小图图片list
		model.addAttribute("bigPicPathList", bigPicPathList);  //大图片list
		model.addAttribute("topic",topicDTO);
		model.addAttribute("branchList",branchList);
		
		return "pc/cpnDetail";
		
	}
	
	

	
	/**
	 * 方法说明：根据商品类别查询券列表
	 * @param 
	 * @return
	 */

	@RequestMapping(value={ "/cpnListByClass" })
	public String getCpnListByClass( Integer classLevel, Integer classId,  Integer currentPage , 
			HttpServletRequest request, HttpServletResponse response,ModelMap model){
		
//		int userType = getUserType(request);
//		UserSessionDTO serviceUser = sessionService.getUserInfoInSession(request);
//		model.put("username",serviceUser.getUsername());
		
		Map<String, Object> advParams1 = new HashMap<String, Object>();
		advParams1.put("advPosition", 1);
		//获取滚动广告图片和链接
		List<AdvParamsDTO> bannerAdvList = cpnAdvFacadeService.getPCAdvByParams(advParams1); //1为滚动广告


		String classIdStr = request.getParameter("classIds");
		String classLevelStr = request.getParameter("classLevels");   //从页面端传类级别到controller层
		
		if(classIdStr!=null&&!"".equals(classIdStr.trim())){
			classId = Integer.valueOf(classIdStr);
		}
		if(classLevelStr!=null && !"".equals(classLevelStr)){
			classLevel = Integer.valueOf(classLevelStr);
		}
		

		if(currentPage==null || currentPage < 1){
			currentPage = 1;
		}

		List<Integer> classIdList = new ArrayList<Integer>(); //3级类id存放list
		if(classLevel==GOODS_CLASS_LEVEL_3){
			classIdList.add(classId);
		}else if(classLevel==GOODS_CLASS_LEVEL_2){
			//将2级类的id也加到idList
			classIdList.add(classId);
			List<GdClassDTO> gcdList3 = this.cpnwebFacadeService.getSonClassByParID(classId);
			for(GdClassDTO gcd :gcdList3){
				classIdList.add(gcd.getGoodClassSid());
			}
		}else if(classLevel==GOODS_CLASS_LEVEL_1){  
			//将1级类的id也加到idList
			classIdList.add(classId);
			List<GdClassDTO> idList2 = this.cpnwebFacadeService.getSonClassByParID(classId);
			for(GdClassDTO gcd2 :idList2){
				//将2级类的id加到idList
				classIdList.add(gcd2.getGoodClassSid());
				List<GdClassDTO> idList3 = this.cpnwebFacadeService.getSonClassByParID(gcd2.getGoodClassSid());
				for(GdClassDTO gcd3 : idList3){
					classIdList.add(gcd3.getGoodClassSid());
				}
			}
		}

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("classLevel",classLevel);
		params.put("topicStatus", TOPIC_STATUS_5); //已发布的券
		params.put("list", classIdList);
//		params.put("userType", userType);
		Pagination<TopicDTO> pagination = this.cpnwebFacadeService.getListByParam(currentPage, LIST_EVERY_PAGE_NUM, params);
		model.put("pagination", pagination);
		model.put("currentPage", currentPage);
		model.put("totalPages",pagination.getTotalPages());
//		model.put("pageHtml", CommUtil.showPageFormHtml(currentPage, pagination.getTotalPages()));
		model.put("pageHtml", PageUtil.showPageHtmlForPC(currentPage, pagination.getTotalPages()));
		model.put("classId", classId);
		model.put("classLevel", classLevel);
		model.addAttribute("bannerList",bannerAdvList);
		return "pc/cpnListClass";

	}
	
	
	
	/**
	 * 方法说明：根据栏目类别查询券列表
	 * @param req
	 * @param model
	 * @return
	 */
	@RequestMapping(value={ "/cpnListByColumn" })
	public String getCpnListByColumn(Integer currentPage, Integer columnId,
			HttpServletRequest request,ModelMap model){
		
//		int userType = getUserType(request);
//		UserSessionDTO serviceUser = sessionService.getUserInfoInSession(request);
//		model.put("username",serviceUser.getUsername());

		Map<String, Object> advParams1 = new HashMap<String, Object>();
		advParams1.put("advPosition", 1);
		//获取滚动广告图片和链接
		List<AdvParamsDTO> bannerAdvList = cpnAdvFacadeService.getPCAdvByParams(advParams1); //1为滚动广告

		String columnIdStr = request.getParameter("columnIds");


		if(currentPage==null || currentPage < 1){
			currentPage = 1;
		}
		
		if(currentPage < 1){
			currentPage = 1;
		}
		
		if(columnIdStr!=null&&!"".equals(columnIdStr.trim())){
			columnId = Integer.valueOf(columnIdStr);
		}		


		Map<String, Object> params = new HashMap<String, Object>();
	
		params.put("columnId",columnId);
		params.put("topicStatus", TOPIC_STATUS_5); //已发布的券
//		params.put("userType", userType);
		Pagination<TopicDTO> pagination = this.cpnwebFacadeService.getListByParam(currentPage, LIST_EVERY_PAGE_NUM, params);
		model.put("pagination", pagination);
		model.put("currentPage", currentPage);
		model.put("totalPages",pagination.getTotalPages());
//		model.put("pageHtml", CommUtil.showPageFormHtml(currentPage, pagination.getTotalPages()));
		model.put("pageHtml", PageUtil.showPageHtmlForPC(currentPage, pagination.getTotalPages()));
		model.put("columnId", columnId);
		model.addAttribute("bannerList",bannerAdvList);
		return "pc/cpnListColumn";

	}
	
	

	
	
	
	
	
	
	/**
	 * 方法说明：PC端检测券的状态
	 * @param topicid
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/topicStatus", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> topicStatus(@RequestParam String topicid,
			HttpServletRequest req) {
		
		UserSessionDTO userinfo = pcLoginService.getUserInfoInSession(req);

		if(userinfo ==null || userinfo.getUserType()==null){
			userinfo = new UserSessionDTO();
			userinfo.setUsername("测试用户");
			userinfo.setUserType(UserType.GUEST);
			userinfo.setUserid(4);
		}
	
//		int userTakernCount = topicService.getUserTakenNum(topicid, userinfo.getUserid());
		int userTakernCount = getUserTakenCouponNums(userinfo,req,topicid);
		CheckTopicResultDTO result = topicService.checkCondition(userinfo.getUserType(),topicid,userTakernCount);
		
		
//		result =  CheckTopicResult.AVAILABLE;//test
		int takenTotals = 0;
		Map<String, Object> datas = new HashMap<String, Object>(2);
		if (result.isAvailable()) {
			takenTotals = topicService.getTopicTakenNums(topicid);
			datas.put("takenTotals", takenTotals);
		}
		datas.put("result", Boolean.toString(result.isAvailable()));
		datas.put("errorMsg", result.getTipsMessage());
		return datas;

	}


	

	
	/**
	 * 方法说明:动态获取商品类别,加载到导航栏
	 * @param request
	 * @param response
	 * @param model
	 */
	@RequestMapping(value={"/goodsclass"},method=RequestMethod.GET)
	public void getGoodsClass(HttpServletRequest request,HttpServletResponse response,Model model) {
		
//		String jsonString = "{\"goodsclass\":[{\"classId\":\"21\",\"className\":\"水果类\",\"children\":[{ \"classId\":\"21\" , \"className\":\"进口水果\" },{ \"classId\":\"1\" , \"className\":\"热带水果\" }]},{\"classId\":\"2\",\"className\":\"蔬菜类\",\"children\":[{ \"classId\":\"2\" , \"className\":\"青菜\" },{ \"classId\":\"3\" , \"className\":\"夏季菜\" }]}]}";
//		String rootPath = request.getSession().getServletContext().getRealPath("/");
//		String jsonString = ReadFile.readFile(rootPath+"data.json");
		
		String jsonString = couponClassFacadeService.getJsonStringOfGoods();
		
		response.setCharacterEncoding("UTF-8");
		PrintWriter pw=null;
		try {
			pw = (PrintWriter)response.getWriter();
		} catch (IOException e) {
			
			
			e.printStackTrace();
		}
		pw.write(jsonString);
		
	}
	

	/**
	 * 方法说明:动态获取栏目类别,加载到导航栏 
	 * @param request
	 * @param response
	 * @param model
	 */
	@RequestMapping(value={"/columns"},method=RequestMethod.GET)
	public void getTopicColumns(HttpServletRequest request,HttpServletResponse response,Model model) {

		//后期使用静态文件的方式获取
		//String jsonString = "{\"topicColumns\": [{ \"id\":\"1\" , \"columnName\":\"银行周末团\" },{ \"id\":\"2\" , \"columnName\":\"当前最热\" },{ \"id\":\"3\" , \"columnName\":\"周周特价\" },{ \"id\":\"4\" , \"columnName\":\"月月惊喜\" }]}";
//		String rootPath = request.getSession().getServletContext().getRealPath("/");
//		String jsonString = ReadFile.readFile(rootPath+"data.json");
		String jsonString = couponClassFacadeService.getJsonStringOfColumn();
		
//		System.out.println(path);
		response.setCharacterEncoding("UTF-8");
		PrintWriter pw=null;
		try {
			pw = (PrintWriter)response.getWriter();
		} catch (IOException e) {
			
			
			e.printStackTrace();
		}
		pw.write(jsonString);
		

	}


	
	
	
	/**
	 * 跳转到登录页面
	 * @param request
	 * @param response
	 * @param model
	 */
	@RequestMapping(value={"/cpnLogin"},method=RequestMethod.GET)
	public String cpnLogin(HttpServletRequest request,HttpServletResponse response,Model model) {
		return "pc/cpnLogin";
	}
	

	
//	/**
//	 * 获取userType
//	 * @param request
//	 * @return
//	 */
//	public int getUserType(HttpServletRequest request){
//		 	int userType = 0;
//			UserSessionDTO serviceUser = null;
//			HttpSession session = request.getSession();
//				
//			if(session!=null){
//				Object obj = session.getAttribute(SESSION_KEY);
//				if(obj!=null){
//					serviceUser = (UserSessionDTO)obj;
//					if(serviceUser!=null){
//						UserType type = serviceUser.getUserType();
//						userType = type.getCode();
//					}
//				}
//			}
//		
//		return userType;
//	}
	
	
	
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
	
	
	
	/**
	 * 登录处理
	 * @param request
	 * @param response
	 * @param model
	 */
	@RequestMapping(value={"/getUserInfo"},method=RequestMethod.GET)
	public void getUserInfo(HttpServletRequest request,HttpServletResponse response,ModelMap model) {
		
		UserSessionDTO user = pcLoginService.getUserInfoInSession(request);
		String username = "";
		if(user!=null){
			username = user.getUsername() == null || "".equals(user.getUsername()) ? "hello":user.getUsername();
		}
		
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = null;
		
		try{
			pw =  (PrintWriter)response.getWriter();
		}catch(Exception e){
			e.printStackTrace();
		}
		pw.write(username);
		
	}
}
