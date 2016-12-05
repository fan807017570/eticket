<!DOCTYPE html>
<html>

<#include "userCenter-base.ftl">

<@htmlHead title="优惠券信息">
</@htmlHead>

<@htmlBody>
<#escape x as x?html>
	<section class="navAndbanner">
		<!--导航部分 开始-->
		<div class="nav">
			<ul class="width1000">
				<li>
					<a href="${buyer_portal_domain}/">橙e券首页</a> 
				</li>
				<li class="active">
					<a href="${buyer_portal_domain}/view/web/usercenter/ticket">我领的券</a>
				</li>
				<li>
					<a href="${buyer_portal_domain}/view/web/usercenter/hongbao">我的红包</a>
				</li>
				<li>
					<a href="${buyer_portal_domain}/view/web/usercenter/notice">我的通知</a>
				</li> 
			</ul>
		</div>
		<!--导航部分 结束-->
	</section>

	<section class="userCenter width1000">
		<div class="left navleft">
			<header>我的橙e券</header>
			<ul>
				<li class="active">
					<a href="${buyer_portal_domain}/view/web/usercenter/ticket">我领的券（<span class="v_coupon">0</span>）</a>
				</li>
				<li>
					<a href="${buyer_portal_domain}/view/web/usercenter/hongbao">我的红包（<span class="v_hongbao">0</span>）</a>
				</li>
				<li>
					<a href="${buyer_portal_domain}/view/web/usercenter/notice">我的通知（<span class="v_notice">0</span>）</a>
				</li>
			</ul>
		</div>
		<div class="right ticketInfo">
			 <div class="info">
			 	<header>优惠券信息</header>
			 	<div class="box">
			 		<div class="img">
			 			<img src="${coupon.pcDetailImage!''}" />
			 		</div>
			 		<div class="text">
			 			<p class="title">优惠券名称：<span class="orange">${coupon.couponName}</span></p>
			 			<p>原价：${coupon.amount}元</p>
			 			<p>现价：${coupon.price}元</p>
			 		</div>
			 	</div>
			 </div>
			 
			 <div class="detail">
			 	<header>券详情</header>
			 	<div class="box">
			 		<p>优惠券券号：<span class="orange">${coupon.couponSN}</span></p>
			 		<#if coupon.status == 2 || coupon.status == 3>
			 			<p>优惠状态：<span class="orange">未使用</span></p>
			 		<#elseif coupon.status == 6>
			 			<p>优惠状态：<span class="orange">已过期</span></p>
			 		<#else>
			 			<p>优惠状态：<span class="orange">已使用</span></p>
			 		</#if>
			 		<p>有效期：<span class="orange">${coupon.useDateSpan}</span></p>
			 		<p>商家：${coupon.orgName}</p>
			 	</div>
			 </div>
			 
			 
		</div>
	</section>

	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>

	<script type="text/javascript">

		jQuery(document).ready(function($) {
			queryStatistics();
		});

		function queryStatistics() {
			var loadDataUrl = "${buyer_portal_domain}/view/user/statistics";
		  	$.get(loadDataUrl, function(result){
				var data = $.parseJSON(result);
			   	if(data.statistics) {
			   		$('.v_coupon').html(data.statistics.unused+data.statistics.used+data.statistics.expired+data.statistics.refund);
			   		$('.v_hongbao').html(data.statistics.received+data.statistics.sended);
			   		$('.v_notice').html(data.statistics.notice);
			   	}
		  	});
	  	};
	</script>
	</#escape>
</@htmlBody>

</html>
