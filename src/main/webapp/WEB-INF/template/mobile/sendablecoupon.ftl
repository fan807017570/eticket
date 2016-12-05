<!DOCTYPE html>
<html>

<#include "base.ftl">

<@htmlHead title="送朋友">
</@htmlHead>

<@htmlBody>
<#escape x as x?html>
	<div class="fakeloader" style="display: none;">
		<div class="spinner3">
			<div class="dot1"></div>
			<div class="dot2"></div>
		</div>
	</div>
	<header class="public_header">
			<span class="title">您可以发的券</span>
	</header>
	<div class="hongbaoList" id="sendablecoupon">
		<div style="display: none;" class="notFound">
			<img src="${buyer_portal_static_resources_domain}/img/pic_crying2.png">
			<p>
				您还没有优惠券可以送给朋友，赶紧<a href="${buyer_weixin_domain}/view/weixin/index">去抢券</a>吧！
			</p>
		</div>
		<a class="toTop" href="#top"></a>
	</div>

	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/template.js" ></script>
	<script id="coupontemplate" type="text/html">
		{{each coupons as coupon}}
		<div class="item">
			<a href="${buyer_weixin_domain}/view/weixin/detail?topicid={{coupon.topicId}}&couponid={{coupon.couponId}}">
				<div class="img">
					<img src="{{coupon.wxListImage}}">
				</div>
				<div class="info">
					<p class="title">{{coupon.couponName}}</p>
					<p>
						{{if coupon.topicClass == "USER_DEFINE"}}
							<span>{{coupon.topicContent}}</span>
						{{else if coupon.topicClass == "OFF_PRICE"}}
							满{{coupon.fullPrice}}<p>减{{coupon.offPrice}}</p>
						{{else if coupon.topicClass == "PERCENT_PRICE"}}
							<p>{{coupon.percentPrice}}折</p>
						{{else}}
							{{if coupon.price=="免费"}}
							<p>免费 </p>
							{{else}}
							<span>{{coupon.price}}现金券</span>
							{{/if}}
						{{/if}}
					</p>
				</div>
			</a>
			<div class="time">
				有效期：{{coupon.useDateSpan}}
				<a href="${buyer_weixin_domain}/view/weixin/presend?couponId={{coupon.couponId}}&topicId={{coupon.topicId}}&couponName={{coupon.couponName}}&couponDesc=平安银行橙e券&couponImage={{coupon.wxListImage}}">
					送朋友
				</a>
			</div>
		</div>
		{{/each}}
	</script>

	<script type="text/javascript">

		var page = 1;
		var loadmore = false;

		$(function(){
			// 窗口滚动事件
	       	$(window).scroll(function(){
	       		if(($(document).height()-$(this).scrollTop()-$(this).height()) < 50) {
	       			if(loadmore){
						queryCoupons(page);
	       			}else
	       			{
	       				var thereisnomore = $(".hongbaoList").find(".thereisnomore").size();
	       				if(thereisnomore == 0 ){
	       					$(".hongbaoList").append("<div class='thereisnomore'><p>到底了，没有别的了！</p></div>");
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
	       	queryCoupons(page);
		});

		function queryCoupons(curPage) {
			$(".fakeloader").show();
			loadmore = false;
			var loadDataUrl = "${buyer_weixin_domain}/view/coupon/sendable?page="+curPage+"&ts="+new Date();
		  	$.get(loadDataUrl, function(result){
				var data = $.parseJSON(result);
			   	if(data.coupons && data.coupons.length > 0) {
					var listhtml = template('coupontemplate', data);
				   	$(".notFound").before(listhtml);
				   	$('.notFound').hide();
				   	page++;
			   	} else {
			   		if(curPage == 1) {
			   			$(".notFound").show();
			   		}
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
					title: '平安银行橙e券', // 分享标题
					link: '${buyer_weixin_domain}/view/weixin/sendable', // 分享链接
					imgUrl: '${buyer_weixin_domain}/resources/img/circle_logo.png', // 分享图标
				    success: function () {
				    	var url = "${buyer_weixin_domain}/view/weixin/sendable";
			        	window.location.replace(url);
				    },
				    cancel: function () { 
				        
				    }
				});


				wx.onMenuShareAppMessage({
				    title: '平安银行橙e券', // 分享标题
				    desc: '发红包', // 分享描述
				    link: '${buyer_weixin_domain}/view/weixin/sendable', // 分享链接
				    imgUrl: '${buyer_weixin_domain}/resources/img/circle_logo.png', // 分享图标
				    type: 'link', // 分享类型,music、video或link，不填默认为link
				    dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
				    success: function () { 
				    	var url = "${buyer_weixin_domain}/view/weixin/sendable";
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