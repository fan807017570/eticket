package com.zteingenico.eticket.buyerportal.mock;

/*
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

import com.zteingenico.orange.beans.TopicDetailDTO;
import com.zteingenico.orange.dao.CouponTopicDao;
import com.zteingenico.orange.entity.CouponTopic;
import com.zteingenico.orange.services.interfaces.DtoConvertService;
import com.zteingenico.orange.services.interfaces.RedisDataService;

import freemarker.cache.FileTemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring/applicationContext.xml", "classpath:spring/mock.xml"})
public class StaticHtmlCreatorTest {

	@Resource 
	private CouponTopicDao topicDao;
	
	@Resource
	private DtoConvertService dtoService;
	
	@Resource
	private RedisDataService redisService;
	
	@Resource
	private FreeMarkerConfigurer configurer;
	
	@Test
	public void testCreat() throws IOException, TemplateException {
		
		FileTemplateLoader ftl = new FileTemplateLoader(new File("D://pacyq//workspace//weixinportal//src//main//webapp//WEB-INF//template//mock"));
//		ApplicationContext ac = new ClassPathXmlApplicationContext("spring/mock.xml", "spring/applicationContext.xml");
//		FreeMarkerConfigurer  configurer = (FreeMarkerConfigurer)ac.getBean("freemarkerConfig");
		Configuration  configuration  = configurer.getConfiguration();
		configuration.setTemplateLoader(ftl);
		Template template = configuration.getTemplate("topicDetail.ftl");
		String fileNamePrefix = "D://pacyq//workspace//weixinportal//src//main//webapp//resources//mock//";
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("curDate", new Date());
		List<CouponTopic> topicList = topicDao.getListByParams(params, 0, 11);
		
		for(CouponTopic entity : topicList) {
			
			File file = new File(fileNamePrefix + entity.getTopicId() + ".html");
			Writer out = new OutputStreamWriter(new FileOutputStream(file), "UTF-8");
			Map<String,Object> rootMap = new HashMap<String, Object>();
			TopicDetailDTO dto = dtoService.couponTopic2TopicDetailDTO(entity);
			rootMap.put("topic", dto);
			template.process(rootMap, out);
			out.close();
			redisService.updateTopicDetailDTO(dto);
		}
		
		System.out.println("create finished...");
	}
}*/
