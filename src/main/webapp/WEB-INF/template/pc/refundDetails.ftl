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
			<div class="right refund">
				<div class="title_bold">
					退款详情
					<a class="help" href="${buyer_portal_domain}/view/web/refund_help.htm" ><span class="icon">？</span>退款帮助</a>
				</div>
				
				<div class="details payment">
					<div class="top">
						<p>${refund.couponName}</p>
						<p>
							<span>
								退款金额：<span class="num">￥${refund.refundAmount}元</span>
							</span>
							<span>
								数量：<span class="num">${refund.refundCount}</span>
							</span>
							<span>
								优惠券：<span>${refund.couponSN}</span>
							</span>
							<span>
								返回账户：<span>${refund.refundAccount}</span>
							</span>
						</p>
					</div>
					<div class="steps">
						
						<ul>
							<li class="active"><a href="#" class="circle">1</a><a href="#" class="text">橙e卷审核处理</a></li>
							<li <#if refund.refundStatus == 8 > class="active"</#if>><a href="#" class="circle">2</a><a href="#" class="text">支付平台处理</a></li>
							<li <#if refund.refundStatus == 8 > class="active"</#if>><a href="#" class="circle">3</a><a href="#" class="text">退款成功</a></li>
		
						</ul>
					</div>
					
					<p>
						<#if refund.refundStatus == 7 >
							当前状态：橙e券审核处理（您的退款申请受理，橙e券会尽快完成审核，部分商品需要1-2个工作日）
							<#else>
							当前状态：微信处理完成后，${refund.refundAmount}元退款将会在3-5个工作日内退至您的微信账户。
						</#if>
						
					</p>
				</div>
				
				<div class="topay">
					<input class="topaybtn" onclick="javascript:history.back();" type="button" name="topay" value="返回"/>
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
