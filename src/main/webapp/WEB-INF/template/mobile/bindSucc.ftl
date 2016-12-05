<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title>橙e绑定</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-mobile-web-app-status-bar-style" content="black">
        <link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/style-vesion1.0.css" />
        <script src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" type="text/javascript"></script>
        <script type="text/javascript" src="${buyer_portal_static_resources_domain}/js/init.js" ></script>
	</head>
	<body>
	<#escape x as x?html>
		<div class="attendSucPage">
			<div class="top">
				<a href="#" class="img">
					<img src="${wxImgUrl}">
				</a>
				<img src="${buyer_portal_static_resources_domain}/img/pingan_logo.png" />
			</div>
			<div class="introduce">
				<div class="tips">
					<#if firstBind?? >
						<div class="header">
							<span class="icon icon-tips"></span>
							小橙提醒您
						</div>
						<p>您的橙e券账户（<span>${ceName!}</span>）已经绑定橙e网了，不用再次绑定了哦！</p>
					<#else>
						<div class="header">
							<span class="icon icon-tips"></span>
							恭喜您，成功绑定橙e网帐户（<span>${ceName!}</span>）！
						</div>
					</#if>
				</div>
				<div class="tips">
					<div class="header"> 
						绑定橙e网，您可以尊享以下权利
					</div>
					
					<p>1、获得平安员工可享受的更多更低优惠折扣资格</p>
					<p>2、获得优先购买平安银行限额发行的超值理财产品资格。</p>
				</div>
			</div>
			<div class="linkbox">
				<a href="${buyer_weixin_domain}/view/weixin/index" class="link link-theme">去看看优惠<span class="icon icon-arrow-right-3"></span></a>
			</div>
			
			
		</div>	 
		</#escape>
	</body>
	
</html>
