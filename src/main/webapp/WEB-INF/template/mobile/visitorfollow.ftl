<!DOCTYPE html>
<html>

<#include "base.ftl">
<@htmlHead title="橙e券">
<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>
<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
</@htmlHead>
<@htmlBody>
<#escape x as x?html>
	<div class="attention">
		<div class="top">
			<header>领取成功</header>
			<p>券码已经给配给您的微信账户</p>
            <p>如需查询和使用请关注橙e券!</p>
			<img src="${buyer_portal_static_resources_domain}/img/circle_logo.png" class="logo"/>
		</div>
		<div class="content">
			<p>关注说明:</p>
			<p>1、打开微信公众号，搜索“橙e券”关注橙e券微信服务号。</p>
			<p>2、长按以下二维码“识别图中二维码”即可关注橙e券。</p>
			<img src="${buyer_portal_static_resources_domain}/img/erweima.jpg" class="erweima"/>
		</div> 
	</div>
	</#escape>
</@htmlBody>

</html>