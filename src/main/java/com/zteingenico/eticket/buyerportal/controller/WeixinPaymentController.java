package com.zteingenico.eticket.buyerportal.controller;

import java.io.BufferedReader;
import java.io.CharArrayWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.zteingenico.eticket.business.facade.dto.payment.PayResultDTO;
import com.zteingenico.eticket.business.facade.service.buyerportal.IBuyerPortalOrderFacadeService;
import com.zteingenico.eticket.business.facade.service.common.IPropertiesFacadeService;
import com.zteingenico.eticket.common.payment.thirdpart.wechat.protocol.notify.NotifyReqData;
import com.zteingenico.eticket.common.payment.thirdpart.wechat.protocol.notify.NotifyResData;
import com.zteingenico.eticket.common.payment.thirdpart.wechat.util.Signature;
import com.zteingenico.eticket.common.payment.thirdpart.wechat.util.XStreamUtil;

/**
 * @author wan.yu
 *  处理第三方支付支付成功后的回调消息
 */
@Controller
@RequestMapping("/view/payment")
public class WeixinPaymentController {
	
	private static Logger log = LoggerFactory.getLogger(WeixinPaymentController.class);
	
	@Resource
	private IBuyerPortalOrderFacadeService orderService;
	
	@Resource
	private IPropertiesFacadeService propertiesService;
	
	@RequestMapping(value="/notify", method = RequestMethod.POST)
	public void paymentNotify(
			HttpServletRequest req,
			HttpServletResponse res){
		log.info("接收到微信的支付结果异步通知！");
		try {
			boolean result = false;
			NotifyResData resData = new NotifyResData();
			XStreamUtil xStreamUtil = XStreamUtil.getInstance();
			String body = readBodyFromReqeust(req);
			body = body.replaceAll("<xml>", "<NotifyReqData>")
					.replaceAll("</xml>", "</NotifyReqData>");
			log.info("payment/notify 支付通知body: " + body);
			
			if (StringUtils.isNotEmpty(body)) {
				
				NotifyReqData notify = (NotifyReqData) xStreamUtil
						.fromXML(body);
				if (notify != null) {
					Properties prop = propertiesService
							.getPropertiesByName("wechatPay");
					/** 微信的商户密钥 */
					String key = prop.getProperty("wechat_key");
					// 签名校验
					if (Signature.checkIsSignValidFromResponseString(body, key)) {
						// 调用服务进行处理
						PayResultDTO dto = new PayResultDTO();
						dto.setAmount(notify.getTotal_fee());
						dto.setAttach(notify.getAttach());
						dto.setBankType(notify.getBank_type());
						dto.setIsSubscribe(notify.getIs_subscribe());
						dto.setOpenId(notify.getOpenid());
						/** 此处双方互为第三方 */
						dto.setOrderCode(notify.getOut_trade_no());
						/** 此处双方互为第三方 */
						dto.setOutTradeNo(notify.getTransaction_id());
						dto.setPayTime(notify.getTime_end());
						dto.setTradeType(notify.getTrade_type());
						if ("SUCCESS".equals(notify.getResult_code())) {
							dto.setSuccess(true);
						} else {
							dto.setSuccess(false);
						}
						result = orderService.handleWechatNotify(dto);
						// 处理返回内容
						if (result) {
							log.info("处理支付通知成功！");
							resData.setReturn_code("SUCCESS");
							resData.setReturn_msg("OK");
						} else {
							log.error("处理支付通知失败！");
							resData.setReturn_code("FAIL");
							resData.setReturn_msg("FAIL");
						}
						// 签名错误
					} else {
						log.info("payment/notify sign error");
						resData.setReturn_code("FAIL");
						resData.setReturn_msg("sign error");
					}

					// 输出返回内容
					String returnStr = xStreamUtil.toXML(resData);
					returnStr = returnStr
							.replaceAll("<NotifyResData>", "<xml>").replaceAll(
									"</NotifyResData>", "</xml>");
					log.info("payment/notify response: " + returnStr);
					
					res.setContentType("text/xml");
					res.setCharacterEncoding("utf-8");
					res.getWriter().print(returnStr);
					res.getWriter().flush();
				}
			}
		} catch (Exception e) {
			log.error("wechat notify process exception", e);
		}
	}

	/** 从请求中读取请求体内容 
	 * @throws IOException */
	private String readBodyFromReqeust(HttpServletRequest req) throws IOException {
		
		Charset charset = Charset.forName("utf-8");
		BufferedReader in = new BufferedReader(
				 new InputStreamReader(req.getInputStream(), charset));
  
         CharArrayWriter data = new CharArrayWriter();
         char[] buf = new char[8192];
         int ret; 
         while ((ret = in.read(buf, 0, 8192)) != -1) { 
             data.write(buf, 0, ret); 
         } 
         return data.toString(); 
	}
}
