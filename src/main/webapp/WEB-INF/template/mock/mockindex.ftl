<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title>券详情</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-mobile-web-app-status-bar-style" content="black">
        <link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/style.css" />
	</head>
	<body>
		<#escape x as x?html>
			<ul>
				<li><a href="${buyer_portal_domain}/view/weixin/index">首页抢券</a></li>
				<li><a href="${buyer_portal_domain}/view/weixin/mycoupon">我领的券</a></li>
				<li><a href="${buyer_portal_domain}/view/weixin/sendable">发红包</a></li>
				<li><a href="${buyer_portal_domain}/view/weixin/hongbao">我的红包</a></li>
				<li><a href="${buyer_portal_domain}/view/weixin/expiring">我的通知</a></li>
				<li><a href="${buyer_portal_domain}/view/weixin/checkcpn">验券</a></li>
			</ul>
		</#escape>
	</body>
</html>
