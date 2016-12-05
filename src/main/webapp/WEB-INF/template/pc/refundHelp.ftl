<!DOCTYPE html>
<html>

<#include "userCenter-base.ftl">

<@htmlHead title="退款详情">
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
			<div class="right notice">
				<div class="refund-help-header">
					退款帮助
					<a href="javascript:;" onclick="javascript:history.back();" class="right">返回</a>
				</div>
				<div class="refund-help-text">
					${content}
				</div>

			</div>
		</section>

		<script type="text/javascript">
			$(function() {
				queryStatistics();
			});
			
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
		</#escape>
		</@htmlBody>

</html>