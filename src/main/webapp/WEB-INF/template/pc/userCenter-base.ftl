
<#macro htmlHead title>
<head>
	<meta charset="utf-8" />
	<title>${title}</title>
	<!--样式 css引入 -->
	<link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/pc/public.css" />
	<link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/pc/userCenter.css" />
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-1.9.1.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/public.js" ></script>
	<!--[if lt IE 9]>
      <script src="${buyer_portal_static_resources_domain}/lib/html5shiv.js"></script>
      <link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/pc/iehack.css" />
   	<![endif]--> 
</head>
</#macro>

<#macro htmlBody>
<body>
<#escape x as x?html>
<#include "header-sub.ftl">

	<#nested>

<#include "footer.ftl">

	</#escape>
</body>
</#macro>