<!DOCTYPE html>
<html>

<#include "userCenter-base.ftl">

<@htmlHead title="未使用/已使用/已过期的券">
</@htmlHead>

<@htmlBody>
<#escape x as x?html>
	<section class="navAndbanner">
		<!--导航部分 开始-->
		<div class="nav">
			<ul class="width1000">
				<li>
					<a href="${buyer_portal_domain}/">橙e券首页</a> 
				</li>
				<li class="active">
					<a href="${buyer_portal_domain}/view/web/usercenter/ticket">我领的券</a>
				</li>
				<li>
					<a href="${buyer_portal_domain}/view/web/usercenter/hongbao">我的红包</a>
				</li>
				<li>
					<a href="${buyer_portal_domain}/view/web/usercenter/notice">我的通知</a>
				</li> 
			</ul>
		</div>
		<!--导航部分 结束-->
	</section>
	
	<section class="userCenter width1000">
		<div class="left navleft">
			<header>我的橙e券</header>
			<ul>
				<li class="active">
					<a href="${buyer_portal_domain}/view/web/usercenter/ticket">我领的券（<span class="v_coupon">0</span>）</a>
				</li>
				<li>
					<a href="${buyer_portal_domain}/view/web/usercenter/hongbao">我的红包（<span class="v_hongbao">0</span>）</a>
				</li>
				<li>
					<a href="${buyer_portal_domain}/view/web/usercenter/notice">我的通知（<span class="v_notice">0</span>）</a>
				</li>
			</ul>
		</div>
		<div class="right">
			<div class="tab">
				<a id="caidan1" onClick="showDiv(1)" href="javascript:;" class="active">未使用（<span class="v_unused">0</span>）</a>
				<a id="caidan2" onClick="showDiv(2)" href="javascript:;">已使用（<span class="v_used">0</span>）</a>
				<a id="caidan3" onClick="showDiv(3)" href="javascript:;">已过期（<span class="v_expired">0</span>）</a>
				<a id="caidan4" onClick="showDiv(4)" href="javascript:;">退款单（<span class="v_refund">0</span>）</a>
			</div>
			<div class="list notuse" id="kqh_neirong1">
				<ul id="unused-container">
				</ul>
				<input id="unused_page" type="hidden" value="1" /> 
			</div>
			
			<div class="list used" id="kqh_neirong2" style="display: none;">
				<ul id="used-container">
				</ul>
				<input id="used_page" type="hidden" value="1" /> 
			</div>
			
			<div class="list notuse" id="kqh_neirong3" style="display: none;">
				<ul id="expired_container">
				</ul>
				<input id="expired_page" type="hidden" value="1" /> 
			</div>
			
			<div class="list notuse" id="kqh_neirong4" style="display: none;">
				<ul id="refund_container">
				</ul>
				<input id="refund_page" type="hidden" value="1" /> 
			</div>

			<div id="un_navigator" style="text-align:right;">
				<a id="un_prev_page" style="display:none;" href="#">上一页</a>
				<a id="un_next_page" style="display:none;" href="#">下一页</a>
			</div>

			<div id="u_navigator" style="text-align:right; display:none;">
				<a id="u_prev_page" style="display:none;" href="#">上一页</a>
				<a id="u_next_page" style="display:none;" href="#">下一页</a>
			</div>

			<div id="e_navigator" style="text-align:right; display:none;">
				<a id="e_prev_page" style="display:none;" href="#">上一页</a>
				<a id="e_next_page" style="display:none;" href="#">下一页</a>
			</div>
			
			<div id="r_navigator" style="text-align:right; display:none;">
				<a id="r_prev_page" style="display:none;" href="#">上一页</a>
				<a id="r_next_page" style="display:none;" href="#">下一页</a>
			</div>
		</div>
	</section>

	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-1.9.1.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/template.js" ></script>

	<script type="text/javascript">

		jQuery(document).ready(function($) {

			$('#un_next_page').click(function(event) {
				var page = $('#unused_page').val();
				page++;
				queryUnused(page);
			});

			$('#u_next_page').click(function(event) {
				var page = $('#used_page').val();
				page++;
				queryUsed(page);
			});

			$('#e_next_page').click(function(event) {
				var page = $('#expired_page').val();
				page++;
				queryExpired(page);
			});
			
			$('#r_next_page').click(function(event) {
				var page = $('#refund_page').val();
				page++;
				queryRefund(page);
			});

			$('#un_prev_page').click(function(event) {
				var page = $('#unused_page').val();
				page--;
				if(page<=0) page=1;
				queryUnused(page);
			});

			$('#u_prev_page').click(function(event) {
				var page = $('#used_page').val();
				page--;
				if(page<=0) page=1;
				queryUsed(page);
			});

			$('#e_prev_page').click(function(event) {
				var page = $('#expired_page').val();
				page--;
				if(page<=0) page=1;
				queryExpired(page);
			});
			
			$('#r_prev_page').click(function(event) {
				var page = $('#refund_page').val();
				page--;
				if(page<=0) page=1;
				queryRefund(page);
			});

			queryStatistics();
			queryUnused(1);
			queryUsed(1);
			queryExpired(1);
			queryRefund(1);
			
		});

		function showDiv(n){
			for(i=1; i<=4; i++){
				var caidan=document.getElementById('caidan'+i);
				var kqh_neirong=document.getElementById('kqh_neirong'+i);
				caidan.className=i==n?"active":"";
				kqh_neirong.style.display=i==n?"block":"none";
			}

			if(n==1) {
				$('#un_navigator').show();
				$('#u_navigator').hide();
				$('#e_navigator').hide();
				$('#r_navigator').hide();
			}
			if(n==2) {
				$('#un_navigator').hide();
				$('#u_navigator').show();
				$('#e_navigator').hide();
				$('#r_navigator').hide();
			}
			if(n==3) {
				$('#un_navigator').hide();
				$('#u_navigator').hide();
				$('#e_navigator').show();
				$('#r_navigator').hide();
			}
			if(n==4) {
				$('#un_navigator').hide();
				$('#u_navigator').hide();
				$('#e_navigator').hide();
				$('#r_navigator').show();
			}
		}

		function queryUnused(page) {
			var loadDataUrl = "${buyer_portal_domain}/view/user/unused?page=" + page+"&ts="+new Date();
		  	$.get(loadDataUrl, function(result){
				var data = $.parseJSON(result);
			   	if(data.unuseds && data.unuseds.length >= 0){
					var listhtml = template('unusedtemplate', data);
				   	$("#unused-container").empty();
				   	$("#unused-container").append(listhtml);
				   	$('#unused_page').val(page);
			   	}
			   	if(data.hasmore) {
			   		$('#un_next_page').show();
			   	}else{
			   		$('#un_next_page').hide();
			   	}
		  	});

		  	if(page>1) {
		  		$('#un_prev_page').show();
		  	}else{
		  		$('#un_prev_page').hide();
		  	}
	  	};

		function queryUsed(page) {
			var loadDataUrl = "${buyer_portal_domain}/view/user/used?page=" + page+"&ts="+new Date();
		  	$.get(loadDataUrl, function(result){
				var data = $.parseJSON(result);
			   	if(data.useds && data.useds.length >= 0){
					var listhtml = template('usedtemplate', data);
				   	$("#used-container").empty();
				   	$("#used-container").append(listhtml);
				   	$('#used_page').val(page);
			   	}
			   	if(data.hasmore) {
			   		$('#u_next_page').show();
			   	}else{
			   		$('#u_next_page').hide();
			   	}
			   	toEvaluate("f-toEvaluate");
				getStars2();
		  	});

		  	if(page>1) {
		  		$('#u_prev_page').show();
		  	}else{
		  		$('#u_prev_page').hide();
		  	}
	  	};

	  	function queryExpired(page) {
			var loadDataUrl = "${buyer_portal_domain}/view/user/expired?page=" + page+"&ts="+new Date();
		  	$.get(loadDataUrl, function(result){
				var data = $.parseJSON(result);
			   	if(data.expireds && data.expireds.length >= 0){
					var listhtml = template('expiredtemplate', data);
				   	$("#expired_container").empty();
				   	$("#expired_container").append(listhtml);
				   	$('#expired_page').val(page);
			   	}
			   	if(data.hasmore) {
			   		$('#e_next_page').show();
			   	}else{
			   		$('#e_next_page').hide();
			   	}
		  	});

		  	if(page>1) {
		  		$('#e_prev_page').show();
		  	}else{
		  		$('#e_prev_page').hide();
		  	}
	  	};
	  	
	  	function queryRefund(page) {
			var loadDataUrl = "${buyer_portal_domain}/view/user/refund?page=" + page+"&ts="+new Date();
		  	$.get(loadDataUrl, function(result){
				var data = $.parseJSON(result);
			   	if(data.coupons && data.coupons.length >= 0){
					var listhtml = template('refundtemplate', data);
				   	$("#refund_container").empty();
				   	$("#refund_container").append(listhtml);
				   	$('#refund_page').val(page);
			   	}
			   	if(data.hasmore) {
			   		$('#r_next_page').show();
			   	}else{
			   		$('#r_next_page').hide();
			   	}
		  	});

		  	if(page>1) {
		  		$('#r_prev_page').show();
		  	}else{
		  		$('#r_prev_page').hide();
		  	}
	  	};

	  	function queryStatistics() {
			var loadDataUrl = "${buyer_portal_domain}/view/user/statistics?ts="+new Date();
		  	$.get(loadDataUrl, function(result){
				var data = $.parseJSON(result);
			   	if(data.statistics) { 

			   		$('.v_coupon').html(data.statistics.unused+data.statistics.used+data.statistics.expired+data.statistics.refund);
			   		$('.v_hongbao').html(data.statistics.received+data.statistics.sended);
			   		$('.v_notice').html(data.statistics.notice);

			   		$('.v_unused').html(data.statistics.unused);
			   		$('.v_used').html(data.statistics.used);
			   		$('.v_expired').html(data.statistics.expired);
			   		$('.v_refund').html(data.statistics.refund);
			   	}
		  	});
	  	};

		//文字悬浮hover事件 评价框隐显
		function toEvaluate(btn){
			var timer;		 
			$("."+btn).hover(function(){
				var that = $(this);
				clearTimeout(timer);
			    timer = setTimeout(function () {
			        that.children(".f-toEvaluate_box").slideDown();
			    }, 200);
				getImgObj(that.children(".f-toEvaluate_box").children(".starsWill"));
			},function(){
				clearTimeout(timer);
			    timer = setTimeout(function () {
			    	$("."+btn).children(".f-toEvaluate_box").slideUp();
			    }, 200);
									
			})	 
		}
		
		function getImgObj(obj){
			var index = $(obj).attr("data");
			$(obj).find("img:eq("+index+")").click();
		}
		
		function getImgSrc(){
			var src = $(".starsWill").find("img")[0].src;
			return src.substring(0, src.lastIndexOf("/")+1);
		}
		
		function setImgSrc(imgObj, imgSrc, flag){
			var getUrl = getImgSrc();
			$(imgObj).parent(".starsWill").find("img").attr("src", getUrl + "star_gray.png");
			if(imgObj && !flag){
				$(imgObj).attr("src",getUrl+"star.png").prevAll("img").attr("src", getUrl+imgSrc);
			}
		}
		
		function getStars2(){
			var curr = null;
			$(".starsWill img").hover(function(){
				setImgSrc(this, "star.png");
			}, function(){
				if(curr){
					setImgSrc(curr, "star.png");
				}else{
					setImgSrc(this, "star_gray.png", true);
				}
			});
			
			$(".starsWill img").click(function(){
				curr = this; 
				$(this).parent(".starsWill").attr("data", $(this).index());
			})
		}
		
		
		function getStars(){
			var starsArray = new Array();
			var getUrl;
			var current;
			$(".starsWill img").hover(function(){
				current = $(this).index();
				for(var i = 0;i < 5;i++){
					starsArray[i] = $(this).parent().children("img")[i].getAttribute("src");
				} 
				getUrl = $(this).attr("src");
				getUrl = getUrl.substring(0, getUrl.lastIndexOf("/")); 
				for(var i = 0;i < 5;i++){
					if(i<current){
						starsArray[i] = $(this).parent().children("img")[i].getAttribute("src");
					}else{
						starsArray[i] = getUrl+"/star_gray.png";
					}
				}
				$(this).attr("src",getUrl+"/star.png").prevAll("img").attr("src",getUrl+"/star.png");
			},function(){
				for(var i = 0;i < 5;i++){
					$(this).parent().children("img")[i].setAttribute("src",starsArray[i]); 
				}
			});
			
			var getStarNum;
			$(".starsWill img").click(function(){
				getStarNum = $(this).index()+1;
				for(var i = 0;i < 5;i++){
					if(i<getStarNum){
						starsArray[i] = $(this).parent().children("img")[i].getAttribute("src");
					}else{
						starsArray[i] = getUrl+"/star_gray.png";
					}
					
				} 
			})
		}
		
		function sendEvaluate(couponId){
			var point = $("#stars_"+couponId).attr("data");
			point = parseInt(point) + 1;
			$.post("${buyer_portal_domain}/view/user/doevaluate",{couponId:couponId,point:point}, function(result){
				var data = $.parseJSON(result);
				var page = $('#used_page').val();
				queryUsed(page);
		  	});
		}
	</script>

	<script id="unusedtemplate" type="text/html">
		<li>
			<div>优惠券名称</div>
			<div>抢券时间</div>
			<div>总价</div>
			<div>优惠券状态</div> 
		</li>
		{{each unuseds as topic}}
		<li>
			<div class="info">
				<div class="img">
					<img src="{{topic.pcListImage}}" />
				</div>
				<div class="description">
					<a href="${buyer_portal_domain}/view/cpnweb/cpnDetail?topicId={{topic.topicId}}" title="{{topic.couponName}}">{{topic.couponName}}</a>
					<span>有效期至：{{topic.endDate}}</span>
				</div> 
			</div>
			<div class="doubleline">{{topic.getDate}}</div>
			<div class="singleline">{{if topic.price != "免费"}}￥{{/if}}{{topic.price}}</div>
			<div class="doubleline">未使用<a href="${buyer_portal_domain}/view/web/detail?topicId={{topic.topicId}}&couponId={{topic.couponId}}">优惠券详情</a>
			{{if topic.price != "免费"}}
			<a href="${buyer_portal_domain}/view/web/refund_apply.htm?couponName={{topic.couponName}}&couponId={{topic.couponId}}&couponPrice={{topic.price}}">申请退款</a>
			{{/if}}
			</div> 
		</li>
		{{/each}}
	</script>

	<script id="usedtemplate" type="text/html">
		<li>
			<div>优惠券名称</div>
			<div>抢券时间</div>
			<div>总价</div>
			<div>优惠券状态</div> 
		</li>
		{{each useds as topic}}
		<li>
			<div class="info">
				<div class="img">
					<img src="{{topic.pcListImage}}" />
				</div>
				<div class="description">
					<a href="${buyer_portal_domain}/view/cpnweb/cpnDetail?topicId={{topic.topicId}}" title="{{topic.couponName}}">{{topic.couponName}}</a>
					<span>有效期至：{{topic.endDate}}</span>
				</div>
			</div>
			<div class="doubleline">{{topic.getDate}}</div>
			<div class="singleline">{{if topic.price != "免费"}}￥{{/if}}{{topic.price}}</div>
			<div class="threeline">
				<p class="title">已使用</p>
				<p>使用时间：<span>{{topic.usedDate}}</span></p>
				{{if topic.marked}}
					<div class="starsbox">已评价：
						<div class="stars">
							{{if topic.couponScore == 5}}
								<div class="stars">
									<img src="${buyer_portal_static_resources_domain}/img/stars.png" style="left: -0%;"/> 
								</div>
							{{else if topic.couponScore == 4}}
								<img src="${buyer_portal_static_resources_domain}/img/stars.png" style="left: -20%;"/>
							{{else if topic.couponScore == 3}}
								<img src="${buyer_portal_static_resources_domain}/img/stars.png" style="left: -40%;"/>
							{{else if topic.couponScore == 2}}
								<img src="${buyer_portal_static_resources_domain}/img/stars.png" style="left: -60%;"/>
							{{else if topic.couponScore == 1}}
								<img src="${buyer_portal_static_resources_domain}/img/stars.png" style="left: -80%;"/>
							{{else}}
								<img src="${buyer_portal_static_resources_domain}/img/stars.png" style="left: -100%;"/>
							{{/if}}
						</div>
					</div>
				{{else}}
					<div class="f-toEvaluate">
						<span>发表评论</span>
						<div class="f-toEvaluate_box" style="display: none;">
							<span class="red">*</span>评分:
							<div class="starsWill" id="stars_{{topic.couponId}}">
								<img src="${buyer_portal_static_resources_domain}/img/pc/star_gray.png" />
								<img src="${buyer_portal_static_resources_domain}/img/pc/star_gray.png" />
								<img src="${buyer_portal_static_resources_domain}/img/pc/star_gray.png" />
								<img src="${buyer_portal_static_resources_domain}/img/pc/star_gray.png" />
								<img src="${buyer_portal_static_resources_domain}/img/pc/star_gray.png" />
							</div>
							<div class="f-tips">
								<p>您的评分是偶们前进的动力</p>
							</div>
							<input type="button" onclick="sendEvaluate({{topic.couponId}});" value="提交" class="f-submit">
						</div>
					</div>
				{{/if}}
			</div> 
		</li>
		{{/each}}
	</script>

	<script id="expiredtemplate" type="text/html">
		<li>
			<div>优惠券名称</div>
			<div>抢券时间</div>
			<div>总价</div>
			<div>优惠券状态</div> 
		</li>
		{{each expireds as topic}}
		<li>
			<div class="info">
				<div class="img">
					<img src="{{topic.pcListImage}}" />
				</div>
				<div class="description">
					<a href="${buyer_portal_domain}/view/cpnweb/cpnDetail?topicId={{topic.topicId}}" title="{{topic.couponName}}">{{topic.couponName}}</a>
					<span>有效期至：{{topic.endDate}}</span>
				</div> 
			</div>
			<div class="doubleline">{{topic.getDate}}</div>
			<div class="singleline">{{if topic.price != "免费"}}￥{{/if}}{{topic.price}}</div>
			<div class="singleline">已过期</div> 
		</li>
		{{/each}}
	</script>
	
	<script id="refundtemplate" type="text/html">
		<li>
			<div>优惠券名称</div>
			<div>抢券时间</div>
			<div>总价</div>
			<div>优惠券状态</div> 
		</li>
		{{each coupons as topic}}
		<li>
			<div class="info">
				<div class="img">
					<img src="{{topic.pcListImage}}" />
				</div>
				<div class="description">
					<a href="${buyer_portal_domain}/view/cpnweb/cpnDetail?topicId={{topic.topicId}}" title="{{topic.couponName}}">{{topic.couponName}}</a>
					<span>有效期至：{{topic.endDate}}</span>
				</div> 
			</div>
			<div class="doubleline">{{topic.getDate}}</div>
			<div class="singleline">{{if topic.price != "免费"}}￥{{/if}}{{topic.price}}</div>
			<div class="doubleline">
				{{if topic.status == 7}}
					退款中
					<a href="${buyer_portal_domain}/view/web/refund_detail.htm?couponId={{topic.couponId}}&couponName={{topic.couponName}}">退款详情</a>
				{{else if topic.status == 8}}
					已退款
					<a href="${buyer_portal_domain}/view/web/refund_detail.htm?couponId={{topic.couponId}}&couponName={{topic.couponName}}">退款详情</a>
				{{else}}
					退款取消
				{{/if}}
			</div> 
		</li>
		{{/each}}
	</script>
</#escape>
</@htmlBody>

</html>
