<!DOCTYPE html>
<html style="font-size: 36px;">

<#include "base.ftl">

<@htmlHead title="我的红包">
</@htmlHead>

<@htmlBody>
<#escape x as x?html>
	<div class="fakeloader" style="display: none;">
		<div class="spinner3">
			<div class="dot1"></div>
			<div class="dot2"></div>
		</div>
	</div>

	<div class="myTicket">
		<header class="public_header">
			<ul class="tabs half"> 
				<li><a href="#" class="active">收到的券</a></li>
				<li><a href="${buyer_weixin_domain}/view/weixin/mygift">发出的券</a></li>
			</ul>
		</header>
		<div style="display: none;" class="notFound">
			<img src="${buyer_portal_static_resources_domain}/img/pic_crying2.png">
			<p>您还没有收到任何优惠券</p>
		</div>
		<div class="coupon-list-cantainer">
		  	
		</div>
		<a class="toTop" href="#top"></a>
	</div>
	
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/template.js" ></script>
	
	<script id="coupontemplate" type="text/html">
	{{each shares as coupon}}
		<div class="item">
			{{if coupon.status == 2}}
				<a href="${buyer_weixin_domain}/view/weixin/detail?topicid={{coupon.topicId}}&couponid={{coupon.couponId}}" class="img-text">
					<div class="img">
						<img src="{{coupon.wxListImage}}">
					</div>
					<div class="text">
						<p class="title">{{coupon.couponName}}</p>
						{{if coupon.topicClass == "USER_DEFINE"}}
							<p class="price">{{coupon.topicContent}}</p>
						{{else if coupon.topicClass == "OFF_PRICE"}}
							<p class="price">满{{coupon.fullPrice}}<span>减{{coupon.offPrice}}</span></p>
						{{else if coupon.topicClass == "PERCENT_PRICE"}}
							<p class="price"><span>{{coupon.percentPrice}}折</span></p>
						{{else}}
							{{if coupon.price=="免费"}}
							<p class="price">免费</p>
							{{else}}
							<p class="price">{{coupon.price}}元现金券</p>
							{{/if}}
						{{/if}}
						<p class="price">
							券码：{{coupon.couponSN}}
						</p>
					</div>
				</a>
			{{else}}
				<a class="img-text">
					<div class="img">
						<img src="{{coupon.wxListImage}}">
					</div>
					<div class="text">
						<p class="title">{{coupon.couponName}}</p>
						{{if coupon.topicClass == "USER_DEFINE"}}
							<p class="price">{{coupon.topicContent}}</p>
						{{else if coupon.topicClass == "OFF_PRICE"}}
							<p class="price">满{{coupon.fullPrice}}<span>减{{coupon.offPrice}}</span></p>
						{{else if coupon.topicClass == "PERCENT_PRICE"}}
							<p class="price"><span>{{coupon.percentPrice}}折</span></p>
						{{else}}
							{{if coupon.price=="免费"}}
							<p class="price">免费</p>
							{{else}}
							<p class="price">{{coupon.price}}元现金券</p>
							{{/if}}
						{{/if}}
						<p class="price">
							券码：{{coupon.couponSN}}
						</p>
					</div>
				</a>
			{{/if}}
			<div class="bottom">
				{{coupon.sharedDate}} 收到 {{coupon.sender}} 赠送的橙e券
			</div>
		</div>
	{{/each}}
	</script>

	<script type="text/javascript">
		var page = 1;
		var loadmore = false;

		jQuery(document).ready(function($) {
			// 窗口滚动事件
	       	$(window).scroll(function(){
	       		if(($(document).height()-$(this).scrollTop()-$(this).height()) < 50 ) {
	       			if(loadmore){
	       				queryReceived(page);
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
			queryReceived(page);
		});

		function queryReceived(curPage) {
			$(".fakeloader").show();
			loadmore = false;
			var loadDataUrl = "${buyer_weixin_domain}/view/share/received?page="+curPage+"&ts="+new Date();
		  	$.get(loadDataUrl, function(result){
				var data = $.parseJSON(result);
			   	if(data.shares && data.shares.length > 0){
				   	var listhtml = template('coupontemplate', data);
				   	$('.coupon-list-cantainer').append(listhtml);
				   	$('.notFound').hide();
				   	page++;
			   	} else {
			   		if(curPage==1) {
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
						link: '${buyer_weixin_domain}/view/weixin/hongbao', // 分享链接
						imgUrl: '${buyer_weixin_domain}/resources/img/circle_logo.png', // 分享图标
					    success: function () {
					    	var url = "${buyer_weixin_domain}/view/weixin/hongbao";
				        	window.location.replace(url);
					    },
					    cancel: function () { 
					        
					    }
					});


					wx.onMenuShareAppMessage({
					    title: '平安银行橙e券', // 分享标题
					    desc: '我的红包', // 分享描述
					    link: '${buyer_weixin_domain}/view/weixin/hongbao', // 分享链接
					    imgUrl: '${buyer_weixin_domain}/resources/img/circle_logo.png', // 分享图标
					    type: 'link', // 分享类型,music、video或link，不填默认为link
					    dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
					    success: function () { 
					    	var url = "${buyer_weixin_domain}/view/weixin/hongbao";
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
