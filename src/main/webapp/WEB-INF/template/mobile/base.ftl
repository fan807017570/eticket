
<#macro htmlHead title>
<head>
	<meta charset="utf-8" />
	<title>${title}</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/style-vesion1.0.css" />
    <!--图标文件样式引入-->
    <#nested>
</head>
</#macro>
	
<#macro htmlBody>
<body>
<#escape x as x?html>
	<#nested>
	<!-- 集成微信JSAPI的配置信息 -->
	<#if jsapiconfig??>
	<script src="${buyer_portal_static_resources_domain}/lib/jweixin-1.0.0.js"></script>
	<script>
	    wx.config(${jsapiconfig});
		wx.error(function(res){
		    console.log("error:"+res);
		});
		wx.ready(function(){
			console.log("weixin js api is ready!");
			try{
				doWxMethod();
			}catch(e){
				console.log("call weixin method error:"+e);
		  };
		});
	</script>
    </#if>
    </#escape>
</body>
</#macro>