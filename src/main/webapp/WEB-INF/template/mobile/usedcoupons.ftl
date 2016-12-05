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
				<li><a href="#" class="active">已使用</a></li>
				<li><a href="${buyer_weixin_domain}/view/weixin/expiredcoupon">已过期</a></li>
				<li><a href="${buyer_weixin_domain}/view/weixin/refundcoupon">退款单</a></li>
			</ul>
		</header>
		<div class="notFound">
			<img src="${buyer_portal_static_resources_domain}/img/pic_crying2.png">
			<p>您还没有使用任何优惠券!</p>
		</div>
		<div class="coupon-list-cantainer">
		</div>
		<a class="toTop" href="#top"></a>
	</div>

	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/template.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>
	<script id="listtemplate" type="text/html">
		{{each coupons as coupon}}
			<div class="item">
				<a href="javascript:void();" class="img-text" onClick="javascript:window.location='${buyer_weixin_domain}/view/weixin/detail?topicid={{coupon.topicId}}&couponid={{coupon.couponId}}'">
					<div class="img">
						<img src="{{coupon.wxListImage}}" />
					</div>
					<div class="text">
						<p class="title">{{coupon.couponName}}</p>
						<p class="price">券码：{{coupon.couponSN}}</p>
						{{if coupon.topicClass == "USER_DEFINE"}}
							<p class="zhe">{{coupon.topicContent}}</p>
						{{else if coupon.topicClass == "OFF_PRICE"}}
							<p class="zhe">满{{coupon.fullPrice}}减{{coupon.offPrice}}</p>
						{{else if coupon.topicClass == "PERCENT_PRICE"}}
							<p class="zhe">{{coupon.percentPrice}}折</p>
						{{else}}
							{{if coupon.price=="免费"}}
							<p class="price">免费</p>
							{{else}}
							<p class="price">￥{{coupon.price}}</p>
							<p class="oldPrice">原价：￥{{coupon.amount}}</p>
							{{/if}}
						{{/if}}
					</div>
				</a>
				<div class="bottom">
					<div class="left">使用时间：{{coupon.usedDate}}</div>
					<div class="right">
						{{if coupon.couponUseType=='1'}}
							待发货
						{{else if coupon.couponUseType=='2'}}
							<a class="btn btn-theme" onclick="confirmRecived('{{coupon.couponId}}');">确认收货</a>
						{{else if coupon.couponUseType=='3'}}
							{{if coupon.marked}}
									<div class="evaluate" >
										{{if coupon.couponEvaluation=='80' }}
                                        <span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										{{else if coupon.couponEvaluation=='60' }}
                                        <span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										{{else if coupon.couponEvaluation=='40' }}
                                        <span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										{{else if coupon.couponEvaluation=='20' }}
                                        <span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star"></span>
										{{else if coupon.couponEvaluation=='100' }}
                                        <span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										{{else }}
										<span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star" style="color: #ffce11"></span>
										{{/if}}
									</div>
								{{else}}
									<div class="evaluate">
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
									</div>
								{{/if}}
								{{if coupon.marked}}
									<span>已评价</span>
								{{else}}
								<a onclick="window.location='${buyer_weixin_domain}/view/weixin/evaluate?couponid={{coupon.couponId}}'">待评价</a>
								{{/if}}	
						{{else}}
								{{if coupon.marked}}
									<div class="evaluate" >
										{{if coupon.couponEvaluation=='80' }}
                                        <span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										{{else if coupon.couponEvaluation=='60' }}
                                        <span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										{{else if coupon.couponEvaluation=='40' }}
                                        <span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										{{else if coupon.couponEvaluation=='20' }}
                                        <span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star"></span>
										{{else if coupon.couponEvaluation=='100' }}
                                        <span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										{{else }}
										<span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star" style="color: #ffce11"></span>
										<span class="fa fa-star" style="color: #ffce11"></span>
										{{/if}}
									</div>
								{{else}}
									<div class="evaluate">
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
										<span class="fa fa-star"></span>
									</div>
								{{/if}}
								{{if coupon.marked}}
									<span>已评价</span>
								{{else}}
								<a onclick="window.location='${buyer_weixin_domain}/view/weixin/evaluate?couponid={{coupon.couponId}}'">待评价</a>
								{{/if}}
						{{/if}}
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
				 $.get("${buyer_weixin_domain}/view/member/used?page="+page+"&ts="+new Date(),
				   function(result){
					   var data = $.parseJSON(result);
					   if(data.coupons && data.coupons.length > 0){
						   	var listhtml = template('listtemplate',data);
						  	$(".coupon-list-cantainer").append(listhtml);
						   	$(".coupon-list-cantainer").show();
					   }else{
						   	if(page==1) {
						   		$(".coupon-list-cantainer").hide();
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
			function confirmRecived(couponid){
				var url = "${buyer_weixin_domain}/view/weixin/mycoupon";
				if(confirm("确认收货？")){
				$.post("${buyer_weixin_domain}/view/member/confirmOrderRecive?couponid="+couponid,
					function(result){
						var data = $.parseJSON(result);
					   	if(data=="0"){
							alert("操作失败！");
					   	}else{
							alert("操作成功！");
					   	}
						window.location.replace(url);
					});
				}
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
						link: '${buyer_weixin_domain}/view/weixin/usedcoupon', // 分享链接
						imgUrl: '${buyer_weixin_domain}/resources/img/circle_logo.png', // 分享图标
					    success: function () {
					    	var url = "${buyer_weixin_domain}/view/weixin/usedcoupon";
				        	window.location.replace(url);
					    },
					    cancel: function () { 
					        
					    }
					});


					wx.onMenuShareAppMessage({
					    title: '平安银行橙e券', // 分享标题
					    desc: '我领的券', // 分享描述
					    link: '${buyer_weixin_domain}/view/weixin/usedcoupon', // 分享链接
					    imgUrl: '${buyer_weixin_domain}/resources/img/circle_logo.png', // 分享图标
					    type: 'link', // 分享类型,music、video或link，不填默认为link
					    dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
					    success: function () { 
					    	var url = "${buyer_weixin_domain}/view/weixin/usedcoupon";
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
