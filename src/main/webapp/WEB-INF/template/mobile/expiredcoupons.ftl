<!DOCTYPE html>
<html style="font-size: 36px;">

<#include "base.ftl">

<@htmlHead title="券管理">
	<link rel="stylesheet" href="${buyer_portal_static_resources_domain}/plugin/font-awesome-4.4.0/css/font-awesome.min.css" />
	<link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/style-vesion1.0.css" />
</@htmlHead>

<@htmlBody>
<#escape x as x?html>
	<!-- 异步加载等待提示效果 -->
	<div class="fakeloader" style="display: none;">
		<div class="spinner3">
			<div class="dot1"></div>
			<div class="dot2"></div>
		</div>
	</div>
     <div class="myTicket">
		<header class="public_header">
			<ul class="tabs"> 
				<li><a href="${buyer_weixin_domain}/view/weixin/mycoupon">未使用</a></li>
				<li><a href="${buyer_weixin_domain}/view/weixin/usedcoupon">已使用</a></li>
				<li><a href="#" class="active">已过期</a></li>
				<li><a href="${buyer_weixin_domain}/view/weixin/refundcoupon">退款单</a></li>
			</ul>
		</header>
		<div class="notFound">
			<img src="${buyer_portal_static_resources_domain}/img/pic_crying2.png">
			<p>您还没有已过期的优惠券!</p>
		</div>
		<div class="coupon-list-cantainer list">
		</div>
		<a class="toTop" href="#top"></a>
	</div>

	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/template.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/js/init.js" ></script>
	<script id="listtemplate" type="text/html">
		{{each coupons as coupon}}
			  <div class="item" >
				<a href="javascript:void();" class="img-text" onClick="javascript:window.location='${buyer_weixin_domain}/view/weixin/detail?topicid={{coupon.topicId}}&couponid={{coupon.couponId}}'">
					<div class="img">
						<img src="{{coupon.wxListImage}}" />
					</div>
					<div class="text">
						<p class="title">{{coupon.couponName}}</p>
						<p class="price">券码：{{coupon.couponSN}}</p>
						{{if coupon.topicClass == 'PERCENT_PRICE' }}
						<p class="zhe">
							{{coupon.percentPrice}}折
						</p>
						{{else if coupon.topicClass == 'OFF_PRICE'}}
						<p class="zhe">
							满{{coupon.fullPrice}}减{{coupon.offPrice}}
						</p>
						{{else if coupon.topicClass == 'FOR_CASH'}}
						<p class="price">￥{{coupon.price}}</p>
						<p class="oldPrice">原价：￥{{coupon.amount}}</p>
						{{else}}
						<p class="price">免费</p>
						<p class="oldPrice">原价：￥{{coupon.amount}}</p>
						{{/if}}
					</div>
				</a>
				
				<div class="bottom">
					<div class="left">有效期：{{coupon.startDate}} - {{coupon.endDate}}</div> 
					<div class="right"> 
							<a href="javascript:window.location.replace('${buyer_weixin_domain}/view/weixin/detail?topicid={{coupon.topicId}}&couponid={{coupon.couponId}}')">查看详情<img src="${buyer_portal_static_resources_domain}/img/icon_double_arrow_right.png"></a>
					</div>
					</div>
				</div>
			</div>
	   {{/each}}
	    </script>
	<script>
			var page = 1;
			var loadmore = false;
			$(function(){
				$(".back").click(function(){
					window.history.go(-1);
					window.location.reload();
				});
				$(".notFound").hide();
				queryDatas(page);
			});
			// 窗口滚动事件
	       	$(window).scroll(function(){
	       		if(($(document).height()-$(this).scrollTop()-$(this).height()) < 50) {
	       			if(loadmore) {
	       				page++;
						queryDatas(page);
	       			}else
	       			{
	       				var thereisnomore = $(".coupon-list-cantainer").find(".thereisnomore").size();
	       				if(thereisnomore == 0 ){
	       					$(".coupon-list-cantainer").append("<div class='thereisnomore'><p>到底了，没有别的了！</p></div>");
	       				}
	       			}
	       		}
	       		
	       		var t = document.documentElement.scrollTop || document.body.scrollTop; 
				if(t>0){
					$(".toTop").show();
				}else{
					$(".toTop").hide();
				}
				
	       	});
			function queryDatas(page){
				$(".fakeloader").show();
				$.get("${buyer_weixin_domain}/view/member/expired?page="+page+"&ts="+new Date(), 
				  	function(result){
					   var data = $.parseJSON(result);
					   if(data.coupons && data.coupons.length > 0){
						   	var listhtml = template('listtemplate',data);
						   	$(".coupon-list-cantainer").append(listhtml);
						   	$(".list").show();
					   }else{
					   		if(page==1) {
					   			$(".list").hide();
						   		$(".notFound").show();	
					   		}
					   }
					   if(!data.hasmore){
							loadmore = false;
					   }else{
							loadmore = true;
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
						title: '平安银行橙e券', // 分享标题
						link: '${buyer_weixin_domain}/view/weixin/expiredcoupon', // 分享链接
						imgUrl: '${buyer_weixin_domain}/resources/img/circle_logo.png', // 分享图标
					    success: function () {
					    	var url = "${buyer_weixin_domain}/view/weixin/expiredcoupon";
				        	window.location.replace(url);
					    },
					    cancel: function () { 
					        
					    }
					});


					wx.onMenuShareAppMessage({
					    title: '平安银行橙e券', // 分享标题
					    desc: '我领的券', // 分享描述
					    link: '${buyer_weixin_domain}/view/weixin/expiredcoupon', // 分享链接
					    imgUrl: '${buyer_weixin_domain}/resources/img/circle_logo.png', // 分享图标
					    type: 'link', // 分享类型,music、video或link，不填默认为link
					    dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
					    success: function () { 
					    	var url = "${buyer_weixin_domain}/view/weixin/expiredcoupon";
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