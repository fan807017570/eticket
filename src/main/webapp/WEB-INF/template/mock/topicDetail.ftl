<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title>活动详情</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-mobile-web-app-status-bar-style" content="black">
        <link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/style.css" />
	</head>
	<body>
		<div class="pop">
			  <span id="tip_span"></span>
			  <a href="#" id="toMyCoupons" style="display: none;">去看看我领的券</a>
		</div>
		<div class="ticket-detail">
			<#escape x as x?html>
			<div class="publicTop">
				<a class="back">返回</a>券详情
			</div>
			<div class="topImg">
				<img src="${topic.wxDetailImage!''}" />
			</div>
			<div class="bgF6 content1">
				<div class="tag">${topic.price}</div>
				<div class="text text-orange">${topic.amount}</div>
				<input type="button" name="getNow" class="getNow" id="getNow" value="立即抢券" onclick="takeCoupon();" style="display:none;"/>
				<input type="button" id="disableBtn" class="btngray right"  value="无法领取" style="display:none;"/>
			</div>
			<div class="bgF6border content2">
				<p>剩余时间：<span class="tag">${topic.days}天</span></p>
				<p>已抢<span class="text-orange takennums"></span>张 剩余<span class="text-orange remainnums"></span>张</p>
			</div>
			</#escape>
			<div class="bgF6border content3">
				<#escape x as x?html>
				<h2>
					<span>${topic.couponName}</span>
					<span>商家：${topic.orgName}</span>
				</h2>
				<p>有效期：<span class="text-orange">${topic.startDate}－${topic.endDate}</span></p>
				</#escape>
				<p>使用须知：</p>
				 ${topic.description}
			</div>
		</div>
		
		<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
		
		<script>
		
			$(function(){
				$(".back").click(function(){
					window.history.go(-1);
					window.location.reload();
				});
				checkStatus();
				$("#getNow").bind(takeCoupon);
			});
		
		
			var token = "";
			var totalCount = ${topic.totalCount};
			var isvisitor = true;
			
			//检查当前券是否可抢
			function checkStatus(){
				  var tip = "";
				  $.get("${buyer_portal_domain}/view/topic/status?topicid=${topic.topicId}", function(result){
					   var data = $.parseJSON(result);
					   if(data.result =="SUCCESS"){
						   $(".takennums").text(data.takenTotals);
						   $(".remainnums").text(totalCount-data.takenTotals);
						   token = data.token;
						   isvisitor = data.isvisitor;
						   $("#getNow").show();
					   }else{
						   if(data.result =="EXCEED_INVENTORY"){
							   tip = "已抢光";
						   }else{
							   tip = "已下架";
						   }
						   $("#disableBtn").val(tip);
						   $("#disableBtn").show();
					   }
				  });
			 }
			
			//处理领券逻辑
			function takeCoupon(){
				console.log(isvisitor);
				$("#getNow").val("领取中...");
				$('#getNow').attr("disabled","disabled"); 
				$.post("${buyer_portal_domain}/view/topic/take",{topicid:'${topic.topicId}',token:token},function(result){
					 console.log(result);
					 var data = $.parseJSON(result);
					 console.log(data.status);
					 var tip = "";
					 if(data.status=="SUCCESS"){
						  tip = "领取成功";
					 }else if(data.status =="TOKEN_ERROR"){
						  tip = "请在微信中打开此页面进行抢券";
				     }else if(data.status =="EXCEED_INVENTORY"){
				    	  tip = "对不起，该券已抢光";
				     }else if(data.status =="EXCEED_LIMIT"){
				    	  tip = "对不起，你已超过领券上限";
				     }else{
					      tip = "对不起，该券已下架";
				    }
					$("#tip_span").text(tip);
					$(".pop").slideDown();
					//按钮状态的变更
					if(data.status=="SUCCESS"){
						//游客直接跳转到提示关注页
					  if(isvisitor){
						  window.location="${buyer_portal_domain}/visitorfollow";
					  }else{
						  $("#toMyCoupons").attr("href","${buyer_portal_domain}/view/weixin/mycoupon");
						  $("#toMyCoupons").show();
					  }
					  tip="已领取"
					}else{
					  tip="无法领取"
					}
					$("#disableBtn").val(tip);
				    $("#disableBtn").show();
				    $("#getNow").hide();
				});
			}
		</script>
	</body>
</html>
