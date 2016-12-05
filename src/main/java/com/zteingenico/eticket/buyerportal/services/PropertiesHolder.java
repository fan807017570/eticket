package com.zteingenico.eticket.buyerportal.services;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

import com.zteingenico.eticket.business.facade.service.common.IPropertiesFacadeService;

import freemarker.template.SimpleHash;
import freemarker.template.utility.XmlEscape;

@Service
public class PropertiesHolder implements InitializingBean {

	@Resource
	private IPropertiesFacadeService propertiesService;

	@Resource
	private FreeMarkerConfigurer freeMarkerConfigurer;

	private Properties prop;

	public String get(String name) {
		if (prop.getProperty(name) == null) {
			throw new IllegalArgumentException("未找到系统属性：" + name);
		}
		return prop.getProperty(name);
	}

	@Override
	public void afterPropertiesSet() throws Exception {
		prop = propertiesService.getPropertiesByName("properties");
		Map<String, Object> ftlProp = new HashMap<String, Object>();
		ftlProp.put("buyer_portal_domain", get("buyer_portal_domain"));
		ftlProp.put("buyer_weixin_domain", get("buyer_weixin_domain"));
		ftlProp.put("upload_file_domain", get("upload_file_domain"));
		ftlProp.put("upload_weixin_file_domain", get("upload_weixin_file_domain"));
		ftlProp.put("buyer_portal_static_resources_domain", get("buyer_portal_static_resources_domain"));
		ftlProp.put("enterprise_login_url", get("enterprise_login_url"));
		ftlProp.put("bind_forget_pwd_url", get("bind_forget_pwd_url"));
		ftlProp.put("bind_register_url", get("bind_register_url"));
		ftlProp.put("buyer_pc_logout_url", get("buyer_pc_logout_url"));
		ftlProp.put("buyer_portal_outer_url", get("buyer_portal_outer_url"));
		ftlProp.put("eticket_rsa_public_key", get("eticket_rsa_public_key"));
		XmlEscape escaper = new XmlEscape();
		ftlProp.put("xml_escape", escaper);
		freeMarkerConfigurer.getConfiguration().setAllSharedVariables(
				new SimpleHash(ftlProp, freeMarkerConfigurer.getConfiguration()
						.getObjectWrapper()));
		freeMarkerConfigurer.setFreemarkerVariables(ftlProp);
	}
}
