<!DOCTYPE html>
<html style="font-size: 36px;">

<#include "base.ftl">

<@htmlHead title="红包信息">
</@htmlHead>

<@htmlBody>
<#escape x as x?html>
	<div class="popbg">
		<#if (couponStatus == "COUPON_SHARING") >
		<div class="hongbao">
			<img src="${buyer_portal_static_resources_domain}/img/pic_packet2.png" class="bg">
			<a href="javascript:void(0);" class="icon"></a>
			<a href="javascript:void(0);" class="img">
				<img src="${senderImg}">
			</a>
			<p>${senderName}</p>
			<p class="tips">给你发了一个橙e券红包</p>
			<p>恭喜发财，大吉大利！</p>
			<a href="${nextUrl}" class="open">拆红包</a>
		</div>
		<#elseif (couponStatus == "COUPON_EXPIRED") >
		<div class="hongbao hongbao_ticket">
			<img src="${buyer_portal_static_resources_domain}/img/pic_packet3.png" class="bg">
			<a href="javascript:void(0);" class="icon"></a>
			<a href="javascript:void(0);" class="img">
				<img src="${senderImg}">
			</a>
			<p>${senderName}</p>
			<p class="tips2">该红包的券已于${expiredTips}过期</p>
			<#if userType == "SENDER">
				<p>继续发其他红包</p>
				<a href="${buyer_weixin_domain}/view/weixin/sendable" class="icon_continue"></a>  
			<#else>
				<a href="${nextUrl}" class="tips3">查看红包详情</a> 
			</#if>
		</div>
		<#elseif (couponStatus == "SHARE_EXPIRED") >
		<div class="hongbao hongbao_ticket">
			<img src="${buyer_portal_static_resources_domain}/img/pic_packet3.png" class="bg">
			<a href="javascript:void(0);" class="icon"></a>
			<a href="javascript:void(0);" class="img">
				<img src="${senderImg}">
			</a>
			<p>${senderName}</p>
			<p class="tips2">该红包已于${expiredTips}过期</p>
			<#if userType == "SENDER">
				<p>继续发红包</p>
				<a href="${buyer_weixin_domain}/view/weixin/sendable" class="icon_continue"></a>
			<#else>
				<a href="${nextUrl}" class="tips3">查看红包详情</a> 
			</#if> 
		</div>
		<#elseif (couponStatus == "COUPON_GOT") >
		<div class="hongbao hongbao_ticket">
			<img src="${buyer_portal_static_resources_domain}/img/pic_packet3.png" class="bg">
			<a href="javascript:void(0);" class="icon"></a>
			<a href="javascript:void(0);" class="img">
				<img src="${senderImg}">
			</a>
			<p>${senderName}</p>
			<p class="tips2">手慢了，红包派完了</p>
			<a href="${nextUrl}" class="tips3">看看大家手气</a> 
		</div>
		<#elseif (couponStatus == "SUCCESS") >
		<div class="hongbao hongbao_ticket">
			<img src="${buyer_portal_static_resources_domain}/img/pic_packet3.png" class="bg">
			<a href="javascript:void(0);" class="icon"></a>
			<a href="javascript:void(0);" class="img">
				<img src="${senderImg}">
			</a>
			<p>${senderName}</p>
			<p class="tips2">恭喜您，抢到红包了</p>
			<a href="${nextUrl}" class="tips3">看看大家手气</a> 
		</div>
		</#if>
	</div>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>
	<script type="text/javascript">
		jQuery(document).ready(function($) {
// 			$('.icon-close2').click(function() {
// 				window.history.back(-1);
// 			});
		});
	</script>
	</#escape>
</@htmlBody>
</html>
