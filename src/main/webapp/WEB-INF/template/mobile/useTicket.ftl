<!DOCTYPE html>
<html style="font-size: 36px;">

<#include "base.ftl">

<@htmlHead title="我的橙e券">
</@htmlHead>
<@htmlBody>
<#escape x as x?html>
	<div class="useTicket">
		<div class="bgF6 top">
			<div class="img">
				<img src="${picturePath}"/>
			</div>
			<div class="info">
				<p class="title">
				 ${couponName}
				</p>
				<p>商户：${orgName}</p>
				<p>有效日期：<span class="text-orange">${useSpan}</span></p>
			</div>
		</div>
		<div class="bgF6 content">
			<p>券号：<span>${couponSN}</span></p> 
			<div id="qrcode" class="erweima" style="padding: 20px 0px 10px;"></div>
		</div>
		<#if isShow?? >		
			<#if isShow=='Y' >
				<input type="button" name="delivery" value="我要快递" class="btn100" onclick="getOwnedAddress();"/> 
			</#if>
		</#if>
		
	</div>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery.qrcode.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/template.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>

	<script type="text/javascript">
		jQuery(document).ready(function($) {

			jQuery('#qrcode').qrcode({
				text: '${realCouponSN}',
				width: 280,
				height: 280
			});

			$('.back').click(function(event) {
				var url = '${buyer_weixin_domain}/view/weixin/detail?topicid=${topicId}&couponid=${couponId}';
				window.location.replace(url);
			});
		});
		
		function getOwnedAddress(){
			var url = '${buyer_weixin_domain}/view/weixin/logistOrderInfo?topicId=${topicId}&couponId=${couponId}&type=0&logistInfo=0';
			window.location.replace(url);
		}
		
		
	</script>
	</#escape>
</@htmlBody>

</html>