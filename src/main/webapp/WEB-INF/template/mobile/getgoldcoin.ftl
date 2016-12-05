<!DOCTYPE html>
<html>

<#include "base.ftl">

<@htmlHead title="发红包">
	<style>
		canvas{position:absolute;top:0;left:0;}
	</style>
</@htmlHead>

<@htmlBody>
	<#escape x as x?html>
	<div class="fakeloader" style="display: none;">
		<div class="spinner3">
			<div class="dot1"></div>
			<div class="dot2"></div>
		</div>
	</div>	
	<div class="goldCoin">
		<div class="img">
			<img src="${buyer_portal_static_resources_domain}/img/overlayer.png" />
		</div>
	</div>
	<div class="hbtips">
		<img src="${buyer_portal_static_resources_domain}/img/right_tip.png" />
	</div>
	</#escape>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js"></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>
	<!--<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jinbi.js"></script>-->
	<script type="text/javascript">

		jQuery(document).ready(function($) {
			//$(".fakeloader").show();
			//$(".goldCoin").height($(window).height());			

			$(".hbtips").click(function() {
				//$(".hbtips").hide();
			});

			$(".back").click(function(event) {
				var url = '${buyer_weixin_domain}/view/weixin/detail?topicid=${topicId}&couponid=${couponId}';
				window.location.replace(url);				
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
    					"menuItem:share:timeline",
    					"menuItem:share:brand"
    				]
				});

        		wx.onMenuShareTimeline({
					//title: '平安银行橙e券红包', // 分享标题
					title: '我买了一张提货券送您，无需支付，关注即可领取！', // 分享标题
					link: '${shareUrl}', // 分享链接
					imgUrl: '${couponImage}', // 分享图标
					//imgUrl: '${buyer_weixin_domain}/resources/img/bribery_money.png', // 分享图标
				    success: function () {
				        // 用户确认分享后执行的回调函数
				        var getUrl = "${buyer_weixin_domain}/view/share/confirm?couponId=${couponId}";
				        $.get(getUrl, function(result){
				        	var url = "${buyer_weixin_domain}/view/weixin/mygift";
				        	window.location.replace(url);
				  		});
				    },
				    cancel: function () { 
				        
				    }
				});

				wx.onMenuShareAppMessage({
				   // title: '平安银行橙e券红包', // 分享标题
				    title: '我买了一张提货券送您，无需支付，关注即可领取！', // 分享标题
				    desc: '${couponName}', // 分享描述
				    link: '${shareUrl}', // 分享链接
				    imgUrl: '${couponImage}', // 分享图标
				    //imgUrl: '${buyer_weixin_domain}/resources/img/bribery_money.png', // 分享图标
				    type: 'link', // 分享类型,music、video或link，不填默认为link
				    dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
				    success: function () { 
				        // 用户确认分享后执行的回调函数
				        var getUrl = "${buyer_weixin_domain}/view/share/confirm?couponId=${couponId}";
				        $.get(getUrl, function(){
				        	var url = "${buyer_weixin_domain}/view/weixin/mygift";
				        	window.location.replace(url);
				  		});
				    },
				    cancel: function () { 
				       	
				    }
				});

			//	$(".fakeloader").hide();
			//	$(".goldCoin").fadeIn(500, function() {
				//	coin = new Coin({
				//		coinSrc: "${buyer_portal_static_resources_domain}/img/jinbi30.png",
				//		audioSrc: "${buyer_portal_static_resources_domain}/img/shake.mp3"
					//	});
				//	setTimeout('$(".hbtips").show();', 1500);
				//});
        	}
        }
	</script>
</@htmlBody>

</html>