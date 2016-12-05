<!DOCTYPE html>
<html style="height: 100%;">
<head>
<meta charset="utf-8" />
<title>把酒言欢</title>
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
<link rel="stylesheet" href="${buyer_portal_static_resources_domain}/lottery/css/base.css">
<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lottery/js/jquery1.42.min.js"></script>

</head>
<body>
	<div class="bgBox01">
		<div class="txtMarquee-top1">
			<div class="bd"></div>
		</div>
	</div>
</body>
<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lottery/js/jquery.SuperSlide.2.1.1.js"></script>
<script type="text/javascript">
	var timeInfo = 20;
	function loadLotteryData(){
		$.getJSON("${buyer_weixin_domain}/lottery/getLotteryList",function(result){
			var htmlStr="";
			if(result && result.data.length > 0){
				for(var i =0;i<result.data.length;i++){
					var object = result.data[i];
					var name = object.userWxName == null ? "匿名用户" : object.userWxName;
					if(name.length>6){
						name = name.substring(0,6);
					}
					var topicName = object.cpnTopicName;
					if(topicName.length > 10){
						topicName = topicName.substring(0,10)+'..';
					}
					htmlStr += '<li>恭喜用户<span style="color:#bd0b08;">'+name+'</span>成功抢购'+topicName+'</li>';
				}
				$(".bd").html('<ul class="infoList">'+htmlStr+'</ul>');
			}
			jQuery(".txtMarquee-top1").slide({mainCell:".bd ul",autoPlay:true,effect:"topMarquee",vis:8,interTime:timeInfo});
		});
	}
	
	$(function(){
		loadLotteryData();
	});
	
	setInterval(loadLotteryData, 30000);

</script>
</html>