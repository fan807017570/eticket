package com.zteingenico.eticket.buyerportal.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.zteingenico.eticket.business.facade.dto.buyerportal.MemMemberDTO;
import com.zteingenico.eticket.business.facade.dto.verify.RespWeb033DTO;
import com.zteingenico.eticket.business.facade.enums.member.UserType;
import com.zteingenico.eticket.business.facade.service.cpnweb.ICpnwebFacadeService;
import com.zteingenico.eticket.business.facade.service.verify.IVerifyFacadeService;


/**
 * 类  编  号：
 * 类  名  称：VerifyController
 * 类  描  述：平安员工身份验证，粉丝绑定已有橙E券帐号类
 * 完成日期：2015年8月3日 16：40
 * 编码作者：梁俊辉
 */

@Controller("verifyController")
@RequestMapping(value="/view/verify")
public class VerifyController {
	private static Logger log = LoggerFactory.getLogger(VerifyController.class);
	
	
	@Autowired
	private IVerifyFacadeService verifyFacadeService;
	
	@Autowired
	private ICpnwebFacadeService cpnwebFacadeService;

	
	
	/**
     * 	方法说明：用户点击邮箱里的地址，访问我司提供的连接地址， 我司服务器根据链接地址里的参数，反查是那个用户，将其状态更改。
	 * @param request
	 * @param response
	 * @param model
	 * @return 
	 */
	@RequestMapping(value={ "/updateCheck" }, method = RequestMethod.GET)
	public String updateCheckStatus(HttpServletRequest request, HttpServletResponse response,ModelMap model){
		
		    String umId = "";
		    
			String userIdMD5 = request.getParameter("key");
			log.info("userIdMD5="+userIdMD5);
			int userIdInt = 0;
			String useridStr = "";
			if(userIdMD5!=null && !"".equals(userIdMD5)){

				//从缓存中获取userid
				String useridAndUmId = verifyFacadeService.getUserIdByUserToken(userIdMD5);
				log.info("userid&UmId="+useridAndUmId);
				if(null==useridAndUmId || "".equals(useridAndUmId)){
					//已过期
					log.info("地址已过期");
					model.put("result", "抱歉，该地址已过期，请返回微信端重新发送验证邮件...");
					return "mobile/checkResult";
				}
				
				String tmpArr[] =  useridAndUmId.split("#");
				useridStr = tmpArr[0];
				umId = tmpArr[1];
				if(!"".equals(useridStr)){
					userIdInt = Integer.parseInt(useridStr);
				}
			}else {
				log.info("未从request中获取到userIdMD5");
			}
			
			
			//检查该用户是否已经通过验证
			if(userIdInt!=0){
				//检测该UM账户是否被别的帐号绑定
				Map<String,Object> map = new HashMap<String,Object>();
				map.put("memberSid", userIdInt);
				List<MemMemberDTO> listMember = cpnwebFacadeService.getMemberByParams(map);

				if(null!=listMember&&!listMember.isEmpty()){
					for(MemMemberDTO memdto : listMember){
						if(memdto.getUserTypeVO()!=null&&memdto.getUserTypeVO().getCode()==3){
							log.info("该用户已通过验证！id="+memdto.getMemberSid());
							model.put("result", "您已通过平安员工身份验证，请勿重复验证！");
							return "mobile/checkResult";
						}
					}
				}
			}
			
			RespWeb033DTO respWeb033DTO = null;
			if(null!=umId && !"".equals(umId.trim())){
				try{
					respWeb033DTO = verifyFacadeService.checkedEticketUM(umId); 
				}catch(Exception e){
					log.info("从ESB获取用户信息出错！");
					model.put("result", "未成功获取您的UM用户信息，请重新返回微信端验证！");
					return "mobile/checkResult";

				}

			//检查UM帐号是否合法
				if(null==respWeb033DTO || !"00".equals(respWeb033DTO.getReturnCode()) || "".equals(respWeb033DTO.getEmail())){
					log.info("从ESB获取用户的用户无效！");
					model.put("result", "未成功获取您的UM用户信息，请重新返回微信端验证！");
					return "mobile/checkResult";
				}
			}
			
			
			
			MemMemberDTO memberDto = new MemMemberDTO();
			memberDto.setMemberSid(userIdInt);
			memberDto.setUserName(respWeb033DTO.getName());
			memberDto.setEmail(respWeb033DTO.getEmail());
			memberDto.setUserUmAccount(umId);
			memberDto.setUserTypeVO(UserType.codeOfEnum(3));   //用户类型（0-1-2-3） 游客/微信用户/橙e会员/平安员工/

			verifyFacadeService.updateCheckStatus(memberDto); 
			
			
			model.put("result", "恭喜，您的平安员工身份验证成功，请返回微信端....");
			return "mobile/checkResult";
	}
	
}
