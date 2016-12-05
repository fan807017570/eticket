<!DOCTYPE html>
<html>
<#include "userCenter-base.ftl">

<@htmlHead title="微信支付">
</@htmlHead>
	
<@htmlBody>
<#escape x as x?html>
	<section class="navAndbanner">
		<!--导航部分 开始-->
		<div class="nav">
			<ul class="width1000">
				<li>
					<a href="${buyer_portal_domain}/">橙e券首页</a> 
				</li>
				<!--<li class="active">
					<a href="${buyer_portal_domain}/view/web/ticket">我领的券</a>
				</li>
				<li>
					<a href="${buyer_portal_domain}/view/web/hongbao">我的红包</a>
				</li>
				<li>
					<a href="${buyer_portal_domain}/view/web/notice">我的通知</a>
				</li> -->
			</ul>
		</div>
		<!--导航部分 结束-->
	</section>
		
		<section class="payment width1000">
			 <div class="steps">
				<ul>
					<li class="active"><a href="#" class="circle">1</a><a href="#" class="text">提交订单</a></li>
					<li class="active"><a href="#" class="circle">2</a><a href="#" class="text">微信支付</a></li>
					<li><a href="#" class="circle">3</a><a href="#" class="text">购买成功</a></li>

				</ul>
			</div>
			
			<div class="stepTwo">
				 <div class="head">
				 	微信支付<span>请在30分钟内完成支付！如需发票请自提时索取！</span>
				 </div>
				 <div class="content">
				 	<div id="qrcode" class="img">
				 	<!-- <img src="img/weixinPayment.jpg" /> -->
				 		<img id="payqrcode" src="" />
				 	</div>
				 	<div class="info">
				 		<div class="tips">
				 			二维码有效期为两小时，请尽快支付
				 		</div>
				 		<div class="scan">
				 			请使用微信扫一扫扫描二维码支付
				 		</div>
				 	</div>
				 </div>
			</div> 
			 
		</section>
		
		<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery.qrcode.min.js" ></script>
		<script type="text/javascript">
			var interval;
			$(function(){
				createQRCode();
				interval = setInterval(queryOrder, "2000");
			});
			
			//生成二维码
			function createQRCode(){
				$("#payqrcode").attr("src","${buyer_portal_domain}/view/user/payqrcode.htm?content=${codeUrl}")
			}
			
			//轮询
			function queryOrder(){
				$.post("${buyer_portal_domain}/view/user/payment_result.htm",{orderid:${orderid}},
					function(data){
						var ret = $.parseJSON(data);
						if(ret.code == 2){//已支付
							clearInterval(interval);
							location.href = "${buyer_portal_domain}/view/web/payment_step3.htm";
						}else if(ret.code != 1){//支付失败或支付时间过期
							clearInterval(interval);
						}
				   	}
				);
			}
			
		</script>
		 
		</#escape>
</@htmlBody>
	
</html>
