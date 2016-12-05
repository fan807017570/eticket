<!DOCTYPE html>
<html style="height: 100%;">
	<head>
		<meta charset="utf-8" />
		<title>提货券提示</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-mobile-web-app-status-bar-style" content="black">
        <link rel="stylesheet" href="../../resources/css/style-vesion1.0.css" />
        <script src="../../resources/js/jquery-1.9.1.js"></script>
        <style>	
        	body{
        		width: 100%;
				height: 100%;
				background-color: #F26434; 
        	}
        	.btn100_new {
				display: block;
				height: 8.5rem;
				line-height: 8.5rem;
				-webkit-border-radius: 8.5rem;
				-moz-border-radius: 8.5rem;
				-ms-border-radius: 8.5rem;
				-o-border-radius: 8.5rem;
				border-radius: 8.5rem;
				width: 40%;
				background: #ff8c3c;
				border: none;
				font-size: 3.5rem;
				text-align: center;
				position: absolute;
				bottom: 2rem;
			}

        </style>
	</head>
	<body >
		<#escape x as x?html>
		<div style="display: inline-block;position: relative;height:100%;width:100%;background-color: #F26434; 
			background: url('../../resources/img/pickup_coupon_tips.jpg');background-size: cover;">
			
			<div class="btn100_new" style="color: #ffffff;left: 6%;" id="confirmPay">
				<a href="${buyer_weixin_domain}/view/weixin/toorderconfirm?topicid=${topicid}" style="color: #ffffff;" >确定买券</a>
			</div>
			<div class="btn100_new" style="background-color: #EEEEEE;right: 6%;">
				<a href="javascript:history.go(-1);" style="color: #959595;">我再看看</a>
			</div>
		</div>
		</#escape>
	</body>
</html>
