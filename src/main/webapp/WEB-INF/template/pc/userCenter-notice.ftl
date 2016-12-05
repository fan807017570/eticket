<!DOCTYPE html>
<html>

<#include "userCenter-base.ftl">

<@htmlHead title="我的通知">
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
				<li>
					<a href="${buyer_portal_domain}/view/web/usercenter/ticket">我领的券</a>
				</li>
				<li>
					<a href="${buyer_portal_domain}/view/web/usercenter/hongbao">我的红包</a>
				</li>
				<li class="active">
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
				<li>
					<a href="${buyer_portal_domain}/view/web/usercenter/ticket">我领的券（<span class="v_coupon">0</span>）</a>
				</li>
				<li>
					<a href="${buyer_portal_domain}/view/web/usercenter/hongbao">我的红包（<span class="v_hongbao">0</span>）</a>
				</li>
				<li class="active">
					<a href="${buyer_portal_domain}/view/web/usercenter/notice">我的通知（<span class="v_notice">0</span>）</a>
				</li>
			</ul>
		</div>
		<div class="right notice">
			<div class="list redEnvelopes">
				<ul id="topic-cantainer">
					<li>
						<div>券信息</div>
						<div>有效期</div>
						<div>通知信息</div>
						<div>操作</div> 
					</li>
				</ul>
			</div>
		</div>
	</section>

	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/template.js" ></script>
	<script type="text/javascript">

		jQuery(document).ready(function($) {
			queryStatistics();
			queryDatas();
		});

		function queryDatas() {
			var loadDataUrl = "${buyer_portal_domain}/view/user/notice?ts="+new Date();
		  	$.get(loadDataUrl, function(result){
				var data = $.parseJSON(result);
			   	if(data.notices && data.notices.length > 0){
					var listhtml = template('listtemplate', data);
				   	$("#topic-cantainer").append(listhtml);
			   	}
		  	});
	  	};

	  	function queryStatistics() {
			var loadDataUrl = "${buyer_portal_domain}/view/user/statistics?ts="+new Date();
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
	<script id="listtemplate" type="text/html">
		{{each notices as topic}}
		<li>
			<div class="info">
				<div class="img">
					<img src="{{topic.pcListImage}}" />
				</div>
				<div class="description">
					<a href="${buyer_portal_domain}/view/cpnweb/cpnDetail?topicId={{topic.topicId}}" title="{{topic.couponName}}">{{topic.couponName}}</a>
					<span>有效期至：{{topic.endDate}}</span>
				</div> 
			</div>
			<div class="doubleline">{{topic.startDate}}<br/>{{topic.endDate}}</div>
			<div class="singleline"><span class="orange">{{topic.expiredTip}}</span></div> 
			<div class="singleline"><a href="${buyer_portal_domain}/view/web/detail?topicId={{topic.topicId}}&couponId={{topic.couponId}}" class="see">查看</a></div> 
		</li>
		{{/each}}
	</script>
	</#escape>
</@htmlBody>

</html>