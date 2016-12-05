<!DOCTYPE html>
<html>

<#include "base.ftl">

<@htmlHead title="订单确认">
</@htmlHead>

<@htmlBody>
<#escape x as x?html>
		<!-- <div class="paymentSuccess">
			 <img src="${buyer_portal_static_resources_domain}/img/success.png">
			 <#if paystatus == "success">
			 	<p>恭喜您，已成功支付${order.price}元！</p>
			 	<a href="${buyer_weixin_domain}/view/weixin/mycoupon"><span id="seconds">3</span>秒后，自动跳转到我领的券</a>
			 <#elseif paystatus=="unknow">
				 <p>支付过程还在处理中，请耐性等待！</p>
			     <a href="javascript:window.location.reload();">刷新页面</a>
			 <#elseif paystatus=="failed">
			 	 <p>支付超时或失败，请重新下单！</p>
			     <a href="${buyer_weixin_domain}/view/weixin/index"><span id="seconds">3</span>秒后自动跳转到首页</a>
			 </#if>
		</div> -->
		
		
		<div class="paySucPage">
			
			<#if paystatus == "success">
				<img src="${buyer_portal_static_resources_domain}/img/icon_success.png">
				<p>恭喜您，已成功支付${order.price}元</p>
				<a href="${buyer_weixin_domain}/view/weixin/mycoupon" class="jump"><span id="seconds">10</span>秒后，进入我领的券</a>
			<#elseif paystatus=="unknow">
				 <p>支付过程还在处理中，请耐性等待！</p>
			     <a href="javascript:window.location.reload();">刷新页面</a>
			 <#elseif paystatus=="failed">
			 	 <p>支付超时或失败，请重新下单！</p>
			     <a href="${buyer_weixin_domain}/view/weixin/index"><span id="seconds">10</span>秒后自动跳转到首页</a>
			 </#if>
			
			<div class="fixedBottom">
				<div class="left">
					<a href="${buyer_weixin_domain}/view/weixin/mycoupon">使用券</a>
				</div>
				<div class="right">
					<a href="${buyer_weixin_domain}/view/weixin/sendable">送好友</a>
				</div>
			</div>
		</div>
		
		<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script> 
		<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>
		<script type="text/javascript">
		         var i = 3;
		         var intervalObj = setInterval(function(){
		        	 if(i>=0){
		        		if(i==0){
		        			var url = $("#seconds").parent().attr("href");
		        			if(url!=null){
		        				window.location = url;
		        			}
		        		}else{
		        			i--;
		        		}
		        		$("#seconds").text(i);
		        	 }else{
		        		 clearInterval(intervalObj);
		        	 }
		         }, 1000);
		</script>
		</#escape>
</@htmlBody>
</html>