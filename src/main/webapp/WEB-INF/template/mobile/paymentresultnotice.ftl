<!DOCTYPE html>
<html>

<#include "base.ftl">

<@htmlHead title="订单确认">
</@htmlHead>

<@htmlBody>
<#escape x as x?html>		
		
		
		<div  style="margin-top: 10px; padding-top: 50px">
			
			<#if paystatus == "success">
				<img src="${buyer_portal_static_resources_domain}/img/icon_success.png">
				<p><font size="15px">恭喜您，已成功支付${order.price}元</font></p>
				<a href="${buyer_weixin_domain}/view/weixin/mycoupon" class="jump"><span id="seconds">10</span>秒后，进入我领的券</a>
			<#elseif paystatus=="unknow">
				 <p><font size="15px">您的订单未支付成功!</font><br>
					<font size="15px">请点击返回重新提交订单</font><br>
					<font size="15px">或关闭界面返回公众号查看系统通知</font><br>
				</p>
			     <!-- <a href="javascript:window.location.reload();"><font size="18px">刷新页面</font></a> -->
			 <#elseif paystatus=="failed">
			 	 <p><font size="15px">您的订单未支付成功!</font><br>
					<font size="15px">请点击返回重新提交订单</font><br>
					<font size="15px">或关闭界面返回公众号查看系统通知</font><br>
				</p>
			     <!-- <a href="${buyer_weixin_domain}/view/weixin/index"><span id="seconds">3</span>秒后自动跳转到首页</a> -->
			 </#if>
			
		
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
		         }, 300);
		</script>
		</#escape>
</@htmlBody>
</html>