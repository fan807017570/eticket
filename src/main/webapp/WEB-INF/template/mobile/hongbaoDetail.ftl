<!DOCTYPE html>
<html style="font-size: 36px;">

<#include "base.ftl">

<@htmlHead title="红包详情">
</@htmlHead>

<@htmlBody>
<#escape x as x?html>
	<#if userType == "RECEIVER">
		<a class="popCE">恭喜您领到红包</a>
	<#elseif userType != "SENDER">
		<a class="popCE">很遗憾，红包已经被别人领取</a>
	</#if>	
	<div class="fakeloader" style="display: none;">
		<div class="spinner3">
			<div class="dot1"></div>
			<div class="dot2"></div>
		</div>
	</div>

	<div class="senderClickPage">
		<div class="hongbaoTop">
			<a href="javascript:void(0);" class="img">
				<img src="${senderImg}" />
			</a>
			<p>${senderName}的红包</p>
		</div>

		<div class="ticketInfo">
			<div class="left">
				<div class="title">${couponName}</div>
				<div class="price">
					<#if couponOriInfo?? >
						<#if (couponInfo == "免费") >
						<span>免费</span>
						<#else>
						￥<span>${couponInfo}</span>
						</#if>
						<#if (couponOriInfo>0) >
						<span class="text-decoration">原价：${couponOriInfo}元</span>
						</#if>
					<#else>
					<span>${couponInfo}</span>
					</#if>
				</div>
			</div>
			<a href="${buyer_weixin_domain}/view/weixin/index" class="btn btn-theme">
				<#if (couponInfo == "免费") >
					<#if userType == "SENDER">
					再去领<span class="icon icon-arrow-right_2"></span>
					<#else>
					我也领<span class="icon icon-arrow-right_2"></span>
					</#if>
				<#else>
					<#if userType == "SENDER">
					再去买<span class="icon icon-arrow-right_2"></span>
					<#else>
					我也买<span class="icon icon-arrow-right_2"></span>
					</#if>
				</#if>
			</a>
		</div>

		<div class="friendList">
			<div class="top-heng"></div>
			<div class="list">
				<#if couponStatus == "COUPON_GOT">
				<header>已领取1/1个红包</header>
				<#elseif couponStatus == "COUPON_SHARING">
				<header>您的红包还未被领取</header>
				<#elseif couponStatus == "SHARE_EXPIRED">
				<header>手慢了，红包已经于${expiredTips}过期了</header>
				<#elseif couponStatus == "COUPON_EXPIRED">
				<header>手慢了，红包的券已经于${expiredTips}过期了</header>
				</#if>
				<ul id="list-cantainer">
				</ul>
			</div>
		</div>

		<#if userType == "SENDER">
		<input type="button" id="sendable" value="继续发红包" class="btn100"/>
		<#else>
		<input type="button" id="hongbao" value="查看我的红包" class="btn100"/>
		</#if>

	</div>
	
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/template.js" ></script>
	
	<script id="contentemplate" type="text/html">
	{{each joiners as joiner}}
	<li>
		<a href="javascript:void(0);">
			{{if joiner.receiver}}
			<span class="icon icon-golden"></span>
			{{/if}}
			<div class="img">
				<img src="{{joiner.userWxImgUrl}}" />
			</div>
			<div class="name">{{joiner.userWxName}}</div>
			<div class="time">{{joiner.userJoinTime}}</div>
		</a>
	</li>
	{{/each}}
	</script>

	<script type="text/javascript">

		var page = 1;
		var loadmore = false;

		jQuery(document).ready(function($) {
			if("${couponStatus}" == "COUPON_GOT" || "${couponStatus}" == "SUCCESS"){
			
				$('.more').click(function() {
					queryJoiners(page);
				});
				// 窗口滚动事件
		       	$(window).scroll(function(){
		       		if(($(document).height()-$(this).scrollTop()-$(this).height()) < 50 ) {
		       			if(loadmore){
		       				queryJoiners(page);
		       			}
		       		}
		       		/*var t = document.documentElement.scrollTop || document.body.scrollTop; 
					if(t>0){
						$(".toTop").show();
					}else{
						$(".toTop").hide();
					}*/
		       	});
				queryJoiners(page);
			}
			$('#sendable').click(function() {
				window.location="${buyer_weixin_domain}/view/weixin/sendable";
			});
			$('#hongbao').click(function() {
				window.location="${buyer_weixin_domain}/view/weixin/hongbao";
			});
			if("${couponStatus}" == "COUPON_GOT" || "${couponStatus}" == "SUCCESS"){
				var oPopCE = $(".popCE");
				if(oPopCE != null && oPopCE != undefined){
					$('.popCE').slideDown('normal').delay(5000).slideUp('slow', function(){
						
					});
				}
			}
			//左边券信息点击   进入券详情界面
			$(".left").click(function(){
				if("${userType}" == "RECEIVER" && ("${couponStatus}" == "COUPON_GOT" || "${couponStatus}" == "SUCCESS")){
					window.location="${buyer_weixin_domain}/view/weixin/detail?topicid=${topicId}&couponid=${recCouponId}";
				}
				else{
					window.location="${wxDetailHtmlUrl}";
				}
			})
		});
		
		function queryJoiners(curPage){
			$(".fakeloader").show();
			loadmore = false;
			var loadDataUrl = "${buyer_weixin_domain}/view/share/joiner?page=" + curPage + 
				"&userId=${userId?c}&couponId=${couponId?c}" + "&ts=" + new Date();
		  	$.get(loadDataUrl, function(result){
				var data = $.parseJSON(result);
			   	if(data.joiners && data.joiners.length > 0){
				   	var listhtml = template('contentemplate', data);
				   	$('#list-cantainer').append(listhtml);
				   	page++;
			   	}
			   	if(data.hasmore){
			   		loadmore = true;
			   	}else{
			   		loadmore = false;
			   	}
			   	$(".fakeloader").hide();   	
			});
		}
		function doWxMethod() {
	    	if(wx) {
	
	    		wx.hideMenuItems({
	    			// 要隐藏的菜单项，只能隐藏“传播类”和“保护类”按钮，所有menu项见附录3
					menuList: [
						"menuItem:share:qq",
						"menuItem:share:weiboApp",
						"menuItem:favorite",
						"menuItem:share:facebook",
						"menuItem:share:QZone",
						"menuItem:delete",
						"menuItem:originPage",
						"menuItem:readMode",
						"menuItem:openWithQQBrowser",
						"menuItem:openWithSafari",
						"menuItem:share:email",
						"menuItem:share:brand"
					]
				});
				wx.onMenuShareTimeline({
					title: "您的好友分享了优惠券给您，赶快领取吧！", // 分享标题
					desc: "${couponName}",
					link: "${wxDetailHtmlUrl}", // 分享链接
					imgUrl: "${wxDetailImage}" // 分享图标
				});
				wx.onMenuShareAppMessage({
				    title: "您的好友分享了优惠券给您，赶快领取吧！", // 分享标题
				    desc: "${couponName}",
					link: "${wxDetailHtmlUrl}", // 分享链接
					imgUrl: "${wxDetailImage}" // 分享图标
				});
	    	}
	    }
	</script>
	</#escape>
</@htmlBody>
</html>
