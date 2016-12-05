<!DOCTYPE html>
<html style="font-size: 36px;">

<#include "base.ftl">

<@htmlHead title="退款详情">
</@htmlHead>

<@htmlBody>
<#escape x as x?html>
	<div class="refundDetail">
		
		<div class="base bgF6border">
			<p>
				<span>退款金额</span>
				<span>￥${refund.refundAmount?string("0.00")}元</span>
			</p>
			<p>
				<span>数量</span>
				<span>${refund.refundCount}</span>
			</p>
			<p>
				<span>优惠券</span>
				<span>${refund.couponSN}</span>
			</p>
			<p>
				<span>退回账户</span>
				<span>${refund.refundAccount}</span>
			</p>
		</div> 
		<div class="steps bgF6border">
			<div class="head">
				<span>退款流程</span>
				<span>退款帮助<a href="${upload_weixin_file_domain}/html/help/mobile/refundhelp.html">?</a></span>
			</div>
			<div class="detail">
				 <div class="box">
				 	<#if refund.refundStatus==7>
				 	<header class="now">退款审核&nbsp;&nbsp;&nbsp;<span>${refund.applyTime!}</span></header>
				 	<#else>
				 	<header>退款审核&nbsp;&nbsp;&nbsp;<span>${refund.applyTime!}</span></header>
				 	</#if>
				 	<div class="intro">
				 		您的退款申请已受理，橙e券将尽快完成审核，部分商品需要1－2个工作日。
				 	</div>
				 </div>
				 <div class="box">
				 	<header>微信钱包</header>
				 	<div class="intro">
				 		橙e券审核通过后退款申请将提交至微信，微信会在1－3个工作日内完成处理。
				 	</div>
				 </div>
				 <div class="box">
				 	<#if refund.refundStatus==8>
				 	<header class="now">退款成功&nbsp;&nbsp;&nbsp;<span>${refund.refundTime!}</span></header>
				 	<#else>
				 	<header>退款成功&nbsp;&nbsp;&nbsp;<span>${refund.refundTime!}</span></header>
				 	</#if>
				 	<div class="intro">
				 		微信处理完成后，退款￥${refund.refundAmount?string("0.00")}元会在3－5个工作日内退至您的账户。
				 	</div>
				 </div>
			</div>
		</div> 
	</div>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>
	<script type="text/javascript">
		jQuery(document).ready(function($) {
			$(".back").click(function(){
				var url = "${buyer_weixin_domain}/view/weixin/refundcoupon";
				window.location.replace(url);
			});
		});
	</script>
	</#escape>
</@htmlBody>
</html>
