package com.zteingenico.eticket.buyerportal.controller;


import java.sql.Timestamp;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.zteingenico.eticket.business.facade.dto.system.SysOrgSinceDto;
import com.zteingenico.eticket.business.facade.service.system.ISysOrgSinceFacadeService;
import com.zteingenico.eticket.buyerportal.vo.ValidformVo;

/**
 * 
 * 类  编  号：
 * 类  名  称：CheckPorsonManageController
 * 类  描  述：人员管理
 * 完成日期：2015年9月28日 下15:20:56
 * 编码作者：张文浩
 */
@Controller("sinceManage")
@RequestMapping(value = "/view/sinceManage")
public class SinceManageControlle{
	@Autowired
	private ISysOrgSinceFacadeService sysOrgSinceFacadeService;
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value={ "/save" },method = {RequestMethod.GET,RequestMethod.POST})
	public String save(HttpServletRequest request,HttpServletResponse response,ModelMap model,SysOrgSinceDto sysOrgSinceDto) {
		if(sysOrgSinceDto.getSysOrgSinceId()==null){
			sysOrgSinceDto.setCreationDate(new Timestamp(System.currentTimeMillis()));
			sysOrgSinceDto.setLastUpdateDate(new Timestamp(System.currentTimeMillis()));
			sysOrgSinceDto.setEnabledFlag("Y");
//			sysOrgSinceFacadeService.addInGeneric(sysOrgSinceDto, new HashMap());
			model.put("orgInfoId",sysOrgSinceDto.getSysOrgId());
			return "pc/pcUnionInfoEdit2";
		}else{
			SysOrgSinceDto oldsinceDto = sysOrgSinceFacadeService.genericGet(Long.valueOf(sysOrgSinceDto.getSysOrgSinceId()), new HashMap());
			oldsinceDto.setSysOrgSinceName(sysOrgSinceDto.getSysOrgSinceName());
			oldsinceDto.setSysOrgSinceContactPhone(sysOrgSinceDto.getSysOrgSinceContactPhone());
			oldsinceDto.setSysOrgSinceContact(sysOrgSinceDto.getSysOrgSinceContact());
			oldsinceDto.setSysOrgSinceBusinessHours(sysOrgSinceDto.getSysOrgSinceBusinessHours());
			oldsinceDto.setSysOrgSinceAddr(sysOrgSinceDto.getSysOrgSinceAddr());
			oldsinceDto.setLastUpdateDate(new Timestamp(System.currentTimeMillis()));
			sysOrgSinceFacadeService.updateInGeneric(oldsinceDto, new HashMap());
			model.put("orgInfoId",sysOrgSinceDto.getSysOrgId());
			return "pc/pcUnionInfoEdit2";
		}
	}
	 
	/**
	 * 
	 * 实现流程:TODO(ajax验证用户名的唯一性)<br />
	 * 1.XXX<br />
	 * @Title: ajaxCheckLoginName 
	 * @param request
	 * @param response
	 * @param param
	 * @param name
	 * @return
	 */
	@RequestMapping(value={ "/ajaxCheNameOrAddr" },method = { RequestMethod.POST , RequestMethod.GET})
	public ValidformVo ajaxCheNameOrAddr(HttpServletRequest request,HttpServletResponse response,String sysOrgId,String param,String name){
		SysOrgSinceDto sysOrgSinceDto = new SysOrgSinceDto();
		sysOrgSinceDto.setSysOrgId(Integer.parseInt(sysOrgId));
		if("sysOrgSinceName".equals(name)){
			sysOrgSinceDto.setSysOrgSinceName(param);
		}else{
			sysOrgSinceDto.setSysOrgSinceAddr(param);
		}
		ValidformVo validformVo = new ValidformVo();
		int n = sysOrgSinceFacadeService.ajaxCheNameOrAddr(sysOrgSinceDto);
		if(n != 0){
			validformVo.setStatus("n");
			validformVo.setInfo("此联盟方自提信息已有使用");
		}else{
			validformVo.setStatus("y");
		}
		return validformVo;
	}
}
