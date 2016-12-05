<!DOCTYPE html>
<html style="height: 100%;">
	<head>
		<meta charset="utf-8" />
		<title>橙e券关注</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-mobile-web-app-status-bar-style" content="black">
        <script src="${buyer_portal_static_resources_domain}/js/jquery-1.9.1.js"></script>
		<style>
			ol, ul ,li{
				list-style:none
			}
			#mq{
				height:50px;
				text-align:left;
			}
			#mq ul{ 
				width:100%;
			}
			#mq ul li{
				padding:5px;
				height:20px;
				overflow:hidden;
				text-align:left;
			}
			#mq ul li .vo2{ 
				line-height:20px;
				text-overflow:ellipsis;
				text-align:center;
			}
			.topicDiv{
				display: inline-block;
				position: relative;
				width: 100%;
				text-align: center;
			}
			.topicShow{
				position: absolute;
				top: 270px;
				right: 450px;
				font-size: 36px;
				font-family: 'Arial Negreta', 'Arial';
			}
			.zeroShopDiv{
				width: 100%;
				font-size: 48px;
				padding: 15px 0;
				text-align: center;
				display: inline-block;
				font-family: 'Arial Negreta', 'Arial';
			}
			.orangee{
				color: #FF6600;
			}
			.zero{
				color: #999999;
			}
			.lotteryDiv{
				width: 100%;
				text-align: center;
				display: inline-block;
			}
			.lotteryList{
				font-family: 'Arial Negreta', 'Arial';
				font-weight: 700;
				font-style: normal;
				font-size: 48px;
				color: #333333;
				text-align: left;
				line-height: normal;
			}
			.congratulate{
				font-size: 36px;
				color: #FF6600;
				font-family: 'Arial Negreta', 'Arial';
				font-weight: 700;
				font-style: normal;
				text-align: left;
				line-height: normal;
			}
			.congratulateDecr{
				font-family: 'Arial Normal', 'Arial';
				font-weight: 400;
				font-style: normal;
				font-size: 24px;
				color: #333333;
				text-align: left;
				line-height: normal;				
			}
			.useProcess,.congratulateDiv{
				padding-left: 15px;
			}
		</style>
	</head>
	<body>
		<div class="topicDiv">
			<img class="topicImg" src="${buyer_portal_static_resources_domain}/img/lottery-topic.png" width="100%" height="100%" />
			<span class="topicShow">活动专题展示</span>
		</div>
		<div class="zeroShopDiv">
			<span class="orangee">橙<B>e</B>券</span>
			<span class="zero"><B>0</B>元购</span>
		</div>
		<div class="lotteryDiv">
			<span class="lotteryList">中奖名单</span>
			<div class="mqs">
			<br/>
			<br/>
    		<div id="mq" onmouseover="iScrollAmount=0" style="overflow: hidden;  height:300px;" onmouseout="iScrollAmount=1"></div>
    		</div>
		</div>
		<br/>
		<br/>
		<div class="congratulateDiv">
			<span class="congratulate">恭喜</span>
			<span class="congratulateDecr">以上用户成功抢购“0元购”商品，抢购成功的用户请根据下面橙e券使用流程进行提货或赠送。</span>
		</div>
		<div class="useProcess">
			<h2>橙e券使用流程</h2>
			<span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">提</span><span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">货：</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">1、</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">在橙</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">e券平台</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">点击</span>
			<span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">“我的券”</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">频道</span>
			<span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">--&gt;</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">点击</span>
			<span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">&quot;券管理&quot;--&gt;</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">查看</span>
			<span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">“未使用”</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">列表并选取</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">已抢购的橙e券</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">，进入券详情页</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">。</span>
			<br/>
			<br/>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">、</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">在券详情页</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">点击</span>
			<span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">“</span>
			<span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">使用</span><span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">券”</span>
			<span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">--&gt;</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">点击</span>
			<span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">&quot;我要快递</span>
			<span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">&quot;--&gt;</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">填写</span>
			<span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">“地址和收货人信息</span>
			<span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">”</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">后点击</span>
			<span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">“</span>
			<span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">确认快递”</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">即可</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">。</span>
			<br/>
			<br/>
			<span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">赠送</span><span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">：</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">1、</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">在橙</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">e券平台</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">点击</span>
			<span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">“我的券”</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">频道</span>
			<span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">--&gt;</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">点击</span>
			<span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">&quot;送朋友</span>
			<span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">&quot;--&gt;</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">点击右上角</span>
			<span style="font-family: 'Arial Negreta', 'Arial'; font-weight: 700;">“...”分享给朋友</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">即可</span>
			<span style="font-family: 'Arial Normal', 'Arial'; font-weight: 400;">。</span>
		</div>
		<br/>
	</body>
	<script type="text/javascript">	
		var oMarquee = document.getElementById("mq"); //滚动对象 
		var iLineHeight = 50; //单行高度，像素 
		var iLineCount = 6; //实际行数 
		var iScrollAmount = 5; //每次滚动高度，像素 
		function run() {
			 oMarquee.scrollTop += iScrollAmount; 
			 if ( oMarquee.scrollTop == iLineCount * iLineHeight ) {
				 oMarquee.scrollTop = 0; 
			 }
			 if ( oMarquee.scrollTop % iLineHeight == 0 ) { 
				window.setTimeout( "run()", 500 ); 
			 } else { 
				window.setTimeout( "run()", 10 ); 
			 } 
		} 
		oMarquee.innerHTML += oMarquee.innerHTML; 
		window.setTimeout( "run()", 500 );
		
		$.getJSON("${buyer_weixin_domain}/lottery/getLotteryList",function(result){
			var htmlStr=$("#mq").html();
			if(result){
				for(var i =0;i<result.data.length;i++){
					var object = result.data[i];
					var name = object.userWxName == null ? '匿名用户' : object.userWxName;
					
					htmlStr += '<ul>';
					htmlStr += '<li>';
					htmlStr += '<div class="vo2"><nobr>恭喜“'+name+'”成功抢购“橙e券0元购”产品。</nobr></div>';
					htmlStr += '</li>';
					htmlStr += '</ul>';
				}
			}
			$("#mq").html(htmlStr);
		});
	</script>
</html>