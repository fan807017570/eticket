<!DOCTYPE html>
<html style="font-size: 36px;">

<#include "base.ftl">

<@htmlHead title="券详情">
	<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-mobile-web-app-status-bar-style" content="black">
       
        <link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/style-vesion1.0.css" />
        <style>
   			.ticket-detail{
   				font-size: 0.34375rem;
   				padding-bottom: 1.5625rem;
   			}
   		</style>
</@htmlHead>
<@htmlBody>
	<div class="ticket-detail">
		<#escape x as x?html>
		<div class="bgF6 top">
			<div class="img" style="margin-top:0;padding-top:0px;">
				<img src="${coupon.wxDetailImage!''}" />
			</div>
			<div class="info">
				<p class="num">${coupon.couponName}</p>
				<p class="price">原价：<i><span>￥<span>${coupon.amount}</span></span></i></p>
				<div class="priceNow">现价：${coupon.price}</div>
				<p class="time">有效期：${coupon.useDateSpan}</p>
			</div>
		</div>
		<div class="bgF6border sellerInfo">
			<h2><span></span>商家信息</h2>
			<div class="info">${coupon.orgName}</div>
		</div>
		<#if (coupon.orgPosCount > 0) >
			<div class="bgF6border branch">
			查看全部${coupon.orgPosCount}家分店 
			</div>
		</#if>
		</#escape>
		<div class="bgF6border content3">
			<p class="title">
				使用详情
			</p>
			<p class="info" style="padding:0;">
				${coupon.description}
			</p>
			<#escape x as x?html>
			<p class="title">
				抢券时间
			</p>
			<p class="info">
				${coupon.getDate}
			</p>
			</#escape>
		</div>
		<#escape x as x?html>
		<div class="bgF6border hongbaoList" style="display:none;"></div>
		<#if coupon.status == 2 >
			<div class="fixedBottom">
					<div class="left">
						<a href="javascript:void(0);">使用券</a>
					</div>
					<div class="right">
						<a href="javascript:void(0);">送好友</a>
					</div>
			</div>			
		</#if>
		</#escape>
	</div>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/template.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>
	<script type="text/javascript">
		$(function(){
			$('.back').click(function(event) {
				window.history.back();
			});
			$('.branch').click(function(event) {
				var url = '${buyer_weixin_domain}/view/weixin/position?orgId='+${coupon.orgId};
				window.location = url;
			});
			$('.left').click(function(event) {
				var url = '${buyer_weixin_domain}/view/weixin/use?picturePath=' +
				'${coupon.wxDetailImage!""}&orgName=${coupon.orgName}' + 
				'&useSpan=${coupon.useDateSpan}&couponSN=${coupon.realCouponSN}&realCouponSN=${coupon.realCouponSN}' +
				'&topicId=${coupon.topicId?c}&couponId=${coupon.couponId?c}';
				url = encodeURI(url);
				window.location.replace(url);
			});
			$('.right').click(function(event) {
				var url = '${buyer_weixin_domain}/view/weixin/presend?couponId=${coupon.couponId?c}&topicId=${coupon.topicId?c}&couponName=${coupon.couponName}&couponDesc=平安银行橙e券&couponImage=${coupon.pcListImage!""}';
				url = encodeURI(url);
				window.location.replace(url);
			});
		});
		
		window.onscroll = function(){
			var t = document.documentElement.scrollTop || document.body.scrollTop; 
			if(t>0){
				$(".toTop").show();
			}else{
				$(".toTop").hide();
			}
		} 
		
		function doWxMethod() {
			if(wx) {
				//调用微信分享给朋友接口
				wx.onMenuShareAppMessage({
				    title: '您的好友分享了优惠券给您，赶快领取吧！', // 分享标题
				    desc: '${coupon.couponName}', // 分享描述
				    link: "${buyer_weixin_domain}/view/weixin/detail?topicid=${coupon.topicId}&couponName=${coupon.couponName}&couponid=${coupon.couponId}&couponImg=${coupon.wxDetailImage!''}", // 分享链接
				    imgUrl: '${coupon.wxDetailImage!''}', // 分享图标
				    success: function () {
				    },
				    cancel: function () { 
				    }
				});
				
				//调用微信分享到朋友圈接口
				wx.onMenuShareTimeline({
					title: '您的好友分享了优惠券给您，赶快领取吧！', // 分享标题
					//title: '${coupon.couponName}', // 分享标题
					link: "${buyer_weixin_domain}/view/weixin/detail?topicid=${coupon.topicId}&couponName=${coupon.couponName}&couponid=${coupon.couponId}&couponImg=${coupon.wxDetailImage!''}", // 分享链接
					imgUrl: '${coupon.wxDetailImage!''}', // 分享图标
					success: function () {
				    },
				    cancel: function () { 
				    }
				});
        	}
        }
	</script>
</@htmlBody>

</html>