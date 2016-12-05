<!DOCTYPE html>
<html style="font-size: 36px;">

<#include "base.ftl">

<@htmlHead title="我的通知">
</@htmlHead>

<@htmlBody>
<#escape x as x?html>
	<div class="myTicket">
		<header class="public_header">
				<span class="title">快过期的券</span>
		</header>
		
		<#if (coupons?size==0)>
			<div class="notFound">
				<img src="${buyer_portal_static_resources_domain}/img/pic_crying2.png">
				<p>暂无此类信息，请看看别的吧</p>
			</div>
		<#else> 
			<#list coupons as coupon>	
				<div class="item">
					<a href="${buyer_weixin_domain}/view/weixin/detail?topicid=${coupon.topicId}&couponid=${coupon.couponId}" class="img-text">
						<div class="img">
							<img src="${coupon.wxListImage!''}">
						</div>
						<div class="text">
							<p class="title">${coupon.couponName}</p>
							<p class="price">￥${coupon.price}</p>
							<p class="price">券码：${coupon.couponSN}</p>
							<p class="oldPrice">原价：${coupon.amount}</p>
						</div>
					</a>
					<div class="bottom">
						<div class="left">有效期：${coupon.useDateSpan}</div> 
						<div class="right"> 
							${coupon.expiredTip}
						</div>
					</div>
				</div>
			</#list>
			 <div id="noOthers">
			 </div>
		 </#if>
		<a title="返回顶部" class="goto-top" style="display: block; position: fixed;" href="#"></a>
	</div>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/template.js" ></script>
	<script type="text/javascript">
		jQuery(document).ready(function($) {
			$('.back').click(function(event) {
				window.history.back();
			});
			var b=1;
			// 窗口滚动事件
	       	$(window).scroll(function(){
	       		if(b==1){
	       		$("#noOthers").append("<div class='thereisnomore'><p>到底了，没有别的了！</p></div>");
	       		}
	       		b++;
	       	});
			
		});
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
					title: '平安银行橙e券', // 分享标题
					link: '${buyer_weixin_domain}/view/weixin/expiring', // 分享链接
					imgUrl: '${buyer_weixin_domain}/resources/img/circle_logo.png', // 分享图标
				    success: function () {
				    	var url = "${buyer_weixin_domain}/view/weixin/expiring";
			        	window.location.replace(url);
				    },
				    cancel: function () { 
				        
				    }
				});


				wx.onMenuShareAppMessage({
				    title: '平安银行橙e券', // 分享标题
				    desc: '我的通知', // 分享描述
				    link: '${buyer_weixin_domain}/view/weixin/expiring', // 分享链接
				    imgUrl: '${buyer_weixin_domain}/resources/img/circle_logo.png', // 分享图标
				    type: 'link', // 分享类型,music、video或link，不填默认为link
				    dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
				    success: function () { 
				    	var url = "${buyer_weixin_domain}/view/weixin/expiring";
			        	window.location.replace(url);
				    },
				    cancel: function () { 
				       	
				    }
				});
        	}
        }
	</script>
	</#escape>
</@htmlBody>
</html>