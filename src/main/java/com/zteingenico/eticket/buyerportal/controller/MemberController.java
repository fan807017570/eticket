package com.zteingenico.eticket.buyerportal.controller;

import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zteingenico.eticket.business.facade.dto.buyerportal.CouponDTO;
import com.zteingenico.eticket.business.facade.dto.buyerportal.CouponDetailDTO;
import com.zteingenico.eticket.business.facade.dto.logisticsorder.CpnLogisticsOrderDto;
import com.zteingenico.eticket.business.facade.dto.logisticsorder.CpnOwnerAddressDto;
import com.zteingenico.eticket.business.facade.dto.system.SysAreaDto;
import com.zteingenico.eticket.business.facade.enums.coupon.LogisticsOrderStatus;
import com.zteingenico.eticket.business.facade.service.buyerportal.IBuyerPortalCouponFacadeService;
import com.zteingenico.eticket.business.facade.service.logisticsorder.ILogisticsOrderFacadeService;
import com.zteingenico.eticket.business.facade.service.logisticsorder.IOwnerAddressFacadeService;
import com.zteingenico.eticket.business.facade.service.system.ISysAreaFacadeService;
import com.zteingenico.eticket.business.facade.service.weixin.IWexinFacadeService;
import com.zteingenico.eticket.buyerportal.services.SessionService;
import com.zteingenico.eticket.buyerportal.vo.UserSessionDTO;
import com.zteingenico.eticket.common.utils.DateUtil;

@Controller
@RequestMapping("/view/member")
public class MemberController {

	private static final Logger logger = LoggerFactory
			.getLogger(MemberController.class);

	@Resource
	private SessionService sessionService;
	@Resource
	private IBuyerPortalCouponFacadeService couponService;

	@Resource
	private IOwnerAddressFacadeService ownerAddressFacadeService;
	@Resource
	private ILogisticsOrderFacadeService logisticsOrderFacadeService;
	@Resource
	private ISysAreaFacadeService sysAreaService;// 地区服务
	@Value("#{propertiesHolder.get('buyer_portal_page_size')}")
	private int pageSize;

	@Resource
	private IWexinFacadeService wexinFacadeServiceImpl;

	@Value("#{propertiesHolder.get('buyer_weixin_domain')}")
	private String buyer_weixin_domain;

