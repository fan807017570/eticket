<!DOCTYPE html>
<html>

<#include "userCenter-base.ftl">

<@htmlHead title="发出/收到的红包">
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
				<li>
					<a href="${buyer_portal_domain}/view/web/usercenter/ticket">我领的券</a>
				</li>
				<li class="active">
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
				<li>
					<a href="${buyer_portal_domain}/view/web/usercenter/ticket">我领的券（<span class="v_coupon">0</span>）</a>
				</li>
				<li class="active">
					<a href="${buyer_portal_domain}/view/web/usercenter/hongbao">我的红包（<span class="v_hongbao">0</span>）</a>
				</li>
				<li>
					<a href="${buyer_portal_domain}/view/web/usercenter/notice">我的通知（<span class="v_notice">0</span>）</a>
				</li>
			</ul>
		</div>
		<div class="right">
			<div class="tab">
				<a href="javascript:;" id="caidan1" onClick="showDiv(1)" class="active">收到的红包（<span class="v_received">0</span>）</a>
				<a href="javascript:;" id="caidan2" onClick="showDiv(2)">发出的红包（<span class="v_sended">0</span>）</a>
			</div>
			<div class="list redEnvelopes" style="display:none;" id="kqh_neirong2">
				<ul id="sended-cantainer">
				</ul>
				<input id="sended_page" type="hidden" value="1" /> 
			</div>
			
			<div class="list redEnvelopes" id="kqh_neirong1">
				<ul id="received_container">
				</ul>
				<input id="received_page" type="hidden" value="1" /> 
			</div>

			<div id="r_navigator" style="text-align:right;">
				<a id="r_prev_page" style="display:none;" href="#">上一页</a>
				<a id="r_next_page" style="display:none;" href="#">下一页</a>
			</div>

			<div id="s_navigator" style="text-align:right; display:none;">
				<a id="s_prev_page" style="display:none;" href="#">上一页</a>
				<a id="s_next_page" style="display:none;" href="#">下一页</a>
			</div>
		</div>
	</section>

	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/template.js" ></script>

	<script type="text/javascript">

		jQuery(document).ready(function($) {

			$('#r_next_page').click(function(event) {
				var page = $('#received_page').val();
				page++;
				queryReceivedDatas(page);
			});

			$('#s_next_page').click(function(event) {
				var page = $('#sended_page').val();
				page++;
				querySendedDatas(page);
			});

			$('#r_prev_page').click(function(event) {
				var page = $('#received_page').val();
				page--;
				if(page<=0) page=1;
				queryReceivedDatas(page);
			});

			$('#s_prev_page').click(function(event) {
				var page = $('#sended_page').val();
				page--;
				if(page<=0) page=1;
				querySendedDatas(page);
			});

			queryStatistics();
			queryReceivedDatas(1);
			querySendedDatas(1);
		});

		function showDiv(n){
			for(i=1; i<=2; i++){
				var caidan=document.getElementById('caidan'+i);
				var kqh_neirong=document.getElementById('kqh_neirong'+i);
				caidan.className=i==n?"active":"";
				kqh_neirong.style.display=i==n?"block":"none";
			}
			if(n==1) {
				$('#r_navigator').show();
				$('#s_navigator').hide();
			}
			if(n==2) {
				$('#r_navigator').hide();
				$('#s_navigator').show();
			}
		}

		function queryReceivedDatas(page) {
			var loadDataUrl = "${buyer_portal_domain}/view/user/received?page=" + page+"&ts="+new Date();
		  	$.get(loadDataUrl, function(result){
				var data = $.parseJSON(result);
			   	if(data.receiveds && data.receiveds.length >= 0){
					var listhtml = template('received_template', data);
				   	$("#received_container").empty();
				   	$("#received_container").append(listhtml);
				   	$('#received_page').val(page);
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

	  	function querySendedDatas(page) {
			var loadDataUrl = "${buyer_portal_domain}/view/user/sended?page=" + page+"&ts="+new Date();
		  	$.get(loadDataUrl, function(result){
				var data = $.parseJSON(result);
			   	if(data.sendeds && data.sendeds.length >= 0){
					var listhtml = template('sended_template', data);
				   	$("#sended-cantainer").empty();
				   	$("#sended-cantainer").append(listhtml);
				   	$('#sended_page').val(page);
			   	}
			   	if(data.hasmore) {
			   		$('#s_next_page').show();
			   	}else {
			   		$('#s_next_page').hide();
			   	}
		  	});

		  	if(page>1) {
		  		$('#s_prev_page').show();
		  	}else{
		  		$('#s_prev_page').hide();
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

			   		$('.v_sended').html(data.statistics.sended);
			   		$('.v_received').html(data.statistics.received);
			   	}
		  	});
	  	};

	</script>

	<script id="received_template" type="text/html">
		<li>
			<div>红包信息</div>
			<div>来自于</div>
			<div>收到时间</div>
			<div>操作</div> 
		</li>
		{{each receiveds as topic}}
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
			<div class="singleline">{{topic.sender}}</div>
			<div class="doubleline">{{topic.receivedDate}}</div>
			<div class="singleline"><a href="${buyer_portal_domain}/view/web/detail?topicId={{topic.topicId}}&couponId={{topic.couponId}}" class="see">查看</a></div> 
		</li>
		{{/each}}
	</script>

	<script id="sended_template" type="text/html">
		<li>
			<div>红包信息</div>
			<div>分享给</div>
			<div>发出时间</div>
			<div>操作</div> 
		</li>
		{{each sendeds as topic}}
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
			{{if topic.receiver}}
				<div class="singleline">{{topic.receiver}}</div>
			{{else}}
				<div class="singleline"></div>
			{{/if}}
			<div class="doubleline">{{topic.sharedDate}}</div>
			<div class="singleline"><a href="${buyer_portal_domain}/view/web/detail?topicId={{topic.topicId}}&couponId={{topic.couponId}}" class="see">查看</a></div> 
		</li>
		{{/each}}
	</script>
	</#escape>
</@htmlBody>

</html>