package com.zteingenico.eticket.buyerportal.exception;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;

/**
 * @author wan.yu
 * 用于处理整个门户的全局异常
 */
public class ExceptionHandler implements HandlerExceptionResolver{
	
	private Logger logger = LoggerFactory.getLogger(ExceptionHandler.class);

	@Override
	public ModelAndView resolveException(HttpServletRequest req,
			HttpServletResponse res, Object handler, Exception exp) {
		logger.error("捕获到全局异常信息:"+exp.getMessage(),exp);
		ModelAndView errorView = new ModelAndView("redirect:/resources/html/error.html");
		return errorView;
	}

}