	@RequestMapping(value = "/owned", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getMyConpons(
			@RequestParam(required = false) Integer page, HttpServletRequest req) {
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		List<CouponDTO> coupons = couponService.getMyCoupon(
				userinfo.getUserid(), page);
		Map<String, Object> datas = new HashMap<String, Object>();
		if (coupons.size() < (pageSize + 1)) {
			datas.put("hasmore", false);
		} else {
			coupons.remove(coupons.size() - 1);
			datas.put("hasmore", true);
		}
		datas.put("coupons", coupons);
		return datas;
	}

	@RequestMapping(value = "/expired", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getMyExpiredConpons(
			@RequestParam(required = false) Integer page, HttpServletRequest req) {
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		List<CouponDTO> coupons = couponService.getMyExpiredCoupon(
				userinfo.getUserid(), page);
		Map<String, Object> datas = new HashMap<String, Object>(2);
		if (coupons.size() < (pageSize + 1)) {
			datas.put("hasmore", false);
		} else {
			coupons.remove(coupons.size() - 1);
			datas.put("hasmore", true);
		}
		datas.put("coupons", coupons);
		return datas;
	}

	@RequestMapping(value = "/used", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getMyUsedConpons(
			@RequestParam(required = false) Integer page, HttpServletRequest req) {
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		List<CouponDTO> coupons = couponService.getMyUsedCoupon(
				userinfo.getUserid(), page);
		Map<String, Object> datas = new HashMap<String, Object>(2);
		if (coupons.size() < (pageSize + 1)) {
			datas.put("hasmore", false);
		} else {
			coupons.remove(coupons.size() - 1);
			datas.put("hasmore", true);
		}
		datas.put("coupons", coupons);
		return datas;
	}

	@RequestMapping(value = "/refund", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getMyRefundConpons(
			@RequestParam(required = false) Integer page, HttpServletRequest req) {
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		List<CouponDTO> coupons = couponService.getMyRefundCoupon(
				userinfo.getUserid(), page);
		Map<String, Object> datas = new HashMap<String, Object>(2);
		if (coupons.size() < (pageSize + 1)) {
			datas.put("hasmore", false);
		} else {
			coupons.remove(coupons.size() - 1);
			datas.put("hasmore", true);
		}
		datas.put("coupons", coupons);
		return datas;
	}

	@RequestMapping(value = "/getOwnedAddress", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getOwnedAddress(
			@RequestParam(required = false) Integer page, HttpServletRequest req) {
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(req);
		List<CpnOwnerAddressDto> ownerAddressList = ownerAddressFacadeService
				.getOwnedAddress(userinfo.getUserid(), page, null);

		Map<String, Object> datas = new HashMap<String, Object>(2);
		if (ownerAddressList.size() < (pageSize + 1)) {
			datas.put("hasmore", false);
		} else {
			ownerAddressList.remove(ownerAddressList.size() - 1);
			datas.put("hasmore", true);
		}
		datas.put("ownerAddressList", ownerAddressList);
		return datas;
	}

	/**
	 * 
	 * 实现流程:TODO(根据父级id，查询所有子级地区)<br />
	 * 1.所有地区中匹配parentId 进行筛选<br />
	 * 
	 * @Title: getAreaByParentId
	 * @param parentId
	 * @return List<SysArea> (到页面后是json对象)
	 */
	@RequestMapping(value = { "/proList" }, method = { RequestMethod.GET,
			RequestMethod.POST })
	@ResponseBody
	public Map<String, Object> proList(HttpServletRequest request,
			HttpServletResponse response, String areaId) {
		List<SysAreaDto> pros = sysAreaService.querySysAreaListByLevel(3L);// 所有省
		Map<String, Object> datas = new HashMap<String, Object>(2);
		datas.put("pros", pros);
		return datas;
	}

	/**
	 * 
	 * 实现流程:TODO(根据父级id，查询所有子级地区)<br />
	 * 1.所有地区中匹配parentId 进行筛选<br />
	 * 
	 * @Title: getAreaByParentId
	 * @param parentId
	 * @return List<SysArea> (到页面后是json对象)
	 */
	@RequestMapping(value = { "/ajaxAreas" }, method = { RequestMethod.GET,
			RequestMethod.POST })
	@ResponseBody
	public Map<String, Object> ajaxArea(HttpServletRequest request,
			HttpServletResponse response, String areaId) {
		List<SysAreaDto> sysAreas = sysAreaService
				.querySysAreaListByParentId(Long.valueOf(areaId));
		Map<String, Object> datas = new HashMap<String, Object>(2);
		datas.put("sysAreas", sysAreas);
		return datas;
	}

	/**
	 * 
	 * @Title: confirmOrder
	 * @param logistId
	 *            物流订单id
	 * @return Map<String, Object> (到页面后是json对象)
	 */
	@RequestMapping(value = { "/confirmOrder" }, method = { RequestMethod.GET,
			RequestMethod.POST })
	@ResponseBody
	public Map<String, Object> confirmOrder(HttpServletRequest request,
			HttpServletResponse response, String logistId, String topicId,
			String couponId) {
		String serNo = DateUtil.getTodayRandom(new Date());
		CpnOwnerAddressDto ownerAddressDto = ownerAddressFacadeService
				.genericGet(Long.parseLong(logistId), null);
		CouponDetailDTO couponDetail = couponService.getCouponDetail(topicId,
				couponId);
		CpnLogisticsOrderDto logisticsOrderDto = new CpnLogisticsOrderDto();
		if (ownerAddressDto != null) {
			logisticsOrderDto.setBorough(ownerAddressDto.getBorough());
			logisticsOrderDto.setCity(ownerAddressDto.getCity());
			// logisticsOrderDto.setCouponSn(couponSn);//订单号
			// logisticsOrderDto.setCreatedBy(createdBy);
			logisticsOrderDto.setCreationDate(new Timestamp(new Date()
					.getTime()));
			logisticsOrderDto.setDetailAddress(ownerAddressDto
					.getDetailAddress());
			logisticsOrderDto.setEnabledFlag("Y");
			logisticsOrderDto
					.setLogisticsStatus(LogisticsOrderStatus.READY_SEND
							.getCode());
			logisticsOrderDto.setName(ownerAddressDto.getName());
			logisticsOrderDto.setPro(ownerAddressDto.getPro());
			logisticsOrderDto.setSerNo(serNo);
			logisticsOrderDto.setTel(ownerAddressDto.getTel());
		}
		logisticsOrderDto.setOrderLineId(Integer.parseInt(couponId));
		logisticsOrderDto.setOrgId(couponDetail.getOrgId());
		logisticsOrderDto.setOrgName(couponDetail.getOrgName());
		logisticsOrderDto.setTopicId(Integer.parseInt(topicId));
		logisticsOrderDto.setTopicName(couponDetail.getCouponName());
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(request);
		int addback = logisticsOrderFacadeService.saveLogistOrder(
				logisticsOrderDto, Long.parseLong(couponId),
				userinfo.getUserid());

		Map<String, Object> datas = new HashMap<String, Object>(2);
		//addback   1  下单成功  0  下单失败    -1  请勿重复下单
		datas.put("status", addback);
		return datas;
	}

	/**
	 * 
	 * @Title: 删除物流地址
	 * @param logistId
	 *            物流订单id
	 * @return Map<String, Object> (到页面后是json对象)
	 */
	@RequestMapping(value = { "/deleteAddress" }, method = { RequestMethod.GET,
			RequestMethod.POST })
	@ResponseBody
	public Map<String, Object> deleteAddress(HttpServletRequest request,
			HttpServletResponse response, String ownerAddressId) {
		Map<String, Object> datas = new HashMap<String, Object>(2);
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(request);
		if (!StringUtils.isEmpty(ownerAddressId)) {
			Long[] ids = { Long.parseLong(ownerAddressId) };
			CpnOwnerAddressDto ownerAddressDto = ownerAddressFacadeService
					.genericGet(Long.parseLong(ownerAddressId), null);
			List<CpnOwnerAddressDto> list = null;
			if (ownerAddressDto != null
					&& "1".equals(ownerAddressDto.getAddStatus())) {
				ownerAddressFacadeService.deleteInGeneric(ids, null);
				list = ownerAddressFacadeService.getOwnedAddress(
						userinfo.getUserid(), 1, null);
				if (list != null && list.size() > 0) {
					ownerAddressFacadeService.setDefaultAddress((long) list
							.get(0).getOwnerAddressId(), 1);
				}
				datas.put("status", "success");
			} else {
				ownerAddressFacadeService.deleteInGeneric(ids, null);
				datas.put("status", "success");
			}
		}
		return datas;
	}

	/**
	 * 
	 * @Title: 设置默认物流地址
	 * @param ownerAddressId
	 *            物流订单id
	 * @return Map<String, Object> (到页面后是json对象)
	 */
	@RequestMapping(value = { "/setDefaultAddress" }, method = {
			RequestMethod.GET, RequestMethod.POST })
	@ResponseBody
	public Map<String, Object> setDefaultAddress(HttpServletRequest request,
			HttpServletResponse response, String ownerAddressId,
			String defaultAddressId) {
		Map<String, Object> datas = new HashMap<String, Object>(2);
		if (!StringUtils.isEmpty(ownerAddressId)
				&& !StringUtils.isEmpty(defaultAddressId)) {
			// 先修改默认地址为非默认
			ownerAddressFacadeService.setDefaultAddress(
					Long.parseLong(defaultAddressId), 0);
			// 设置当前为默认地址
			int updateStatus = ownerAddressFacadeService.setDefaultAddress(
					Long.parseLong(ownerAddressId), 1);
			if (updateStatus == 1) {
				datas.put("status", "1");
			} else {
				datas.put("status", "0");
			}
		}
		return datas;
	}

	/**
	 * 
	 * @Title: addAddress
	 * @param logistId
	 *            物流订单id
	 * @return Map<String, Object> (到页面后是json对象)
	 */
	@RequestMapping(value = { "/saveAddress" }, method = { RequestMethod.GET,
			RequestMethod.POST })
	@ResponseBody
	public Map<String, Object> saveAddress(HttpServletRequest request,
			HttpServletResponse response, String username, String tel,
			String pro, String city, String area, String detailAddress) {
		UserSessionDTO userinfo = sessionService.getUserInfoInSession(request);
		List<CpnOwnerAddressDto> list = ownerAddressFacadeService
				.getOwnedAddress(userinfo.getUserid(), 1, "1");
		CpnOwnerAddressDto ownerAddressDto = new CpnOwnerAddressDto();
		if (list != null && list.size() > 0) {
			ownerAddressDto.setAddStatus("0");// 先查询是否有默认地址
		} else {
			ownerAddressDto.setAddStatus("1");// 先查询是否有默认地址
		}
		ownerAddressDto.setBorough(area);
		ownerAddressDto.setCity(city);
		ownerAddressDto.setCreationDate(new Timestamp(new Date().getTime()));
		ownerAddressDto.setDetailAddress(detailAddress);
		ownerAddressDto.setEnabledFlag("Y");
		ownerAddressDto.setMemId((int) userinfo.getUserid());
		ownerAddressDto.setName(username);
		ownerAddressDto.setPro(pro);
		ownerAddressDto.setTel(tel);
		ownerAddressFacadeService.addInGeneric(ownerAddressDto, null);
		Map<String, Object> datas = new HashMap<String, Object>(2);
		datas.put("status", "success");
		return datas;
	}

	/**
	 * 确定收货
	 * 
	 * @param couponid
	 *            物流订单id
	 * @return json对象
	 */
	@RequestMapping("/confirmOrderRecive")
	@ResponseBody
	public Map<String, Object> confirmOrderRecive(String couponid) {

		int updateResult = 0;
		if (!StringUtils.isEmpty(couponid)) {
			updateResult = ownerAddressFacadeService.confirmRecive(Long
					.parseLong(couponid));
		} else {
			logger.info("不存在订单号", couponid);
		}
		Map<String, Object> datas = new HashMap<String, Object>(2);
		datas.put("status", updateResult);
		return datas;
	}
}
