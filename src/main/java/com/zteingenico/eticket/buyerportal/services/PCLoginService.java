package com.zteingenico.eticket.buyerportal.services;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.sso.client.util.SSOClient;
import com.zteingenico.eticket.business.facade.dto.buyerportal.MemMemberDTO;
import com.zteingenico.eticket.business.facade.enums.member.UserStatus;
import com.zteingenico.eticket.business.facade.enums.member.UserType;
import com.zteingenico.eticket.business.facade.service.cpnweb.ICpnwebFacadeService;
import com.zteingenico.eticket.buyerportal.vo.UserSessionDTO;

@Service
public class PCLoginService {
	
	@Autowired
	private ICpnwebFacadeService cpnwebFacadeService;

	/**
	 * 获取用户信息
	 * @param req
	 * @return
	 */
	public UserSessionDTO getUserInfoInSession(HttpServletRequest request) {
		
		UserSessionDTO user = null;
		HttpSession session = request.getSession();
		
		Object obj = session.getAttribute(SessionService.USER_INFO_SESSION_KEY);
		if(obj!=null){
			user = (UserSessionDTO)obj;
		}
		
		return user;
	}

	
	
	/**
	 * 登录操作
	 * @param user
	 * @param req
	 */
	public void login(HttpServletRequest request) {
		
		HttpSession session = request.getSession(); 
		
		
		String userCode = SSOClient.getSSOUserId(request);//橙E网id
		String chewUserId = SSOClient.getSSOUserNo(request);//橙E网id
		String email = SSOClient.getSSOUserEmail(request);
		String userMobile = SSOClient.getSSOUserMobile(request);
		String userName = SSOClient.getSSOUserName(request);//中文名
		UserSessionDTO user = null;
	
		if(chewUserId!=null && !"".equals(chewUserId.trim())){ //登录成功
			//进行插入表操作
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("chewUserId", chewUserId);
			
//			MemMemberDTO memberDTO = cpnwebFacadeService.getMemberByParams(map);
			
			List<MemMemberDTO> listMember = cpnwebFacadeService.getMemberByParams(map);
			
			if(null==listMember || listMember.isEmpty()){
				//未登录过的用户  插入表会员表
				MemMemberDTO tmpMemberDTO = new MemMemberDTO();
				tmpMemberDTO.setUserCode(userCode);
				tmpMemberDTO.setChewUserId(chewUserId);
				tmpMemberDTO.setUserMobile(userMobile);
				tmpMemberDTO.setUserName(userName);
				tmpMemberDTO.setEmail(email);
				tmpMemberDTO.setUserTypeVO(UserType.CHEWUSER);
				tmpMemberDTO.setUserStatusVO(UserStatus.NORMAL);
				tmpMemberDTO.setEnabledFlag("Y");
				
				cpnwebFacadeService.addMember(tmpMemberDTO);  
				
				listMember = cpnwebFacadeService.getMemberByParams(map);
				
				if(listMember!=null && !listMember.isEmpty()){
					MemMemberDTO memberDTO = listMember.get(0);
					user = new UserSessionDTO();
					user.setUserid(memberDTO.getMemberSid());
					user.setUsername(memberDTO.getUserCode());
					user.setUserType(UserType.codeOfEnum(2));
				}
				

			}else {//曾经登陆过 或已绑定的用户
				user = new UserSessionDTO();
				MemMemberDTO memberDTO = listMember.get(0);
				user.setUserid(memberDTO.getMemberSid());
				user.setUsername(memberDTO.getUserCode());
				user.setUserType(memberDTO.getUserTypeVO());
				
				//更新最新信息
				//TODO
			}
			//设置session
			if(user!=null){
				session.setAttribute(SessionService.USER_INFO_SESSION_KEY, user);
			}
			
		}
	}
	
	
	
	
}
